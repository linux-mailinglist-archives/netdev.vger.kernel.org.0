Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0054E592
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377747AbiFPPCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377502AbiFPPCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:02:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EC83FDBA;
        Thu, 16 Jun 2022 08:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655391743; x=1686927743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cPIvtGkzUaCtMm3FU+yIhMsE21kpvjfDBJRq5gORsFE=;
  b=EYwuygfNWQ+BE3jz+nte2gYiUNYTiVJB8db7hF9V0MnKU6bzeU8oOeSl
   OQe+rcl4YFzGWTipJ0WH+esfuKO3AelN+Mxg2aMDogA52D5KBZxhnYPAk
   OZ2jlFT4owFE+oOAhP3Um15OL/mTDXawxHs+lKncpKGbQfC25sh3HmCEv
   f/W0L4awfoXXEKzFzBeNYGSeOSeDKk6fY2UDxGitd9JKi8+Mw9nhwQiV5
   jhZow2o7SKwPtapZ4sSUJtYRO3T9NYYKwfeAfqZ7MMlzME2Sh2OuXV+jw
   TE5hIL6r7KCRhkoOqOoSaigyuMCx+9Ck5usv0ABYaipzpepID5kNXObbB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="279981317"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="279981317"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="912192935"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2022 08:01:55 -0700
Date:   Thu, 16 Jun 2022 17:01:55 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Fix tail call count offset
 calculation on bpf2bpf call
Message-ID: <YqtF4/1nNLfO/6Pn@boxer>
References: <20220615151721.404596-1-jakub@cloudflare.com>
 <20220615151721.404596-2-jakub@cloudflare.com>
 <c19ed052-90ea-3bf5-c57c-7879844579ea@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c19ed052-90ea-3bf5-c57c-7879844579ea@iogearbox.net>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 04:45:09PM +0200, Daniel Borkmann wrote:
> On 6/15/22 5:17 PM, Jakub Sitnicki wrote:
> [...]
> > int entry(struct __sk_buff * skb):
> >     0xffffffffa0201788:  nop    DWORD PTR [rax+rax*1+0x0]
> >     0xffffffffa020178d:  xor    eax,eax
> >     0xffffffffa020178f:  push   rbp
> >     0xffffffffa0201790:  mov    rbp,rsp
> >     0xffffffffa0201793:  sub    rsp,0x8
> >     0xffffffffa020179a:  push   rax
> >     0xffffffffa020179b:  xor    esi,esi
> >     0xffffffffa020179d:  mov    BYTE PTR [rbp-0x1],sil
> >     0xffffffffa02017a1:  mov    rax,QWORD PTR [rbp-0x9]	!!! tail call count
> >     0xffffffffa02017a8:  call   0xffffffffa02017d8       !!! is at rbp-0x10
> >     0xffffffffa02017ad:  leave
> >     0xffffffffa02017ae:  ret
> > 
> > Fix it by rounding up the BPF stack depth to a multiple of 8, when
> > calculating the tail call count offset on stack.
> > 
> > Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index f298b18a9a3d..c98b8c0ed3b8 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1420,8 +1420,9 @@ st:			if (is_imm8(insn->off))
> >   		case BPF_JMP | BPF_CALL:
> >   			func = (u8 *) __bpf_call_base + imm32;
> >   			if (tail_call_reachable) {
> > +				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
> >   				EMIT3_off32(0x48, 0x8B, 0x85,
> > -					    -(bpf_prog->aux->stack_depth + 8));
> > +					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);
> 
> Lgtm, great catch by the way!

Indeed!

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I was wondering if it would be possible to work only on rounded up to 8
stack depth from JIT POV since it's what we do everywhere we use it...
