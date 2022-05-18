Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6719252C5B4
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiERVlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiERVjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:39:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5730D24988C;
        Wed, 18 May 2022 14:38:48 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 3/7] net: fix dev_fill_forward_path with pppoe + bridge
Date:   Wed, 18 May 2022 23:38:37 +0200
Message-Id: <20220518213841.359653-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518213841.359653-1-pablo@netfilter.org>
References: <20220518213841.359653-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

When calling dev_fill_forward_path on a pppoe device, the provided destination
address is invalid. In order for the bridge fdb lookup to succeed, the pppoe
code needs to update ctx->daddr to the correct value.
Fix this by storing the address inside struct net_device_path_ctx

Fixes: f6efc675c9dd ("net: ppp: resolve forwarding path for bridge pppoe devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ppp/pppoe.c   | 1 +
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 3619520340b7..e172743948ed 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -988,6 +988,7 @@ static int pppoe_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.proto = htons(ETH_P_PPP_SES);
 	path->encap.id = be16_to_cpu(po->num);
 	memcpy(path->encap.h_dest, po->pppoe_pa.remote, ETH_ALEN);
+	memcpy(ctx->daddr, po->pppoe_pa.remote, ETH_ALEN);
 	path->dev = ctx->dev;
 	ctx->dev = dev;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b1fbe21650bb..f736c020cde2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -900,7 +900,7 @@ struct net_device_path_stack {
 
 struct net_device_path_ctx {
 	const struct net_device *dev;
-	const u8		*daddr;
+	u8			daddr[ETH_ALEN];
 
 	int			num_vlans;
 	struct {
diff --git a/net/core/dev.c b/net/core/dev.c
index 1461c2d9dec8..2771fd22dc6a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -681,11 +681,11 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 	const struct net_device *last_dev;
 	struct net_device_path_ctx ctx = {
 		.dev	= dev,
-		.daddr	= daddr,
 	};
 	struct net_device_path *path;
 	int ret = 0;
 
+	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
 	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
 		last_dev = ctx.dev;
-- 
2.30.2

