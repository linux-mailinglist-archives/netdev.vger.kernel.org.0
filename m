Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D23464C86
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348907AbhLAL0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbhLAL0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:26:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C7C061574;
        Wed,  1 Dec 2021 03:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38DEACE1DD0;
        Wed,  1 Dec 2021 11:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964ADC53FCC;
        Wed,  1 Dec 2021 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638357809;
        bh=xhWa9kYaaIqXYR6S1IYSxmMPz5H4LcVfM2CN5iPCnHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g09M9yxJvo7hsHf5vy4qcxtPlW45DNqrZR05xtb5tqEpEJwS7wuI4yI4QFfdfwQiY
         rMNtEoGQ5QwOTZ2ksIkHJ+VOvpCuIanml8dwZFX8ZeS1Etpc8kagCpplVTPyGVZHLs
         egrthvul+ut+zt6Pli9iGntqyAFxdqraT1h7UmkWr+kD0rCmn5U6rTeQKe2SNvNZSb
         MXWy8vU+OP8VmrBtf49sFgAFLpckkoBujLj7/7pMOQZ5W3tsS3zQXJlR+AJdOWshqS
         NNPQzZX/rTlC9YmEiTTaWD7/ee2cKyJsicGz675FXZBlXZy/rgAS6ttSmaSPVvf58E
         +j+nsu+9+1oRw==
Date:   Wed, 1 Dec 2021 13:23:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Subject: Re: [PATCH -next v2] bpf: Add oversize check before call kvmalloc()
Message-ID: <YadbLDfAG95RWDgz@unreal>
References: <1638322402-54754-1-git-send-email-cuibixuan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638322402-54754-1-git-send-email-cuibixuan@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 09:33:22AM +0800, Bixuan Cui wrote:
> Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add
> the oversize check. When the allocation is larger than what kvmalloc()
> supports, the following warning triggered:
> 
> WARNING: CPU: 1 PID: 372 at mm/util.c:597 kvmalloc_node+0x111/0x120
> mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 372 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 60
> 20 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 4f 20 d1 ff <0f> 0b e9
> 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 36
> RSP: 0018:ffffc90002bf7c98 EFLAGS: 00010216
> RAX: 00000000000000ec RBX: 1ffff9200057ef9f RCX: ffffc9000ac63000
> RDX: 0000000000040000 RSI: ffffffff81a6a621 RDI: 0000000000000003
> RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
> R10: ffffffff81a6a5de R11: 0000000000000000 R12: 00000000ffff9aaa
> R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  00007f05f2573700(0000) GS:ffff8880b9d00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f424000 CR3: 0000000027d2c000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  kvmalloc include/linux/slab.h:741 [inline]
>  map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
>  __sys_bpf+0x3a5b/0x5f00 kernel/bpf/syscall.c:4603
>  __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The type of 'value_size' is u32, its value may exceed INT_MAX.
> 
> Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com
> Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
> ---
> Changes in v2:
> * Change the err from -EINVAL to -E2BIG;
> * Change "goto err_put" to "goto free_key";

Please fix kvmalloc instead.
https://lore.kernel.org/all/YadOjJXMTjP85MQx@unreal

diff --git a/mm/util.c b/mm/util.c
index 741ba32a43ac..3749f4a16ab9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -594,7 +594,7 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
                return ret;

        /* Don't even allow crazy sizes */
-       if (WARN_ON_ONCE(size > INT_MAX))
+       if (size > INT_MAX)
                return NULL;

        return __vmalloc_node(size, 1, flags, node,


> 
>  kernel/bpf/syscall.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1033ee8..30aabdd 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1094,6 +1094,10 @@ static int map_lookup_elem(union bpf_attr *attr)
>  	}
>  
>  	value_size = bpf_map_value_size(map);
> +	if (value_size > INT_MAX) {
> +		err = -E2BIG;
> +		goto free_key;
> +	}
>  
>  	err = -ENOMEM;
>  	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
> -- 
> 1.8.3.1
> 
