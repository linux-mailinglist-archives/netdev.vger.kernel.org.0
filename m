Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD78FD6CB
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOHOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:14:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:58974 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfKOHOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:14:01 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVVnr-0002xW-CQ; Fri, 15 Nov 2019 08:13:59 +0100
Date:   Fri, 15 Nov 2019 08:13:58 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog
 array pokes
Message-ID: <20191115071358.GA3957@pc-9.home>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
 <20191115042939.ckt4fqvtfdi344y2@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115042939.ckt4fqvtfdi344y2@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 08:29:41PM -0800, Alexei Starovoitov wrote:
> On Fri, Nov 15, 2019 at 02:04:02AM +0100, Daniel Borkmann wrote:
> > Add tracking of constant keys into tail call maps. The signature of
> > bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
> > is a index key. The direct call approach for tail calls can be enabled
> > if the verifier asserted that for all branches leading to the tail call
> > helper invocation, the map pointer and index key were both constant
> > and the same. Tracking of map pointers we already do from prior work
> > via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
> > speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
> > delete calls on maps"). Given the tail call map index key is not on
> > stack but directly in the register, we can add similar tracking approach
> > and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
> > with the relevant information for the JITing phase. We internally reuse
> > insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
> > to point into the prog's poke_tab and keep insn->imm == 0 as indicator
> > that current indirect tail call emission must be used.
> > 
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > ---
> >  include/linux/bpf_verifier.h |  1 +
> >  kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 99 insertions(+)
> > 
> > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > index cdd08bf0ec06..f494f0c9ac13 100644
> > --- a/include/linux/bpf_verifier.h
> > +++ b/include/linux/bpf_verifier.h
> > @@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
> >  			u32 map_off;		/* offset from value base address */
> >  		};
> >  	};
> > +	u64 key_state; /* constant key tracking for maps */
> 
> may be map_key_state ?
> key_state is a bit ambiguous in the bpf_insn_aux_data.

Could be, alternatively could also be idx_state or map_idx_state since
it's really just for u32 type key indices.

> > +static int
> > +record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> > +		int func_id, int insn_idx)
> > +{
> > +	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
> > +	struct bpf_reg_state *regs = cur_regs(env), *reg;
> > +	struct tnum range = tnum_range(0, U32_MAX);
> > +	struct bpf_map *map = meta->map_ptr;
> > +	u64 val;
> > +
> > +	if (func_id != BPF_FUNC_tail_call)
> > +		return 0;
> > +	if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
> > +		verbose(env, "kernel subsystem misconfigured verifier\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	reg = &regs[BPF_REG_3];
> > +	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
> > +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> > +		return 0;
> > +	}
> > +
> > +	val = reg->var_off.value;
> > +	if (bpf_map_key_unseen(aux))
> > +		bpf_map_key_store(aux, val);
> > +	else if (bpf_map_key_immediate(aux) != val)
> > +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> > +	return 0;
> > +}
> 
> I think this analysis is very useful in other cases as well. Could you
> generalize it for array map lookups ? The key used in bpf_map_lookup_elem() for
> arrays is often constant. In such cases we can optimize array_map_gen_lookup()
> into absolute pointer. It will be possible to do
> if (idx < max_entries) ptr += idx * elem_size;
> during verification instead of runtime and the whole
> bpf_map_lookup_elem(map, &key); will become single instruction that
> assigns &array[idx] into R0.

Was thinking exactly the same. ;-) I started coding this yesterday night [0],
but then had the (in hinsight obvious) realization that as-is the key_state
holds the address but not the index for plain array map lookup. Hence I'd need
to go a step further there to look at the const stack content. Will proceed on
this as a separate set on top.

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/bpf.git/commit/?h=pr/bpf-tail-call-rebased2&id=b86b7eae4646d8233e3e9058e68fef27536bf0c4

Thanks,
Daniel
