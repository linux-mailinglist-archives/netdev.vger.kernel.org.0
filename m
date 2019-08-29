Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41471A1AD9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfH2NGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfH2NGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:06:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C7A83CA0C;
        Thu, 29 Aug 2019 13:06:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF625D9C9;
        Thu, 29 Aug 2019 13:06:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/5] rxrpc: Use skb_unshare() rather than skb_cow_data()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 29 Aug 2019 14:06:47 +0100
Message-ID: <156708400744.25861.1729881072245920016.stgit@warthog.procyon.org.uk>
In-Reply-To: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
References: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 29 Aug 2019 13:06:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The in-place decryption routines in AF_RXRPC's rxkad security module
currently call skb_cow_data() to make sure the data isn't shared and that
the skb can be written over.  This has a problem, however, as the softirq
handler may be still holding a ref or the Rx ring may be holding multiple
refs when skb_cow_data() is called in rxkad_verify_packet() - and so
skb_shared() returns true and __pskb_pull_tail() dislikes that.  If this
occurs, something like the following report will be generated.

	kernel BUG at net/core/skbuff.c:1463!
	...
	RIP: 0010:pskb_expand_head+0x253/0x2b0
	...
	Call Trace:
	 __pskb_pull_tail+0x49/0x460
	 skb_cow_data+0x6f/0x300
	 rxkad_verify_packet+0x18b/0xb10 [rxrpc]
	 rxrpc_recvmsg_data.isra.11+0x4a8/0xa10 [rxrpc]
	 rxrpc_kernel_recv_data+0x126/0x240 [rxrpc]
	 afs_extract_data+0x51/0x2d0 [kafs]
	 afs_deliver_fs_fetch_data+0x188/0x400 [kafs]
	 afs_deliver_to_call+0xac/0x430 [kafs]
	 afs_wait_for_call_to_complete+0x22f/0x3d0 [kafs]
	 afs_make_call+0x282/0x3f0 [kafs]
	 afs_fs_fetch_data+0x164/0x300 [kafs]
	 afs_fetch_data+0x54/0x130 [kafs]
	 afs_readpages+0x20d/0x340 [kafs]
	 read_pages+0x66/0x180
	 __do_page_cache_readahead+0x188/0x1a0
	 ondemand_readahead+0x17d/0x2e0
	 generic_file_read_iter+0x740/0xc10
	 __vfs_read+0x145/0x1a0
	 vfs_read+0x8c/0x140
	 ksys_read+0x4a/0xb0
	 do_syscall_64+0x43/0xf0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by using skb_unshare() instead in the input path for DATA packets
