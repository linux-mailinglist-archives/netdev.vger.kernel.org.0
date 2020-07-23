Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE29922A76B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGWGJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgGWGJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB438C0619E3;
        Wed, 22 Jul 2020 23:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oYVq7NIRWqvX/f/cel/N+xePG7N1PJ2B3QTLRfoiAMQ=; b=RmS+yof9oOWACLzdO26AX0uvn/
        wDiM3OtnYGKll0k7V7EEhs4h13147H5vXBTkLjApiEE7c2uKTZSFyO4x4GL348FhVTbWDpILohbSo
        cBkUCd/tpSzjo2rHYMxoLok4j+mlk3gd/kM12ANxEJtjEfY7gB+/CfbIkXZ7qkQyjHJE1L20fDqWN
        ci1Kri+UWaOL5Rr5mlx8jFaaQnl0mNoIi82p9ICnX1kU+pMrwVVKsSSHtBvXGpiZidpQky2908IqH
        pyh4iVL9I1l+vvct9nOY0bjp9ijfrIYfa3cycmVYL7P/WWMOnYE0MGHGrzsKRyRPgb36hKUw55sKp
        2hccLDLw==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQB-0003nH-07; Thu, 23 Jul 2020 06:09:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 18/26] net/ipv6: split up ipv6_flowlabel_opt
Date:   Thu, 23 Jul 2020 08:09:00 +0200
Message-Id: <20200723060908.50081-19-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split ipv6_flowlabel_opt into a subfunction for each action and a small
wrapper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/ip6_flowlabel.c | 311 +++++++++++++++++++++------------------
 1 file changed, 167 insertions(+), 144 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index ce4fbba4acce7e..27ee6de9beffc4 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -533,187 +533,210 @@ int ipv6_flowlabel_opt_get(struct sock *sk, struct in6_flowlabel_req *freq,
 	return -ENOENT;
 }
 
