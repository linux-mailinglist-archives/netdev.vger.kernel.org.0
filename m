Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304706595BB
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiL3HcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiL3HcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:32:06 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A9B2BD9;
        Thu, 29 Dec 2022 23:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/eX4/CTCtjyiWC4V7OvOX6dzNZbFQNR2QZZFW5KPupw=; b=imvlYXXLQzkhx3C9WX7lII+acM
        ixTx1f6ndSof5qCXODx7uSKtLWVAarD7z6YBuQVrZv1DOGx3pKP3polA2qD6VwyZ6uixGTBZx/xhU
        jrd1yuzyJqQxUBqabRCr2U/9MvyZMcxmyh3NluE5k1hN/UlyZ0RXpBT5lA9p/uYtuoM8=;
Received: from p200300daa720fc00fd7bb9014adaf597.dip0.t-ipconnect.de ([2003:da:a720:fc00:fd7b:b901:4ada:f597] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pB9rn-00CcyM-UX; Fri, 30 Dec 2022 08:31:48 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 3/5] net: ethernet: mtk_eth_soc: fix flow_offload related refcount bug
Date:   Fri, 30 Dec 2022 08:31:43 +0100
Message-Id: <20221230073145.53386-3-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230073145.53386-1-nbd@nbd.name>
References: <20221230073145.53386-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we need to call
flow_block_cb_incref unconditionally, even for a newly allocated cb.
Fixes a use-after-free bug

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf..412d215b9571 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -554,6 +554,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 	struct mtk_eth *eth = mac->hw;
 	static LIST_HEAD(block_cb_list);
 	struct flow_block_cb *block_cb;
+	bool register_block = false;
 	flow_setup_cb_t *cb;
 
 	if (!eth->soc->offload_version)
@@ -568,16 +569,20 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_lookup(f->block, cb, dev);
-		if (block_cb) {
-			flow_block_cb_incref(block_cb);
-			return 0;
+		if (!block_cb) {
+			block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
+			if (IS_ERR(block_cb))
+				return PTR_ERR(block_cb);
+
+			register_block = true;
 		}
-		block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
-		if (IS_ERR(block_cb))
-			return PTR_ERR(block_cb);
 
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, &block_cb_list);
+		flow_block_cb_incref(block_cb);
+
+		if (register_block) {
+			flow_block_cb_add(block_cb, f);
+			list_add_tail(&block_cb->driver_list, &block_cb_list);
+		}
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f->block, cb, dev);
-- 
2.38.1

