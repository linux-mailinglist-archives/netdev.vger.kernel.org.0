Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517665A076B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiHYClr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiHYClh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:41:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B89C8F1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64D8BB826C8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0791C433B5;
        Thu, 25 Aug 2022 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395287;
        bh=A88pz8Xg7pwRiNUh1brRJFDY1X++48g8K2vqfjNcoLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLWsR3xc7zameEmx4HzcsDES4EFd/BUMl+oWbdzQZliWIQQZscV14effp+sXCc7GL
         xev4Jm1PRF+hw2WbcZ1NuiA9LPASCj2T/AvDGLp/ka0kByU2LxO82+2v5wvJnKXrXa
         zbGGskRR3fLC1goMNxOZnqPuHzfCkNkO/DQgOko2f5UsZfQOFupHNd55RO6nnoEkxa
         VutvwpYRGIcpxddXq8KUs31PhKIfD9iv5ATqrtys/9NhbIqYZ6kueCcNKsepE4Vlj0
         OgOF053aCHGtcJyusfN0ciKfRvoC3LjFUw5khpx5dW9tCUBCsKgP/wb2URFB2hORjR
         X2JR5UrkiYe4Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>, fw@strlen.de
Subject: [PATCH net-next v2 1/6] netlink: factor out extack composition
Date:   Wed, 24 Aug 2022 19:41:17 -0700
Message-Id: <20220825024122.1998968-2-kuba@kernel.org>
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

The ext_ack writing code looks very "organically grown".
Move the calculation of the size and writing out to helpers.
This is more idiomatic and gives us the ability to return early
avoiding the long (and randomly ordered) "if" conditions.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: new patch
---
CC: fw@strlen.de
---
 net/netlink/af_netlink.c | 85 ++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 30 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..9bcbe491c798 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2400,6 +2400,57 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(__netlink_dump_start);
 
+static size_t
+netlink_ack_tlv_len(struct netlink_sock *nlk, int err,
+		    const struct netlink_ext_ack *extack)
+{
+	size_t tlvlen;
+
+	if (!extack || !(nlk->flags & NETLINK_F_EXT_ACK))
+		return 0;
+
+	tlvlen = 0;
+	if (extack->_msg)
+		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
+	if (extack->cookie_len)
+		tlvlen += nla_total_size(extack->cookie_len);
+
+	/* Following attributes are only reported as error (not warning) */
+	if (!err)
+		return tlvlen;
+
+	if (extack->bad_attr)
+		tlvlen += nla_total_size(sizeof(u32));
+	if (extack->policy)
+		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
+
+	return tlvlen;
+}
+
+static void
+netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
+		     struct nlmsghdr *nlh,  int err,
+		     const struct netlink_ext_ack *extack)
+{
+	if (extack->_msg)
+		WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg));
+	if (extack->cookie_len)
+		WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
+				extack->cookie_len, extack->cookie));
+
+	if (!err)
+		return;
+
+	if (extack->bad_attr &&
+	    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
+		     (u8 *)extack->bad_attr >= in_skb->data + in_skb->len))
+		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
+				    (u8 *)extack->bad_attr - (u8 *)nlh));
+	if (extack->policy)
+		netlink_policy_dump_write_attr(skb, extack->policy,
+					       NLMSGERR_ATTR_POLICY);
+}
+
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		 const struct netlink_ext_ack *extack)
 {
@@ -2407,29 +2458,20 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	struct nlmsghdr *rep;
 	struct nlmsgerr *errmsg;
 	size_t payload = sizeof(*errmsg);
-	size_t tlvlen = 0;
 	struct netlink_sock *nlk = nlk_sk(NETLINK_CB(in_skb).sk);
 	unsigned int flags = 0;
-	bool nlk_has_extack = nlk->flags & NETLINK_F_EXT_ACK;
+	size_t tlvlen;
 
 	/* Error messages get the original request appened, unless the user
 	 * requests to cap the error message, and get extra error data if
 	 * requested.
 	 */
-	if (nlk_has_extack && extack && extack->_msg)
-		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
-
 	if (err && !(nlk->flags & NETLINK_F_CAP_ACK))
 		payload += nlmsg_len(nlh);
 	else
 		flags |= NLM_F_CAPPED;
-	if (err && nlk_has_extack && extack && extack->bad_attr)
-		tlvlen += nla_total_size(sizeof(u32));
-	if (nlk_has_extack && extack && extack->cookie_len)
-		tlvlen += nla_total_size(extack->cookie_len);
-	if (err && nlk_has_extack && extack && extack->policy)
-		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
 
+	tlvlen = netlink_ack_tlv_len(nlk, err, extack);
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
 
@@ -2446,25 +2488,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	errmsg->error = err;
 	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
 
-	if (nlk_has_extack && extack) {
-		if (extack->_msg) {
-			WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
-					       extack->_msg));
-		}
-		if (err && extack->bad_attr &&
-		    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
-			     (u8 *)extack->bad_attr >= in_skb->data +
-						       in_skb->len))
-			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
-					    (u8 *)extack->bad_attr -
-					    (u8 *)nlh));
-		if (extack->cookie_len)
-			WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
-					extack->cookie_len, extack->cookie));
-		if (extack->policy)
-			netlink_policy_dump_write_attr(skb, extack->policy,
-						       NLMSGERR_ATTR_POLICY);
-	}
+	if (tlvlen)
+		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
 
 	nlmsg_end(skb, rep);
 
-- 
2.37.2

