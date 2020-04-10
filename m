Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038841A4A23
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDJTEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDJTEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 15:04:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BC320732;
        Fri, 10 Apr 2020 19:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586545484;
        bh=klzepfhJXThLtLP0FfjoWLdi4EnlrjtsVh8Rug5lgoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSzGfBG67pIMmZBYoSEJpaXfp+LnJqmywbZ9etut/n7bMQkm0gjT7lFNxuVREBPdg
         Ggl70Rkjrry1txvDjmfdVE0yOEGJuAAlhTIRtYJoHwFLGPHyucR743IS8uj8gBnQcc
         crMzMmlEHBP4VrgviwE39z8zNZs7VeGWaHGc2NZE=
Date:   Fri, 10 Apr 2020 12:04:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
Message-Id: <20200410120443.ad7856db13e158fbd441f3ae@linux-foundation.org>
In-Reply-To: <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
        <20200128025958.43490-3-arjunroy.kdev@gmail.com>
        <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
        <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
        <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Feb 2020 13:21:41 -0800 Arjun Roy <arjunroy@google.com> wrote:

> I remain a bit concerned regarding the merge process for this specific
> patch (0003, the net/ipv4/tcp.c change) since I have other in-flight
> changes for TCP receive zerocopy that I'd like to upstream for
> net-next - and would like to avoid weird merge issues.
> 
> So perhaps the following could work:
> 
> 1. Andrew, perhaps we could remove this particular patch (0003, the
> net/ipv4/tcp.c change) from mm-next; that way we merge
> vm_insert_pages() but not the call-site within TCP, for now.
> 2. net-next will eventually pick vm_insert_pages() up.
> 3. I can modify the zerocopy code to use it at that point?
> 
> Else I'm concerned a complicated merge situation may result.

The merge situation is quite clean.

I guess I'll hold off on
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch (below) and
shall send it to davem after Linus has merged the prerequisites.


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
@@ -1734,14 +1734,48 @@ int tcp_mmap(struct file *file, struct s
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
@@ -1754,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
 
 	sock_rps_record_flow(sk);
 
+	tp = tcp_sk(sk);
+
 	down_read(&current->mm->mmap_sem);
 
 	ret = -EINVAL;
@@ -1762,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
 		goto out;
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
 
-	tp = tcp_sk(sk);
 	seq = tp->copied_seq;
 	inq = tcp_inq(sk);
 	zc->length = min_t(u32, zc->length, inq);
@@ -1774,8 +1809,20 @@ static int tcp_zerocopy_receive(struct s
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
@@ -1784,7 +1831,6 @@ static int tcp_zerocopy_receive(struct s
 			} else {
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
-
 			zc->recv_skip_hint = skb->len - offset;
 			offset -= skb_headlen(skb);
 			if ((int)offset < 0 || skb_has_frag_list(skb))
@@ -1808,14 +1854,24 @@ static int tcp_zerocopy_receive(struct s
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

