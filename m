Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E91347974
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhCXNU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:20:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:55486 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234852AbhCXNUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 09:20:10 -0400
IronPort-SDR: vqtXr38qjjINZ/SV90fGC9u6oE844BSs5H9oqq0yP9mmSISOjxEwiVA4nkq69m9cI+EHtmcMi0
 jmpnlsY+mQFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="178257396"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="178257396"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 06:20:08 -0700
IronPort-SDR: +BvFiJ81LORotHafL8+gXDF9is7UnaqfRprgC429p7UniZ/NGm7i4V/ONnw/q4mjPV4zBbF4hq
 3wt+mPd+pbeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="514185134"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 24 Mar 2021 06:20:06 -0700
Date:   Wed, 24 Mar 2021 14:09:18 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com
Subject: Re: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
Message-ID: <20210324130918.GA6932@ranger.igk.intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
 <20210322205816.65159-7-maciej.fijalkowski@intel.com>
 <87wnty7teq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wnty7teq.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 10:47:09PM +0100, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
> > Currently, if there are multiple xdpsock instances running on a single
> > interface and in case one of the instances is terminated, the rest of
> > them are left in an inoperable state due to the fact of unloaded XDP
> > prog from interface.
> >
> > Consider the scenario below:
> >
> > // load xdp prog and xskmap and add entry to xskmap at idx 10
> > $ sudo ./xdpsock -i ens801f0 -t -q 10
> >
> > // add entry to xskmap at idx 11
> > $ sudo ./xdpsock -i ens801f0 -t -q 11
> >
> > terminate one of the processes and another one is unable to work due to
> > the fact that the XDP prog was unloaded from interface.
> >
> > To address that, step away from setting bpf prog in favour of bpf_link.
> > This means that refcounting of BPF resources will be done automatically
> > by bpf_link itself.
> >
> > Provide backward compatibility by checking if underlying system is
> > bpf_link capable. Do this by looking up/creating bpf_link on loopback
> > device. If it failed in any way, stick with netlink-based XDP prog.
> > Otherwise, use bpf_link-based logic.
> 
> So how is the caller supposed to know which of the cases happened?
> Presumably they need to do their own cleanup in that case? AFAICT you're
> changing the code to always clobber the existing XDP program on detach
> in the fallback case, which seems like a bit of an aggressive change? :)

Sorry Toke, I was offline yesterday.
Yeah once again I went too far and we shouldn't do:

bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);

if xsk_lookup_bpf_maps(xsk) returned non-zero value which implies that the
underlying prog is not AF_XDP related.

closing prog_fd (and link_fd under the condition that system is bpf_link
capable) is enough for that case.

If we agree on that and there's nothing else that I missed, I'll send a
v4.

Thanks for review!

> 
> -Toke
> 
