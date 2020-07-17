Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EA52239E7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQLCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:02:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:39762 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgGQLCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 07:02:38 -0400
IronPort-SDR: Nb+GI10Aa9nhretFbhK7jRqqxuOD24TMdi4GEtNKhACdBgKHQaOqUhlKEfc+Ik79URjvpU8IDH
 fqE6FrLrPhng==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="129653869"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="129653869"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 04:02:37 -0700
IronPort-SDR: pHbq/ebcCm1hQ8GatDLBFurXq9LgKkL9IzeSadcwZBbESEGldn8zCeG9H6xAd3YUgt53GBrVmK
 AvsZ8of4H93A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="308987836"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2020 04:02:35 -0700
Date:   Fri, 17 Jul 2020 12:57:44 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and tailcall
 handling in JIT
Message-ID: <20200717105744.GB11239@ranger.igk.intel.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-5-maciej.fijalkowski@intel.com>
 <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
 <20200717021624.do6mrxxr37vc7ajd@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717021624.do6mrxxr37vc7ajd@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 07:16:24PM -0700, Alexei Starovoitov wrote:
> On Fri, Jul 17, 2020 at 01:06:07AM +0200, Daniel Borkmann wrote:
> > > +				ret = bpf_arch_text_poke(poke->tailcall_bypass,
> > > +							 BPF_MOD_JUMP,
> > > +							 NULL, bypass_addr);
> > > +				BUG_ON(ret < 0 && ret != -EINVAL);
> > > +				/* let other CPUs finish the execution of program
> > > +				 * so that it will not possible to expose them
> > > +				 * to invalid nop, stack unwind, nop state
> > > +				 */
> > > +				synchronize_rcu();
> > 
> > Very heavyweight that we need to potentially call this /multiple/ times for just a
> > /single/ map update under poke mutex even ... but agree it's needed here to avoid
> > racing. :(
> 
> Yeah. I wasn't clear with my suggestion earlier.
> I meant to say that synchronize_rcu() can be done between two loops.
> list_for_each_entry(elem, &aux->poke_progs, list)
>    for (i = 0; i < elem->aux->size_poke_tab; i++)
>         bpf_arch_text_poke(poke->tailcall_bypass, ...
> synchronize_rcu();
> list_for_each_entry(elem, &aux->poke_progs, list)
>    for (i = 0; i < elem->aux->size_poke_tab; i++)
>         bpf_arch_text_poke(poke->poke->tailcall_target, ...
> 
> Not sure how much better it will be though.
> text_poke is heavy.
> I think it's heavier than synchronize_rcu().
> Long term we can do batch of text_poke-s.

Yeah since we introduce another poke target we could come up with
preparing the vector of pokes as you're saying?

> 
> I'm actually fine with above approach of synchronize_rcu() without splitting the loop.
> This kind of optimizations can be done later as a follow up.
> I'd really like to land this stuff in this bpf-next cycle.
> It's a big improvement to tail_calls and bpf2bpf calls.
