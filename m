Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8CBCABF
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbfIXPBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:01:33 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:35030 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388811AbfIXPBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:01:33 -0400
Received: by mail-pf1-f201.google.com with SMTP id r7so1681301pfg.2
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PmOaIoNTQne9rz0hHDbRDL6TH+kYulBoG1++HpZ+0Y4=;
        b=tx6KFrXXcNS53uvE88elAmZ9xGS4PKF1o++aFdsu3GJnz4sRWhE0t85QtMIHwh/Fa1
         mp2xL47atoSg4uN1UnrQbeNfOr3nrf6RaMX+CdJ3swDfjBr8DbsHP2MH4BnbqCQOc7mv
         /faZNdTFCFYwSCjynV/mjt1cE0ArfZ2LK5vgs5jhrFS+T1OXaRiSMl+FFpwMYkOCMmw0
         zPA1gP69J2+FcCNBB0krLBhdOMv64dO89RM6cUSZExMPgDWdseckurgY1wCtzTT1qZw9
         O7ll4UBvm1ZVXKKrTwoBgVo6En2/Wn0MykHSVBs2yt7oFXBLxoDLOdvQIYLlhrKo00ya
         Hz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PmOaIoNTQne9rz0hHDbRDL6TH+kYulBoG1++HpZ+0Y4=;
        b=BfHT5IINx46yowBiDRpllQSR2NyVTgfmY+2Ns2mA/heCZ1ycjf6CLIUNnQcIn65ZbF
         oFlcEMJ5Qw6Ek3AXSP5eUVzXQ5nxu4L3oFRw/2SlAg56DfLu8eSGpAB3/V0IPws9/RB0
         ewqiZ60tS4g0UA+DQ05CUTEsS/CLL9AZQ/Q30NBwY96rNAkhguyNianFXuOPKdpSBN3I
         usAcjcpjq/JPkLb29w4WmmP4T4p6Rldtag14VscY4ZTkYYbSCeUcD914crmVRjSwnqSJ
         zEMzOb1IyA+rk+fsOAsSpAW7jmMPFeKK4GFU/RPrzr8naoX6b+MZiINwn67H+XOCXSu7
         lbdQ==
X-Gm-Message-State: APjAAAX9oaye9UXgUC16D/0VSpeFKHEjWxlJ+9EHGKvdBlw7sITK2Juq
        ssVyRLuuYBEkndqklS1tQKkCKTf5O4ecfA==
X-Google-Smtp-Source: APXvYqxeQE9xFpAy9oeYGE4p0dHOq3lY9YfXTnXZpU0z8Vp8iASwnbO2qukggJ7mMcqxGSyijgYOhjbFyu/pzQ==
X-Received: by 2002:a63:4616:: with SMTP id t22mr3635431pga.123.1569337290592;
 Tue, 24 Sep 2019 08:01:30 -0700 (PDT)
Date:   Tue, 24 Sep 2019 08:01:14 -0700
In-Reply-To: <20190924150116.199028-1-edumazet@google.com>
Message-Id: <20190924150116.199028-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190924150116.199028-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net 1/3] ipv6: add priority parameter to ip6_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ip6_xmit() sets skb->priority based on sk->sk_priority

This is not desirable for TCP since TCP shares the same ctl socket
for a given netns. We want to be able to send RST or ACK packets
with a non zero skb->priority.

This patch has no functional change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h               | 2 +-
 net/dccp/ipv6.c                  | 5 +++--
 net/ipv6/inet6_connection_sock.c | 2 +-
 net/ipv6/ip6_output.c            | 4 ++--
 net/ipv6/tcp_ipv6.c              | 6 ++++--
 net/sctp/ipv6.c                  | 2 +-
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 8dfc65639aa4c4dc10277989cf4bfa03ec161354..009605c56f209040d10f4878353aafa66c1a845f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -981,7 +981,7 @@ int ip6_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
  *	upper-layer output functions
  */
 int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
-	     __u32 mark, struct ipv6_txoptions *opt, int tclass);
+	     __u32 mark, struct ipv6_txoptions *opt, int tclass, u32 priority);
 
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1b7381ff787b388488a8458b6f52760f73a4f22d..25aab672fc9907801f63ff2bd374f6db17fe28d2 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -230,7 +230,8 @@ static int dccp_v6_send_response(const struct sock *sk, struct request_sock *req
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, &fl6, sk->sk_mark, opt, np->tclass);
+		err = ip6_xmit(sk, skb, &fl6, sk->sk_mark, opt, np->tclass,
+			       sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
@@ -284,7 +285,7 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(skb, dst);
-		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0);
+		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0, 0);
 		DCCP_INC_STATS(DCCP_MIB_OUTSEGS);
 		DCCP_INC_STATS(DCCP_MIB_OUTRSTS);
 		return;
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 4da24aa6c696dff6867f876b20805f2dd207e8c5..0a0945a5b30da1647aaf1b9f8b46db69102e8ff8 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -133,7 +133,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 	fl6.daddr = sk->sk_v6_daddr;
 
 	res = ip6_xmit(sk, skb, &fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       np->tclass);
+		       np->tclass,  sk->sk_priority);
 	rcu_read_unlock();
 	return res;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 89a4c7c2e25d01cc2ef18ae9c407f8f3319590d9..edadee4a7e76105f737d705052db8f5bbc6c0152 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -193,7 +193,7 @@ bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
  * which are using proper atomic operations or spinlocks.
  */
 int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
-	     __u32 mark, struct ipv6_txoptions *opt, int tclass)
+	     __u32 mark, struct ipv6_txoptions *opt, int tclass, u32 priority)
 {
 	struct net *net = sock_net(sk);
 	const struct ipv6_pinfo *np = inet6_sk(sk);
@@ -258,7 +258,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	hdr->daddr = *first_hop;
 
 	skb->protocol = htons(ETH_P_IPV6);
-	skb->priority = sk->sk_priority;
+	skb->priority = priority;
 	skb->mark = mark;
 
 	mtu = dst_mtu(dst);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 87f44d3250ee6844777a000760326d6ad6831de6..806064c2886777ad37a1f0b8406aa8bee7945723 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -512,7 +512,8 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass);
+		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass,
+			       sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
@@ -907,7 +908,8 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
-		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass);
+		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass,
+			 0);
 		TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 		if (rst)
 			TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e5f2fc726a983579dddbd201ea5ee5eb371a50ac..dd860fea014843b350fd01108b78b538cb09ecbb 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -215,7 +215,7 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 
 	rcu_read_lock();
 	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       tclass);
+		       tclass, sk->sk_priority);
 	rcu_read_unlock();
 	return res;
 }
-- 
2.23.0.351.gc4317032e6-goog

