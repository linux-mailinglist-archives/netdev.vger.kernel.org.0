Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFCCC65F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfJDXRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:17:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41594 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbfJDXRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:17:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id p10so7360849qkg.8
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XxCI+i3Sr6S1rFWgAZkqRAgXhXSwN10+7XvCk5zOCQc=;
        b=2NSoejZpenBhfBVwmaaKHlnQ8jYRMNrz34MIHW34aEoltGuIrBXpJne07kiJBwRgTJ
         EcphEWvv4ygrfdynZEM03ceewtpnEr8rGF2ipFpf1/4sx0pQ7x7Bd0ZWwV7Y0fIf39p2
         DUv1pnRPsuTnu3Cka4CsJb224K9Th4v/PjcK8jWfmtTueI4Psd2kyYivInpxY4JSABM6
         vd6xp8qEIWcyzs/Ay8ODuhVFw2znq7I6Qha/XJ/MifiaD1S7tX0vf2fuBgUU4lE941JB
         ktlxNujNOg/P48O298Eza25pedzHTczAY4vam8ToLSPjXKuw4jHMJ4fLgooY5XndKaCx
         KpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XxCI+i3Sr6S1rFWgAZkqRAgXhXSwN10+7XvCk5zOCQc=;
        b=saD9+qSgR84UvkM/AlMIrDMAIB3Uwx/yHFvZN/ID3aYr+e336jVL8/WXRls/GpCC71
         qVr45DEkbZdCz369eJB1M781ackvmq7dziVr7oXtyoDxPsGFlWB0eoajyuV1Sw/OcX2/
         +VVzOkbRY4Aat2B57uZ9FzILWROy6A7GEDl16tnuf0gpfnaNyYbO/jNU5dsAVKO6esHL
         DYEFBijBnXjMOm9fi/lkMUP92DM3kHnbbeXGJRG/fpHRkfbltJE+Una6QNliODtLanpB
         nm2tvtqvMrcLXVSKjeE5dZ6AwOa/IzxpnLzdN5R1lCzhqBcO8sZs5/0CrzJGdS+rM8L9
         fZzQ==
X-Gm-Message-State: APjAAAWxS+1jFfJlUs6MJJ79zEcAVGyF6ArIa8Qfr/v8R5emnv+JEd5+
        8R2UOW6V0wrFjPg7Wo8HhSEd2w==
X-Google-Smtp-Source: APXvYqwlyT7C/YTD8ZIQ4SR4L9XIAaaHZHV9RX+7zXKeSy1TYeU52I4athYB+lHAqhA+tuSGFuAn/A==
X-Received: by 2002:a37:7d82:: with SMTP id y124mr12772294qkc.264.1570231040428;
        Fri, 04 Oct 2019 16:17:20 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a134sm3873856qkc.95.2019.10.04.16.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:17:20 -0700 (PDT)
Date:   Fri, 4 Oct 2019 16:17:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
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
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into
 BPF programs on load
Message-ID: <20191004161715.2dc7cbd9@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
        <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Oct 2019 19:22:41 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> This adds support for injecting chain call logic into eBPF programs before
> they return. The code injection is controlled by a flag at program load
> time; if the flag is set, the verifier will add code to every BPF_EXIT
> instruction that first does a lookup into a chain call structure to see if
> it should call into another program before returning. The actual calls
> reuse the tail call infrastructure.
>=20
> Ideally, it shouldn't be necessary to set the flag on program load time,
> but rather inject the calls when a chain call program is first loaded.
> However, rewriting the program reallocates the bpf_prog struct, which is
> obviously not possible after the program has been attached to something.

Very exciting stuff :)

Forgive my ignorance, isn't synchronize_rcu() enough to ensure old
image is no longer used?

For simple rewrites which don't require much context like the one here
it'd be cool to do it after loading..

