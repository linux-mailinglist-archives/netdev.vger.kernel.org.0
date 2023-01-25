Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A867AD31
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbjAYJCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjAYJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:02:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D72DE4F;
        Wed, 25 Jan 2023 01:02:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 75EBD21BE5;
        Wed, 25 Jan 2023 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674637332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SlRMHnKgl2ysMiG3ziDgQVqy0pZ2+RMTN2tEUkXl1oQ=;
        b=CylERLDbieGu3PWTdvXLEld0Li+qbd7wIdoCwjIyDd+qG3j/xsmZaFNxHZ9BHqigKFDp2h
        G+luEBa1wjOWHFua4YAnGvwD5IYd5KDo2FdpDHLq+ELEUbPuYE6WIwO6oA3RlzeuL+Fv1J
        XkwT2InE7+nANi+BujeIlpRiAMYhk9g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 224651339E;
        Wed, 25 Jan 2023 09:02:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id reRPCBTw0GOqDAAAMHmgww
        (envelope-from <mhocko@suse.com>); Wed, 25 Jan 2023 09:02:12 +0000
Date:   Wed, 25 Jan 2023 10:02:11 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     akpm@linux-foundation.org, michel@lespinasse.org,
        jglisse@google.com, vbabka@suse.cz, hannes@cmpxchg.org,
        mgorman@techsingularity.net, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, peterz@infradead.org,
        ldufour@linux.ibm.com, paulmck@kernel.org, luto@kernel.org,
        songliubraving@fb.com, peterx@redhat.com, david@redhat.com,
        dhowells@redhat.com, hughd@google.com, bigeasy@linutronix.de,
        kent.overstreet@linux.dev, punit.agrawal@bytedance.com,
        lstoakes@gmail.com, peterjung1337@gmail.com, rientjes@google.com,
        axelrasmussen@google.com, joelaf@google.com, minchan@google.com,
        jannh@google.com, shakeelb@google.com, tatashin@google.com,
        edumazet@google.com, gthelen@google.com, gurua@google.com,
        arjunroy@google.com, soheil@google.com, hughlynch@google.com,
        leewalsh@google.com, posk@google.com, will@kernel.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com,
        chenhuacai@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        qianweili@huawei.com, wangzhou1@hisilicon.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org,
        airlied@gmail.com, daniel@ffwll.ch,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, l.stach@pengutronix.de,
        krzysztof.kozlowski@linaro.org, patrik.r.jakobsson@gmail.com,
        matthias.bgg@gmail.com, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        tomba@kernel.org, hjc@rock-chips.com, heiko@sntech.de,
        ray.huang@amd.com, kraxel@redhat.com, sre@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        tfiga@chromium.org, m.szyprowski@samsung.com, mchehab@kernel.org,
        dimitri.sivanich@hpe.com, zhangfei.gao@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        dgilbert@interlog.com, hdegoede@redhat.com, mst@redhat.com,
        jasowang@redhat.com, alex.williamson@redhat.com, deller@gmx.de,
        jayalk@intworks.biz, viro@zeniv.linux.org.uk, nico@fluxnic.net,
        xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miklos@szeredi.hu,
        mike.kravetz@oracle.com, muchun.song@linux.dev, bhe@redhat.com,
        andrii@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, perex@perex.cz, tiwai@suse.com,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
        loongarch@lists.linux.dev, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
        linux-um@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, nvdimm@lists.linux.dev,
        dmaengine@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org, kexec@lists.infradead.org,
        linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com,
        selinux@vger.kernel.org, alsa-devel@alsa-project.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 2/6] mm: replace VM_LOCKED_CLEAR_MASK with
 VM_LOCKED_MASK
Message-ID: <Y9DwE4Z8hB38aX6X@dhcp22.suse.cz>
References: <20230125083851.27759-1-surenb@google.com>
 <20230125083851.27759-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125083851.27759-3-surenb@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 25-01-23 00:38:47, Suren Baghdasaryan wrote:
