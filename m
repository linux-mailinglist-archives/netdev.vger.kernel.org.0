Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695F8FEABE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 06:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfKPFpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 00:45:23 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41103 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfKPFpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 00:45:23 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so6954039pgv.8
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 21:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=/G7w5EobTTGuTYLN0ZTnGeuQwoMZaZgqgGUbbYwx+lg=;
        b=F0S/77FQEiKJz72xwxujfWgTIFZ9Mu02ZMmrFH6pZofyJ7tuIpPNf6PiUfhe1yfGe4
         fMZQu/qkn2x2Et3NUQJBrE5i0mzcJ/fjZfbemipw3K1WORUGOwG8GDwvKYgqbFbOygby
         i8kYGiw/z613le2uHzYR8qB2Ny7pDzd7dz4cPvKyuxZIgyS4tBZzLEl7/9qUwz6Fgi37
         01gJR8Sr8rScot8W9kJPeZ4hzVvYM7TSZhXHwrnrxnti+OkRLOpcXKVkyS5RijsZzAZH
         kB9GiNYTzMMa3G8J6i3+6IHTDrGmm2Sp7Sb5bllG7lhK/jpwJhcTy7SjOqmC84VzYDt4
         hRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=/G7w5EobTTGuTYLN0ZTnGeuQwoMZaZgqgGUbbYwx+lg=;
        b=SijXnJV+s9yY+bDx4cXbtY7CTiQsJL3LeJXt8mooEaP1UV6vdMkvQk33Lj90oAFIyn
         PLFqPsNDqNKqWFcbPxod9HFMiJNfvdmSa99+X2C9qK2hU/qBnllbjzQnaE9iXTZiXJ21
         7fBIjFwP/zrWvE+s6gxwLCMqRPMV2i8KKxGW2yTGe/YONho50v2FXVBF41M7XcDMhaC9
         a3dLSKPvLknJxSzZb4CvqxI8IhqUP513/CY0yj3SsdUlpcUWIYHYIlUrPNJs2of5XgId
         Hkwhv9QuQNrhioMCJX7Wi1Gal5elOXRZQN9gzEC1NXybMWZkm0BhDWLHG5MddTb633Y9
         ir+g==
X-Gm-Message-State: APjAAAV1m9MtFDBrFNW0QKbGG/yYaHTCc3P9T36GeYOl3aFOKglaSGSO
        /Bqhwev7TieZWvmZXuDRzy7R490l
X-Google-Smtp-Source: APXvYqz2FsiTp4yOvWr7YzAmFFUZVXmhFSdBnPuHHCRgMzr58MJ+pL4mp+N5mMCKxpwcGVVHXSLBTw==
X-Received: by 2002:a62:1c91:: with SMTP id c139mr21993847pfc.175.1573883120956;
        Fri, 15 Nov 2019 21:45:20 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id b82sm12512367pfb.33.2019.11.15.21.45.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 15 Nov 2019 21:45:20 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v3 net-next 2/2] Special handling for IP & MPLS.
Date:   Sat, 16 Nov 2019 11:15:08 +0530
Message-Id: <24ec93937d65fa2afc636a2887c78ae48736a649.1573872264.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1573872263.git.martin.varghese@nokia.com>
References: <cover.1573872263.git.martin.varghese@nokia.com>
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
    - Changed commit message.

Changes in v3:
    - Re-sending the patch.

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

