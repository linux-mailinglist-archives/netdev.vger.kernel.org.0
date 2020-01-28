Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76F114BE2F
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA1Q6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 11:58:17 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33178 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgA1Q6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 11:58:17 -0500
Received: by mail-pj1-f66.google.com with SMTP id m7so803660pjs.0
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 08:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yiJMx6YCNWAp8K4UQCV7jVMHH7hb9NBIB/Oqu2uv3HA=;
        b=UyGRpY5NYJoLwZcxuLyqDFEx33np+vLjyUqGE+QFrMAAz4GFvOtuIJgmt2suD14ljF
         jt//24fZGuBaBO1RVQMQJmk7uALOXlA4MkTcjw4ywq4Vw/57QuaAIYvQrERrM1nIJRTt
         6NzIsz822aceU1GiyfxJZhlihlZOmcVL/h79wGyYYIG+S/rcEGSowN/F2giGsGsr5VAI
         e9aWn0jtDt1u0kjUVkELe1mzoaKmu0oCZNy7dDrlmOdTyunYMejoYbpNPDT2m4cIiHZH
         vKeRZE5UR9UN75hxzClDU3NPwLxvNqvxMBKi0AiK2WzjkPtjj0ytr6lV1NBadaGcDfIp
         xALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yiJMx6YCNWAp8K4UQCV7jVMHH7hb9NBIB/Oqu2uv3HA=;
        b=dXT9JnGATBqBEDPJWcBRUWug3Z1BOBft4v1kjQ9uBB8cdAbIyV8wJHXMsnXqOooKt0
         QHqT6Mh1UiC+4raf8XFw9oYPBLMc9pxN3K53PSKdYHn8lW1Wf3TxtID2HFQoS5Jh1ojb
         NYyBEWCrvdj9c8jBfqpTdQX6P8DV4vuKvQXOQJNfj7uOmt3ETKI3ZEbqshG4qACRekWc
         9tAn+fxsDdkEZRKzA/SgZ1p59AMZ/WL26GzXNvC7qB5Y7aiMgTL7Q8odiUr3sIdA7zIB
         NrJ+O/lt3tH1QByqRKneGuqCZvnrhwENE4kqZWcqLQBlUpCm1T9fqeT3pTxR0tXVUd26
         vjWA==
X-Gm-Message-State: APjAAAU72WjjnRMLJG1kR/nuypY4KMdaAWWYKAImJVbdcHorOQgsnCFD
        iS7s1fnLeGtPXW834eFQ+aeFmshD
X-Google-Smtp-Source: APXvYqysuR1bZAZJInOb+57N16eLrlLXgBhZjCYeBCn0DyuKKtCvHTNye5J6mxXkVUvTm32W2hyEyA==
X-Received: by 2002:a17:90a:cc02:: with SMTP id b2mr5521754pju.137.1580230696485;
        Tue, 28 Jan 2020 08:58:16 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id x8sm3084780pfr.104.2020.01.28.08.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 Jan 2020 08:58:15 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v6 2/2] net: Special handling for IP & MPLS.
Date:   Tue, 28 Jan 2020 22:28:03 +0530
Message-Id: <1b6ec1eda948bba711cae138b74cba0711e18674.1580205811.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1580205811.git.martin.varghese@nokia.com>
References: <cover.1580205811.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Special handling is needed in bareudp module for IP & MPLS as they
support more than one ethertypes.

MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
While decapsulating MPLS packet from UDP packet the tunnel destination IP
address is checked to determine the ethertype. The ethertype of the packet
will be set to 0x8848 if the  tunnel destination IP address is a multicast
IP address. The ethertype of the packet will be set to 0x8847 if the
tunnel destination IP address is a unicast IP address.

IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version
field of the IP header tunnelled will be checked to determine the ethertype.

This special handling to tunnel additional ethertypes will be disabled
by default and can be enabled using a flag called multiproto. This flag can
be used only with ethertypes 0x8847 and 0x0800.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
Changes in v2:
    - Fixed documentation errors.
    - Changed commit message.

Changes in v3:
    - Re-sending the patch.

Changes in v4:
    - Renamed extmode flag to multiproto
    - Fixed typo in description.

Changes in v5:
    - Mention about extmode is changed in multiproto in commit msg.
    - Ack from Willem added.

