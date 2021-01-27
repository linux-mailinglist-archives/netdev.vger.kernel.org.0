Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A07305B7A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbhA0MfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:35:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:27055 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237986AbhA0McF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 07:32:05 -0500
IronPort-SDR: Zc/2MAaAeaqktXUx4mmYStUkLRZbgW46EMqyECGwwEazweUqCv8EgfXkVxAvmldJzMRbNK86rB
 cX1g5cSelfsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="264883750"
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="264883750"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 04:31:11 -0800
IronPort-SDR: kHmWbkgukQoOE3pVIpk2T+xYgrm4/PW00drbTc6F0hsF8hDZgPm6wfr+kNnLJ9nDkVvYQbnNGk
 juQKEABmhyTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="388288477"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 27 Jan 2021 04:31:08 -0800
Date:   Wed, 27 Jan 2021 13:20:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210127122050.GA41732@ranger.igk.intel.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-2-liuhangbin@gmail.com>
 <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
 <87lfcesomf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfcesomf.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:41:44AM +0100, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
> > Hangbin Liu wrote:
> >> From: Jesper Dangaard Brouer <brouer@redhat.com>
> >> 
> >> This changes the devmap XDP program support to run the program when the
> >> bulk queue is flushed instead of before the frame is enqueued. This has
> >> a couple of benefits:
> >> 
> >> - It "sorts" the packets by destination devmap entry, and then runs the
> >>   same BPF program on all the packets in sequence. This ensures that we
> >>   keep the XDP program and destination device properties hot in I-cache.
> >> 
> >> - It makes the multicast implementation simpler because it can just
> >>   enqueue packets using bq_enqueue() without having to deal with the
> >>   devmap program at all.
> >> 
> >> The drawback is that if the devmap program drops the packet, the enqueue
> >> step is redundant. However, arguably this is mostly visible in a
> >> micro-benchmark, and with more mixed traffic the I-cache benefit should
> >> win out. The performance impact of just this patch is as follows:
> >> 
> >> The bq_xmit_all's logic is also refactored and error label is removed.
> >> When bq_xmit_all() is called from bq_enqueue(), another packet will
> >> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> >> flush_node in bq_xmit_all() is redundant. Let's move the clear to
> >> __dev_flush(), and only check them once in bq_enqueue() since they are
> >> all modified together.
> >> 
> >> By using xdp_redirect_map in sample/bpf and send pkts via pktgen cmd:
> >> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> >> 
> >> There are about +/- 0.1M deviation for native testing, the performance
> >> improved for the base-case, but some drop back with xdp devmap prog attached.
> >> 
> >> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
> >> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
> >> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
> >> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
> >> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M
> >> 
> >
> > [...]
> >
> >> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> >> +				struct xdp_frame **frames, int n,
> >> +				struct net_device *dev)
> >> +{
> >> +	struct xdp_txq_info txq = { .dev = dev };
> >> +	struct xdp_buff xdp;
> >> +	int i, nframes = 0;
> >> +
> >> +	for (i = 0; i < n; i++) {
> >> +		struct xdp_frame *xdpf = frames[i];
> >> +		u32 act;
> >> +		int err;
> >> +
> >> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> >> +		xdp.txq = &txq;
> >> +
> >> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >> +		switch (act) {
> >> +		case XDP_PASS:
> >> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> >> +			if (unlikely(err < 0))
> >> +				xdp_return_frame_rx_napi(xdpf);
> >> +			else
> >> +				frames[nframes++] = xdpf;
> >> +			break;
> >> +		default:
> >> +			bpf_warn_invalid_xdp_action(act);
> >> +			fallthrough;
> >> +		case XDP_ABORTED:
> >> +			trace_xdp_exception(dev, xdp_prog, act);
> >> +			fallthrough;
> >> +		case XDP_DROP:
> >> +			xdp_return_frame_rx_napi(xdpf);
> >> +			break;
> >> +		}
> >> +	}
> >> +	return nframes; /* sent frames count */
> >> +}
> >> +
> >>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >>  {
> >>  	struct net_device *dev = bq->dev;
> >> -	int sent = 0, drops = 0, err = 0;
> >> +	unsigned int cnt = bq->count;
> >> +	int drops = 0, err = 0;
> >> +	int to_send = cnt;
> >> +	int sent = cnt;
> >>  	int i;
> >>  
> >> -	if (unlikely(!bq->count))
> >> +	if (unlikely(!cnt))
> >>  		return;
> >>  
> >> -	for (i = 0; i < bq->count; i++) {
> >> +	for (i = 0; i < cnt; i++) {
> >>  		struct xdp_frame *xdpf = bq->q[i];
> >>  
> >>  		prefetch(xdpf);
> >>  	}
> >>  
> >> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> >> +	if (bq->xdp_prog) {
> >> +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> >> +		if (!to_send) {
> >> +			sent = 0;
> >> +			goto out;
> >> +		}
> >> +		drops = cnt - to_send;
> >> +	}
> >
> > I might be missing something about how *bq works here. What happens when
> > dev_map_bpf_prog_run returns to_send < cnt?
> >
> > So I read this as it will send [0, to_send] and [to_send, cnt] will be
> > dropped? How do we know the bpf prog would have dropped the set,
> > [to_send+1, cnt]?

You know that via recalculation of 'drops' value after you returned from
dev_map_bpf_prog_run() which later on is provided onto trace_xdp_devmap_xmit.

> 
> Because dev_map_bpf_prog_run() compacts the array:
> 
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> +			if (unlikely(err < 0))
> +				xdp_return_frame_rx_napi(xdpf);
> +			else
> +				frames[nframes++] = xdpf;
> +			break;

To expand this a little, 'frames' array is reused and 'nframes' above is
the value that is returned and we store it onto 'to_send' variable.

> 
> [...]
> 
> >>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> >> @@ -489,12 +516,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> >>  {
> >>  	struct net_device *dev = dst->dev;
> >>  
> >> -	if (dst->xdp_prog) {
> >> -		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> >> -		if (!xdp)
> >> -			return 0;
> >
> > So here it looks like dev_map_run_prog will not drop extra
> > packets, but will see every single packet.
> >
> > Are we changing the semantics subtle here? This looks like
> > a problem to me. We should not drop packets in the new case
> > unless bpf program tells us to.
> 
> It's not a change in semantics (see above), but I'll grant you that it's
> subtle :)

dev map xdp prog still sees all of the frames.

Maybe you were referring to a fact that for XDP_PASS action you might fail
with xdp->xdpf conversion?

I'm wondering if we could actually do a further optimization and avoid
xdpf/xdp juggling.

What if xdp_dev_bulk_queue would be storing the xdp_buffs instead of
xdp_frames ?

Then you hit bq_xmit_all and if prog is present it doesn't have to do that
dance like we have right now. After that you walk through xdp_buff array
and do the conversion so that xdp_frame array will be passed do
ndo_xdp_xmit.

I had a bad sleep so maybe I'm talking nonsense over here, will take
another look in the evening though :)


> 
> -Toke
> 
