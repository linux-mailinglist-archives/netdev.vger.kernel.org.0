Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31AB223422
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgGQG0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgGQGYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1A9C061755;
        Thu, 16 Jul 2020 23:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=onGMObakYuJolqNUDGEoKH222TJ4CRvXciqCD06UH/4=; b=Uc0ddcNECGZcu9NFgN8NW/9NDo
        9YsTXvgLnALfkSMrgDoBURQ9+dpcHCrJcbgqduNESwel2WYvkDDv4y9m/FOkibo8xgGZF2kGOlddN
        OLGEJiOxYSHPni5Byri9LJSVIvsPNGVWp83iGMhpqCLTfcwiBtGEvW2miEfaCHx6CvEoEub4Xo0XE
        5A7p2ZxvckF66jQI0VYWK99tE+Dag48jDYcBYr+d9WCkh+GsOG7NmwGIitI4Eb/a+aGKIbnsA5oSv
        YWSuCicEdqvh2HaWOmLeKUKgzFx/TFWPLtAVsUuU4RKtOxpgsrrlbjybpWo6GtLB0QqCeYUHC08qr
        mK+F0ICg==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn0-00053W-6X; Fri, 17 Jul 2020 06:24:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 10/22] netfilter/ebtables: clean up compat {get,set}sockopt handling
Date:   Fri, 17 Jul 2020 08:23:19 +0200
Message-Id: <20200717062331.691152-11-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the native and compat {get,set}sockopt handlers using
in_compat_syscall().  Note that this required moving a fair
amout of code around to be done sanely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bridge/netfilter/ebtables.c | 214 +++++++++++++++-----------------
 1 file changed, 98 insertions(+), 116 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c83ffe9121639c..fe13108af1f542 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1451,86 +1451,6 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 	   ebt_entry_to_user, entries, tmp.entries);
 }
 
