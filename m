Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5115659E2
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiGDPbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiGDPbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:31:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECADDE65;
        Mon,  4 Jul 2022 08:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656948706; x=1688484706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dzc35Y240MiRkwfn46iq+CERQnVr/1xCWoAYvTc52Aw=;
  b=iKNU38luCNc6YFb4QuOQpST1qI1WRJK19HKijQ+Y2lMYfSVcza4907ir
   eOP9JWQnOluEzv+OFvFPx2UVkDwEb0bIhL/aBqmDcvuGo8H+53quCoXzV
   AmI2wWiAnpgj5YoW4V7+1nOlzq3yFneUTEqKcpd8x/KdcKTXPuq43brUk
   9WQETElRzFHQbpxY376Stwow881XQ++wn9uEavOF7KedogP00DF9pr7xR
   uKWJAkcTN35ZYfk8NT1Rk32acfrwx4melQrmeHKGWbHNw8FRgvRQWqIYh
   AfoOZ+16+VDXIdIOSUVuyPgraQ8PHO/FM4jEELe4bdFePCUKzRkzPGjOn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="283884968"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="283884968"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 08:31:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="919399934"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jul 2022 08:31:41 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 264FVdq2026358;
        Mon, 4 Jul 2022 16:31:40 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce and use Generic Hints/metadata
Date:   Mon,  4 Jul 2022 17:31:13 +0200
Message-Id: <20220704153113.7370-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <62bbedf07f44a_2181420830@john.notmuch>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com> <62bbedf07f44a_2181420830@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain;
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Tue, 28 Jun 2022 23:15:12 -0700

> Alexander Lobakin wrote:
> > This RFC is to give the whole picture. It will most likely be split
> > onto several series, maybe even merge cycles. See the "table of
> > contents" below.
> 
> Even for RFC its a bit much. Probably improve the summary
> message here as well I'm still not clear on the overall
> architecture so not sure I want to dig into patches.

I wanted to give an overview to the whole code that I have for now.
We have several series on 30+, even 60+ next to this one, I'm not
sure I've seen a single "TL;DR" there. Same thing was with Matt's
folio series, there was 165+, ok he didn't send it as is to LKML,
but his words were "this is the first part, please take a look at
the whole concept here[link]".
I provided a "table of contents", so that anyone could go and
review only stuff he's interested in, not touching the rest.
My intention is that what if I submit the first part, then second,
and then at the third someone says he doesn't like the idea and
NACKs it, what then, if it all was supposed to work together as one?

> 
> > 
> > The series adds ability to pass different frame
> > details/parameters/parameters used by most of NICs and the kernel
> > stack (in skbs), not essential, but highly wanted, such as:
> > 
> > * checksum value, status (Rx) or command (Tx);
> > * hash value and type/level (Rx);
> > * queue number (Rx);
> > * timestamps;
> > * and so on.
> > 
> > As XDP structures used to represent frames are as small as possible
> > and must stay like that, it is done by using the already existing
> > concept of metadata, i.e. some space right before a frame where BPF
> > programs can put arbitrary data.
> 
> OK so you stick attributes in the metadata. You can do this without
> touching anything but your driver today. Why not push a patch to
> ice to start doing this? People could start using it today and put
> it in some feature flag.

We have to configure it somehow, doesn't we? Do a feature flag for
ice? Why doing anything "generic" then if I could just go with one
driver and send it through our Intel mailing list?

> 
> I get everyone wants some grand theory around this but again one
> patch would do it and your customers could start using it. Show
> a benchmark with 20% speedup or whatever with small XDP prog
> update and you win.

One patch would be a hardwiring/hardcoding everything on one button,
what's the point if there were several such examples?
This is RFC because the whole stuff needs to be discussed, not
because a have some drafts and want to show them. It's finished
and polished production-quality code which any vendor or customer
could start using without rehardcoding for their own
driver/needs/etc.
I'm not following this "TL;DR" stuff, one can just apply the series
and see how it goes/works for his needs (and then get back and
report) even if he's not feeling like reviewing it.

> 
> > 
> > Now, a NIC driver, or even a SmartNIC itself, can put those params
> > there in a well-defined format. The format is fixed, but can be of
> > several different types represented by structures, which definitions
> > are available to the kernel, BPF programs and the userland.
> 
> I don't think in general the format needs to be fixed.

