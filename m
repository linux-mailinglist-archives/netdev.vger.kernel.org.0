Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB153F23D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiFFWqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbiFFWqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:46:48 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E249C5E5E
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:46:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso1943364pjk.5
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcelv3cy01fZ3BgGjcMbeAjdDL8VyMdiqIBwItA7vaw=;
        b=f11FNZuCh+qlW7ecUdwf/j0bhqh1gPq7uQzvVnxb1H96cnREhSKzwoC9xf3AuCahfA
         9KkTNF0WN1tDyci8Iw4xPEC/P2xWoi4a0yJlO6fvtwChak/Efh/GnQ9XOpcWBPrtogL4
         hE/5ItIMCTFkO66aGv7Q2U42TKAc9TiKcWIO55O8Nfuh7YEc1fBLIhEbMLgSOssY0LgK
         R/dfnHcD69E+9OzSN9azW8rzm2z9ZdZEZw7eiXWD9NpSk+4u2oQmQYEwxDSNOi2Kp9ri
         Cq05JGqtGDog7LqBMZhQszp6OIf7Pb0z+hanVYhzef+vlGOKq/ze3e7lp7TPvjlsGKgQ
         uj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcelv3cy01fZ3BgGjcMbeAjdDL8VyMdiqIBwItA7vaw=;
        b=1yI7Agn4ah6PpUQGDqixDyFWJl7LjetNcOE6JNGK4NRoQ8s8XyvZljoy2SbeD/SBhH
         3/2pAH+MzQhgVIfnMCwuYAMrSYphYHP7Hq+PQsMN0hZRQEGvo+0ytTIDo6UeQlajBEbT
         9o0Mx2IZakPqhN53vD0cW0Ul/apTUt2lNve+br9KkXMcxcAEFDXBkJz48IDIqt6x1k+M
         Y0QQ1cH6RcnoYx8Z8QPn56g1hZUBwkJdrNAhqJ2id6U/z/Q8BM1dYv0GztyJhJiuyW29
         iZ2NgdJaROwChAhrDKlA1JKFKC2jraWQnQzxfBeaboBpHH1wozrHbxNTzdgPnxQCy9x1
         J3UQ==
X-Gm-Message-State: AOAM5311hqnEeQyC3/8vkeJIE0LMTDfdrn9mGZAyv0LTqKZ58VgDbF2U
        UpDHbJWSj292FstaRY+eiFNmuNhtepKG7MIIRJtVUWo3PdE=
X-Google-Smtp-Source: ABdhPJzAbH7y7YD4ZJ2KSXOMCHS4r3xJKr/W3g7UAuZtQI1faGXSwXSoC6lELb2gFcut1J2uCqXTq2ph5QfcalagyFk=
X-Received: by 2002:a17:90b:188:b0:1e3:1feb:edb2 with SMTP id
 t8-20020a17090b018800b001e31febedb2mr29289181pjs.195.1654555603760; Mon, 06
 Jun 2022 15:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-5-sdf@google.com>
 <20220604063556.qyhsssqgp2stw73q@kafai-mbp>
In-Reply-To: <20220604063556.qyhsssqgp2stw73q@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 6 Jun 2022 15:46:32 -0700
Message-ID: <CAKH8qBvY++bswS8ycJyGVR0DsKsyXNhKv=MzwD2FkJY4wSYFbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 11:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 01, 2022 at 12:02:11PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 0f72020bfdcf..83aa431dd52e 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -69,11 +69,6 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> >               *bpf_func = __cgroup_bpf_run_lsm_current;
> >  }
> >
> > -int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -     return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> The implementation of btf_id_set_index() added in patch 3
> should be removed also.

Thank you for the review!

At some point I was using btf_id_set_index inside of
btf_id_set_contains but since then reverted this part, will fix!

> > -}
> > -
> >  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> >                       const struct bpf_prog *prog)
> >  {
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 66b644a76a69..a27a6a7bd852 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -129,12 +129,46 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> >  }
> >
> >  #ifdef CONFIG_BPF_LSM
> > +u32 cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
> static

Thx!

