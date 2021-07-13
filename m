Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9233C68A7
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhGMCvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhGMCvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:51:41 -0400
X-Greylist: delayed 50121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Jul 2021 19:48:52 PDT
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A27C0613DD;
        Mon, 12 Jul 2021 19:48:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626144530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lStPFj8qvcgCwMoBQwKRWxIuDXA8OI5V+DDbWuXsQ9U=;
        b=XzYsqY3+/nv4P9vUmEQymCL4lGnzA57LHW8zpl3Y/doBSkAOzY76fsHZI/0sWM0RM1R3vT
        UdN99HvXA36JVXmUCg+Y1B2VrO25234DF61j2zoglEoKOff1WtkkXb2y7hxp9WbQJnzauq
        OHM95gDhuL1iftdz9mXvLYFoGRoECnA=
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
Subject: [PATCH v2] net: Use nlmsg_unicast() instead of netlink_unicast()
Date:   Tue, 13 Jul 2021 10:48:24 +0800
Message-Id: <20210713024824.14359-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has 'if (err >0 )' statement in nlmsg_unicast(), so use nlmsg_unicast()
instead of netlink_unicast(), this looks more concise.

v2: remove the change in netfilter.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/fib_frontend.c  | 2 +-
 net/ipv4/inet_diag.c     | 5 +----
 net/ipv4/raw_diag.c      | 7 ++-----
 net/ipv4/udp_diag.c      | 6 ++----
 net/mptcp/mptcp_diag.c   | 6 ++----
 net/netlink/af_netlink.c | 2 +-
 net/sctp/diag.c          | 6 ++----
 net/unix/diag.c          | 6 ++----
 8 files changed, 13 insertions(+), 27 deletions(-)

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

