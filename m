Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5D5222B8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348237AbiEJRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiEJRfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:35:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8DE36173
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g129-20020a25db87000000b0064b0d671050so2351954ybf.6
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+OItLiQE6V8bbnL9yESMNsFuPWf1H2cgWOWhkugLbts=;
        b=C7uHnMQH/g8c4RQwEgQXe4iSngwlEhlbNu8w8o2e9ZZmCvYNC6h/ztU1TomM1+2+pU
         5w6ss35/qQ8cdqeviXf88HW9jauycb9ePQV5jBs5xWONQdJlDCcFle9WlKJlTxrxI+cq
         igyaKezOXn17wIMFftdSC2GmAmyb6RyjkcdlgAJ+XNUwZDnQWJV37t5qR5rEGTv2Nk2i
         fJ1M2tkbFQV2scAO5/E0MfqdDmGR5HSZt6Wi6KaTLRcK2DaTVXuZuLUNzyHaqxhZS1B9
         1NtWUdFoiiqselXALoSIBxFznLhceBwgbUDXiL30pb93svi0tSMUfDOB/iDNA5C+kDtU
         Y6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+OItLiQE6V8bbnL9yESMNsFuPWf1H2cgWOWhkugLbts=;
        b=xZh3h4iPiDTcSxCqu7YAsykp84Bd33rxOchoS+ghYOhyg50CEcVKaVVXLYVly6aThl
         6evbrch5yzJL3/Ti5rkGCvGCX4ORSxiGBist3wPKst+3xcqNFa+Q10tteji3aSqyF75/
         UACQ0ycX4jh5TVgREohzLCU3uCz505A7JXlNE/GNOi9j6Jd4WwvlPQrJfJN2gMDlh/gD
         QoIsFJf5/Yqs822rJZkxfwSKFVoMjN/7A1TgehmTg5uyPTL3Z8NFCyBI8y5W6/Bx1BYN
         HT1WtsjCd887EcMa+ZHDEEdNVJWeSqJ/GaWbbKR1+eNy2MuVscz+kuuyyce1RGNjvDtl
         kFtg==
X-Gm-Message-State: AOAM531Iquv9XHH7++76Yp+wSJEebkjw6wFSu6Sb0qmfTF+hKfkigik6
        suDTEP+YCue0s7s8D0EaHTLoLQs=
X-Google-Smtp-Source: ABdhPJzn7uyZpM0TZ1IyM3QlV/L2ZjzJjdOoEArLgCgMJaHR3V0/cutOa8vWeP+TULrBJY7f1Ragtr0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:e4f0:6894:4cb0:4ccc])
 (user=sdf job=sendgmr) by 2002:a25:e056:0:b0:645:d68d:8474 with SMTP id
 x83-20020a25e056000000b00645d68d8474mr19379979ybg.294.1652203867668; Tue, 10
 May 2022 10:31:07 -0700 (PDT)