> > +
> >  static enum cgroup_bpf_attach_type
> >  bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> >  {
> > +     int i;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> >       if (attach_type != BPF_LSM_CGROUP)
> >               return to_cgroup_bpf_attach_type(attach_type);
> > -     return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> > +
> > +     for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
> > +             if (cgroup_lsm_atype_btf_id[i] == attach_btf_id)
> > +                     return CGROUP_LSM_START + i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
> > +             if (cgroup_lsm_atype_btf_id[i] == 0)
> > +                     return CGROUP_LSM_START + i;
> > +
> > +     return -E2BIG;
> > +
> > +}
> > +
> > +static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
> > +{
> > +     int i = cgroup_atype - CGROUP_LSM_START;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> > +     cgroup_lsm_atype_btf_id[i] = attach_btf_id;
> > +}
> > +
> > +void bpf_cgroup_atype_free(int cgroup_atype)
> > +{
> > +     int i = cgroup_atype - CGROUP_LSM_START;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +     cgroup_lsm_atype_btf_id[i] = 0;
> I think holding cgroup_mutex in the __cgroup_bpf_attach() and
> bpf_cgroup_atype_free() is not enough.
>
> Consider a case that __cgroup_bpf_attach() runs first and bpf_trampoline_link_cgroup_shim()
> cannot find the shim_link because it is unlinked and its shim_prog
> is currently still under the bpf_prog_free_deferred's deadrow.
> Then bpf_prog_free_deferred() got run and do the bpf_cgroup_atype_free().
>
> A refcnt is still needed.  It is better to put them together in a
> struct instead of having two arrays, like
>
> struct cgroup_lsm_atype {
>        u32 attach_btf_id;
>        u32 refcnt;
> };

Ugh, that's true, very good point, will add.

> > +     mutex_unlock(&cgroup_mutex);
> >  }
> >  #else
> >  static enum cgroup_bpf_attach_type
> > @@ -144,6 +178,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> >               return to_cgroup_bpf_attach_type(attach_type);
> >       return -EOPNOTSUPP;
> >  }
> > +
> > +static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
> > +{
> > +}
> > +
> > +void bpf_cgroup_atype_free(int cgroup_atype)
> > +{
> > +}
> >  #endif /* CONFIG_BPF_LSM */
> >
> >  void cgroup_bpf_offline(struct cgroup *cgrp)
> > @@ -659,6 +701,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
> >               if (err)
> >                       goto cleanup;
> > +             bpf_cgroup_atype_alloc(new_prog->aux->attach_btf_id, atype);
> This atype alloc (or refcnt inc) should be done in
> cgroup_shim_alloc() where the shim_prog is the one holding
> the refcnt of the atype.  If the above "!old_prog" needs to be
> removed as the earlier comment in patch 3, bumping the atype refcnt
> here will be wrong.
>
> >       }

Agreed. The only thing here that might be a bit unclear is the need to
hold cgroup_mutex. I'll keep lockdep_assert_held to make it more
apparent.

> >       err = update_effective_progs(cgrp, atype);
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 091ee210842f..224bb4d4fe4e 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> >       fp->aux->prog = fp;
> >       fp->jit_requested = ebpf_jit_enabled();
> >       fp->blinding_requested = bpf_jit_blinding_enabled(fp);
> > +#ifdef CONFIG_BPF_LSM
> I don't think this is needed.

enum cgroup_bpf_attach_type is under '#ifdef CONFIG_CGROUP_BPF', so it
fails in some configs without cgroup/bpf. I was trying to move that
enumo out of ifdef but then decided that it's easier to fix here.
Should I instead try to move ifdef in bpf-cgroup-defs.h around?



> > +     aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID;
> > +#endif
> >
> >       INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
> >       mutex_init(&fp->aux->used_maps_mutex);
> > @@ -2558,6 +2561,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
> >       aux = container_of(work, struct bpf_prog_aux, work);
> >  #ifdef CONFIG_BPF_SYSCALL
> >       bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
> > +#endif
> > +#ifdef CONFIG_BPF_LSM
> Same here.
>
> > +     if (aux->cgroup_atype != CGROUP_BPF_ATTACH_TYPE_INVALID)
> > +             bpf_cgroup_atype_free(aux->cgroup_atype);
> >  #endif
> >       bpf_free_used_maps(aux);
> >       bpf_free_used_btfs(aux);
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
