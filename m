Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D683482622
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 00:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhLaXhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 18:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhLaXhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 18:37:48 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C138C061574;
        Fri, 31 Dec 2021 15:37:48 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso18764388pje.0;
        Fri, 31 Dec 2021 15:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+Kc/UYgK6oTjcvVvGgDkY/jZEZZ3r0f0THb7EUT3Fg=;
        b=Qv4cgel8JElkHJRkFGcwE4+dUE22sQ618eA+6zR3gszp3FeqEuLmLvkzlVp6rdx8Ug
         psJO2uAqhElGWpDAjHG82XnOHEH0pVtuFaqzSm0GhiAmiVpoJcihIlaIeUuiAzWW+8W9
         V7tObgVZZlNdvikJ2mbFoIaW2b3S+gXw51o7oz45Zimx5kBhwBixduQPzatiegUwN6x1
         ZHr9Fhp4bZEeD/+3uH+g7n0j0w1mpx57uMzjqsWSsqzk4aGDoUjKKOCydzyWyFRti8+n
         cepLE+r3QGQBBqwG1kDs5wO8hJD1hnxiQ3s0xCywBGUioL/Fwd1VXfIYBDpPcU4FeUfA
         1+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+Kc/UYgK6oTjcvVvGgDkY/jZEZZ3r0f0THb7EUT3Fg=;
        b=dMBg55iWbsaZ7ZZT/qVNFK30gG//D7SebLizuHxsduU5xGkb1pCrhQgd4E5C24EWiJ
         01YWj6mNwQNnA9wNXZGbBJOy6J//NWxxlUewQ27eLGDlLmk+3W5+fvV8OrLxYmsymOr/
         QSuZG5rx+gooc23/CcGJfpPQvCrWxuksi+eH+pWtZ9O0x5Ce4XRhZ8cne6ihIaXJB9gu
         f9YPbdEV6la0EsJYWt49hb4xzIOxTyoG7TdaYPIG9aUbCAkkV0+mVMjZuLpWgcUMW7sE
         eAKZ8jZYRsUN3YUxEMN0H5WKE6OGa0qCj3ge+CA7/Q0DGJKFY4mpPRdWb38z1AVLIbSY
         IpIQ==
X-Gm-Message-State: AOAM531ZXeIp1+6LRsTk4RdC5+tM9w6DSJCF4YQGSx0rGQYuPQMkqc6U
        F0G1PwLKa5RcrIstGXJRi4M7Vos75KhM2Q==
X-Google-Smtp-Source: ABdhPJzhtEAb/SZefHB9TSS8LnCV50TKOwQUUyMSvCZKw5wmC9goR9GGhbdJfEpZ8EzEpba62CU+QQ==
X-Received: by 2002:a17:90b:4b8d:: with SMTP id lr13mr45739670pjb.0.1640993867180;
        Fri, 31 Dec 2021 15:37:47 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u71sm25888167pgd.68.2021.12.31.15.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 15:37:46 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH net] sctp: hold endpoint before calling cb in sctp_transport_lookup_process
Date:   Fri, 31 Dec 2021 18:37:37 -0500
Message-Id: <937648ddf3d2bf49c8fb15e82b45b24d5a537cda.1640993857.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same fix in commit 5ec7d18d1813 ("sctp: use call_rcu to free endpoint")
is also needed for dumping one asoc and sock after the lookup.

Fixes: 86fdb3448cc1 ("sctp: ensure ep is not destroyed before doing the dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h |  3 +--
 net/sctp/diag.c         | 46 +++++++++++++++++++----------------------
 net/sctp/socket.c       | 22 +++++++++++++-------
 3 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index d314a180ab93..3ae61ce2eabd 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -112,8 +112,7 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
 			struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_idx(struct net *net,
 			struct rhashtable_iter *iter, int pos);
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a7d623171501..034e2c74497d 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -245,48 +245,44 @@ static size_t inet_assoc_attr_size(struct sctp_association *asoc)
 		+ 64;
 }
 
