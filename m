Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CC25243DF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 06:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345843AbiELEII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 00:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiELEIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 00:08:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB761C194A;
        Wed, 11 May 2022 21:07:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso3764960pjb.5;
        Wed, 11 May 2022 21:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3a4YxQ/WF7oORdxUbgy4gguqjUrbBoNLgvefwmvTIag=;
        b=el1LkYqGyx9AddWKsiV4y734Zg4kv9p2L5IIYG9GwWWT7hOOujXKPujBZFmkRR/ff2
         gLzLQO0ZPQg77NI5LZcMdV/S2oi+CtS6MDiJf7SPvp2kLj3TWUU+of5V2D0GPrqHmw+W
         hKiWmZIFuHbp3IR2bLFhSKgEyf/KelPWdljGZr7zOA8tv37EyHt0/tbUeT+4ugex4cQW
         peAWIHoCeiK9Eqzm0muh+I8qakIaYiA4qhEmO1glm6/GxqKMK0OWj6XKMRmSWBOQEtGx
         jbxfhOYZZ4pMZ79qVUmZcR8edzuNyFkS95yaQLe4scCqM7l88S+WVZoWRwoXSz2Bji7U
         6z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3a4YxQ/WF7oORdxUbgy4gguqjUrbBoNLgvefwmvTIag=;
        b=k0mzAPUtScjNVDSJQWpLtuQM1b+WX2ERCwmwHTsQkZuNJESxtaAJojkJc7hmUbjHua
         Or3JjRk98UR5tXL8e0cEwK3MoVhaOkjzkXfUvsbPEbw033xG+1jevmbhVoOuOWLW+RUO
         dgKR2OC8TMtb5euUESg3dl3ggwols0SE6IoK1lVAF2ePkFfcXHh16PksSfNdWPspv7Bx
         pNm9cWTwtFubeKB8S4zDf8MTuIw7hWFjlVo6iBYOvmD4SwCgOxgaEXNuYRZc0wwIwDbd
         GoR5qn6eT2DtMY1efAQhzqNJyYB5PIrn3Y9cJdkVI/RVZzmXkATpiktb7j0a2rsCTX46
         ffJg==
X-Gm-Message-State: AOAM530ZB8ISVUGq/QofavXfKimO01KLf1ieqGMIjwFfhRfA5JgjF9UC
        aMhDRBWJJZ8n/XpxgZ5OeDlB4CqFNzs=
X-Google-Smtp-Source: ABdhPJzxrLyLxheZ40sv8LueFEVbUd4ds3KJWW0ZG7Yg3Ned3l2RU1PdBfyixx7N48/FevMw+FGmNA==
X-Received: by 2002:a17:902:82c8:b0:15c:f7c7:ef9d with SMTP id u8-20020a17090282c800b0015cf7c7ef9dmr28359778plz.44.1652328479202;
        Wed, 11 May 2022 21:07:59 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:6b86])
        by smtp.gmail.com with ESMTPSA id d11-20020aa7868b000000b0050dc7628196sm2528110pfo.112.2022.05.11.21.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 21:07:58 -0700 (PDT)
Date:   Wed, 11 May 2022 21:07:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 04/10] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220512040756.gmwhvnikmta2zdc3@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-5-sdf@google.com>
 <20220510050546.tpuslkld4rlrqexp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YnqhWTshFLqMY9kl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnqhWTshFLqMY9kl@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 10:31:05AM -0700, sdf@google.com wrote:
