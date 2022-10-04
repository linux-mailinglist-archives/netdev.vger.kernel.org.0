Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC115F48C5
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 19:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJDRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 13:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJDRm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 13:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED52B21E32;
        Tue,  4 Oct 2022 10:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6493614CB;
        Tue,  4 Oct 2022 17:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54E3C433D6;
        Tue,  4 Oct 2022 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664905375;
        bh=I4p81oGMlPEM6Os4yrqYtTn2/8Jqieq/v6DTOXcC3Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mn3twGAsZi4al5Dy4Z1BvuhQkmv2Jo3dsBcxjIG087OQdTr7tP0B5GNhLRaph4QLM
         zQI/27qpII5AHCdpwD5cXKmCuC1ou5QGA6uS3dEOqDC4QoI57zOxyfNJkyzvVjm77N
         FruauZhtA5KoesyXxO5DQEdgoiiB1YhlIfKcdKXLoBGlFNc2DyvzaDqa825ww4iS9N
         djgNwtlSuFxLBz4GKXHnLF4qd2np8fiDXT75jOjHbv8NUKgLTm+FrAvlCyB9E6fvhd
         68HTGiSpyVWZUdt9lN3BirZsjWvxp/mAEzt/V705fSmfaUQ+vWPCsyLCiJamfdk99Q
         83zBPqkbAr9AA==
Date:   Tue, 4 Oct 2022 10:42:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [syzbot] upstream boot error: WARNING in netlink_ack
Message-ID: <20221004104253.29c1f3c7@kernel.org>
In-Reply-To: <F58E0701-8F53-46FE-8324-4DEA7A806C20@chromium.org>
References: <000000000000a793cc05ea313b87@google.com>
        <CACT4Y+a8b-knajrXWs8OnF1ijCansRxEicU=YJz6PRk-JuSKvg@mail.gmail.com>
        <F58E0701-8F53-46FE-8324-4DEA7A806C20@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Oct 2022 07:36:55 -0700 Kees Cook wrote:
> This is fixed in the pending netdev tree coming for the merge window.

This has been weighing on my conscience a little, I don't like how we
still depend on putting one length in the skb and then using a
different one for the actual memcpy(). How would you feel about this
patch on top (untested):

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..6ad671441dff 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -931,6 +931,29 @@ static inline struct nlmsghdr *nlmsg_put(struct sk_buff *skb, u32 portid, u32 se
 	return __nlmsg_put(skb, portid, seq, type, payload, flags);
 }
 
+/**
+ * nlmsg_append - Add more data to a nlmsg in a skb
+ * @skb: socket buffer to store message in
+ * @nlh: message header
+ * @payload: length of message payload
+ *
+ * Append data to an existing nlmsg, used when constructing a message
+ * with multiple fixed-format headers (which is rare).
+ * Returns NULL if the tailroom of the skb is insufficient to store
+ * the extra payload.
+ */
+static inline void *nlmsg_append(struct sk_buff *skb, struct nlmsghdr *nlh,
+				 u32 size)
+{
+	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
+		return NULL;
+
+	if (!__builtin_constant_p(size) || NLMSG_ALIGN(size) - size != 0)
+		memset(skb_tail_pointer(skb) + size, 0,
+		       NLMSG_ALIGN(size) - size);
+	return __skb_put(NLMSG_ALIGN(size));
+}
+
 /**
  * nlmsg_put_answer - Add a new callback based netlink message to an skb
  * @skb: socket buffer to store message in
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a662e8a5ff84..bb3d855d1f57 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2488,19 +2488,28 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
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
+	memcpy(&errmsg->msg, nlh, sizeof(*nlh));
+
+	if (!(flags & NLM_F_CAPPED)) {
+		size_t data_len = nlh->nlmsg_len - sizeof(*nlh);
+		void *data;
+
+		data = nlmsg_append(skb, rep, data_len);
+		if (!data)
+			goto err_bad_put;
+
+		/* the nlh + 1 is probably going to make you unhappy? */
+		memcpy(data, nlh + 1, data_len);
+	}
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
@@ -2508,6 +2517,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
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
 