We discussed it previously as well, not only in regards to this
stuff, but in general. For BPF programs, for sure we can CO-RE
everything, but we also have: a) in-kernel users not hardcoded to
a particular vendor/driver which just want to have generic fields
in one format for every driver; b) AF_XDP/XSk programs which you
can't CO-RE. There was a proposal from Alexei to patch LLVM to be
able to apply CO-RE for AF_XDP (I mean, for ARM64/x86_64/etc.
binaries) as well, but it's a whole different story with way more
caveats.

> 
> > It is fixed due to it being almost a UAPI, and the exact format can
> > be determined by reading the last 10 bytes of metadata. They contain
> > a 2-byte magic ID to not confuse it with a non-compatible meta and
> > a 8-byte combined BTF ID + type ID: the ID of the BTF where this
> > structure is defined and the ID of that definition inside that BTF.
> > Users can obtain BTF IDs by structure types using helpers available
> > in the kernel, BPF (written by the CO-RE/verifier) and the userland
> > (libbpf -> kernel call) and then rely on those ID when reading data
> > to make sure whether they support it and what to do with it.
> > Why separate magic and ID? The idea is to make different formats
> > always contain the basic/"generic" structure embedded at the end.
> > This way we can still benefit in purely generic consumers (like
> > cpumap) while providing some "extra" data to those who support it.
> 
> I don't follow this. If you have a struct in your driver name it
> something obvious, ice_xdp_metadata. If I understand things
> correctly just dump the BTF for the driver, extract the
> struct and done you can use CO-RE reads. For the 'fixed' case
> this looks easy. And I don't think you even need a patch for this.
> 
> > 
> > The enablement of this feature is controlled on attaching/replacing
> > XDP program on an interface with two new parameters: that combined
> > BTF+type ID and metadata threshold.
> > The threshold specifies the minimum frame size which a driver (or
> > NIC) should start composing metadata from. It is introduced instead
> > of just false/true flag due to that often it's not worth it to spend
> > cycles to fetch all that data for such small frames: let's say, it
> > can be even faster to just calculate checksums for them on CPU
> > rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
> > 15 Mpps on 64 byte frames with enabled metadata, threshold can help
> > mitigate that.
> 
> I would put this in the bonus category. Can you do the simple thing
> above without these extra bits and then add them later. Just
> pick some overly conservative threshold to start with.

It's as simple as adding on/off button, there's no reason to leave
it for later. Or is there?

> 
> > 
> > The RFC can be divided into 8 parts:
> 
> I'm missing something why not do the simplest bit of work and
> get this running in ice with a few smallish driver updates
> so we can all see it. No need for so many patches.

Ok I should've write this down in the cover: it's not a draft or
some hardcode to just show a PoC...

> 
> > 
> > 01-04: BTF ID hacking: here Larysa provides BPF programs with not
> >        only type ID, but the ID of the BTF as well by using the
> >        unused upper 32 bits.
> > 05-10: this provides in-kernel mechanisms for taking ID and
> >        threshold from the userspace and passing it to the drivers.
> > 11-18: provides libbpf API to be able to specify those params from
> >        the userspace, plus some small selftest to verify that both
> >        the kernel and the userspace parts work.
> > 19-29: here the actual structure is defined, then the in-kernel
> >        helpers and finally here comes the first consumer: function
> >        used to convert &xdp_frame to &sk_buff now will be trying
> >        to parse metadata. The affected users are cpumap and veth.
> > 30-36: here I try to benefit from the metadata in cpumap even more
> >        by switching it to GRO. Now that we have checksums from NIC
> >        available... but even with no meta it gives some fair
> >        improvements.
> > 37-43: enabling building generic metadata on Generic/skb path. Since
> >        skbs already have all those fields, it's not a problem to do
> >        this in here, plus allows to benefit from it on interfaces
> >        not supporting meta yet.
> > 44-47: ice driver part, including enabling prog hot-swap;
> > 48-52: adds a complex selftest to verify everything works. Can be
> >        used as a sample as well, showing how to work with metadata
> >        in BPF programs and how to configure it from the userspace.
> > 
> > Please refer to the actual commit messages where some precise
> > implementation details might be explained.
> > Nearly 20 of 52 are various cleanups and prereqs, as usually.
> > 
> > Perf figures were taken on cpumap redirect from the ice interface
> > (driver-side XDP), redirecting the traffic within the same node.
> > 
> > Frame size /   64/42  128/20  256/8  512/4  1024/2  1532/1
> > thread num
> 
> You'll have to remind me whats the production use case for
> cpu_map on a modern nic or even smart nic? Why are you not
> just using a hardware queues and redirecting to the right
> queues in hardware to start with?

