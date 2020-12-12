Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9771A2D89FC
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407884AbgLLUcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407876AbgLLUcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 15:32:07 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BE5C0613CF;
        Sat, 12 Dec 2020 12:31:27 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s21so9393073pfu.13;
        Sat, 12 Dec 2020 12:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=IzEAYkh03L4RJV+eNaKmSQRncB77N7LYk5SfdKse3fI=;
        b=ZF3yP54FvIw5kwV1lVzKvRVjx0SBZ8UxRkkSJ5N8lANWUuVjy96KgaHN4MlILjMKrX
         66jYfHMXidKleASQq7bv2O/GFr02HBDKGlRYyefWl0ruDFaYV9sD/BsRvh/z5q79Gffa
         +aQcW3g+0t5VW63yByUmkfs4LyEPFompD5C/A3+ZTiVs6IBSY+JTH9MsZK64TRWn8V2/
         JUVoHZhfyq20l8QMTdRyKJq71JrYjwSAF0YkReUsICAYebaR+E3+8h5WUIdJJjDgQore
         jQ9iqMugptIfEVMO5pJYqln+VX58ynjMduvwALfYUsRSGijlEv9IxD8hxqtQ27D0QG/k
         iGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=IzEAYkh03L4RJV+eNaKmSQRncB77N7LYk5SfdKse3fI=;
        b=E9sbumUc9HO+LPCwnqGxkTKM6q9pU0PEPn2c0+AqAPUwQkbkfeXlShsrcLti2UkqD1
         FD1776+STAD3BR9x0/f4raSR2BbjS281cCXAWbWHLrnUlC9P/SY7lGE7E09LVSHrDPf9
         L6vsoiivlnV7v2Gz1a68gf0mbCiUvC9GOXPsXWjeyC+WdA3MDlccwA3YPsPFIbQMoO/P
         lLoUaopWMMR5H/bz6b29HWsdVXKpKTDSfQ60qB8SUHGw80fZCVUZw8Uy3MPE8qBpC6eG
         /DyRdA7YQEgMtimpntUgia7kCLIJKrtMpJ9KOX/d+SN9TSEamvGOhT+Caq/qC649OVG7
         Z+Rg==
X-Gm-Message-State: AOAM533zuykgUXBvLXjqKoGgCavAj8Z5/T/0R+mXmR4kJxDgD2BQjGnk
        3lQ8JPRaTAsJx7YzNLTKOHgLlqeJJUz2aw==
X-Google-Smtp-Source: ABdhPJw/DenBaH6N/mzl9k6y/CjraD0mkrf6xEs+0PAJRlLRqYw2UAc2uNKr8MzELBk9ga/x3NWEfw==
X-Received: by 2002:aa7:9429:0:b029:197:f974:c989 with SMTP id y9-20020aa794290000b0290197f974c989mr17497471pfo.30.1607805086170;
        Sat, 12 Dec 2020 12:31:26 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id i16sm14944376pfr.183.2020.12.12.12.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 12:31:25 -0800 (PST)
Subject: [net-next PATCH v3] tcp: Add logic to check for SYN w/ data in
 tcp_simple_retransmit
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        ycheng@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        kernel-team@fb.com
Date:   Sat, 12 Dec 2020 12:31:24 -0800
Message-ID: <160780498125.3272.15437756269539236825.stgit@localhost.localdomain>
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

In order to resolve this we can reduce the MSS the packets are compared
to in tcp_simple_retransmit to -1 for cases where we are still in the
TCP_SYN_SENT state for a fastopen socket. Doing this we will mark all of
the packets related to the fastopen SYN as lost.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---

v2: Changed logic to invalidate all retransmit queue frames if fastopen SYN
v3: Updated commit message to reflect actual solution in 3rd paragraph

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


