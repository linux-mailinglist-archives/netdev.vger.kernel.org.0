Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0C82AB932
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgKING7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731186AbgKING6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:06:58 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BC1C0613CF;
        Mon,  9 Nov 2020 05:06:57 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w6so2615058pfu.1;
        Mon, 09 Nov 2020 05:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:date;
        bh=pv/qcPPzxY24BJv/TEpfoqjXaGRaaqqNFfUeBE2/vdI=;
        b=sT3nKO/oUVfm1r6qUVlx1wsZeOwbzS5aKSfpGj0Z7RVxxARSTKPn62yeSyDj5wLZ4r
         SzsJX7bXPAHAnpL87g/XKHuUAW6Ei5n2yfkmx/BKKtY4579berHzvRlUb9LnN4zKCrbo
         eKY5UXRUVP2Ku3N1mNY1fW1es+A8LpekORFMxoxkMYzSSHWWtx1UsvxH8Cy17175XzKo
         SkOsE7Vag79J3/+/ezNwWQH/JCSMCuACPMN1/AM1PYJcK7KhXr1EkJeMXh0yy0gxJQXO
         3L0u4k7SixloDgV1Bfq2ysVFo/plNGRuGz30g7VlQ8J8Dl7qV7VFglCVhf4AvCU5AXjI
         cZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date;
        bh=pv/qcPPzxY24BJv/TEpfoqjXaGRaaqqNFfUeBE2/vdI=;
        b=at32OKK5VyvPKAzwnsn8zJc6LjtKByLCJqx/kEs8HJ0/jfxKXDc2yzTPmHmEJn25+S
         OenZg49uIIhyfKzn/pPH08dbE4rkuchs2duJlWaCF0uKJEEMU8IYdPg8ENPyZ8ZBBYXw
         inBzkUF0hofatl0v1BxJ7iokHMjb5v23NDDRTVdOiG+8/wYfXygLVzmCH5jgCGfxJqkr
         2vX8Yykc8WSdDC6EszHxKwbkbDvSAtPTpW2l3t08FhfRxLhsuQEU68D45W1EvKFnyidV
         tl6LhPPElWCz8328B95y0yVVBC+R20yJ4VtmkLwkiUyd7zsi2XBGuA1m9clG1gVGr+1U
         HFzg==
X-Gm-Message-State: AOAM531q5DKek3vWIbZ/0n9Xcq15LZ3gdM/vUbfv0BHU64x4ciby1b46
        sDr40SMmsGq2OjYWbnfD9U8=
X-Google-Smtp-Source: ABdhPJwD4jwkOUq/fxk5ZZIs+ZhQ+9KL97Y1VfG/9OPmSl6RAtuihPW0tL0U8O5xLmZMdq02ZvvZOA==
X-Received: by 2002:a17:90b:386:: with SMTP id ga6mr3765316pjb.209.1604927217360;
        Mon, 09 Nov 2020 05:06:57 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id t18sm8246920pjs.56.2020.11.09.05.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 05:06:56 -0800 (PST)
Message-ID: <5fa93ef0.1c69fb81.bff98.2afc@mx.google.com>
X-Google-Original-Message-ID: <1604927180-63394-1-git-send-email---global>
From:   menglong8.dong@gmail.com
X-Google-Original-From: --global
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: tcp: ratelimit warnings in tcp_recvmsg
Date:   Mon,  9 Nov 2020 08:06:20 -0500
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

'before(*seq, TCP_SKB_CB(skb)->seq) == true' means that one or more
skbs are lost somehow. Once this happen, it seems that it will
never recover automatically. As a result, a warning will be printed
and a '-EAGAIN' will be returned in non-block mode.

As a general suituation, users call 'poll' on a socket and then receive
skbs with 'recv' in non-block mode. This mode will make every
arriving skb of the socket trigger a warning. Plenty of skbs will cause
high rate of kernel log.

Besides, WARN is for indicating kernel bugs only and should not be
user-triggable. Replace it with 'net_warn_ratelimited' here.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/tcp.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2bc3d7fe9e8..5e38dfd03036 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2093,11 +2093,12 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			/* Now that we have two receive queues this
 			 * shouldn't happen.
 			 */
-			if (WARN(before(*seq, TCP_SKB_CB(skb)->seq),
-				 "TCP recvmsg seq # bug: copied %X, seq %X, rcvnxt %X, fl %X\n",
-				 *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt,
-				 flags))
+			if (unlikely(before(*seq, TCP_SKB_CB(skb)->seq))) {
+				net_warn_ratelimited("TCP recvmsg seq # bug: copied %X, seq %X, rcvnxt %X, fl %X\n",
+						     *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt,
+						     flags);
 				break;
+			}
 
 			offset = *seq - TCP_SKB_CB(skb)->seq;
 			if (unlikely(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)) {
@@ -2108,9 +2109,11 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 				goto found_ok_skb;
 			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 				goto found_fin_ok;
-			WARN(!(flags & MSG_PEEK),
-			     "TCP recvmsg seq # bug 2: copied %X, seq %X, rcvnxt %X, fl %X\n",
-			     *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt, flags);
+
+			if (!(flags & MSG_PEEK))
+				net_warn_ratelimited("TCP recvmsg seq # bug 2: copied %X, seq %X, rcvnxt %X, fl %X\n",
+						     *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt,
+						     flags);
 		}
 
 		/* Well, if we have backlog, try to process it now yet. */
-- 
2.25.1


