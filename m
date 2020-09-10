Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DBF263A4C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgIJCYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbgIJCMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:12:03 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CCCC06136F
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 17:51:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q2so3343170pfc.17
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 17:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BzCqo5xgZBo5lkRUUpl4P1WsfLCH683BsG3jzL/NrGM=;
        b=Gni/co0WqpO+s/m3y9FvhRplSy1+BsWk5adqElUr58DADZInAY7WK+tpTVOyuUB7DX
         A4/lrcASJ/H9rY07YW+UOU3AGyUH32uChIv/YttoVP7kr3m7qse+3TbWQmo+dUD4A11f
         oKTanqAwIbNrShNNIyxfoxFuQ8XFx6MOAJ8bYPmth+uNHPdYIdtU1lUs4SPQVxRvP0fZ
         ZOmCoBgzH+sx8xo9N7qGne3byABD7mnlMiFfJBlH8DDsMo+JFz7K+90/tb7AkUl35Vx7
         dHzqZjxPi5YaGZ0l+BP89xnrR4J/ZYgRSGciK8GoABTl5H4oFnz1oXAWagX52fuYLfgt
         mXKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BzCqo5xgZBo5lkRUUpl4P1WsfLCH683BsG3jzL/NrGM=;
        b=DVBo2Bher4XFTMSojcBl9ecCepR56ROzxiWXA4Gs7EjKzeoeBL4C6KIchBfQuKvg3W
         iDuO929RqWu3mfyqp+tE/2vOva7Z/t43QdUcMiTqMW6X1s/yEpICIvOgo/93Fa3fw7SM
         kEWxpll33b8sPU1P5mjNgQr2Yy9Lpp/V9SkyDHf4bFpse29s9RgkBRhnMf2tEzQbgi/E
         anfRUF9v+jAIfgY/Kxx2zGEX2qCL8eGgz3Kzmub7j3tqvJ0KLeJpxu1Gz+WeXpOUfhg/
         17pW35Jy1r0koOLswXfbifgY0HgXW02WLAcg7byNScZpaKqg3eL4JDcYR9cL6ueQwbpC
         5MNw==
X-Gm-Message-State: AOAM530G1qvRHPgW+JgIL1msRFjCavXbWZwMSsdRfaAZB5gW9pTZd0G/
        c12G90LjF3G8pSpEDmjmHWs3i216J3U=
X-Google-Smtp-Source: ABdhPJz0yds0a/ctKWfOeZ+euQiljkEdGK3NBmqSqwghhWb9ja05AXg4kH7M1ILkJ0pQsHKzDCCowe6gZxs=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a63:43c7:: with SMTP id q190mr2403824pga.6.1599699082703;
 Wed, 09 Sep 2020 17:51:22 -0700 (PDT)
Date:   Wed,  9 Sep 2020 17:50:47 -0700
In-Reply-To: <20200910005048.4146399-1-weiwan@google.com>
Message-Id: <20200910005048.4146399-3-weiwan@google.com>
Mime-Version: 1.0
References: <20200910005048.4146399-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next 2/3] ip: pass tos into ip_build_and_send_pkt()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds tos as a new passed in parameter to
ip_build_and_send_pkt() which will be used in the later commit.
This is a pure restructure and does not have any functional change.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h     | 2 +-
 net/dccp/ipv4.c      | 6 ++++--
 net/ipv4/ip_output.c | 5 +++--
 net/ipv4/tcp_ipv4.c  | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b09c48d862cc..0f72bf8c0cbf 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -151,7 +151,7 @@ int igmp_mc_init(void);
 
 int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 			  __be32 saddr, __be32 daddr,
-			  struct ip_options_rcu *opt);
+			  struct ip_options_rcu *opt, u8 tos);
 int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	   struct net_device *orig_dev);
 void ip_list_rcv(struct list_head *head, struct packet_type *pt,
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index d8f3751a512b..bb3d70664dde 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -495,7 +495,8 @@ static int dccp_v4_send_response(const struct sock *sk, struct request_sock *req
 		rcu_read_lock();
 		err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
 					    ireq->ir_rmt_addr,
-					    rcu_dereference(ireq->ireq_opt));
+					    rcu_dereference(ireq->ireq_opt),
+					    inet_sk(sk)->tos);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
@@ -537,7 +538,8 @@ static void dccp_v4_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	local_bh_disable();
 	bh_lock_sock(ctl_sk);
 	err = ip_build_and_send_pkt(skb, ctl_sk,
-				    rxiph->daddr, rxiph->saddr, NULL);
+				    rxiph->daddr, rxiph->saddr, NULL,
+				    inet_sk(ctl_sk)->tos);
 	bh_unlock_sock(ctl_sk);
 
 	if (net_xmit_eval(err) == 0) {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index b931d0b02e49..5fb536ff51f0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -142,7 +142,8 @@ static inline int ip_select_ttl(struct inet_sock *inet, struct dst_entry *dst)
  *
  */
 int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
-			  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt)
+			  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt,
+			  u8 tos)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct rtable *rt = skb_rtable(skb);
@@ -155,7 +156,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph = ip_hdr(skb);
 	iph->version  = 4;
 	iph->ihl      = 5;
-	iph->tos      = inet->tos;
+	iph->tos      = tos;
 	iph->ttl      = ip_select_ttl(inet, &rt->dst);
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index af27cfa9d8d3..c4c7ad4c8b5a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -985,7 +985,8 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 		rcu_read_lock();
 		err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
 					    ireq->ir_rmt_addr,
-					    rcu_dereference(ireq->ireq_opt));
+					    rcu_dereference(ireq->ireq_opt),
+					    inet_sk(sk)->tos);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
-- 
2.28.0.618.gf4bc123cb7-goog