-static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump_one(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
 	struct sctp_association *assoc = tsp->asoc;
-	struct sock *sk = tsp->asoc->base.sk;
 	struct sctp_comm_param *commp = p;
-	struct sk_buff *in_skb = commp->skb;
+	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *req = commp->r;
-	const struct nlmsghdr *nlh = commp->nlh;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = commp->skb;
 	struct sk_buff *rep;
 	int err;
 
 	err = sock_diag_check_cookie(sk, req->id.idiag_cookie);
 	if (err)
-		goto out;
+		return err;
 
-	err = -ENOMEM;
 	rep = nlmsg_new(inet_assoc_attr_size(assoc), GFP_KERNEL);
 	if (!rep)
-		goto out;
+		return -ENOMEM;
 
 	lock_sock(sk);
-	if (sk != assoc->base.sk) {
-		release_sock(sk);
-		sk = assoc->base.sk;
-		lock_sock(sk);
+	if (ep != assoc->ep) {
+		err = -EAGAIN;
+		goto out;
 	}
-	err = inet_sctp_diag_fill(sk, assoc, rep, req,
-				  sk_user_ns(NETLINK_CB(in_skb).sk),
-				  NETLINK_CB(in_skb).portid,
-				  nlh->nlmsg_seq, 0, nlh,
-				  commp->net_admin);
-	release_sock(sk);
+
+	err = inet_sctp_diag_fill(sk, assoc, rep, req, sk_user_ns(NETLINK_CB(skb).sk),
+				  NETLINK_CB(skb).portid, commp->nlh->nlmsg_seq, 0,
+				  commp->nlh, commp->net_admin);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
-		kfree_skb(rep);
 		goto out;
 	}
+	release_sock(sk);
 
-	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(sock_net(skb->sk)->diag_nlsk, rep, NETLINK_CB(skb).portid);
 
 out:
+	release_sock(sk);
+	kfree_skb(rep);
 	return err;
 }
 
@@ -429,15 +425,15 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 static int sctp_diag_dump_one(struct netlink_callback *cb,
 			      const struct inet_diag_req_v2 *req)
 {
-	struct sk_buff *in_skb = cb->skb;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = cb->skb;
+	struct net *net = sock_net(skb->sk);
 	const struct nlmsghdr *nlh = cb->nlh;
 	union sctp_addr laddr, paddr;
 	struct sctp_comm_param commp = {
-		.skb = in_skb,
+		.skb = skb,
 		.r = req,
 		.nlh = nlh,
-		.net_admin = netlink_net_capable(in_skb, CAP_NET_ADMIN),
+		.net_admin = netlink_net_capable(skb, CAP_NET_ADMIN),
 	};
 
 	if (req->sdiag_family == AF_INET) {
@@ -460,7 +456,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 		paddr.v6.sin6_family = AF_INET6;
 	}
 
-	return sctp_transport_lookup_process(sctp_tsp_dump_one,
+	return sctp_transport_lookup_process(sctp_sock_dump_one,
 					     net, &laddr, &paddr, &commp);
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ad5028a07b18..da08671a3f80 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5317,23 +5317,31 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 }
 EXPORT_SYMBOL_GPL(sctp_for_each_endpoint);
 
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p)
 {
 	struct sctp_transport *transport;
-	int err;
+	struct sctp_endpoint *ep;
+	int err = -ENOENT;
 
 	rcu_read_lock();
 	transport = sctp_addrs_lookup_transport(net, laddr, paddr);
+	if (!transport) {
+		rcu_read_unlock();
+		return err;
+	}
+	ep = transport->asoc->ep;
+	if (!sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+		sctp_transport_put(transport);
+		rcu_read_unlock();
+		return err;
+	}
 	rcu_read_unlock();
-	if (!transport)
-		return -ENOENT;
 
-	err = cb(transport, p);
+	err = cb(ep, transport, p);
+	sctp_endpoint_put(ep);
 	sctp_transport_put(transport);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);
-- 
2.27.0

