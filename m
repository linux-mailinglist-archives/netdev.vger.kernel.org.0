Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BF91348C1
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 18:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgAHRDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 12:03:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:38434 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgAHRDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 12:03:01 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipEjU-0001Cc-8d; Wed, 08 Jan 2020 18:03:00 +0100
Date:   Wed, 8 Jan 2020 18:02:59 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
Message-ID: <20200108170259.GA7665@linux-3.fritz.box>
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
 <20200108045708.31240-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108045708.31240-1-forrest0579@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25688/Wed Jan  8 10:56:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 12:57:08PM +0800, Lingpeng Chen wrote:
> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> and there's also some data in psock->ingress_msg, the data in
> psock->ingress_msg will be purged. It is always happen when request to a
> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> packet after data is sent out.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Arika Chen <eaglesora@gmail.com>
> Suggested-by: Arika Chen <eaglesora@gmail.com>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/ipv4/tcp_bpf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index e38705165ac9..f7e902868fce 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -123,12 +123,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  
>  	if (unlikely(flags & MSG_ERRQUEUE))
>  		return inet_recv_error(sk, msg, len, addr_len);

Shouldn't we also move the error queue handling below the psock test as
well and let tcp_recvmsg() natively do it in case of !psock?

> -	if (!skb_queue_empty(&sk->sk_receive_queue))
> -		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>  
>  	psock = sk_psock_get(sk);
>  	if (unlikely(!psock))
>  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> +	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> +	    sk_psock_queue_empty(psock))
> +		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>  	lock_sock(sk);
>  msg_bytes_ready:
>  	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
> @@ -139,7 +140,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  		timeo = sock_rcvtimeo(sk, nonblock);
>  		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
>  		if (data) {
> -			if (skb_queue_empty(&sk->sk_receive_queue))
> +			if (!sk_psock_queue_empty(psock))
>  				goto msg_bytes_ready;
>  			release_sock(sk);
>  			sk_psock_put(sk, psock);
> -- 
> 2.17.1
> 
