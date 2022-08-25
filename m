Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E545A0767
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiHYClk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHYClb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F95732D80
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACA9B61746
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DF3C433D7;
        Thu, 25 Aug 2022 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395288;
        bh=dVtZjn+PCWnMKDBVZ13eIotoJAm4U91qDnpew5SnU2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlmTwQqsUpH2d2o0h8Yp4kttXiaAYgyTIPkX0Trt1oKxhHwXFtnJAz0iQwlx4KebE
         +EaU5gGiIk1mlwrwNw5IA/Rby+Hq/witVlhbeBiDh0oseZF25FPy1amS8akp3s7F+H
         qioRRxTv+E9ZKBh7yCmBSsZ1qQZ8BzQ9Phu8JPSQopQX6bWPUBcAkjjFfzXoHTIuPj
         W/oMfsJXY7e5VnsX4bzIDUN3OYYbzlC8hqs88UR7h1O/FrK4xYE9NfMgIdZFtCAw3i
         jVD962Ia2tMidQOKaBiSeO4EnQD00KS8hasd9nKbqS4cp6Fk68XDi+ExXHznVT02Je
         a6E1XSEEhrI1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>, fw@strlen.de
Subject: [PATCH net-next v2 3/6] netlink: add helpers for extack attr presence checking
Date:   Wed, 24 Aug 2022 19:41:19 -0700
Message-Id: <20220825024122.1998968-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825024122.1998968-1-kuba@kernel.org>
References: <20220825024122.1998968-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Being able to check attribute presence and set extack
if not on one line is handy, add helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: squash old genetlink and netlink patches now that
    we don't need special handling of fixed headers (Johannes)
---
CC: fw@strlen.de
---
 include/linux/netlink.h | 11 +++++++++++
 include/net/genetlink.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 2e647157f383..f30b66996058 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -139,6 +139,17 @@ struct netlink_ext_ack {
 	}						\
 } while (0)
 
+#define NL_REQ_ATTR_CHECK(extack, nest, tb, type) ({		\
+	struct nlattr **__tb = (tb);				\
+	u32 __attr = (type);					\
+	int __retval;						\
+								\
+	__retval = !__tb[__attr];				\
+	if (__retval)						\
+		NL_SET_ERR_ATTR_MISS((extack), (nest), __attr);	\
+	__retval;						\
+})
+
 static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 					    u64 cookie)
 {
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 56a50e1c51b9..c41b20783ad0 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -107,6 +107,13 @@ static inline void genl_info_net_set(struct genl_info *info, struct net *net)
 
 #define GENL_SET_ERR_MSG(info, msg) NL_SET_ERR_MSG((info)->extack, msg)
 
+/* Report that a root attribute is missing */
+#define GENL_REQ_ATTR_CHECK(info, attr) ({				\
+	struct genl_info *__info = (info);				\
+									\
+	NL_REQ_ATTR_CHECK(__info->extack, NULL, __info->attrs, (attr)); \
+})
+
 enum genl_validate_flags {
 	GENL_DONT_VALIDATE_STRICT		= BIT(0),
 	GENL_DONT_VALIDATE_DUMP			= BIT(1),
-- 
2.37.2

