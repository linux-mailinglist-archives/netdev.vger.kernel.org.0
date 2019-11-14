Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143E0FC9C7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfKNPV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:21:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43343 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfKNPV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:21:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id a18so2754092plm.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=tZVvvQ84aQcIMqaemf5cQ0xlNg70D/y9ZTT7aWGw/jI=;
        b=k8TQ5h40b60YyHuxuvI3Jmf6Geaw041oKC2SnyarjQ6WDjWUFV1LWOMYAiu1ytJ8kb
         zYXyFosLaHs1+pXIcxkILZ3kWq70L7OgJLPw3P8Afu0pFOtrz0YPN8R1rK+qVLF0aqUI
         jSAevPXK5og/MnWAXWyPWlmVeIQjgJAp08nsC6ENKhG4qKQvi0vXa3HswXa4XkHrePNz
         gP07SLLekRmVnrMIaGkyizHHPaCfm9cKnZdFb5yDCtD2VwtUD2C5aZvXnyZXebOmRFi5
         Ol4/fr10EN3DDjIYcbOLHkN3sidRAPXJDL/JYK8Pg50YM59Ujs59gOJF7WtqQl5SQ6Kb
         b8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=tZVvvQ84aQcIMqaemf5cQ0xlNg70D/y9ZTT7aWGw/jI=;
        b=SCvOPnwxudZIYeEPgiw7liRNtYcFmtv+I12LqAnROkuBvzNRpg9sDjtl9+RJk3p5BS
         pCTFJicnXXNZ7cl7+OZudNxyoiwEQ7tBiSL3DjLqrp5Fz0/CY6uz4/IHhE3MMii4IGXG
         ohZg1UXVzVsLxT641YkbfpNNQaQO/pxvALIulPXb5asETFRAOOCpGGYF1NVhQN/de6Bk
         8gHZm0gxH/LEyDcU4zJdCF/F6pK8Pn3q4iEAV1x+QhyPrG8KBhp0yQVikwshl6JGa3iw
         k4SN28Ee07ThssKmZY8TSP4pGQ5ntMgaK5yTFIg3W0F3wIkD0mc2HCwiVAzEjuj1JTto
         jcyg==
X-Gm-Message-State: APjAAAUAsz3KA3tuDXYzJfQJOOydQDxLBryQckha6ZHy91BCEz5kwRYS
        j9biD/2RdJ+87+khLx6xr40qbYF2
X-Google-Smtp-Source: APXvYqzqLSCMhu/SywlXbVVENeUSR0XdL80ZjU9DRfqEpplVx6YQxVc4+NsW13wRv23w5SsMgFA4uw==
X-Received: by 2002:a17:902:8606:: with SMTP id f6mr9777452plo.74.1573744884896;
        Thu, 14 Nov 2019 07:21:24 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id u7sm5885546pjx.19.2019.11.14.07.21.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 07:21:23 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next 2/2] Special handling for IP & MPLS.
Date:   Thu, 14 Nov 2019 20:49:58 +0530
Message-Id: <24ec93937d65fa2afc636a2887c78ae48736a649.1573659466.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1573659466.git.martin.varghese@nokia.com>
References: <cover.1573659466.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Special handling is needed in bareudp module for IP & MPLS as they support
more than one ethertypes.

MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
While decapsulating MPLS packet from UDP packet the tunnel destination IP
address is checked to determine the ethertype. The ethertype of the packet
will be set to 0x8848 if the  tunnel destination IP address is a multicast
IP address. The ethertype of the packet will be set to 0x8847 if the
tunnel destination IP address is a unicast IP address.

IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version field
of the IP header tunnelled will be checked to determine the ethertype.

This special handling to tunnel additional ethertypes will be disabled by
default and can be enabled using a flag called ext mode. This flag can be
used only with ethertypes 0x8847 and 0x0800.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
    - Fixed documentation errors.
    - Changed commit message

 Documentation/networking/bareudp.rst | 18 ++++++++
 drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
 include/net/bareudp.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 4 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 2828521..1f01dfd 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -12,6 +12,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
 support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
 a UDP tunnel.
 
+Special Handling
+----------------
+The bareudp device supports special handling for MPLS & IP as they can have
+multiple ethertypes.
+MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
+IP proctocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
+This special handling can be enabled only for ethertypes ETH_P_IP & ETH_P_MPLS_UC
+with a flag called extended mode.
+
 Usage
 ------
 
@@ -24,3 +33,12 @@ Usage
        6635.The device will listen on UDP port 6635 to receive traffic.
 
     b) ip link delete bareudp0
