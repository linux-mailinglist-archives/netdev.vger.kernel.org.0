Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D8A6A4414
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjB0ORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjB0ORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:17:10 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F4FE075
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:17:08 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a5a0b6e3so143064887b3.10
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c3mlybQ+QQWiz0dWEEECQAtCwpGdMWlRygXNRSBadio=;
        b=iOAQ5Skm6GKYi9PlL1kM05fWJ2ymTLZUntXDfd1PYoS+E98toruTiY+kdjUDiuI6QR
         4mqxQMe3jLoRGnFt91q6jhkW4aKg8GJ6DwxEJb0eGOZug5L4mjLPkTQNqNrkTeY10JxP
         G5sOqRFQZ4AzkK5MPKHf94qI0o96k02pFBLwfGEhjKRm3W7kqor7JYGTKL+zN1FSmFVW
         DvqZ+yfHFRS/XuD9JQNOCI4ekpbBJaWQfIOTOhSNkXI67fWrjUti1j43Y3aRCt8dbukA
         0RR2Q7RvLLAZoqv3D7fZiGDxNkQ7gaEaXJP9T5DT8bQ+Ce0OATcU4D6DL4KPp1J1vFgv
         SjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c3mlybQ+QQWiz0dWEEECQAtCwpGdMWlRygXNRSBadio=;
        b=zvRLQpx/riP5bL/G5bbSE7l3A9w6fLm7sjUuP8dtH9hIdXbtEtwzqA039DYC/3weFi
         3M/DaJNRr5C4rRa/K1qIet+4dGU3+63cpsjWFlIGDyAcz2/0R62aRTLrtPV02SdmzuUd
         /whguwX/UOoIYx3LnPFcGnL/vNNa8TheaKTb1UL9KMGxn32DDvzFGBDI7ZrUOXWsUMSG
         /IWclWh6cgSZ17+0t4oUEdttNq2aKYC0VNW9v50kglLm9RtY+RaG54yBIaw35aWOUo2v
         nVmwNufrxI6zt9NVYIu/gMt9jTdp4wUKnSqw8XZjizJVSkT/QT5HI6QPPVq/1xRowIxb
         KNRg==
X-Gm-Message-State: AO0yUKXVub2SQr7C5BS8DUVVn4FTJzJKTInqnIyCShty5C1CK17+gmny
        LG8Sp/YPIqhLhfq6aB+4xLQsO7+iavfEuw==
X-Google-Smtp-Source: AK7set8048xo39NbWguF+su8AJe8amaGMQXTZr6HXbbZqVSGNQSu+8fSY2UYCFWwPsmgMg7/9IHrVZBFFpz7jA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9087:0:b0:8ea:3d09:b125 with SMTP id
 t7-20020a259087000000b008ea3d09b125mr7729217ybl.0.1677507427814; Mon, 27 Feb
 2023 06:17:07 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:17:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230227141706.447954-1-edumazet@google.com>
Subject: [PATCH net] net: avoid skb end_offset change in __skb_unclone_keeptruesize()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once initial skb->head has been allocated from skb_small_head_cache,
we need to make sure to use the same strategy whenever skb->head
has to be re-allocated, as found by syzbot [1]

This means kmalloc_reserve() can not fallback from using
skb_small_head_cache to generic (power-of-two) kmem caches.

It seems that we probably want to rework things in the future,
to partially revert following patch, because we no longer use
ksize() for skb allocated in TX path.

2b88cba55883 ("net: preserve skb_end_offset() in skb_unclone_keeptruesize()")

Ideally, TCP stack should never put payload in skb->head,
this effort has to be completed.

In the mean time, add a sanity check.

[1]
BUG: KASAN: invalid-free in slab_free mm/slub.c:3787 [inline]
BUG: KASAN: invalid-free in kmem_cache_free+0xee/0x5c0 mm/slub.c:3809
Free of addr ffff88806cdee800 by task syz-executor239/5189

