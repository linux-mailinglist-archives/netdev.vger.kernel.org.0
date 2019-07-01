Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C99B5BD1D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfGANjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:39:41 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:56004 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfGANjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 09:39:41 -0400
Received: by mail-qk1-f201.google.com with SMTP id p206so13500951qke.22
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 06:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jPVZgmTTH75o91jmwljS8Jl8n4BWs6DsaQwyGo5tBKo=;
        b=MYY8f0cSnnp1lhQAmFCNaVXsxwFAygOxQu1N88j+KydOWnfYg3II8+9e+JGjSgY1bm
         8GCwdTy7/yKRJTDxQ/qTZAyISKucUdXCxRxmjyAPN4cJV9CQLtULXEC3l8h9A43ZLuK4
         KlxtQqnmItJCbWdN+ZA9C720B83PxonwqB3M35mlMdaQH4tYu5ht4iS+sAUySvdBzN3H
         VJncI9CKUPJ+ne9MP9dyCZ+PDmwZnVhO5QlFTcsvRDYjxCk9tQOTf/P9R9w+JQPpCRbt
         APiT0ArboflRPOn7v9nFKJ2xMLDJkhGLKwTP7QUCMTItNYiwZNEI5UEYzHX5Z/AvyQnS
         T4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jPVZgmTTH75o91jmwljS8Jl8n4BWs6DsaQwyGo5tBKo=;
        b=XIdwmcd5BvC7DHgOT6iPcIkOsmwkPc+zqplKKjfh44k8S1wtS8dhTt2iWUqyRk8WXx
         sOkdQcmD6nAl1AWNw3SKH1QGQX8MtcDclwC+tXaOKXvy+XwzFU6KjElAmEKwr3Uf+JiN
         Dxm+7Z3FkJlzahWeOvmDVOOQsblp/8lJXrM6TPIk0GiUSxBLvxCE64FQE5bSZsN3dml+
         Bdu9z4WoLNq7o4m2LQsB8gB+85kTnda3ET6ROGCBTG0CWcdCYH02OUF1+lOP/3C/mz4p
         czSWphmwgnB6r3XPBViqRbdh4+59jGH0G+kVDCJP9NAIz0J75IuiziAd63i/ADKAJk9W
         X4mw==
X-Gm-Message-State: APjAAAVtp+MhJYKe6ITiZakyxJn4bUPC7B/C3E5Ke47bcAbDOXhpVWps
        5/AnKgtQ8vhOzjhwXt6TG5rHlCX9Jw4B/Q==
X-Google-Smtp-Source: APXvYqyBkw3pfj0KI2cdEJ0byawFc3i9y2TFba6OZJHb6rYNXuMiGzlJ4QRrSD49Rjv7g13BObzv09Vu9t/p1Q==
X-Received: by 2002:aed:3ed5:: with SMTP id o21mr20631121qtf.369.1561988380222;
 Mon, 01 Jul 2019 06:39:40 -0700 (PDT)
Date:   Mon,  1 Jul 2019 06:39:36 -0700
Message-Id: <20190701133936.15238-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next] ipv6: icmp: allow flowlabel reflection in echo replies
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

Extend flowlabel_reflect bitmask to allow conditional
reflection of incoming flowlabels in echo replies.

Note this has precedence against auto flowlabels.

Add flowlabel_reflect enum to replace hard coded
values.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.txt | 4 +++-
 include/net/ipv6.h                     | 7 +++++++
 net/ipv6/af_inet6.c                    | 2 +-
 net/ipv6/icmp.c                        | 3 +++
 net/ipv6/sysctl_net_ipv6.c             | 4 ++--
 net/ipv6/tcp_ipv6.c                    | 2 +-
 6 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index e0d8a96e2c671e3d09d234c8ed49799b08240259..f0e6d1f53485d6cbfcd73c9cd079b970d976b6d9 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1452,7 +1452,7 @@ flowlabel_reflect - INTEGER
 	environments. See RFC 7690 and:
 	https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
 
-	This is a mask of two bits.
+	This is a bitmask.
 	1: enabled for established flows
 
 	Note that this prevents automatic flowlabel changes, as done
@@ -1463,6 +1463,8 @@ flowlabel_reflect - INTEGER
 	If set, a RST packet sent in response to a SYN packet on a closed
 	port will reflect the incoming flow label.
 
+	4: enabled for ICMPv6 echo reply messages.
+
 	Default: 0
 
 fib_multipath_hash_policy - INTEGER
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index b41f6a0fa903e9916e293f86f8bfb0f264161e80..8eca5fb30376f3a0a40ff0dc438cbad9ff56142a 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -301,6 +301,13 @@ struct ipv6_txoptions {
 	/* Option buffer, as read by IPV6_PKTOPTIONS, starts here. */
 };
 
+/* flowlabel_reflect sysctl values */
+enum flowlabel_reflect {
+	FLOWLABEL_REFLECT_ESTABLISHED		= 1,
+	FLOWLABEL_REFLECT_TCP_RESET		= 2,
+	FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES	= 4,
+};
+
 struct ip6_flowlabel {
 	struct ip6_flowlabel __rcu *next;
 	__be32			label;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7382a927d1eb74a6bbf4d5f83de336ccab5a2ae2..8369af32cef619b5d8fd2fcfaeb12924941d4ae8 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -208,7 +208,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->mc_loop	= 1;
 	np->mc_all	= 1;
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
-	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & 1;
+	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ESTABLISHED;
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
 
 	/* Init the ipv4 part of the socket since we can have sockets
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 12906301ec7baedcccfba224b93d30cb6060c3b9..62c997201970a664cbcfd526d426af07ae019b0e 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -703,6 +703,9 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
 
 	memset(&fl6, 0, sizeof(fl6));
+	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
+		fl6.flowlabel = ip6_flowlabel(ipv6_hdr(skb));
+
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	if (saddr)
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 6d86fac472e7298cbd8df7aa0b190cf0087675e2..8b3fe81783ed945e2f9172fd9008f48fed474475 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,7 +23,7 @@
 
 static int zero;
 static int one = 1;
-static int three = 3;
+static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_min;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 
@@ -116,7 +116,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
-		.extra2		= &three,
+		.extra2		= &flowlabel_reflect_max,
 	},
 	{
 		.procname	= "max_dst_opts_number",
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 408d9ec2697154e840a26675765e8a9c1636ada4..4f3f99b3982099b3c64669f0445bc68d27390c89 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -989,7 +989,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_TIME_WAIT)
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
 	} else {
-		if (net->ipv6.sysctl.flowlabel_reflect & 2)
+		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
 			label = ip6_flowlabel(ipv6h);
 	}
 
-- 
2.22.0.410.gd8fdbe21b5-goog

