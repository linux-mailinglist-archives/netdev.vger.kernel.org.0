Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD482DB384
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgLOSRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:17:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:5907 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbgLOSQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 13:16:55 -0500
IronPort-SDR: GF4LOZg/0kMJX/KUSBird20sXTkffx7US8OQxYeXV7G2R+xMJWi1A3jWCTdwubZKDg0rxhDiqP
 ZIaX0Uf7eJcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="172358596"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="172358596"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 10:16:14 -0800
IronPort-SDR: MRnosgKBBLZI3ZrdPNs7J7pKMfcCs0ejNncK4t2iU4CGdaGFH5edJnI/X/v0RXh2bYu40V5bVp
 RwTEMe6OztRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="336868302"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 15 Dec 2020 10:16:13 -0800
Date:   Tue, 15 Dec 2020 19:06:38 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the
 XDP ctx
Message-ID: <20201215180638.GB23785@ranger.igk.intel.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
 <20201208221746.GA33399@ranger.igk.intel.com>
 <96C89134-A747-4E05-AA11-CB6EA1420900@redhat.com>
 <20201209111047.GB36812@ranger.igk.intel.com>
 <170BF39B-894D-495F-93E0-820EC7880328@redhat.com>
 <38C60760-4F8C-43AC-A5DE-7FAECB65C310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38C60760-4F8C-43AC-A5DE-7FAECB65C310@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 02:28:39PM +0100, Eelco Chaudron wrote:
> 
> 
> On 9 Dec 2020, at 13:07, Eelco Chaudron wrote:
> 
> > On 9 Dec 2020, at 12:10, Maciej Fijalkowski wrote:
> 
> <SNIP>
> 
> > > > > > +
> > > > > > +		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 :
> > > > > > si->src_reg;
> > > > > > +		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
> > > > > > +			ctx_reg--;
> > > > > > +
> > > > > > +		/* Save scratch registers */
> > > > > > +		if (ctx_reg != si->src_reg) {
> > > > > > +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
> > > > > > +					      offsetof(struct xdp_buff,
> > > > > > +						       tmp_reg[1]));
> > > > > > +
> > > > > > +			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
> > > > > > +		}
> > > > > > +
> > > > > > +		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
> > > > > > +				      offsetof(struct xdp_buff, tmp_reg[0]));
> > > > > 
> > > > > Why don't you push regs to stack, use it and then pop it
> > > > > back? That way
> > > > > I
> > > > > suppose you could avoid polluting xdp_buff with tmp_reg[2].
> > > > 
> > > > There is no “real” stack in eBPF, only a read-only frame
> > > > pointer, and as we
> > > > are replacing a single instruction, we have no info on what we
> > > > can use as
> > > > scratch space.
> > > 
> > > Uhm, what? You use R10 for stack operations. Verifier tracks the
> > > stack
> > > depth used by programs and then it is passed down to JIT so that
> > > native
> > > asm will create a properly sized stack frame.
> > > 
> > > From the top of my head I would let know xdp_convert_ctx_access of a
> > > current stack depth and use it for R10 stores, so your scratch space
> > > would
> > > be R10 + (stack depth + 8), R10 + (stack_depth + 16).
> > 
> > Other instances do exactly the same, i.e. put some scratch registers in
> > the underlying data structure, so I reused this approach. From the
> > current information in the callback, I was not able to determine the
> > current stack_depth. With "real" stack above, I meant having a pop/push
> > like instruction.
> > 
> > I do not know the verifier code well enough, but are you suggesting I
> > can get the current stack_depth from the verifier in the
> > xdp_convert_ctx_access() callback? If so any pointers?
> 
> Maciej any feedback on the above, i.e. getting the stack_depth in
> xdp_convert_ctx_access()?

Sorry. I'll try to get my head around it. If i recall correctly stack
depth is tracked per subprogram whereas convert_ctx_accesses is iterating
through *all* insns (so a prog that is not chunked onto subprogs), but
maybe we could dig up the subprog based on insn idx.

But at first, you mentioned that you took the approach from other
instances, can you point me to them?

I'd also like to hear from Daniel/Alexei/John and others their thoughts.

> 
> > > Problem with that would be the fact that convert_ctx_accesses()
> > > happens to
> > > be called after the check_max_stack_depth(), so probably stack_depth
> > > of a
> > > prog that has frame_length accesses would have to be adjusted
> > > earlier.
> > 
> > Ack, need to learn more on the verifier part…
> 
> <SNIP>
> 
