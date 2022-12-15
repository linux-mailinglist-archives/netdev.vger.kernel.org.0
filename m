Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E25664D530
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiLOCCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLOCCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF4F2ED5E;
        Wed, 14 Dec 2022 18:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28B5E61CE5;
        Thu, 15 Dec 2022 02:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66BEC433EF;
        Thu, 15 Dec 2022 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069725;
        bh=5wIJyUE2h46AaDrI7YOVEtNZr4I0U12viyqrqK8D7nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuLlG1Y3eR6+90le0R+7lHHFjmWe/I0UckdGZGs553u43aBnyMymKUphlDaISDiUn
         7PphYDIodnpMSIWiPoZ1BJhTutGjvbvVaxbeMO3b+oR/vUyiB2ei23FiIvky6ZeLZn
         r3iE+RuwXwhdoZ7FU40dtJ2G/nKVCIPboKb098unFh9T0v7KKntrEeSbZ+so3IWvHm
         3XmoLatEaV2MODYxktlL07i8+sRaxDFDpor6ZiB2FBv3GDGAfwLGwF+BXavTKZueYW
         H73wXDLHQYOgMvIXOhCtmHkvSnWcXHrNFrb5QqSquLmNlG9ms5jlCtc8e8TfsGkWpO
         /j3tWKwtl+HnQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [RFC net-next 05/15] netlink: add macro for checking dump ctx size
Date:   Wed, 14 Dec 2022 18:01:45 -0800
Message-Id: <20221215020155.1619839-6-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encourage casting struct netlink_callback::ctx to a local
struct (in a comment above the field). Provide a convenience
macro for checking if the local struct fits into the ctx.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pablo@netfilter.org
CC: kadlec@netfilter.org
CC: fw@strlen.de
CC: johannes@sipsolutions.net
CC: ecree.xilinx@gmail.com
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org
---
 include/linux/netlink.h              | 4 ++++
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index d81bde5a5844..38f6334f408c 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -263,6 +263,10 @@ struct netlink_callback {
 	};
 };
 
+#define NL_ASSET_DUMP_CTX_FITS(type_name)				\
+	BUILD_BUG_ON(sizeof(type_name) >				\
+		     sizeof_field(struct netlink_callback, ctx))
+
 struct netlink_notify {
 	struct net *net;
 	u32 portid;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1286ae7d4609..90672e293e57 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3866,7 +3866,7 @@ static int __init ctnetlink_init(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(sizeof(struct ctnetlink_list_dump_ctx) > sizeof_field(struct netlink_callback, ctx));
+	NL_ASSET_DUMP_CTX_FITS(struct ctnetlink_list_dump_ctx);
 
 	ret = nfnetlink_subsys_register(&ctnl_subsys);
 	if (ret < 0) {
-- 
2.38.1

