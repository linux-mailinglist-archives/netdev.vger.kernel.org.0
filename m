Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76724304ABF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbhAZE7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:59:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:59440 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbhAYMki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:40:38 -0500
IronPort-SDR: vPvt62oTPN60vrv/jDdDaYTC3NpFgPai9m+vhJ81gF2M/EYUvrtoO3ajinejb/egcNf5/nqsgK
 4fOn7piS7d0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179865104"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179865104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:39:39 -0800
IronPort-SDR: iSRPcwWmcLKh4CvReFLRHIVwl4jVTyQwJFnFERsqE/azz/nC1aTCId+veT2oFmfZvc5S+UVDYD
 AHjKiaLHJewg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="472282481"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 25 Jan 2021 04:39:35 -0800
Date:   Mon, 25 Jan 2021 13:29:33 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv16 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210125122933.GB18646@ranger.igk.intel.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210122074652.2981711-2-liuhangbin@gmail.com>
 <20210122105043.GB52373@ranger.igk.intel.com>
 <871red6qhr.fsf@toke.dk>
 <20210125033025.GL1421720@Leo-laptop-t470s>
 <87r1m9mfd5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1m9mfd5.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 12:21:26PM +0100, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Fri, Jan 22, 2021 at 02:38:40PM +0100, Toke Høiland-Jørgensen wrote:
> >> >>  out:
> >> >> +	drops = cnt - sent;
> >> >>  	bq->count = 0;
> >> >>  
> >> >>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> >> >>  	bq->dev_rx = NULL;
> >> >> +	bq->xdp_prog = NULL;
> >> >
> >> > One more question, do you really have to do that per each bq_xmit_all
> >> > call? Couldn't you clear it in __dev_flush ?
> >> >
> >> > Or IOW - what's the rationale behind storing xdp_prog in
> >> > xdp_dev_bulk_queue. Why can't you propagate the dst->xdp_prog and rely on
> >> > that without that local pointer?
> >> >
> >> > You probably have an answer for that, so maybe include it in commit
> >> > message.
> >> >
> >> > BTW same question for clearing dev_rx. To me this will be the same for all
> >> > bq_xmit_all() calls that will happen within same napi.
> >> 
> >> I think you're right: When bq_xmit_all() is called from bq_enqueue(),
> >> another packet will always be enqueued immediately after, so clearing
> >> out all of those things in bq_xmit_all() is redundant. This also
> >> includes the list_del on bq->flush_node, BTW.
> >> 
> >> And while we're getting into e micro-optimisations: In bq_enqueue() we
> >> have two checks:
> >> 
> >> 	if (!bq->dev_rx)
> >> 		bq->dev_rx = dev_rx;
> >> 
> >> 	bq->q[bq->count++] = xdpf;
> >> 
> >> 	if (!bq->flush_node.prev)
> >> 		list_add(&bq->flush_node, flush_list);
> >> 
> >> 
> >> those two if() checks can be collapsed into one, since the list and the
> >> dev_rx field are only ever modified together. This will also be the case
> >> for bq->xdp_prog, so putting all three under the same check in
> >> bq_enqueue() and only clearing them in __dev_flush() would be a win, I
> >> suppose - nice catch! :)

Huh, nice further optimization! :) Of course I agree on that.

> >
> > Thanks for the advice, so how about modify it like:
> 
> Yup, exactly! :)
> 
> -Toke
> 
