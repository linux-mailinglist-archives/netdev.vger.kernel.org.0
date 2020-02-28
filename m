Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6434F173EFF
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgB1SCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:02:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54960 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:02:04 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so1595130pjb.4
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1wj0tuS0GdkZUdja4ZsgAE8dIYmZ2kpjseZ0Vnnf+pU=;
        b=DBGRoOXjR6w6D0MHalsgRm0MtTusVkb4GLhAqG7aKzOA+oYAl5M3buHxYC3ntcoaLw
         grsbJNDn4+JZL5OPODBlO7N6pzJT7dlm0rBpF4r8ldaRlWAyBf5L3bXsmeiNXQKdFPbS
         i1VsaJTxHGsdJwo1k0MxPwdn3YgxsnalS2eKJe4Do5MCymFIO27w3F+0V2UUNtAbcsP1
         7vgBBTXE+ikqd9gSabMkNW4gXXpEMjhiirY0g85rcTGUPv6FaiChjf4cdIgEUggxOB+r
         +7v989ePTmm3JOX50BKx2SE9BF9S5e+pGVX3VS8WFdFB+hCrfWctvbTzL0cZWvTP6+rw
         Wi+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1wj0tuS0GdkZUdja4ZsgAE8dIYmZ2kpjseZ0Vnnf+pU=;
        b=MSrt+NNFFNpJ170im6Q879jIwvarCDFpk3UmCS0gs99U08OdcjBM4otV1//GZ1DWwg
         lLjzqMHDpec6HF0Mde8gPjPEpYZl+iwJsJ7w9UiqtwJnvrP4UrXDrajThpZDBQq4teSy
         in0XU3Kk2Q3cA2eMgnk0u0gxrhST0FEeCBis8FYJK/HlEwnKoNvvHhkrLQNZ1irqTAmp
         KF+IfdCXszRIyrwed1xnuVIB9uLAEzmFyQLH9mkwlX7BreD73bigFuwqdV6BhUNoDsGI
         pjM5q07AZXmuzAbyONw3bkOmHrS6wb3vKHj89sKvWzPxE3wBj0u20EolZ9ic5rJvdtoE
         bkfg==
X-Gm-Message-State: APjAAAUo7s5fpIZqu7iMOxvPU84/wUCvBzTDPgLlrPvBmyj1l+//bd5p
        J7yCVx/lyzWpKr7JHEwLdgA=
X-Google-Smtp-Source: APXvYqzVq4iCgJd/Lx1PJ+8VJ8vyc8CKvZqkKAm7ULSEQMoLWy8hD3nK2S199WsLCrUXtW0rz6O59Q==
X-Received: by 2002:a17:90a:cc04:: with SMTP id b4mr5780707pju.136.1582912923087;
        Fri, 28 Feb 2020 10:02:03 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id l13sm3043467pjq.23.2020.02.28.10.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:02:01 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 4/5] hsr: remove unnecessary rcu_read_lock() in hsr module
Date:   Fri, 28 Feb 2020 18:01:56 +0000
Message-Id: <20200228180156.27841-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to access the port list, the hsr_port_get_hsr() is used.
And this is protected by RTNL and RCU.
The hsr_fill_info(), hsr_check_carrier(), hsr_dev_open() and
hsr_get_max_mtu() are protected by RTNL.
So, rcu_read_lock() in these functions are not necessary.
The hsr_handle_frame() also uses rcu_read_lock() but this function
is called by packet path.
It's already protected by RCU.
So, the rcu_read_lock() in hsr_handle_frame() can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c  | 23 +++++++----------------
 net/hsr/hsr_netlink.c | 27 +++++++++------------------
 net/hsr/hsr_slave.c   |  3 ---
 3 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index a48f621c2fec..00532d14fc7c 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -57,24 +57,19 @@ static void hsr_set_operstate(struct hsr_port *master, bool has_carrier)
 static bool hsr_check_carrier(struct hsr_port *master)
 {
 	struct hsr_port *port;
-	bool has_carrier;
 
-	has_carrier = false;
+	ASSERT_RTNL();
 
-	rcu_read_lock();
-	hsr_for_each_port(master->hsr, port)
+	hsr_for_each_port(master->hsr, port) {
 		if (port->type != HSR_PT_MASTER && is_slave_up(port->dev)) {
-			has_carrier = true;
-			break;
+			netif_carrier_on(master->dev);
+			return true;
 		}
-	rcu_read_unlock();
+	}
 
-	if (has_carrier)
-		netif_carrier_on(master->dev);
-	else
-		netif_carrier_off(master->dev);
+	netif_carrier_off(master->dev);
 
-	return has_carrier;
+	return false;
 }
 
 static void hsr_check_announce(struct net_device *hsr_dev,
@@ -118,11 +113,9 @@ int hsr_get_max_mtu(struct hsr_priv *hsr)
 	struct hsr_port *port;
 
 	mtu_max = ETH_DATA_LEN;
-	rcu_read_lock();
 	hsr_for_each_port(hsr, port)
 		if (port->type != HSR_PT_MASTER)
 			mtu_max = min(port->dev->mtu, mtu_max);
-	rcu_read_unlock();
 
 	if (mtu_max < HSR_HLEN)
 		return 0;
@@ -157,7 +150,6 @@ static int hsr_dev_open(struct net_device *dev)
 	hsr = netdev_priv(dev);
 	designation = '\0';
 
-	rcu_read_lock();
 	hsr_for_each_port(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
@@ -175,7 +167,6 @@ static int hsr_dev_open(struct net_device *dev)
 			netdev_warn(dev, "Slave %c (%s) is not up; please bring it up to get a fully working HSR network\n",
 				    designation, port->dev->name);
 	}
-	rcu_read_unlock();
 
 	if (designation == '\0')
 		netdev_warn(dev, "No slave devices configured\n");
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 7ed308a0c035..64d39c1e93a2 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -79,29 +79,20 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *port;
-	int res;
-
-	hsr = netdev_priv(dev);
-
-	res = 0;
 
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
-	if (port)
-		res = nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex);
-	rcu_read_unlock();
-	if (res)
-		goto nla_put_failure;
+	if (port) {
+		if (nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex))
+			goto nla_put_failure;
+	}
 
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
-	if (port)
-		res = nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex);
-	rcu_read_unlock();
-	if (res)
-		goto nla_put_failure;
+	if (port) {
+		if (nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex))
+			goto nla_put_failure;
+	}
 
 	if (nla_put(skb, IFLA_HSR_SUPERVISION_ADDR, ETH_ALEN,
 		    hsr->sup_multicast_addr) ||
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 127ebcc0e28f..07edc7f626fe 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -25,7 +25,6 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	rcu_read_lock(); /* hsr->node_db, hsr->ports */
 	port = hsr_port_get_rcu(skb->dev);
 	if (!port)
 		goto finish_pass;
@@ -45,11 +44,9 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	hsr_forward_skb(skb, port);
 
 finish_consume:
-	rcu_read_unlock(); /* hsr->node_db, hsr->ports */
 	return RX_HANDLER_CONSUMED;
 
 finish_pass:
-	rcu_read_unlock(); /* hsr->node_db, hsr->ports */
 	return RX_HANDLER_PASS;
 }
 
-- 
2.17.1

