Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7FDDA05
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfJSSPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:15:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39959 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfJSSPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:15:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so5800534pfb.7;
        Sat, 19 Oct 2019 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hpln9PUIoPv5oft5uSHAYxpNgr53ZiQaS7Vg+5P2qqU=;
        b=A0SZSwDAcdMl3Kqqq+5k6AZh6epqsi6Nphk6a/+Z00/PwLSzZMeKVIl0vFnoOF8NKM
         2+Iq5a9l+R5igupTWpXRxpH1QrQMC0ArIr9aBPUMVDApn1o2NowpcIkBlItjVMl7OWRb
         5FyUH4ddmBXyCpJJ7HVPSFq6b+I+4N3upeJHH+bWRyir0jDbEJ2WaKcwXaePmD0aOrav
         jcEuulUBdngtkCl8R0v93EHH7YcW4A3TFjN6McIYOLwnGXWMVB7MX4X2IXAG8ow+nW/V
         ghmfoOXPEPJVV2wliFrqo/Izr37t55zaLJ3m/QDKNkkllKy2Xontcj32hIe+hHoLSoRS
         eRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hpln9PUIoPv5oft5uSHAYxpNgr53ZiQaS7Vg+5P2qqU=;
        b=HCSW9QaAIHr4tkH9x6vjF4K/XUj3a35LDDn30Fkoj8Tr6fxlcYgkwAfseH3hVCRJO4
         MlyWMxWg9fw/PjobLA17kiFWwt7kn1wfJIMorXWuA08Uybpyt2w51fm343I2osseK2Th
         jgzDQROTS5HkTu8PzMIp46wZl6O2GEJYQYaOlyCu6CeXjuDIaApTYScAnjj6q98Fs5B2
         SHVWt81qwoKSl9ShMeZx1WkoLfUP+Bv8CfFG98avulObIPsOwBLhzv5kWW1ADBaEB1zY
         mnggFjymn8nf4F0b/5GAhTnwAOBuXIu4PUPXRPlp6vICKWiJS3113szbOEzPx926n3GQ
         9BIw==
X-Gm-Message-State: APjAAAUrKQo9jpgup4AabVY0NPEFhhiZjjQynbMTWIig7xo0rG85tLsa
        61b6LZBhnvH3wv9n3n6s//8=
X-Google-Smtp-Source: APXvYqyVUOx8svIWYOi2E2AqQLkghA2rODjFQGz6vtBg5bXahSguxuVAcNkSZDOU13dQaSqqsDooSg==
X-Received: by 2002:a17:90a:aa81:: with SMTP id l1mr141147pjq.73.1571508930842;
        Sat, 19 Oct 2019 11:15:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id g35sm9462179pgg.42.2019.10.19.11.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2019 11:15:29 -0700 (PDT)
