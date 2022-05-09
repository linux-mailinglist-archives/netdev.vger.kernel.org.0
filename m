Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B568E51FCB6
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiEIMaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiEIMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:30:19 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9822AC47;
        Mon,  9 May 2022 05:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BQrHcg0SdKByu+hHVqPndSb+ErQKSZycgLyclzck4Rk=; b=SaBvqIvd6hbKJ2cWNmGsYBcLbi
        FTcca3T6oOouIKmyhqlC60X9b+PdQW0gvEYWHwS5J/XqjZ68DdHwaH3EtA1DYhQVD1JQAZT6gh7zz
        YWGneEqMztTHKbHdSXW37JdUz/Tu/wMgd8UlyWzo0+ur3voSH4MaR0vf1U0nZuSnE/tg=;
Received: from p200300daa70ef2003c9b1ea8f6ef4a42.dip0.t-ipconnect.de ([2003:da:a70e:f200:3c9b:1ea8:f6ef:4a42] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1no2T0-0003Fl-Nl; Mon, 09 May 2022 14:26:22 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf 3/4] net: fix dev_fill_forward_path with pppoe + bridge
Date:   Mon,  9 May 2022 14:26:15 +0200
Message-Id: <20220509122616.65449-3-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509122616.65449-1-nbd@nbd.name>
References: <20220509122616.65449-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling dev_fill_forward_path on a pppoe device, the provided destination
address is invalid. In order for the bridge fdb lookup to succeed, the pppoe
code needs to update ctx->daddr to the correct value.
Fix this by storing the address inside struct net_device_path_ctx

Fixes: f6efc675c9dd ("net: ppp: resolve forwarding path for bridge pppoe devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
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
2.35.1

