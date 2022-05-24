Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC105320C8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiEXCO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiEXCO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:14:57 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7149CC89
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:14:55 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id bg25so9771179wmb.4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZ2IOqUDaK3j+e0RV9j2+FjGdDIetc42lD8daSMHuOA=;
        b=fo/XzurneQVX4Q0pxmSjQFKQBxK0xGcibAhAraFBM3qVH7UPIOnBrs2RQHoxZKrZ6s
         YCUQ/tixtgt8hx+rRW5te/EZNLx4LzJfHa13JZreUaL/a6PNIv/AMdjUU76mW9Ytp69E
         XYqiuy3ko+CP+JcceFDeDyH31zTdyQjnFT1eki4SBBs2QCDASSgPrDDDWObHR5csqUO0
         5CM3NMFibpCDJXWcCDQ++z4OJlux5gM6+JEGl9f0S7lbSRKIW6c7OU8zP7zSaHntVrHM
         j5gz2HhUnjP7CFFRHFpWICzv13esctuSZi7S2+B2PV7exjMehX5DWD0/fKEddCEJi+Gs
         4XTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZ2IOqUDaK3j+e0RV9j2+FjGdDIetc42lD8daSMHuOA=;
        b=PQyPsveREvT08v9qRJ35Xk2y9R2vjMObOK2ASYy5RPX3riUHWZ8Yb7Z8UGwSEZ+kjt
         RU6gw7JlHRaUv2vPZEogzh8NPxdPBjXAU7GEXEm9y4JWJ55zLHsIkqJ6LSQ+ImfHF6M4
         SxeHQSajJ8jXZIK7S3MWKw1sKicRscvhv4eYnZkBj7csHtwZ1Befw4aHoYd5jAwKPMot
         AMvV/TAnULySwfej2CAft3uaIi3GS98xSIhTjVo9YKn8io9RdQHU/9emNseeM1J/B7+0
         tLbxzJpJMB1q5qbXyp9zTxJzIFlP8kG+xzy0wueYCsFSW8RQS78JDo5yWZQsbxp3Ulb5
         6NkQ==
X-Gm-Message-State: AOAM5305JIR/UZfaNopNrYdowx1n1OeEUfCIm9IAMZD7w41yeOlBNgHd
        XpEFV698XaiSmqwV310P66mdGU31wUqPNAoRiLoilg==
X-Google-Smtp-Source: ABdhPJyiDtAe9+jlp98apo9b03OXvDYEbtVQFV+UxxQJVOob+hJTNyQB4Gc+FJ6QAng1ZDUzD/PVPff52HxyrfPvF0U=
X-Received: by 2002:a05:600c:600a:b0:397:4d8f:2655 with SMTP id
 az10-20020a05600c600a00b003974d8f2655mr1632927wmb.92.1653358494321; Mon, 23
 May 2022 19:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-5-sdf@google.com>
 <20220521065614.w7jqj4xg2skfg73u@kafai-mbp>
