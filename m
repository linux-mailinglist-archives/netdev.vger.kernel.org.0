Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBA140FCB9
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhIQPke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:40:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241898AbhIQPkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631893150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zhpqnvr5P0Rs3k/q+nqsF3Dii07E6KFJrmbpNgKLJMM=;
        b=giMNmk51t3asTiwspgB5eCMJMthXD5bCXRdNJCWolJI2fxWCOJ8C8x8dHfZTwGlSGV677n
        RrmRZB6NtufhyqhNw9+KckWBWpEgUt01JoxmhSfBQyALZKpcOoq74fL76k1wBnwAp3nj5O
        hIKEve0vdFXMdWTeQppWHVY/aQtMB5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-RLcskn4CMtySgKIJaomz7w-1; Fri, 17 Sep 2021 11:39:06 -0400
X-MC-Unique: RLcskn4CMtySgKIJaomz7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94560101F007;
        Fri, 17 Sep 2021 15:39:05 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D87DC18A8F;
        Fri, 17 Sep 2021 15:39:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 1/5] chtls: rename skb_entail() to chtls_skb_entail()
Date:   Fri, 17 Sep 2021 17:38:36 +0200
Message-Id: <04d1b3ce3e139be5114c1fd89eb64a7e0b0df810.1631888517.git.pabeni@redhat.com>
In-Reply-To: <cover.1631888517.git.pabeni@redhat.com>
References: <cover.1631888517.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The next patch will expose the core TCP helper with the same
name. It looks like we can't trivially re-use it in chtls, so
remame the driver specific's one to avoid name conflicts.

Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls.h   |  2 +-
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    |  2 +-
 .../ethernet/chelsio/inline_crypto/chtls/chtls_io.c    | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 9e2378013642..4b57e58845b0 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -580,7 +580,7 @@ void chtls_set_tcb_field_rpl_skb(struct sock *sk, u16 word,
 				 int through_l2t);
 int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 mode, int cipher_type);
 void chtls_set_quiesce_ctrl(struct sock *sk, int val);
-void skb_entail(struct sock *sk, struct sk_buff *skb, int flags);
+void chtls_skb_entail(struct sock *sk, struct sk_buff *skb, int flags);
 unsigned int keyid_to_addr(int start_addr, int keyid);
 void free_tls_keyid(struct sock *sk);
 #endif
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index bcad69c48074..dfa2bfc9638e 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -317,7 +317,7 @@ static void chtls_close_conn(struct sock *sk)
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_CLOSE_CON_REQ, tid));
 
 	tcp_uncork(sk);
-	skb_entail(sk, skb, ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
+	chtls_skb_entail(sk, skb, ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
 	if (sk->sk_state != TCP_SYN_SENT)
 		chtls_push_frames(csk, 1);
 }
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index c320cc8ca68d..05cf45098462 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -119,8 +119,8 @@ static int send_flowc_wr(struct sock *sk, struct fw_flowc_wr *flowc,
 		if (!skb)
 			return -ENOMEM;
 
-		skb_entail(sk, skb,
-			   ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
+		chtls_skb_entail(sk, skb,
+				 ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
 		return 0;
 	}
 
@@ -816,7 +816,7 @@ static int select_size(struct sock *sk, int io_len, int flags, int len)
 	return io_len;
 }
 
-void skb_entail(struct sock *sk, struct sk_buff *skb, int flags)
+void chtls_skb_entail(struct sock *sk, struct sk_buff *skb, int flags)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -840,7 +840,7 @@ static struct sk_buff *get_tx_skb(struct sock *sk, int size)
 	skb = alloc_skb(size + TX_HEADER_LEN, sk->sk_allocation);
 	if (likely(skb)) {
 		skb_reserve(skb, TX_HEADER_LEN);
-		skb_entail(sk, skb, ULPCB_FLAG_NEED_HDR);
+		chtls_skb_entail(sk, skb, ULPCB_FLAG_NEED_HDR);
 		skb_reset_transport_header(skb);
 	}
 	return skb;
@@ -857,7 +857,7 @@ static struct sk_buff *get_record_skb(struct sock *sk, int size, bool zcopy)
 	if (likely(skb)) {
 		skb_reserve(skb, (TX_TLSHDR_LEN +
 			    KEY_ON_MEM_SZ + max_ivs_size(sk, size)));
-		skb_entail(sk, skb, ULPCB_FLAG_NEED_HDR);
+		chtls_skb_entail(sk, skb, ULPCB_FLAG_NEED_HDR);
 		skb_reset_transport_header(skb);
 		ULP_SKB_CB(skb)->ulp.tls.ofld = 1;
 		ULP_SKB_CB(skb)->ulp.tls.type = csk->tlshws.type;
-- 
2.26.3

