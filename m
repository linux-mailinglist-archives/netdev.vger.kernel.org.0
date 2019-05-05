Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20E14123
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfEEQjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbfEEQjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:41 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB31208C2;
        Sun,  5 May 2019 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074380;
        bh=plYONt3+to7c0vRX8AmHO5mEKv7TilRHAU6QJgjpZRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnvEfI/IdRGKkUnMcTQpmYtqaZrbFAQ7OzPd0xplUIlRd3Qn5UsDr0ieqUvk/ZV/7
         GELa7UWxYcQQh4iDdaOdFR/2rowSWXyrGH4OB2r5mEivBL9cR01g0GDd9snts+bc0r
         zc9bACSn3HAtA5LK+U0d5i99S22W0HoutB4pCP3A=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 2/7] ipv6: Add hook to bump sernum for a route to stubs
Date:   Sun,  5 May 2019 09:40:51 -0700
Message-Id: <20190505164056.1742-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add hook to ipv6 stub to bump the sernum up to the root node for a
route. This is needed by the nexthop code when a nexthop config changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h    | 1 +
 include/net/ipv6_stubs.h | 1 +
 net/ipv6/af_inet6.c      | 1 +
 net/ipv6/ip6_fib.c       | 8 ++++++++
 4 files changed, 11 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 40105738e2f6..d1f1f94e0267 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -484,6 +484,7 @@ int fib6_tables_dump(struct net *net, struct notifier_block *nb);
 
 void fib6_update_sernum(struct net *net, struct fib6_info *rt);
 void fib6_update_sernum_upto_root(struct net *net, struct fib6_info *rt);
+void fib6_update_sernum_stub(struct net *net, struct fib6_info *f6i);
 
 void fib6_metric_set(struct fib6_info *f6i, int metric, u32 val);
 static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 307114a46eee..97f42e16b3b3 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -45,6 +45,7 @@ struct ipv6_stub {
 			    struct fib6_config *cfg, gfp_t gfp_flags,
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
+	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
 	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt);
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index bc2ca61a020a..55138f0d2b9d 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -926,6 +926,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_mtu_from_fib6 = ip6_mtu_from_fib6,
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
+	.fib6_update_sernum = fib6_update_sernum_stub,
 	.ip6_del_rt	   = ip6_del_rt,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 08e0390e001c..c333a9710034 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1216,6 +1216,14 @@ void fib6_update_sernum_upto_root(struct net *net, struct fib6_info *rt)
 	__fib6_update_sernum_upto_root(rt, fib6_new_sernum(net));
 }
 
+/* allow ipv4 to update sernum via ipv6_stub */
+void fib6_update_sernum_stub(struct net *net, struct fib6_info *f6i)
+{
+	spin_lock_bh(&f6i->fib6_table->tb6_lock);
+	fib6_update_sernum_upto_root(net, f6i);
+	spin_unlock_bh(&f6i->fib6_table->tb6_lock);
+}
+
 /*
  *	Add routing information to the routing tree.
  *	<destination addr>/<source addr>
-- 
2.11.0

