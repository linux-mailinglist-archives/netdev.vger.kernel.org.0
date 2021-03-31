Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9734FCCE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhCaJ3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCaJ2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 05:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CA561606;
        Wed, 31 Mar 2021 09:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617182930;
        bh=Y2KIGR+vQOCwkenByF8/05tg8IxGcotlykRYxJa4B7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HalLlvoWduM+QwONzIW12DvynzvUjVAvjRpYA+RzP4smHbvZtPKvPkMUSlZQJzYc5
         AgkNYA76ZX8DlbphlosWeakn2beANedWUdKS5BlsacO4qrgSz1T4RzpEjym/HNKEnF
         gCyxUWhDJ6LJv240kr11HyxaeWR1nsswPE7ktzO+boJGpEwS2sx/riblCmpNh6FHO+
         jNyQMnJIpmIaO5O96UFaA5cOycA+SU0Vxli5UFIMPmoc0RlSn+TrNd0ddTi5b8sP3R
         wR6x2DvpXnTxntemhmle0bxHp0b1GT8jy81nzhYPJqeYxT/ytu+vEMUrv3E1rx+BNF
         4yxmIl7kiKiFQ==
Date:   Wed, 31 Mar 2021 10:28:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Jianlin Lv <iecedge@gmail.com>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        zlim.lnx@gmail.com, catalin.marinas@arm.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH bpf-next] bpf: arm64: Redefine MOV consistent with arch
 insn
Message-ID: <20210331092844.GA7205@willie-the-truck>
References: <20210330074235.525747-1-Jianlin.Lv@arm.com>
 <20210330093149.GA5281@willie-the-truck>
 <CAFA-uR8_N=RHbhm4PdiB-AMCBdXsoMyM-9WgaPxPQ7-ZF6ujXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA-uR8_N=RHbhm4PdiB-AMCBdXsoMyM-9WgaPxPQ7-ZF6ujXA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 05:22:18PM +0800, Jianlin Lv wrote:
> On Tue, Mar 30, 2021 at 5:31 PM Will Deacon <will@kernel.org> wrote:
> >
> > On Tue, Mar 30, 2021 at 03:42:35PM +0800, Jianlin Lv wrote:
> > > A64_MOV is currently mapped to Add Instruction. Architecturally MOV
> > > (register) is an alias of ORR (shifted register) and MOV (to or from SP)
> > > is an alias of ADD (immediate).
> > > This patch redefines A64_MOV and uses existing functionality
> > > aarch64_insn_gen_move_reg() in insn.c to encode MOV (register) instruction.
> > > For moving between register and stack pointer, rename macro to A64_MOV_SP.
> >
> > What does this gain us? There's no requirement for a BPF "MOV" to match an
> > arm64 architectural "MOV", so what's the up-side of aligning them like this?
> 
> According to the description in the Arm Software Optimization Guide,
> Arithmetic(basic) and Logical(basic) instructions have the same
> Exec Latency and Execution Throughput.
> This change did not bring about a performance improvement.
> The original intention was to make the instruction map more 'natively'.

I think we should leave the code as-is, then. Having a separate MOV_SP
macro s confusing and, worse, I worry that somebody passing A64_SP to
A64_MOV will end up using the zero register.

Will
