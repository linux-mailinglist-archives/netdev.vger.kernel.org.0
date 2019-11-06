Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B1EF218C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfKFWWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfKFWWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:22:13 -0500
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3E333D09
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 22:22:12 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id g65so26386626qkf.19
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 14:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dLGSnQ4fkDuSeMipTwar+6JmifzoOygUiu/8/zw4SzM=;
        b=iWxxHHDFWl/XqTjSwnvS7Db9jUq4PypQaR6LKEynFAWbExXDuFA7F19QJgU3zdiG7o
         V6F2cosjOhmi/BBklDrahGqSqpouAD8wS0CINNN7aJU4QlDyDcgMQc3Ly/tLNPlijNgC
         JsXIu4JWqs7Uw/AhriVzODEsagfLIcbL3HwxE/TOkVueTHJqSEbQzYt976eSFFz+yc5t
         N98qxWLYHo7z0o+2ssRkcaJp1nMeoU9eem7Uw+u3VwHusxZjqeXQgzd3vh0fUNUq7Vp8
         mC6CcQowc/8WrIIe5Doily2WN8Gbcf73YH7piHTBFEcGVj1ex7FiM5zYyQKxfG6UkuuO
         rzeA==
X-Gm-Message-State: APjAAAX+k9UE2Uu/d+O21OzEiJXA6hVYTwmJvIa4Wv9bepiKgjwfuEDm
        HHE8Rci2wAfp6lRk+eOSlu4TuN54a7mX2GHh0R1Mg/nTCZh2qKYWvBXKA2gC+g1S3SiVcTqdl/z
        mZwS7QtKJiTja+P6t
X-Received: by 2002:ac8:22b5:: with SMTP id f50mr323371qta.229.1573078931911;
        Wed, 06 Nov 2019 14:22:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHQnmM1Vt9DyGkXwPmrF6WH+1xUM4DgxYXTh69ua35Qf6sOfTXB/8AHJsSBTp5UTA69gXkkA==
X-Received: by 2002:ac8:22b5:: with SMTP id f50mr323334qta.229.1573078931573;
        Wed, 06 Nov 2019 14:22:11 -0800 (PST)
Received: from labbott-redhat.redhat.com (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id 32sm156131qth.16.2019.11.06.14.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 14:22:10 -0800 (PST)
From:   Laura Abbott <labbott@redhat.com>
To:     Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Laura Abbott <labbott@redhat.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, clipos@ssi.gouv.fr,
        Vlastimil Babka <vbabka@suse.cz>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Subject: [PATCH] mm: slub: Really fix slab walking for init_on_free
Date:   Wed,  6 Nov 2019 17:22:08 -0500
Message-Id: <20191106222208.26815-1-labbott@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
fixed one problem with the slab walking but missed a key detail:
When walking the list, the head and tail pointers need to be updated
since we end up reversing the list as a result. Without doing this,
bulk free is broken. One way this is exposed is a NULL pointer with
slub_debug=F:

=============================================================================
BUG skbuff_head_cache (Tainted: G                T): Object already free
-----------------------------------------------------------------------------

INFO: Slab 0x000000000d2d2f8f objects=16 used=3 fp=0x0000000064309071 flags=0x3fff00000000201
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:print_trailer+0x70/0x1d5
Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 20 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 free_debug_processing.cold.37+0xc9/0x149
 ? __kfree_skb_flush+0x30/0x40
 ? __kfree_skb_flush+0x30/0x40
 __slab_free+0x22a/0x3d0
 ? tcp_wfree+0x2a/0x140
 ? __sock_wfree+0x1b/0x30
 kmem_cache_free_bulk+0x415/0x420
 ? __kfree_skb_flush+0x30/0x40
 __kfree_skb_flush+0x30/0x40
 net_rx_action+0x2dd/0x480
 __do_softirq+0xf0/0x246
 irq_exit+0x93/0xb0
 do_IRQ+0xa0/0x110
 common_interrupt+0xf/0xf
 </IRQ>

Given we're now almost identical to the existing debugging
code which correctly walks the list, combine with that.

Link: https://lkml.kernel.org/r/20191104170303.GA50361@gandi.net
Reported-by: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Fixes: 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 mm/slub.c | 39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index dac41cf0b94a..d2445dd1c7ed 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1432,12 +1432,15 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 	void *old_tail = *tail ? *tail : *head;
 	int rsize;
 
-	if (slab_want_init_on_free(s)) {
-		void *p = NULL;
+	/* Head and tail of the reconstructed freelist */
+	*head = NULL;
+	*tail = NULL;
 
-		do {
-			object = next;
-			next = get_freepointer(s, object);
+	do {
+		object = next;
+		next = get_freepointer(s, object);
+
+		if (slab_want_init_on_free(s)) {
 			/*
 			 * Clear the object and the metadata, but don't touch
 			 * the redzone.
@@ -1447,29 +1450,8 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 							   : 0;
 			memset((char *)object + s->inuse, 0,
 			       s->size - s->inuse - rsize);
-			set_freepointer(s, object, p);
-			p = object;
-		} while (object != old_tail);
-	}
-
-/*
- * Compiler cannot detect this function can be removed if slab_free_hook()
- * evaluates to nothing.  Thus, catch all relevant config debug options here.
- */
-#if defined(CONFIG_LOCKDEP)	||		\
-	defined(CONFIG_DEBUG_KMEMLEAK) ||	\
-	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
-	defined(CONFIG_KASAN)
 
-	next = *head;
-
-	/* Head and tail of the reconstructed freelist */
-	*head = NULL;
-	*tail = NULL;
-
-	do {
-		object = next;
-		next = get_freepointer(s, object);
+		}
 		/* If object's reuse doesn't have to be delayed */
 		if (!slab_free_hook(s, object)) {
 			/* Move object to the new freelist */
@@ -1484,9 +1466,6 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 		*tail = NULL;
 
 	return *head != NULL;
-#else
-	return true;
-#endif
 }
 
 static void *setup_object(struct kmem_cache *s, struct page *page,
-- 
2.21.0