Changes in v6:
    - Sending Again.

 Documentation/networking/bareudp.rst | 20 ++++++++++-
 drivers/net/bareudp.c                | 67 ++++++++++++++++++++++++++++++++++--
 include/net/bareudp.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 4 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 4087a1b..9794dd8 100644
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
+IP protocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
+This special handling can be enabled only for ethertypes ETH_P_IP & ETH_P_MPLS_UC
+with a flag called multiproto mode.
+
 Usage
 ------
 
@@ -25,7 +34,16 @@ Usage
 
     b) ip link delete bareudp0
 
-2) Device Usage
+2) Device creation with multiple proto mode enabled
+
+There are two ways to create a bareudp device for MPLS & IP with multiproto mode
+enabled.
+
+    a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 multiproto
+
+    b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
+
+3) Device Usage
 
 The bareudp device could be used along with OVS or flower filter in TC.
 The OVS or TC flower layer must set the tunnel information in SKB dst field before
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 0338160..88cef80 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -45,6 +45,7 @@ struct bareudp_dev {
 	__be16		   ethertype;
 	__be16             port;
 	u16	           sport_min;
+	bool               multi_proto_mode;
 	struct socket      __rcu *sock;
 	struct list_head   next;        /* bareudp node  on namespace list */
 	struct gro_cells   gro_cells;
@@ -70,7 +71,52 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	else
 		family = AF_INET6;
 
-	proto = bareudp->ethertype;
+	if (bareudp->ethertype == htons(ETH_P_IP)) {
+		struct iphdr *iphdr;
+
+		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
+		if (iphdr->version == 4) {
+			proto = bareudp->ethertype;
+		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
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
+			} else if (bareudp->multi_proto_mode &&
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
+			} else if (bareudp->multi_proto_mode &&
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
 				 proto,
@@ -370,8 +416,12 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err;
 
 	if (skb->protocol != bareudp->ethertype) {
-		err = -EINVAL;
-		goto tx_error;
+		if (!bareudp->multi_proto_mode ||
+		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
+		     skb->protocol !=  htons(ETH_P_IPV6))) {
+			err = -EINVAL;
+			goto tx_error;
+		}
 	}
 
 	info = skb_tunnel_info(skb);
@@ -462,6 +512,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 	[IFLA_BAREUDP_PORT]                = { .type = NLA_U16 },
 	[IFLA_BAREUDP_ETHERTYPE]	   = { .type = NLA_U16 },
 	[IFLA_BAREUDP_SRCPORT_MIN]         = { .type = NLA_U16 },
+	[IFLA_BAREUDP_MULTIPROTO_MODE]     = { .type = NLA_FLAG },
 };
 
 /* Info for udev, that this is a virtual tunnel endpoint */
@@ -544,9 +595,15 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	if (t)
 		return -EBUSY;
 
+	if (conf->multi_proto_mode &&
+	    (conf->ethertype != htons(ETH_P_MPLS_UC) &&
+	     conf->ethertype != htons(ETH_P_IP)))
+		return -EINVAL;
+
 	bareudp->port = conf->port;
 	bareudp->ethertype = conf->ethertype;
 	bareudp->sport_min = conf->sport_min;
+	bareudp->multi_proto_mode = conf->multi_proto_mode;
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -603,6 +660,7 @@ static size_t bareudp_get_size(const struct net_device *dev)
 	return  nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_PORT */
 		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
 		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
+		nla_total_size(0)              +  /* IFLA_BAREUDP_MULTIPROTO_MODE */
 		0;
 }
 
@@ -616,6 +674,9 @@ static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		goto nla_put_failure;
 	if (nla_put_u16(skb, IFLA_BAREUDP_SRCPORT_MIN, bareudp->sport_min))
 		goto nla_put_failure;
+	if (bareudp->multi_proto_mode &&
+	    nla_put_flag(skb, IFLA_BAREUDP_MULTIPROTO_MODE))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index 513fae6..cb03f6f 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -10,6 +10,7 @@ struct bareudp_conf {
 	__be16 ethertype;
 	__be16 port;
 	u16 sport_min;
+	bool multi_proto_mode;
 };
 
 struct net_device *bareudp_dev_create(struct net *net, const char *name,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index fb4b33a..61e0801 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -596,6 +596,7 @@ enum {
 	IFLA_BAREUDP_PORT,
 	IFLA_BAREUDP_ETHERTYPE,
 	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_MULTIPROTO_MODE,
 	__IFLA_BAREUDP_MAX
 };
 
-- 
1.8.3.1

