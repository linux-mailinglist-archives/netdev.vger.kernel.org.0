Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794503949B9
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhE2AzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:07 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39896 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhE2AzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:02 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 7C495E9;
        Fri, 28 May 2021 17:53:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 7C495E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249606;
        bh=LittCoeFaTxDo64I8Nomrhue/KeaLeHLISJW4thTbIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNdSXMU8Rjg6WxMszIr3nXwEAJbhlGqzbaH3Zd9gzSqWh5vQ32XbVgYXaELyipCOV
         y6TGL4o6OSnCuxFLMCfeRUcDjR7HbYurDfR3Rj4n+az7n6Af9tdIkqqDBlannBzcn0
         HPmt6x3m7OOMA3rjl7XILqI8J3T5aJsvsqOsR3QI=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 4/7] bnxt_en: Get the full 48-bit hardware timestamp periodically.
Date:   Fri, 28 May 2021 20:53:18 -0400
Message-Id: <1622249601-7106-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

From the bnxt_timer(), read the 48-bit hardware running clock
periodically and store it in ptp->current_time.  The previous snapshot
of the clock will be stored in ptp->old_time.  The old_time snapshot
will be used in the next patches to compute the RX packet timestamps.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  9 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 29 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  2 ++
 4 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e89207413155..2b24d927fd07 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10064,6 +10064,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		}
 	}
 
+	bnxt_ptp_start(bp);
 	rc = bnxt_init_nic(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
@@ -11154,6 +11155,11 @@ static void bnxt_timer(struct timer_list *t)
 		bnxt_queue_sp_work(bp);
 	}
 
+	if (bp->ptp_cfg && (bp->flags & BNXT_FLAG_CHIP_P5)) {
+		set_bit(BNXT_PTP_CURRENT_TIME_EVENT, &bp->sp_event);
+		bnxt_queue_sp_work(bp);
+	}
+
 #ifdef CONFIG_RFS_ACCEL
 	if ((bp->flags & BNXT_FLAG_RFS) && bp->ntp_fltr_count) {
 		set_bit(BNXT_RX_NTP_FLTR_SP_EVENT, &bp->sp_event);
@@ -11558,6 +11564,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RING_COAL_NOW_SP_EVENT, &bp->sp_event))
 		bnxt_chk_missed_irq(bp);
 
+	if (test_and_clear_bit(BNXT_PTP_CURRENT_TIME_EVENT, &bp->sp_event))
+		bnxt_ptp_get_current_time(bp);
+
 	if (test_and_clear_bit(BNXT_FW_ECHO_REQUEST_SP_EVENT, &bp->sp_event))
 		bnxt_fw_echo_reply(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 65deefcb04f8..cf10cfff5c1b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1957,6 +1957,7 @@ struct bnxt {
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
 #define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
+#define BNXT_PTP_CURRENT_TIME_EVENT	22
 #define BNXT_FW_ECHO_REQUEST_SP_EVENT	23
 
 	struct delayed_work	fw_reset_task;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 53fe98245b89..bdf79850fc2d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -55,6 +55,17 @@ static int bnxt_hwrm_port_ts_query(struct bnxt *bp, u32 flags, u64 *ts,
 	return rc;
 }
 
+int bnxt_ptp_get_current_time(struct bnxt *bp)
+{
+	u32 flags = PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME;
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (!ptp)
+		return 0;
+	ptp->old_time = ptp->current_time;
+	return bnxt_hwrm_port_ts_query(bp, flags, &ptp->current_time, NULL);
+}
+
 static int bnxt_ptp_gettimex(struct ptp_clock_info *ptp_info,
 			     struct timespec64 *ts,
 			     struct ptp_system_timestamp *sts)
@@ -236,6 +247,24 @@ static u64 bnxt_cc_read(const struct cyclecounter *cc)
 	return ns;
 }
 
+int bnxt_ptp_start(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	int rc = 0;
+
+	if (!ptp)
+		return 0;
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		u32 flags = PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME;
+
+		rc = bnxt_hwrm_port_ts_query(bp, flags, &ptp->current_time,
+					     NULL);
+		ptp->old_time = ptp->current_time;
+	}
+	return rc;
+}
+
 static const struct ptp_clock_info bnxt_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "bnxt clock",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 54b368d49fa8..7ea58a26720d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -50,8 +50,10 @@ struct bnxt_ptp_cfg {
 	int			rx_filter;
 };
 
+int bnxt_ptp_get_current_time(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.18.1

