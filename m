Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700237E6EF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390500AbfHAXug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:50:36 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41252 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731376AbfHAXuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:50:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so34974931pff.8;
        Thu, 01 Aug 2019 16:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ILltP4pawog108CDtnFkAicndYwTMJ/m9ELSEhuHDyI=;
        b=SXUCWFB5ON9vIMhIrlJZXXRIoCIq6Pq9upabWftfXgZ7EYOUHPRXS0AUM2Lt21zvF3
         YMaa1QSHVh/rxtsKTgAdgXRWkdVa2h5MDiGm8TOb0KlC40vHVnbDzr4UB3AdVbRzYyrx
         zjvPVEFxT03XLqLYnB4Doup7VQJFmpuSTkS9RCGrkXzeAie+Yi3Q2Onw4Ww/k7vweIxq
         Qj0rScSVkYcBbzlPK+k2xSz+9KgqDpuVTSfkr00uM6omkXsTZEH23xsJL087f35Pq5fd
         XoTp91sWy7a3DN+RiHrmQ1FV1bEsz2bSoXVR9hFzYVz8ymj/x0VMASrNgeTZj0jXPjdx
         2g2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ILltP4pawog108CDtnFkAicndYwTMJ/m9ELSEhuHDyI=;
        b=tHZtP4bQlZ32Q69bmmAS3KK/wVtGdGVxMZQO43I4ULdKOh+TGvu6DSM7DDVWMNLZ5i
         Fffq1eOhjLn5t5dziF39DvU0B9s6efmSDqrh6NxKZxez1DKqS1T8kAF+wz6Yx0IQaUty
         3mpNa9lereRwj/I/kKIvoBjXfzTXEuEIVNZ7JJWOLvSwCz/xKG0h1DXpsQToHuA+YvVw
         2iw5v6X9fi6Dp9mT3Z8LjRmixu6lFDAcNi5a2/M6+WxHG9wSGNNcc2VfeLn8VQ6240FZ
         xBY6g8h28/YsjJA03UW30AjojEwAPuF4BKJPD76OciUhOptH0QTQXS1RXINBpj/oOK5U
         y3rQ==
X-Gm-Message-State: APjAAAU0SQH15MmM81iFccCBmMmZ73Rn22gZ1rqxbZ8nmx4PuXd8pLan
        2VtRKSaKmR/X4P9B4Dku1BI=
X-Google-Smtp-Source: APXvYqwLIqNlzTskCENRwMCBIVFqYC9TSZtTD8L32HszKlkfDfLYxq2zGdFLSLscM32fVRiNqzZXEw==
X-Received: by 2002:a17:90a:cb81:: with SMTP id a1mr1300543pju.81.1564703434521;
        Thu, 01 Aug 2019 16:50:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:f96b])
        by smtp.gmail.com with ESMTPSA id i7sm4911043pjk.24.2019.08.01.16.50.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 16:50:33 -0700 (PDT)
Date:   Thu, 1 Aug 2019 16:50:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, songliubraving@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Message-ID: <20190801235030.bzssmwzuvzdy7h7t@ast-mbp.dhcp.thefacebook.com>
References: <20190801064803.2519675-1-andriin@fb.com>
 <20190801064803.2519675-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801064803.2519675-3-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 11:47:53PM -0700, Andrii Nakryiko wrote:
