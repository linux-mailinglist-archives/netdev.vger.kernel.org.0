Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CEB5A1F45
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbiHZDJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiHZDJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CA4CD524
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B04CB61E6F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE3C433D7;
        Fri, 26 Aug 2022 03:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483380;
        bh=raLu5V+1pAu3hBtirSHVIy8xJN43qvOCg8bHGUV/ugM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIckqf3KGKR+TfJnO5otDi6vz86RSOHOV/QHv63stljLov+ghUIrinz5oF2JyE60N
         d+Bm0AG2gqKPQmRPxwBoASQfSKZk5BlXzIkB0tk6omLjptzj5OfKJPXlEEg6bl4S69
         dphCWkpU/LIa+sdFDot6jMcS7aIHKtlpJyZUBlGv7fUd+g7ryHNdm2F/TMLW5F/xmC
         aKitaHJ9D5cIV9QWDbZrIeLHCOIj4HQ84hziKeP4t184rh5JMMZVNJ5wsmaI0umA0D
         oWw+smsCo3WvKjXa7j5uxbbAJdFR///6lUTrqPTXAF5+HCs8RGds3VZzwLJ3u7GLu+
         uW7HZhvS5y/8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, fw@strlen.de
Subject: [PATCH net-next v3 3/6] netlink: add helpers for extack attr presence checking
Date:   Thu, 25 Aug 2022 20:09:32 -0700
Message-Id: <20220826030935.2165661-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
References: <20220826030935.2165661-1-kuba@kernel.org>
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

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
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
index 1619221c415c..d51e041d2242 100644
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

