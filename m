Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189A91C03F4
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgD3Rfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:35:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D27C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m138so8619127ybf.12
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=95kKH2I/3l6suen8DIljhfpclih+REAoGAkI8GXxGIY=;
        b=HkfehOpsIgiLN0W6BiX83X3tOUCrHP9eKavhP8oS7V2EdaEr5soCSqVV7P3XzcYwOU
         JYyTvZG6MvOlleFk9PXlOxBuSDtcUKs6/YmFE+nVJL1vo4jXRKylo2tE6AZoMWiUlsIc
         eyvpQmADlMWoYcgnt3XyiyKh3Q20+hYIrgSTeJkq9PMpE4mLq7/8XVzgMQd+3yhVC61L
         o+8KxLFvcPw42SUwXOYyjh/cJ64K0AGR8TrjBc1i/gHJWCcE/Wr8HbNTdGEw8GAEIMCe
         /WFgQsHouMkeMflPuq3VoH+adl4R6ocaHHf0qkaDMlavAIqJxcjJ/dyTjHl+ZNbHhNaf
         b5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=95kKH2I/3l6suen8DIljhfpclih+REAoGAkI8GXxGIY=;
        b=AH1vnHM6nYC3Dw0pYNbgMgpLnzl6NYQeWtbvbVdWmlEAI8nHkeIgm/ZbehKimokoV3
         pNBl7lWHEYsdFVvDAvaePRXOH8dI5ukeZvka53ztogJuCQCgMJTLktoHxYBeFi6Ost0a
         kLfmYHrxltoxRzTTOYCsViGSx5SxK+tEHVjGiGQ0iTZ5cJSLuDC60+Va0EWzjLjsosgi
         etZSuqRBHwMUOiTJA2zblF8TmTZGsNqlyeir0kBvFZLS6CaVbNEcvf8uXlaEFcD9M7IH
         qMeHndg7lf3DxYlSDrV6Wd31pFm6Xn9UbTuLtEYFBjaZOk222uGx7KEeOIpc/9Il4zVz
         iFMQ==
X-Gm-Message-State: AGi0PuaiB9clX98VVK2AZBobpr9Zb3TsBzc9pPDDt9q736A35BDvcgiz
        aMu8NcHvp0kTNWku4HNvdKgC8i3ajYbLiQ==
X-Google-Smtp-Source: APiQypJELbkErwkqKDVodECaX31opylAbociBMWGl+8ZMWmCZk9mlvpRlOW/OQTwV6ylLeil/rn1u/iDRCAgiw==
X-Received: by 2002:a5b:bc8:: with SMTP id c8mr7445139ybr.395.1588268152273;
 Thu, 30 Apr 2020 10:35:52 -0700 (PDT)
Date:   Thu, 30 Apr 2020 10:35:42 -0700
In-Reply-To: <20200430173543.41026-1-edumazet@google.com>
Message-Id: <20200430173543.41026-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200430173543.41026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net-next 2/3] tcp: tcp_sack_new_ofo_skb() should be more conservative
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tcp_sack_new_ofo_skb() sends an ack if prior
acks were 'compressed', if room has to be made in tp->selective_acks[]

But there is no guarantee all four sack ranges can be included
in SACK option. As a matter of fact, when TCP timestamps option
is used, only three SACK ranges can be included.

Lets assume only two ranges can be included, and force the ack:

- When we touch more than 2 ranges in the reordering
  done if tcp_sack_extend() could be done.

- If we have at least 2 ranges when adding a new one.

This enforces that before a range is in third or fourth
position, at least one ACK packet included it in first/second
position.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_input.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index da777df0a0baefb3bef8c802c9b9b83ff38b9fc9..ef921ecba4155abe9d078152ca8bd6a0be68317e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4348,6 +4348,12 @@ static void tcp_sack_compress_send_ack(struct sock *sk)
 	tcp_send_ack(sk);
 }
 
+/* Reasonable amount of sack blocks included in TCP SACK option
+ * The max is 4, but this becomes 3 if TCP timestamps are there.
+ * Given that SACK packets might be lost, be conservative and use 2.
+ */
+#define TCP_SACK_BLOCKS_EXPECTED 2
+
 static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -4360,6 +4366,8 @@ static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 
 	for (this_sack = 0; this_sack < cur_sacks; this_sack++, sp++) {
 		if (tcp_sack_extend(sp, seq, end_seq)) {
+			if (this_sack >= TCP_SACK_BLOCKS_EXPECTED)
+				tcp_sack_compress_send_ack(sk);
 			/* Rotate this_sack to the first one. */
 			for (; this_sack > 0; this_sack--, sp--)
 				swap(*sp, *(sp - 1));
@@ -4369,6 +4377,9 @@ static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 		}
 	}
 
+	if (this_sack >= TCP_SACK_BLOCKS_EXPECTED)
+		tcp_sack_compress_send_ack(sk);
+
 	/* Could not find an adjacent existing SACK, build a new one,
 	 * put it at the front, and shift everyone else down.  We
 	 * always know there is at least one SACK present already here.
@@ -4376,7 +4387,6 @@ static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 	 * If the sack array is full, forget about the last one.
 	 */
 	if (this_sack >= TCP_NUM_SACKS) {
-		tcp_sack_compress_send_ack(sk);
 		this_sack--;
 		tp->rx_opt.num_sacks--;
 		sp--;
-- 
2.26.2.303.gf8c07b1a785-goog

