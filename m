Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9A5A898A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiHaXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHaXiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:38:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6AF75490
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:38:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33ef3e5faeeso208850767b3.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=pYtQdfR9DdJuwm8vNTghU9PARQVOvGqcSKNgapXYbHw=;
        b=HjFxDD49bkmiVx3MzbDWByanvIEtnAZZt1OjhutAwP27iKY+270Us9U64k7J/07t3b
         ChXT0x/VKSdFW75tMHUGiwLHCMqNLyhrAcHeiX9bn4kFGO6KTHC6NavyHGA/+QF7ITxI
         5d83Gyf4/ZcdJLqa4ruyiz2djO629/3DuKLyBubEGRhoxex3pTibnBoanUWikxFAADeU
         mmxGsRLTVWM56ggG8n9EKV+7NmEMIUEKcJ2Kbifh95eAIvZFM8HkxkS5eaL2Fa204vqt
         lQfL9rUCa5qS44yy8xbVZWRW+ZiaufXc+ldNfwF8HfqvAXa/I+Sey5A5fg2r5skWj8e8
         Gy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=pYtQdfR9DdJuwm8vNTghU9PARQVOvGqcSKNgapXYbHw=;
        b=l+HTtg1NsfE1Nt8Dx0/+0lprFllZG09wKRTEguE8RrqY5LsIZ3kGjipQGiv/Ceajy4
         LH96VHSkCVqPT/nBRSSukAUsJUpI5cHWpdMeIt4JoLMTwotUnomcUfSElq/Ee69hyiIP
         7afASR/nSlAuxYysN8M+/JNy5AVvhHpTf3sM4F2GwhCRzzyBSqtazpXCHqjbC1i6at+a
         qa/6UMq7u4SF6iRqrd+ABUxmK+gPgtcJx4m5idZysRJRkASjwCQhsWbu0m6r+4uT7A5D
         lRJpqaHq1naHy1wtlM17A3ZBI/6Y1sD0UiipM0fUoV3tUvZ6z040NPIR/M7h6mDsj3+x
         Rxxg==
X-Gm-Message-State: ACgBeo0n6LeWnlxSnUPlOpw9GGkdlU18Irug1Q9FvNiZzE3F5+SO7zxz
        hYBU7jrN9JFYGkYvnS5d0Xn7seisDV2ZzQ==
X-Google-Smtp-Source: AA6agR40B6L33NjR6vlVAqAMQ5H1ULNtOEaBjGnN3fj89PEHWxbRhV8eDFGmmUeA5SY1o/B/1n540hhHZ9f0iQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1501:b0:697:c614:2079 with SMTP
 id q1-20020a056902150100b00697c6142079mr17248715ybu.389.1661989093536; Wed,
 31 Aug 2022 16:38:13 -0700 (PDT)
Date:   Wed, 31 Aug 2022 23:38:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831233809.242987-1-edumazet@google.com>
Subject: [PATCH net] tcp: TX zerocopy should not sense pfmemalloc status
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got a recent syzbot report [1] showing a possible misuse
of pfmemalloc page status in TCP zerocopy paths.

Indeed, for pages coming from user space or other layers,
using page_is_pfmemalloc() is moot, and possibly could give
false positives.

There has been attempts to make page_is_pfmemalloc() more robust,
but not using it in the first place in this context is probably better,
removing cpu cycles.

Note to stable teams :

