Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988513C5CA8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhGLM4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:56:22 -0400
Received: from out0.migadu.com ([94.23.1.103]:20253 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhGLM4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:56:21 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626094409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nLeorn7JAX1a2d/hq7DI3yYWcR2plTGaxbLKNq9l55M=;
        b=W7corV9zVpilvj/nQG0SESgZO3fyTjFe1Ob5uoNvC+WH/f9RP6k1dKiGaiJDNAQb2BIMr+
        j1maKRLZOvrqQYEOUd7SYNueYLRtciS9LAfQc6WBcUq2PQfBfnaAF6HuvoPX7m7U8AAd4H
        RKforoo6ouQvMKOBE6sa7n38iimfQtI=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        johannes.berg@intel.com, ast@kernel.org, yhs@fb.com,
        0x7f454c46@gmail.com, yajun.deng@linux.dev, aahringo@redhat.com,
        rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mptcp@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org
Subject: [PATCH] net: Use nlmsg_unicast() instead of netlink_unicast()
Date:   Mon, 12 Jul 2021 20:53:01 +0800
Message-Id: <20210712125301.14248-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has 'if (err >0 )' in nlmsg_unicast(), so use nlmsg_unicast()
instead of netlink_unicast(), this looks more concise.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/fib_frontend.c    | 2 +-
 net/ipv4/inet_diag.c       | 5 +----
 net/ipv4/raw_diag.c        | 7 ++-----
 net/ipv4/udp_diag.c        | 6 ++----
 net/mptcp/mptcp_diag.c     | 6 ++----
 net/netfilter/nft_compat.c | 6 ++----
 net/netlink/af_netlink.c   | 2 +-
 net/sctp/diag.c            | 6 ++----
 net/unix/diag.c            | 6 ++----
 9 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index a933bd6345b1..9fe13e4f5d08 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1376,7 +1376,7 @@ static void nl_fib_input(struct sk_buff *skb)
 	portid = NETLINK_CB(skb).portid;      /* netlink portid */
 	NETLINK_CB(skb).portid = 0;        /* from kernel */
 	NETLINK_CB(skb).dst_group = 0;  /* unicast */
-	netlink_unicast(net->ipv4.fibnl, skb, portid, MSG_DONTWAIT);
+	nlmsg_unicast(net->ipv4.fibnl, skb, portid);
 }
 
 static int __net_init nl_fib_lookup_init(struct net *net)
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e65f4ef024a4..ef7897226f08 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -580,10 +580,7 @@ int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
 		nlmsg_free(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 
 out:
 	if (sk)
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 1b5b8af27aaf..ccacbde30a2c 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -119,11 +119,8 @@ static int raw_diag_dump_one(struct netlink_callback *cb,
 		return err;
 	}
 
-	err = netlink_unicast(net->diag_nlsk, rep,
-			      NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 	return err;
 }
 
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index b2cee9a307d4..1ed8c4d78e5c 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -77,10 +77,8 @@ static int udp_dump_one(struct udp_table *tbl,
 		kfree_skb(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	if (sk)
 		sock_put(sk);
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 8f88ddeab6a2..f48eb6315bbb 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -57,10 +57,8 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 		kfree_skb(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	sock_put(sk);
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 639c337c885b..aa3397eec330 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -683,10 +683,8 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
+	ret = nlmsg_unicast(info->sk, skb2, NETLINK_CB(skb).portid);
+
 out_put:
 	rcu_read_lock();
 	module_put(THIS_MODULE);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d233ac4a91b6..380f95aacdec 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2471,7 +2471,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	nlmsg_end(skb, rep);
 
-	netlink_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid, MSG_DONTWAIT);
+	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
 }
 EXPORT_SYMBOL(netlink_ack);
 
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 493fc01e5d2b..760b367644c1 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -284,10 +284,8 @@ static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
 		goto out;
 	}
 
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	return err;
 }
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 9ff64f9df1f3..7e7d7f45685a 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -295,10 +295,8 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 
 		goto again;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	if (sk)
 		sock_put(sk);
-- 
2.32.0

