Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29550DD9BE
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 19:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfJSRBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 13:01:47 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42699 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfJSRBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 13:01:47 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so8323042qkl.9;
        Sat, 19 Oct 2019 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=38ukDg6v8LzizblKy4R2j0RSGFLL8YYA9eWGRF9AGus=;
        b=JUD/23hU4Mo2uD2286zu3BYxl0mQSOAegANJp70s5q5u0KQoJNPwPbpdE2QtEgYBwv
         9TrOpZUWfRAy+veAJbWwzHhEiOXnVyOC7QaSAdxTehqtmt/aUYO7IqzOv45jSrTSG6Wo
         1UoXHw91DbGQ5b/5TbkIVZ9UVgWzg/Xv36O1JNtaKOkVmZirpDPQGZS+P6BZ3DbnnSJU
         fYjv+7S1Vos3gp7GYbEYEHr1+q1sGT7qBoXNqdpUb3pnWsdJ0YxkcCsR7bcz1nwH/ygr
         DrG8/wQ6Hq6tq8OzDoOqJISDTq96fg+qObTBWFWwAlZ09Q3ccCwpyLKRHVnyIzV5jPO+
         +N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=38ukDg6v8LzizblKy4R2j0RSGFLL8YYA9eWGRF9AGus=;
        b=QB1nTzRmYaaR+wUW9LnIuHYS4n/xCmXHZAtxOaLIQX94Y0ODaOvIfr3Y6XAOzkzHIc
         u69ovi9VvwhUGLj3LDZ9t93PR1A5b1lbiTLZiden2eBj3eUjN8U8WnTyD9TXp5pXKvDs
         001eFrCDF52g9+QigpejxaboIi/MYrJGzLic1+0CCUu+/gHiizXzF+HyzWxLXa8IznJF
         RjtMEE1OADK1377W2E+22xLl/ZcgQ1ZTay3CdU5WF8mbCpJoUr0Ogc8USlcSTeXZRHHx
         0glJiEENwA/DOslijoIMNKS/Lkf/+u856fX5wpvYTfcITpnoUVUVqAa+KC1RlTcFn7WQ
         wtow==
X-Gm-Message-State: APjAAAUrp+JcAPgMDUu+H+SvpVoUXUFNz4b3AaLFLqMm6tZonP/vPb7X
        1WXxApvVdtEusYjNVws780E=
X-Google-Smtp-Source: APXvYqxAvZI7YFOQcPdLVEYxFx2B66SsHWgmjPccV4L/VIqVGl98IbL+90alk+068fN7Go00HPBHNg==
X-Received: by 2002:a05:620a:74f:: with SMTP id i15mr14408297qki.199.1571504505434;
        Sat, 19 Oct 2019 10:01:45 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::c67b])
        by smtp.gmail.com with ESMTPSA id j19sm1174170qtr.6.2019.10.19.10.01.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 10:01:44 -0700 (PDT)
Date:   Sat, 19 Oct 2019 10:01:41 -0700
From:   Tejun Heo <tj@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] net: fix sk_page_frag() recursion from memory reclaim
Message-ID: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From f0335a5d14d3596d36e3ffddb2fd4fa0dc6ca9c2 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 19 Oct 2019 09:10:57 -0700

sk_page_frag() optimizes skb_frag allocations by using per-task
skb_frag cache when it knows it's the only user.  The condition is
determined by seeing whether the socket allocation mask allows
blocking - if the allocation may block, it obviously owns the task's
context and ergo exclusively owns current->task_frag.

