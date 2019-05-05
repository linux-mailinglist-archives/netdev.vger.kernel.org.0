Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5560E14129
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEEQj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfEEQjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:41 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E58208C0;
        Sun,  5 May 2019 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074380;
        bh=GwQ1eRBk4CHQPFRylilBPHV3zzeeuISH1Erp8Xbag7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJG0GTIhlhH2yvc21CF24GUumNkojtuROcIsiKGcVdwhBTiH+2zMQHVJ/oYqVFZtX
         vAKiTUcZ0adMhbBZkFIthjWsdoVXiueh9JJfgVjieFzF2fMmKnCogVFN621x287a8T
         PnCWOdYLG/OZ+b8zCLMeMCiZJ/i8neFz/Foya25Y=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/7] ipv6: Add delete route hook to stubs
Date:   Sun,  5 May 2019 09:40:50 -0700
Message-Id: <20190505164056.1742-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add ip6_del_rt to the IPv6 stub. The hook is needed by the nexthop
code to remove entries linked to a nexthop that is getting deleted.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ipv6_stubs.h | 1 +
 net/ipv6/addrconf_core.c | 6 ++++++
 net/ipv6/af_inet6.c      | 1 +
 3 files changed, 8 insertions(+)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 6c0c4fde16f8..307114a46eee 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -45,6 +45,7 @@ struct ipv6_stub {
 			    struct fib6_config *cfg, gfp_t gfp_flags,
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
+	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt);
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 763a947e0d14..9644af96810d 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -182,6 +182,11 @@ static int eafnosupport_fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	return -EAFNOSUPPORT;
 }
 
+static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt)
+{
+	return -EAFNOSUPPORT;
+}
+
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 	.ipv6_dst_lookup   = eafnosupport_ipv6_dst_lookup,
 	.ipv6_route_input  = eafnosupport_ipv6_route_input,
@@ -191,6 +196,7 @@ const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 	.fib6_select_path  = eafnosupport_fib6_select_path,
 	.ip6_mtu_from_fib6 = eafnosupport_ip6_mtu_from_fib6,
 	.fib6_nh_init	   = eafnosupport_fib6_nh_init,
+	.ip6_del_rt	   = eafnosupport_ip6_del_rt,
 };
 EXPORT_SYMBOL_GPL(ipv6_stub);
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index c04ae282f4e4..bc2ca61a020a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -926,6 +926,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_mtu_from_fib6 = ip6_mtu_from_fib6,
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
+	.ip6_del_rt	   = ip6_del_rt,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
 	.nd_tbl	= &nd_tbl,
-- 
2.11.0

