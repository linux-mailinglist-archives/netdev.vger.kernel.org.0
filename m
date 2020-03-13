Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF107183EF1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 03:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCMCFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 22:05:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42138 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgCMCFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 22:05:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id h8so4034245pgs.9
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 19:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IpVTh41d2rSBfzu7o/acWAoPFxrqBT4HVHUWc5LixT8=;
        b=pq6gwkB3LL+9PMBDh+YN0Um3aV8xlhbtFeQ+Yw9HZTof+7hmk4fMg4jV8zW927/hD+
         PeqZMSSuUNBcIv4xEQMyCUDLW7jQNXufB96FvzVW9Ez2NhiNhWreSWRVMmhlpwTWjvvY
         ETxwSV7CT69MxGbJEAUqeyc+Jx6lNYk4PHHa371DWcSKWVp5fP1EOI4lFKy5Ry5pJmxK
         0cHKOUnzxvzT0nKrjM1pSpHLn1Ot0ibZoTdH6PH7NFLp3JmYTgAi09NbUUG4M36wC3/A
         PsNW61V59uodbzsrqqtaSs3sUrEAfAC3GOR4VrLAqcQCVogxGoeuJcUU1S5sNX0C9rjG
         a8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IpVTh41d2rSBfzu7o/acWAoPFxrqBT4HVHUWc5LixT8=;
        b=dK5RG1XT6JsHJ+6uBBq11wBeEOS2pc1+Vrl99Hu3FEsjrLFAsuVtaKsCTMIHPaaSxM
         tF+PlWIujf68gjU5zZDbWm6FrP/0XHSiMp0qrPwWX28ggyaW5VBCisZtT++MII5qP5/x
         EhM5HsVgEtkAVSzW2omwWu1bGwAV37Uh9RwAzEaSa2CwLWavbRooxtZjpEQCVq0/SdHt
         H2nM8jbCEBqdG2z9PgtQVTHhFW+3uhubw/xwZc0PjsE1VNeJdYyEkX3CyobTIJlfStdV
         yfdOwjJhVv/OokXBkJ6gNOWjK2PmHde8WCvAEXtJezbEA0g26URYtTn82g56h7zb0YcF
         TEZw==
X-Gm-Message-State: ANhLgQ1/jz37K3rgEknzJGdz60sGB2o+W7CzKj6v6oPMuhaqOhJplRzT
        XOxB/j8Y1b9KmcMyajCNbW0=
X-Google-Smtp-Source: ADFU+vvZpJ/MWU5DNtP/qhoHbqTFJBEo8eO8640DEhRLOgy5gSVS2KX4rXCGQIra4+i2EFC3n6m1iQ==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr11473348pfh.124.1584065141326;
        Thu, 12 Mar 2020 19:05:41 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s19sm5562388pfh.218.2020.03.12.19.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:05:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/3] hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
Date:   Fri, 13 Mar 2020 02:05:30 +0000
Message-Id: <20200313020530.31435-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_get_node_{list/status}() are not under rtnl_lock() because
they are callback functions of generic netlink.
But they use __dev_get_by_index() without rtnl_lock().
So, it would use unsafe data.
In order to fix it, rcu_read_lock() and dev_get_by_index_rcu()
are used instead of __dev_get_by_index().

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_framereg.c |  9 ++-------
 net/hsr/hsr_netlink.c  | 39 +++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 3ba7f61be107..a64bb64935a6 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -482,12 +482,9 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 	struct hsr_port *port;
 	unsigned long tdiff;
 
-	rcu_read_lock();
 	node = find_node_by_addr_A(&hsr->node_db, addr);
-	if (!node) {
-		rcu_read_unlock();
-		return -ENOENT;	/* No such entry */
-	}
+	if (!node)
+		return -ENOENT;
 
 	ether_addr_copy(addr_b, node->macaddress_B);
 
@@ -522,7 +519,5 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 		*addr_b_ifindex = -1;
 	}
 
-	rcu_read_unlock();
-
 	return 0;
 }
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 8dc0547f01d0..d6760df2ad1f 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -251,15 +251,16 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	if (!na)
 		goto invalid;
 
-	hsr_dev = __dev_get_by_index(genl_info_net(info),
-				     nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	rcu_read_lock();
+	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
+				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
-		goto invalid;
+		goto rcu_unlock;
 	if (!is_hsr_master(hsr_dev))
-		goto invalid;
+		goto rcu_unlock;
 
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -313,12 +314,10 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
 				  port->dev->ifindex);
-	rcu_read_unlock();
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -328,20 +327,22 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
 				  port->dev->ifindex);
-	rcu_read_unlock();
 	if (res < 0)
 		goto nla_put_failure;
 
+	rcu_read_unlock();
+
 	genlmsg_end(skb_out, msg_head);
 	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
 
 	return 0;
 
+rcu_unlock:
+	rcu_read_unlock();
 invalid:
 	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
 	return 0;
@@ -351,6 +352,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	/* Fall through */
 
 fail:
+	rcu_read_unlock();
 	return res;
 }
 
@@ -377,15 +379,16 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	if (!na)
 		goto invalid;
 
-	hsr_dev = __dev_get_by_index(genl_info_net(info),
-				     nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	rcu_read_lock();
+	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
+				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
-		goto invalid;
+		goto rcu_unlock;
 	if (!is_hsr_master(hsr_dev))
-		goto invalid;
+		goto rcu_unlock;
 
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -405,14 +408,11 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 
 	hsr = netdev_priv(hsr_dev);
 
-	rcu_read_lock();
 	pos = hsr_get_next_node(hsr, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0) {
-			rcu_read_unlock();
+		if (res < 0)
 			goto nla_put_failure;
-		}
 		pos = hsr_get_next_node(hsr, pos, addr);
 	}
 	rcu_read_unlock();
@@ -422,6 +422,8 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 
 	return 0;
 
+rcu_unlock:
+	rcu_read_unlock();
 invalid:
 	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
 	return 0;
@@ -431,6 +433,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	/* Fall through */
 
 fail:
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.17.1

