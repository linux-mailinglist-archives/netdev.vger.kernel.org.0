Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4DC225F9E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgGTMvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbgGTMsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3B8C061794;
        Mon, 20 Jul 2020 05:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BXIWlOxxLGAwEkybRtLTw7LIxC9f35ukkZ5P3mQ+S3I=; b=kknbEvF359Bd6tXs5m6v0Bn7Ko
        vYBhFcZbo5m2EyzEZQSROToEVfvd7U8AhbFyTHl9tBHPHBpn+o06EGL26u8zK84fwOqTG2nwOTyuy
        /ww4G31fRlSvc8af//hFPJZq9EbHojgpRpTqOszBhMu0hLLrSpMAT8x41hg8Ewk86gOq82WD5rvCA
        gXK0QpfDMrdhD2r7iYAIAAkoDis+eFcYhp8PGOQVSN5RkG7Mk0F6HEa0t8a0MydisW7a9HUhiIFoo
        Z7pExtU3rAtnoGUKv+TyOO/Cf/7kDtzI9zMIITcsA5ywQPTi+jPfu4KWisp4vKX5fqHM0Ji5cy75r
        T85wpX2w==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVDD-0004YK-02; Mon, 20 Jul 2020 12:48:08 +0000
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
Subject: [PATCH 10/24] netfilter: switch xt_copy_counters to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:23 +0200
Message-Id: <20200720124737.118617-11-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a sockptr_t to prepare for set_fs-less handling of the kernel
pointer from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/netfilter/x_tables.h |  4 ++--
 net/ipv4/netfilter/arp_tables.c    |  7 +++----
 net/ipv4/netfilter/ip_tables.c     |  7 +++----
 net/ipv6/netfilter/ip6_tables.c    |  6 +++---
 net/netfilter/x_tables.c           | 20 ++++++++++----------
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b8b943ee7b8b66..5deb099d156dcb 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -301,8 +301,8 @@ int xt_target_to_user(const struct xt_entry_target *t,
 int xt_data_to_user(void __user *dst, const void *src,
 		    int usersize, int size, int aligned_size);
 
-void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
-				 struct xt_counters_info *info);
+void *xt_copy_counters(sockptr_t arg, unsigned int len,
+		       struct xt_counters_info *info);
 struct xt_counters *xt_counters_alloc(unsigned int counters);
 
 struct xt_table *xt_register_table(struct net *net,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2c8a4dad39d748..6d24b686c7f00a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -996,8 +996,7 @@ static int do_replace(struct net *net, const void __user *user,
 	return ret;
 }
 
-static int do_add_counters(struct net *net, const void __user *user,
-			   unsigned int len)
+static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 {
 	unsigned int i;
 	struct xt_counters_info tmp;
@@ -1008,7 +1007,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 	struct arpt_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp);
+	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 
@@ -1420,7 +1419,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned
 		break;
 
 	case ARPT_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(sock_net(sk), user, len);
+		ret = do_add_counters(sock_net(sk), USER_SOCKPTR(user), len);
 		break;
 
 	default:
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 161901dd1cae7f..4697d09c98dc3e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1151,8 +1151,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 }
 
 static int
-do_add_counters(struct net *net, const void __user *user,
-		unsigned int len)
+do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 {
 	unsigned int i;
 	struct xt_counters_info tmp;
@@ -1163,7 +1162,7 @@ do_add_counters(struct net *net, const void __user *user,
 	struct ipt_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp);
+	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 
@@ -1629,7 +1628,7 @@ do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 
 	case IPT_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(sock_net(sk), user, len);
+		ret = do_add_counters(sock_net(sk), USER_SOCKPTR(user), len);
 		break;
 
 	default:
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index fd1f8f93123188..a787aba30e2db7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1168,7 +1168,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 }
 
 static int
-do_add_counters(struct net *net, const void __user *user, unsigned int len)
+do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 {
 	unsigned int i;
 	struct xt_counters_info tmp;
@@ -1179,7 +1179,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len)
 	struct ip6t_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp);
+	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 	t = xt_find_table_lock(net, AF_INET6, tmp.name);
@@ -1637,7 +1637,7 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 
 	case IP6T_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(sock_net(sk), user, len);
+		ret = do_add_counters(sock_net(sk), USER_SOCKPTR(user), len);
 		break;
 
 	default:
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 32bab45af7e415..b97eb4b538fd4e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1028,9 +1028,9 @@ int xt_check_target(struct xt_tgchk_param *par,
 EXPORT_SYMBOL_GPL(xt_check_target);
 
 /**
- * xt_copy_counters_from_user - copy counters and metadata from userspace
+ * xt_copy_counters - copy counters and metadata from a sockptr_t
  *
- * @user: src pointer to userspace memory
+ * @arg: src sockptr
  * @len: alleged size of userspace memory
  * @info: where to store the xt_counters_info metadata
  *
@@ -1047,8 +1047,8 @@ EXPORT_SYMBOL_GPL(xt_check_target);
  * Return: returns pointer that caller has to test via IS_ERR().
  * If IS_ERR is false, caller has to vfree the pointer.
  */
-void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
-				 struct xt_counters_info *info)
+void *xt_copy_counters(sockptr_t arg, unsigned int len,
+		       struct xt_counters_info *info)
 {
 	void *mem;
 	u64 size;
@@ -1062,12 +1062,12 @@ void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
 			return ERR_PTR(-EINVAL);
 
 		len -= sizeof(compat_tmp);
-		if (copy_from_user(&compat_tmp, user, sizeof(compat_tmp)) != 0)
+		if (copy_from_sockptr(&compat_tmp, arg, sizeof(compat_tmp)) != 0)
 			return ERR_PTR(-EFAULT);
 
 		memcpy(info->name, compat_tmp.name, sizeof(info->name) - 1);
 		info->num_counters = compat_tmp.num_counters;
-		user += sizeof(compat_tmp);
+		sockptr_advance(arg, sizeof(compat_tmp));
 	} else
 #endif
 	{
@@ -1075,10 +1075,10 @@ void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
 			return ERR_PTR(-EINVAL);
 
 		len -= sizeof(*info);
-		if (copy_from_user(info, user, sizeof(*info)) != 0)
+		if (copy_from_sockptr(info, arg, sizeof(*info)) != 0)
 			return ERR_PTR(-EFAULT);
 
-		user += sizeof(*info);
+		sockptr_advance(arg, sizeof(*info));
 	}
 	info->name[sizeof(info->name) - 1] = '\0';
 
@@ -1092,13 +1092,13 @@ void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
-	if (copy_from_user(mem, user, len) == 0)
+	if (copy_from_sockptr(mem, arg, len) == 0)
 		return mem;
 
 	vfree(mem);
 	return ERR_PTR(-EFAULT);
 }
-EXPORT_SYMBOL_GPL(xt_copy_counters_from_user);
+EXPORT_SYMBOL_GPL(xt_copy_counters);
 
 #ifdef CONFIG_COMPAT
 int xt_compat_target_offset(const struct xt_target *target)
-- 
2.27.0

