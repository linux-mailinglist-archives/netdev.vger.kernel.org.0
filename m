Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0B48253B
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 17:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhLaQ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 11:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhLaQ4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 11:56:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D19DC061574;
        Fri, 31 Dec 2021 08:56:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so26121260pjp.0;
        Fri, 31 Dec 2021 08:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JtYLxaNef3JUVkkScn27mFN6xzYiFAKj5fUU19X854o=;
        b=BhtisCDnE+1QS4FGy325PuWtbMYUWxD583Lw2+SRWkwbO2INEjteBmbp4+nS1OnP13
         5rv9PtNfcssiei/stKZzixfSzqw4mjHJMUM7xPDVxECMPS9Tsg/Im4uEQNECT3tDhWjc
         HBijiyv1RhJZorkd49jXQhZStVFGrcri0JCfNJk83G46MVKjBj1gVfM3SwgGCxIbkUKM
         6/Xm0GAJwSB7SPpk4Ffrl/7oL5BHYfO5w63dNh4TmgRt1SEIZ980rzqWwOvvoAJBtDZU
         J5RHAhugk7uwKyPAxnWs8Gax76jgtFJxG6MqgcgUzfkMhkPreHSED0BiHN0BmAJTS6MB
         fNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JtYLxaNef3JUVkkScn27mFN6xzYiFAKj5fUU19X854o=;
        b=ax6+GTpMNkg1wVsSVuwfhDlN5heo3ymANxacBmAWI6y6fblw9QBRwkQJFv7OMAFzln
         uVaIexvgLSo+uY/oflIGBk2mkwO+AUI0lHhRPgf7l6nBF1W+/pmK4UEKmPyZ2JgNreYr
         HLzW8EVWeZDuwHnBWhfK/GX+1dId1pWu991s4XV9pBXBDHKLxaZWMtY+lG96S62fcnLt
         cIySCt6H8qKXxA51X6sy49MNcmCGRHlSopmOQ0FDpYZN0vsJNJuZ7ZnHT5yzfnzfdsO1
         dOQuaqcyihoR8+O6IKqu7Mdkx2GJkBBV3ChEAszfqIp2ANPoEmi4LDHv+2Abk8PZ4qfs
         Nssg==
X-Gm-Message-State: AOAM533HmqSymg4ObtqgbIYtsmkoNikUGOr4zyJTJ12qNy65tVHTuNOx
        xOi6915QdvnZ/DhEB4uGLoQ=
X-Google-Smtp-Source: ABdhPJwodD/xgCUk273E+pkrIY6jDAJ8tBtPznHvs3BMEG40ztyGacwwSs/+yfTsKpuE3Q0HWjcxJA==
X-Received: by 2002:a17:903:124d:b0:149:8141:88ea with SMTP id u13-20020a170903124d00b00149814188eamr22665433plh.82.1640969792659;
        Fri, 31 Dec 2021 08:56:32 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:92df])
        by smtp.gmail.com with ESMTPSA id e8sm8844404pjs.46.2021.12.31.08.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 08:56:32 -0800 (PST)
Date:   Fri, 31 Dec 2021 08:56:29 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v5 2/9] bpf: Prepare kfunc BTF ID sets when
 parsing kernel BTF
Message-ID: <20211231165629.fnaolmwjoqt6hhcb@ast-mbp.dhcp.thefacebook.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
 <20211230023705.3860970-3-memxor@gmail.com>
 <20211231022307.3cwff3suzemuiiqk@ast-mbp.dhcp.thefacebook.com>
 <20211231034507.6iqa7nxwe27o77fw@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231034507.6iqa7nxwe27o77fw@apollo.legion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 09:15:07AM +0530, Kumar Kartikeya Dwivedi wrote:
