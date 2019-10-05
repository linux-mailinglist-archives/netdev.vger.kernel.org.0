Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2915CC95B
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 12:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfJEK3V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 06:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfJEK3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 06:29:20 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87752C001F03
        for <netdev@vger.kernel.org>; Sat,  5 Oct 2019 10:29:19 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id l13so2361321lji.7
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 03:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=5ld6mvaTaFysits5sS/BQg6PZgIZJXXNnUbaRYN6pRE=;
        b=r7BcZ/24ZyATp6f3reIUUKgQr00DcHtzPVZ4EUfDMfr66gj1bio4rDg1Q7rc+ZuA1r
         ZO+ak/88dCGOT9e+zGSRe3PSvE5Vvll97Tmq8rShYaDXrVXiS1Nj9kBrnJOsuHdz6iv3
         lzw10u+EpKVhKMPE+5eeXnBj6Ggqzi/rdQfSDzUwZzMXrAFKbCrfpP5QJja8C8BLTu/O
         67/De3g4n18Vgo00gL7BEbgAZIt5zLrqnN/ECVlDUOg40lBZ5aVbha+gQutdCGAHGMet
         /n4g7lmo2Ksz7o1o1Ntc5VA/Q+t0clQUZWpWs9FzVwxtZsPyQwIqI4ngycyJwBdi+WQS
         Pa6w==
X-Gm-Message-State: APjAAAW5B9GnhFx+5XlnGKJmRkEWTt8vf1ICCerem6LET+gtpzxk9xcA
        +4ifRBeuIXTW+W7yzDsxFIeyfrTy3PKuwEDnBYHFj/nPzsH6kh7fUTmT9HyRuOkULsgdtdoRpgd
        tM7drHp2BqfGOVdvN
X-Received: by 2002:ac2:4902:: with SMTP id n2mr11689798lfi.0.1570271357855;
        Sat, 05 Oct 2019 03:29:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwZNCrJEMOF4tSr+Ilbe21VpkrggmSf12Y10g7t8HuAeMjj8dSV2sdYxTDAu7apiNHhBDgNnA==
X-Received: by 2002:ac2:4902:: with SMTP id n2mr11689780lfi.0.1570271357477;
        Sat, 05 Oct 2019 03:29:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id q19sm2167601lfj.9.2019.10.05.03.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 03:29:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E8A0A18063D; Sat,  5 Oct 2019 12:29:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into BPF programs on load
In-Reply-To: <20191004161715.2dc7cbd9@cakuba.hsd1.ca.comcast.net>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1> <157020976144.1824887.10249946730258092768.stgit@alrua-x1> <20191004161715.2dc7cbd9@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 05 Oct 2019 12:29:14 +0200
Message-ID: <87d0fbo58l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Fri, 04 Oct 2019 19:22:41 +0200, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> This adds support for injecting chain call logic into eBPF programs before
>> they return. The code injection is controlled by a flag at program load
>> time; if the flag is set, the verifier will add code to every BPF_EXIT
>> instruction that first does a lookup into a chain call structure to see if
>> it should call into another program before returning. The actual calls
>> reuse the tail call infrastructure.
>> 
>> Ideally, it shouldn't be necessary to set the flag on program load time,
>> but rather inject the calls when a chain call program is first loaded.
>> However, rewriting the program reallocates the bpf_prog struct, which is
>> obviously not possible after the program has been attached to something.
>
> Very exciting stuff :)
>
> Forgive my ignorance, isn't synchronize_rcu() enough to ensure old
> image is no longer used?

Because it's reallocating the 'struct bpf_prog*'. Which is what we pass
into the driver on XDP attach. So we'd have to track down all the uses
and replace the pointer.

At least, that's how I read the code; am I missing something?

> For simple rewrites which don't require much context like the one here
> it'd be cool to do it after loading..

I think re-jit'ing is probably doable, which is why I kinda want the
support in the JIT. We could also conceivably just stick in some NOP
instructions in the eBPF byte code on load and then replace them
dynamically later?