-int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
+#define socklist_dereference(__sflp) \
+	rcu_dereference_protected(__sflp, lockdep_is_held(&ip6_sk_fl_lock))
+
+static int ipv6_flowlabel_put(struct sock *sk, struct in6_flowlabel_req *freq)
 {
-	int uninitialized_var(err);
-	struct net *net = sock_net(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct in6_flowlabel_req freq;
-	struct ipv6_fl_socklist *sfl1 = NULL;
-	struct ipv6_fl_socklist *sfl;
 	struct ipv6_fl_socklist __rcu **sflp;
-	struct ip6_flowlabel *fl, *fl1 = NULL;
-
+	struct ipv6_fl_socklist *sfl;
 
-	if (optlen < sizeof(freq))
-		return -EINVAL;
+	if (freq->flr_flags & IPV6_FL_F_REFLECT) {
+		if (sk->sk_protocol != IPPROTO_TCP)
+			return -ENOPROTOOPT;
+		if (!np->repflow)
+			return -ESRCH;
+		np->flow_label = 0;
+		np->repflow = 0;
+		return 0;
+	}
 
-	if (copy_from_user(&freq, optval, sizeof(freq)))
-		return -EFAULT;
+	spin_lock_bh(&ip6_sk_fl_lock);
+	for (sflp = &np->ipv6_fl_list;
+	     (sfl = socklist_dereference(*sflp)) != NULL;
+	     sflp = &sfl->next) {
+		if (sfl->fl->label == freq->flr_label)
+			goto found;
+	}
+	spin_unlock_bh(&ip6_sk_fl_lock);
+	return -ESRCH;
+found:
+	if (freq->flr_label == (np->flow_label & IPV6_FLOWLABEL_MASK))
+		np->flow_label &= ~IPV6_FLOWLABEL_MASK;
+	*sflp = sfl->next;
+	spin_unlock_bh(&ip6_sk_fl_lock);
+	fl_release(sfl->fl);
+	kfree_rcu(sfl, rcu);
+	return 0;
+}
+		
+static int ipv6_flowlabel_renew(struct sock *sk, struct in6_flowlabel_req *freq)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct net *net = sock_net(sk);
+	struct ipv6_fl_socklist *sfl;
+	int err;
 
-	switch (freq.flr_action) {
-	case IPV6_FL_A_PUT:
-		if (freq.flr_flags & IPV6_FL_F_REFLECT) {
-			if (sk->sk_protocol != IPPROTO_TCP)
-				return -ENOPROTOOPT;
-			if (!np->repflow)
-				return -ESRCH;
-			np->flow_label = 0;
-			np->repflow = 0;
-			return 0;
-		}
-		spin_lock_bh(&ip6_sk_fl_lock);
-		for (sflp = &np->ipv6_fl_list;
-		     (sfl = rcu_dereference_protected(*sflp,
-						      lockdep_is_held(&ip6_sk_fl_lock))) != NULL;
-		     sflp = &sfl->next) {
-			if (sfl->fl->label == freq.flr_label) {
-				if (freq.flr_label == (np->flow_label&IPV6_FLOWLABEL_MASK))
-					np->flow_label &= ~IPV6_FLOWLABEL_MASK;
-				*sflp = sfl->next;
-				spin_unlock_bh(&ip6_sk_fl_lock);
-				fl_release(sfl->fl);
-				kfree_rcu(sfl, rcu);
-				return 0;
-			}
+	rcu_read_lock_bh();
+	for_each_sk_fl_rcu(np, sfl) {
+		if (sfl->fl->label == freq->flr_label) {
+			err = fl6_renew(sfl->fl, freq->flr_linger,
+					freq->flr_expires);
+			rcu_read_unlock_bh();
+			return err;
 		}
-		spin_unlock_bh(&ip6_sk_fl_lock);
-		return -ESRCH;
+	}
+	rcu_read_unlock_bh();
 
-	case IPV6_FL_A_RENEW:
-		rcu_read_lock_bh();
-		for_each_sk_fl_rcu(np, sfl) {
-			if (sfl->fl->label == freq.flr_label) {
-				err = fl6_renew(sfl->fl, freq.flr_linger, freq.flr_expires);
-				rcu_read_unlock_bh();
-				return err;
-			}
-		}
-		rcu_read_unlock_bh();
+	if (freq->flr_share == IPV6_FL_S_NONE &&
+	    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+		struct ip6_flowlabel *fl = fl_lookup(net, freq->flr_label);
 
-		if (freq.flr_share == IPV6_FL_S_NONE &&
-		    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
-			fl = fl_lookup(net, freq.flr_label);
-			if (fl) {
-				err = fl6_renew(fl, freq.flr_linger, freq.flr_expires);
-				fl_release(fl);
-				return err;
-			}
+		if (fl) {
+			err = fl6_renew(fl, freq->flr_linger,
+					freq->flr_expires);
+			fl_release(fl);
+			return err;
 		}
-		return -ESRCH;
-
-	case IPV6_FL_A_GET:
-		if (freq.flr_flags & IPV6_FL_F_REFLECT) {
-			struct net *net = sock_net(sk);
-			if (net->ipv6.sysctl.flowlabel_consistency) {
-				net_info_ratelimited("Can not set IPV6_FL_F_REFLECT if flowlabel_consistency sysctl is enable\n");
-				return -EPERM;
-			}
+	}
+	return -ESRCH;
+}
 
-			if (sk->sk_protocol != IPPROTO_TCP)
-				return -ENOPROTOOPT;
+static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
+		void __user *optval, int optlen)
+{
+	struct ipv6_fl_socklist *sfl, *sfl1 = NULL;
+	struct ip6_flowlabel *fl, *fl1 = NULL;
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct net *net = sock_net(sk);
+	int uninitialized_var(err);
 
-			np->repflow = 1;
-			return 0;
+	if (freq->flr_flags & IPV6_FL_F_REFLECT) {
+		if (net->ipv6.sysctl.flowlabel_consistency) {
+			net_info_ratelimited("Can not set IPV6_FL_F_REFLECT if flowlabel_consistency sysctl is enable\n");
+			return -EPERM;
 		}
 
-		if (freq.flr_label & ~IPV6_FLOWLABEL_MASK)
-			return -EINVAL;
+		if (sk->sk_protocol != IPPROTO_TCP)
+			return -ENOPROTOOPT;
+		np->repflow = 1;
+		return 0;
+	}
 
-		if (net->ipv6.sysctl.flowlabel_state_ranges &&
-		    (freq.flr_label & IPV6_FLOWLABEL_STATELESS_FLAG))
-			return -ERANGE;
+	if (freq->flr_label & ~IPV6_FLOWLABEL_MASK)
+		return -EINVAL;
+	if (net->ipv6.sysctl.flowlabel_state_ranges &&
+	    (freq->flr_label & IPV6_FLOWLABEL_STATELESS_FLAG))
+		return -ERANGE;
 
-		fl = fl_create(net, sk, &freq, optval, optlen, &err);
-		if (!fl)
-			return err;
-		sfl1 = kmalloc(sizeof(*sfl1), GFP_KERNEL);
+	fl = fl_create(net, sk, freq, optval, optlen, &err);
+	if (!fl)
+		return err;
 
-		if (freq.flr_label) {
-			err = -EEXIST;
-			rcu_read_lock_bh();
-			for_each_sk_fl_rcu(np, sfl) {
-				if (sfl->fl->label == freq.flr_label) {
-					if (freq.flr_flags&IPV6_FL_F_EXCL) {
-						rcu_read_unlock_bh();
-						goto done;
-					}
-					fl1 = sfl->fl;
-					if (!atomic_inc_not_zero(&fl1->users))
-						fl1 = NULL;
-					break;
+	sfl1 = kmalloc(sizeof(*sfl1), GFP_KERNEL);
+
+	if (freq->flr_label) {
+		err = -EEXIST;
+		rcu_read_lock_bh();
+		for_each_sk_fl_rcu(np, sfl) {
+			if (sfl->fl->label == freq->flr_label) {
+				if (freq->flr_flags & IPV6_FL_F_EXCL) {
+					rcu_read_unlock_bh();
+					goto done;
 				}
+				fl1 = sfl->fl;
+				if (!atomic_inc_not_zero(&fl1->users))
+					fl1 = NULL;
+				break;
 			}
-			rcu_read_unlock_bh();
+		}
+		rcu_read_unlock_bh();
 
-			if (!fl1)
-				fl1 = fl_lookup(net, freq.flr_label);
-			if (fl1) {
+		if (!fl1)
+			fl1 = fl_lookup(net, freq->flr_label);
+		if (fl1) {
 recheck:
-				err = -EEXIST;
-				if (freq.flr_flags&IPV6_FL_F_EXCL)
-					goto release;
-				err = -EPERM;
-				if (fl1->share == IPV6_FL_S_EXCL ||
-				    fl1->share != fl->share ||
-				    ((fl1->share == IPV6_FL_S_PROCESS) &&
-				     (fl1->owner.pid != fl->owner.pid)) ||
-				    ((fl1->share == IPV6_FL_S_USER) &&
-				     !uid_eq(fl1->owner.uid, fl->owner.uid)))
-					goto release;
-
-				err = -ENOMEM;
-				if (!sfl1)
-					goto release;
-				if (fl->linger > fl1->linger)
-					fl1->linger = fl->linger;
-				if ((long)(fl->expires - fl1->expires) > 0)
-					fl1->expires = fl->expires;
-				fl_link(np, sfl1, fl1);
-				fl_free(fl);
-				return 0;
+			err = -EEXIST;
+			if (freq->flr_flags&IPV6_FL_F_EXCL)
+				goto release;
+			err = -EPERM;
+			if (fl1->share == IPV6_FL_S_EXCL ||
+			    fl1->share != fl->share ||
+			    ((fl1->share == IPV6_FL_S_PROCESS) &&
+			     (fl1->owner.pid != fl->owner.pid)) ||
+			    ((fl1->share == IPV6_FL_S_USER) &&
+			     !uid_eq(fl1->owner.uid, fl->owner.uid)))
+				goto release;
+
+			err = -ENOMEM;
+			if (!sfl1)
+				goto release;
+			if (fl->linger > fl1->linger)
+				fl1->linger = fl->linger;
+			if ((long)(fl->expires - fl1->expires) > 0)
+				fl1->expires = fl->expires;
+			fl_link(np, sfl1, fl1);
+			fl_free(fl);
+			return 0;
 
 release:
-				fl_release(fl1);
-				goto done;
-			}
-		}
-		err = -ENOENT;
-		if (!(freq.flr_flags&IPV6_FL_F_CREATE))
+			fl_release(fl1);
 			goto done;
+		}
+	}
+	err = -ENOENT;
+	if (!(freq->flr_flags & IPV6_FL_F_CREATE))
+		goto done;
 
-		err = -ENOMEM;
-		if (!sfl1)
-			goto done;
+	err = -ENOMEM;
+	if (!sfl1)
+		goto done;
 
-		err = mem_check(sk);
-		if (err != 0)
-			goto done;
+	err = mem_check(sk);
+	if (err != 0)
+		goto done;
 
-		fl1 = fl_intern(net, fl, freq.flr_label);
-		if (fl1)
-			goto recheck;
+	fl1 = fl_intern(net, fl, freq->flr_label);
+	if (fl1)
+		goto recheck;
 
-		if (!freq.flr_label) {
-			if (copy_to_user(&((struct in6_flowlabel_req __user *) optval)->flr_label,
-					 &fl->label, sizeof(fl->label))) {
-				/* Intentionally ignore fault. */
-			}
+	if (!freq->flr_label) {
+		if (copy_to_user(&((struct in6_flowlabel_req __user *) optval)->flr_label,
+				 &fl->label, sizeof(fl->label))) {
+			/* Intentionally ignore fault. */
 		}
-
-		fl_link(np, sfl1, fl);
-		return 0;
-
-	default:
-		return -EINVAL;
 	}
 
+	fl_link(np, sfl1, fl);
+	return 0;
 done:
 	fl_free(fl);
 	kfree(sfl1);
 	return err;
 }
 
+int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
+{
+	struct in6_flowlabel_req freq;
+
+	if (optlen < sizeof(freq))
+		return -EINVAL;
+	if (copy_from_user(&freq, optval, sizeof(freq)))
+		return -EFAULT;
+
+	switch (freq.flr_action) {
+	case IPV6_FL_A_PUT:
+		return ipv6_flowlabel_put(sk, &freq);
+	case IPV6_FL_A_RENEW:
+		return ipv6_flowlabel_renew(sk, &freq);
+	case IPV6_FL_A_GET:
+		return ipv6_flowlabel_get(sk, &freq, optval, optlen);
+	default:
+		return -EINVAL;
+	}
+}
+
 #ifdef CONFIG_PROC_FS
 
 struct ip6fl_iter_state {
-- 
2.27.0

