Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74363BB2C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiK2IDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiK2IC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:02:58 -0500
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 5ACE427CD4;
        Tue, 29 Nov 2022 00:02:50 -0800 (PST)
Received: from XMCDN1207038 (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltACnh+SovIVjDH8AAA--.610S2;
        Tue, 29 Nov 2022 16:02:48 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Jakub Sitnicki'" <jakub@cloudflare.com>
Cc:     "'John Fastabend'" <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Lorenz Bauer'" <lmb@cloudflare.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com> <1669082309-2546-3-git-send-email-yangpc@wangsu.com> <637d8d5bd4e27_2b649208eb@john.notmuch> <000001d8ff01$053529d0$0f9f7d70$@wangsu.com> <87cz97cnz8.fsf@cloudflare.com>
In-Reply-To: <87cz97cnz8.fsf@cloudflare.com>
Subject: Re: [PATCH RESEND bpf 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
Date:   Tue, 29 Nov 2022 16:02:48 +0800
Message-ID: <000001d903c8$f8d2d710$ea788530$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGntG3gSsG5fexUwyK4ofUjVybadQE5HE+MAYsC+QACkhU0QQGEqlaWroE5o8A=
Content-Language: zh-cn
X-CM-TRANSID: SyJltACnh+SovIVjDH8AAA--.610S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1kKr48CF18Kw4DXr1xAFb_yoW7JF15pF
        s0ya1rCF4jkrWUWw4SqF48WF4I934rtF1jkF1UAw1fKwsrKr18JFn5KFy5ZFn5tr4kCa1a
        qr4IgFW5GFnrZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki <jakub@cloudflare.com> wrote:
> On Wed, Nov 23, 2022 at 02:01 PM +08, Pengcheng Yang wrote:
> > John Fastabend <john.fastabend@gmail.com> wrote:
> >>
> >> 		if (!psock->apply_bytes) {
> >> 			/* Clean up before releasing the sock lock. */
> >> 			eval = psock->eval;
> >> 			psock->eval = __SK_NONE;
> >> 			psock->sk_redir = NULL;
> >> 		}
> >>
> >> Now that we have a psock->flags we should clera that as
> >> well right?
> >
> > According to my understanding, it is not necessary (but can) to clear
> > psock->flags here, because psock->flags will be overwritten by msg->flags
> > at the beginning of each redirection (in sk_psock_msg_verdict()).
> 
> 1. We should at least document that psock->flags value can be garbage
>    (undefined) if psock->sk_redir is null.
> 
> 2. 'flags' is amiguous (flags for what?). I'd suggest to rename to
>    something like redir_flags.
> 
>    Also, since we don't care about all flags, but just the ingress bit,
>    we should store just that. It's not about size. Less state passed
>    around is easier to reason about. See patch below.
> 
> 3. Alternatively, I'd turn psock->sk_redir into a tagged pointer, like
>    skb->_sk_redir is. This way all state (pointer & flags) is bundled
>    and managed together. It would be a bigger change. Would have to be
>    split out from this patch set.
> 
> --8<--
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 70d6cb94e580..84f787416a54 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -82,6 +82,7 @@ struct sk_psock {
>  	u32				apply_bytes;
>  	u32				cork_bytes;
>  	u32				eval;
> +	bool				redir_ingress; /* undefined if sk_redir is null */
>  	struct sk_msg			*cork;
>  	struct sk_psock_progs		progs;
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 14d45661a84d..5b70b241ce71 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2291,8 +2291,8 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
>  #endif /* CONFIG_BPF_SYSCALL */
> 
> -int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
> -			  int flags);
> +int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> +			  struct sk_msg *msg, u32 bytes, int flags);
>  #endif /* CONFIG_NET_SOCK_MSG */
> 
>  #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index e6b9ced3eda8..53d0251788aa 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -886,13 +886,16 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
>  	ret = sk_psock_map_verd(ret, msg->sk_redir);
>  	psock->apply_bytes = msg->apply_bytes;
>  	if (ret == __SK_REDIRECT) {
> -		if (psock->sk_redir)
> +		if (psock->sk_redir) {
>  			sock_put(psock->sk_redir);
> -		psock->sk_redir = msg->sk_redir;
> -		if (!psock->sk_redir) {
> +			psock->sk_redir = NULL;
> +		}
> +		if (!msg->sk_redir) {
>  			ret = __SK_DROP;
>  			goto out;
>  		}
> +		psock->redir_ingress = sk_msg_to_ingress(msg);
> +		psock->sk_redir = msg->sk_redir;
>  		sock_hold(psock->sk_redir);
>  	}
>  out:
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index cf9c3e8f7ccb..490b359dc814 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -131,10 +131,9 @@ static int tcp_bpf_push_locked(struct sock *sk, struct sk_msg *msg,
>  	return ret;
>  }
> 
> -int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
> -			  u32 bytes, int flags)
> +int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> +			  struct sk_msg *msg, u32 bytes, int flags)
>  {
> -	bool ingress = sk_msg_to_ingress(msg);
>  	struct sk_psock *psock = sk_psock_get(sk);
>  	int ret;
> 
> @@ -337,7 +336,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		release_sock(sk);
> 
>  		origsize = msg->sg.size;
> -		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
> +		ret = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
                                       ^^^^^^^
Thanks for such detailed advice.
Here it looks like we need to pre-save the redir_ingress before
setting psock->sk_redir to NULL and release_sock.

> +					    msg, tosend, flags);
>  		sent = origsize - msg->sg.size;
> 
>  		if (eval == __SK_REDIRECT)
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 264cf367e265..b22d97610b9a 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -846,7 +846,8 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
>  		sk_msg_return_zero(sk, msg, send);
>  		msg->sg.size -= send;
>  		release_sock(sk);
> -		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
> +		err = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
> +					    &msg_redir, send, flags);
>  		lock_sock(sk);
>  		if (err < 0) {
>  			*copied -= sk_msg_free_nocharge(sk, &msg_redir);

