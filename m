Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84363A73C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiK1Ldw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiK1Ldv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:33:51 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845A812772
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:33:50 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so24917942ejb.13
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=n/0AR+XUvHAQpL1RlhgVd3/YWU5WZhXuH/csAwCA6p8=;
        b=UysEO1M59eAgxnBRAF4Pm7UxLxvG4QmnLsWEvcSLP5PrRart7cG69oQ0kbvvUiLI3F
         RF9RTGmGFy7fM728a7n3VH2HTSr9kPyD4rnYH5PYdiOCl4dMTGf32wofx8zfFCMuJOpU
         SwtXl/j0061xTV1tZ2GKXlwSBl03YO0EHqs4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/0AR+XUvHAQpL1RlhgVd3/YWU5WZhXuH/csAwCA6p8=;
        b=fpAKSi+djF4JLBK62EfUE1+wIq7ccklP+awjGcihtVowJ3dDzR2t4yxciPmVagMtZv
         0uXpjdPzxwn4k7rAyG6g3nhJb3jffaqRxQ5xE42cB9ABeLXBhhapLQd0Ljlli6LkhmiM
         MoLt1/vJhvktZL23axIxXSSrx2pehosttiojWQ9yjJbqSGEOofsbwKL6KLxLQ31zVDnj
         Yl6wO7AVBfM5mtDvvabn8IJRMgejg2/ai8/DtXTs7x6KTEzRDnQPUulRvfv2tsPoVCmC
         5QUh2u5SJwxpFgjpJbKaGVLVupoqN39m6Ld8jz80P80ohGJQjIxj8fhVE7A6Zw5hm0d8
         q9gw==
X-Gm-Message-State: ANoB5pmaOmHcqJxOw0KXyzq/6SdaEnQL3XpkmO8h9oJ523nONi5avLPW
        0Fh7kfQjPipqEsIbRazc04d3vg==
X-Google-Smtp-Source: AA0mqf54aDrJEQlrysClgRz1HTez+VgioM/ddgWxF9nLRhhfROR1NHyj6n8Z324bF+Dbcn92QwWzuQ==
X-Received: by 2002:a17:907:8c8e:b0:78d:4167:cf08 with SMTP id td14-20020a1709078c8e00b0078d4167cf08mr9200822ejc.337.1669635229033;
        Mon, 28 Nov 2022 03:33:49 -0800 (PST)
Received: from cloudflare.com ([2a09:bac1:5bc0:40::49:10a])
        by smtp.gmail.com with ESMTPSA id la21-20020a170907781500b007c03fa39c33sm924736ejc.71.2022.11.28.03.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 03:33:48 -0800 (PST)
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com>
 <1669082309-2546-3-git-send-email-yangpc@wangsu.com>
 <637d8d5bd4e27_2b649208eb@john.notmuch>
 <000001d8ff01$053529d0$0f9f7d70$@wangsu.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     'John Fastabend' <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, 'Daniel Borkmann' <daniel@iogearbox.net>,
        'Lorenz Bauer' <lmb@cloudflare.com>
