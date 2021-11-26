Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40745ED4F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377252AbhKZMFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346209AbhKZMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637928021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iDrWAu3qsdqC1G+K85PyPx5yYTMiKAdZ80dSk9v+8F0=;
        b=It+wURrBZXh/rNrvlqHUeIYy5MMoXUYHsl4OJ1YU8rIeVk1EgrrVgkyXqeGB9Xivhek77b
        qi1acxtNAOjT+nmOc3vItqruiAKfTUQdBh2OVeabZ4w8y+8bkFpjVjOf4YAkgGhSQ3/CeF
        6YyWKmfw0wCavUUo4MzqyfebMfAzqCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-cOqX1pLqNsaqirqpeSZu6Q-1; Fri, 26 Nov 2021 07:00:20 -0500
X-MC-Unique: cOqX1pLqNsaqirqpeSZu6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DE9E2F20;
        Fri, 26 Nov 2021 12:00:19 +0000 (UTC)
Received: from gerbillo.fritz.box (unknown [10.39.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8421E5F4ED;
        Fri, 26 Nov 2021 12:00:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Froemer <sfroemer@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: fix page frag corruption on page fault
Date:   Fri, 26 Nov 2021 13:00:01 +0100
Message-Id: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steffen reported a TCP stream corruption for HTTP requests
served by the apache web-server using a cifs mount-point
and memory mapping the relevant file.

The root cause is quite similar to the one addressed by
commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
memory reclaim"). Here the nested access to the task page frag
is caused by a page fault on the (mmapped) user-space memory
buffer coming from the cifs file.

The page fault handler performs an smb transaction on a different
socket, inside the same process context. Since sk->sk_allaction
for such socket does not prevent the usage for the task_frag,
the nested allocation modify "under the hood" the page frag
in use by the outer sendmsg call, corrupting the stream.

The overall relevant stack trace looks like the following:

httpd 78268 [001] 3461630.850950:      probe:tcp_sendmsg_locked:
        ffffffff91461d91 tcp_sendmsg_locked+0x1
        ffffffff91462b57 tcp_sendmsg+0x27
        ffffffff9139814e sock_sendmsg+0x3e
        ffffffffc06dfe1d smb_send_kvec+0x28
        [...]
        ffffffffc06cfaf8 cifs_readpages+0x213
        ffffffff90e83c4b read_pages+0x6b
        ffffffff90e83f31 __do_page_cache_readahead+0x1c1
        ffffffff90e79e98 filemap_fault+0x788
        ffffffff90eb0458 __do_fault+0x38
        ffffffff90eb5280 do_fault+0x1a0
        ffffffff90eb7c84 __handle_mm_fault+0x4d4
        ffffffff90eb8093 handle_mm_fault+0xc3
        ffffffff90c74f6d __do_page_fault+0x1ed
        ffffffff90c75277 do_page_fault+0x37
        ffffffff9160111e page_fault+0x1e
        ffffffff9109e7b5 copyin+0x25
        ffffffff9109eb40 _copy_from_iter_full+0xe0
        ffffffff91462370 tcp_sendmsg_locked+0x5e0
        ffffffff91462370 tcp_sendmsg_locked+0x5e0
        ffffffff91462b57 tcp_sendmsg+0x27
        ffffffff9139815c sock_sendmsg+0x4c
        ffffffff913981f7 sock_write_iter+0x97
        ffffffff90f2cc56 do_iter_readv_writev+0x156
        ffffffff90f2dff0 do_iter_write+0x80
        ffffffff90f2e1c3 vfs_writev+0xa3
        ffffffff90f2e27c do_writev+0x5c
        ffffffff90c042bb do_syscall_64+0x5b
        ffffffff916000ad entry_SYSCALL_64_after_hwframe+0x65

A possible solution would be adding the __GFP_MEMALLOC flag
to the cifs allocation. That looks dangerous, as the memory
allocated by the cifs fs will not be free soon and such
allocation will not allow for more memory to be freed.

Instead, this patch changes the tcp_sendmsg() code to avoid
touching the page frag after performing the copy from the
user-space buffer. Any page fault or memory reclaim operation
there is now free to touch the task page fragment without
corrupting the state used by the outer sendmsg().

As a downside, if the user-space copy fails, there will be
some additional atomic operations due to the reference counting
on the faulty fragment, but that looks acceptable for a slow
error path.

Reported-by: Steffen Froemer <sfroemer@redhat.com>
Fixes: 5640f7685831 ("net: use a per task frag allocator")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/tcp.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bbb3d39c69af..2d85636c1577 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1304,6 +1304,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
+			unsigned int offset;
 
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto wait_for_space;
@@ -1331,14 +1332,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (!sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
 
-			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
-						       pfrag->page,
-						       pfrag->offset,
-						       copy);
-			if (err)
-				goto do_error;
-
-			/* Update the skb. */
+			/* Update the skb before accessing the user space buffer
+			 * so that we leave the task frag in a consistent state.
+			 * Just in case the page_fault handler need to use it
+			 */
+			offset = pfrag->offset;
 			if (merge) {
 				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 			} else {
@@ -1347,6 +1345,12 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
+
+			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
+						       pfrag->page,
+						       offset, copy);
+			if (err)
+				goto do_error;
 		} else {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
-- 
2.33.1

