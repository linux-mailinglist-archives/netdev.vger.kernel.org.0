Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FC060EAA9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiJZVEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 17:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiJZVEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1DA12A97
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E043D620CB
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 21:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2087C433D6;
        Wed, 26 Oct 2022 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666818276;
        bh=eSHZY1xMTanqhaQa697d0fIQfSdmFi7wi1UG/mjM1w8=;
        h=From:To:Cc:Subject:Date:From;
        b=g4QVf3WE3WJsZ4e0cpYcQMQRkQk2d/B9OY/OHVbDuK5+rjDEeoZewCd0FgjlnVB4e
         /93VQ0p+PhdEYJDgADsskFAyw6L67icDgVnBecGtnsb5PbZfxOaKDtfIVPt9JQgEDv
         OvrO/ZQLDJ+U/ZVQ4cT2tO+zPZvoLqBoNa8FbfkQf1LbyQL2urZCP91QlnEch6ct9c
         /YHIJA2QwxibDy/Ly1Q3f77NkAvupA+x7DrYiHkaMxsw3/xgWI8p6XIXJBeHbZFxRE
         eN8yvDNiG0dWCVf5I6GYNj9zuxh8+v1dPg3cYJrXcd17XG4uavRPlRuE6C4HF1jEm+
         xUbfI471Mae/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netlink: split up copies in the ack construction
Date:   Wed, 26 Oct 2022 14:04:30 -0700
Message-Id: <20221026210430.2036464-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the use of unsafe_memcpy() by adding a flexible array
at the end of netlink message header and splitting up the header
and data copies.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/netlink.h        | 21 +++++++++++++++++++++
 include/uapi/linux/netlink.h |  2 ++
 net/netlink/af_netlink.c     | 29 ++++++++++++++++++++---------
 3 files changed, 43 insertions(+), 9 deletions(-)

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
index e2ae82e3f9f7..5da0da59bf01 100644
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
+	__u8		nlmsg_data[];
 };
 
 /* Flags values */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f0c94d394ab1..b10d5e50b99d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2499,19 +2499,24 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
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
+		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
+		       nlmsg_len(nlh));
+	}
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
@@ -2519,6 +2524,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
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