Subject: Re: [PATCH RESEND bpf 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS
 flag when using apply_bytes
Date:   Mon, 28 Nov 2022 12:22:20 +0100
In-reply-to: <000001d8ff01$053529d0$0f9f7d70$@wangsu.com>
Message-ID: <87cz97cnz8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:01 PM +08, Pengcheng Yang wrote:
> John Fastabend <john.fastabend@gmail.com> wrote:
>> 
>> Pengcheng Yang wrote:
>> > When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
>> > flag from the msg->flags. If apply_bytes is used and it is larger than
>> > the current data being processed, sk_psock_msg_verdict() will not be
>> > called when sendmsg() is called again. At this time, the msg->flags is 0,
>> > and we lost the BPF_F_INGRESS flag.
>> >
>> > So we need to save the BPF_F_INGRESS flag in sk_psock and assign it to
>> > msg->flags before redirection.
>> >
>> > Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
>> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
>> > ---
>> >  include/linux/skmsg.h | 1 +
>> >  net/core/skmsg.c      | 1 +
>> >  net/ipv4/tcp_bpf.c    | 1 +
>> >  net/tls/tls_sw.c      | 1 +
>> >  4 files changed, 4 insertions(+)
>> >
>> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
>> > index 48f4b64..e1d463f 100644
>> > --- a/include/linux/skmsg.h
>> > +++ b/include/linux/skmsg.h
>> > @@ -82,6 +82,7 @@ struct sk_psock {
>> >  	u32				apply_bytes;
>> >  	u32				cork_bytes;
>> >  	u32				eval;
>> > +	u32				flags;
>> >  	struct sk_msg			*cork;
>> >  	struct sk_psock_progs		progs;
>> >  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> > index 188f855..ab2f8f3 100644
>> > --- a/net/core/skmsg.c
>> > +++ b/net/core/skmsg.c
>> > @@ -888,6 +888,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
>> >  		if (psock->sk_redir)
>> >  			sock_put(psock->sk_redir);
>> >  		psock->sk_redir = msg->sk_redir;
>> > +		psock->flags = msg->flags;
>> >  		if (!psock->sk_redir) {
>> >  			ret = __SK_DROP;
>> >  			goto out;
>> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> > index ef5de4f..1390d72 100644
>> > --- a/net/ipv4/tcp_bpf.c
>> > +++ b/net/ipv4/tcp_bpf.c
>> > @@ -323,6 +323,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>> >  		break;
>> >  	case __SK_REDIRECT:
>> >  		sk_redir = psock->sk_redir;
>> > +		msg->flags = psock->flags;
>> >  		sk_msg_apply_bytes(psock, tosend);
>> >  		if (!psock->apply_bytes) {
>> >  			/* Clean up before releasing the sock lock. */
>>                  ^^^^^^^^^^^^^^^
>> In this block reposted here with the rest of the block
>> 
>> 
>> 		if (!psock->apply_bytes) {
>> 			/* Clean up before releasing the sock lock. */
>> 			eval = psock->eval;
>> 			psock->eval = __SK_NONE;
>> 			psock->sk_redir = NULL;
>> 		}
>> 
>> Now that we have a psock->flags we should clera that as
>> well right?
>
> According to my understanding, it is not necessary (but can) to clear
> psock->flags here, because psock->flags will be overwritten by msg->flags
> at the beginning of each redirection (in sk_psock_msg_verdict()).

1. We should at least document that psock->flags value can be garbage
   (undefined) if psock->sk_redir is null.

2. 'flags' is amiguous (flags for what?). I'd suggest to rename to
   something like redir_flags.

   Also, since we don't care about all flags, but just the ingress bit,
   we should store just that. It's not about size. Less state passed
   around is easier to reason about. See patch below.

3. Alternatively, I'd turn psock->sk_redir into a tagged pointer, like
   skb->_sk_redir is. This way all state (pointer & flags) is bundled
   and managed together. It would be a bigger change. Would have to be
   split out from this patch set.

--8<--

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 70d6cb94e580..84f787416a54 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -82,6 +82,7 @@ struct sk_psock {
 	u32				apply_bytes;
 	u32				cork_bytes;
 	u32				eval;
+	bool				redir_ingress; /* undefined if sk_redir is null */
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14d45661a84d..5b70b241ce71 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2291,8 +2291,8 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
-			  int flags);
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e6b9ced3eda8..53d0251788aa 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -886,13 +886,16 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
-		if (psock->sk_redir)
+		if (psock->sk_redir) {
 			sock_put(psock->sk_redir);
-		psock->sk_redir = msg->sk_redir;
-		if (!psock->sk_redir) {
+			psock->sk_redir = NULL;
+		}
+		if (!msg->sk_redir) {
 			ret = __SK_DROP;
 			goto out;
 		}
+		psock->redir_ingress = sk_msg_to_ingress(msg);
+		psock->sk_redir = msg->sk_redir;
 		sock_hold(psock->sk_redir);
 	}
 out:
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index cf9c3e8f7ccb..490b359dc814 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -131,10 +131,9 @@ static int tcp_bpf_push_locked(struct sock *sk, struct sk_msg *msg,
 	return ret;
 }
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
-			  u32 bytes, int flags)
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags)
 {
-	bool ingress = sk_msg_to_ingress(msg);
 	struct sk_psock *psock = sk_psock_get(sk);
 	int ret;
 
@@ -337,7 +336,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		release_sock(sk);
 
 		origsize = msg->sg.size;
-		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		ret = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
+					    msg, tosend, flags);
 		sent = origsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 264cf367e265..b22d97610b9a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -846,7 +846,8 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		sk_msg_return_zero(sk, msg, send);
 		msg->sg.size -= send;
 		release_sock(sk);
-		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
+		err = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
+					    &msg_redir, send, flags);
 		lock_sock(sk);
 		if (err < 0) {
 			*copied -= sk_msg_free_nocharge(sk, &msg_redir);