> On Fri, Dec 31, 2021 at 07:53:07AM IST, Alexei Starovoitov wrote:
> > On Thu, Dec 30, 2021 at 08:06:58AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > [...]
> > > +
> > > +	/* Identify type */
> > > +	symbol_name += pfx_size;
> > > +	if (!*symbol_name) {
> > > +		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
> > > +		return -EINVAL;
> > > +	}
> > > +	for (i = 0; i < ARRAY_SIZE(kfunc_type_str); i++) {
> > > +		pfx_size = strlen(kfunc_type_str[i]);
> > > +		if (strncmp(symbol_name, kfunc_type_str[i], pfx_size))
> > > +			continue;
> > > +		break;
> > > +	}
> > > +	if (i == ARRAY_SIZE(kfunc_type_str)) {
> > > +		bpf_log(bdata->log, "invalid type '%s' for kfunc_btf_id_set %s\n", symbol_name,
> > > +			orig_name);
> > > +		return -EINVAL;
> > > +	}
> > > +	type = i;
> > > +
> > > +	return btf_populate_kfunc_sets(bdata->btf, bdata->log, hook, type, set);
> >
> > I really like the direction taken by patches 2 and 3.
> > I think we can save the module_kallsyms_on_each_symbol loop though.
> > The registration mechanism, like:
> >   register_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
> > doesn't have to be complete removed.
> > It can replaced with a sequence of calls:
> >   btf_populate_kfunc_sets(btf, hook, type, set);
> > from __init of the module.
> > The module knows its 'hook' and 'type' and set==&bpf_testmod_kfunc_btf_set.
> > The bpf_testmod_init() can call btf_populate_kfunc_sets() multiple
> > times to popualte sets into different hooks and types.
> > There is no need to 'unregister' any more.
> > And the patch 1 will no longer be necessary, since we don't need to iterate
> > every symbol of the module with module_kallsyms_on_each_symbol().
> > No need to standardize on the prefix and kfunc_[hook|type]_str,
> > though it's probably good idea anyway across module BTF sets.
> > The main disadvantage is that we lose 'log' in btf_populate_kfunc_sets(),
> > since __init of the module cannot have verifier log at that point.
> > But it can stay as 'ret = -E2BIG;' without bpf_log() and module registration
> > will fail in such case or we just warn inside __init if btf_populate_kfunc_sets
> > fails in the rare case.
> > wdyt?
> >
> 
> Sounds good, I'll make this change in the next version. Should I also drop
> kallsyms_on_each_symbol for vmlinux BTF? I think we can use initcall for it too,
> right?

Yep. Of course. For consistency.

> > > +}
> > > +
> > > +static int btf_parse_kfunc_sets(struct btf *btf, struct module *mod,
> > > +				struct bpf_verifier_log *log)
> > > +{
> > > +	struct btf_parse_kfunc_data data = { .btf = btf, .log = log, };
> > > +	struct btf_kfunc_set_tab *tab;
> > > +	int hook, type, ret;
> > > +
> > > +	if (!btf_is_kernel(btf))
> > > +		return -EINVAL;
> > > +	if (WARN_ON_ONCE(btf_is_module(btf) && !mod)) {
> > > +		bpf_log(log, "btf internal error: no module for module BTF %s\n", btf->name);
> > > +		return -EFAULT;
> > > +	}
> > > +	if (mod)
> > > +		ret = module_kallsyms_on_each_symbol(mod, btf_parse_kfunc_sets_cb, &data);
> > > +	else
> > > +		ret = kallsyms_on_each_symbol(btf_parse_kfunc_sets_cb, &data);
> > > +
> > > +	tab = btf->kfunc_set_tab;
> > > +	if (!ret && tab) {
> > > +		/* Sort all populated sets */
> > > +		for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
> > > +			for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++) {
> > > +				struct btf_id_set *set = tab->sets[hook][type];
> > > +
> > > +				/* Not all sets may be populated */
> > > +				if (!set)
> > > +					continue;
> > > +				sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_kfunc_ids_cmp,
> > > +				     NULL);
> >
> > Didn't resolve_btfid store ids already sorted?
> > Why another sort is needed?
> 
> Because it might be possible while iterating over symbols (be it vmlinux or
> module), we combine sets like [1, 4, 6] and [2, 3, 5] into [1, 4, 6, 2, 3, 5],
> into the set for a certain hook, type, so to enable bsearch we do one final sort
> after possible sets have been populated.
> 
> > Because btf_populate_kfunc_sets() can concatenate the sets?
> > But if we let __init call it directly the module shouldn't use
> > the same hook/type combination multiple times with different sets.
> > So no secondary sorting will be necessary?
> >
> 
> Yes, if we make it that only one call per hook/type can be done, then this
> shouldn't be needed, but e.g. if each file has a set for some hook and uses late
> initcall to do registration, then it will be needed again for the same reason.

You mean when module has multiple files and these sets have to be in different files?

> We can surely catch the second call (see if tab->[hook][type] != NULL).

Good idea. Let's do this for now.
One .c per module with such sets is fine, imo.

> > > This commit prepares the BTF parsing functions for vmlinux and module
> > > BTFs to find all kfunc BTF ID sets from the vmlinux and module symbols
> > > and concatentate all sets into single unified set which is sorted and
> > > keyed by the 'hook' it is meant for, and 'type' of set.
> >
> > 'sorted by hook' ?
> > The btf_id_set_contains() need to search it by 'id', so it's sorted by 'id'.
> 
> Yeah, it needs a comma after 'sorted' :).
> 
> > Is it because you're adding mod's IDs to vmlinux IDs and re-sorting them?
> 
> No, I'm not mixing them. We only add same module's/vmlinux's IDs to its struct
> btf, then sort each set (for hook,type pair). find_kfunc_desc_btf gives us the
> BTF, then we can directly do what is essentially a single btf_id_set_contains
> call, so it is not required to research in vmlinux BTF. The BTF associated with
> the kfunc call is known.

Got it. Ok.
