Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D551851D2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgCMWtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:49:51 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39860 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCMWtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:49:49 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnjKq029939;
        Fri, 13 Mar 2020 17:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584139785;
        bh=VDL4bQPEF3OLQcAhE+BrvsJYUbu3alZiaqyJxwQK41U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tCcQwuammv4QPSb0fDQVBovpAvYCjYjdxJ3DRixvZNASjsqHaM5yJmhdnzK+zcLPA
         EZ9F3fcnuMG/LwQhUf9Ie+61kqqmWrBow1HpsCKYuri3e2UdITTSt4VH5e76gP6BCy
         epYYpf+fAKNaPrH6q13HAzKfdBt2i3KXxWKWr1OE=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnjBe048539;
        Fri, 13 Mar 2020 17:49:45 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 17:49:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 17:49:45 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnhOa034818;
        Fri, 13 Mar 2020 17:49:44 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 03/11] net: ethernet: ti: cpts: move tc mult update in cpts_fifo_read()
Date:   Sat, 14 Mar 2020 00:49:06 +0200
Message-ID: <20200313224914.5997-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313224914.5997-1-grygorii.strashko@ti.com>
References: <20200313224914.5997-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now CPTS driver .adjfreq() generates request to read CPTS current time
(CPTS_EV_PUSH) with intention to process all pending event using previous
frequency adjustment values before switching to the new ones. So
CPTS_EV_PUSH works as a marker to switch to the new frequency adjustment
values. Current code assumes that all job is done in .adjfreq(), but after
enabling IRQ this will not be true any more.

Hence save new frequency adjustment values (mult) and perform actual freq
adjustment in cpts_fifo_read() immediately after CPTS_EV_PUSH is received.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 8 ++++++--
 drivers/net/ethernet/ti/cpts.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 6a1844cd23ff..e6a8ccae711c 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -165,6 +165,10 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		case CPTS_EV_PUSH:
 			WRITE_ONCE(cpts->cur_timestamp, lo);
 			timecounter_read(&cpts->tc);
+			if (cpts->mult_new) {
+				cpts->cc.mult = cpts->mult_new;
+				cpts->mult_new = 0;
+			}
 			break;
 		case CPTS_EV_TX:
 			if (cpts_match_tx_ts(cpts, event)) {
@@ -228,9 +232,9 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 	spin_lock_irqsave(&cpts->lock, flags);
 
-	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
+	cpts->mult_new = neg_adj ? mult - diff : mult + diff;
 
-	cpts->cc.mult = neg_adj ? mult - diff : mult + diff;
+	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
 
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 32ecd1ce4d3b..421630049ee7 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -116,6 +116,7 @@ struct cpts {
 	unsigned long ov_check_period;
 	struct sk_buff_head txq;
 	u64 cur_timestamp;
+	u32 mult_new;
 };
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
-- 
2.17.1

