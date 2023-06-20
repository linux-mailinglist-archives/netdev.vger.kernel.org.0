Return-Path: <netdev+bounces-12273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C59736F55
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A235E2812F9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECD9171A9;
	Tue, 20 Jun 2023 14:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE31101CA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:56:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E7D1713
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687272984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VjthvFXeQGZeDxQ7unAKOEBDdmvRqvLtJxvDci7YFS0=;
	b=hnlsSSI5j23el6c7JX4DzECdTvT4Q6tjlQ1/4hmMbMX2rANr+sYSKP/jx7OHaVlo1422ah
	ktxPKfsEZp+rtqwFBpXbRGXdMTjLfmAZLEk64Xx9Go47fi2EoGMuqsJC6ncmMk57OvI62F
	jPaXm1RFOlV/Zsc4+6fxXHXzcjtW0Vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-iKtTzmMANW2P_f63qnZVtw-1; Tue, 20 Jun 2023 10:56:20 -0400
X-MC-Unique: iKtTzmMANW2P_f63qnZVtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36AF58A6967;
	Tue, 20 Jun 2023 14:53:53 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35FACC1ED97;
	Tue, 20 Jun 2023 14:53:51 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Tom Talpey <tom@talpey.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 04/18] siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
Date: Tue, 20 Jun 2023 15:53:23 +0100
Message-ID: <20230620145338.1300897-5-dhowells@redhat.com>
In-Reply-To: <20230620145338.1300897-1-dhowells@redhat.com>
References: <20230620145338.1300897-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header, data
pages and trailer.

To make this work, the data is assembled in a bio_vec array and attached to
a BVEC-type iterator.  The header and trailer (if present) are copied into
page fragments that can be freed with put_page().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Bernard Metzler <bmt@zurich.ibm.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Leon Romanovsky <leon@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-rdma@vger.kernel.org
cc: netdev@vger.kernel.org
---

Notes:
    ver #2)
     - Wrap lines at 80.

 drivers/infiniband/sw/siw/siw_qp_tx.c | 231 ++++----------------------
 1 file changed, 36 insertions(+), 195 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index ffb16beb6c30..2584f9da0dd8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -311,114 +311,8 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
 	return rv;
 }
 
-/*
- * 0copy TCP transmit interface: Use MSG_SPLICE_PAGES.
- *
- * Using sendpage to push page by page appears to be less efficient
- * than using sendmsg, even if data are copied.
- *
- * A general performance limitation might be the extra four bytes
- * trailer checksum segment to be pushed after user data.
- */
-static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
-			     size_t size)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = {
-		.msg_flags = (MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST |
-			      MSG_SPLICE_PAGES),
-	};
-	struct sock *sk = s->sk;
-	int i = 0, rv = 0, sent = 0;
-
-	while (size) {
-		size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
-
-		if (size + offset <= PAGE_SIZE)
-			msg.msg_flags &= ~MSG_SENDPAGE_NOTLAST;
-
-		tcp_rate_check_app_limited(sk);
-		bvec_set_page(&bvec, page[i], bytes, offset);
-		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-
-try_page_again:
-		lock_sock(sk);
-		rv = tcp_sendmsg_locked(sk, &msg, size);
-		release_sock(sk);
-
-		if (rv > 0) {
-			size -= rv;
-			sent += rv;
-			if (rv != bytes) {
-				offset += rv;
-				bytes -= rv;
-				goto try_page_again;
-			}
-			offset = 0;
-		} else {
-			if (rv == -EAGAIN || rv == 0)
-				break;
-			return rv;
-		}
-		i++;
-	}
-	return sent;
-}
-
-/*
- * siw_0copy_tx()
- *
- * Pushes list of pages to TCP socket. If pages from multiple
- * SGE's, all referenced pages of each SGE are pushed in one
- * shot.
- */
-static int siw_0copy_tx(struct socket *s, struct page **page,
-			struct siw_sge *sge, unsigned int offset,
-			unsigned int size)
-{
-	int i = 0, sent = 0, rv;
-	int sge_bytes = min(sge->length - offset, size);
-
-	offset = (sge->laddr + offset) & ~PAGE_MASK;
-
-	while (sent != size) {
-		rv = siw_tcp_sendpages(s, &page[i], offset, sge_bytes);
-		if (rv >= 0) {
-			sent += rv;
-			if (size == sent || sge_bytes > rv)
-				break;
-
-			i += PAGE_ALIGN(sge_bytes + offset) >> PAGE_SHIFT;
-			sge++;
-			sge_bytes = min(sge->length, size - sent);
-			offset = sge->laddr & ~PAGE_MASK;
-		} else {
-			sent = rv;
-			break;
-		}
-	}
-	return sent;
-}
-
 #define MAX_TRAILER (MPA_CRC_SIZE + 4)
 