CPU: 0 PID: 5189 Comm: syz-executor239 Not tainted 6.2.0-rc8-syzkaller-02400-gd1fabc68f8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:306 [inline]
print_report+0x15e/0x45d mm/kasan/report.c:417
kasan_report_invalid_free+0x9b/0x1b0 mm/kasan/report.c:482
____kasan_slab_free+0x1a5/0x1c0 mm/kasan/common.c:216
kasan_slab_free include/linux/kasan.h:177 [inline]
slab_free_hook mm/slub.c:1781 [inline]
slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
slab_free mm/slub.c:3787 [inline]
kmem_cache_free+0xee/0x5c0 mm/slub.c:3809
skb_kfree_head net/core/skbuff.c:857 [inline]
skb_kfree_head net/core/skbuff.c:853 [inline]
skb_free_head+0x16f/0x1a0 net/core/skbuff.c:872
skb_release_data+0x57a/0x820 net/core/skbuff.c:901
skb_release_all net/core/skbuff.c:966 [inline]
__kfree_skb+0x4f/0x70 net/core/skbuff.c:980
tcp_wmem_free_skb include/net/tcp.h:302 [inline]
tcp_rtx_queue_purge net/ipv4/tcp.c:3061 [inline]
tcp_write_queue_purge+0x617/0xcf0 net/ipv4/tcp.c:3074
tcp_v4_destroy_sock+0x125/0x810 net/ipv4/tcp_ipv4.c:2302
inet_csk_destroy_sock+0x19a/0x440 net/ipv4/inet_connection_sock.c:1195
__tcp_close+0xb96/0xf50 net/ipv4/tcp.c:3021
tcp_close+0x2d/0xc0 net/ipv4/tcp.c:3033
inet_release+0x132/0x270 net/ipv4/af_inet.c:426
__sock_release+0xcd/0x280 net/socket.c:651
sock_close+0x1c/0x20 net/socket.c:1393
__fput+0x27c/0xa90 fs/file_table.c:320
task_work_run+0x16f/0x270 kernel/task_work.c:179
resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
__syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2511f546c3
Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007ffef0103d48 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f2511f546c3
RDX: 0000000000000978 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000003434
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffef0103d6c
R13: 00007ffef0103d80 R14: 00007ffef0103dc0 R15: 0000000000000003
</TASK>

Allocated by task 5189:
kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
kasan_set_track+0x25/0x30 mm/kasan/common.c:52
____kasan_kmalloc mm/kasan/common.c:374 [inline]
____kasan_kmalloc mm/kasan/common.c:333 [inline]
__kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:383
kasan_kmalloc include/linux/kasan.h:211 [inline]
__do_kmalloc_node mm/slab_common.c:968 [inline]
__kmalloc_node_track_caller+0x5b/0xc0 mm/slab_common.c:988
kmalloc_reserve+0xf1/0x230 net/core/skbuff.c:539
pskb_expand_head+0x237/0x1160 net/core/skbuff.c:1995
__skb_unclone_keeptruesize+0x93/0x220 net/core/skbuff.c:2094
skb_unclone_keeptruesize include/linux/skbuff.h:1910 [inline]
skb_prepare_for_shift net/core/skbuff.c:3804 [inline]
skb_shift+0xef8/0x1e20 net/core/skbuff.c:3877
tcp_skb_shift net/ipv4/tcp_input.c:1538 [inline]
tcp_shift_skb_data net/ipv4/tcp_input.c:1646 [inline]
tcp_sacktag_walk+0x93b/0x18a0 net/ipv4/tcp_input.c:1713
tcp_sacktag_write_queue+0x1599/0x31d0 net/ipv4/tcp_input.c:1974
tcp_ack+0x2e9f/0x5a10 net/ipv4/tcp_input.c:3847
tcp_rcv_established+0x667/0x2230 net/ipv4/tcp_input.c:6006
tcp_v4_do_rcv+0x670/0x9b0 net/ipv4/tcp_ipv4.c:1721
sk_backlog_rcv include/net/sock.h:1113 [inline]
__release_sock+0x133/0x3b0 net/core/sock.c:2921
release_sock+0x58/0x1b0 net/core/sock.c:3488
tcp_sendmsg+0x3a/0x50 net/ipv4/tcp.c:1485
inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
sock_sendmsg_nosec net/socket.c:722 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:745
sock_write_iter+0x295/0x3d0 net/socket.c:1136
call_write_iter include/linux/fs.h:2189 [inline]
new_sync_write fs/read_write.c:491 [inline]
vfs_write+0x9ed/0xdd0 fs/read_write.c:584
ksys_write+0x1ec/0x250 fs/read_write.c:637
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88806cdee800
which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of
1024-byte region [ffff88806cdee800, ffff88806cdeec00)