You need to backport 84ce071e38a6 ("net: introduce
__skb_fill_page_desc_noacc") as a prereq.

Race is more probable after commit c07aea3ef4d4
("mm: add a signature in struct page") because page_is_pfmemalloc()
is now using low order bit from page->lru.next, which can change
more often than page->index.

Low order bit should never be set for lru.next (when used as an anchor
in LRU list), so KCSAN report is mostly a false positive.

Backporting to older kernel versions seems not necessary.

[1]
BUG: KCSAN: data-race in lru_add_fn / tcp_build_frag

write to 0xffffea0004a1d2c8 of 8 bytes by task 18600 on cpu 0:
__list_add include/linux/list.h:73 [inline]
list_add include/linux/list.h:88 [inline]
lruvec_add_folio include/linux/mm_inline.h:105 [inline]
lru_add_fn+0x440/0x520 mm/swap.c:228
folio_batch_move_lru+0x1e1/0x2a0 mm/swap.c:246
folio_batch_add_and_move mm/swap.c:263 [inline]
folio_add_lru+0xf1/0x140 mm/swap.c:490
filemap_add_folio+0xf8/0x150 mm/filemap.c:948
__filemap_get_folio+0x510/0x6d0 mm/filemap.c:1981
pagecache_get_page+0x26/0x190 mm/folio-compat.c:104
grab_cache_page_write_begin+0x2a/0x30 mm/folio-compat.c:116
ext4_da_write_begin+0x2dd/0x5f0 fs/ext4/inode.c:2988
generic_perform_write+0x1d4/0x3f0 mm/filemap.c:3738
ext4_buffered_write_iter+0x235/0x3e0 fs/ext4/file.c:270
ext4_file_write_iter+0x2e3/0x1210
call_write_iter include/linux/fs.h:2187 [inline]
new_sync_write fs/read_write.c:491 [inline]
vfs_write+0x468/0x760 fs/read_write.c:578
ksys_write+0xe8/0x1a0 fs/read_write.c:631
__do_sys_write fs/read_write.c:643 [inline]
__se_sys_write fs/read_write.c:640 [inline]
__x64_sys_write+0x3e/0x50 fs/read_write.c:640
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffffea0004a1d2c8 of 8 bytes by task 18611 on cpu 1:
page_is_pfmemalloc include/linux/mm.h:1740 [inline]
__skb_fill_page_desc include/linux/skbuff.h:2422 [inline]
skb_fill_page_desc include/linux/skbuff.h:2443 [inline]
tcp_build_frag+0x613/0xb20 net/ipv4/tcp.c:1018
do_tcp_sendpages+0x3e8/0xaf0 net/ipv4/tcp.c:1075
tcp_sendpage_locked net/ipv4/tcp.c:1140 [inline]
tcp_sendpage+0x89/0xb0 net/ipv4/tcp.c:1150
inet_sendpage+0x7f/0xc0 net/ipv4/af_inet.c:833
kernel_sendpage+0x184/0x300 net/socket.c:3561
sock_sendpage+0x5a/0x70 net/socket.c:1054
pipe_to_sendpage+0x128/0x160 fs/splice.c:361
splice_from_pipe_feed fs/splice.c:415 [inline]
__splice_from_pipe+0x222/0x4d0 fs/splice.c:559
splice_from_pipe fs/splice.c:594 [inline]
generic_splice_sendpage+0x89/0xc0 fs/splice.c:743
do_splice_from fs/splice.c:764 [inline]
direct_splice_actor+0x80/0xa0 fs/splice.c:931
splice_direct_to_actor+0x305/0x620 fs/splice.c:886
do_splice_direct+0xfb/0x180 fs/splice.c:974
do_sendfile+0x3bf/0x910 fs/read_write.c:1249
__do_sys_sendfile64 fs/read_write.c:1317 [inline]
__se_sys_sendfile64 fs/read_write.c:1303 [inline]
__x64_sys_sendfile64+0x10c/0x150 fs/read_write.c:1303
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000000000000 -> 0xffffea0004a1d288

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 18611 Comm: syz-executor.4 Not tainted 6.0.0-rc2-syzkaller-00248-ge022620b5d05-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022

Fixes: c07aea3ef4d4 ("mm: add a signature in struct page")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
---
 include/linux/skbuff.h | 21 +++++++++++++++++++++
 net/core/datagram.c    |  2 +-
 net/ipv4/tcp.c         |  2 +-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2936f12d34dce1aa1329a640802c5..18e163a3460dd41c3875bf41261cc6ca65ede331 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2444,6 +2444,27 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
 	skb_shinfo(skb)->nr_frags = i + 1;
 }
 
+/**
+ * skb_fill_page_desc_noacc - initialise a paged fragment in an skb
+ * @skb: buffer containing fragment to be initialised
+ * @i: paged fragment index to initialise
+ * @page: the page to use for this fragment
+ * @off: the offset to the data with @page
+ * @size: the length of the data
+ *
+ * Variant of skb_fill_page_desc() which does not deal with
+ * pfmemalloc, if page is not owned by us.
+ */
+static inline void skb_fill_page_desc_noacc(struct sk_buff *skb, int i,
+					    struct page *page, int off,
+					    int size)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	__skb_fill_page_desc_noacc(shinfo, i, page, off, size);
+	shinfo->nr_frags = i + 1;
+}
+
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		     int size, unsigned int truesize);
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 7255531f63ae279204bd6dd1a592ded789d4ac0e..e4ff2db40c9810a4cbbf6540ab5365d79bcdbbe0 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -677,7 +677,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 				page_ref_sub(last_head, refs);
 				refs = 0;
 			}
-			skb_fill_page_desc(skb, frag++, head, start, size);
+			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
 		}
 		if (refs)
 			page_ref_sub(last_head, refs);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e5011c136fdb7accd6b86cb38d0817f7b854f9fd..6cdfce6f28672d42ce813ba2a9dc4d18b4939e42 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1015,7 +1015,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 	} else {
 		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, copy);
+		skb_fill_page_desc_noacc(skb, i, page, offset, copy);
 	}
 
 	if (!(flags & MSG_NO_SHARED_FRAGS))
-- 
2.37.2.672.g94769d06f0-goog

