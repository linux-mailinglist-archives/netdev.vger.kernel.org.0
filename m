Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35809108C55
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfKYKyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:54:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:37656 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfKYKyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:54:46 -0500
Received: from 11.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.11] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZBzu-0006fh-Ae; Mon, 25 Nov 2019 11:54:36 +0100
Date:   Mon, 25 Nov 2019 11:53:37 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
Message-ID: <20191125105337.GA14828@pc-9.home>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
 <20191123071226.6501-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191123071226.6501-2-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25644/Mon Nov 25 10:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 08:12:20AM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The BPF dispatcher is a multiway branch code generator, mainly
> targeted for XDP programs. When an XDP program is executed via the
> bpf_prog_run_xdp(), it is invoked via an indirect call. With
> retpolines enabled, the indirect call has a substantial performance
> impact. The dispatcher is a mechanism that transform multiple indirect
> calls to direct calls, and therefore avoids the retpoline. The
> dispatcher is generated using the BPF JIT, and relies on text poking
> provided by bpf_arch_text_poke().
> 
> The dispatcher hijacks a trampoline function it via the __fentry__ nop
> of the trampoline. One dispatcher instance currently supports up to 16
> dispatch points. This can be extended in the future.
> 
> An example: A module/driver allocates a dispatcher. The dispatcher is
> shared for all netdevs. Each unique XDP program has a slot in the
> dispatcher, registered by a netdev. The netdev then uses the
> dispatcher to call the correct program with a direct call.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
[...]
> +static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
> +{
> +	u8 *jg_reloc, *jg_target, *prog = *pprog;
> +	int pivot, err, jg_bytes = 1, cnt = 0;
> +	s64 jg_offset;
> +
> +	if (a == b) {
> +		/* Leaf node of recursion, i.e. not a range of indices
> +		 * anymore.
> +		 */
> +		EMIT1(add_1mod(0x48, BPF_REG_3));	/* cmp rdx,func */
> +		if (!is_simm32(progs[a]))
> +			return -1;
> +		EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3),
> +			    progs[a]);
> +		err = emit_cond_near_jump(&prog,	/* je func */
> +					  (void *)progs[a], prog,
> +					  X86_JE);
> +		if (err)
> +			return err;
> +
> +		err = emit_jump(&prog,			/* jmp thunk */
> +				__x86_indirect_thunk_rdx, prog);
> +		if (err)
> +			return err;
> +
> +		*pprog = prog;
> +		return 0;
> +	}
> +
> +	/* Not a leaf node, so we pivot, and recursively descend into
> +	 * the lower and upper ranges.
> +	 */
> +	pivot = (b - a) / 2;
> +	EMIT1(add_1mod(0x48, BPF_REG_3));		/* cmp rdx,func */
> +	if (!is_simm32(progs[a + pivot]))
> +		return -1;
> +	EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3), progs[a + pivot]);
> +
> +	if (pivot > 2) {				/* jg upper_part */
> +		/* Require near jump. */
> +		jg_bytes = 4;
> +		EMIT2_off32(0x0F, X86_JG + 0x10, 0);
> +	} else {
> +		EMIT2(X86_JG, 0);
> +	}
> +	jg_reloc = prog;
> +
> +	err = emit_bpf_dispatcher(&prog, a, a + pivot,	/* emit lower_part */
> +				  progs);
> +	if (err)
> +		return err;
> +
> +	/* Intel 64 and IA-32 ArchitecturesOptimization Reference
> +	 * Manual, 3.4.1.5 Code Alignment Assembly/Compiler Coding
> +	 * Rule 12. (M impact, H generality) All branch targets should
> +	 * be 16-byte aligned.

Isn't this section 3.4.1.4, rule 11 or are you reading a newer manual
than on the website [0]? :) Just wondering, in your IXIA tests, did you
see any noticeable slowdowns if you don't do the 16-byte alignments as
in the rest of the kernel [1,2]?

  [0] https://software.intel.com/sites/default/files/managed/9e/bc/64-ia-32-architectures-optimization-manual.pdf
  [1] be6cb02779ca ("x86: Align jump targets to 1-byte boundaries")
  [2] https://lore.kernel.org/patchwork/patch/560050/

> +	 */
> +	jg_target = PTR_ALIGN(prog, 16);
> +	if (jg_target != prog)
> +		emit_nops(&prog, jg_target - prog);
> +	jg_offset = prog - jg_reloc;
> +	emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
> +
> +	err = emit_bpf_dispatcher(&prog, a + pivot + 1,	/* emit upper_part */
> +				  b, progs);
> +	if (err)
> +		return err;
> +
> +	*pprog = prog;
> +	return 0;
> +}
