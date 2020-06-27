Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99DE20BE09
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgF0EFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgF0EFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 00:05:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D146C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so11972281ybg.21
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jt6WhDQvdEkiFGmjrJwz7Q0ln/RzE8kaKuWwCPnVjbs=;
        b=RVy7UnNmWWbzdyhzTkaGAunulE0TvtC4UG7u3KGWCWj7ejNb1Qu3O8GKMZKt7NT4tq
         EJjWJ7SGwoXyg9Qpl2mJD9NydOhrl8bOwk6LoRb6Df6adimz/FMsmypTLvVxaWi+6DmF
         sgt10wp2Df5piuVx1yuxSOW8S6PPuhZ0iYc7KQIUOekIL9CedB1TbYolqOiH42hzTBtd
         F5RAO+vlnjEmCT/CP4HUd/cK3q4cevADhAEkShIg1m/yU9DlTeQBDqTn0OQ/CoFrlW0l
         wYiP2P3NYWNiZGKo6PvZhc/sCNBIjye/IvosQVm590Qt49FODFEExyIdoapoQ31MJnHJ
         wKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jt6WhDQvdEkiFGmjrJwz7Q0ln/RzE8kaKuWwCPnVjbs=;
        b=m1eFn7DKZF2ymi0ruykmt2zaHn7G+SzqKW0AzMDpgppXiZ4xkz01RZtV8lyP6LCpWh
         XM8SHacXzczMRtV0tGxdQdsadBFYJCPxfzx/YG53gc5dPkNkgl8//RvH3RSpWs0G66fC
         NI9xSLw7lThlCpd9U0iMI0gNKTMlvGAKnBLm7O35UDhLzmixGrC5AXk1atknOgefJhKu
         mVsxsUQsxsYOxA5KT3GxMHjl3ufguKe7MZBSuBNMQna6WY6vTiwaz4ZgQ83rIAJYzHs4
         IDVRVPFRcs89JiwNepfHu5Em48Y9G6MBbQSi78xHLRV38Vw961bXbc6pPH51Q2W7mz5o
         zwfg==
X-Gm-Message-State: AOAM533eIoPPmoel3ov8jm82WzCg+smHWB2aiXCyP6Lm2LT5XEA+C9q0
        hPl31PngSWAy1wHe+kfrm53sGgm47IJG
X-Google-Smtp-Source: ABdhPJyRKNDpg1p3F46PwWLWaJxm5EuzlfDpr8MrFO4bTK1BqzF04SQcLSnh8Hdg6lOeq+QotRr+LcYyu4Kz
X-Received: by 2002:a25:aaeb:: with SMTP id t98mr10481195ybi.295.1593230754446;
 Fri, 26 Jun 2020 21:05:54 -0700 (PDT)
Date:   Fri, 26 Jun 2020 21:05:32 -0700
In-Reply-To: <20200627040535.858564-1-ysseung@google.com>
Message-Id: <20200627040535.858564-2-ysseung@google.com>
Mime-Version: 1.0
References: <20200627040535.858564-1-ysseung@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next 1/4] tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue()
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tp->delivered is updated with sacked packets but not
cumulatively acked when SCP_TSTAMP_ACK is timestamped. This patch moves
a tcp_ack_tstamp() call in tcp_clean_rtx_queue() to later in the loop so
that when a skb is fully acked OPT_STATS of SCM_TSTAMP_ACK will include
the current skb in the delivered count. When not fully acked
tcp_ack_tstamp() is a no-op and there is no change in behavior.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f3a0eb139b76..2a683e785cca 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3078,8 +3078,6 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		u8 sacked = scb->sacked;
 		u32 acked_pcount;
 
-		tcp_ack_tstamp(sk, skb, prior_snd_una);
-
 		/* Determine how many packets and what bytes were acked, tso and else */
 		if (after(scb->end_seq, tp->snd_una)) {
 			if (tcp_skb_pcount(skb) == 1 ||
@@ -3143,6 +3141,8 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		if (!fully_acked)
 			break;
 
+		tcp_ack_tstamp(sk, skb, prior_snd_una);
+
 		next = skb_rb_next(skb);
 		if (unlikely(skb == tp->retransmit_skb_hint))
 			tp->retransmit_skb_hint = NULL;
-- 
2.27.0.212.ge8ba1cc988-goog