+
+2) Device creation with extended mode enabled
+
+There are two ways to create a bareudp device for MPLS & IP with extended mode
+enabled.
+
+    a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode
+
+    b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 5a8e64a..636127a 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -50,6 +50,7 @@ struct bareudp_dev {
 	struct net_device  *dev;        /* netdev for bareudp tunnel */
 	__be16		   ethertype;
 	u16	           sport_min;
+	bool               ext_mode;
 	struct bareudp_conf conf;
 	struct bareudp_sock __rcu *sock;
 	struct list_head   next;        /* bareudp node  on namespace list */
@@ -81,15 +82,64 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	bareudp = bs->bareudp;
-	proto = bareudp->ethertype;
+	if (!bareudp)
+		goto drop;
+
+	if (bareudp->ethertype == htons(ETH_P_IP)) {
+		struct iphdr *iphdr;
+
+		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
+		if (iphdr->version == 4) {
+			proto = bareudp->ethertype;
+		} else if (bareudp->ext_mode && (iphdr->version == 6)) {
+			proto = htons(ETH_P_IPV6);
+		} else {
+			bareudp->dev->stats.rx_dropped++;
+			goto drop;
+		}
+	} else if (bareudp->ethertype == htons(ETH_P_MPLS_UC)) {
+		struct iphdr *tunnel_hdr;
+
+		tunnel_hdr = (struct iphdr *)skb_network_header(skb);
+		if (tunnel_hdr->version == 4) {
+			if (!ipv4_is_multicast(tunnel_hdr->daddr)) {
+				proto = bareudp->ethertype;
+			} else if (bareudp->ext_mode &&
+				   ipv4_is_multicast(tunnel_hdr->daddr)) {
+				proto = htons(ETH_P_MPLS_MC);
+			} else {
+				bareudp->dev->stats.rx_dropped++;
+				goto drop;
+			}
+		} else {
+			int addr_type;
+			struct ipv6hdr *tunnel_hdr_v6;
+
+			tunnel_hdr_v6 = (struct ipv6hdr *)skb_network_header(skb);
+			addr_type =
+			ipv6_addr_type((struct in6_addr *)&tunnel_hdr_v6->daddr);
+			if (!(addr_type & IPV6_ADDR_MULTICAST)) {
+				proto = bareudp->ethertype;
+			} else if (bareudp->ext_mode &&
+				   (addr_type & IPV6_ADDR_MULTICAST)) {
+				proto = htons(ETH_P_MPLS_MC);
+			} else {
+				bareudp->dev->stats.rx_dropped++;
+				goto drop;
+			}
+		}
+	} else {
+		proto = bareudp->ethertype;
+	}
 
 	if (iptunnel_pull_header(skb, BAREUDP_BASE_HLEN,
-				 proto,
-				 !net_eq(bareudp->net,
-					 dev_net(bareudp->dev)))) {
+				proto,
+				!net_eq(bareudp->net,
+					dev_net(bareudp->dev)))) {
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
 	}
+
 	tun_dst = udp_tun_rx_dst(skb, bareudp_get_sk_family(bs), TUNNEL_KEY,
 				 0, 0);
 	if (!tun_dst) {
@@ -421,10 +471,13 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err;
 
 	if (skb->protocol != bareudp->ethertype) {
-		err = -EINVAL;
-		goto tx_error;
+		if (!bareudp->ext_mode ||
+		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
+		     skb->protocol !=  htons(ETH_P_IPV6))) {
+			err = -EINVAL;
+			goto tx_error;
+		}
 	}
-
 	info = skb_tunnel_info(skb);
 	if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
 		err = -EINVAL;
@@ -520,6 +573,7 @@ static int bareudp_change_mtu(struct net_device *dev, int new_mtu)
 	[IFLA_BAREUDP_PORT]                = { .type = NLA_U16 },
 	[IFLA_BAREUDP_ETHERTYPE]	   = { .type = NLA_U16 },
 	[IFLA_BAREUDP_SRCPORT_MIN]         = { .type = NLA_U16 },
+	[IFLA_BAREUDP_EXTMODE]             = { .type = NLA_FLAG },
 };
 
 static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -602,9 +656,15 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	if (t)
 		return -EBUSY;
 
+	if (conf->ext_mode &&
+	    (conf->ethertype != htons(ETH_P_MPLS_UC) &&
+	     conf->ethertype != htons(ETH_P_IP)))
+		return -EINVAL;
+
 	bareudp->conf = *conf;
 	bareudp->ethertype = conf->ethertype;
 	bareudp->sport_min = conf->sport_min;
+	bareudp->ext_mode = conf->ext_mode;
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -627,6 +687,11 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf)
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
 
+	if (data[IFLA_BAREUDP_EXTMODE])
+		conf->ext_mode = true;
+	else
+		conf->ext_mode = false;
+
 	return 0;
 }
 
@@ -669,6 +734,7 @@ static size_t bareudp_get_size(const struct net_device *dev)
 	return  nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_PORT */
 		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
 		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
+		nla_total_size(0)              +  /* IFLA_BAREUDP_EXTMODE */
 		0;
 }
 
@@ -682,6 +748,8 @@ static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		goto nla_put_failure;
 	if (nla_put_u16(skb, IFLA_BAREUDP_SRCPORT_MIN, bareudp->conf.sport_min))
 		goto nla_put_failure;
+	if (bareudp->ext_mode && nla_put_flag(skb, IFLA_BAREUDP_EXTMODE))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index 513fae6..2c121d8 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -10,6 +10,7 @@ struct bareudp_conf {
 	__be16 ethertype;
 	__be16 port;
 	u16 sport_min;
+	bool ext_mode;
 };
 
 struct net_device *bareudp_dev_create(struct net *net, const char *name,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 012f7e8..2b91c872 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -586,6 +586,7 @@ enum {
 	IFLA_BAREUDP_PORT,
 	IFLA_BAREUDP_ETHERTYPE,
 	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_EXTMODE,
 	__IFLA_BAREUDP_MAX
 };
 
-- 
1.8.3.1

