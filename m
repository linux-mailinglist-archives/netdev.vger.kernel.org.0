Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D624548897E
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiAINJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiAINJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:09:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D140C06173F;
        Sun,  9 Jan 2022 05:09:02 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i30so8970302pgl.0;
        Sun, 09 Jan 2022 05:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=arpw+ljAljq5NB0O7Qtm3OVFeIt6QFUH4U9kJ3gcQts=;
        b=cLqToY/ebl6ZpwjWFuu1/yKSspKy6/p+fsr5CU2YMQV2/FMU+3Lx/FXV16Y89jXLNy
         LUqXghbIXQLP7ZOH7K5yWivB7ZfS069TY5RiTordnZ9vLVNAJolXUjeNyhl5X2gWmLFN
         kwYKsQOncpXzp4YKPcCv8cJcTPOiq4H9PYMLj8HVqMZpnKAxccJBvrlVVR5d3J2SFPK2
         +IMbTDJSpJSq9l5AL5FVsbV9COsfinCJdixjtMT8bS0jJV3uTCK9HF+KbewPey7bwTAa
         Iyby5AOlsaA08lU28GydpnfboK0+bMruWOEz9FQj8oMECRK3lerBMYgLhWIMSKHj649b
         X43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=arpw+ljAljq5NB0O7Qtm3OVFeIt6QFUH4U9kJ3gcQts=;
        b=8HnCBKGfKOp06ug471/olUAPp+CT/aMogMiEGTh3PUcQoMwdTSQ1W6ekcCgrj5WIFc
         b8UEjALn8oxVQyBAsA5bIwWQjYFTQdo3XqqwFKF10X27w/+leMe3J2JV+TyKD2N93eP2
         /U5o/1XlbR7ne0Y7C0zMejZWnalSqd9gTjMOvu9AX2LzkYzYfGQw8gV665qYvtXVU/Nu
         WjbdoTHAd4eswtHW+jtZC5flWPAN+Iui1v2SCceIHZhRRi1HrD7wQsepAZggyxQ64qZh
         h7qZswpq27sBJIkoqayc65I3jm/MiPB2RZG//NDo4HWIUMmYd+jaUXV48b0UPFC+Ba9/
         HJAQ==
X-Gm-Message-State: AOAM531lg2vw+OoNKOkpsYKzlD/51MhViAJUoBQQnFz78Eo77VDFMqoI
        zx3nHcL43rtmYa+J5McLtEI=
X-Google-Smtp-Source: ABdhPJw90YE57koiEht2HXw4VLhAqSoeHWpus+R0aMIn9BFDmU+7vYicDfVziCgfUteaK2KnKKNRAg==
X-Received: by 2002:a63:b905:: with SMTP id z5mr46556966pge.245.1641733741931;
        Sun, 09 Jan 2022 05:09:01 -0800 (PST)
Received: from fedora.. ([101.229.48.173])
        by smtp.gmail.com with ESMTPSA id r26sm1157020pgu.65.2022.01.09.05.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 05:09:01 -0800 (PST)
From:   Benjamin Yim <yan2228598786@gmail.com>
To:     kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Yim <yan2228598786@gmail.com>
Subject: [PATCH] tcp: tcp_send_challenge_ack delete useless param `skb`
Date:   Sun,  9 Jan 2022 21:08:24 +0800
Message-Id: <20220109130824.2776-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After this parameter is passed in, there is no usage, and deleting it will
 not bring any impact.

Signed-off-by: Benjamin Yim <yan2228598786@gmail.com>
---
 net/ipv4/tcp_input.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8010583f868b..dc49a3d551eb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3601,7 +3601,7 @@ bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 }
 
 /* RFC 5961 7 [ACK Throttling] */
-static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
+static void tcp_send_challenge_ack(struct sock *sk)
 {
 	/* unprotected vars, we dont care of overwrites */
 	static u32 challenge_timestamp;
@@ -3763,7 +3763,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
 		if (before(ack, prior_snd_una - tp->max_window)) {
 			if (!(flag & FLAG_NO_CHALLENGE_ACK))
-				tcp_send_challenge_ack(sk, skb);
+				tcp_send_challenge_ack(sk);
 			return -1;
 		}
 		goto old_ack;
@@ -5726,7 +5726,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			if (tp->syn_fastopen && !tp->data_segs_in &&
 			    sk->sk_state == TCP_ESTABLISHED)
 				tcp_fastopen_active_disable(sk);
-			tcp_send_challenge_ack(sk, skb);
+			tcp_send_challenge_ack(sk);
 		}
 		goto discard;
 	}
@@ -5741,7 +5741,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		if (syn_inerr)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
-		tcp_send_challenge_ack(sk, skb);
+		tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 
@@ -6456,7 +6456,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	if (!acceptable) {
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
-		tcp_send_challenge_ack(sk, skb);
+		tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 	switch (sk->sk_state) {
-- 
2.33.1