> This patch implements the core logic for BPF CO-RE offsets relocations.
> Every instruction that needs to be relocated has corresponding
> bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> to match recorded "local" relocation spec against potentially many
> compatible "target" types, creating corresponding spec. Details of the
> algorithm are noted in corresponding comments in the code.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
...
> +		if (btf_is_composite(t)) {
> +			const struct btf_member *m = (void *)(t + 1);
> +			__u32 offset;
> +
> +			if (access_idx >= BTF_INFO_VLEN(t->info))
> +				return -EINVAL;
> +
> +			m = &m[access_idx];
> +
> +			if (BTF_INFO_KFLAG(t->info)) {
> +				if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> +					return -EINVAL;
> +				offset = BTF_MEMBER_BIT_OFFSET(m->offset);
> +			} else {
> +				offset = m->offset;
> +			}

very similar logic exists in btf_dump.c
probably makes sense to make a common helper at some point.

> +static size_t bpf_core_essential_name_len(const char *name)
> +{
> +	size_t n = strlen(name);
> +	int i = n - 3;
> +
> +	while (i > 0) {
> +		if (name[i] == '_' && name[i + 1] == '_' && name[i + 2] == '_')
> +			return i;
> +		i--;
> +	}
> +	return n;
> +}

that's a bit of an eye irritant. How about?
	size_t n = strlen(name);
	int i, cnt = 0;

	for (i = n - 1; i >= 0; i--) {
		if (name[i] == '_') {
                    cnt++;
                } else {
                   if (cnt == 3)
                      return i + 1;
                   cnt = 0;
                }
	}
	return n;

> +	case BTF_KIND_ARRAY: {
> +		const struct btf_array *loc_a, *targ_a;
> +
> +		loc_a = (void *)(local_type + 1);
> +		targ_a = (void *)(targ_type + 1);
> +		local_id = loc_a->type;
> +		targ_id = targ_a->type;

can we add a helper like:
const struct btf_array *btf_array(cosnt struct btf_type *t)
{
        return (const struct btf_array *)(t + 1);
}

then above will be:
	case BTF_KIND_ARRAY: {
		local_id = btf_array(local_type)->type;
		targ_id = btf_array(targ_type)->type;

and a bunch of code in btf.c and btf_dump.c would be cleaner as well?

> +		goto recur;
> +	}
> +	default:
> +		pr_warning("unexpected kind %d relocated, local [%d], target [%d]\n",
> +			   kind, local_id, targ_id);
> +		return 0;
> +	}
> +}
> +
> +/* 
> + * Given single high-level named field accessor in local type, find
> + * corresponding high-level accessor for a target type. Along the way,
> + * maintain low-level spec for target as well. Also keep updating target
> + * offset.
> + *
> + * Searching is performed through recursive exhaustive enumeration of all
> + * fields of a struct/union. If there are any anonymous (embedded)
> + * structs/unions, they are recursively searched as well. If field with
> + * desired name is found, check compatibility between local and target types,
> + * before returning result.
> + *
> + * 1 is returned, if field is found.
> + * 0 is returned if no compatible field is found.
> + * <0 is returned on error.
> + */
> +static int bpf_core_match_member(const struct btf *local_btf,
> +				 const struct bpf_core_accessor *local_acc,
> +				 const struct btf *targ_btf,
> +				 __u32 targ_id,
> +				 struct bpf_core_spec *spec,
> +				 __u32 *next_targ_id)
> +{
> +	const struct btf_type *local_type, *targ_type;
> +	const struct btf_member *local_member, *m;
> +	const char *local_name, *targ_name;
> +	__u32 local_id;
> +	int i, n, found;
> +
> +	targ_type = skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
> +	if (!targ_type)
> +		return -EINVAL;
> +	if (!btf_is_composite(targ_type))
> +		return 0;
> +
> +	local_id = local_acc->type_id;
> +	local_type = btf__type_by_id(local_btf, local_id);
> +	local_member = (void *)(local_type + 1);
> +	local_member += local_acc->idx;
> +	local_name = btf__name_by_offset(local_btf, local_member->name_off);
> +
> +	n = BTF_INFO_VLEN(targ_type->info);
> +	m = (void *)(targ_type + 1);

new btf_member() helper?

> +	for (i = 0; i < n; i++, m++) {
> +		__u32 offset;
> +
> +		/* bitfield relocations not supported */
> +		if (BTF_INFO_KFLAG(targ_type->info)) {
> +			if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> +				continue;
> +			offset = BTF_MEMBER_BIT_OFFSET(m->offset);
> +		} else {
> +			offset = m->offset;
> +		}
> +		if (offset % 8)
> +			continue;

same bit of code again?
definitely could use a helper.

> +	for (i = 0; i < local_spec->len; i++, local_acc++, targ_acc++) {
> +		targ_type = skip_mods_and_typedefs(targ_spec->btf, targ_id,
> +						   &targ_id);
> +		if (!targ_type)
> +			return -EINVAL;
> +
> +		if (local_acc->name) {
> +			matched = bpf_core_match_member(local_spec->btf,
> +							local_acc,
> +							targ_btf, targ_id,
> +							targ_spec, &targ_id);
> +			if (matched <= 0)
> +				return matched;
> +		} else {
> +			/* for i=0, targ_id is already treated as array element
> +			 * type (because it's the original struct), for others
> +			 * we should find array element type first
> +			 */
> +			if (i > 0) {
> +				const struct btf_array *a;
> +
> +				if (!btf_is_array(targ_type))
> +					return 0;
> +
> +				a = (void *)(targ_type + 1);
> +				if (local_acc->idx >= a->nelems)
> +					return 0;

am I reading it correctly that the local spec requested out-of-bounds
index in the target array type?
Why this is 'ignore' instead of -EINVAL?

> +/*
> + * Probe few well-known locations for vmlinux kernel image and try to load BTF
> + * data out of it to use for target BTF.
> + */
> +static struct btf *bpf_core_find_kernel_btf(void)
> +{
> +	const char *locations[] = {
> +		"/lib/modules/%1$s/vmlinux-%1$s",
> +		"/usr/lib/modules/%1$s/kernel/vmlinux",
> +	};
> +	char path[PATH_MAX + 1];
> +	struct utsname buf;
> +	struct btf *btf;
> +	int i, err;
> +
> +	err = uname(&buf);
> +	if (err) {
> +		pr_warning("failed to uname(): %d\n", err);

defensive programming ?
I think uname() can fail only if &buf points to non-existing page like null.

> +		return ERR_PTR(err);
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(locations); i++) {
> +		snprintf(path, PATH_MAX, locations[i], buf.release);
> +		pr_debug("attempting to load kernel BTF from '%s'\n", path);

I think this debug message would have been more useful after access().

> +
> +		if (access(path, R_OK))
> +			continue;
> +
> +		btf = btf__parse_elf(path, NULL);
> +		if (IS_ERR(btf))
> +			continue;
> +
> +		pr_debug("successfully loaded kernel BTF from '%s'\n", path);
> +		return btf;
> +	}
> +
> +	pr_warning("failed to find valid kernel BTF\n");
> +	return ERR_PTR(-ESRCH);
> +}
> +
> +/* Output spec definition in the format:
> + * [<type-id>] (<type-name>) + <raw-spec> => <offset>@<spec>,
> + * where <spec> is a C-syntax view of recorded field access, e.g.: x.a[3].b
> + */
> +static void bpf_core_dump_spec(int level, const struct bpf_core_spec *spec)
> +{
> +	const struct btf_type *t;
> +	const char *s;
> +	__u32 type_id;
> +	int i;
> +
> +	type_id = spec->spec[0].type_id;
> +	t = btf__type_by_id(spec->btf, type_id);
> +	s = btf__name_by_offset(spec->btf, t->name_off);
> +	libbpf_print(level, "[%u] (%s) + ", type_id, s);

imo extra []() don't improve readability of the dump.

> +
> +	for (i = 0; i < spec->raw_len; i++)
> +		libbpf_print(level, "%d%s", spec->raw_spec[i],
> +			     i == spec->raw_len - 1 ? " => " : ":");
> +
> +	libbpf_print(level, "%u @ &x", spec->offset);
> +
> +	for (i = 0; i < spec->len; i++) {
> +		if (spec->spec[i].name)
> +			libbpf_print(level, ".%s", spec->spec[i].name);
> +		else
> +			libbpf_print(level, "[%u]", spec->spec[i].idx);
> +	}
> +
> +}
> +
> +static size_t bpf_core_hash_fn(const void *key, void *ctx)
> +{
> +	return (size_t)key;
> +}
> +
> +static bool bpf_core_equal_fn(const void *k1, const void *k2, void *ctx)
> +{
> +	return k1 == k2;
> +}
> +
> +static void *u32_to_ptr(__u32 x)
> +{
> +	return (void *)(uintptr_t)x;
> +}

u32 to pointer on 64-bit arch?!
That surely needs a comment.

> +
> +/* 
> + * CO-RE relocate single instruction.
> + *
> + * The outline and important points of the algorithm:
> + * 1. For given local type, find corresponding candidate target types.
> + *    Candidate type is a type with the same "essential" name, ignoring
> + *    everything after last triple underscore (___). E.g., `sample`,
> + *    `sample___flavor_one`, `sample___flavor_another_one`, are all candidates
> + *    for each other. Names with triple underscore are referred to as
> + *    "flavors" and are useful, among other things, to allow to
> + *    specify/support incompatible variations of the same kernel struct, which
> + *    might differ between different kernel versions and/or build
> + *    configurations.
> + *
> + *    N.B. Struct "flavors" could be generated by bpftool's BTF-to-C
> + *    converter, when deduplicated BTF of a kernel still contains more than
> + *    one different types with the same name. In that case, ___2, ___3, etc
> + *    are appended starting from second name conflict. But start flavors are
> + *    also useful to be defined "locally", in BPF program, to extract same
> + *    data from incompatible changes between different kernel
> + *    versions/configurations. For instance, to handle field renames between
> + *    kernel versions, one can use two flavors of the struct name with the
> + *    same common name and use conditional relocations to extract that field,
> + *    depending on target kernel version.

there are actual kernel types that have ___ in the name.
Ex: struct lmc___media
We probably need to revisit this 'flavor' convention.

> +	for (i = 0, j = 0; i < cand_ids->len; i++) {
> +		cand_id = cand_ids->data[i];
> +		cand_type = btf__type_by_id(targ_btf, cand_id);
> +		cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> +
> +		err = bpf_core_spec_match(&local_spec, targ_btf,
> +					  cand_id, &cand_spec);
> +		if (err < 0) {
> +			pr_warning("prog '%s': relo #%d: failed to match spec ",
> +				   prog_name, relo_idx);
> +			bpf_core_dump_spec(LIBBPF_WARN, &local_spec);
> +			libbpf_print(LIBBPF_WARN,
> +				     " to candidate #%d [%d] (%s): %d\n",
> +				     i, cand_id, cand_name, err);
> +			return err;
> +		}
> +		if (err == 0) {
> +			pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec ",
> +				 prog_name, relo_idx, i, cand_id, cand_name);
> +			bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> +			libbpf_print(LIBBPF_DEBUG, "\n");
> +			continue;
> +		}
> +
> +		pr_debug("prog '%s': relo #%d: candidate #%d matched as spec ",
> +			 prog_name, relo_idx, i);

did you mention that you're going to make a helper for this debug dumps?

