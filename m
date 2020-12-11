Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233F92D6DCA
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 02:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391411AbgLKB4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 20:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391228AbgLKB4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:56:02 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE7DC0613CF;
        Thu, 10 Dec 2020 17:55:22 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id w79so7104015qkb.5;
        Thu, 10 Dec 2020 17:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=h+3wXg9zxjblejETrBdin05cHUgj1s4ON1XU54bbcbU=;
        b=KsXaodLIP7h9ZZ3X6GDt0C87ob6rockdy593G+gaDRk7maUKa9Gcro6ln5yo+Agb0c
         ZM0iPJ5zg8MDtDu1Q+FjTA4uTd1ooabndlRsBEBsKrZZSjpOjXi8q8AkdUag+glajAXE
         FUazOhRpMjxIxY37P803gujRkeS8NPoVmbQnxTEn9lPz5uLApCThQWOuOULYWJkU6fBL
         SXMM3jtdXp+zP1wMPUG6+/QG/IRb/QX21iIT9d4r5bXHpTKneHFFlxFvv4zaf2XDuxRN
         ED3PK16co74QZtsAQhxAhhxM9dBLrDWBF0RuwPs4fRQvw6XL9xEWkucE3izxKeAx1fvU
         RqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=h+3wXg9zxjblejETrBdin05cHUgj1s4ON1XU54bbcbU=;
        b=rYm2S0n+6KV+EaMFySyrTymycna5KIN0q/ZFY4QBwlT+bj4Qe+9kCEPkcaVkSLQTi2
         ZDxQ6Yxv2CCsSJbpsDJ9EVAFtL7kOz8emGNYWibFovhyEgNhVrcKSR9bs+FNmJ+KdZ7p
         85kzWJyUPezHdgwxslKCqXUiFBRVPiKTS8eASgFxHtHC7U/KGBxivRokodLKUCFclUK5
         UOtLT0Yq54bVOszoj/bgkhMxAdAahZ846z8TmyQiHYv3PJbBbsX04MK38Rip/cjTLz5z
         O00NFODBW9ocdCDMf1cjbiQqyeU/vyuMDuRblauMEY91IKRHtYx7StOZeeRpQQrKzCU6
         e2hg==
X-Gm-Message-State: AOAM5326+Z2hdAdw/ixlrN0WDoJK9GnbmH4EJ/ZNdI9R5ESrL0tyrz2U
        trlyj4lhSJZaykXVmXCfRWk=
X-Google-Smtp-Source: ABdhPJxFaGjwRBKky7QcXxQQO3pJYSGuaWbWN2HTL0a0FaLp5y7eYWbLUdxzk+Tbks5Drqho7GtLxg==
X-Received: by 2002:a05:620a:140c:: with SMTP id d12mr13192787qkj.340.1607651721740;
        Thu, 10 Dec 2020 17:55:21 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id m8sm5643996qkn.41.2020.12.10.17.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 17:55:21 -0800 (PST)
Subject: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving
 ICMP_TOOBIG/ICMP_FRAG_NEEDED
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        kernel-team@fb.com
Date:   Thu, 10 Dec 2020 17:55:19 -0800
Message-ID: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

In the case of a fastopen SYN there are cases where it may trigger either a
ICMP_TOOBIG message in the case of IPv6 or a fragmentation request in the
case of IPv4. This results in the socket stalling for a second or more as
it does not respond to the message by retransmitting the SYN frame.

Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
makes use of the entire MTU. In the case of fastopen it does, and an
additional complication is that the retransmit queue doesn't contain the
original frames. As a result when tcp_simple_retransmit is called and
walks the list of frames in the queue it may not mark the frames as lost
because both the SYN and the data packet each individually are smaller than
the MSS size after the adjustment. This results in the socket being stalled
until the retransmit timer kicks in and forces the SYN frame out again
without the data attached.

In order to resolve this we need to mark the SYN frame as lost if it is the
first packet in the queue. Doing this allows the socket to recover much
more quickly without the retransmit timeout stall.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/net/tcp.h    |    1 +
 net/ipv4/tcp_input.c |    8 ++++++++
 net/ipv4/tcp_ipv4.c  |    6 ++++++
 net/ipv6/tcp_ipv6.c  |    4 ++++
 4 files changed, 19 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d4ef5bf94168..6181ad98727a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2062,6 +2062,7 @@ void tcp_init(void);
 
 /* tcp_recovery.c */
 void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb);
+void tcp_mark_syn_lost(struct sock *sk);
 void tcp_newreno_mark_lost(struct sock *sk, bool snd_una_advanced);
 extern s32 tcp_rack_skb_timeout(struct tcp_sock *tp, struct sk_buff *skb,
 				u32 reo_wnd);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 389d1b340248..d0c5248bc4e1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1066,6 +1066,14 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+void tcp_mark_syn_lost(struct sock *sk)
+{
+	struct sk_buff *skb = tcp_rtx_queue_head(sk);
+
+	if (skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
+		tcp_mark_skb_lost(sk, skb);
+}
+
 /* Updates the delivered and delivered_ce counts */
 static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
 				bool ece_ack)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8391aa29e7a4..ad62fe029646 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -546,6 +546,12 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 			if (sk->sk_state == TCP_LISTEN)
 				goto out;
 
+			/* fastopen SYN may have triggered the fragmentation
+			 * request. Mark the SYN or SYN/ACK as lost.
+			 */
+			if (sk->sk_state == TCP_SYN_SENT)
+				tcp_mark_syn_lost(sk);
+
 			tp->mtu_info = info;
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 992cbf3eb9e3..d7b1346863e3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -443,6 +443,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
+		/* fastopen SYN may have triggered TOOBIG, mark it lost. */
+		if (sk->sk_state == TCP_SYN_SENT)
+			tcp_mark_syn_lost(sk);
+
 		tp->mtu_info = ntohl(info);
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);


