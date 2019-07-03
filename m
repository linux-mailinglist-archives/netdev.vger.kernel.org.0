Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F415DCE3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 05:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfGCD1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 23:27:23 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:43041 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbfGCD1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 23:27:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0TVvQlX0_1562124439;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0TVvQlX0_1562124439)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Jul 2019 11:27:19 +0800
Date:   Wed, 3 Jul 2019 11:27:18 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        oliver.yang@linux.alibaba.com, xlpang@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190703032718.GC55248@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20190621130955.147974-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621130955.147974-1-edumazet@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

	We have applied that commit e358f4af19db ("tcp: tcp_fragment() should apply sane memory limits")
	as a hotpatch in production environment. We found that it will make
	tcp long connection reset during sending out packet when applying
	that commit. 
	
	Our applications which in A/B test have suffered that
	and made them retransmit large data, and then caused retransmission
	storm and lower the performance and increase RT.

	Therefore we discontinued to apply this hotpatch in A/B test.

	After invesgation, we found this patch already fix this issue in
	stable. Before applying this patch, we have some questions:

	1. This commit in stable hard coded a magic number 0x20000. I am
	wondering this value and if there any better solution.
	2. Is there any known or unknown side effect? If any, we could test
	it in some suspicious scenarios before testing in prod env.

	Thanks.

Cheers,
Tony Lu

On Fri, Jun 21, 2019 at 06:09:55AM -0700, Eric Dumazet wrote:
> tcp_fragment() might be called for skbs in the write queue.
> 
> Memory limits might have been exceeded because tcp_sendmsg() only
> checks limits at full skb (64KB) boundaries.
> 
> Therefore, we need to make sure tcp_fragment() wont punish applications
> that might have setup very low SO_SNDBUF values.
> 
> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> ---
>  net/ipv4/tcp_output.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 00c01a01b547ec67c971dc25a74c9258563cf871..0ebc33d1c9e5099d163a234930e213ee35e9fbd1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>  	if (nsize < 0)
>  		nsize = 0;
>  
> -	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
> +	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
> +		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>  		return -ENOMEM;
>  	}
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
