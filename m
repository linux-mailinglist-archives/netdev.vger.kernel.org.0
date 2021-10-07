Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F493425CC9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhJGUCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:02:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:56756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241686AbhJGUCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:02:20 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYZZ3-0006K9-1W; Thu, 07 Oct 2021 22:00:25 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYZZ2-000KBa-R2; Thu, 07 Oct 2021 22:00:24 +0200
Subject: Re: [Patch bpf v3 3/4] net: implement ->sock_is_readable() for UDP
 and AF_UNIX
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
 <20211002003706.11237-4-xiyou.wangcong@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <582ff8e9-c7b7-88c1-6cf0-e143da92836f@iogearbox.net>
Date:   Thu, 7 Oct 2021 22:00:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211002003706.11237-4-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26315/Thu Oct  7 11:09:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/21 2:37 AM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Yucong noticed we can't poll() sockets in sockmap even
> when they are the destination sockets of redirections.
> This is because we never poll any psock queues in ->poll(),
> except for TCP. With ->sock_is_readable() now we can
> overwrite >sock_is_readable(), invoke and implement it for
> both UDP and AF_UNIX sockets.
> 
> Reported-by: Yucong Sun <sunyucong@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>   net/ipv4/udp.c      | 2 ++
>   net/ipv4/udp_bpf.c  | 1 +
>   net/unix/af_unix.c  | 4 ++++
>   net/unix/unix_bpf.c | 2 ++
>   4 files changed, 9 insertions(+)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 2a7825a5b842..4a7e15a43a68 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2866,6 +2866,8 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
>   	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
>   		mask &= ~(EPOLLIN | EPOLLRDNORM);
>   
> +	if (sk_is_readable(sk))
> +		mask |= EPOLLIN | EPOLLRDNORM;

udp_poll() has this extra logic around first_packet_length() which drops all bad csum'ed
skbs. How does this stand in relation to sk_msg_is_readable()? Is this a concern as well
there? Maybe makes sense to elaborate a bit more in the commit message for context / future
reference.

Thanks,
Daniel

>   	return mask;
>   
>   }


