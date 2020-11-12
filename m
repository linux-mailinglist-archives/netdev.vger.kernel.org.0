Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3F2AFC1F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgKLBcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:55022 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgKLAWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:22:34 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kd0Ni-0007ZF-Ab; Thu, 12 Nov 2020 01:22:30 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kd0Ni-000QHX-5J; Thu, 12 Nov 2020 01:22:30 +0100
Subject: Re: [bpf PATCH 3/5] bpf, sockmap: Avoid returning unneeded EAGAIN
 when redirecting to self
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
 <160477791482.608263.14389359214124051944.stgit@john-XPS-13-9370>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a49096e0-6cc7-7741-a283-27c8629da80f@iogearbox.net>
Date:   Thu, 12 Nov 2020 01:22:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160477791482.608263.14389359214124051944.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25985/Wed Nov 11 14:18:01 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/20 8:38 PM, John Fastabend wrote:
> If a socket redirects to itself and it is under memory pressure it is
> possible to get a socket stuck so that recv() returns EAGAIN and the
> socket can not advance for some time. This happens because when
> redirecting a skb to the same socket we received the skb on we first
> check if it is OK to enqueue the skb on the receiving socket by checking
> memory limits. But, if the skb is itself the object holding the memory
> needed to enqueue the skb we will keep retrying from kernel side
> and always fail with EAGAIN. Then userspace will get a recv() EAGAIN
> error if there are no skbs in the psock ingress queue. This will continue
> until either some skbs get kfree'd causing the memory pressure to
> reduce far enough that we can enqueue the pending packet or the
> socket is destroyed. In some cases its possible to get a socket
> stuck for a noticable amount of time if the socket is only receiving
> skbs from sk_skb verdict programs. To reproduce I make the socket
> memory limits ridiculously low so sockets are always under memory
> pressure. More often though if under memory pressure it looks like
> a spurious EAGAIN error on user space side causing userspace to retry
> and typically enough has moved on the memory side that it works.
> 
> To fix skip memory checks and skb_orphan if receiving on the same
> sock as already assigned.
> 
> For SK_PASS cases this is easy, its always the same socket so we
> can just omit the orphan/set_owner pair.
> 
> For backlog cases we need to check skb->sk and decide if the orphan
> and set_owner pair are needed.
> 
> Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   net/core/skmsg.c |   72 ++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 53 insertions(+), 19 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index fe44280c033e..580252e532da 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -399,38 +399,38 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
>   }
>   EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
>   
> -static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
> +static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
> +						  struct sk_buff *skb)
>   {
> -	struct sock *sk = psock->sk;
> -	int copied = 0, num_sge;
>   	struct sk_msg *msg;
>   
>   	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
> -		return -EAGAIN;
> +		return NULL;
> +
> +	if (!sk_rmem_schedule(sk, skb, skb->len))

Isn't accounting always truesize based, thus we should fix & convert all skb->len
to skb->truesize ?

> +		return NULL;
>   
>   	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
>   	if (unlikely(!msg))
> -		return -EAGAIN;
> -	if (!sk_rmem_schedule(sk, skb, skb->len)) {
> -		kfree(msg);
> -		return -EAGAIN;
> -	}
> +		return NULL;
>   
>   	sk_msg_init(msg);
> -	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
> +	return msg;
> +}
> +
