Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D198063C8BB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiK2Trg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiK2TrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:47:08 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 620631276A;
        Tue, 29 Nov 2022 11:44:16 -0800 (PST)
Received: from localhost.biz (unknown [10.81.81.211])
        by gw.red-soft.ru (Postfix) with ESMTPA id BE80F3E2A78;
        Tue, 29 Nov 2022 22:44:13 +0300 (MSK)
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH v2] net: dsa: Check return value from skb_trim_rcsum()
Date:   Tue, 29 Nov 2022 22:43:09 +0300
Message-Id: <20221129194309.3428340-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.30.3
In-Reply-To: <20221129165531.wgeyxgo5el2x43mj@skbuf>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173833 [Nov 29 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, red-soft.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;localhost.biz:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/11/29 17:49:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/11/29 16:49:00 #20624738
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return NULL if we got unexpected value from skb_trim_rcsum()

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
Fixes: 4913b8ebf8a9 ("net: dsa: add support for the SJA1110 native tagging protocol")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
V1->V2 Fixes for tag_hellcreek.c and tag_sja1105.c

 net/dsa/tag_hellcreek.c | 3 ++-
 net/dsa/tag_ksz.c       | 3 ++-
 net/dsa/tag_sja1105.c   | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..53a206d11685 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -49,7 +49,8 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+	if (pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..429250298ac4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 83e4136516b0..1a85125bda6d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -665,7 +665,8 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 		 * padding and trailer we need to account for the fact that
 		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
 		 */
-		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+		if (pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN))
+			return NULL;
 	/* Trap-to-host frame, no timestamp trailer */
 	} else {
 		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
-- 
2.30.3

