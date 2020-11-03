Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32CD2A3B8A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 05:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgKCEvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 23:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgKCEvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 23:51:47 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B0BC0617A6;
        Mon,  2 Nov 2020 20:51:46 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id h196so13751316ybg.4;
        Mon, 02 Nov 2020 20:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mn94UqTv/V38LHwLIuTC1zi/B5ww5U+7rV+EfP97hfc=;
        b=PZBwg20Lm0SG3HhL5w59bOeSY+fz+gPDnDaCypzLR1J1fjRUDpFEe58wjXOA8fUVEU
         8fYl19vdubFsxsq+j2hKBWuYNVKovM5Hs8UBtaGJtw8am7jDCidhnbg4730VQIjmhANq
         HyhCjb61mpFncoLLG/F6Wt7DDm4jZHL21lRCgptcd9Pa39+x1GXJXYMn/GAPWuWTtUUM
         eQDJrLIg3ZFa2E/QvfLnyMk04+Le7RCRAGaWb9v8vYR5Q6zY0YWITIfOBuFTM8wN+yco
         dn+ebjlzkBPUbzf0Ve9gn+HAGVIGjwbXqVbm0yzhHddoDLH0Gi8MfLQ0/LTeZLp0AVTK
         56rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mn94UqTv/V38LHwLIuTC1zi/B5ww5U+7rV+EfP97hfc=;
        b=ea++5m7DGx9B+dZgJIi4P/bINdKUEOaeV3r5fNoOgrpTqldd5cEMZ1+EfGfpZrLqkK
         U38pRnWyXsvDa1McIEfBvCU/2nCSfagenTcIwdZfQH3MGDiGuIxaZ/kVKl+zGL4Zpf/k
         0evDkt/fJAJTN9ptQ5rD9Brv6HuLDHvAWVok1uZtbl7p2mgolwFy3Hw4M90qBWJwYHeZ
         497DB80R425egLCPVcNBLiosHNbLCvbn4BC0iPY5cjDJ/z9BhEQ35OZh4LkQZRnLpDyl
         faTGlgZFFJLOtkQmKE3mnojTNZmlXOzOZXdbh1G3uYb1iL1iU9E/rWvtyxDI/ju3EuFg
         elhQ==
X-Gm-Message-State: AOAM532Yfc9nUFeHNHsfnseVa0pNzY62YQ4r0+jiia6taTLgbr7tJnHA
        stXuJxJ9+t13UchIn5cXayMHlshhgHfRqd0FliOj/PcFhzc=
X-Google-Smtp-Source: ABdhPJxAivtlg7wlrsxngrMkhwfzSRJ17fCqWIcl1JQ5hnjG/pZ1jduRKGpXYQAddalwICZ0DLUBSYvg4BJF7EoKNvE=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr25663163ybg.459.1604379104443;
 Mon, 02 Nov 2020 20:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-4-andrii@kernel.org>
 <11A01E1A-FBAC-490C-BFBC-CB7CF7F8E07A@fb.com>
In-Reply-To: <11A01E1A-FBAC-490C-BFBC-CB7CF7F8E07A@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 20:51:33 -0800
Message-ID: <CAEf4Bzavxu80+P8N+rEzHTNetsKcPqWkMUafpyG6Bz-6EydwiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/11] libbpf: unify and speed up BTF string deduplication
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 4:33 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > From: Andrii Nakryiko <andriin@fb.com>
> >
> > Revamp BTF dedup's string deduplication to match the approach of writable BTF
> > string management. This allows to transfer deduplicated strings index back to
> > BTF object after deduplication without expensive extra memory copying and hash
> > map re-construction. It also simplifies the code and speeds it up, because
> > hashmap-based string deduplication is faster than sort + unique approach.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> LGTM, with a couple nitpick below:
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> > ---
> > tools/lib/bpf/btf.c | 265 +++++++++++++++++---------------------------
> > 1 file changed, 99 insertions(+), 166 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 89fecfe5cb2b..db9331fea672 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -90,6 +90,14 @@ struct btf {
> >       struct hashmap *strs_hash;
> >       /* whether strings are already deduplicated */
> >       bool strs_deduped;
> > +     /* extra indirection layer to make strings hashmap work with stable
> > +      * string offsets and ability to transparently choose between
> > +      * btf->strs_data or btf_dedup->strs_data as a source of strings.
> > +      * This is used for BTF strings dedup to transfer deduplicated strings
> > +      * data back to struct btf without re-building strings index.
> > +      */
> > +     void **strs_data_ptr;
> > +
> >       /* BTF object FD, if loaded into kernel */
> >       int fd;
> >
> > @@ -1363,17 +1371,19 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> >
> > static size_t strs_hash_fn(const void *key, void *ctx)
> > {
> > -     struct btf *btf = ctx;
> > -     const char *str = btf->strs_data + (long)key;
> > +     const char ***strs_data_ptr = ctx;
> > +     const char *strs = **strs_data_ptr;
> > +     const char *str = strs + (long)key;
>
> Can we keep using btf as the ctx here? "char ***" hurts my eyes...
>

yep, changed to struct btf *

> [...]
>
> > -     d->btf->hdr->str_len = end - start;
> > +     /* replace BTF string data and hash with deduped ones */
> > +     free(d->btf->strs_data);
> > +     hashmap__free(d->btf->strs_hash);
> > +     d->btf->strs_data = d->strs_data;
> > +     d->btf->strs_data_cap = d->strs_cap;
> > +     d->btf->hdr->str_len = d->strs_len;
> > +     d->btf->strs_hash = d->strs_hash;
> > +     /* now point strs_data_ptr back to btf->strs_data */
> > +     d->btf->strs_data_ptr = &d->btf->strs_data;
> > +
> > +     d->strs_data = d->strs_hash = NULL;
> > +     d->strs_len = d->strs_cap = 0;
> >       d->btf->strs_deduped = true;
> > +     return 0;
> > +
> > +err_out:
> > +     free(d->strs_data);
> > +     hashmap__free(d->strs_hash);
> > +     d->strs_data = d->strs_hash = NULL;
> > +     d->strs_len = d->strs_cap = 0;
> > +
> > +     /* restore strings pointer for existing d->btf->strs_hash back */
> > +     d->btf->strs_data_ptr = &d->strs_data;
>
> We have quite some duplicated code in err_out vs. succeed_out cases.
> How about we add a helper function, like

nope, that won't work, free(d->strs_data) vs free(d->btf->strs_data),
same for hashmap__free(), plus there are strict requirements about the
exact sequence of assignments in success case

>
> void free_strs_data(struct btf_dedup *d)
> {
>         free(d->strs_data);
>         hashmap__free(d->strs_hash);
>         d->strs_data = d->strs_hash = NULL;
>         d->strs_len = d->strs_cap = 0;
> }
>
> ?