> One way around this could be a sysctl to force the flag one (for enforcing
> system-wide support). Another could be to have the chain call support
> itself built into the interpreter and JIT, which could conceivably be
> re-run each time we attach a new chain call program. This would also allow
> the JIT to inject direct calls to the next program instead of using the
> tail call infrastructure, which presumably would be a performance win. The
> drawback is, of course, that it would require modifying all the JITs.
>=20
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..753abfb78c13 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -383,6 +383,7 @@ struct bpf_prog_aux {
>  	struct list_head ksym_lnode;
>  	const struct bpf_prog_ops *ops;
>  	struct bpf_map **used_maps;
> +	struct bpf_array *chain_progs;
>  	struct bpf_prog *prog;
>  	struct user_struct *user;
>  	u64 load_time; /* ns since boottime */
> @@ -443,6 +444,7 @@ struct bpf_array {
> =20
>  #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
>  #define MAX_TAIL_CALL_CNT 32
> +#define BPF_NUM_CHAIN_SLOTS 8

This could be user arg? Also the behaviour of mapping could be user
controlled? Perhaps even users could pass the snippet to map the return
code to the location, one day?

>  #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
>  				 BPF_F_RDONLY_PROG |	\
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77c6be96d676..febe8934d19a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -288,6 +288,12 @@ enum bpf_attach_type {
>  /* The verifier internal test flag. Behavior is undefined */
>  #define BPF_F_TEST_STATE_FREQ	(1U << 3)
> =20
> +/* Whether to enable chain call injection at program return. If set, the
> + * verifier will rewrite program returns to check for and jump to chain =
call
> + * programs configured with the BPF_PROG_CHAIN_* commands to the bpf sys=
call.
> + */
> +#define BPF_F_INJECT_CHAIN_CALLS	(1U << 4)
> +
>  /* When BPF ldimm64's insn[0].src_reg !=3D 0 then this can have
>   * two extensions:
>   *
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 66088a9e9b9e..98f1ad920e48 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -255,6 +255,16 @@ void __bpf_prog_free(struct bpf_prog *fp)
>  {
>  	if (fp->aux) {
>  		free_percpu(fp->aux->stats);
> +		if (fp->aux->chain_progs) {
> +			struct bpf_array *array =3D fp->aux->chain_progs;
> +			int i;
> +
> +			for (i =3D 0; i < BPF_NUM_CHAIN_SLOTS; i++)
> +				if (array->ptrs[i])
> +					bpf_prog_put(array->ptrs[i]);
> +
> +			bpf_map_area_free(array);
> +		}
>  		kfree(fp->aux);
>  	}
>  	vfree(fp);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 82eabd4e38ad..c2a49df5f921 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1630,7 +1630,8 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
>  	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
>  				 BPF_F_ANY_ALIGNMENT |
>  				 BPF_F_TEST_STATE_FREQ |
> -				 BPF_F_TEST_RND_HI32))
> +				 BPF_F_TEST_RND_HI32 |
> +				 BPF_F_INJECT_CHAIN_CALLS))
>  		return -EINVAL;
> =20
>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ffc3e53f5300..dbc9bbf13300 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9154,6 +9154,79 @@ static int fixup_bpf_calls(struct bpf_verifier_env=
 *env)
>  	return 0;
>  }
> =20
> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
> +{
> +	struct bpf_prog *prog =3D env->prog;
> +	struct bpf_insn *insn =3D prog->insnsi;
> +	int i, cnt, delta =3D 0, ret =3D -ENOMEM;
> +	const int insn_cnt =3D prog->len;
> +	struct bpf_array *prog_array;
> +	struct bpf_prog *new_prog;
> +	size_t array_size;
> +
> +	struct bpf_insn call_next[] =3D {
> +		BPF_LD_IMM64(BPF_REG_2, 0),
> +		/* Save real return value for later */
> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +		/* First try tail call with index ret+1 */
> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),

Don't we need to check against the max here, and spectre-proofing here?

> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> +		/* If that doesn't work, try with index 0 (wildcard) */
> +		BPF_MOV64_IMM(BPF_REG_3, 0),
> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> +		/* Restore saved return value and exit */
> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
> +		BPF_EXIT_INSN()
> +	};

> +	if (prog->aux->chain_progs)
> +		return 0;

Not sure why this check is here?

> +	array_size =3D sizeof(*prog_array) + BPF_NUM_CHAIN_SLOTS * sizeof(void*=
);
> +	prog_array =3D bpf_map_area_alloc(array_size, NUMA_NO_NODE);
> +
> +	if (!prog_array)
> +		goto out_err;
> +
> +	prog_array->elem_size =3D sizeof(void*);
> +	prog_array->map.max_entries =3D BPF_NUM_CHAIN_SLOTS;
> +
> +	call_next[0].imm =3D (u32)((u64) prog_array);
> +	call_next[1].imm =3D ((u64) prog_array) >> 32;
> +
> +	for (i =3D 0; i < insn_cnt; i++, insn++) {
> +		if (insn->code !=3D (BPF_JMP | BPF_EXIT))
> +			continue;

Mm.. don't subprogs also exit with JMP | EXIT?  This should only apply
to main prog, no?

> +		cnt =3D ARRAY_SIZE(call_next);
> +
> +		new_prog =3D bpf_patch_insn_data(env, i+delta, call_next, cnt);
> +		if (!new_prog) {
> +			goto out_err;
> +		}
> +
> +		delta    +=3D cnt - 1;
> +		env->prog =3D prog =3D new_prog;
> +		insn      =3D new_prog->insnsi + i + delta;
> +	}
> +
> +	/* If we chain call into other programs, we cannot make any assumptions
> +	 * since they can be replaced dynamically during runtime.
> +	 */
> +	prog->cb_access =3D 1;
> +	env->prog->aux->stack_depth =3D MAX_BPF_STACK;
> +	env->prog->aux->max_pkt_offset =3D MAX_PACKET_OFF;

Some refactoring & reuse of the normal tail call code could be nice?
Same for the hand allocation of the prog array actually :(

> +	prog->aux->chain_progs =3D prog_array;
> +	return 0;
> +
> +out_err:
> +	bpf_map_area_free(prog_array);
> +	return ret;
> +}
> +
> +
>  static void free_states(struct bpf_verifier_env *env)
>  {
>  	struct bpf_verifier_state_list *sl, *sln;
> @@ -9336,6 +9409,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_att=
r *attr,
>  	if (ret =3D=3D 0)
>  		ret =3D fixup_bpf_calls(env);
> =20
> +	if (ret =3D=3D 0 && (attr->prog_flags & BPF_F_INJECT_CHAIN_CALLS))
> +		ret =3D bpf_inject_chain_calls(env);
> +
>  	/* do 32-bit optimization after insn patching has done so those patched
>  	 * insns could be handled correctly.
>  	 */
>=20

