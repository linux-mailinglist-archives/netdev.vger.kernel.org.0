Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E5659F2D6
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiHXEuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiHXEua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314DA804B9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA69761871
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88A6C43143;
        Wed, 24 Aug 2022 04:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661316629;
        bh=enkzfz2yOSSVbcusSEWfnmKzioF8qz12SaqEAGDGR7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRxrjpTcr/sc5vgQQhqoOHjUCLxvAR7CYiHRDXblYonUSlm2N12NJdn1ujPsh4U7f
         r8TvQpU9Mpek2Tg1ImxLkWGvv6bYsaqFrmuz70u0yfUkE+hDWw7jlRNBcJBMDHr6RY
         p0pPsgH68624roXF0yhjhbvGqSMxkWgP2j5msbQinnWUREPSPKLhwzxXr2k3H2y1uo
         jIn4TEInxDTiC033WPN0h6XP6tHrGnc0pp8euGXa2ra8kLUyNz9NgNL9VMz7OF7fU9
         DFuW5lTbifXxAyFfXN+6JcSc5zCFy9fbZ6Oes9aEKYAYfLNMksn0crfe5FcXWIi31T
         Mtq/AWEk/s8fA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] genetlink: add helper for checking required attrs and use it in devlink
Date:   Tue, 23 Aug 2022 21:50:21 -0700
Message-Id: <20220824045024.1107161-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220824045024.1107161-1-kuba@kernel.org>
References: <20220824045024.1107161-1-kuba@kernel.org>
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

Add a genetlink wrapper for checking if a required attribute
is present in the root nest. Because we want the offset to
point at the inner-most header we need to differentiate
between families which have userhdr and those which don't.
Only ovs, tipc and drbd access userhdr, and they all have
additional userhdr so it's safe to set userhdr to NULL
for families which depend purely on attributes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 14 ++++++++++++++
 net/netlink/genetlink.c |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 56a50e1c51b9..5da038e1b39e 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -107,6 +107,20 @@ static inline void genl_info_net_set(struct genl_info *info, struct net *net)
 
 #define GENL_SET_ERR_MSG(info, msg) NL_SET_ERR_MSG((info)->extack, msg)
 
+/* Report that a root attribute is missing */
+#define GENL_REQ_ATTR_CHECK(info, attr) ({				\
+	struct genl_info *__info = (info);				\
+	u32 __attr = (attr);						\
+	int __retval;							\
+									\
+	__retval = !__info->attrs[__attr];				\
+	if (__retval)							\
+		NL_SET_ERR_ATTR_MISS(__info->extack,			\
+				     __info->userhdr ? : __info->genlhdr, \
+				     __attr);				\
+	__retval;							\
+})
+
 enum genl_validate_flags {
 	GENL_DONT_VALIDATE_STRICT		= BIT(0),
 	GENL_DONT_VALIDATE_DUMP			= BIT(1),
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 57010927e20a..37805115e637 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -716,7 +716,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	info.snd_portid = NETLINK_CB(skb).portid;
 	info.nlhdr = nlh;
 	info.genlhdr = nlmsg_data(nlh);
-	info.userhdr = nlmsg_data(nlh) + GENL_HDRLEN;
+	info.userhdr = family->hdrsize ? nlmsg_data(nlh) + GENL_HDRLEN : NULL;
 	info.attrs = attrbuf;
 	info.extack = extack;
 	genl_info_net_set(&info, net);
-- 
2.37.2

