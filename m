Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9414AE3E
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 04:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgA1DAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 22:00:23 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34749 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA1DAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 22:00:23 -0500
Received: by mail-pj1-f66.google.com with SMTP id f2so278275pjq.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 19:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=va5ceMBcMHca5rjvI+EDSohv+EXPpRRFokLBFZz9T2A=;
        b=Li6NLUzVdFa03uhF/grzvDirq0uQuojXbvzYub/HWIORNwXnnHlhRZjkHVIQ+tU6L3
         lAlrcES7e1W1qqCpYftPzQfxAWQnNnwsIYgvYZTVbNRgwgKpX/sYPTjxQHPzaNJtiXK3
         PU4uPf3KV3JrZXGZkN25GnVw9x+0lcWgMi/Y49XqpYcWLeao84PMkZVox7olQm0JMYrH
         vUyBTw0Yfcq0AX5BnlX2g6eCQmy6NQfa6kcxY5tvXlHLzEHKt5TWPEhLx6AGjRvJKOT4
         xFkAIVaurbhAceKnPWwsHROBQACe38O8A2O3Kchygy65TGeLzKxm5n9HQRIpjcjFI0Jm
         Ldkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=va5ceMBcMHca5rjvI+EDSohv+EXPpRRFokLBFZz9T2A=;
        b=SWIcKRTpVygFNm/liSQkcKBnSCJn9siFUUr5A2zyGzy3km9D0UXoKYa/iGl98+Qg9N
         T5cmqEbeTN46D5AK1FeCtkQT4fmUvG9eQq6csDMbcjibVjBEitdGTXScyYmqg20eR3p8
         i2YcC9AjewNOCOTXM55f3u543xhMkpCC6gvTQ9gA7qXVbpXykmr97REl4Thn5vZYx4ww
         c4hPUdZCNEfoDx7r0cXssgNdUAW+cqs4RyWrONeg8QOiO1NipUb59t8Be6sh4q2uf5H8
         YxKqwsR/ID/aNEJmoQQdTgW331s7UPFld90lk/0fr7FRdGYcpDwFXiu1tI1Bl6l8G+Dq
         pCXA==
X-Gm-Message-State: APjAAAVODzHbB9i+D5iFdOQoeUwjMkcUlltWujAyiZlUgUJhKPbWHGMv
        ZcRk0x+vlQCN1l8cwpXgHlk=
X-Google-Smtp-Source: APXvYqxE4U/Yr9uMcJLTs7FMzjv+WkOIiTCx8pbWC5e7IjY95Sn57gW5PeYdkXHyY+vKApXsIToP7g==
X-Received: by 2002:a17:90b:4382:: with SMTP id in2mr2137282pjb.29.1580180422682;
        Mon, 27 Jan 2020 19:00:22 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id p5sm18184677pga.69.2020.01.27.19.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 19:00:22 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH resend mm,net-next 3/3] net-zerocopy: Use vm_insert_pages() for tcp rcv zerocopy.
Date:   Mon, 27 Jan 2020 18:59:58 -0800
Message-Id: <20200128025958.43490-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Use vm_insert_pages() for tcp receive zerocopy. Spin lock cycles
(as reported by perf) drop from a couple of percentage points
to a fraction of a percent. This results in a roughly 6% increase in
efficiency, measured roughly as zerocopy receive count divided by CPU
utilization.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 67 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 34490d972758..52f96c3ceab3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1861,14 +1861,48 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
+					struct page **pages,
+					unsigned long pages_to_map,
+					unsigned long *insert_addr,
+					u32 *length_with_pending,
+					u32 *seq,
+					struct tcp_zerocopy_receive *zc)
+{
+	unsigned long pages_remaining = pages_to_map;
+	int bytes_mapped;
+	int ret;
+
+	ret = vm_insert_pages(vma, *insert_addr, pages, &pages_remaining);
+	bytes_mapped = PAGE_SIZE * (pages_to_map - pages_remaining);
+	/* Even if vm_insert_pages fails, it may have partially succeeded in
+	 * mapping (some but not all of the pages).
+	 */
+	*seq += bytes_mapped;
+	*insert_addr += bytes_mapped;
+	if (ret) {
+		/* But if vm_insert_pages did fail, we have to unroll some state
+		 * we speculatively touched before.
+		 */
+		const int bytes_not_mapped = PAGE_SIZE * pages_remaining;
+		*length_with_pending -= bytes_not_mapped;
+		zc->recv_skip_hint += bytes_not_mapped;
+	}
+	return ret;
+}
+
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
 	unsigned long address = (unsigned long)zc->address;
 	u32 length = 0, seq, offset, zap_len;
+	#define PAGE_BATCH_SIZE 8
+	struct page *pages[PAGE_BATCH_SIZE];
 	const skb_frag_t *frags = NULL;
 	struct vm_area_struct *vma;
 	struct sk_buff *skb = NULL;
+	unsigned long pg_idx = 0;
+	unsigned long curr_addr;
 	struct tcp_sock *tp;
 	int inq;
 	int ret;
@@ -1901,15 +1935,26 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		zc->recv_skip_hint = zc->length;
 	}
 	ret = 0;
+	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
+			/* If we're here, finish the current batch. */
+			if (pg_idx) {
+				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+								   pg_idx,
+								   &curr_addr,
+								   &length,
+								   &seq, zc);
+				if (ret)
+					goto out;
+				pg_idx = 0;
+			}
 			if (skb) {
 				skb = skb->next;
 				offset = seq - TCP_SKB_CB(skb)->seq;
 			} else {
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
-
 			zc->recv_skip_hint = skb->len - offset;
 			offset -= skb_headlen(skb);
 			if ((int)offset < 0 || skb_has_frag_list(skb))
@@ -1933,14 +1978,24 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			zc->recv_skip_hint -= remaining;
 			break;
 		}
-		ret = vm_insert_page(vma, address + length,
-				     skb_frag_page(frags));
-		if (ret)
-			break;
+		pages[pg_idx] = skb_frag_page(frags);
+		pg_idx++;
 		length += PAGE_SIZE;
-		seq += PAGE_SIZE;
 		zc->recv_skip_hint -= PAGE_SIZE;
 		frags++;
+		if (pg_idx == PAGE_BATCH_SIZE) {
+			ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+							   &curr_addr, &length,
+							   &seq, zc);
+			if (ret)
+				goto out;
+			pg_idx = 0;
+		}
+	}
+	if (pg_idx) {
+		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+						   &curr_addr, &length, &seq,
+						   zc);
 	}
 out:
 	up_read(&current->mm->mmap_sem);
-- 
2.25.0.rc1.283.g88dfdc4193-goog

