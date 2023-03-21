Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4D6C3308
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCUNhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUNhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:37:22 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E7742BC7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MDRovu1TOsLuVee4reqOHGepgajwEfElAryYO+Uiw3U=; b=TfCxQQXquHzo1TTNTr4f/NmMJe
        7SPdF/Rw+6sOca/sltVeATZ2mIRjWdNB6/bgsCb5lsygiZL2WmtrfEIPVtUdNH23KBXFAESNtKkDj
        JnKtZNOvEuq4SWTCj8wY2IAkZ+Cn2V6PSKt5iFvVybS/oNXwPUPssPwXtnP5lnk2QIP8=;
Received: from [217.114.218.22] (helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pecAx-005Lkw-ON
        for netdev@vger.kernel.org; Tue, 21 Mar 2023 14:37:19 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block refcounting
Date:   Tue, 21 Mar 2023 14:37:18 +0100
Message-Id: <20230321133719.49652-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we need to call
flow_block_cb_incref unconditionally, even for a newly allocated cb.
Fixes a use-after-free bug. Also fix the accidentally inverted refcount
check on unbind.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 23 +++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf..43cc510b51bd 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -554,6 +554,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 	struct mtk_eth *eth = mac->hw;
 	static LIST_HEAD(block_cb_list);
 	struct flow_block_cb *block_cb;
+	bool register_block = false;
 	flow_setup_cb_t *cb;
 
 	if (!eth->soc->offload_version)
@@ -568,23 +569,27 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
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
 		if (!block_cb)
 			return -ENOENT;
 
-		if (flow_block_cb_decref(block_cb)) {
+		if (!flow_block_cb_decref(block_cb)) {
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 		}
-- 
2.39.0

