Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7AC45DF66
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242163AbhKYROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:14:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:54216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241954AbhKYRMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:12:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="222415070"
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="222415070"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 09:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="554691064"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2021 09:07:39 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1APH7a6a001588;
        Thu, 25 Nov 2021 17:07:36 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic per-channel statistics
Date:   Thu, 25 Nov 2021 18:07:08 +0100
Message-Id: <20211125170708.127323-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <87bl28bga6.fsf@toke.dk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com> <20211123163955.154512-22-alexandr.lobakin@intel.com> <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net> <87bl28bga6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 25 Nov 2021 12:56:01 +0100

> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
> > Hi Alexander,
> >
> > On 11/23/21 5:39 PM, Alexander Lobakin wrote:
> > [...]
> >
> > Just commenting on ice here as one example (similar applies to other drivers):
> >
> >> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> >> index 1dd7e84f41f8..7dc287bc3a1a 100644
> >> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> >> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> >> @@ -258,6 +258,8 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
> >>   		xdp_ring->next_dd = ICE_TX_THRESH - 1;
> >>   	xdp_ring->next_to_clean = ntc;
> >>   	ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
> >> +	xdp_update_tx_drv_stats(&xdp_ring->xdp_stats->xdp_tx, total_pkts,
> >> +				total_bytes);
> >>   }
> >> 
> >>   /**
> >> @@ -277,6 +279,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
> >>   		ice_clean_xdp_irq(xdp_ring);
> >> 
> >>   	if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
> >> +		xdp_update_tx_drv_full(&xdp_ring->xdp_stats->xdp_tx);
> >>   		xdp_ring->tx_stats.tx_busy++;
> >>   		return ICE_XDP_CONSUMED;
> >>   	}
> >> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> >> index ff55cb415b11..62ef47a38d93 100644
> >> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> >> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> >> @@ -454,42 +454,58 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff **xdp_arr)
> >>    * @xdp: xdp_buff used as input to the XDP program
> >>    * @xdp_prog: XDP program to run
> >>    * @xdp_ring: ring to be used for XDP_TX action
> >> + * @lrstats: onstack Rx XDP stats
> >>    *
> >>    * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
> >>    */
> >>   static int
> >>   ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
> >> -	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
> >> +	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
> >> +	       struct xdp_rx_drv_stats_local *lrstats)
> >>   {
> >>   	int err, result = ICE_XDP_PASS;
> >>   	u32 act;
> >> 
> >> +	lrstats->bytes += xdp->data_end - xdp->data;
> >> +	lrstats->packets++;
> >> +
> >>   	act = bpf_prog_run_xdp(xdp_prog, xdp);
> >> 
> >>   	if (likely(act == XDP_REDIRECT)) {
> >>   		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> >> -		if (err)
> >> +		if (err) {
> >> +			lrstats->redirect_errors++;
> >>   			goto out_failure;
> >> +		}
> >> +		lrstats->redirect++;
> >>   		return ICE_XDP_REDIR;
> >>   	}
> >> 
> >>   	switch (act) {
> >>   	case XDP_PASS:
> >> +		lrstats->pass++;
> >>   		break;
> >>   	case XDP_TX:
> >>   		result = ice_xmit_xdp_buff(xdp, xdp_ring);
> >> -		if (result == ICE_XDP_CONSUMED)
> >> +		if (result == ICE_XDP_CONSUMED) {
> >> +			lrstats->tx_errors++;
> >>   			goto out_failure;
> >> +		}
> >> +		lrstats->tx++;
> >>   		break;
> >>   	default:
> >>   		bpf_warn_invalid_xdp_action(act);
> >> -		fallthrough;
> >> +		lrstats->invalid++;
> >> +		goto out_failure;
> >>   	case XDP_ABORTED:
> >> +		lrstats->aborted++;
> >>   out_failure:
> >>   		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> >> -		fallthrough;
> >> +		result = ICE_XDP_CONSUMED;
> >> +		break;
> >>   	case XDP_DROP:
> >>   		result = ICE_XDP_CONSUMED;
> >> +		lrstats->drop++;
> >>   		break;
> >>   	}
> >
> > Imho, the overall approach is way too bloated. I can see the
> > packets/bytes but now we have 3 counter updates with return codes
> > included and then the additional sync of the on-stack counters into
> > the ring counters via xdp_update_rx_drv_stats(). So we now need
> > ice_update_rx_ring_stats() as well as xdp_update_rx_drv_stats() which
> > syncs 10 different stat counters via u64_stats_add() into the per ring
> > ones. :/
> >
> > I'm just taking our XDP L4LB in Cilium as an example: there we already
> > count errors and export them via per-cpu map that eventually lead to
> > XDP_DROP cases including the /reason/ which caused the XDP_DROP (e.g.
> > Prometheus can then scrape these insights from all the nodes in the
> > cluster). Given the different action codes are very often application
> > specific, there's not much debugging that you can do when /only/
> > looking at `ip link xdpstats` to gather insight on *why* some of these
> > actions were triggered (e.g. fib lookup failure, etc). If really of
> > interest, then maybe libxdp could have such per-action counters as
> > opt-in in its call chain..
> 
> To me, standardising these counters is less about helping people debug
> their XDP programs (as you say, you can put your own telemetry into
> those), and more about making XDP less "mystical" to the system
> administrator (who may not be the same person who wrote the XDP
> programs). So at the very least, they need to indicate "where are the
> packets going", which means at least counters for DROP, REDIRECT and TX
> (+ errors for tx/redirect) in addition to the "processed by XDP" initial
> counter. Which in the above means 'pass', 'invalid' and 'aborted' could
> be dropped, I guess; but I don't mind terribly keeping them either given
> that there's no measurable performance impact.

Right.

The other reason is that I want to continue the effort of
standardizing widely-implemented statistics. Ethtool private stats
approach is neither scalable (you can't rely on any fields which may
be not exposed in other drivers) nor good for code hygiene (code
duplication, differences in naming and logics etc.).
Let's say if only mlx5 driver has 'cache_waive' stats, then it's
okay to export it using private stats, but if 10 drivers has
'xdp_drop' field it's better to uniform it, isn't it?

> > But then it also seems like above in ice_xmit_xdp_ring() we now need
> > to bump counters twice just for sake of ethtool vs xdp counters which
> > sucks a bit, would be nice to only having to do it once:

We'll remove such duplication in the nearest future, as well as some
of duplications between Ethtool private and this XDP stats. I wanted
this series to be as harmless as possible.

> This I agree with, and while I can see the layering argument for putting
> them into 'ip' and rtnetlink instead of ethtool, I also worry that these
> counters will simply be lost in obscurity, so I do wonder if it wouldn't
> be better to accept the "layering violation" and keeping them all in the
> 'ethtool -S' output?

I don't think we should harm the code and the logics in favor of
'some of the users can face something'. We don't control anything
related to XDP using Ethtool at all, but there is some XDP-related
stuff inside iproute2 code, so for me it's even more intuitive to
have them there.
Jakub, may be you'd like to add something at this point?

> [...]
> 
> > +  xdp-channel0-rx_xdp_redirect: 7
> > +  xdp-channel0-rx_xdp_redirect_errors: 8
> > +  xdp-channel0-rx_xdp_tx: 9
> > +  xdp-channel0-rx_xdp_tx_errors: 10
> > +  xdp-channel0-tx_xdp_xmit_packets: 11
> > +  xdp-channel0-tx_xdp_xmit_bytes: 12
> > +  xdp-channel0-tx_xdp_xmit_errors: 13
> > +  xdp-channel0-tx_xdp_xmit_full: 14
> >
> >  From a user PoV to avoid confusion, maybe should be made more clear that the latter refers
> > to xsk.
> 
> +1, these should probably be xdp-channel0-tx_xsk_* or something like
> that...

I think I should expand this example in Docs a bit. For XSK, there's
a separate set of the same counters, and they differ as follows:

xdp-channel0-rx_xdp_packets: 0
xdp-channel0-rx_xdp_bytes: 1
xdp-channel0-rx_xdp_errors: 2
[ ... ]
xsk-channel0-rx_xdp_packets: 256
xsk-channel0-rx_xdp_bytes: 257
xsk-channel0-rx_xdp_errors: 258
[ ... ]

The only semantic difference is that 'tx_xdp_xmit' for XDP is a
counter for the packets gone through .ndo_xdp_xmit(), and in
case of XSK it's a counter for the packets gone through XSK
ZC xmit.

> -Toke

Thanks,
Al
