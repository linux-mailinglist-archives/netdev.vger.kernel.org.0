Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B8136946B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhDWOM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:12:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:3869 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhDWOM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 10:12:28 -0400
IronPort-SDR: l2LME7WpeOzJj5CkBzLkCJdY0ePhujjcMrpd2oy+mMmuMYQat2RtXbI1PvgBj9RNtrXZlliz7B
 JMrGyzddaLjg==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="192885905"
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="192885905"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 07:11:51 -0700
IronPort-SDR: rgCBhGZxy3SQeAJYG6hyLfcfhtvaW79uRi1BZRb4R4+r5B44ip2yUCK+mdMnjGAbhnz8kQWQNY
 ntDpB2NfANJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="456237874"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 07:11:49 -0700
Date:   Fri, 23 Apr 2021 15:57:04 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH RFC bpf-next 4/4] i40e: remove rcu_read_lock() around XDP
 program invocation
Message-ID: <20210423135704.GC64904@ranger.igk.intel.com>
References: <161917591559.102337.3558507780042453425.stgit@toke.dk>
 <161917591996.102337.9559803697014955421.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <161917591996.102337.9559803697014955421.stgit@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 01:05:20PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The i40e driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.

Okay, but what about the lifetime of the xdp_prog itself? Can xdp_prog
change within a single NAPI poll? After reading previous discussions I
would say it can't, right?

There are drivers that have a big RCU critical section in NAPI poll, but it
seems that some read a xdp_prog a single time whereas others read it per
processed frame.

If we are sure that xdp_prog can't change on-the-fly then first low
hanging fruit, at least for the Intel drivers, is to skip a test against
NULL and read it only once at the beginning of NAPI poll. There might be
also other micro-optimizations specific to each drivers that could be done
based on that (that of course read the xdp_prog per each frame).

Or am I nuts?

> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c |    2 --
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c  |    6 +-----
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index fc20afc23bfa..3f4c947a5185 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2303,7 +2303,6 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
>  	struct bpf_prog *xdp_prog;
>  	u32 act;
>  
> -	rcu_read_lock();
>  	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
>  
>  	if (!xdp_prog)
> @@ -2334,7 +2333,6 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
>  		break;
>  	}
>  xdp_out:
> -	rcu_read_unlock();
>  	return ERR_PTR(-result);
>  }
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index d89c22347d9d..93b349f11d3b 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -153,7 +153,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
>  	struct bpf_prog *xdp_prog;
>  	u32 act;
>  
> -	rcu_read_lock();
>  	/* NB! xdp_prog will always be !NULL, due to the fact that
>  	 * this path is enabled by setting an XDP program.
>  	 */
> @@ -162,9 +161,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
>  
>  	if (likely(act == XDP_REDIRECT)) {
>  		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> -		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
> -		rcu_read_unlock();
> -		return result;
> +		return !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
>  	}
>  
>  	switch (act) {
> @@ -184,7 +181,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
>  		result = I40E_XDP_CONSUMED;
>  		break;
>  	}
> -	rcu_read_unlock();
>  	return result;
>  }
>  
> 
