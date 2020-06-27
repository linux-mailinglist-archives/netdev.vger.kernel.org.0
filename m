Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3C20BE0B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgF0EGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgF0EGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 00:06:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C473FC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b14so5518728ybq.3
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SIMon8ym3NGiIuenBYzlB8XmYzXAJxZpMpE2/6caaCE=;
        b=vyz7w2yfwCIfJyFBU5B/5GxmP5XG2dt8GMNRoKpCPlqmrHSnUiMigjI147tWVar2rR
         78K9lmQPF1UrIcXHEHCL8uPjU4WQQpC4Bo5T4Rw7z7OLtDRJBMBwe7MucZmdAOfqgrow
         qmVjgdDXumwzND/JDhYEiHjtdPxf98w42RrRyp/WiYgyTY6HBdAzQRGxUTEOSVWW9fUz
         mDiPHBAxi+zmm54gJ4Fuuvugnz4y39ZcC+/SB7jJ7bIkeKUl4wz/63EAkQudq1eF+JXt
         knmLdh4ICnpxxHvP54OzNHmM0/jD2dQcqDiOmg0ZJJjN4yfrbBvf0G0HARPRB4Vr9O5/
         jcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SIMon8ym3NGiIuenBYzlB8XmYzXAJxZpMpE2/6caaCE=;
        b=VKguL15kN9695RAWCL5hYTvEguEXj5Ozhzk6gKgsyOZY/faJ6xicmDXAX9gL1WD/If
         o9am3Av5zPgkhCohYQrzeptvkYd0zo/HOqRSMoimKJI9TJT5a5Kv9/3sFKCuOv+jgM67
         s12JMJieQTux0QIEG4xyWtzJEqL97F/SxN59YpkvB2BFUEpHEaCtqxEyv7LRj3gJ0Vqw
         5qd0rhthWlPwIlbyjBf7ELpTbKeSvk6RRpPXljRY0QkCFGjcMqdotxHegUTciH8OCq4T
         noQt9ZiTx29XPQ8RrnPgZ/iZeULETkeF7q8WvKdkW1+v2tQbfs/jV4L/iu9tVPNt+INh
         qHYw==
X-Gm-Message-State: AOAM533Szg8jIJ+nWvAZxjzhS5s9kJKlNqU3NhbGviTSZqJHNFTUmAVC
        VWZDfqhU7bUK3dLsAjZemeqOmrZC7QEj
X-Google-Smtp-Source: ABdhPJwZNkYCP5Ey9tlB4N2xw/8k5bu8ypDpb9OCdhbZg//tkIGRxSnsgdbw01FHmmQVgqJvGg9915MW2HqZ
X-Received: by 2002:a25:5d5:: with SMTP id 204mr9652931ybf.24.1593230759061;
 Fri, 26 Jun 2020 21:05:59 -0700 (PDT)
Date:   Fri, 26 Jun 2020 21:05:34 -0700
In-Reply-To: <20200627040535.858564-1-ysseung@google.com>
Message-Id: <20200627040535.858564-4-ysseung@google.com>
Mime-Version: 1.0
References: <20200627040535.858564-1-ysseung@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next 3/4] tcp: count sacked packets in tcp_sacktag_state
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

Add sack_delivered to tcp_sacktag_state and count the number of sacked
and dsacked packets. This is pure refactor for future patches to improve
tracking delivered counts.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 09bed29e3ef4..db61ea597e39 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1138,6 +1138,7 @@ struct tcp_sacktag_state {
 	struct rate_sample *rate;
 	int	flag;
 	unsigned int mss_now;
+	u32	sack_delivered;
 };
 
 /* Check if skb is fully within the SACK block. In presence of GSO skbs,
@@ -1259,6 +1260,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 		state->flag |= FLAG_DATA_SACKED;
 		tp->sacked_out += pcount;
 		tp->delivered += pcount;  /* Out-of-order packets delivered */
+		state->sack_delivered += pcount;
 
 		/* Lost marker hint past SACKed? Tweak RFC3517 cnt */
 		if (tp->lost_skb_hint &&
@@ -1685,6 +1687,7 @@ tcp_sacktag_write_queue(struct sock *sk, const struct sk_buff *ack_skb,
 	if (found_dup_sack) {
 		state->flag |= FLAG_DSACKING_ACK;
 		tp->delivered++; /* A spurious retransmission is delivered */
+		state->sack_delivered++;
 	}
 
 	/* Eliminate too old ACKs, but take into
@@ -3586,6 +3589,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 
 	sack_state.first_sackt = 0;
 	sack_state.rate = &rs;
+	sack_state.sack_delivered = 0;
 
 	/* We very likely will need to access rtx queue. */
 	prefetch(sk->tcp_rtx_queue.rb_node);
-- 
2.27.0.212.ge8ba1cc988-goog

