Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63C343A48
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVHJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:21 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:54944 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhCVHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:51 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 7F3AE22565;
        Mon, 22 Mar 2021 00:08:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 7F3AE22565
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396930;
        bh=Tl9uPBwNlLnWyT8MBJI7lRh6N4TT+MmppDpsA1sG/TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6IKxalqhpRs6wIoefgmDBsaLBCtXmjZKKv/LqMISffdv1qd8v3KYZG94WlKrXHak
         mHEkqcm5PrrvAN58DhC25JpPMjL5LnE5QQCSADNSGjm+rOr+IvYy1ycz5R4r8vSzka
         xkphZPhDf8cYhhqf3YvRoYzcG4rKQ7LEuRZOQ17E=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 7/7] bnxt_en: Enhance retry of the first message to the firmware.
Date:   Mon, 22 Mar 2021 03:08:45 -0400
Message-Id: <1616396925-16596-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two enhancements:

1. Read the health status first before sending the first
HWRM_VER_GET message to firmware instead of the other way around.
This guarantees we got the accurate health status before we attempt
to send the message.

2. We currently only retry sending the first HWRM_VER_GET message to
the firmware if the firmware is in the process of booting.  If the
firmware is in error state and is doing core dump for example, the
driver should also retry if the health register has the RECOVERING
flag set.  This flag indicates the firmware will undergo recovery
soon.  Modify the retry logic to retry for this case as well.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6db5e927a473..6f13642121c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9530,9 +9530,10 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 
 		mutex_lock(&bp->hwrm_cmd_lock);
 		do {
-			rc = __bnxt_hwrm_ver_get(bp, true);
 			sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
-			if (!sts || !BNXT_FW_IS_BOOTING(sts))
+			rc = __bnxt_hwrm_ver_get(bp, true);
+			if (!sts || (!BNXT_FW_IS_BOOTING(sts) &&
+				     !BNXT_FW_IS_RECOVERING(sts)))
 				break;
 			retry++;
 		} while (rc == -EBUSY && retry < BNXT_FW_RETRY);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e77d60712954..29061c577baa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1564,6 +1564,7 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_STATUS_HEALTH_MSK	0xffff
 #define BNXT_FW_STATUS_HEALTHY		0x8000
 #define BNXT_FW_STATUS_SHUTDOWN		0x100000
+#define BNXT_FW_STATUS_RECOVERING	0x400000
 
 #define BNXT_FW_IS_HEALTHY(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) ==\
 					 BNXT_FW_STATUS_HEALTHY)
@@ -1574,6 +1575,9 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_IS_ERR(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) > \
 					 BNXT_FW_STATUS_HEALTHY)
 
+#define BNXT_FW_IS_RECOVERING(sts)	(BNXT_FW_IS_ERR(sts) &&		       \
+					 ((sts) & BNXT_FW_STATUS_RECOVERING))
+
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
 
-- 
2.18.1

