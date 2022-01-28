Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DB49F437
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346733AbiA1HRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:17:47 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55965 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242865AbiA1HRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:17:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V31PeLV_1643354258;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V31PeLV_1643354258)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 Jan 2022 15:17:38 +0800
Date:   Fri, 28 Jan 2022 15:17:37 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/smc: Fallback when handshake workqueue
 congested
Message-ID: <YfOYkcJzpqFH/c6i@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1643284658.git.alibuda@linux.alibaba.com>
 <ed4781cde8e3b9812d4a46ce676294a812c80e8f.1643284658.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed4781cde8e3b9812d4a46ce676294a812c80e8f.1643284658.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:08:03PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch intends to provide a mechanism to allow automatic fallback to
> TCP according to the pressure of SMC handshake process. At present,
> frequent visits will cause the incoming connections to be backlogged in
> SMC handshake queue, raise the connections established time. Which is
> quite unacceptable for those applications who base on short lived
> connections.
> 
> It should be optional for applications that don't care about connection
> established time. For now, this patch only provides the switch at the
> compile time.
> 
> There are two ways to implement this mechanism:
> 
> 1. Fallback when TCP established.
> 2. Fallback before TCP established.
> 
> In the first way, we need to wait and receive CLC messages that the
> client will potentially send, and then actively reply with a decline
> message, in a sense, which is also a sort of SMC handshake, affect the
> connections established time on its way.
> 
> In the second way, the only problem is that we need to inject SMC logic
> into TCP when it is about to reply the incoming SYN, since we already do
> that, it's seems not a problem anymore. And advantage is obvious, few
> additional processes are required to complete the fallback.
> 
> This patch use the second way.
> 
> Link: https://lore.kernel.org/all/1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com/
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  include/linux/tcp.h  |  1 +
>  net/ipv4/tcp_input.c |  3 ++-
>  net/smc/Kconfig      | 12 ++++++++++++
>  net/smc/af_smc.c     | 22 ++++++++++++++++++++++
>  4 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 78b91bb..1c4ae5d 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -394,6 +394,7 @@ struct tcp_sock {
>  	bool	is_mptcp;
>  #endif
>  #if IS_ENABLED(CONFIG_SMC)
> +	bool	(*smc_in_limited)(const struct sock *sk);
>  	bool	syn_smc;	/* SYN includes SMC */
>  #endif
>  
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index dc49a3d..9890de9 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6701,7 +6701,8 @@ static void tcp_openreq_init(struct request_sock *req,
>  	ireq->ir_num = ntohs(tcp_hdr(skb)->dest);
>  	ireq->ir_mark = inet_request_mark(sk, skb);
>  #if IS_ENABLED(CONFIG_SMC)
> -	ireq->smc_ok = rx_opt->smc_ok;
> +	ireq->smc_ok = rx_opt->smc_ok && !(tcp_sk(sk)->smc_in_limited &&
> +			tcp_sk(sk)->smc_in_limited(sk));
>  #endif
>  }
>  
> diff --git a/net/smc/Kconfig b/net/smc/Kconfig
> index 1ab3c5a..1903927 100644
> --- a/net/smc/Kconfig
> +++ b/net/smc/Kconfig
> @@ -19,3 +19,15 @@ config SMC_DIAG
>  	  smcss.
>  
>  	  if unsure, say Y.
> +
> +if MPTCP

If we really need MPTCP? According the context, this doesn't seem necessary.

> +
> +config SMC_AUTO_FALLBACK
> +	bool "SMC: automatic fallback to TCP"
> +	default y
> +	help
> +	  Allow automatic fallback to TCP accroding to the pressure of SMC-R
> +	  handshake process.
> +
> +	  If that's not what you except or unsure, say N.
> +endif

Consider using a dynamic switch to enable or disable this feature? SMC
currently have netlink interface in smc_netlink.c, we can extend this in
userspace tool smc-tools.

Thank you,
Tony Lu
