Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46F55F4D0A
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJEA2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJEA2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4235D6F546;
        Tue,  4 Oct 2022 17:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D715161564;
        Wed,  5 Oct 2022 00:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C40DC433C1;
        Wed,  5 Oct 2022 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664929697;
        bh=QVz1s/SM7EbgUnldga0aFwxWP1PoO1RoKscYnGphzEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5XUKR5VvizsuhvwSbaGkMHH1lt/yp27lNuaA2M/NFd3X/OHWYP4AChMHCF/L41Jj
         V6N3ap9+iLqIP5qD75J0grhPflzhjO7EuJUGdqG6X/5DW5J2F4Vtt7QFAswCFKNjvj
         MldeE1aILrjRQv6/K0tbkttQTwIA1BLVDb6jHnAsrVPuqgggkBADG/UnX9PlE2M3Nt
         icSXeYOZ++wPSlnqDGh8Hp91U63K5zEi148B06xfwDRX8Dzj7jXCLu36bT13oYgL8+
         otYPHpXZZQ4+ImGwXKigLC7zn8oY8aaHTUowOvR1x/sY6fj4dRoKFXfbfvsNV4moB8
         A4VuwJcJpcJbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, linux-hardening@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC] netlink: split up copies in the ack construction
Date:   Tue,  4 Oct 2022 17:28:14 -0700
Message-Id: <20221005002814.2233715-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <202210041600.7C90DF917@keescook>
References: <202210041600.7C90DF917@keescook>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/netlink.h        | 21 +++++++++++++++++++++
 include/uapi/linux/netlink.h |  2 ++
 net/netlink/af_netlink.c     | 30 +++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..46c40fabd2b5 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -931,6 +931,27 @@ static inline struct nlmsghdr *nlmsg_put(struct sk_buff *skb, u32 portid, u32 se
 	return __nlmsg_put(skb, portid, seq, type, payload, flags);
 }
 
+/**
+ * nlmsg_append - Add more data to a nlmsg in a skb
+ * @skb: socket buffer to store message in
+ * @payload: length of message payload
+ *
+ * Append data to an existing nlmsg, used when constructing a message
+ * with multiple fixed-format headers (which is rare).
+ * Returns NULL if the tailroom of the skb is insufficient to store
+ * the extra payload.
+ */
+static inline void *nlmsg_append(struct sk_buff *skb, u32 size)
+{
+	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
+		return NULL;
+
+	if (NLMSG_ALIGN(size) - size)
+		memset(skb_tail_pointer(skb) + size, 0,
+		       NLMSG_ALIGN(size) - size);
+	return __skb_put(skb, NLMSG_ALIGN(size));
+}
+
 /**
  * nlmsg_put_answer - Add a new callback based netlink message to an skb
  * @skb: socket buffer to store message in
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e2ae82e3f9f7..fba3ca8152fa 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -48,6 +48,7 @@ struct sockaddr_nl {
  * @nlmsg_flags: Additional flags
  * @nlmsg_seq:   Sequence number
  * @nlmsg_pid:   Sending process port ID
+ * @nlmsg_data:  Message payload
  */
 struct nlmsghdr {
 	__u32		nlmsg_len;
@@ -55,6 +56,7 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;
 	__u32		nlmsg_seq;
 	__u32		nlmsg_pid;
+	__DECLARE_FLEX_ARRAY(char, nlmsg_data);
 };
 
 /* Flags values */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a662e8a5ff84..f8c94454b916 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2488,19 +2488,25 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		flags |= NLM_F_ACK_TLVS;
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
-	if (!skb) {
-		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
-		sk_error_report(NETLINK_CB(in_skb).sk);
-		return;
-	}
+	if (!skb)
+		goto err_bad_put;
 
 	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-			NLMSG_ERROR, payload, flags);
+			NLMSG_ERROR, sizeof(*errmsg), flags);
+	if (!rep)
+		goto err_bad_put;
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
-					 ? nlh->nlmsg_len : sizeof(*nlh),
-		      /* Bounds checked by the skb layer. */);
+	errmsg->msg = *nlh;
+
+	if (!(flags & NLM_F_CAPPED)) {
+		if (!nlmsg_append(skb, nlmsg_len(nlh)))
+			goto err_bad_put;
+
+		/* the nlh + 1 is probably going to make you unhappy? */
+		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
+		       nlmsg_len(nlh));
+	}
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
@@ -2508,6 +2514,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	nlmsg_end(skb, rep);
 
 	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
+
+	return;
+
+err_bad_put:
+	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+	sk_error_report(NETLINK_CB(in_skb).sk);
 }
 EXPORT_SYMBOL(netlink_ack);
 
-- 
2.37.3