Date:   Tue, 10 May 2022 10:31:05 -0700
In-Reply-To: <20220510050546.tpuslkld4rlrqexp@MBP-98dd607d3435.dhcp.thefacebook.com>
Message-Id: <YnqhWTshFLqMY9kl@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-5-sdf@google.com>
 <20220510050546.tpuslkld4rlrqexp@MBP-98dd607d3435.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next v6 04/10] bpf: minimize number of allocated lsm
 slots per program
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/09, Alexei Starovoitov wrote:
> On Fri, Apr 29, 2022 at 02:15:34PM -0700, Stanislav Fomichev wrote:
> > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > and bpf_cgroup program array. Instead of reserving a slot per
> > possible hook, reserve 10 slots per cgroup for lsm programs.
> > Those slots are dynamically allocated on demand and reclaimed.
> >
> > It should be possible to eventually extend this idea to all hooks if
> > the memory consumption is unacceptable and shrink overall effective
> > programs array.
> >
> > struct cgroup_bpf {
> > 	struct bpf_prog_array *    effective[33];        /*     0   264 */
> > 	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> > 	struct hlist_head          progs[33];            /*   264   264 */
> > 	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> > 	u8                         flags[33];            /*   528    33 */
> >
> > 	/* XXX 7 bytes hole, try to pack */
> >
> > 	struct list_head           storages;             /*   568    16 */
> > 	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> > 	struct bpf_prog_array *    inactive;             /*   584     8 */
> > 	struct percpu_ref          refcnt;               /*   592    16 */
> > 	struct work_struct         release_work;         /*   608    72 */
> >
> > 	/* size: 680, cachelines: 11, members: 7 */
> > 	/* sum members: 673, holes: 1, sum holes: 7 */
> > 	/* last cacheline: 40 bytes */
> > };
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup-defs.h |   3 +-
> >  include/linux/bpf_lsm.h         |   6 --
> >  kernel/bpf/bpf_lsm.c            |   5 --
> >  kernel/bpf/cgroup.c             | 107 +++++++++++++++++++++++++++-----
> >  4 files changed, 94 insertions(+), 27 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup-defs.h  
> b/include/linux/bpf-cgroup-defs.h
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
> >  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > index 7f0e59f5f9be..613de44aa429 100644
> > --- a/include/linux/bpf_lsm.h
> > +++ b/include/linux/bpf_lsm.h
> > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto  
> bpf_inode_storage_delete_proto;
> >  void bpf_inode_storage_free(struct inode *inode);
> >
> >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t  
> *bpf_func);
> > -int bpf_lsm_hook_idx(u32 btf_id);
> >
> >  #else /* !CONFIG_BPF_LSM */
> >
> > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const  
> struct bpf_prog *prog,
> >  	return -ENOENT;
> >  }
> >
> > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -	return -EINVAL;
> > -}
> > -
> >  #endif /* CONFIG_BPF_LSM */
> >
> >  #endif /* _LINUX_BPF_LSM_H */
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index a0e68ef5dfb1..1079c747e061 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -91,11 +91,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog  
> *prog,
> >  	return 0;
> >  }
> >
> > -int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> > -}
> > -
> >  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> >  			const struct bpf_prog *prog)
> >  {
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 9cc38454e402..787ff6cf8d42 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -79,10 +79,13 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void  
> *ctx,
> >  	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct  
> bpf_prog, insnsi));
> >
> >  	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > -	if (likely(cgrp))
> > +	if (likely(cgrp)) {
> > +		rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */

> I've looked at bpf_lsm_attach_type_get/put, but still don't get it :)
> shim_prog->aux->cgroup_atype stays the same for the life of shim_prog.
> atype_usecnt will go up and down, but atype_usecnt == 0 is the only
> interesting one from the pov of selecting atype in _get().
> And there shim_prog will be detached and trampoline destroyed.
> The shim_prog->aux->cgroup_atype deref below cannot be happening on
> freed shim_prog.
> So what is the point of this critical section and sync_rcu() ?
> It seems none of it is necessary.

I was trying to guard against the reuse of the same cgroup_atype:

CPU0                                     CPU1
__cgroup_bpf_run_lsm_socket:
atype = shim_prog->aux->cgroup_atype
                                          __cgroup_bpf_detach
                                          bpf_lsm_attach_type_put(shim_prog  
attach_btf_id)
                                          __cgroup_bpf_attach(another hook)
                                          bpf_lsm_attach_type_get(another  
btf_id)
                                          ^^^ can reuse the same cgroup_atype
array = cgrp->effective[atype]
^^^ run effective from another btf_id?

So I added that sync_rcu to wait for existing shim_prog users to exit.
Am I too paranoid? Maybe if I move bpf_lsm_attach_type_put deep into
bpf_prog_put (deferred path) that won't be an issue and we can drop
rcu_sync+read lock?

> > It should be possible to eventually extend this idea to all hooks if
> > the memory consumption is unacceptable and shrink overall effective
> > programs array.

> if BPF_LSM_CGROUP do atype differently looks too special.
> Why not to do this generalization right now?
> Do atype_get for all cgroup hooks and get rid of  
> to_cgroup_bpf_attach_type ?
> Combine ranges of attach_btf_id for lsm_cgroup and enum bpf_attach_type
> for traditional cgroup hooks into single _get() method that returns a slot
> in effective[] array ?
> attach/detach/query apis won't notice this internal implementation detail.

I'm being extra cautious by using this new allocation scheme for LSM only.
If there is no general pushback, I can try to convert everything at the
same time.