Subject: Re: [PATCH] net: fix sk_page_frag() recursion from memory reclaim
To:     Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dc6ff540-e7fc-695e-ed71-2bc0a92a0a9b@gmail.com>
Date:   Sat, 19 Oct 2019 11:15:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/19 10:01 AM, Tejun Heo wrote:
> From f0335a5d14d3596d36e3ffddb2fd4fa0dc6ca9c2 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sat, 19 Oct 2019 09:10:57 -0700
> 
> sk_page_frag() optimizes skb_frag allocations by using per-task
> skb_frag cache when it knows it's the only user.  The condition is
> determined by seeing whether the socket allocation mask allows
> blocking - if the allocation may block, it obviously owns the task's
> context and ergo exclusively owns current->task_frag.
> 
> Unfortunately, this misses recursion through memory reclaim path.
> Please take a look at the following backtrace.
> 
>  [2] RIP: 0010:tcp_sendmsg_locked+0xccf/0xe10
>      ...
>      tcp_sendmsg+0x27/0x40
>      sock_sendmsg+0x30/0x40
>      sock_xmit.isra.24+0xa1/0x170 [nbd]
>      nbd_send_cmd+0x1d2/0x690 [nbd]
>      nbd_queue_rq+0x1b5/0x3b0 [nbd]
>      __blk_mq_try_issue_directly+0x108/0x1b0
>      blk_mq_request_issue_directly+0xbd/0xe0
>      blk_mq_try_issue_list_directly+0x41/0xb0
>      blk_mq_sched_insert_requests+0xa2/0xe0
>      blk_mq_flush_plug_list+0x205/0x2a0
>      blk_flush_plug_list+0xc3/0xf0
>  [1] blk_finish_plug+0x21/0x2e
>      _xfs_buf_ioapply+0x313/0x460
>      __xfs_buf_submit+0x67/0x220
>      xfs_buf_read_map+0x113/0x1a0
>      xfs_trans_read_buf_map+0xbf/0x330
>      xfs_btree_read_buf_block.constprop.42+0x95/0xd0
>      xfs_btree_lookup_get_block+0x95/0x170
>      xfs_btree_lookup+0xcc/0x470
>      xfs_bmap_del_extent_real+0x254/0x9a0
>      __xfs_bunmapi+0x45c/0xab0
>      xfs_bunmapi+0x15/0x30
>      xfs_itruncate_extents_flags+0xca/0x250
>      xfs_free_eofblocks+0x181/0x1e0
>      xfs_fs_destroy_inode+0xa8/0x1b0
>      destroy_inode+0x38/0x70
>      dispose_list+0x35/0x50
>      prune_icache_sb+0x52/0x70
>      super_cache_scan+0x120/0x1a0
>      do_shrink_slab+0x120/0x290
>      shrink_slab+0x216/0x2b0
>      shrink_node+0x1b6/0x4a0
>      do_try_to_free_pages+0xc6/0x370
>      try_to_free_mem_cgroup_pages+0xe3/0x1e0
>      try_charge+0x29e/0x790
>      mem_cgroup_charge_skmem+0x6a/0x100
>      __sk_mem_raise_allocated+0x18e/0x390
>      __sk_mem_schedule+0x2a/0x40
>  [0] tcp_sendmsg_locked+0x8eb/0xe10
>      tcp_sendmsg+0x27/0x40
>      sock_sendmsg+0x30/0x40
>      ___sys_sendmsg+0x26d/0x2b0
>      __sys_sendmsg+0x57/0xa0
>      do_syscall_64+0x42/0x100
>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> In [0], tcp_send_msg_locked() was using current->page_frag when it
> called sk_wmem_schedule().  It already calculated how many bytes can
> be fit into current->page_frag.  Due to memory pressure,
> sk_wmem_schedule() called into memory reclaim path which called into
> xfs and then IO issue path.  Because the filesystem in question is
> backed by nbd, the control goes back into the tcp layer - back into
> tcp_sendmsg_locked().
> 
> nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
> sense - it's in the process of freeing memory and wants to be able to,
> e.g., drop clean pages to make forward progress.  However, this
> confused sk_page_frag() called from [2].  Because it only tests
> whether the allocation allows blocking which it does, it now thinks
> current->page_frag can be used again although it already was being
> used in [0].
> 
> After [2] used current->page_frag, the offset would be increased by
> the used amount.  When the control returns to [0],
> current->page_frag's offset is increased and the previously calculated
> number of bytes now may overrun the end of allocated memory leading to
> silent memory corruptions.
> 
> Fix it by updating sk_page_frag() to test __GFP_MEMALLOC and not use
> current->task_frag if set.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: stable@vger.kernel.org
> ---
>  include/net/sock.h | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 2c53f1a1d905..4e2ca38acc3c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2233,12 +2233,21 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>   * sk_page_frag - return an appropriate page_frag
>   * @sk: socket
>   *
> - * If socket allocation mode allows current thread to sleep, it means its
> - * safe to use the per task page_frag instead of the per socket one.
> + * Use the per task page_frag instead of the per socket one for
> + * optimization when we know there can be no other users.
> + *
> + * 1. The socket allocation mode allows current thread to sleep.  This is
> + *    the sleepable context which owns the task page_frag.
> + *
> + * 2. The socket allocation mode doesn't indicate that the socket is being
> + *    used to reclaim memory.  Memory reclaim may nest inside other socket
> + *    operations and end up recursing into sk_page_frag() while it's
> + *    already in use.
>   */
>  static inline struct page_frag *sk_page_frag(struct sock *sk)
>  {
> -	if (gfpflags_allow_blocking(sk->sk_allocation))
> +	if (gfpflags_allow_blocking(sk->sk_allocation) &&
> +	    !(sk->sk_allocation & __GFP_MEMALLOC))
>  		return &current->task_frag;
>  
>  	return &sk->sk_frag;
> 

It seems compiler generates better code with :

diff --git a/include/net/sock.h b/include/net/sock.h
index ab905c4b1f0efd42ebdcae333b3f0a2c7c1b2248..56de6ac99f0952bd0bc003353c094ce3a5a852f4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2238,7 +2238,8 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-       if (gfpflags_allow_blocking(sk->sk_allocation))
+       if (likely((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
+                   __GFP_DIRECT_RECLAIM))
                return &current->task_frag;
 
        return &sk->sk_frag;


WDYT ?

Thanks !
