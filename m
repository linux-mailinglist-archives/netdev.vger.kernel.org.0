Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325312B4033
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgKPJsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgKPJsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yTXVG8dt9nUabbLliCVl0X0xkDODTEBGO7CgtePjrQ=;
        b=SxzlEsXSJ9JoRDiDiICTgenmfQOS5Szvo+IWcGFoKbsI+Va2aU7RVb0yD7SUwIJwgFMtAs
        oDzw/xn9kNTSGeQNlBzocWOHJ8lo5dE/gBPEnGdQoDZW3qegFqAGEVu5M3ZTNw3WAwa7p4
        JwY7UmdcwyWSMM+EUbEArazP8zbIfrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-wwe_-7YGM_mNEgxafUS5oA-1; Mon, 16 Nov 2020 04:48:32 -0500
X-MC-Unique: wwe_-7YGM_mNEgxafUS5oA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDF6C108E1B3;
        Mon, 16 Nov 2020 09:48:31 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 805011002C1D;
        Mon, 16 Nov 2020 09:48:30 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 02/13] mptcp: use tcp_build_frag()
Date:   Mon, 16 Nov 2020 10:48:03 +0100
Message-Id: <4282a924c0bda6c5c80ababb5000cb17cc1b9954.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_push_pending() is called even on orphaned
msk (and orphaned subflows), if there is outstanding
data at close() time.

To cope with the above MPTCP needs to handle explicitly
the allocation failure on xmit. The newly introduced
do_tcp_sendfrag() allows that, just plug it.

We can additionally drop a couple of sanity checks,
duplicate in the TCP code.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index eaa61e227492..3c68cf912fb8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -992,17 +992,13 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		psize = min_t(size_t, dfrag->data_len, avail_size);
 	}
 
-	/* tell the TCP stack to delay the push so that we can safely
-	 * access the skb after the sendpages call
-	 */
-	ret = do_tcp_sendpages(ssk, page, offset, psize,
-			       msg->msg_flags | MSG_SENDPAGE_NOTLAST | MSG_DONTWAIT);
-	if (ret <= 0) {
-		if (!retransmission)
-			iov_iter_revert(&msg->msg_iter, psize);
-		return ret;
+	tail = tcp_build_frag(ssk, psize, msg->msg_flags, page, offset, &psize);
+	if (!tail) {
+		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
+		return -ENOMEM;
 	}
 
+	ret = psize;
 	frag_truesize += ret;
 	if (!retransmission) {
 		if (unlikely(ret < psize))
@@ -1026,20 +1022,15 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		sk->sk_forward_alloc -= frag_truesize;
 	}
 
-	/* if the tail skb extension is still the cached one, collapsing
-	 * really happened. Note: we can't check for 'same skb' as the sk_buff
-	 * hdr on tail can be transmitted, freed and re-allocated by the
-	 * do_tcp_sendpages() call
+	/* if the tail skb is still the cached one, collapsing really happened.
 	 */
-	tail = tcp_write_queue_tail(ssk);
-	if (mpext && tail && mpext == skb_ext_find(tail, SKB_EXT_MPTCP)) {
+	if (skb == tail) {
 		WARN_ON_ONCE(!can_collapse);
 		mpext->data_len += ret;
 		goto out;
 	}
 
-	skb = tcp_write_queue_tail(ssk);
-	mpext = __skb_ext_set(skb, SKB_EXT_MPTCP, msk->cached_ext);
+	mpext = __skb_ext_set(tail, SKB_EXT_MPTCP, msk->cached_ext);
 	msk->cached_ext = NULL;
 
 	memset(mpext, 0, sizeof(*mpext));
-- 
2.26.2

