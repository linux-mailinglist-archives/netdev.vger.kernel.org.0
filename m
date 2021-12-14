Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F54474262
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhLNMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:20:55 -0500
Received: from mga18.intel.com ([134.134.136.126]:15137 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhLNMUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:20:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639484454; x=1671020454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fq41OeLF8fdr/GNtKSrDNCF3D6JdFod014dweZ/IpUs=;
  b=LyJm/zVwSxT7d9XuqQPFHNAKTN5frwlcdmoXJJMFck5cj/dRPT4cqiiX
   eqgDPBCra0zRPt3Dyt0pPexDHUHISj9fDKs0Y23fqMAZOwQh1U2frYIcZ
   Gx85acW/kvKCncFcckK0IS7mM5BFJOXrZExEWCRC9OUVqoR7Mx+hBiqsU
   tNqVOaHJuFKz7FWaunHUjnkXxnz1ACriuBBLlOFZBOMU7lcqESLWRkZAm
   8vsVV2gu2zpZ8SsKi4VbODP99SrGlCI0ZWusGPZSY/cG1QrF4mwOQjeYC
   q0isS5JIZICnJtPfYuORiiJvdbRQ0r4N+RrwgHXbmNXpJfd3+YMk8VXKd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225825437"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="225825437"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 04:20:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="481933907"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Dec 2021 04:20:52 -0800
Date:   Tue, 14 Dec 2021 13:20:51 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Keith Wiles <keith.wiles@intel.com>
Subject: Re: [PATCH bpf] xsk: do not sleep in poll() when need_wakeup set
Message-ID: <YbiMIzFt0EXzc+fQ@boxer>
References: <20211214102607.7677-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214102607.7677-1-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:26:07AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Do not sleep in poll() when the need_wakeup flag is set. When this
> flag is set, the application needs to explicitly wake up the driver
> with a syscall (poll, recvmsg, sendmsg, etc.) to guarantee that Rx
> and/or Tx processing will be processed promptly. But the current code
> in poll(), sleeps first then wakes up the driver. This means that no
> driver processing will occur (baring any interrupts) until the timeout
> has expired.
> 
> Fix this by checking the need_wakeup flag first and if set, wake the
> driver and return to the application. Only if need_wakeup is not set
> should the process sleep if there is a timeout set in the poll() call.
> 
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> Reported-by: Keith Wiles <keith.wiles@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  net/xdp/xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f16074eb53c7..7a466ea962c5 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -677,8 +677,6 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>  	struct xdp_sock *xs = xdp_sk(sk);
>  	struct xsk_buff_pool *pool;
>  
> -	sock_poll_wait(file, sock, wait);
> -
>  	if (unlikely(!xsk_is_bound(xs)))
>  		return mask;
>  
> @@ -690,6 +688,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>  		else
>  			/* Poll needs to drive Tx also in copy mode */
>  			__xsk_sendmsg(sk);
> +	} else {
> +		sock_poll_wait(file, sock, wait);
>  	}
>  
>  	if (xs->rx && !xskq_prod_is_empty(xs->rx))
> 
> base-commit: 0be2516f865f5a876837184a8385163ff64a5889
> -- 
> 2.29.0
> 
