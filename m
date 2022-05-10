Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCE0520D1F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiEJFJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 01:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiEJFJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 01:09:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E96D46150;
        Mon,  9 May 2022 22:05:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so1099920pju.2;
        Mon, 09 May 2022 22:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=slY1omRS0mwv11+I6n9tNRvC3Bt2XnZ3D/KSuhls1B8=;
        b=gcn3VN3fxMDMM9BAGSBOPdXit+yohcImVTqODTQKb+uEjL863rT5sGYnw8tBEf2Ohv
         is7YylOWlO4fX6pNV0u0K32Ec065S1hATHNzrmi1+9uCvR1pnge3iKFEBMXIJLlfO0KX
         6dbU/IdP9Lnx/mTd9IqsMERs3Ju8CJbk1aj1g0SbhkF9ni8ecWDjeL3KL2stbgdafy6v
         C9CndRNRWsRxGC6mnlhmhX63Bz2EzpeHSh4jIiN/ZkBriugffuBAPhXbazNMUOd+4Oc6
         01uCj8r1zRZWFZayfn90OXk+pMQcghql93EZ7q1ip3kZ/Wn6gV7j60l2s2u4im1ItrY5
         l1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=slY1omRS0mwv11+I6n9tNRvC3Bt2XnZ3D/KSuhls1B8=;
        b=21hNhH3Qs41Wv2XFisv9GVgLtifu/04kvAM8D9CtUfWRgHO45oXq9MzQ2JUcqhk5yu
         ykHaBpsXeE/s5Qye3bC+DJ2XWWFue+k3b7sOX4Uen6kWwSDCohYL6l/FVrf3awIVweW+
         9+zG+c7XaWXUxOSmGlHcZtdZrHy49yMnAhQZr5cbVU8GRO0oqZ3LcBhwIDCMuSql3xII
         f8k0Q722yW5r+HFnQnQ63eAu3p4E6BCxTQlCGCQ7tToaY39sKX54NFdAl5+p/tZiZiXr
         s6xUrkhiKGOKU85geqygiAcfCEZ0LkY5MHmUK/fBXX1rJGVSg9+buatl3lZTBhYuHSMr
         2wwA==
X-Gm-Message-State: AOAM530KOX6xpn97RkUHZdnlwjIpsKo/8oqZopm2y9e0z8Jb/Hlb9zrU
        VLgZKmS+9UAFS/5JT3QL4QU=
X-Google-Smtp-Source: ABdhPJx+nfsjPJUBHOzv0FoqkcxExFALHVUhxQvq+ndrWuaNRQ87dqzqysXkzPd6UzpzgSMJEDz2Cg==
X-Received: by 2002:a17:90b:194f:b0:1dd:a47:3db5 with SMTP id nk15-20020a17090b194f00b001dd0a473db5mr11453364pjb.74.1652159148530;
        Mon, 09 May 2022 22:05:48 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:e8e5])
        by smtp.gmail.com with ESMTPSA id o5-20020a625a05000000b0050dc76281f9sm9461929pfb.211.2022.05.09.22.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 22:05:48 -0700 (PDT)
Date:   Mon, 9 May 2022 22:05:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 04/10] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220510050546.tpuslkld4rlrqexp@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-5-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429211540.715151-5-sdf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 02:15:34PM -0700, Stanislav Fomichev wrote:
> Previous patch adds 1:1 mapping between all 211 LSM hooks
> and bpf_cgroup program array. Instead of reserving a slot per
> possible hook, reserve 10 slots per cgroup for lsm programs.
> Those slots are dynamically allocated on demand and reclaimed.
> 
> It should be possible to eventually extend this idea to all hooks if
> the memory consumption is unacceptable and shrink overall effective
> programs array.
> 
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[33];        /*     0   264 */
> 	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> 	struct hlist_head          progs[33];            /*   264   264 */
> 	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> 	u8                         flags[33];            /*   528    33 */
> 
> 	/* XXX 7 bytes hole, try to pack */
> 
> 	struct list_head           storages;             /*   568    16 */
> 	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> 	struct bpf_prog_array *    inactive;             /*   584     8 */
> 	struct percpu_ref          refcnt;               /*   592    16 */
> 	struct work_struct         release_work;         /*   608    72 */
> 
> 	/* size: 680, cachelines: 11, members: 7 */
> 	/* sum members: 673, holes: 1, sum holes: 7 */
> 	/* last cacheline: 40 bytes */
> };
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup-defs.h |   3 +-
>  include/linux/bpf_lsm.h         |   6 --
>  kernel/bpf/bpf_lsm.c            |   5 --
>  kernel/bpf/cgroup.c             | 107 +++++++++++++++++++++++++++-----
>  4 files changed, 94 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index d5a70a35dace..359d3f16abea 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -10,7 +10,8 @@
>  
>  struct bpf_prog_array;
>  
> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> +#define CGROUP_LSM_NUM 10
>  
>  enum cgroup_bpf_attach_type {
>  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 7f0e59f5f9be..613de44aa429 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
>  void bpf_inode_storage_free(struct inode *inode);
>  
>  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> -int bpf_lsm_hook_idx(u32 btf_id);
>  
>  #else /* !CONFIG_BPF_LSM */
>  
> @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return -ENOENT;
>  }
>  
> -static inline int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return -EINVAL;
> -}
> -
>  #endif /* CONFIG_BPF_LSM */
>  
>  #endif /* _LINUX_BPF_LSM_H */
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index a0e68ef5dfb1..1079c747e061 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -91,11 +91,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return 0;
>  }
>  
> -int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> -}
> -
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>  			const struct bpf_prog *prog)
>  {
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 9cc38454e402..787ff6cf8d42 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -79,10 +79,13 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
>  	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
>  
>  	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> -	if (likely(cgrp))
> +	if (likely(cgrp)) {
> +		rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */

I've looked at bpf_lsm_attach_type_get/put, but still don't get it :)
shim_prog->aux->cgroup_atype stays the same for the life of shim_prog.
atype_usecnt will go up and down, but atype_usecnt == 0 is the only
interesting one from the pov of selecting atype in _get().
And there shim_prog will be detached and trampoline destroyed.
The shim_prog->aux->cgroup_atype deref below cannot be happening on
freed shim_prog.
So what is the point of this critical section and sync_rcu() ?
It seems none of it is necessary.

> It should be possible to eventually extend this idea to all hooks if
> the memory consumption is unacceptable and shrink overall effective
> programs array.

if BPF_LSM_CGROUP do atype differently looks too special.
Why not to do this generalization right now?
Do atype_get for all cgroup hooks and get rid of to_cgroup_bpf_attach_type ?
Combine ranges of attach_btf_id for lsm_cgroup and enum bpf_attach_type
for traditional cgroup hooks into single _get() method that returns a slot
in effective[] array ?
attach/detach/query apis won't notice this internal implementation detail.
