Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EC65CC48
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbjADERE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238350AbjADEQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093C4167FA;
        Tue,  3 Jan 2023 20:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0243BCE13CA;
        Wed,  4 Jan 2023 04:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527FFC43396;
        Wed,  4 Jan 2023 04:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805806;
        bh=NvFAR7JaCaB5BMuJNxI50Iet3gkxHTJmRdr/P0f2tLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPXxSOXAjQiYGz8QA2K+tT6JKpnv0EIBAJVJziGf1elXzS6T1PPxA3wCHeDRjXTha
         Q2Ls4/Vz/nC5kZyj1/7FecWm644kz3G5c4ry45pbndhtyUSYRHtSaNtRO8sr/vR2sO
         fAo4xwxC/zUyc5YLRcidNtNPaAyspB2bYvGK+Wauy/arJSO7Ty1pF/6n+eVb4+6I5g
         aR/SQg6EqopxymYbDGLSW1G8ktBLb4C18IS3WD2HdtSOegrHsSppu5HFKsxG8JSCj0
         Bfa05tIfJEASfx51Rn12ATVlS2tTn3RCqkWaMDgh7b53qPbHbWMjd5THY6kbcN6pyG
         IcEbAaOgLbi4g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH net-next 04/14] netlink: add macro for checking dump ctx size
Date:   Tue,  3 Jan 2023 20:16:26 -0800
Message-Id: <20230104041636.226398-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

