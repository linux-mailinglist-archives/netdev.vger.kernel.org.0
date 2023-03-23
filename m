Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B06C6922
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCWNIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 09:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCWNIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:08:34 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8587CA5C8
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=06qBwxrcWGNBmhT6zzZqmbL6cZUA9sD/TZdf6v4fZAE=; b=hf0B3cpoQik24Qz/wch+Ji94fy
        yVO2TGIcFbimDrEOR8WL0XM/qEiyvLJ4DBMCOwNg9Aa2BQJuAQrEg6O6o6oML1Nifrcs7g3l+2/pt
        6qeqjHnydw8AjJONsWKM9psh9a5ceKc4OdSpTsdbu91WAIafoeRQ1IH+6yEwygLKqkj8=;
Received: from [217.114.218.29] (helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfKfw-0062oc-F2
        for netdev@vger.kernel.org; Thu, 23 Mar 2023 14:08:16 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH v2 1/3] net: ethernet: mtk_eth_soc: fix flow block refcounting logic
Date:   Thu, 23 Mar 2023 14:08:13 +0100
Message-Id: <20230323130815.7753-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
call flow_block_cb_incref for a newly allocated cb.
Also fix the accidentally inverted refcount check on unbind.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: fix description, simplify refcounting change

 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf..161751bb36c9 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -576,6 +576,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
+		flow_block_cb_incref(block_cb);
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &block_cb_list);
 		return 0;
@@ -584,7 +585,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (!block_cb)
 			return -ENOENT;
 
-		if (flow_block_cb_decref(block_cb)) {
+		if (!flow_block_cb_decref(block_cb)) {
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 		}
-- 
2.39.0