Load balancing, you can distribute packets not only by flows, but
as you wish as you have full access to frames. Also, with RSS/RFS
you serve interrupts and push a frame through the networking stack
on the same CPU, with cpumap you can do the former on one and the
latter on another one, and it's obviously faster.

> 
> Also my understanding is if you do XDP_PASS up the stack
> the skb is built with all the normal good stuff from hw
> descriptor. Sorry going to need some extra context here
> to understand.

Correct, so this series makes cpumap on par (probably even better)
with just %XDP_PASS.

> 
> Could you do a benchmark for AF_XDP I thought this was
> the troublesome use case where the user space ring lost
> the hardware info e.g. timestamps and checksum values.

Ok sure, a bit later. I wasn't focusing on AF_XDP, but it's there
in the closest plans.

> 
> > 
> > meta off       30022  31350   21993  12144  6374    3610
> > meta on        33059  28502   21503  12146  6380    3610
> > GRO meta off   30020  31822   21970  12145  6384    3610
> > GRO meta on    34736  28848   21566  12144  6381    3610
> > 
> > Yes, redirect between the nodes plays awfully with the metadata
> > composed by the driver:
> 
> Many production use case use XDP exactly for this. If it
> slows this basic use case down its going to be very hard
> to use in many environments. Likely it wont be used.

Redirect between the nodes is not a good idea in general as you will
be working with remote memory each redirect. Not sure it's widely
used.
And yes, SmartNICs don't have that problem if they're capable of
composing arbitrary meta themselves.

> 
> > 
> > meta off       21449  18078   16897  11820  6383    3610
> > meta on        16956  19004   14337  8228   5683    2822
> > GRO meta off   22539  19129   16304  11659  6381    3592
> > GRO meta on    17047  20366   15435  8878   5600    2753
> 
> Do you have hardware that can write the data into the
> metadata region so you don't do it in software? Seems
> like it should be doable without much trouble and would
> make this more viable.

For now I personally don't, but: a) some people do; b) I will in
some time. IIRC, we were concering for both SmartNIC and "current
generation" NICs not giving favour to any of them.

> 
> > 
> > Questions still open:
> > 
> > * the actual generic structure: it must have all the fields used
> >   oftenly and by the majority of NICs. It can always be expanded
> >   later on (note that the structure grows to the left), but the
> >   less often UAPI is modified, the better (less compat pain);
> 
> I don't believe a generic structure is needed.

Please see above.

> 
> > * ability to specify the exact fields to fill by the driver, e.g.
> >   flags bitmap passed from the userspace. In theory it can be more
> >   optimal to not spend cycles on data we don't need, but at the
> >   same time increases the complexity of the whole concept (e.g. it
> >   will be more problematic to unify drivers' routines for collecting
> >   data from descriptors to metadata and to skbs);
> > * there was an idea to be able to specify from the userspace the
> >   desired cacheline offset, so that [the wanted fields of] metadata
> >   and the packet headers would lay in the same CL. Can't be
> >   implemented in Generic/skb XDP and ice has some troubles with it
> >   too;
> > * lacks AF_XDP/XSk perf numbers and different other scenarios in
> >   general, is the current implementation optimal for them?
> 
> AF_XDP is the primary use case from my understanding.

Not really, but is one of them.

> 
> > * metadata threshold and everything else present in this
> >   implementation.
> 
> I really think your asking questions that are two or three
> jumps away. Why not do the simplest bit first and kick
> the driver with an on/off switch into this mode. But
> I don't understand this cpumap use case so maybe explain
> that first.
> 
> And sorry didn't even look at your 50+ patches. Figure lets
> get agreement on the goal first.

"TL;DR" will kill open source once ._. As I said, you could just
pick whatever you want to look at, I never said "you, go and
review cpumap GRO stuff" to anyone.

> 
> .John

Thanks,
Olek
