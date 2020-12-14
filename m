Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9A2D974B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407311AbgLNLUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:20:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:57028 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgLNLUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 06:20:14 -0500
IronPort-SDR: FhclqXYdSD+6YAfyGHwYUzqZhWPzuHrFFRNipGtkvRfU5yQh7mAnP74SHEj52lbueTutnOrNEe
 BR0A0mxuTwJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="171180118"
X-IronPort-AV: E=Sophos;i="5.78,418,1599548400"; 
   d="scan'208";a="171180118"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 03:19:24 -0800
IronPort-SDR: TBsEhtvPWl6DeuKGckm5kbCZ3WcUZ34QEUd0WVApkMUenAI8GvVUcW9KtyoLaotgnRDlfRLbqR
 198obvQWvfFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,418,1599548400"; 
   d="scan'208";a="333277818"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 14 Dec 2020 03:19:22 -0800
Date:   Mon, 14 Dec 2020 12:09:57 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf] xsk: fix memory leak for failed bind
Message-ID: <20201214110957.GA11487@ranger.igk.intel.com>
References: <20201214085127.3960-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214085127.3960-1-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 09:51:27AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a possible memory leak when a bind of an AF_XDP socket fails. When
> the fill and completion rings are created, they are tied to the
> socket. But when the buffer pool is later created at bind time, the
> ownership of these two rings are transferred to the buffer pool as
> they might be shared between sockets (and the buffer pool cannot be
> created until we know what we are binding to). So, before the buffer
> pool is created, these two rings are cleaned up with the socket, and
> after they have been transferred they are cleaned up together with
> the buffer pool.
> 
> The problem is that ownership was transferred before it was absolutely
> certain that the buffer pool could be created and initialized
> correctly and when one of these errors occurred, the fill and
> completion rings did neither belong to the socket nor the pool and
> where therefore leaked. Solve this by moving the ownership transfer
> to the point where the buffer pool has been completely set up and
> there is no way it can fail.
> 
> Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
> ---
>  net/xdp/xsk.c           | 4 ++++
>  net/xdp/xsk_buff_pool.c | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 62504471fd20..189cfbbcccc0 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -772,6 +772,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>  		}
>  	}
>  
> +	/* FQ and CQ are now owned by the buffer pool and cleaned up with it. */
> +	xs->fq_tmp = NULL;
> +	xs->cq_tmp = NULL;
> +
>  	xs->dev = dev;
>  	xs->zc = xs->umem->zc;
>  	xs->queue_id = qid;
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index d5adeee9d5d9..46c2ae7d91d1 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -75,8 +75,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>  
>  	pool->fq = xs->fq_tmp;
>  	pool->cq = xs->cq_tmp;
> -	xs->fq_tmp = NULL;
> -	xs->cq_tmp = NULL;

Given this change, are there any circumstances that we could hit
xsk_release with xs->{f,c}q_tmp != NULL ?
>  
>  	for (i = 0; i < pool->free_heads_cnt; i++) {
>  		xskb = &pool->heads[i];
> 
> base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
> -- 
> 2.29.0
> 
