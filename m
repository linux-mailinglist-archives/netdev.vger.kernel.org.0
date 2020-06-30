Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9720F9CD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgF3Qth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgF3Qtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:49:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8175BC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:49:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id k1so11777887qko.14
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uMKtLi+P4br2ZtzViunrT6OChsSprmS/dqS+0k4wYBQ=;
        b=mXxzdiHzWPaeovPxBhAbP/IObKnWOc/axgW7/VVZnjH/ZUl8foNTDdyP6TUVHiXDgu
         WuBOfFJlW6zkzfwXlVUyqD8DNUIr0z1UZNUVkK0FS8loy5tHeK/I8wi5AzXBtxpvPtqO
         r7K8MzYgOLuhamslJ4lU8ynQ5ZmTnsizBq/D5IFGVa168bKK09Ytcc7NBqtc5fNUksNx
         LTaxCGOCMwWkrXQd9mAXBYxoBYUn/JV60qrlb1QtECpvSaHnmnkq3zpAjPRbPxvqHUf9
         3fg9RfcJ5PBV6LXOc69IvGkwpnrF2tB/lqpyY8apLrsttCeXddL+wTvYegT5jrSujfJw
         RuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uMKtLi+P4br2ZtzViunrT6OChsSprmS/dqS+0k4wYBQ=;
        b=VunTGyzcGtLHjwi92HobT8G8JQs44407Fo53u/cKLg4tWTj2Icu5pxXN+4LJ7Q8UUv
         4rR2JbezUWYsWnQkYeA4MKYXG9CzA7jft26pBkYvUPrabW315U/9TcRtc35d/yUjHmjK
         88LV9TyXe+7u40XnRXeiC1JzjuYS/2zrye8v1/jx6WK0F0JoMdohUeYMH/bhG8EccFBI
         3ZGxGGzVpE5Qzj4d3DAwPHUAlNI9bBGJHk1TXQLgnN1iOoYhYfHAlagoy4ao0MVC3j5d
         8OK6GQUf74yd4sXeIe3mkmCpYaw5NWVrMqjhutOQMqIudrRgItGHfS7gWaMu3Ha+OnK6
         Kl6w==
X-Gm-Message-State: AOAM532Tg1aj2nb8I+UJgRxYKULz00nA5lLOgzPJwAna9t8N3XhxbyTG
        RHc8moDMMcrtWrywB9bytKE+K1dAPbAy
X-Google-Smtp-Source: ABdhPJxZYBj5d6Y3LMHEM3sJYF1vZiit2LYPuivKQ2bYcfXctD29KtYKFYfBCJ73oJK4dcamA2uzk9X7jUZ4
X-Received: by 2002:a0c:fdc5:: with SMTP id g5mr21126498qvs.125.1593535775630;
 Tue, 30 Jun 2020 09:49:35 -0700 (PDT)
Date:   Tue, 30 Jun 2020 09:49:33 -0700
Message-Id: <20200630164933.2571340-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next v2] tcp: call tcp_ack_tstamp() when not fully acked
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb is coalesced tcp_ack_tstamp() still needs to be called when not
fully acked in tcp_clean_rtx_queue(), otherwise SCM_TSTAMP_ACK
timestamps may never be fired. Since the original patch series had
dependent commits, this patch fixes the issue instead of reverting by
restoring calls to tcp_ack_tstamp() when skb is not fully acked.

Fixes: fdb7eb21ddd3 ("tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue()")
Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8479b84f0a7f..12c26c9565b7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3172,8 +3172,11 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 	if (likely(between(tp->snd_up, prior_snd_una, tp->snd_una)))
 		tp->snd_up = tp->snd_una;
 
-	if (skb && (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
-		flag |= FLAG_SACK_RENEGING;
+	if (skb) {
+		tcp_ack_tstamp(sk, skb, prior_snd_una);
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
+			flag |= FLAG_SACK_RENEGING;
+	}
 
 	if (likely(first_ackt) && !(flag & FLAG_RETRANS_DATA_ACKED)) {
 		seq_rtt_us = tcp_stamp_us_delta(tp->tcp_mstamp, first_ackt);
-- 
2.27.0.212.ge8ba1cc988-goog

