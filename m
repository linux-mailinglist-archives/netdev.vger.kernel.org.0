Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819702B030C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgKLKtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbgKLKtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUYvbbfy6T6Sm7+J87lHgVC3YiqT/xVkivx28njVxWI=;
        b=eWeM3ONSL+FX7o/Rmvxag9JR328K0sVVgIgFSD5UvuDCNsNqHBTDi4bG8NUXEZdiaGPxRU
        fNU4bY0G1R7zuqkmVjNQh4VwPHXxoVQjs2xFqO7Dnfx50vJFAk8TOlBgt5DCYJyYv0k9gr
        hz0R793R6dFcFvq4Fu761Ucx23oW9J8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-qZAjORKzNdms4mSaa2AKaA-1; Thu, 12 Nov 2020 05:49:00 -0500
X-MC-Unique: qZAjORKzNdms4mSaa2AKaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17DB6108594F;
        Thu, 12 Nov 2020 10:48:59 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDDDD5C3E1;
        Thu, 12 Nov 2020 10:48:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/13] mptcp: use tcp_build_frag()
Date:   Thu, 12 Nov 2020 11:48:00 +0100
Message-Id: <e9ab4e3eacb3b983110af3cf24b435c183a6193e.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index b84b84adc9ad..0d712755d7fc 100644
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