In-Reply-To: <20220521065614.w7jqj4xg2skfg73u@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 23 May 2022 19:14:42 -0700
Message-ID: <CAKH8qBvzBNQVm3S7DQMZAoOvG7WxGdQPMZFRyAUquO3ZfiNtsw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 04/11] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, May 20, 2022 at 11:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, May 18, 2022 at 03:55:24PM -0700, Stanislav Fomichev wrote:
> > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > and bpf_cgroup program array. Instead of reserving a slot per
> > possible hook, reserve 10 slots per cgroup for lsm programs.
> > Those slots are dynamically allocated on demand and reclaimed.
> >
> > struct cgroup_bpf {
> >       struct bpf_prog_array *    effective[33];        /*     0   264 */
> >       /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> >       struct hlist_head          progs[33];            /*   264   264 */
> >       /* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> >       u8                         flags[33];            /*   528    33 */
> >
> >       /* XXX 7 bytes hole, try to pack */
> >
> >       struct list_head           storages;             /*   568    16 */
> >       /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> >       struct bpf_prog_array *    inactive;             /*   584     8 */
> >       struct percpu_ref          refcnt;               /*   592    16 */
> >       struct work_struct         release_work;         /*   608    72 */
> >
> >       /* size: 680, cachelines: 11, members: 7 */
> >       /* sum members: 673, holes: 1, sum holes: 7 */
> >       /* last cacheline: 40 bytes */
> > };
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup-defs.h |   3 +-
> >  include/linux/bpf_lsm.h         |   6 --
> >  kernel/bpf/bpf_lsm.c            |   5 --
> >  kernel/bpf/cgroup.c             | 135 +++++++++++++++++++++++++++++---
> >  4 files changed, 125 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > index d5a70a35dace..359d3f16abea 100644
> > --- a/include/linux/bpf-cgroup-defs.h
> > +++ b/include/linux/bpf-cgroup-defs.h
> > @@ -10,7 +10,8 @@
> >
> >  struct bpf_prog_array;
> >
> > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> > +#define CGROUP_LSM_NUM 10
> >
> >  enum cgroup_bpf_attach_type {
> >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > index 7f0e59f5f9be..613de44aa429 100644
> > --- a/include/linux/bpf_lsm.h
> > +++ b/include/linux/bpf_lsm.h
> > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> >  void bpf_inode_storage_free(struct inode *inode);
> >
> >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > -int bpf_lsm_hook_idx(u32 btf_id);
> >
> >  #else /* !CONFIG_BPF_LSM */
> >
> > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> >       return -ENOENT;
> >  }
> >
> > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -     return -EINVAL;
> > -}
> > -
> >  #endif /* CONFIG_BPF_LSM */
> >
> >  #endif /* _LINUX_BPF_LSM_H */
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 654c23577ad3..96503c3e7a71 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -71,11 +71,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> >       return 0;
> >  }
> >
> > -int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -     return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> > -}
> > -
> >  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> >                       const struct bpf_prog *prog)
> >  {
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 2c356a38f4cf..a959cdd22870 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -132,15 +132,110 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> >  }
> >
> >  #ifdef CONFIG_BPF_LSM
> > +struct list_head unused_bpf_lsm_atypes;
> > +struct list_head used_bpf_lsm_atypes;
> > +
> > +struct bpf_lsm_attach_type {
> > +     int index;
> > +     u32 btf_id;
> > +     int usecnt;
> > +     struct list_head atypes;
> > +     struct rcu_head rcu_head;
> > +};
> > +
> > +static int __init bpf_lsm_attach_type_init(void)
> > +{
> > +     struct bpf_lsm_attach_type *atype;
> > +     int i;
> > +
> > +     INIT_LIST_HEAD_RCU(&unused_bpf_lsm_atypes);
> > +     INIT_LIST_HEAD_RCU(&used_bpf_lsm_atypes);
> > +
> > +     for (i = 0; i < CGROUP_LSM_NUM; i++) {
> > +             atype = kzalloc(sizeof(*atype), GFP_KERNEL);
> > +             if (!atype)
> > +                     continue;
> > +
> > +             atype->index = i;
> > +             list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
> > +     }
> > +
> > +     return 0;
> > +}
> > +late_initcall(bpf_lsm_attach_type_init);
> > +
> >  static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
> >  {
> > -     return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> > +     struct bpf_lsm_attach_type *atype;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> > +     list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
> > +             if (atype->btf_id != attach_btf_id)
> > +                     continue;
> > +
> > +             atype->usecnt++;
> > +             return CGROUP_LSM_START + atype->index;
> > +     }
> > +
> > +     atype = list_first_or_null_rcu(&unused_bpf_lsm_atypes, struct bpf_lsm_attach_type, atypes);
> > +     if (!atype)
> > +             return -E2BIG;
> > +
> > +     list_del_rcu(&atype->atypes);
> > +     atype->btf_id = attach_btf_id;
> > +     atype->usecnt = 1;
> > +     list_add_tail_rcu(&atype->atypes, &used_bpf_lsm_atypes);
> > +
> > +     return CGROUP_LSM_START + atype->index;
> > +}
> > +
> > +static void bpf_lsm_attach_type_reclaim(struct rcu_head *head)
> > +{
> > +     struct bpf_lsm_attach_type *atype =
> > +             container_of(head, struct bpf_lsm_attach_type, rcu_head);
> > +
> > +     atype->btf_id = 0;
> > +     atype->usecnt = 0;
> > +     list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
> hmm...... no need to hold the cgroup_mutex when changing
> the unused_bpf_lsm_atypes list ?
> but it is a rcu callback, so spinlock is needed.

Oh, good point.

> > +}
> > +
> > +static void bpf_lsm_attach_type_put(u32 attach_btf_id)
> > +{
> > +     struct bpf_lsm_attach_type *atype;
> > +
> > +     lockdep_assert_held(&cgroup_mutex);
> > +
> > +     list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
> > +             if (atype->btf_id != attach_btf_id)
> > +                     continue;
> > +
> > +             if (--atype->usecnt <= 0) {
> > +                     list_del_rcu(&atype->atypes);
> > +                     WARN_ON_ONCE(atype->usecnt < 0);
> > +
> > +                     /* call_rcu here prevents atype reuse within
> > +                      * the same rcu grace period.
> > +                      * shim programs use __bpf_prog_enter_lsm_cgroup
> > +                      * which starts RCU read section.
> It is a bit unclear for me to think through why
> there is no need to assign 'shim_prog->aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID'
> here before reclaim and the shim_prog->bpf_func does not need to check
> shim_prog->aux->cgroup_atype before using it.
>
> It will be very useful to have a few word comments here to explain this.

My thinking is:
- shim program starts rcu read section (via __bpf_prog_enter_lsm_cgroup)
- on release (bpf_lsm_attach_type_put) we do
list_del_rcu(&atype->atypes) to make sure that particular atype is
"reserved" until grace period and not being reused
- we won't reuse that particular atype for new attachments until grace period
- existing shim programs will still use this atype until grace period,
but we rely on cgroup effective array be empty by that point
- after grace period, we reclaim that atype

Does it clarify your concern? Am I missing something? Not sure how to
put it into a small/concise comment :-)

(maybe moot after your next comment)

> > +                      */
> > +                     call_rcu(&atype->rcu_head, bpf_lsm_attach_type_reclaim);
> How about doing this bpf_lsm_attach_type_put() in bpf_prog_free_deferred().
> And only do it for the shim_prog but not the cgroup-lsm prog.
> The shim_prog is the only one needing cgroup_atype.  Then the cgroup_atype
> naturally can be reused when the shim_prog is being destroyed.
>
> bpf_prog_free_deferred has already gone through a rcu grace
> period (__bpf_prog_put_rcu) and it can block, so cgroup_mutex
> can be used.
>
> The need for the rcu_head here should go away also.  The v6 array approach
> could be reconsidered.
>
> The cgroup-lsm prog does not necessarily need to hold a usecnt to the cgroup_atype.
> Their aux->cgroup_atype can be CGROUP_BPF_ATTACH_TYPE_INVALID.
> My understanding is the replace_prog->aux->cgroup_atype during attach
> is an optimization, it can always search again.

I've considered using bpf_prog_free (I think Alexei also suggested
it?), but not ended up using it because of the situation where the
program can be attached, then detached but not actually freed (there
is a link or an fd holding it); in this case we'll be blocking that
atype reuse. But not sure if it's a real problem?

Let me try to see if it works again, your suggestions make sense.
(especially the part about cgroup_atype for shim only, I don't like
all these replace_prog->aux->cgroup_atype = atype in weird places)

Thank you for the review!
