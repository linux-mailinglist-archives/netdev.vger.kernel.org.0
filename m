Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C73554FCF9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiFQS2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiFQS2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:28:31 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32F02F67E
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:30 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 193so1877382pgc.2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8w//hGwxbuYTuV6pWs34aHkHuYHQ3CrODWdIJdp4AYQ=;
        b=tO/pGwNarBwp/HPL5d/52rkiChro54KMTpDG7iXhYqI3wJVG2FnvXnI/VY7n9a9TV9
         ekt/6lBYbpBSCdC3bBjmjWX4N86IGOuoRq9WE+ZVObGoQVTIC/aPJXaXB6GRsewYX2RI
         Psl5v4uKrTV4VVi0ez45FBVsZUjvxPV0ppnW8yZ1onnVbfe7Dz5gw3JJyItm3VG33z2v
         3BkrzOhpnhxeD4TlCjghWK8jcbVQPtBfka8lsLvadSJBbRGVcaUouMNhDYpnkNloSNxZ
         Aqa/IAyo5M9clokLowDQ6KkvDpx9DKLlsFRcc4AwbijLycPNIf54beVSWSwfoC8jV3cB
         NRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8w//hGwxbuYTuV6pWs34aHkHuYHQ3CrODWdIJdp4AYQ=;
        b=Am2MQv/omK8jUNM01E1xjyoHW9A3ryzaHYIHg9XQODRV0gJJGp+SKiPDn7WePzmEps
         iXYI84JYrhxp2zFjpqYsvKLv+i7EMEW8YgXG+/9qJlBcJOs10KyV2R+D8Wr1SlP6dDG1
         So5pMau6g3OMQlpHvYdiRtTBN7ARO1GwwU3lXm9VWtQZ6Vre+iJMUUWTF4VRAFpzwKsk
         QnfytJHIOqxOXdj1qOzJZ1PxD8lZB1Z81kA4VWbxL7wbWzNWO3spGXuSCv8EjFSxlinQ
         VghmcR/p71WE57eMteCJUkI2Eo8GzTjSoVm6whWtCDoJDV/k/PBaVkcGCYuwmIWbxWW3
         aVcA==
X-Gm-Message-State: AJIora+JsBNaZh1Hv5mqj8WNttjchDuE8CfOqFIm6v6RQSCCRbs6u5lZ
        iGVCENSlJEvMtq5dnudV+MmJrB2IQgba6xafmu0Px6bp3Mw=
X-Google-Smtp-Source: AGRyM1sct6XrOz8KDW7zSM+WJADzC5mGcv695xVbEo0FfU031iRsYSmMpEh3wmSMjdcTkbbp43GenW9C3tapi4uRd50=
X-Received: by 2002:a63:1408:0:b0:408:ab3d:9310 with SMTP id
 u8-20020a631408000000b00408ab3d9310mr10223059pgl.253.1655490509822; Fri, 17
 Jun 2022 11:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com> <20220610165803.2860154-5-sdf@google.com>
 <20220617004321.4qbte4k5ftbcvivs@kafai-mbp>
In-Reply-To: <20220617004321.4qbte4k5ftbcvivs@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 17 Jun 2022 11:28:18 -0700
Message-ID: <CAKH8qBtQmS5R7AaXoqh0HWWSReh3CF0E7sdL3jCH=ZKRJehnKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 04/10] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 5:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 10, 2022 at 09:57:57AM -0700, Stanislav Fomichev wrote:
> > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > and bpf_cgroup program array. Instead of reserving a slot per
> > possible hook, reserve 10 slots per cgroup for lsm programs.
> > Those slots are dynamically allocated on demand and reclaimed.
> >
> > struct cgroup_bpf {
> >       struct bpf_prog_array *    effective[33];        /*     0   264 *=
/
> >       /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> >       struct hlist_head          progs[33];            /*   264   264 *=
/
> >       /* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> >       u8                         flags[33];            /*   528    33 *=
/
> >
> >       /* XXX 7 bytes hole, try to pack */
> >
> >       struct list_head           storages;             /*   568    16 *=
/
> >       /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> >       struct bpf_prog_array *    inactive;             /*   584     8 *=
/
> >       struct percpu_ref          refcnt;               /*   592    16 *=
/
> >       struct work_struct         release_work;         /*   608    72 *=
/
> >
> >       /* size: 680, cachelines: 11, members: 7 */
> >       /* sum members: 673, holes: 1, sum holes: 7 */
> >       /* last cacheline: 40 bytes */
> > };
> >
> > Move 'ifdef CONFIG_CGROUP_BPF' to expose CGROUP_BPF_ATTACH_TYPE_INVALID
> > to non-cgroup (core) parts.
> hmm... don't see this change in bpf-cgroup-defs.h in this patch.

Sorry for confusion, that's a leftover from my previous attempt to
make it work for CONFIG_CGROUP_BPF=3Dn case; will remove.

