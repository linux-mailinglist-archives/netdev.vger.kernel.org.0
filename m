Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1A26A76
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfEVTE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEVTE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:04:58 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820252173C;
        Wed, 22 May 2019 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558551897;
        bh=YnFaXiomBFlrCT5HIV+c18zVHNU7I3dOBj4d8SD2R4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyzN5j/RsR+bV3PWOL6O23048K3biXvtLYPXesBJdume0jNI9/sWWZ90FiIdedhQm
         e/I1AN+QXRQFve7YbC8svq6RwTDH0XAd1VNAwXt5qOk+2uAjs46R15q3A/SgNbD3bM
         EmnMXKEnC931QGyrs8ffOhgvdDzEVFMEa8P01+XI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 2/8] ipv6: Add hook to bump sernum for a route to stubs
Date:   Wed, 22 May 2019 12:04:40 -0700
Message-Id: <20190522190446.15486-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522190446.15486-1-dsahern@kernel.org>
References: <20190522190446.15486-1-dsahern@kernel.org>
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
index 525f701653ca..d038d02cbc3c 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -485,6 +485,7 @@ int fib6_tables_dump(struct net *net, struct notifier_block *nb);
 
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
index 008421b550c6..df726fb8f70f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1222,6 +1222,14 @@ void fib6_update_sernum_upto_root(struct net *net, struct fib6_info *rt)
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

