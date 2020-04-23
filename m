Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3321B5D85
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgDWOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:23 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59946 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgDWOVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:22 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NELH5H077840;
        Thu, 23 Apr 2020 09:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651677;
        bh=iv9QmrfUf+R9zgNjHtl/3SGXqaJSQlBgGn3Q0gmfZdE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=klmTfyA2gsQzOAcRcXmctVPJgEasRZQxp3eg7jv5uhIEfoYdQMJ4MmVvrJLms2dv4
         WYMuL6aalcdNqZb0/RRoFHLu37keDcpOEj8Vejrwa8vboVUDr78GeLqdFoOY0zQ1y+
         GMz4mp1dMCo10So6FJJDa4uCMb/ZPMFj4G8s3qwA=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELH1r054035;
        Thu, 23 Apr 2020 09:21:17 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:17 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:17 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELGvg002935;
        Thu, 23 Apr 2020 09:21:17 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 03/10] net: ethernet: ti: cpts: move tc mult update in cpts_fifo_read()
Date:   Thu, 23 Apr 2020 17:20:15 +0300
Message-ID: <20200423142022.10538-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 8 ++++++--
 drivers/net/ethernet/ti/cpts.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index f40a864d8c36..a2974b542bed 100644
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

