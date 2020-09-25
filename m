Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC46278F4E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgIYREm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgIYREl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:04:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1416C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7so3174009ybq.22
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LkYOVOnkUnJHYHdTID+eAr4bWSUFNO12flF0Na+m7x0=;
        b=b8q+0D8d+g44dssqMdOkSSe3XqYzHSd1Uwl3Np2suBitB6gk69Q/x2jGCbyq58t5MU
         TkN88j6QIP3ePHIvu+1mOFm54+cIpUSNPFEmNW9z/IJgbkJ11vm+B1Lv+1ek53QTntHb
         SoqrwQIMtOcBPgco6TTxrS0auaNSb3kSzyL4r01PYyQb3tg8BAFOeQ4cH2jshDRIpBJQ
         6fniEplUzeQIt9lZEdrwpS4Y8/v3YE7U2c1pqjyLuW5pdwzwJcDuJrlqzvw4FC2Gyv88
         4DcpqKwjkfjqV5Xf1fyIO7xz5GjuBUzcgJ51rdI6muB5Uq74c23612DINUI+rRQDds5u
         AVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LkYOVOnkUnJHYHdTID+eAr4bWSUFNO12flF0Na+m7x0=;
        b=eIJUhnpHlWmtpSN0c/4rCMi+v55q+hpPvQyQCQT37rPFXT4UkW52vO1/hA/WHE5xrC
         H5Y6CqLeEISj+6H7SZh2OZzlIPFTQa1FvjRk6FroCKixsufiC+ccvKystngBJdhBQ/KC
         cjqyVzHponwRgQzFx2KGsYyVknHeErR91pMbOrwhcSkM7woSCVOabWvt+vuSKJSTC5AD
         p0Y2qpQd4RD2IAqkL326HkClsABEgRiaRe+2QZ04ZBNgRGggBAUqiZv0f/on21Q2P6cV
         JJ41rtoCl1ys/X/AncLmce8U0EkIf7fVKDshmd3PXFmVSTsR9JGZ0R6ngAXL+8uP1OLU
         xJlw==
X-Gm-Message-State: AOAM530fsqyODwlA4jPXrCpyu1Fzq6b9XNbIh6Rw/nLA/nEjNnKBIHV2
        aws3PGRkp7y3eyqssHsknD3yBr5+HgI=
X-Google-Smtp-Source: ABdhPJwBmRW/gQgEZGW8y32Dcl+FcdlQILWKm/b4/560KBBfczyXsT3+3R5SjR2rHnLJQ+GLXfgB7H4zp1A=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a25:3752:: with SMTP id e79mr242593yba.154.1601053480883;
 Fri, 25 Sep 2020 10:04:40 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:04:29 -0700
In-Reply-To: <20200925170431.1099943-1-ycheng@google.com>
Message-Id: <20200925170431.1099943-3-ycheng@google.com>
Mime-Version: 1.0
References: <20200925170431.1099943-1-ycheng@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next 2/4] tcp: move tcp_mark_skb_lost
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A pure refactor to move tcp_mark_skb_lost to tcp_input.c to prepare
for the later loss marking consolidation.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c    | 14 ++++++++++++++
 net/ipv4/tcp_recovery.c | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f84420dc7d37..0f8d33b95678 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1016,6 +1016,20 @@ static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 		tp->retransmit_skb_hint = skb;
 }
 
+void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	tcp_skb_mark_lost_uncond_verify(tp, skb);
+	if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_RETRANS) {
+		/* Account for retransmits that are lost again */
+		TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
+		tp->retrans_out -= tcp_skb_pcount(skb);
+		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPLOSTRETRANSMIT,
+			      tcp_skb_pcount(skb));
+	}
+}
+
 /* Sum the number of packets on the wire we have marked as lost.
  * There are two cases we care about here:
  * a) Packet hasn't been marked lost (nor retransmitted),
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 26a42289a870..f65a3ddd0d58 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -2,20 +2,6 @@
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
-void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	tcp_skb_mark_lost_uncond_verify(tp, skb);
-	if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_RETRANS) {
-		/* Account for retransmits that are lost again */
-		TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
-		tp->retrans_out -= tcp_skb_pcount(skb);
-		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPLOSTRETRANSMIT,
-			      tcp_skb_pcount(skb));
-	}
-}
-
 static bool tcp_rack_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
 {
 	return t1 > t2 || (t1 == t2 && after(seq1, seq2));
-- 
2.28.0.681.g6f77f65b4e-goog

