Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC7F635946
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiKWKJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiKWKIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:08:46 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5862D5E9D2;
        Wed, 23 Nov 2022 01:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/eX4/CTCtjyiWC4V7OvOX6dzNZbFQNR2QZZFW5KPupw=; b=Wb7gqAByhlP9lJAokk3U4HXZvf
        JpCNn6xzFJgoUbEzxz7fkKuSA6cRyCHwDsvj2aS7e+gZwU96Fls3DqOjH6vqG1E/vjfeyQa9vI848
        PdftqAdxza637CWdWdZFm8+skDRGRekev5MfNbleUXaG//cOThYgYLTPqyCk2GNF+Hz4=;
Received: from p200300daa7225c0894d890dd9e4669b3.dip0.t-ipconnect.de ([2003:da:a722:5c08:94d8:90dd:9e46:69b3] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oxmVx-003vzk-HX; Wed, 23 Nov 2022 10:57:57 +0100
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
Subject: [PATCH 4/5] net: ethernet: mtk_eth_soc: fix flow_offload related refcount bug
Date:   Wed, 23 Nov 2022 10:57:53 +0100
Message-Id: <20221123095754.36821-4-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123095754.36821-1-nbd@nbd.name>
References: <20221123095754.36821-1-nbd@nbd.name>
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

