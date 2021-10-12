Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E208242A8F6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhJLQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhJLQAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3F0F610CC;
        Tue, 12 Oct 2021 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054329;
        bh=T6ppLGl0aDoCFsR3Pz4UcvNQUbGl2TOczrkHIqZxPJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNfe21BdT/D4tbKZxLpnUaNUeEY7oMjDx6G3FpsND6Hh+RaQf59yeYiyDZPcbExt7
         tt9tZB+Dh51zUxYRONn2Ma3OJaIllqrx2sXvf+eJKlPNDdUNqVUjMhBedhbWGNjdVH
         0u6aGS9LBJYCGDwQ/VcOKlLiYGpdRMV4UgwN6kpiMBf9QXeAabCDCNz45rXrsg1+2n
         0pkpnTAA22BLDePAuUdN2FjNeQgl33yVw30xqZigXdmfr5Jm10EVcOE9OfhPHlCYTV
         pvqnydVJIAeoEMhLtrryKBM/6COjdesD/LiQZLWgJk+NVcVzJhd0ZLPYT5toE/e6LE
         8Vd9MdBKI5w/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] rose: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:36 -0700
Message-Id: <20211012155840.4151590-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in rose constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/rose.h    |  8 ++++----
 net/rose/af_rose.c    |  5 +++--
 net/rose/rose_dev.c   |  6 +++---
 net/rose/rose_route.c | 10 ++++++----
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index cf517d306a28..0f0a4ce0fee7 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -162,8 +162,8 @@ extern int  sysctl_rose_link_fail_timeout;
 extern int  sysctl_rose_maximum_vcs;
 extern int  sysctl_rose_window_size;
 
-int rosecmp(rose_address *, rose_address *);
-int rosecmpm(rose_address *, rose_address *, unsigned short);
+int rosecmp(const rose_address *, const rose_address *);
+int rosecmpm(const rose_address *, const rose_address *, unsigned short);
 char *rose2asc(char *buf, const rose_address *);
 struct sock *rose_find_socket(unsigned int, struct rose_neigh *);
 void rose_kill_by_neigh(struct rose_neigh *);
@@ -205,8 +205,8 @@ extern const struct seq_operations rose_node_seqops;
 extern struct seq_operations rose_route_seqops;
 
 void rose_add_loopback_neigh(void);
-int __must_check rose_add_loopback_node(rose_address *);
-void rose_del_loopback_node(rose_address *);
+int __must_check rose_add_loopback_node(const rose_address *);
+void rose_del_loopback_node(const rose_address *);
 void rose_rt_device_down(struct net_device *);
 void rose_link_device_down(struct net_device *);
 struct net_device *rose_dev_first(void);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index cf7d974e0f61..30a1cf4c16c6 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -109,7 +109,7 @@ char *rose2asc(char *buf, const rose_address *addr)
 /*
  *	Compare two ROSE addresses, 0 == equal.
  */
-int rosecmp(rose_address *addr1, rose_address *addr2)
+int rosecmp(const rose_address *addr1, const rose_address *addr2)
 {
 	int i;
 
@@ -123,7 +123,8 @@ int rosecmp(rose_address *addr1, rose_address *addr2)
 /*
  *	Compare two ROSE addresses for only mask digits, 0 == equal.
  */
-int rosecmpm(rose_address *addr1, rose_address *addr2, unsigned short mask)
+int rosecmpm(const rose_address *addr1, const rose_address *addr2,
+	     unsigned short mask)
 {
 	unsigned int i, j;
 
diff --git a/net/rose/rose_dev.c b/net/rose/rose_dev.c
index 2a35e188b389..f1a76a5820f1 100644
--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -66,7 +66,7 @@ static int rose_set_mac_address(struct net_device *dev, void *addr)
 		if (err)
 			return err;
 
-		rose_del_loopback_node((rose_address *)dev->dev_addr);
+		rose_del_loopback_node((const rose_address *)dev->dev_addr);
 	}
 
 	dev_addr_set(dev, sa->sa_data);
@@ -78,7 +78,7 @@ static int rose_open(struct net_device *dev)
 {
 	int err;
 
-	err = rose_add_loopback_node((rose_address *)dev->dev_addr);
+	err = rose_add_loopback_node((const rose_address *)dev->dev_addr);
 	if (err)
 		return err;
 
@@ -90,7 +90,7 @@ static int rose_open(struct net_device *dev)
 static int rose_close(struct net_device *dev)
 {
 	netif_stop_queue(dev);
-	rose_del_loopback_node((rose_address *)dev->dev_addr);
+	rose_del_loopback_node((const rose_address *)dev->dev_addr);
 	return 0;
 }
 
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index c0e04c261a15..e2e6b6b78578 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -401,7 +401,7 @@ void rose_add_loopback_neigh(void)
 /*
  *	Add a loopback node.
  */
-int rose_add_loopback_node(rose_address *address)
+int rose_add_loopback_node(const rose_address *address)
 {
 	struct rose_node *rose_node;
 	int err = 0;
@@ -446,7 +446,7 @@ int rose_add_loopback_node(rose_address *address)
 /*
  *	Delete a loopback node.
  */
-void rose_del_loopback_node(rose_address *address)
+void rose_del_loopback_node(const rose_address *address)
 {
 	struct rose_node *rose_node;
 
@@ -629,7 +629,8 @@ struct net_device *rose_dev_get(rose_address *addr)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_ROSE && rosecmp(addr, (rose_address *)dev->dev_addr) == 0) {
+		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_ROSE &&
+		    rosecmp(addr, (const rose_address *)dev->dev_addr) == 0) {
 			dev_hold(dev);
 			goto out;
 		}
@@ -646,7 +647,8 @@ static int rose_dev_exists(rose_address *addr)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_ROSE && rosecmp(addr, (rose_address *)dev->dev_addr) == 0)
+		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_ROSE &&
+		    rosecmp(addr, (const rose_address *)dev->dev_addr) == 0)
 			goto out;
 	}
 	dev = NULL;
-- 
2.31.1

