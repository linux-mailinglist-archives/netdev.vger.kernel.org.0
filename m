Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E9272B3E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgIUQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:12:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:56281 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbgIUQMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:12:32 -0400
IronPort-SDR: MqHtZHQzCNjjlesA7nhzk4+LuQ2szVY6xef3bCzBYXHvyg/1JypCqdnIxGFurhvwa3FUp/2gUe
 JuEkSIP1XfDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="245261224"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="245261224"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:12:30 -0700
IronPort-SDR: PFGD7cxLtx6JSmQh/9xzoRoxUT3dNwg1ZsCx6L//MdStBZ/1a6fjfDJblGVWT2k9Nvg+mJYmQl
 i+wt/coDa7zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="454105387"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2020 09:12:28 -0700
Date:   Mon, 21 Sep 2020 18:05:37 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
Message-ID: <20200921160537.GA31703@ranger.igk.intel.com>
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 08:26:34PM -0700, Alexei Starovoitov wrote:
> On Wed, Sep 16, 2020 at 2:16 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Changelog:
> >
> > v7->v8:
> > - teach bpf_patch_insn_data to adjust insn_idx of tailcall insn
> > - address case of clearing tail call counter when bpf2bpf with tailcalls
> >   are mixed
> > - drop unnecessary checks against cbpf in JIT
> > - introduce more tailcall_bpf2bpf[X] selftests that are making sure the
> >   combination of tailcalls with bpf2bpf calls works correctly
> > - add test cases to test_verifier to make sure logic from
> >   check_max_stack_depth that limits caller's stack depth down to 256 is
> >   correct
> > - move the main patch to appear after the one that limits the caller's
> >   stack depth so that 'has_tail_call' can be used by 'tail_call_reachable'
> >   logic
> 
> Thanks a lot for your hard work on this set. 5 month effort!

Thanks for the whole collaboration! It was quite a ride :)

> I think it's a huge milestone that will enable cilium, cloudflare, katran to
> use bpf functions. Removing always_inline will improve performance.
> Switching to global functions with function-by-function verification
> will drastically improve program load times.
> libbpf has full support for subprogram composition and call relocations.
> Until now these verifier and libbpf features were impossible to use in XDP
> programs, since most of them use tail_calls.
> It's great to see all these building blocks finally coming together.
> 
> I've applied the set with few changes.
> In patch 4 I've removed ifdefs and redundant ().
> In patch 5 removed redundant !tail_call_reachable check.
> In patch 6 replaced CONFIG_JIT_ALWAYS_ON dependency with
> jit_requested && IS_ENABLED(CONFIG_X86_64).
> It's more user friendly.
> I also added patch 7 that checks that ld_abs and tail_call are only
> allowed in subprograms that return 'int'.

Thank you for this last touch! I went through patches and I agree with the
changes.

> I felt that the fix is simple enough, so I just pushed it, since
> without it the set is not safe. Please review it here:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=09b28d76eac48e922dc293da1aa2b2b85c32aeee

LGTM.

> I'll address any issues in the followups.
> Because of the above changes I tweaked patch 8 to increase test coverage
> with ld_abs and combination of global/static subprogs.
> Also did s/__attribute__((noinline))/__noinline/.
> 
> John and Daniel,
> I wasn't able to test it on cilium programs.
> When you have a chance please give it a thorough run.
> tail_call poke logic is delicate.
> 
> Lorenz,
> if you can test it on cloudflare progs would be awesome.
> 
> Thanks a lot everyone!
