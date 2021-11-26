Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1551845F4C2
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbhKZSkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244634AbhKZSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:38:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637951739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c8FX9a/QXx3B4MxTn5/SOfiYaxswe/u53Phg/YrLu0A=;
        b=TusRQAYIiV3QpnXLaCQaL5gAtWgpmoVFnWmRH+gA8zMrOP0ZuJq9Mr666zDhdDjWTcJ6yH
        kpQE0heE9VeScfAfQNOVXpQDMwtso6BXuYwiz1VLB8dm/XMONypb95j/dABho+1vrPH/P1
        VGmrgz1WHGlmChqJepgt7+9JYwxGGC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-4ghxYwVFPr6j9ZHD2jYksA-1; Fri, 26 Nov 2021 13:35:35 -0500
X-MC-Unique: 4ghxYwVFPr6j9ZHD2jYksA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7F9B80BCA8;
        Fri, 26 Nov 2021 18:35:34 +0000 (UTC)
Received: from gerbillo.fritz.box (unknown [10.39.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D44105C1CF;
        Fri, 26 Nov 2021 18:35:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Froemer <sfroemer@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v2] tcp: fix page frag corruption on page fault
Date:   Fri, 26 Nov 2021 19:34:21 +0100
Message-Id: <0fa74bfdfee95d6bba9fa49a5437f63c014f29ce.1637951641.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

The cifs filesystem rightfully sets sk_allocations to GFP_NOFS,
we can avoid the nesting using the sk page frag for allocation
lacking the __GFP_FS flag. Do not define an additional mm-helper
for that, as this is strictly tied to the sk page frag usage.

v1 -> v2:
 - use a stricted sk_page_frag() check instead of reordering the
   code (Eric)

Reported-by: Steffen Froemer <sfroemer@redhat.com>
Fixes: 5640f7685831 ("net: use a per task frag allocator")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b32906e1ab55..715cdb4b2b79 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2430,19 +2430,22 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * @sk: socket
  *
  * Use the per task page_frag instead of the per socket one for
- * optimization when we know that we're in the normal context and owns
+ * optimization when we know that we're in process context and own
  * everything that's associated with %current.
  *
- * gfpflags_allow_blocking() isn't enough here as direct reclaim may nest
- * inside other socket operations and end up recursing into sk_page_frag()
- * while it's already in use.
+ * Both direct reclaim and page faults can nest inside other
+ * socket operations and end up recursing into sk_page_frag()
+ * while it's already in use: explicitly avoid task page_frag
+ * usage if the caller is potentially doing any of them.
+ * This assumes that page fault handlers use the GFP_NOFS flags.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (gfpflags_normal_context(sk->sk_allocation))
+	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
 		return &current->task_frag;
 
 	return &sk->sk_frag;
-- 
2.33.1