-static void siw_unmap_pages(struct kvec *iov, unsigned long kmap_mask, int len)
-{
-	int i;
-
-	/*
-	 * Work backwards through the array to honor the kmap_local_page()
-	 * ordering requirements.
-	 */
-	for (i = (len-1); i >= 0; i--) {
-		if (kmap_mask & BIT(i)) {
-			unsigned long addr = (unsigned long)iov[i].iov_base;
-
-			kunmap_local((void *)(addr & PAGE_MASK));
-		}
-	}
-}
-
 /*
  * siw_tx_hdt() tries to push a complete packet to TCP where all
  * packet fragments are referenced by the elements of one iovec.
@@ -438,30 +332,21 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 {
 	struct siw_wqe *wqe = &c_tx->wqe_active;
 	struct siw_sge *sge = &wqe->sqe.sge[c_tx->sge_idx];
-	struct kvec iov[MAX_ARRAY];
-	struct page *page_array[MAX_ARRAY];
+	struct bio_vec bvec[MAX_ARRAY];
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_EOR };
+	void *trl;
 
 	int seg = 0, do_crc = c_tx->do_crc, is_kva = 0, rv;
 	unsigned int data_len = c_tx->bytes_unsent, hdr_len = 0, trl_len = 0,
 		     sge_off = c_tx->sge_off, sge_idx = c_tx->sge_idx,
 		     pbl_idx = c_tx->pbl_idx;
-	unsigned long kmap_mask = 0L;
 
 	if (c_tx->state == SIW_SEND_HDR) {
-		if (c_tx->use_sendpage) {
-			rv = siw_tx_ctrl(c_tx, s, MSG_DONTWAIT | MSG_MORE);
-			if (rv)
-				goto done;
+		void *hdr = &c_tx->pkt.ctrl + c_tx->ctrl_sent;
 
-			c_tx->state = SIW_SEND_DATA;
-		} else {
-			iov[0].iov_base =
-				(char *)&c_tx->pkt.ctrl + c_tx->ctrl_sent;
-			iov[0].iov_len = hdr_len =
-				c_tx->ctrl_len - c_tx->ctrl_sent;
-			seg = 1;
-		}
+		hdr_len = c_tx->ctrl_len - c_tx->ctrl_sent;
+		bvec_set_virt(&bvec[0], hdr, hdr_len);
+		seg = 1;
 	}
 
 	wqe->processed += data_len;
@@ -477,28 +362,9 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 		} else {
 			is_kva = 1;
 		}
-		if (is_kva && !c_tx->use_sendpage) {
-			/*
-			 * tx from kernel virtual address: either inline data
-			 * or memory region with assigned kernel buffer
-			 */
-			iov[seg].iov_base =
-				ib_virt_dma_to_ptr(sge->laddr + sge_off);
-			iov[seg].iov_len = sge_len;
-
-			if (do_crc)
-				crypto_shash_update(c_tx->mpa_crc_hd,
-						    iov[seg].iov_base,
-						    sge_len);
-			sge_off += sge_len;
-			data_len -= sge_len;
-			seg++;
-			goto sge_done;
-		}
 
 		while (sge_len) {
 			size_t plen = min((int)PAGE_SIZE - fp_off, sge_len);
-			void *kaddr;
 
 			if (!is_kva) {
 				struct page *p;
@@ -511,33 +377,12 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 					p = siw_get_upage(mem->umem,
 							  sge->laddr + sge_off);
 				if (unlikely(!p)) {
-					siw_unmap_pages(iov, kmap_mask, seg);
 					wqe->processed -= c_tx->bytes_unsent;
 					rv = -EFAULT;
 					goto done_crc;
 				}
-				page_array[seg] = p;
-
-				if (!c_tx->use_sendpage) {
-					void *kaddr = kmap_local_page(p);
-
-					/* Remember for later kunmap() */
-					kmap_mask |= BIT(seg);
-					iov[seg].iov_base = kaddr + fp_off;
-					iov[seg].iov_len = plen;
-
-					if (do_crc)
-						crypto_shash_update(
-							c_tx->mpa_crc_hd,
-							iov[seg].iov_base,
-							plen);
-				} else if (do_crc) {
-					kaddr = kmap_local_page(p);
-					crypto_shash_update(c_tx->mpa_crc_hd,
-							    kaddr + fp_off,
-							    plen);
-					kunmap_local(kaddr);
-				}
+
+				bvec_set_page(&bvec[seg], p, plen, fp_off);
 			} else {
 				/*
 				 * Cast to an uintptr_t to preserve all 64 bits
@@ -545,12 +390,17 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 				 */
 				u64 va = sge->laddr + sge_off;
 
-				page_array[seg] = ib_virt_dma_to_page(va);
-				if (do_crc)
-					crypto_shash_update(
-						c_tx->mpa_crc_hd,
-						ib_virt_dma_to_ptr(va),
-						plen);
+				bvec_set_virt(&bvec[seg],
+					      ib_virt_dma_to_ptr(va), plen);
+			}
+
+			if (do_crc) {
+				void *kaddr =
+					kmap_local_page(bvec[seg].bv_page);
+				crypto_shash_update(c_tx->mpa_crc_hd,
+						    kaddr + bvec[seg].bv_offset,
+						    bvec[seg].bv_len);
+				kunmap_local(kaddr);
 			}
 
 			sge_len -= plen;
@@ -560,13 +410,12 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 
 			if (++seg >= (int)MAX_ARRAY) {
 				siw_dbg_qp(tx_qp(c_tx), "to many fragments\n");
-				siw_unmap_pages(iov, kmap_mask, seg-1);
 				wqe->processed -= c_tx->bytes_unsent;
 				rv = -EMSGSIZE;
 				goto done_crc;
 			}
 		}