> On 05/09, Alexei Starovoitov wrote:
> > On Fri, Apr 29, 2022 at 02:15:34PM -0700, Stanislav Fomichev wrote:
> > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > and bpf_cgroup program array. Instead of reserving a slot per
> > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > Those slots are dynamically allocated on demand and reclaimed.
> > >
> > > It should be possible to eventually extend this idea to all hooks if
> > > the memory consumption is unacceptable and shrink overall effective
> > > programs array.
> > >
> > > struct cgroup_bpf {
> > > 	struct bpf_prog_array *    effective[33];        /*     0   264 */
> > > 	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> > > 	struct hlist_head          progs[33];            /*   264   264 */
> > > 	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> > > 	u8                         flags[33];            /*   528    33 */
> > >
> > > 	/* XXX 7 bytes hole, try to pack */
> > >
> > > 	struct list_head           storages;             /*   568    16 */
> > > 	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> > > 	struct bpf_prog_array *    inactive;             /*   584     8 */
> > > 	struct percpu_ref          refcnt;               /*   592    16 */
> > > 	struct work_struct         release_work;         /*   608    72 */
> > >
> > > 	/* size: 680, cachelines: 11, members: 7 */
> > > 	/* sum members: 673, holes: 1, sum holes: 7 */
> > > 	/* last cacheline: 40 bytes */
> > > };
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf-cgroup-defs.h |   3 +-
> > >  include/linux/bpf_lsm.h         |   6 --
> > >  kernel/bpf/bpf_lsm.c            |   5 --
> > >  kernel/bpf/cgroup.c             | 107 +++++++++++++++++++++++++++-----
> > >  4 files changed, 94 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/include/linux/bpf-cgroup-defs.h
> > b/include/linux/bpf-cgroup-defs.h
> > > index d5a70a35dace..359d3f16abea 100644
> > > --- a/include/linux/bpf-cgroup-defs.h
> > > +++ b/include/linux/bpf-cgroup-defs.h
> > > @@ -10,7 +10,8 @@
> > >
> > >  struct bpf_prog_array;
> > >
> > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> > > +#define CGROUP_LSM_NUM 10
> > >
> > >  enum cgroup_bpf_attach_type {
> > >  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > index 7f0e59f5f9be..613de44aa429 100644
> > > --- a/include/linux/bpf_lsm.h
> > > +++ b/include/linux/bpf_lsm.h
> > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto
> > bpf_inode_storage_delete_proto;
> > >  void bpf_inode_storage_free(struct inode *inode);
> > >
> > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t
> > *bpf_func);
> > > -int bpf_lsm_hook_idx(u32 btf_id);
> > >
> > >  #else /* !CONFIG_BPF_LSM */
> > >
> > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const
> > struct bpf_prog *prog,
> > >  	return -ENOENT;
> > >  }
> > >
> > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > -{
> > > -	return -EINVAL;
> > > -}
> > > -
> > >  #endif /* CONFIG_BPF_LSM */
> > >
> > >  #endif /* _LINUX_BPF_LSM_H */
> > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > index a0e68ef5dfb1..1079c747e061 100644
> > > --- a/kernel/bpf/bpf_lsm.c
> > > +++ b/kernel/bpf/bpf_lsm.c
> > > @@ -91,11 +91,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog
> > *prog,
> > >  	return 0;
> > >  }
> > >
> > > -int bpf_lsm_hook_idx(u32 btf_id)
> > > -{
> > > -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> > > -}
> > > -
> > >  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> > >  			const struct bpf_prog *prog)
> > >  {
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 9cc38454e402..787ff6cf8d42 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -79,10 +79,13 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void
> > *ctx,
> > >  	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct
> > bpf_prog, insnsi));
> > >
> > >  	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > -	if (likely(cgrp))
> > > +	if (likely(cgrp)) {
> > > +		rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> 
> > I've looked at bpf_lsm_attach_type_get/put, but still don't get it :)
> > shim_prog->aux->cgroup_atype stays the same for the life of shim_prog.
> > atype_usecnt will go up and down, but atype_usecnt == 0 is the only
> > interesting one from the pov of selecting atype in _get().
> > And there shim_prog will be detached and trampoline destroyed.
> > The shim_prog->aux->cgroup_atype deref below cannot be happening on
> > freed shim_prog.
> > So what is the point of this critical section and sync_rcu() ?
> > It seems none of it is necessary.
> 
> I was trying to guard against the reuse of the same cgroup_atype:
> 
> CPU0                                     CPU1
> __cgroup_bpf_run_lsm_socket:
> atype = shim_prog->aux->cgroup_atype
>                                          __cgroup_bpf_detach
>                                          bpf_lsm_attach_type_put(shim_prog
> attach_btf_id)

but inbetween the two ops on CPU1 you're doing:
bpf_trampoline_unlink_cgroup_shim
which will go through the trampoline update.
I guess it CPU0 runs sleepable prog for long time
there is a chance...
Maybe put bpf_lsm_attach_type_put in shim_prog free path?

>                                          __cgroup_bpf_attach(another hook)
>                                          bpf_lsm_attach_type_get(another
> btf_id)
>                                          ^^^ can reuse the same cgroup_atype
> array = cgrp->effective[atype]
> ^^^ run effective from another btf_id?
> 
> So I added that sync_rcu to wait for existing shim_prog users to exit.
> Am I too paranoid? Maybe if I move bpf_lsm_attach_type_put deep into
> bpf_prog_put (deferred path) that won't be an issue and we can drop
> rcu_sync+read lock?

Mainly not excited about sync_rcu. It was causing latency issues in the past.
Please use call_rcu whenever possible.

> > > It should be possible to eventually extend this idea to all hooks if
> > > the memory consumption is unacceptable and shrink overall effective
> > > programs array.
> 
> > if BPF_LSM_CGROUP do atype differently looks too special.
> > Why not to do this generalization right now?
> > Do atype_get for all cgroup hooks and get rid of
> > to_cgroup_bpf_attach_type ?
> > Combine ranges of attach_btf_id for lsm_cgroup and enum bpf_attach_type
> > for traditional cgroup hooks into single _get() method that returns a slot
> > in effective[] array ?
> > attach/detach/query apis won't notice this internal implementation detail.
> 
> I'm being extra cautious by using this new allocation scheme for LSM only.
> If there is no general pushback, I can try to convert everything at the
> same time.

Hopefully generalization of the mechanism will move atype_get/put logic
into a path that is clearly race free.
