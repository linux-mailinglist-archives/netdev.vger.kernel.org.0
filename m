Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4A22343D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgGQG0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgGQGYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE660C061755;
        Thu, 16 Jul 2020 23:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wr5cOSCBypjWaa13QpyMI0Pyh05kUAwvudFuTMkZyns=; b=s3rvm7cVFffHZaEfGTg7ZfxVZj
        x98j/y1+kfHZpWI0o1XmAwtMIa3yqk+Mc35fICVgr5SELYyL2RJfoDIKDIQSXFAsXM2VTe8QKHi5F
        Ms4N6XlX6SrfF4CMde/BUp9r4z8dZzORk9rMPY4AUlCe5u/SKvMCnl4dBlfzkl2VAmFEIm+GFY8lZ
        QShVpd2XFETG8G+PSNHUayBUaUWpvUXP1w8ZOTIXN90+oLvpDE6atTMlyXW8e9cOsrgX/OhVi9zFr
        aJKInlOHEuN74IWoQ+LsKSCMq945wnFRGiPbMkMVSCsxQnG2UWG2tAf67VXI8o56QRe+iexrykVXk
        6aCu719g==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJmx-00052z-Gw; Fri, 17 Jul 2020 06:24:07 +0000
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
Subject: [PATCH 08/22] netfilter/ip_tables: clean up compat {get,set}sockopt handling
Date:   Fri, 17 Jul 2020 08:23:17 +0200
Message-Id: <20200717062331.691152-9-hch@lst.de>
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
in_compat_syscall().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/netfilter/ip_tables.c | 86 +++++++++-------------------------
 1 file changed, 21 insertions(+), 65 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 5bf9fa06aee0be..fbfad38f397949 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -944,8 +944,7 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
-static int get_info(struct net *net, void __user *user,
-		    const int *len, int compat)
+static int get_info(struct net *net, void __user *user, const int *len)
 {
 	char name[XT_TABLE_MAXNAMELEN];
 	struct xt_table *t;
@@ -959,7 +958,7 @@ static int get_info(struct net *net, void __user *user,
 
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
 #ifdef CONFIG_COMPAT
-	if (compat)
+	if (in_compat_syscall())
 		xt_compat_lock(AF_INET);
 #endif
 	t = xt_request_find_table_lock(net, AF_INET, name);
@@ -969,7 +968,7 @@ static int get_info(struct net *net, void __user *user,
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
-		if (compat) {
+		if (in_compat_syscall()) {
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(AF_INET);
 			private = &tmp;
@@ -995,7 +994,7 @@ static int get_info(struct net *net, void __user *user,
 	} else
 		ret = PTR_ERR(t);
 #ifdef CONFIG_COMPAT
-	if (compat)
+	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET);
 #endif
 	return ret;
@@ -1153,7 +1152,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 
 static int
 do_add_counters(struct net *net, const void __user *user,
-		unsigned int len, int compat)
+		unsigned int len)
 {
 	unsigned int i;
 	struct xt_counters_info tmp;
@@ -1164,7 +1163,8 @@ do_add_counters(struct net *net, const void __user *user,
 	struct ipt_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp, compat);
+	paddc = xt_copy_counters_from_user(user, len, &tmp,
+					   in_compat_syscall());
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 
@@ -1534,31 +1534,6 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
-static int
-compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
-		      unsigned int len)
-{
-	int ret;
-
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	switch (cmd) {
-	case IPT_SO_SET_REPLACE:
-		ret = compat_do_replace(sock_net(sk), user, len);
-		break;
-
-	case IPT_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(sock_net(sk), user, len, 1);
-		break;
-
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
 struct compat_ipt_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
@@ -1634,29 +1609,6 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	xt_compat_unlock(AF_INET);
 	return ret;
 }
-
-static int do_ipt_get_ctl(struct sock *, int, void __user *, int *);
-
-static int
-compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
-{
-	int ret;
-
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	switch (cmd) {
-	case IPT_SO_GET_INFO:
-		ret = get_info(sock_net(sk), user, len, 1);
-		break;
-	case IPT_SO_GET_ENTRIES:
-		ret = compat_get_entries(sock_net(sk), user, len);
-		break;
-	default:
-		ret = do_ipt_get_ctl(sk, cmd, user, len);
-	}
-	return ret;
-}
 #endif
 
 static int
@@ -1669,11 +1621,16 @@ do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
 	switch (cmd) {
 	case IPT_SO_SET_REPLACE:
-		ret = do_replace(sock_net(sk), user, len);
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = compat_do_replace(sock_net(sk), user, len);
+		else
+#endif
+			ret = do_replace(sock_net(sk), user, len);
 		break;
 
 	case IPT_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(sock_net(sk), user, len, 0);
+		ret = do_add_counters(sock_net(sk), user, len);
 		break;
 
 	default:
@@ -1693,11 +1650,16 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	switch (cmd) {
 	case IPT_SO_GET_INFO:
-		ret = get_info(sock_net(sk), user, len, 0);
+		ret = get_info(sock_net(sk), user, len);
 		break;
 
 	case IPT_SO_GET_ENTRIES:
-		ret = get_entries(sock_net(sk), user, len);
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = compat_get_entries(sock_net(sk), user, len);
+		else
+#endif
+			ret = get_entries(sock_net(sk), user, len);
 		break;
 
 	case IPT_SO_GET_REVISION_MATCH:
@@ -1886,15 +1848,9 @@ static struct nf_sockopt_ops ipt_sockopts = {
 	.set_optmin	= IPT_BASE_CTL,
 	.set_optmax	= IPT_SO_SET_MAX+1,
 	.set		= do_ipt_set_ctl,
-#ifdef CONFIG_COMPAT
-	.compat_set	= compat_do_ipt_set_ctl,
-#endif
 	.get_optmin	= IPT_BASE_CTL,
 	.get_optmax	= IPT_SO_GET_MAX+1,
 	.get		= do_ipt_get_ctl,
-#ifdef CONFIG_COMPAT
-	.compat_get	= compat_do_ipt_get_ctl,
-#endif
 	.owner		= THIS_MODULE,
 };
 
-- 
2.27.0