-sge_done:
+
 		/* Update SGE variables at end of SGE */
 		if (sge_off == sge->length &&
 		    (data_len != 0 || wqe->processed < wqe->bytes)) {
@@ -575,15 +424,8 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 			sge_off = 0;
 		}
 	}
-	/* trailer */
-	if (likely(c_tx->state != SIW_SEND_TRAILER)) {
-		iov[seg].iov_base = &c_tx->trailer.pad[4 - c_tx->pad];
-		iov[seg].iov_len = trl_len = MAX_TRAILER - (4 - c_tx->pad);
-	} else {
-		iov[seg].iov_base = &c_tx->trailer.pad[c_tx->ctrl_sent];
-		iov[seg].iov_len = trl_len = MAX_TRAILER - c_tx->ctrl_sent;
-	}
 
+	/* Set the CRC in the trailer */
 	if (c_tx->pad) {
 		*(u32 *)c_tx->trailer.pad = 0;
 		if (do_crc)
@@ -596,23 +438,23 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 	else if (do_crc)
 		crypto_shash_final(c_tx->mpa_crc_hd, (u8 *)&c_tx->trailer.crc);
 
-	data_len = c_tx->bytes_unsent;
-
-	if (c_tx->use_sendpage) {
-		rv = siw_0copy_tx(s, page_array, &wqe->sqe.sge[c_tx->sge_idx],
-				  c_tx->sge_off, data_len);
-		if (rv == data_len) {
-			rv = kernel_sendmsg(s, &msg, &iov[seg], 1, trl_len);
-			if (rv > 0)
-				rv += data_len;
-			else
-				rv = data_len;
-		}
+	/* Copy the trailer and add it to the output list */
+	if (likely(c_tx->state != SIW_SEND_TRAILER)) {
+		trl = &c_tx->trailer.pad[4 - c_tx->pad];
+		trl_len = MAX_TRAILER - (4 - c_tx->pad);
 	} else {
-		rv = kernel_sendmsg(s, &msg, iov, seg + 1,
-				    hdr_len + data_len + trl_len);
-		siw_unmap_pages(iov, kmap_mask, seg);
+		trl = &c_tx->trailer.pad[c_tx->ctrl_sent];
+		trl_len = MAX_TRAILER - c_tx->ctrl_sent;
 	}
+	bvec_set_virt(&bvec[seg], trl, trl_len);
+
+	data_len = c_tx->bytes_unsent;
+
+	if (c_tx->use_sendpage)
+		msg.msg_flags |= MSG_SPLICE_PAGES;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, bvec, seg + 1,
+		      hdr_len + data_len + trl_len);
+	rv = sock_sendmsg(s, &msg);
 	if (rv < (int)hdr_len) {
 		/* Not even complete hdr pushed or negative rv */
 		wqe->processed -= data_len;
@@ -673,7 +515,6 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 	}
 done_crc:
 	c_tx->do_crc = 0;
-done:
 	return rv;
 }
 