Unfortunately, this misses recursion through memory reclaim path.
Please take a look at the following backtrace.

 [2] RIP: 0010:tcp_sendmsg_locked+0xccf/0xe10
     ...
     tcp_sendmsg+0x27/0x40
     sock_sendmsg+0x30/0x40
     sock_xmit.isra.24+0xa1/0x170 [nbd]
     nbd_send_cmd+0x1d2/0x690 [nbd]
     nbd_queue_rq+0x1b5/0x3b0 [nbd]
     __blk_mq_try_issue_directly+0x108/0x1b0
     blk_mq_request_issue_directly+0xbd/0xe0
     blk_mq_try_issue_list_directly+0x41/0xb0
     blk_mq_sched_insert_requests+0xa2/0xe0
     blk_mq_flush_plug_list+0x205/0x2a0
     blk_flush_plug_list+0xc3/0xf0
 [1] blk_finish_plug+0x21/0x2e
     _xfs_buf_ioapply+0x313/0x460
     __xfs_buf_submit+0x67/0x220
     xfs_buf_read_map+0x113/0x1a0
     xfs_trans_read_buf_map+0xbf/0x330
     xfs_btree_read_buf_block.constprop.42+0x95/0xd0
     xfs_btree_lookup_get_block+0x95/0x170
     xfs_btree_lookup+0xcc/0x470
     xfs_bmap_del_extent_real+0x254/0x9a0
     __xfs_bunmapi+0x45c/0xab0
     xfs_bunmapi+0x15/0x30
     xfs_itruncate_extents_flags+0xca/0x250
     xfs_free_eofblocks+0x181/0x1e0
     xfs_fs_destroy_inode+0xa8/0x1b0
     destroy_inode+0x38/0x70
     dispose_list+0x35/0x50
     prune_icache_sb+0x52/0x70
     super_cache_scan+0x120/0x1a0
     do_shrink_slab+0x120/0x290
     shrink_slab+0x216/0x2b0
     shrink_node+0x1b6/0x4a0
     do_try_to_free_pages+0xc6/0x370
     try_to_free_mem_cgroup_pages+0xe3/0x1e0
     try_charge+0x29e/0x790
     mem_cgroup_charge_skmem+0x6a/0x100
     __sk_mem_raise_allocated+0x18e/0x390
     __sk_mem_schedule+0x2a/0x40
 [0] tcp_sendmsg_locked+0x8eb/0xe10
     tcp_sendmsg+0x27/0x40
     sock_sendmsg+0x30/0x40
     ___sys_sendmsg+0x26d/0x2b0
     __sys_sendmsg+0x57/0xa0
     do_syscall_64+0x42/0x100
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

In [0], tcp_send_msg_locked() was using current->page_frag when it
called sk_wmem_schedule().  It already calculated how many bytes can
be fit into current->page_frag.  Due to memory pressure,
sk_wmem_schedule() called into memory reclaim path which called into
xfs and then IO issue path.  Because the filesystem in question is
backed by nbd, the control goes back into the tcp layer - back into
tcp_sendmsg_locked().

nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
sense - it's in the process of freeing memory and wants to be able to,
e.g., drop clean pages to make forward progress.  However, this
confused sk_page_frag() called from [2].  Because it only tests
whether the allocation allows blocking which it does, it now thinks
current->page_frag can be used again although it already was being
used in [0].

After [2] used current->page_frag, the offset would be increased by
the used amount.  When the control returns to [0],
current->page_frag's offset is increased and the previously calculated
number of bytes now may overrun the end of allocated memory leading to
silent memory corruptions.

Fix it by updating sk_page_frag() to test __GFP_MEMALLOC and not use
current->task_frag if set.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: stable@vger.kernel.org
---
 include/net/sock.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2c53f1a1d905..4e2ca38acc3c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2233,12 +2233,21 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
  * sk_page_frag - return an appropriate page_frag
  * @sk: socket
  *
- * If socket allocation mode allows current thread to sleep, it means its
- * safe to use the per task page_frag instead of the per socket one.
+ * Use the per task page_frag instead of the per socket one for
+ * optimization when we know there can be no other users.
+ *
+ * 1. The socket allocation mode allows current thread to sleep.  This is
+ *    the sleepable context which owns the task page_frag.
+ *
+ * 2. The socket allocation mode doesn't indicate that the socket is being
+ *    used to reclaim memory.  Memory reclaim may nest inside other socket
+ *    operations and end up recursing into sk_page_frag() while it's
+ *    already in use.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (gfpflags_allow_blocking(sk->sk_allocation))
+	if (gfpflags_allow_blocking(sk->sk_allocation) &&
+	    !(sk->sk_allocation & __GFP_MEMALLOC))
 		return &current->task_frag;
 
 	return &sk->sk_frag;
-- 
2.17.1

