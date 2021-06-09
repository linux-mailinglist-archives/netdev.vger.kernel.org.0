Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1B3A1B0C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhFIQfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:35:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:21173 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhFIQfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 12:35:37 -0400
IronPort-SDR: KodCqx9GWWi+nVnJkDfqrVdpqOcJ6cR/lZ3vFOBseRh6Oqy/Dha5/z0QqlcHWeAcSC1VUsIql7
 2kunFW6zX/yA==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="290739938"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="290739938"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 09:33:40 -0700
IronPort-SDR: hPuEAVrs68tdOfGu7fByPS1wrajql9AVvmjTaGdCNlf69gS5i3JsLAkIaqZE5D2bSeFxhHeOPn
 cxxKyAPpNCgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="448343988"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 09 Jun 2021 09:33:37 -0700
Date:   Wed, 9 Jun 2021 18:21:08 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf 2/2] bpf: selftest to verify mixing bpf2bpf calls and
 tailcalls with insn patch
Message-ID: <20210609162108.GA12650@ranger.igk.intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318063321.323820.18256758193426055338.stgit@john-XPS-13-9370>
 <20210609155704.GB12061@ranger.igk.intel.com>
 <60c0eb99aa8c2_98621208ad@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60c0eb99aa8c2_98621208ad@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:26:01AM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > On Tue, Jun 08, 2021 at 12:30:33PM -0700, John Fastabend wrote:
> > > This adds some extra noise to the tailcall_bpf2bpf4 tests that will cause
> > > verifier to patch insns. This then moves around subprog start/end insn
> > > index and poke descriptor insn index to ensure that verify and JIT will
> > > continue to track these correctly.
> > 
> > This test is the most complicated one where I tried to document the scope
> > of it on the side of prog_tests/tailcalls.c. I feel that it would make it
> > more difficult to debug it if under any circumstances something would have
> > been broken with that logic.
> > 
> > Maybe a separate test scenario? Or is this an overkill? If so, I would
> > vote for moving it to tailcall_bpf2bpf1.c and have a little comment that
> > testing other bpf helpers mixed in is in scope of that test.
> 
> I like pushing it into the complex test to get the most instruction
> patching combinations possible.

Makes sense after a second thought, that was the intention of that test
case, to squeeze out the feature out here.

I still would ask to have it commented on the prog_tests/tailcalls.c side,
WDYT?

> 
> > 
> > > 
> > > Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> > >  .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > > index 9a1b166b7fbe..0d70de5f97e2 100644
> > > --- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > > +++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > > @@ -2,6 +2,13 @@
> > >  #include <linux/bpf.h>
> > >  #include <bpf/bpf_helpers.h>
> > >  
> > > +struct {
> > > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > > +	__uint(max_entries, 1);
> > > +	__uint(key_size, sizeof(__u32));
> > > +	__uint(value_size, sizeof(__u32));
> > > +} nop_table SEC(".maps");
> > > +
> > >  struct {
> > >  	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> > >  	__uint(max_entries, 3);
> > > @@ -11,9 +18,19 @@ struct {
> > >  
> > >  static volatile int count;
> > >  
> > > +__noinline
> > > +int subprog_noise(struct __sk_buff *skb)
> > > +{
> > > +	__u32 key = 0;
> > > +
> > > +	bpf_map_lookup_elem(&nop_table, &key);
> > > +	return 0;
> > > +}
> > > +
> > >  __noinline
> > >  int subprog_tail_2(struct __sk_buff *skb)
> > >  {
> > > +	subprog_noise(skb);
> > >  	bpf_tail_call_static(skb, &jmp_table, 2);
> > >  	return skb->len * 3;
> > >  }
> > > 
> > > 
> 
> 
