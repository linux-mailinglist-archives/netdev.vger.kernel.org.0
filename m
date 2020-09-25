Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F89278F4D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgIYREk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgIYREj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:04:39 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBA8C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e12so2849091pfm.0
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fAS1HK36MpDrFQPqOdGconAl2xhLDaF0hI+cer5liZk=;
        b=DGJqL1XBcYzca0zwB4WkMYr60cYLmVg/KaNIycR+iEFUo0qYa2dTdy/P6FtFC1+Kf9
         23yHECLSoB6Cru4fa5dtdHTivT8lhowfZz2Vo27QqhFqRYTVm7Pq7/C8ZwEfogoo8Cjk
         kxKzIM6acr9jKuJ1uEgUDo+zbJHOS+AIJ5AKrSOkaEAQLqYBIm4UOjdAlzB9xu6VGIDR
         UqYmXvQ0bB5Z/HrsGpgtdLJtHYDrJhyi0jHo/kVLTQwRUkorzCPoxytQLov5qQsJqg4h
         4uA/n/jD/x9+iuzJmNE0GqFqqNAs0urYsb0ng4RHiQSld0z3W82ki5ZLE1JkOoItp9tz
         GQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fAS1HK36MpDrFQPqOdGconAl2xhLDaF0hI+cer5liZk=;
        b=Cxz4goNC8VhGK8xT9yjkDWjeBTv6dtFIYhxArzl57oOSTxTuMR10hdADmTEZfHt1GI
         P16YRjNdIqL8Ypw6TUSAaaMcF+hDM7xNZFU0MQh8rE5lVk1RsivihpHbpKkmfzik5BXQ
         w+S+YSbMWkpaN3knr4VhMKjXLnqD2+hs92kykvn1CF2h2KgJ+tPPFXucLJyM2lRmEoAK
         EbJRj7ypoNxaUX2uVUo3ByfomBFWHL7kYhKBgWVjBOc/j8toeRfBKN0KyCt7UMkWrV/z
         NrVA5B+vnTC5KEGNIRYXvQwaTsi0vnzpj/bVIyVhy9o2MEConC78TxrmYTpRI8Po6d9J
         2rww==
X-Gm-Message-State: AOAM530wSSij3OPJM8dEm/koqBzouScwKjSz1GtJUUdueHaEnQUBha5B
        nMhvEyTr/Tmy5g0W5NBXK7ZZtnMAUjw=
X-Google-Smtp-Source: ABdhPJxc2wa/JehqHfiNAhh6HyM4PKHpMoxz2BgsybV+RYQj/PBgnkxKWNLyyZGmsefOJ5RTMoXJnac8d4o=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a17:902:aa95:b029:d2:19f4:ff56 with SMTP id
 d21-20020a170902aa95b02900d219f4ff56mr346164plr.78.1601053479039; Fri, 25 Sep
 2020 10:04:39 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:04:28 -0700
In-Reply-To: <20200925170431.1099943-1-ycheng@google.com>
Message-Id: <20200925170431.1099943-2-ycheng@google.com>
Mime-Version: 1.0
References: <20200925170431.1099943-1-ycheng@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next 1/4] tcp: consistently check retransmit hint
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_simple_retransmit() used for path MTU discovery may not adjust
the retransmit hint properly by deducting retrans_out before checking
it to adjust the hint. This patch fixes this by a correct routine
tcp_mark_skb_lost() already used by the RACK loss detection.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c    | 9 ++-------
 net/ipv4/tcp_recovery.c | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 50834e7f958e..f84420dc7d37 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2675,13 +2675,8 @@ void tcp_simple_retransmit(struct sock *sk)
 
 	skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
 		if (tcp_skb_seglen(skb) > mss &&
-		    !(TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)) {
-			if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_RETRANS) {
-				TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
-				tp->retrans_out -= tcp_skb_pcount(skb);
-			}
-			tcp_skb_mark_lost_uncond_verify(tp, skb);
-		}
+		    !(TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
+			tcp_mark_skb_lost(sk, skb);
 	}
 
 	tcp_clear_retrans_hints_partial(tp);
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index fdb715bdd2d1..26a42289a870 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -246,6 +246,6 @@ void tcp_newreno_mark_lost(struct sock *sk, bool snd_una_advanced)
 			tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb,
 				     mss, mss, GFP_ATOMIC);
 
-		tcp_skb_mark_lost_uncond_verify(tp, skb);
+		tcp_mark_skb_lost(sk, skb);
 	}
 }
-- 
2.28.0.681.g6f77f65b4e-goog