that have a security index != 0.  Non-DATA packets don't need in-place
encryption and neither do unencrypted DATA packets.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   12 ++++++++----
 net/rxrpc/ar-internal.h      |    1 +
 net/rxrpc/input.c            |   18 ++++++++++++++++++
 net/rxrpc/rxkad.c            |   32 +++++++++-----------------------
 net/rxrpc/skbuff.c           |   25 ++++++++++++++++++++-----
 5 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index e2356c51883b..a13a62db3565 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -32,6 +32,8 @@ enum rxrpc_skb_trace {
 	rxrpc_skb_received,
 	rxrpc_skb_rotated,
 	rxrpc_skb_seen,
+	rxrpc_skb_unshared,
+	rxrpc_skb_unshared_nomem,
 };
 
 enum rxrpc_local_trace {
@@ -231,7 +233,9 @@ enum rxrpc_tx_point {
 	EM(rxrpc_skb_purged,			"PUR") \
 	EM(rxrpc_skb_received,			"RCV") \
 	EM(rxrpc_skb_rotated,			"ROT") \
-	E_(rxrpc_skb_seen,			"SEE")
+	EM(rxrpc_skb_seen,			"SEE") \
+	EM(rxrpc_skb_unshared,			"UNS") \
+	E_(rxrpc_skb_unshared_nomem,		"US0")
 
 #define rxrpc_local_traces \
 	EM(rxrpc_local_got,			"GOT") \
@@ -633,9 +637,9 @@ TRACE_EVENT(rxrpc_call,
 
 TRACE_EVENT(rxrpc_skb,
 	    TP_PROTO(struct sk_buff *skb, enum rxrpc_skb_trace op,
-		     int usage, int mod_count, const void *where),
+		     int usage, int mod_count, u8 flags,    const void *where),
 
-	    TP_ARGS(skb, op, usage, mod_count, where),
+	    TP_ARGS(skb, op, usage, mod_count, flags, where),
 
 	    TP_STRUCT__entry(
 		    __field(struct sk_buff *,		skb		)
@@ -648,7 +652,7 @@ TRACE_EVENT(rxrpc_skb,
 
 	    TP_fast_assign(
 		    __entry->skb = skb;
-		    __entry->flags = rxrpc_skb(skb)->rx_flags;
+		    __entry->flags = flags;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->mod_count = mod_count;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 2d5294f3e62f..852e58781fda 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1110,6 +1110,7 @@ void rxrpc_kernel_data_consumed(struct rxrpc_call *, struct sk_buff *);
 void rxrpc_packet_destructor(struct sk_buff *);
 void rxrpc_new_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_see_skb(struct sk_buff *, enum rxrpc_skb_trace);
+void rxrpc_eaten_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_get_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_free_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_purge_queue(struct sk_buff_head *);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 31090bdf1fae..d122c53c8697 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1249,6 +1249,24 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 			goto bad_message;
 		if (!rxrpc_validate_data(skb))
 			goto bad_message;
+
+		/* Unshare the packet so that it can be modified for in-place
+		 * decryption.
+		 */
+		if (sp->hdr.securityIndex != 0) {
+			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
+			if (!nskb) {
+				rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
+				goto out;
+			}
+
+			if (nskb != skb) {
+				rxrpc_eaten_skb(skb, rxrpc_skb_received);
+				rxrpc_new_skb(skb, rxrpc_skb_unshared);
+				skb = nskb;
+				sp = rxrpc_skb(skb);
+			}
+		}
 		break;
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index ae8cd8926456..c60c520fde7c 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -187,10 +187,8 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
-	struct sk_buff *trailer;
 	unsigned int len;
 	u16 check;
-	int nsg;
 	int err;
 
 	sp = rxrpc_skb(skb);
@@ -214,15 +212,14 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	crypto_skcipher_encrypt(req);
 
 	/* we want to encrypt the skbuff in-place */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	err = -ENOMEM;
-	if (nsg < 0 || nsg > 16)
+	err = -EMSGSIZE;
+	if (skb_shinfo(skb)->nr_frags > 16)
 		goto out;
 
 	len = data_size + call->conn->size_align - 1;
 	len &= ~(call->conn->size_align - 1);
 
-	sg_init_table(sg, nsg);
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	err = skb_to_sgvec(skb, sg, 0, len);
 	if (unlikely(err < 0))
 		goto out;
@@ -319,11 +316,10 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxkad_level1_hdr sechdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
-	struct sk_buff *trailer;
 	bool aborted;
 	u32 data_size, buf;
 	u16 check;
-	int nsg, ret;
+	int ret;
 
 	_enter("");
 
@@ -336,11 +332,7 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	if (nsg < 0 || nsg > 16)
-		goto nomem;
-
-	sg_init_table(sg, nsg);
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = skb_to_sgvec(skb, sg, offset, 8);
 	if (unlikely(ret < 0))
 		return ret;
@@ -388,10 +380,6 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	if (aborted)
 		rxrpc_send_abort_packet(call);
 	return -EPROTO;
-
-nomem:
-	_leave(" = -ENOMEM");
-	return -ENOMEM;
 }
 
 /*
@@ -406,7 +394,6 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxkad_level2_hdr sechdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist _sg[4], *sg;
-	struct sk_buff *trailer;
 	bool aborted;
 	u32 data_size, buf;
 	u16 check;
@@ -423,12 +410,11 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	if (nsg < 0)
-		goto nomem;
-
 	sg = _sg;
-	if (unlikely(nsg > 4)) {
+	nsg = skb_shinfo(skb)->nr_frags;
+	if (nsg <= 4) {
+		nsg = 4;
+	} else {
 		sg = kmalloc_array(nsg, sizeof(*sg), GFP_NOIO);
 		if (!sg)
 			goto nomem;
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 8e6f45f84b9b..0348d2bf6f7d 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -24,7 +24,8 @@ void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+			rxrpc_skb(skb)->rx_flags, here);
 }
 
 /*
@@ -35,7 +36,8 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n = atomic_read(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+				rxrpc_skb(skb)->rx_flags, here);
 	}
 }
 
@@ -46,10 +48,21 @@ void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+			rxrpc_skb(skb)->rx_flags, here);
 	skb_get(skb);
 }
 
+/*
+ * Note the dropping of a ref on a socket buffer by the core.
+ */
+void rxrpc_eaten_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+{
+	const void *here = __builtin_return_address(0);
+	int n = atomic_inc_return(&rxrpc_n_rx_skbs);
+	trace_rxrpc_skb(skb, op, 0, n, 0, here);
+}
+
 /*
  * Note the destruction of a socket buffer.
  */
@@ -60,7 +73,8 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 		int n;
 		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+				rxrpc_skb(skb)->rx_flags, here);
 		kfree_skb(skb);
 	}
 }
@@ -75,7 +89,8 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 	while ((skb = skb_dequeue((list))) != NULL) {
 		int n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, rxrpc_skb_purged,
-				refcount_read(&skb->users), n, here);
+				refcount_read(&skb->users), n,
+				rxrpc_skb(skb)->rx_flags, here);
 		kfree_skb(skb);
 	}
 }

