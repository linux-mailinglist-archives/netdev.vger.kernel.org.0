Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0AD42CBE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502265AbfFLQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:52 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:47837 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502240AbfFLQwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:51 -0400
Received: by mail-yb1-f201.google.com with SMTP id k10so16028828ybd.14
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tfKXnvv/aEYtKnSYlu3ZyBW1DvmgTnVxp/N4Bhkr328=;
        b=s6jC0/B6eS0iRDIPg1xO2aNQktx6o6avTFVi7sB15olyy+Em2URZ/5ngU/vO3u3Ez9
         870j2r3Jfg3kUQlWWai50Q3E3nh1os3TuXZ7aHUhKpL5wnCcWswmC65x/FZehxC/w3LS
         8PhyAeG2vVg4T0COfGS1SLuO6l9pv6qY3ndFFG4fUaxsP0n+BkAdd1JDBmreIRmtR46y
         8C4FG2J9Vd9z87Zuvz5oadkDBd7X7Nk73SwyteBp36/HbELEe99wMvo/tbXq7I0/yeVV
         EPtrbtP5qEs5BuSlcI/X7mlaajjg9JMwOneDTn3fgEzDy8nnBtKoCJgCkuT4ugU1UdPa
         TRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tfKXnvv/aEYtKnSYlu3ZyBW1DvmgTnVxp/N4Bhkr328=;
        b=ARJbBPDDANZdGipg0q4cVS6Lfj6uMnFt/MPH8bDdWja/mX1jN/CWTBgm3/Ux/0Jl0t
         VAOB04DzeTnm/tIcG1MzDZe2ITjbjW7ElFpqw9VYbHcEx8KVr1Blxd6UDBFskUxaP+uz
         twTRa740OdwHBiVYr8st8j51Bl7VWsUdhCIRwf+CHZ3SjhE6T6oR8W13luzlHRnUbQUz
         tClphMnJXBcA2bDm7w4kfjptCxoU9aeZEdp6QC5uYU5QWIOjNIBrdXsqVVCKeIprMoL3
         32D7hvlf5EmrWT3nACjR+rbhEpKC948vrGU+6D4ViGtyTzMfkcmrZCZADh4NmCfgYL0H
         vLLg==
X-Gm-Message-State: APjAAAVAOfhoAtFkZC4Y8PDONYWVtQAblN5IwsZ2qK9q2v4Ad7HKgk8V
        LZFcCIMuuaMLXUweSIIKTqBxh0vn7NeV9w==
X-Google-Smtp-Source: APXvYqy/H1kgBT4kko+rlJKgzWeqR2AbvCr2a+e6/xQuvvdY1dJ9+PXJbMLYl0bQGVsCxqyWCM6B7h5vWbOY6g==
X-Received: by 2002:a0d:fe44:: with SMTP id o65mr28618154ywf.257.1560358370368;
 Wed, 12 Jun 2019 09:52:50 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:29 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-5-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 4/8] net/packet: constify __packet_rcv_has_room()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goal is use the helper without lock being held.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5ef63d0c3ad0a184a03429fdd52cad26349647d1..a0564855ed9dca4be37f70ed81c6dee1b38aca39 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1224,15 +1224,18 @@ static bool __tpacket_v3_has_room(const struct packet_sock *po, int pow_off)
 	return prb_lookup_block(po, &po->rx_ring, idx, TP_STATUS_KERNEL);
 }
 
-static int __packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
+static int __packet_rcv_has_room(const struct packet_sock *po,
+				 const struct sk_buff *skb)
 {
-	struct sock *sk = &po->sk;
+	const struct sock *sk = &po->sk;
 	int ret = ROOM_NONE;
 
 	if (po->prot_hook.func != tpacket_rcv) {
-		int avail = sk->sk_rcvbuf - atomic_read(&sk->sk_rmem_alloc)
-					  - (skb ? skb->truesize : 0);
-		if (avail > (sk->sk_rcvbuf >> ROOM_POW_OFF))
+		int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+		int avail = rcvbuf - atomic_read(&sk->sk_rmem_alloc)
+				   - (skb ? skb->truesize : 0);
+
+		if (avail > (rcvbuf >> ROOM_POW_OFF))
 			return ROOM_NORMAL;
 		else if (avail > 0)
 			return ROOM_LOW;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

