Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA82D89E5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439867AbgLLUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407863AbgLLUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 15:06:38 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1668C0613CF;
        Sat, 12 Dec 2020 12:05:57 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id j26so9017178qtq.8;
        Sat, 12 Dec 2020 12:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=NikLZAMXA6dsXesyJ9crXqoFZuWybuJXmotB1Aiulu8=;
        b=SJlFV34vohHjtVZZX0yXxVp+ULkRvZ1tMlwE+y+DOOI2Mp3oEU4YgizRoomIB6Df6S
         LvCwoEHOENNDP4kAs90QUSGnlQy3VCBcm5jKKAjD4cXjo+i9xdb5QGf6HoAFfmRmBqPl
         JnCCNvO0361TcQKN8xJHYn2QUOb3/N7MxvNb0MZc19Ykc74lFjxzN/2UF5P48dgNEezY
         7CznEJxzNHKzc+yQroEtrf3uKQ+/wEJGZW6KSwhA+FVdsA/P6REzbNfoDrKzd3fW3QUl
         wLAHmJPWjmBJ0Z1Ei6NuxaL3+9WPH+Wbbin9E6+yHmkh447IMGYS93i97WHxymAZf1aI
         sclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=NikLZAMXA6dsXesyJ9crXqoFZuWybuJXmotB1Aiulu8=;
        b=ILVe5itxgbha6wbdHkTk2sJFp4KET0Y2+aFXP94XKgb2CKFQhD2OfGbZ75DC8uKS6A
         Kby3cG6Ohd9q8fTVMn7ZB9lktgGU8ipLQtWvy1y7SSGPOxeM0qLRY/MXjn5rbrCKuayo
         dSbEpU/1OwwOfUK2ZSmbMCpq1z8ns/ZCuEmUjxz74oWPXsqtEiUj1puoQvx01sPu2JPC
         6iS8X0UWZnlHwgKXW4oKn96rKYSJydIqHJFgNunJeCXPxxdnlEUMZAVu3no0Vs75b5cH
         7ivMl10ibCHUqpLh23SP/zDVMq2zmTIwl+br1W+WACszfT9Q4iKV5OwsSekj27qu4oM1
         25lg==
X-Gm-Message-State: AOAM531pOvwFDqbmAdxeJlRISfHjrjm5gZz3ZhAH0Ru9yfXmH7bmxV6t
        sDzlU5xMOwmy+KsMMI4xGgE=
X-Google-Smtp-Source: ABdhPJztoO6Y/Ywtr0NBjXHVW0ojw4+crhO9+t8TqyVsi8KPEpCGbk6RKVULY/sSmkqNt1Zo7rVRmg==
X-Received: by 2002:ac8:7b9d:: with SMTP id p29mr15077917qtu.75.1607803556856;
        Sat, 12 Dec 2020 12:05:56 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h1sm10419236qtr.1.2020.12.12.12.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 12:05:56 -0800 (PST)
Subject: [net-next PATCH v2] tcp: Add logic to check for SYN w/ data in
 tcp_simple_retransmit
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        ycheng@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        kernel-team@fb.com
Date:   Sat, 12 Dec 2020 12:05:53 -0800
Message-ID: <160780355379.2904.733062980589887769.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
message in the case of IPv6 or a fragmentation request in the case of
IPv4. This results in the socket stalling for a second or more as it does
not respond to the message by retransmitting the SYN frame.

Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
makes use of the entire MSS. In the case of fastopen it does, and an
additional complication is that the retransmit queue doesn't contain the
original frames. As a result when tcp_simple_retransmit is called and
walks the list of frames in the queue it may not mark the frames as lost
because both the SYN and the data packet each individually are smaller than
the MSS size after the adjustment. This results in the socket being stalled
until the retransmit timer kicks in and forces the SYN frame out again
without the data attached.

In order to resolve this we can generate our best estimate for the original
packet size by detecting the fastopen SYN frame and then adding the
overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
have exceeded the MSS. If so we can mark the frame as lost and retransmit
it.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_input.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9e8a6c1aa019..e44327a39a1f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2688,7 +2688,22 @@ void tcp_simple_retransmit(struct sock *sk)
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
-	unsigned int mss = tcp_current_mss(sk);
+	int mss;
+
+	/* A fastopen SYN request is stored as two separate packets within
+	 * the retransmit queue, this is done by tcp_send_syn_data().
+	 * As a result simply checking the MSS of the frames in the queue
+	 * will not work for the SYN packet.
+	 *
+	 * Us being here is an indication of a path MTU issue so we can
+	 * assume that the fastopen SYN was lost and just mark all the
+	 * frames in the retransmit queue as lost. We will use an MSS of
+	 * -1 to mark all frames as lost, otherwise compute the current MSS.
+	 */
+	if (tp->syn_data && sk->sk_state == TCP_SYN_SENT)
+		mss = -1;
+	else
+		mss = tcp_current_mss(sk);
 
 	skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
 		if (tcp_skb_seglen(skb) > mss)


