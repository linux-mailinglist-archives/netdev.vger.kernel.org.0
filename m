Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1680329897F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1422535AbgJZJjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 05:39:25 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35182 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422458AbgJZJjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:39:24 -0400
Received: by mail-pj1-f68.google.com with SMTP id h4so2798451pjk.0;
        Mon, 26 Oct 2020 02:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EwBk3v+48o6fnUl3pVyjwAHRohkxTAhu7Ru3s/S+zog=;
        b=gbdPCoZAqmjcz9g4LNBSDGr2QroQBOcCJCBm0jntBSHqscSxVrz3jgZdZX5NZQgd5L
         cTRutHgX4hMHSTHQ0W5pA8U7nDZXKW0b4cxYQhH1lhsXn6SjYJeeu5X+P2hQowfWgxw/
         BwGQxo4hESCSdjFPdfHxajP08ZMnelhMSLRrgADvbtZOdDfbpirH89STd7g2/as6wu2c
         OgpznrWTHC4NfHp+g4m9tAxkc+jrYOWgAxvX2N110zHMoXRNMHi6APXXF2k8NCIzhf9V
         wDVwfStnv/Q+XtTTJukeMkKTYj0kzgOgQKFdjN3EUCxpDs9EZvohvHyyPYxBCMioDHsr
         B+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EwBk3v+48o6fnUl3pVyjwAHRohkxTAhu7Ru3s/S+zog=;
        b=gYG/W5WyX9R8XQiIgoNbnaJz3RKDKzR/uSk+RcbdAF0Sf01ir7ssmWCFGGIaQPJ0fQ
         vIgyfsthXkWi2ZxhIYXXsPjkK12s9khSwGJSlOXIeENhzSXkMtWQFi2WtNrlFwG3698a
         VNo4evp57McNVOOsWB831jYGfBqtiM8D1Z7H9A1Rl/wyYZmJ5nIgBzpcZpzI1wRodhNB
         yDiIKl4MW3wDoI2U5EqmBhINqvXMOBvcNK9tsmN0zC/rUEPyosPiOqP44ACFF8/L1+1k
         x5N4V/IoaYQZ52EqfyDKFn5Yz11gZzTyg6IKgJxZ02t19xj4D/aLKSaxRxSq/YtrgBwR
         EVPw==
X-Gm-Message-State: AOAM5333x4cM3XS2Mr1y/67G83fTUcwwFf3oa3Q2a66fkK5BZ+e+/Gzg
        a/NFSC6A1JjNwH98Hz0ozgU=
X-Google-Smtp-Source: ABdhPJxGr5yPTW1aY56+oKuTgBWhT/0xfqyUWnvvR69sFRCKlcIs0WsNPUrKgnWgANk8sg3qgto2NA==
X-Received: by 2002:a17:902:724b:b029:d5:a5e2:51c4 with SMTP id c11-20020a170902724bb02900d5a5e251c4mr9246635pll.80.1603705162249;
        Mon, 26 Oct 2020 02:39:22 -0700 (PDT)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id v24sm10145984pgi.91.2020.10.26.02.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:39:21 -0700 (PDT)
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: udp: increase UDP_MIB_RCVBUFERRORS when ENOBUFS
Date:   Mon, 26 Oct 2020 17:39:07 +0800
Message-Id: <20201026093907.13799-1-menglong8.dong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error returned from __udp_enqueue_schedule_skb is ENOMEM or ENOBUFS.
For now, only ENOMEM is counted into UDP_MIB_RCVBUFERRORS in
__udp_queue_rcv_skb. UDP_MIB_RCVBUFERRORS should count all of the
failed skb because of memory errors during udp receiving, not just
those because of the limit of sock receive queue. We can see this
in __udp4_lib_mcast_deliver:

		nskb = skb_clone(skb, GFP_ATOMIC);

		if (unlikely(!nskb)) {
			atomic_inc(&sk->sk_drops);
			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
					IS_UDPLITE(sk));
			__UDP_INC_STATS(net, UDP_MIB_INERRORS,
					IS_UDPLITE(sk));
			continue;
		}

See, UDP_MIB_RCVBUFERRORS is increased when skb clone failed. From this
point, ENOBUFS from __udp_enqueue_schedule_skb should be counted, too.
It means that the buffer used by all of the UDP sock is to the limit, and
it ought to be counted.

Signed-off-by: Menglong Dong <menglong8.dong@gmail.com>
---
 net/ipv4/udp.c | 4 +---
 net/ipv6/udp.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23d1a01..49a69d8d55b3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2035,9 +2035,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		int is_udplite = IS_UDPLITE(sk);
 
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
-			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
-					is_udplite);
+		UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 		kfree_skb(skb);
 		trace_udp_fail_queue_rcv_skb(rc, sk);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9..d5e23b150fd9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -634,9 +634,7 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		int is_udplite = IS_UDPLITE(sk);
 
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
-			UDP6_INC_STATS(sock_net(sk),
-					 UDP_MIB_RCVBUFERRORS, is_udplite);
+		UDP6_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
 		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 		kfree_skb(skb);
 		return -1;
-- 
2.28.0

