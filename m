Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6865E459
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjAEEFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjAEEFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D90537250
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C504261802
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4837FC43398;
        Thu,  5 Jan 2023 04:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891540;
        bh=kypzoOHbkojBB+13tb5pyk4qlMHyTe8CQUa1tZB0gkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4jcSE/tk11uakDtj+HXVAg5qzS8TsfwmRO1tx6XXTLgN4u5CMwuyYNo8I54X9BFF
         22p9SDMfkS4Ncw7R+tZc96jeYepqkkSjUaLhluu7ffnYCrhQTCiFxHYOoMKA2CHZ/s
         ldBbr7P6xekZbTyXE8e8HtsuDTlFuawOQNF69WTzHJvx18/VHxSCx3SuOOsSamLMsC
         Ce9gN246671Uk2POI1bq3EMT62UpjEZ29VQZuyGYh/4+EBTRKP1D+7sJnM6qMBmt6c
         GKOt68Lx4FwPXprbjVpV2fK5rAEYRfqHtw1tFdfij3Fw0yDRj46jchwsIO/stkEhpj
         EmTV5rb4nd/Og==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 05/15] netlink: add macro for checking dump ctx size
Date:   Wed,  4 Jan 2023 20:05:21 -0800
Message-Id: <20230105040531.353563-6-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
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