>> One way around this could be a sysctl to force the flag one (for enforcing
>> system-wide support). Another could be to have the chain call support
>> itself built into the interpreter and JIT, which could conceivably be
>> re-run each time we attach a new chain call program. This would also allow
>> the JIT to inject direct calls to the next program instead of using the
>> tail call infrastructure, which presumably would be a performance win. The
>> drawback is, of course, that it would require modifying all the JITs.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 5b9d22338606..753abfb78c13 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -383,6 +383,7 @@ struct bpf_prog_aux {
>>  	struct list_head ksym_lnode;
>>  	const struct bpf_prog_ops *ops;
>>  	struct bpf_map **used_maps;
>> +	struct bpf_array *chain_progs;
>>  	struct bpf_prog *prog;
>>  	struct user_struct *user;
>>  	u64 load_time; /* ns since boottime */
>> @@ -443,6 +444,7 @@ struct bpf_array {
>>  
>>  #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
>>  #define MAX_TAIL_CALL_CNT 32
>> +#define BPF_NUM_CHAIN_SLOTS 8
>
> This could be user arg? Also the behaviour of mapping could be user
> controlled? Perhaps even users could pass the snippet to map the return
> code to the location, one day?
>
>>  #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
>>  				 BPF_F_RDONLY_PROG |	\
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 77c6be96d676..febe8934d19a 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -288,6 +288,12 @@ enum bpf_attach_type {
>>  /* The verifier internal test flag. Behavior is undefined */
>>  #define BPF_F_TEST_STATE_FREQ	(1U << 3)
>>  
>> +/* Whether to enable chain call injection at program return. If set, the
>> + * verifier will rewrite program returns to check for and jump to chain call
>> + * programs configured with the BPF_PROG_CHAIN_* commands to the bpf syscall.
>> + */
>> +#define BPF_F_INJECT_CHAIN_CALLS	(1U << 4)
>> +
>>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>>   * two extensions:
>>   *
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 66088a9e9b9e..98f1ad920e48 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -255,6 +255,16 @@ void __bpf_prog_free(struct bpf_prog *fp)
>>  {
>>  	if (fp->aux) {
>>  		free_percpu(fp->aux->stats);
>> +		if (fp->aux->chain_progs) {
>> +			struct bpf_array *array = fp->aux->chain_progs;
>> +			int i;
>> +
>> +			for (i = 0; i < BPF_NUM_CHAIN_SLOTS; i++)
>> +				if (array->ptrs[i])
>> +					bpf_prog_put(array->ptrs[i]);
>> +
>> +			bpf_map_area_free(array);
>> +		}
>>  		kfree(fp->aux);
>>  	}
>>  	vfree(fp);
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 82eabd4e38ad..c2a49df5f921 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -1630,7 +1630,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>>  	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
>>  				 BPF_F_ANY_ALIGNMENT |
>>  				 BPF_F_TEST_STATE_FREQ |
>> -				 BPF_F_TEST_RND_HI32))
>> +				 BPF_F_TEST_RND_HI32 |
>> +				 BPF_F_INJECT_CHAIN_CALLS))
>>  		return -EINVAL;
>>  
>>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index ffc3e53f5300..dbc9bbf13300 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -9154,6 +9154,79 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>>  	return 0;
>>  }
>>  
>> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
>> +{
>> +	struct bpf_prog *prog = env->prog;
>> +	struct bpf_insn *insn = prog->insnsi;
>> +	int i, cnt, delta = 0, ret = -ENOMEM;
>> +	const int insn_cnt = prog->len;
>> +	struct bpf_array *prog_array;
>> +	struct bpf_prog *new_prog;
>> +	size_t array_size;
>> +
>> +	struct bpf_insn call_next[] = {
>> +		BPF_LD_IMM64(BPF_REG_2, 0),
>> +		/* Save real return value for later */
>> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
>> +		/* First try tail call with index ret+1 */
>> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
>
> Don't we need to check against the max here, and spectre-proofing
> here?

No, I don't think so. This is just setting up the arguments for the
BPF_TAIL_CALL instruction below. The JIT will do its thing with that and
emit the range check and the retpoline stuff...

>> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
>> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> +		/* If that doesn't work, try with index 0 (wildcard) */
>> +		BPF_MOV64_IMM(BPF_REG_3, 0),
>> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> +		/* Restore saved return value and exit */
>> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
>> +		BPF_EXIT_INSN()
>> +	};
>
>> +	if (prog->aux->chain_progs)
>> +		return 0;
>
> Not sure why this check is here?

In preparation for being able to call this function multiple times when
attaching the chain call program :)

>> +	array_size = sizeof(*prog_array) + BPF_NUM_CHAIN_SLOTS * sizeof(void*);
>> +	prog_array = bpf_map_area_alloc(array_size, NUMA_NO_NODE);
>> +
>> +	if (!prog_array)
>> +		goto out_err;
>> +
>> +	prog_array->elem_size = sizeof(void*);
>> +	prog_array->map.max_entries = BPF_NUM_CHAIN_SLOTS;
>> +
>> +	call_next[0].imm = (u32)((u64) prog_array);
>> +	call_next[1].imm = ((u64) prog_array) >> 32;
>> +
>> +	for (i = 0; i < insn_cnt; i++, insn++) {
>> +		if (insn->code != (BPF_JMP | BPF_EXIT))
>> +			continue;
>
> Mm.. don't subprogs also exit with JMP | EXIT?  This should only apply
> to main prog, no?

Hmm, no idea? If it does, you're right of course. Guess I'll try to
figure that out...

>> +		cnt = ARRAY_SIZE(call_next);
>> +
>> +		new_prog = bpf_patch_insn_data(env, i+delta, call_next, cnt);
>> +		if (!new_prog) {
>> +			goto out_err;
>> +		}
>> +
>> +		delta    += cnt - 1;
>> +		env->prog = prog = new_prog;
>> +		insn      = new_prog->insnsi + i + delta;
>> +	}
>> +
>> +	/* If we chain call into other programs, we cannot make any assumptions
>> +	 * since they can be replaced dynamically during runtime.
>> +	 */
>> +	prog->cb_access = 1;
>> +	env->prog->aux->stack_depth = MAX_BPF_STACK;
>> +	env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
>
> Some refactoring & reuse of the normal tail call code could be nice?
> Same for the hand allocation of the prog array actually :(

See above; this is actually just setting up the arguments to reuse the
tail call logic. I'll try to make that clearer...

Most other places that do these kinds of smallish code injections seem
to be hand-coding the instructions; what else would I do?

-Toke
