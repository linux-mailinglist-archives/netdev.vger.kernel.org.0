Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1752FEC76
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbhAUN6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:58:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:14150 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbhAUNqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 08:46:12 -0500
IronPort-SDR: WJpd9lMuNW8Uyv8t3KCunDYlvXYQIEoGfm4sDjQeG3pvet+YN1VliaipPXBxoRN0YASHkRxxPb
 09xR1zGbU+nQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="198006144"
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="198006144"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 05:45:13 -0800
IronPort-SDR: XRAujAvTTM7ZXgiv33dUPK0lz+XqJ9dlDDZVQkyRGWoDUuqjZkQTbxIGoQaIxSqcwmf2iuS/WR
 qLNQ8kVeClkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="385313196"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 21 Jan 2021 05:45:09 -0800
Date:   Thu, 21 Jan 2021 14:35:38 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv15 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210121133538.GA41935@ranger.igk.intel.com>
References: <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210120022514.2862872-2-liuhangbin@gmail.com>
 <20210120224238.GA33532@ranger.igk.intel.com>
 <20210121035424.GK1421720@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121035424.GK1421720@Leo-laptop-t470s>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 11:54:24AM +0800, Hangbin Liu wrote:
> Hi Maciej,
> On Wed, Jan 20, 2021 at 11:42:38PM +0100, Maciej Fijalkowski wrote:
> > > +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> > > +				struct xdp_frame **frames, int n,
> > > +				struct net_device *dev)
> > > +{
> > > +	struct xdp_txq_info txq = { .dev = dev };
> > > +	struct xdp_buff xdp;
> > > +	int i, nframes = 0;
> > > +
> > > +	for (i = 0; i < n; i++) {
> > > +		struct xdp_frame *xdpf = frames[i];
> > > +		u32 act;
> > > +		int err;
> > > +
> > > +		xdp_convert_frame_to_buff(xdpf, &xdp);
> > > +		xdp.txq = &txq;
> > > +
> > > +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > > +		switch (act) {
> > > +		case XDP_PASS:
> > > +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> > 
> > Bump on John's question.
> 
> Hi Jesper, would you please help answer John's question?
> > >  
> > > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > > +	/* Init sent to cnt in case there is no xdp_prog */
> > > +	sent = cnt;
> > > +	if (bq->xdp_prog) {
> > > +		sent = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > > +		if (!sent)
> > > +			goto out;
> > 
> > Sorry, but 'sent' is a bit confusing to me, actual sending happens below
> > via ndo_xdp_xmit, right? This hook will not actually send frames.
> > Can we do a subtle change to have it in separate variable 'to_send' ?
> 
> Makes sense to me.
> > 
> > Although I'm a huge goto advocate, I feel like this particular usage could
> > be simplified. Not sure why we had that in first place.
> > 
> > I gave a shot at rewriting/refactoring whole bq_xmit_all and I feel like
> > it's more readable. I introduced 'to_send' variable and got rid of 'error'
> > label.
> > 
> > Thoughts?
> > 
> > I might have missed something, though.
> > 
> > static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> > {
> > 	struct net_device *dev = bq->dev;
> > 	unsigned int cnt = bq->count;
> > 	int drops = 0, err = 0;
> > 	int to_send = 0;
> 
> The to_send also need to init to cnt.

So I missed something indeed :P you're correct

> 
> > 	int sent = cnt;
> > 	int i;
> > 
> > 	if (unlikely(!cnt))
> > 		return;
> > 
> > 	for (i = 0; i < cnt; i++) {
> > 		struct xdp_frame *xdpf = bq->q[i];
> > 
> > 		prefetch(xdpf);
> > 	}
> > 
> > 	if (bq->xdp_prog) {
> > 		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > 		if (!to_send) {
> > 			sent = 0;
> > 			goto out;
> > 		}
> > 	}
> > 
> > 	drops = cnt - to_send;
> 
> This line could move in to the xdp_prog brackets to save time when no xdp_prog.

Hmm, looks like we can do it.
For scenario where there was no bq->xdp_prog and failure of ndo_xdp_xmit,
we didn't alter the count of frames to be sent, so we would basically free
all of the frames (as drops is 0, cnt = bq->count). After that we
recalculate drops and correct value will be reported in tracepoint.

(needed to explain it to myself)

> 
> 	if (bq->xdp_prog) {
> 		to_send = ...
> 		if (!to_send) {
> 			...
> 		}
> 		drops = cnt - to_send;
> 	}
> 
> > 	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
> 
> If we don't have xdp_prog, the to_send should be cnt.

Yes, we should init to_send to cnt as you're suggesting above.

> 
> > 	if (sent < 0) {
> > 		err = sent;
> > 		sent = 0;
> > 
> > 		/* If ndo_xdp_xmit fails with an errno, no frames have been
> > 		 * xmit'ed and it's our responsibility to them free all.
> > 		 */
> > 		for (i = 0; i < cnt - drops; i++) {
> > 			struct xdp_frame *xdpf = bq->q[i];
> > 
> > 			xdp_return_frame_rx_napi(xdpf);
> > 		}
> > 	}
> > out:
> > 	drops = cnt - sent;
> > 	bq->count = 0;
> > 
> > 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> > 	bq->dev_rx = NULL;
> > 	bq->xdp_prog = NULL;
> > 	__list_del_clearprev(&bq->flush_node);
> > 
> > 	return;
> > }
> 
> Thanks for your code, looks much clear now.

Good to hear! I agree on your points as well.

> 
> Hangbin
