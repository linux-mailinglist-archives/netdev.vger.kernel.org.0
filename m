Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75E647DCD0
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbhLWBOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:18 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18294 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345738AbhLWBOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=8dwPvDwhfyU5dMZPpdOsVTnb3/1u+mRXqp7YaVTNdGU=;
        b=R3yiLGLs1uZQGXBA5TY6+EOguEXdgO+NFMS9YERcdysDiQ74J09QGW0gtwwaBTwIb3lP
        14/s3VZ0MrU9V1Esh6nxwkFlnkeAu3oeTqnb0+GCprOZ2Df8Hl+HIRdfh93KlGnbickV4r
        1rZLqvK+Ryd+uNTMUH0qyT4sXyAUeny5SIYKZWoBM3zVFvoDr62sOI5L3QZ6OSDyNDTNii
        +jSXr56RBOU3/8NPVBHcv6KWTgdql3C6HQ5pKMM1C2a9ZhBW0ayYJ4xgu3ka1nT/lNMthz
        wryFmVZf8EqOks5TDp/IJXqehiHzMHQEUeON2RlHmpY5/db5fYfDIguaWdaah8tw==
Received: by filterdrecv-656998cfdd-mht2v with SMTP id filterdrecv-656998cfdd-mht2v-1-61C3CD5E-18
        2021-12-23 01:14:06.608787935 +0000 UTC m=+7955208.093419968
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id vPbHODG4Sse8dQwPEkefYg
        Thu, 23 Dec 2021 01:14:06.453 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 443A8701397; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 20/50] wilc1000: eliminate "max_size_over" variable in
 fill_vmm_table
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-21-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBovVGGUqsKDfRdCL?=
 =?us-ascii?Q?g1PJA3t8foKn9E0eDBioSfxjXTPS=2FqEtvMwuU7e?=
 =?us-ascii?Q?ykaxv403jcXR8Nu5mfoqIItxiNmkjMXnZnPTYXp?=
 =?us-ascii?Q?iWMaZfcfl=2F5jMv=2FuTliEqOcuAyIR29pxVsz3nks?=
 =?us-ascii?Q?s6F8hCjxydBjRzAKh91N8KgPQwxCJ8jvOKzKsT?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code tighter and easier to understand.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index a6064a85140b4..dc6608390591c 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -638,7 +638,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 	u32 sum;
 	u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 *num_pkts_to_add;
-	bool max_size_over = 0, ac_exist = 0;
+	bool ac_exist = 0;
 	int vmm_sz = 0;
 	struct sk_buff *tqe_q[NQUEUES];
 	struct wilc_skb_tx_cb *tx_cb;
@@ -648,20 +648,17 @@ static int fill_vmm_table(const struct wilc *wilc,
 
 	i = 0;
 	sum = 0;
-	max_size_over = 0;
 	num_pkts_to_add = ac_desired_ratio;
 	do {
 		ac_exist = 0;
-		for (ac = 0; (ac < NQUEUES) && (!max_size_over); ac++) {
+		for (ac = 0; ac < NQUEUES; ac++) {
 			if (!tqe_q[ac])
 				continue;
 
 			ac_exist = 1;
-			for (k = 0; (k < num_pkts_to_add[ac]) &&
-			     (!max_size_over) && tqe_q[ac]; k++) {
+			for (k = 0; (k < num_pkts_to_add[ac]) && tqe_q[ac]; k++) {
 				if (i >= (WILC_VMM_TBL_SIZE - 1)) {
-					max_size_over = 1;
-					break;
+					goto out;
 				}
 
 				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
@@ -676,8 +673,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 				vmm_sz = ALIGN(vmm_sz, 4);
 
 				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
-					max_size_over = 1;
-					break;
+					goto out;
 				}
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
@@ -693,8 +689,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
-	} while (!max_size_over && ac_exist);
-
+	} while (ac_exist);
+out:
 	vmm_table[i] = 0x0;
 	return i;
 }
-- 
2.25.1