> To simplify the usage of VM_LOCKED_CLEAR_MASK in clear_vm_flags(),
> replace it with VM_LOCKED_MASK bitmask and convert all users.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/mm.h | 4 ++--
>  kernel/fork.c      | 2 +-
>  mm/hugetlb.c       | 4 ++--
>  mm/mlock.c         | 6 +++---
>  mm/mmap.c          | 6 +++---
>  mm/mremap.c        | 2 +-
>  6 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b71f2809caac..da62bdd627bf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -421,8 +421,8 @@ extern unsigned int kobjsize(const void *objp);
>  /* This mask defines which mm->def_flags a process can inherit its parent */
>  #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
>  
> -/* This mask is used to clear all the VMA flags used by mlock */
> -#define VM_LOCKED_CLEAR_MASK	(~(VM_LOCKED | VM_LOCKONFAULT))
> +/* This mask represents all the VMA flag bits used by mlock */
> +#define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>  
>  /* Arch-specific flags to clear when updating VM flags on protection change */
>  #ifndef VM_ARCH_CLEAR
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 6683c1b0f460..03d472051236 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -669,7 +669,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
>  			tmp->anon_vma = NULL;
>  		} else if (anon_vma_fork(tmp, mpnt))
>  			goto fail_nomem_anon_vma_fork;
> -		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
> +		clear_vm_flags(tmp, VM_LOCKED_MASK);
>  		file = tmp->vm_file;
>  		if (file) {
>  			struct address_space *mapping = file->f_mapping;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d20c8b09890e..4ecdbad9a451 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6973,8 +6973,8 @@ static unsigned long page_table_shareable(struct vm_area_struct *svma,
>  	unsigned long s_end = sbase + PUD_SIZE;
>  
>  	/* Allow segments to share if only one is marked locked */
> -	unsigned long vm_flags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
> -	unsigned long svm_flags = svma->vm_flags & VM_LOCKED_CLEAR_MASK;
> +	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED_MASK;
> +	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED_MASK;
>  
>  	/*
>  	 * match the virtual addresses, permission and the alignment of the
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 0336f52e03d7..5c4fff93cd6b 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -497,7 +497,7 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
>  		if (vma->vm_start != tmp)
>  			return -ENOMEM;
>  
> -		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
> +		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
>  		newflags |= flags;
>  		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
>  		tmp = vma->vm_end;
> @@ -661,7 +661,7 @@ static int apply_mlockall_flags(int flags)
>  	struct vm_area_struct *vma, *prev = NULL;
>  	vm_flags_t to_add = 0;
>  
> -	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
> +	current->mm->def_flags &= ~VM_LOCKED_MASK;
>  	if (flags & MCL_FUTURE) {
>  		current->mm->def_flags |= VM_LOCKED;
>  
> @@ -681,7 +681,7 @@ static int apply_mlockall_flags(int flags)
>  	for_each_vma(vmi, vma) {
>  		vm_flags_t newflags;
>  
> -		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
> +		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
>  		newflags |= to_add;
>  
>  		/* Ignore errors */
> diff --git a/mm/mmap.c b/mm/mmap.c
> index d4abc6feced1..323bd253b25a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2671,7 +2671,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>  		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
>  					is_vm_hugetlb_page(vma) ||
>  					vma == get_gate_vma(current->mm))
> -			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
> +			clear_vm_flags(vma, VM_LOCKED_MASK);
>  		else
>  			mm->locked_vm += (len >> PAGE_SHIFT);
>  	}
> @@ -3340,8 +3340,8 @@ static struct vm_area_struct *__install_special_mapping(
>  	vma->vm_start = addr;
>  	vma->vm_end = addr + len;
>  
> -	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
> -	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
> +	init_vm_flags(vma, (vm_flags | mm->def_flags |
> +		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
>  	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>  
>  	vma->vm_ops = ops;
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 1b3ee02bead7..35db9752cb6a 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -687,7 +687,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
>  
>  	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
>  		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
> -		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
> +		clear_vm_flags(vma, VM_LOCKED_MASK);
>  
>  		/*
>  		 * anon_vma links of the old vma is no longer needed after its page
> -- 
> 2.39.1

-- 
Michal Hocko
SUSE Labs