The buggy address belongs to the physical page:
page:ffffea0001b37a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x6cde8
head:ffffea0001b37a00 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1f2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_MEMALLOC|__GFP_HARDWALL), pid 75, tgid 75 (kworker/u4:4), ts 96369578780, free_ts 26734162530
prep_new_page mm/page_alloc.c:2531 [inline]
get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
__alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
alloc_pages+0x1aa/0x270 mm/mempolicy.c:2287
alloc_slab_page mm/slub.c:1851 [inline]
allocate_slab+0x25f/0x350 mm/slub.c:1998
new_slab mm/slub.c:2051 [inline]
___slab_alloc+0xa91/0x1400 mm/slub.c:3193
__slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
__slab_alloc_node mm/slub.c:3345 [inline]
slab_alloc_node mm/slub.c:3442 [inline]
__kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
__do_kmalloc_node mm/slab_common.c:967 [inline]
__kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:988
kmalloc_reserve+0xf1/0x230 net/core/skbuff.c:539
__alloc_skb+0x129/0x330 net/core/skbuff.c:608
__netdev_alloc_skb+0x74/0x410 net/core/skbuff.c:672
__netdev_alloc_skb_ip_align include/linux/skbuff.h:3203 [inline]
netdev_alloc_skb_ip_align include/linux/skbuff.h:3213 [inline]
batadv_iv_ogm_aggregate_new+0x106/0x4e0 net/batman-adv/bat_iv_ogm.c:558
batadv_iv_ogm_queue_add net/batman-adv/bat_iv_ogm.c:670 [inline]
batadv_iv_ogm_schedule_buff+0xe6b/0x1450 net/batman-adv/bat_iv_ogm.c:849
batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:868 [inline]
batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:861 [inline]
batadv_iv_send_outstanding_bat_ogm_packet+0x744/0x910 net/batman-adv/bat_iv_ogm.c:1712
process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
worker_thread+0x669/0x1090 kernel/workqueue.c:2436
page last free stack trace:
reset_page_owner include/linux/page_owner.h:24 [inline]
free_pages_prepare mm/page_alloc.c:1446 [inline]
free_pcp_prepare+0x66a/0xc20 mm/page_alloc.c:1496
free_unref_page_prepare mm/page_alloc.c:3369 [inline]
free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
free_contig_range+0xb5/0x180 mm/page_alloc.c:9488
destroy_args+0xa8/0x64c mm/debug_vm_pgtable.c:998
debug_vm_pgtable+0x28de/0x296f mm/debug_vm_pgtable.c:1318
do_one_initcall+0x141/0x790 init/main.c:1306
do_initcall_level init/main.c:1379 [inline]
do_initcalls init/main.c:1395 [inline]
do_basic_setup init/main.c:1414 [inline]
kernel_init_freeable+0x6f9/0x782 init/main.c:1634
kernel_init+0x1e/0x1d0 init/main.c:1522
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
ffff88806cdee700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff88806cdee780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88806cdee800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
^
ffff88806cdee880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index eb7d33b41e7107b07e4d8af7abf474b22255a9cd..1a31815104d617a66fee5e981131ceeffaa67128 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -517,18 +517,16 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 #ifdef HAVE_SKB_SMALL_HEAD_CACHE
 	if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
 	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
-
-		/* skb_small_head_cache has non power of two size,
-		 * likely forcing SLUB to use order-3 pages.
-		 * We deliberately attempt a NOMEMALLOC allocation only.
-		 */
 		obj = kmem_cache_alloc_node(skb_small_head_cache,
 				flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 				node);
-		if (obj) {
-			*size = SKB_SMALL_HEAD_CACHE_SIZE;
+		*size = SKB_SMALL_HEAD_CACHE_SIZE;
+		if (obj || !(gfp_pfmemalloc_allowed(flags)))
 			goto out;
-		}
+		/* Try again but now we are using pfmemalloc reserves */
+		ret_pfmemalloc = true;
+		obj = kmem_cache_alloc_node(skb_small_head_cache, flags, node);
+		goto out;
 	}
 #endif
 	*size = obj_size = kmalloc_size_roundup(obj_size);
@@ -2082,6 +2080,7 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 }
 EXPORT_SYMBOL(skb_realloc_headroom);
 
+/* Note: We plan to rework this in linux-6.4 */
 int __skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
 {
 	unsigned int saved_end_offset, saved_truesize;
@@ -2100,6 +2099,22 @@ int __skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
 	if (likely(skb_end_offset(skb) == saved_end_offset))
 		return 0;
 
+#ifdef HAVE_SKB_SMALL_HEAD_CACHE
+	/* We can not change skb->end if the original or new value
+	 * is SKB_SMALL_HEAD_HEADROOM, as it might break skb_kfree_head().
+	 */
+	if (saved_end_offset == SKB_SMALL_HEAD_HEADROOM ||
+	    skb_end_offset(skb) == SKB_SMALL_HEAD_HEADROOM) {
+		/* We think this path should not be taken.
+		 * Add a temporary trace to warn us just in case.
+		 */
+		pr_err_once("__skb_unclone_keeptruesize() skb_end_offset() %u -> %u\n",
+			    saved_end_offset, skb_end_offset(skb));
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+#endif
+
 	shinfo = skb_shinfo(skb);
 
 	/* We are about to change back skb->end,
-- 
2.39.2.637.g21b0678d19-goog

