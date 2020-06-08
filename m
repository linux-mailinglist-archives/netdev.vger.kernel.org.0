Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C671F1134
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 03:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgFHByp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 21:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgFHByn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 21:54:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BBA2063A;
        Mon,  8 Jun 2020 01:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591581282;
        bh=iJ6QDOmh+t64+FAsHNlpj+zsKZSvyxue1XB0B0ar26Q=;
        h=Date:From:To:Subject:From;
        b=W6++Ol7Bj8XC7TzE4ItUooffDaMFaOG6o4SgINSoe9B3D/Cl6u3+/tJFL3RvksR/C
         pSZwek9Bv8l1LpovKBx1Y821tWnp5O1YwKnaH9EyTl9IAaharfeX/js1QFhK8sWOff
         e8gs0w+D9t6MiSgAQhoHg6Mlc/+Jl6UMS5UqGheQ=
Date:   Sun, 07 Jun 2020 18:54:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arjunroy@google.com,
        davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca,
        netdev@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com,
        willy@infradead.org
Subject:  [patch 1/1] net-zerocopy: use vm_insert_pages() for tcp
 rcv zerocopy
Message-ID: <20200608015441._rpcs9Om6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>
Subject: net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy

Use vm_insert_pages() for tcp receive zerocopy.  Spin lock cycles (as
reported by perf) drop from a couple of percentage points to a fraction of
a percent.  This results in a roughly 6% increase in efficiency, measured
roughly as zerocopy receive count divided by CPU utilization.

The intention of this patchset is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

[akpm@linux-foundation.org: suppress gcc-7.2.0 warning]
Link: http://lkml.kernel.org/r/20200128025958.43490-3-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |   70 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy
+++ a/net/ipv4/tcp.c
@@ -1742,14 +1742,48 @@ int tcp_mmap(struct file *file, struct s
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
@@ -1762,6 +1796,8 @@ static int tcp_zerocopy_receive(struct s
 
 	sock_rps_record_flow(sk);
 
+	tp = tcp_sk(sk);
+
 	down_read(&current->mm->mmap_sem);
 
 	vma = find_vma(current->mm, address);
@@ -1771,7 +1807,6 @@ static int tcp_zerocopy_receive(struct s
 	}
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
 
-	tp = tcp_sk(sk);
 	seq = tp->copied_seq;
 	inq = tcp_inq(sk);
 	zc->length = min_t(u32, zc->length, inq);
@@ -1783,8 +1818,20 @@ static int tcp_zerocopy_receive(struct s
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
 				if (zc->recv_skip_hint > 0)
 					break;
@@ -1793,7 +1840,6 @@ static int tcp_zerocopy_receive(struct s
 			} else {
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
-
 			zc->recv_skip_hint = skb->len - offset;
 			offset -= skb_headlen(skb);
 			if ((int)offset < 0 || skb_has_frag_list(skb))
@@ -1817,14 +1863,24 @@ static int tcp_zerocopy_receive(struct s
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
_