-static int do_ebt_set_ctl(struct sock *sk,
-	int cmd, void __user *user, unsigned int len)
-{
-	int ret;
-	struct net *net = sock_net(sk);
-
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	switch (cmd) {
-	case EBT_SO_SET_ENTRIES:
-		ret = do_replace(net, user, len);
-		break;
-	case EBT_SO_SET_COUNTERS:
-		ret = update_counters(net, user, len);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
-static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
-{
-	int ret;
-	struct ebt_replace tmp;
-	struct ebt_table *t;
-	struct net *net = sock_net(sk);
-
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (copy_from_user(&tmp, user, sizeof(tmp)))
-		return -EFAULT;
-
-	tmp.name[sizeof(tmp.name) - 1] = '\0';
-
-	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
-	if (!t)
-		return ret;
-
-	switch (cmd) {
-	case EBT_SO_GET_INFO:
-	case EBT_SO_GET_INIT_INFO:
-		if (*len != sizeof(struct ebt_replace)) {
-			ret = -EINVAL;
-			mutex_unlock(&ebt_mutex);
-			break;
-		}
-		if (cmd == EBT_SO_GET_INFO) {
-			tmp.nentries = t->private->nentries;
-			tmp.entries_size = t->private->entries_size;
-			tmp.valid_hooks = t->valid_hooks;
-		} else {
-			tmp.nentries = t->table->nentries;
-			tmp.entries_size = t->table->entries_size;
-			tmp.valid_hooks = t->table->valid_hooks;
-		}
-		mutex_unlock(&ebt_mutex);
-		if (copy_to_user(user, &tmp, *len) != 0) {
-			ret = -EFAULT;
-			break;
-		}
-		ret = 0;
-		break;
-
-	case EBT_SO_GET_ENTRIES:
-	case EBT_SO_GET_INIT_ENTRIES:
-		ret = copy_everything_to_user(t, user, len, cmd);
-		mutex_unlock(&ebt_mutex);
-		break;
-
-	default:
-		mutex_unlock(&ebt_mutex);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 /* 32 bit-userspace compatibility definitions. */
 struct compat_ebt_replace {
@@ -2314,28 +2234,6 @@ static int compat_update_counters(struct net *net, void __user *user,
 					hlp.num_counters, user, len);
 }
 
-static int compat_do_ebt_set_ctl(struct sock *sk,
-		int cmd, void __user *user, unsigned int len)
-{
-	int ret;
-	struct net *net = sock_net(sk);
-
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	switch (cmd) {
-	case EBT_SO_SET_ENTRIES:
-		ret = compat_do_replace(net, user, len);
-		break;
-	case EBT_SO_SET_COUNTERS:
-		ret = compat_update_counters(net, user, len);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
 static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 		void __user *user, int *len)
 {
@@ -2344,14 +2242,6 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 	struct ebt_table *t;
 	struct net *net = sock_net(sk);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	/* try real handler in case userland supplied needed padding */
-	if ((cmd == EBT_SO_GET_INFO ||
-	     cmd == EBT_SO_GET_INIT_INFO) && *len != sizeof(tmp))
-			return do_ebt_get_ctl(sk, cmd, user, len);
-
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 
@@ -2413,20 +2303,112 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 }
 #endif
 
+static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
+{
+	struct net *net = sock_net(sk);
+	struct ebt_replace tmp;
+	struct ebt_table *t;
+	int ret;
+
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+#ifdef CONFIG_COMPAT
+	/* try real handler in case userland supplied needed padding */
+	if (in_compat_syscall() &&
+	    ((cmd != EBT_SO_GET_INFO && cmd != EBT_SO_GET_INIT_INFO) ||
+	     *len != sizeof(tmp)))
+		return compat_do_ebt_get_ctl(sk, cmd, user, len);
+#endif
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)))
+		return -EFAULT;
+
+	tmp.name[sizeof(tmp.name) - 1] = '\0';
+
+	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
+	if (!t)
+		return ret;
+
+	switch (cmd) {
+	case EBT_SO_GET_INFO:
+	case EBT_SO_GET_INIT_INFO:
+		if (*len != sizeof(struct ebt_replace)) {
+			ret = -EINVAL;
+			mutex_unlock(&ebt_mutex);
+			break;
+		}
+		if (cmd == EBT_SO_GET_INFO) {
+			tmp.nentries = t->private->nentries;
+			tmp.entries_size = t->private->entries_size;
+			tmp.valid_hooks = t->valid_hooks;
+		} else {
+			tmp.nentries = t->table->nentries;
+			tmp.entries_size = t->table->entries_size;
+			tmp.valid_hooks = t->table->valid_hooks;
+		}
+		mutex_unlock(&ebt_mutex);
+		if (copy_to_user(user, &tmp, *len) != 0) {
+			ret = -EFAULT;
+			break;
+		}
+		ret = 0;
+		break;
+
+	case EBT_SO_GET_ENTRIES:
+	case EBT_SO_GET_INIT_ENTRIES:
+		ret = copy_everything_to_user(t, user, len, cmd);
+		mutex_unlock(&ebt_mutex);
+		break;
+
+	default:
+		mutex_unlock(&ebt_mutex);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int do_ebt_set_ctl(struct sock *sk, int cmd, void __user *user,
+		unsigned int len)
+{
+	struct net *net = sock_net(sk);
+	int ret;
+
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case EBT_SO_SET_ENTRIES:
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = compat_do_replace(net, user, len);
+		else
+#endif
+			ret = do_replace(net, user, len);
+		break;
+	case EBT_SO_SET_COUNTERS:
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = compat_update_counters(net, user, len);
+		else
+#endif
+			ret = update_counters(net, user, len);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
 static struct nf_sockopt_ops ebt_sockopts = {
 	.pf		= PF_INET,
 	.set_optmin	= EBT_BASE_CTL,
 	.set_optmax	= EBT_SO_SET_MAX + 1,
 	.set		= do_ebt_set_ctl,
-#ifdef CONFIG_COMPAT
-	.compat_set	= compat_do_ebt_set_ctl,
-#endif
 	.get_optmin	= EBT_BASE_CTL,
 	.get_optmax	= EBT_SO_GET_MAX + 1,
 	.get		= do_ebt_get_ctl,
-#ifdef CONFIG_COMPAT
-	.compat_get	= compat_do_ebt_get_ctl,
-#endif
 	.owner		= THIS_MODULE,
 };
 
-- 
2.27.0

