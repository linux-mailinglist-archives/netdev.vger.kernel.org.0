Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7CD1FA716
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFPDhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:37:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C359C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:37:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 186so3556357yby.19
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bZDLxh48h2jTHLDHRC62/uMdHeOG86jVbxuIXjmy7s0=;
        b=XHNB5lMVRZB1led5BSqLD7nD3gOsr5dNv1RcsVC/d/qWeedM2iN3OYaTXljlgJfFmi
         yGg0l73Gl8VqDpo8Cor9Djtru78t0NLYrbEwtI/MEKVDAfDKPfVvRkpnzyKr6i08kTW1
         HlMdz1cqFXl/5TIbz9M6kc+zOznEWwbrL73MGMBSciZ4HqdR9j1yuKDb14wisiCCRfRy
         +7wrq+QXRNkM2hU6ypJJ2s6ajdLgtXPXgJgLQSqdZTdplaIXudLkZ2g8wGi7mQXC0VHJ
         yB38SlJOhkxLUcptCi4w/Ym2RBvTYwyUPoc/DeVWzS48zO6aIzNl6S3LWOng/jaR31Kj
         H3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bZDLxh48h2jTHLDHRC62/uMdHeOG86jVbxuIXjmy7s0=;
        b=b1b3iY8qE93Xbsen9VHnaP9pBmMnrkfcyZt0AzVVmzJYXZx6l+CAzq+NyqEHDamxu2
         J6fms9M2XVLIjKoxhfVYXuSeIVzte6s8xI5urpgL4oAlBOx+9qa7vaVgEi0uI+XoDgGH
         NrSUPmhwaKzxZgz00U9f8CZM3mEXTh0PLR/8hI1RU49veJHlJA/d07YNOiSDIg6VDSWr
         51PHzhUpMefvbtGgJ8eRg0wA7+k79hx9inB5Vxkzf8uOjTSsjd8E8kDPpl9qNPiEEWg9
         +vJFo+VPXmQotC5c/m+nLMFqeJsa67Da38tpfkj6HRt/D4fgsfojzNZafgsvQUVO9KQi
         aX6g==
X-Gm-Message-State: AOAM530MflDtH7vtm1TJ+9IUC/tf2aF4wZPezopBNnirKdq7Gl2vIM9r
        /9awOpj3kdOUlisE+xQmjZXxyIX0u4Pyag==
X-Google-Smtp-Source: ABdhPJw0Fb+FjXmypZuLzKKuAHIxRZ5/n9pt7EVjPgBSoyx6ni1SHvNFLjroBTAnDhvBMbszjbZZgZjiBEFv/g==
X-Received: by 2002:a25:748a:: with SMTP id p132mr1063710ybc.493.1592278630761;
 Mon, 15 Jun 2020 20:37:10 -0700 (PDT)
Date:   Mon, 15 Jun 2020 20:37:07 -0700
Message-Id: <20200616033707.145423-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net] tcp: grow window for OOO packets only for SACK flows
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back in 2013, we made a change that broke fast retransmit
for non SACK flows.

Indeed, for these flows, a sender needs to receive three duplicate
ACK before starting fast retransmit. Sending ACK with different
receive window do not count.

Even if enabling SACK is strongly recommended these days,
there still are some cases where it has to be disabled.

Not increasing the window seems better than having to
rely on RTO.

After the fix, following packetdrill test gives :

// Initialize connection
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1000,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,wscale 8>
   +0 < . 1:1(0) ack 1 win 514

   +0 accept(3, ..., ...) = 4

   +0 < . 1:1001(1000) ack 1 win 514
// Quick ack
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 2001:3001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 3001:4001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 4001:5001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
    +0 > . 1:1(0) ack 1001 win 264

   +0 < . 1001:2001(1000) ack 1 win 514
// Hole is repaired.
   +0 > . 1:1(0) ack 5001 win 272

Fixes: 4e4f1fc22681 ("tcp: properly increase rcv_ssthresh for ofo packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
---
 net/ipv4/tcp_input.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 83330a6cb24209cf6ac60d634245b7bc151ee6ac..12fda8f27b08bdf5c9f3bad422734f6b1965cef9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4605,7 +4605,11 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (tcp_ooo_try_coalesce(sk, tp->ooo_last_skb,
 				 skb, &fragstolen)) {
 coalesce_done:
-		tcp_grow_window(sk, skb);
+		/* For non sack flows, do not grow window to force DUPACK
+		 * and trigger fast retransmit.
+		 */
+		if (tcp_is_sack(tp))
+			tcp_grow_window(sk, skb);
 		kfree_skb_partial(skb, fragstolen);
 		skb = NULL;
 		goto add_sack;
@@ -4689,7 +4693,11 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_sack_new_ofo_skb(sk, seq, end_seq);
 end:
 	if (skb) {
-		tcp_grow_window(sk, skb);
+		/* For non sack flows, do not grow window to force DUPACK
+		 * and trigger fast retransmit.
+		 */
+		if (tcp_is_sack(tp))
+			tcp_grow_window(sk, skb);
 		skb_condense(skb);
 		skb_set_owner_r(skb, sk);
 	}
-- 
2.27.0.290.gba653c62da-goog