> >
> > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup=
-defs.h
> > index b99f8c3e37ea..7b121bd780eb 100644
> > --- a/include/linux/bpf-cgroup-defs.h
> > +++ b/include/linux/bpf-cgroup-defs.h
> > @@ -11,7 +11,8 @@
> >  struct bpf_prog_array;
> >
> >  #ifdef CONFIG_BPF_LSM
> > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> > +#define CGROUP_LSM_NUM 10
> >  #else
> >  #define CGROUP_LSM_NUM 0
> >  #endif
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 4dceb86229f6..503f28fa66d2 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -2407,7 +2407,6 @@ int bpf_arch_text_invalidate(void *dst, size_t le=
n);
> >
> >  struct btf_id_set;
> >  bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
> > -int btf_id_set_index(const struct btf_id_set *set, u32 id);
> >
> >  #define MAX_BPRINTF_VARARGS          12
> >
> > @@ -2444,4 +2443,7 @@ void bpf_dynptr_init(struct bpf_dynptr_kern *ptr,=
 void *data,
> >  void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
> >  int bpf_dynptr_check_size(u32 size);
> >
> > +void bpf_cgroup_atype_put(int cgroup_atype);
> > +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
> > +
> >  #endif /* _LINUX_BPF_H */
>
> [ ... ]
>
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index b0314889a409..ba402d50e130 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -128,12 +128,56 @@ unsigned int __cgroup_bpf_run_lsm_current(const v=
oid *ctx,
> >  }
> >
> >  #ifdef CONFIG_BPF_LSM
> > +struct cgroup_lsm_atype {
> > +     u32 attach_btf_id;
> > +     int refcnt;
> > +};
> > +
> > +static struct cgroup_lsm_atype cgroup_lsm_atype[CGROUP_LSM_NUM];
> > +
> >  static enum cgroup_bpf_attach_type
> >  bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf=
_id)
> >  {
> > +     int i;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> >       if (attach_type !=3D BPF_LSM_CGROUP)
> >               return to_cgroup_bpf_attach_type(attach_type);
> > -     return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
> > +             if (cgroup_lsm_atype[i].attach_btf_id =3D=3D attach_btf_i=
d)
> > +                     return CGROUP_LSM_START + i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
> > +             if (cgroup_lsm_atype[i].attach_btf_id =3D=3D 0)
> > +                     return CGROUP_LSM_START + i;
> > +
> > +     return -E2BIG;
> > +
> > +}
> > +
> > +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
> > +{
> > +     int i =3D cgroup_atype - CGROUP_LSM_START;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> > +     WARN_ON_ONCE(cgroup_lsm_atype[i].attach_btf_id &&
> > +                  cgroup_lsm_atype[i].attach_btf_id !=3D attach_btf_id=
);
> > +
> > +     cgroup_lsm_atype[i].attach_btf_id =3D attach_btf_id;
> > +     cgroup_lsm_atype[i].refcnt++;
> > +}
> > +
> > +void bpf_cgroup_atype_put(int cgroup_atype)
> > +{
> > +     int i =3D cgroup_atype - CGROUP_LSM_START;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +     if (--cgroup_lsm_atype[i].refcnt <=3D 0)
> > +             cgroup_lsm_atype[i].attach_btf_id =3D 0;
> > +     mutex_unlock(&cgroup_mutex);
> >  }
> >  #else
> >  static enum cgroup_bpf_attach_type
> > @@ -143,6 +187,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_=
type, u32 attach_btf_id)
> >               return to_cgroup_bpf_attach_type(attach_type);
> >       return -EOPNOTSUPP;
> >  }
> > +
> > +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
> > +{
> > +}
> > +
> > +void bpf_cgroup_atype_put(int cgroup_atype)
> > +{
> > +}
> From the test bot report, these two empty functions may need
> to be inlined in a .h or else the caller needs to have a CONFIG_CGROUP_BP=
F
> before calling bpf_cgroup_atype_get().  The bpf-cgroup.h may be a better =
place
> than bpf.h for the inlines but not sure if it is easy to be included in
> trampoline.c or core.c.  Whatever way makes more sense.  Either .h is fin=
e.

Yeah, I already moved them into headers after the complaints from the
bot. Thanks for double checking!

Let's keep in bpf.h ?

kernel/bpf/core.c:2563:17: error: implicit declaration of function
=E2=80=98bpf_cgroup_atype_put=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
 2563 |                 bpf_cgroup_atype_put(aux->cgroup_atype);


> Others lgtm.
>
> >  #endif /* CONFIG_BPF_LSM */
> >
> >  void cgroup_bpf_offline(struct cgroup *cgrp)
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 8d171eb0ed0d..0699098dc6bc 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned i=
nt size, gfp_t gfp_extra_flag
> >       fp->aux->prog =3D fp;
> >       fp->jit_requested =3D ebpf_jit_enabled();
> >       fp->blinding_requested =3D bpf_jit_blinding_enabled(fp);
> > +#ifdef CONFIG_CGROUP_BPF
> > +     aux->cgroup_atype =3D CGROUP_BPF_ATTACH_TYPE_INVALID;
> > +#endif
> >
> >       INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
> >       mutex_init(&fp->aux->used_maps_mutex);
> > @@ -2554,6 +2557,10 @@ static void bpf_prog_free_deferred(struct work_s=
truct *work)
> >       aux =3D container_of(work, struct bpf_prog_aux, work);
> >  #ifdef CONFIG_BPF_SYSCALL
> >       bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
> > +#endif
> > +#ifdef CONFIG_CGROUP_BPF
> > +     if (aux->cgroup_atype !=3D CGROUP_BPF_ATTACH_TYPE_INVALID)
> > +             bpf_cgroup_atype_put(aux->cgroup_atype);
> >  #endif
> >       bpf_free_used_maps(aux);
> >       bpf_free_used_btfs(aux);
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 023239a10e7c..e849dd243624 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -555,6 +555,7 @@ static struct bpf_shim_tramp_link *cgroup_shim_allo=
c(const struct bpf_prog *prog
> >       bpf_prog_inc(p);
> >       bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
> >                     &bpf_shim_tramp_link_lops, p);
> > +     bpf_cgroup_atype_get(p->aux->attach_btf_id, cgroup_atype);
> >
> >       return shim_link;
> >  }
> > --
> > 2.36.1.476.g0c4daa206d-goog
> >
