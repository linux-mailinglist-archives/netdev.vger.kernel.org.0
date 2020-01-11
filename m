Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4179137A9A
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgAKA3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:29:24 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36669 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbgAKA3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:29:24 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so1929018pfb.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 16:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LDI4J9RjcFLtSkqnZ1wNc4xIuHBN5WiIppT7x73FiY=;
        b=oitzAvxblJcT6HGYXN37tqOcTuVllVo4oE3LuXvven6wfJ8p78mTXgRCOKE6vhpIrI
         5gpd2HOJZTNUmqtS8pKj9qXOsbypMvTLm/krIkJTC6XR7NRJhSBiApNG5QMUtofSvGDC
         0+U8Bpm5nyTcHp9nckqbASiV/Wpyw1oNXghPmIoGVh9ylTdiilfHVQSeqSVFzorNop26
         TaGUXEa4OyIU1ERTjy8aEcnBGJGhp21SWtKWbqhVZGnjYkw3l2U1htDRjopxKLrkwfCU
         fsL5KkFLXNYoQn06r3Ph4OOFZFQvKG7I9SYNX3v8E+H/kQnkW5j9OgjW3Iq4ouHE82EX
         1OiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LDI4J9RjcFLtSkqnZ1wNc4xIuHBN5WiIppT7x73FiY=;
        b=f6u60JXeSihmuetddariLQKl0iUgx/kYxlZ5XlDf+0pZDzamF3+N2iYsjQvKd/JD27
         Dp1FbB7YrHTkncqI6L7RATfKrj0gupuivZzE2u8KdlJaSK2Xy4OIiT8jnwXMlR23ejsR
         JB9etdZLtHRoet8YQCfPJxoL3qLRvdp+qJrRrsMDKpUUzhjv6bNrFs7V2rn9TAWfPDRx
         1IcduaHTp52ukxc/y5S1NiojcNb8/bx8WEIklBQ5cZikEGDbRArClq0e9EHxP/8unYZg
         wRP4DdppdQIGSngq4nEIi3Bple4Yw1Rwkydt8tFT4bbXr/8QDXQz4uzya6xVah0Rj/q8
         T4Dg==
X-Gm-Message-State: APjAAAUMHs6x5ya5uge05CGV/5ph5tSHURQTXcLfdDdoPJrMYfmiiEw2
        vnXbEwIL7u7sNgBE18n280E=
X-Google-Smtp-Source: APXvYqynZPWxev5HGGPaDMT4SeA3bIUYAeFJGYDi8krQcaLK/IaE5Dvc8g5CvUIMBFJWYPXZuzz2rQ==
X-Received: by 2002:a63:fe50:: with SMTP id x16mr7557165pgj.31.1578702563076;
        Fri, 10 Jan 2020 16:29:23 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id h126sm4567066pfe.19.2020.01.10.16.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 16:29:22 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, Arjun Roy <arjunroy.kdev@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH mm,net-next 3/3] net-zerocopy: Use vm_insert_pages() for tcp rcv zerocopy.
Date:   Fri, 10 Jan 2020 16:28:49 -0800
Message-Id: <20200111002849.252704-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
In-Reply-To: <20200111002849.252704-1-arjunroy.kdev@gmail.com>
References: <20200111002849.252704-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use vm_insert_pages() for tcp receive zerocopy. Spin lock cycles
(as reported by perf) drop from a couple of percentage points
to a fraction of a percent. This results in a roughly 6% increase in
efficiency, measured roughly as zerocopy receive count divided by CPU
utilization.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy.kdev@gmail.com>
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

