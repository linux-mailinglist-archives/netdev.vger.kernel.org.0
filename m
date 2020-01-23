Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3C9147046
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAWSEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:04:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45546 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWSEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:04:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so1657767pls.12
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=kB2pUOeMusMy1aY3K5mMtEUdzcWJ8rqoZU9/O2To404=;
        b=DEEpj0GTGJLTdjk+lQWfC7wwmfr+HSzMOTqkt+4amGXZZaZDwtNX9gb0qRg36bPVaX
         V8AzgMMPSB1bU9DqS+jjPI6hXyBBs2ujWWbIDj2rqEfNgGMJOoh1J9sGCbOyFLWqEcDL
         oFTbWtthoA/dOqZCfWYhBJNfqfVGUJ9s75ZuMgG7CQ2Mryy8uYJVREQEQVjR1JwfjdfW
         u3uBZOcwVUR9mfxm3I5zsSUITEI7Jts8b2N8+QEX/iAN6Na1kMPM6++jNqwLrSmcwQU8
         JiJecDnnl4t7LEBuOFcSEbPs1VQzuKtDimBXjjs49U40wqk+Sr0CmnjJFt8Nywd3BgB6
         Sa7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=kB2pUOeMusMy1aY3K5mMtEUdzcWJ8rqoZU9/O2To404=;
        b=LGITFJioNjfcsYJeFtllx8laTBclGbPLSeb6tXkzX30T/y4/xI5f3RICijiB9EIEsE
         RaR6CaQYezwfiLHFDOKAW/D4IuTViVY3P5FbSEBm65dzaYSHcHwJ3YTifgFO+lIHOm5k
         Mth6S4D4x1RghxGUXxuQrpKSPTjoIF9wtpmiDmQVm0ODxMduZ5XOC06EPT0t/4moBd8H
         0iaDsWXywrj7qLq+zFW2uZW4mgtaACPUE7CKBn6ZxuxYNoVPdtYBWRYqwdnLP+v8bIKN
         u890hnhrQ2xh8ZC7VE3XFj3Kalu/plrAhwyi0iA+h0xrztKGuXj3onAVIsCHBY7yt2mD
         en9g==
X-Gm-Message-State: APjAAAUZalF/xn5HQAw9STGjJGNc8MCjCaPF/wuclX3aBmkdeGYOMtWy
        TAU1yuqHmJsD6e6+m3SnrCGPmtj7
X-Google-Smtp-Source: APXvYqzEKEqHOGXqtKaAe6Yar8uWRcBpnzI7ID5v9QUE7lK4RKxf7LbccBvXk1+MtTez/jJIBJ+cIA==
X-Received: by 2002:a17:90a:6484:: with SMTP id h4mr5566030pjj.84.1579802663257;
        Thu, 23 Jan 2020 10:04:23 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id w131sm3545485pfc.16.2020.01.23.10.04.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 10:04:22 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS,IP,NSH etc.
Date:   Thu, 23 Jan 2020 23:34:15 +0530
Message-Id: <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1579798999.git.martin.varghese@nokia.com>
References: <cover.1579798999.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The Bareudp tunnel module provides a generic L3 encapsulation
tunnelling module for tunnelling different protocols like MPLS,
IP,NSH etc inside a UDP tunnel.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
     - Fixed documentation errors.
     - Converted documentation to rst format.
     - Moved ip tunnel rt lookup code to a common location.
     - Removed seperate v4 and v6 socket.
     - Added call to skb_ensure_writable before updating ethernet header.
     - Simplified bareudp_destroy_tunnels as deleting devices under a
       namespace is taken care be the default pernet exit code.
     - Fixed bareudp_change_mtu.

Changes in v3:
     - Re-sending the patch again.

Changes in v4:
     - Converted bareudp device to l3 device.
     - Removed redundant fields in bareudp device.
     - Added device usage section in documentation

Changes in v5:
     - Modified version 4 change log
     - Added Select NET_UDP_TUNNEL in Bareudp config section
     - Fixed bareudp index position in documentation index file.
     - 1500 changed to ETH_DATA_LEN while setting MTU field.
     - Replaced bareudp_change_mtu with core function dev_set_mtu.
     - Removed udp header present redundant check in recv.


 Documentation/networking/bareudp.rst |  35 ++
 Documentation/networking/index.rst   |   1 +
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 740 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  19 +
 include/net/ip6_tunnel.h             |  50 +++
 include/net/ip_tunnels.h             |  47 +++
 include/uapi/linux/if_link.h         |  11 +
 9 files changed, 917 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
new file mode 100644
index 0000000..4087a1b
--- /dev/null
+++ b/Documentation/networking/bareudp.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================================
+Bare UDP Tunnelling Module Documentation
+========================================
+
+There are various L3 encapsulation standards using UDP being discussed to
+leverage the UDP based load balancing capability of different networks.
+MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.
+
+The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
+support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
+a UDP tunnel.
+
+Usage
+------
+
+1) Device creation & deletion
+
+    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.
+
+       This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
+       0x8847 (MPLS traffic). The destination port of the UDP header will be set to
+       6635.The device will listen on UDP port 6635 to receive traffic.
+
+    b) ip link delete bareudp0
+
+2) Device Usage
+
+The bareudp device could be used along with OVS or flower filter in TC.
+The OVS or TC flower layer must set the tunnel information in SKB dst field before
+sending packet buffer to the bareudp device for transmission. On reception the
+bareudp device extracts and stores the tunnel information in SKB dst field before
+passing the packet buffer to the network stack.
+
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index d07d985..3a83cfb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -8,6 +8,7 @@ Contents:
 
    netdev-FAQ
    af_xdp
+   bareudp
    batman-adv
    can
    can_ucan_protocol
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dee7958..aa722f4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -258,6 +258,19 @@ config GENEVE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geneve.
 
+config BAREUDP
+       tristate "Bare UDP Encapsulation"
+       depends on INET
+       depends on IPV6 || !IPV6
+       select NET_UDP_TUNNEL
+       select GRO_CELLS
+       help
+          This adds a bare UDP tunnel module for tunnelling different
+          kinds of traffic like MPLS, IP, etc. inside a UDP tunnel.
+
+          To compile this driver as a module, choose M here: the module
+          will be called bareudp.
+
 config GTP
 	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
 	depends on INET
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 953b7c1..567b1aa49 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_VETH) += veth.o
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
 obj-$(CONFIG_VXLAN) += vxlan.o
 obj-$(CONFIG_GENEVE) += geneve.o
+obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
new file mode 100644
index 0000000..99c0b5a
--- /dev/null
+++ b/drivers/net/bareudp.c
@@ -0,0 +1,740 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Bareudp: UDP  tunnel encasulation for different Payload types like
+ * MPLS, NSH, IP, etc.
+ * Copyright (c) 2019 Nokia, Inc.
+ * Authors:  Martin Varghese, <martin.varghese@nokia.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/etherdevice.h>
+#include <linux/hash.h>
+#include <net/dst_metadata.h>
+#include <net/gro_cells.h>
+#include <net/rtnetlink.h>
+#include <net/protocol.h>
+#include <net/ip6_tunnel.h>
+#include <net/ip_tunnels.h>
+#include <net/udp_tunnel.h>
+#include <net/bareudp.h>
+
+#define BAREUDP_BASE_HLEN sizeof(struct udphdr)
+#define BAREUDP_IPV4_HLEN (sizeof(struct iphdr) + \
+			   sizeof(struct udphdr))
+#define BAREUDP_IPV6_HLEN (sizeof(struct ipv6hdr) + \
+			   sizeof(struct udphdr))
+
+static bool log_ecn_error = true;
+module_param(log_ecn_error, bool, 0644);
+MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
+
+/* per-network namespace private data for this module */
+
+static unsigned int bareudp_net_id;
+
+struct bareudp_net {
+	struct list_head        bareudp_list;
+};
+
+/* Pseudo network device */
+struct bareudp_dev {
+	struct net         *net;        /* netns for packet i/o */
+	struct net_device  *dev;        /* netdev for bareudp tunnel */
+	__be16		   ethertype;
+	__be16             port;
+	u16	           sport_min;
+	struct socket      __rcu *sock;
+	struct list_head   next;        /* bareudp node  on namespace list */
+	struct gro_cells   gro_cells;
+};
+
+static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
+{
+	struct bareudp_dev *bareudp;
+	struct metadata_dst *tun_dst = NULL;
+	struct pcpu_sw_netstats *stats;
+	unsigned int len;
+	int err = 0;
+	void *oiph;
+	__be16 proto;
+	unsigned short family;
+
+	bareudp = rcu_dereference_sk_user_data(sk);
+	if (!bareudp)
+		goto drop;
+
+	if (skb->protocol ==  htons(ETH_P_IP))
+		family = AF_INET;
+	else
+		family = AF_INET6;
+
+	proto = bareudp->ethertype;
+
+	if (iptunnel_pull_header(skb, BAREUDP_BASE_HLEN,
+				 proto,
+				 !net_eq(bareudp->net,
+				 dev_net(bareudp->dev)))) {
+		bareudp->dev->stats.rx_dropped++;
+		goto drop;
+	}
+
+	tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
+	if (!tun_dst) {
+		bareudp->dev->stats.rx_dropped++;
+		goto drop;
+	}
+	skb_dst_set(skb, &tun_dst->dst);
+	skb->dev = bareudp->dev;
+	oiph = skb_network_header(skb);
+	skb_reset_network_header(skb);
+
+	if (family == AF_INET)
+		err = IP_ECN_decapsulate(oiph, skb);
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		err = IP6_ECN_decapsulate(oiph, skb);
+#endif
+
+	if (unlikely(err)) {
+		if (log_ecn_error) {
+			if  (family == AF_INET)
+				net_info_ratelimited("non-ECT from %pI4 "
+						     "with TOS=%#x\n",
+						     &((struct iphdr *)oiph)->saddr,
+						     ((struct iphdr *)oiph)->tos);
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				net_info_ratelimited("non-ECT from %pI6\n",
+						     &((struct ipv6hdr *)oiph)->saddr);
+#endif
+		}
+		if (err > 1) {
+			++bareudp->dev->stats.rx_frame_errors;
+			++bareudp->dev->stats.rx_errors;
+			goto drop;
+		}
+	}
+
+	len = skb->len;
+	err = gro_cells_receive(&bareudp->gro_cells, skb);
+	if (likely(err == NET_RX_SUCCESS)) {
+		stats = this_cpu_ptr(bareudp->dev->tstats);
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_packets++;
+		stats->rx_bytes += len;
+		u64_stats_update_end(&stats->syncp);
+	}
+	return 0;
+drop:
+	/* Consume bad packet */
+	kfree_skb(skb);
+
+	return 0;
+}
+
+static int bareudp_err_lookup(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
+
+static int bareudp_init(struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+	int err;
+
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
+	err = gro_cells_init(&bareudp->gro_cells, dev);
+	if (err) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+	return 0;
+}
+
+static void bareudp_uninit(struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	gro_cells_destroy(&bareudp->gro_cells);
+	free_percpu(dev->tstats);
+}
+
+static struct socket *bareudp_create_sock(struct net *net, __be16 port)
+{
+	struct socket *sock;
+	struct udp_port_cfg udp_conf;
+	int err;
+
+	memset(&udp_conf, 0, sizeof(udp_conf));
+#if IS_ENABLED(CONFIG_IPV6)
+	udp_conf.family = AF_INET6;
+#else
+	udp_conf.family = AF_INET;
+#endif
+	udp_conf.local_udp_port = port;
+	/* Open UDP socket */
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	return sock;
+}
+
+/* Create new listen socket if needed */
+static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
+{
+	struct socket *sock;
+	struct udp_tunnel_sock_cfg tunnel_cfg;
+
+	sock = bareudp_create_sock(bareudp->net, port);
+	if (IS_ERR(sock))
+		return PTR_ERR(sock);
+
+	/* Mark socket as an encapsulation socket */
+	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
+	tunnel_cfg.sk_user_data = bareudp;
+	tunnel_cfg.encap_type = 1;
+	tunnel_cfg.encap_rcv = bareudp_udp_encap_recv;
+	tunnel_cfg.encap_err_lookup = bareudp_err_lookup;
+	tunnel_cfg.encap_destroy = NULL;
+	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
+
+	if (sock->sk->sk_family == AF_INET6)
+		udp_encap_enable();
+
+	rcu_assign_pointer(bareudp->sock, sock);
+	return 0;
+}
+
+static int bareudp_open(struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+	int ret = 0;
+
+	ret =  bareudp_socket_create(bareudp, bareudp->port);
+	return ret;
+}
+
+static void bareudp_sock_release(struct bareudp_dev *bareudp)
+{
+	struct socket *sock;
+
+	sock = bareudp->sock;
+	rcu_assign_pointer(bareudp->sock, NULL);
+	synchronize_net();
+	udp_tunnel_sock_release(sock);
+}
+
+static int bareudp_stop(struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	bareudp_sock_release(bareudp);
+	return 0;
+}
+
+static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
+			    struct bareudp_dev *bareudp,
+			    const struct ip_tunnel_info *info)
+{
+	bool xnet = !net_eq(bareudp->net, dev_net(bareudp->dev));
+	struct socket *sock = rcu_dereference(bareudp->sock);
+	const struct ip_tunnel_key *key = &info->key;
+	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
+	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
+	int err;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	__u8 tos, ttl;
+	__be16 sport;
+	__be16 df;
+	int min_headroom;
+
+	if (!sock)
+		return -ESHUTDOWN;
+
+	rt = iptunnel_get_rt(skb, dev, bareudp->net, &fl4, info,
+			     use_cache);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	skb_tunnel_check_pmtu(skb, &rt->dst,
+			      BAREUDP_IPV4_HLEN + info->options_len);
+
+	sport = udp_flow_src_port(bareudp->net, skb,
+				  bareudp->sport_min, USHRT_MAX,
+				  true);
+	tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
+	ttl = key->ttl;
+	df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
+	skb_scrub_packet(skb, xnet);
+
+	if (!skb_pull(skb, skb_network_offset(skb)))
+		goto free_dst;
+
+	min_headroom = LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len +
+		BAREUDP_BASE_HLEN + info->options_len + sizeof(struct iphdr);
+
+	err = skb_cow_head(skb, min_headroom);
+	if (unlikely(err))
+		goto free_dst;
+
+	err = udp_tunnel_handle_offloads(skb, udp_sum);
+	if (err)
+		goto free_dst;
+
+	skb_set_inner_protocol(skb, bareudp->ethertype);
+	udp_tunnel_xmit_skb(rt, sock->sk, skb, fl4.saddr, fl4.daddr,
+			    tos, ttl, df, sport, bareudp->port,
+			    !net_eq(bareudp->net, dev_net(bareudp->dev)),
+			    !(info->key.tun_flags & TUNNEL_CSUM));
+	return 0;
+
+free_dst:
+	dst_release(&rt->dst);
+	return err;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
+			     struct bareudp_dev *bareudp,
+			     const struct ip_tunnel_info *info)
+{
+	bool xnet = !net_eq(bareudp->net, dev_net(bareudp->dev));
+	struct socket *sock  = rcu_dereference(bareudp->sock);
+	const struct ip_tunnel_key *key = &info->key;
+	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
+	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
+	struct dst_entry *dst = NULL;
+	struct flowi6 fl6;
+	__u8 prio, ttl;
+	__be16 sport;
+	int min_headroom;
+	int err;
+
+	if (!sock)
+		return -ESHUTDOWN;
+
+	dst = ip6tunnel_get_dst(skb, dev, bareudp->net, sock, &fl6, info,
+				use_cache);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	skb_tunnel_check_pmtu(skb, dst, BAREUDP_IPV6_HLEN + info->options_len);
+
+	sport = udp_flow_src_port(bareudp->net, skb,
+				  bareudp->sport_min, USHRT_MAX,
+				  true);
+	prio = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
+	ttl = key->ttl;
+
+	skb_scrub_packet(skb, xnet);
+
+	if (!skb_pull(skb, skb_network_offset(skb)))
+		goto free_dst;
+
+	min_headroom = LL_RESERVED_SPACE(dst->dev) + dst->header_len +
+		BAREUDP_BASE_HLEN + info->options_len + sizeof(struct iphdr);
+
+	err = skb_cow_head(skb, min_headroom);
+	if (unlikely(err))
+		goto free_dst;
+
+	err = udp_tunnel_handle_offloads(skb, udp_sum);
+	if (err)
+		goto free_dst;
+
+	udp_tunnel6_xmit_skb(dst, sock->sk, skb, dev,
+			     &fl6.saddr, &fl6.daddr, prio, ttl,
+			     info->key.label, sport, bareudp->port,
+			     !(info->key.tun_flags & TUNNEL_CSUM));
+	return 0;
+
+free_dst:
+	dst_release(dst);
+	return err;
+}
+#endif
+
+static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+	struct ip_tunnel_info *info = NULL;
+	int err;
+
+	if (skb->protocol != bareudp->ethertype) {
+		err = -EINVAL;
+		goto tx_error;
+	}
+
+	info = skb_tunnel_info(skb);
+	if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
+		err = -EINVAL;
+		goto tx_error;
+	}
+
+	rcu_read_lock();
+#if IS_ENABLED(CONFIG_IPV6)
+	if (info->mode & IP_TUNNEL_INFO_IPV6)
+		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
+	else
+#endif
+		err = bareudp_xmit_skb(skb, dev, bareudp, info);
+
+	rcu_read_unlock();
+
+	if (likely(!err))
+		return NETDEV_TX_OK;
+tx_error:
+	dev_kfree_skb(skb);
+
+	if (err == -ELOOP)
+		dev->stats.collisions++;
+	else if (err == -ENETUNREACH)
+		dev->stats.tx_carrier_errors++;
+
+	dev->stats.tx_errors++;
+	return NETDEV_TX_OK;
+}
+
+static int bareudp_fill_metadata_dst(struct net_device *dev,
+				     struct sk_buff *skb)
+{
+	struct ip_tunnel_info *info = skb_tunnel_info(skb);
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
+	int ret;
+
+	if (ip_tunnel_info_af(info) == AF_INET) {
+		struct rtable *rt;
+		struct flowi4 fl4;
+
+		rt = iptunnel_get_rt(skb, dev, bareudp->net, &fl4, info,
+				     use_cache);
+		if (IS_ERR(rt))
+			return PTR_ERR(rt);
+
+		ip_rt_put(rt);
+		info->key.u.ipv4.src = fl4.saddr;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (ip_tunnel_info_af(info) == AF_INET6) {
+		struct dst_entry *dst;
+		struct flowi6 fl6;
+		struct socket *sock = rcu_dereference(bareudp->sock);
+
+		dst = ip6tunnel_get_dst(skb, dev, bareudp->net, sock, &fl6,
+					info, use_cache);
+		if (IS_ERR(dst))
+			return PTR_ERR(dst);
+
+		dst_release(dst);
+		info->key.u.ipv6.src = fl6.saddr;
+#endif
+	} else {
+		return -EINVAL;
+	}
+
+	info->key.tp_src = udp_flow_src_port(bareudp->net, skb,
+					     bareudp->sport_min,
+			USHRT_MAX, true);
+	info->key.tp_dst = bareudp->port;
+	return ret;
+}
+
+static const struct net_device_ops bareudp_netdev_ops = {
+	.ndo_init               = bareudp_init,
+	.ndo_uninit             = bareudp_uninit,
+	.ndo_open               = bareudp_open,
+	.ndo_stop               = bareudp_stop,
+	.ndo_start_xmit         = bareudp_xmit,
+	.ndo_get_stats64        = ip_tunnel_get_stats64,
+	.ndo_fill_metadata_dst  = bareudp_fill_metadata_dst,
+};
+
+static const struct nla_policy bareudp_policy[IFLA_BAREUDP_MAX + 1] = {
+	[IFLA_BAREUDP_PORT]                = { .type = NLA_U16 },
+	[IFLA_BAREUDP_ETHERTYPE]	   = { .type = NLA_U16 },
+	[IFLA_BAREUDP_SRCPORT_MIN]         = { .type = NLA_U16 },
+};
+
+/* Info for udev, that this is a virtual tunnel endpoint */
+static struct device_type bareudp_type = {
+	.name = "bareudp",
+};
+
+/* Initialize the device structure. */
+static void bareudp_setup(struct net_device *dev)
+{
+	dev->netdev_ops = &bareudp_netdev_ops;
+	dev->needs_free_netdev = true;
+	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
+	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features    |= NETIF_F_RXCSUM;
+	dev->features    |= NETIF_F_GSO_SOFTWARE;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	dev->hard_header_len = 0;
+	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN;
+	dev->min_mtu = IPV4_MIN_MTU;
+	dev->max_mtu = IP_MAX_MTU - BAREUDP_BASE_HLEN;
+	dev->type = ARPHRD_NONE;
+	netif_keep_dst(dev);
+	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+}
+
+static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
+			    struct netlink_ext_ack *extack)
+{
+	if (!data) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough attributes provided to perform the operation");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf)
+{
+	if (!data[IFLA_BAREUDP_PORT] || !data[IFLA_BAREUDP_ETHERTYPE])
+		return -EINVAL;
+
+	if (data[IFLA_BAREUDP_PORT])
+		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
+
+	if (data[IFLA_BAREUDP_ETHERTYPE])
+		conf->ethertype =  nla_get_u16(data[IFLA_BAREUDP_ETHERTYPE]);
+
+	if (data[IFLA_BAREUDP_SRCPORT_MIN])
+		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
+
+	return 0;
+}
+
+static struct bareudp_dev *bareudp_find_dev(struct bareudp_net *bn,
+					    const struct bareudp_conf *conf)
+{
+	struct bareudp_dev *bareudp, *t = NULL;
+
+	list_for_each_entry(bareudp, &bn->bareudp_list, next) {
+		if (conf->port == bareudp->port)
+			t = bareudp;
+	}
+	return t;
+}
+
+static int bareudp_configure(struct net *net, struct net_device *dev,
+			     struct bareudp_conf *conf)
+{
+	struct bareudp_net *bn = net_generic(net, bareudp_net_id);
+	struct bareudp_dev *t, *bareudp = netdev_priv(dev);
+	int err;
+
+	bareudp->net = net;
+	bareudp->dev = dev;
+	t = bareudp_find_dev(bn, conf);
+	if (t)
+		return -EBUSY;
+
+	bareudp->port = conf->port;
+	bareudp->ethertype = conf->ethertype;
+	bareudp->sport_min = conf->sport_min;
+	err = register_netdevice(dev);
+	if (err)
+		return err;
+
+	list_add(&bareudp->next, &bn->bareudp_list);
+	return 0;
+}
+
+static int bareudp_link_config(struct net_device *dev,
+			       struct nlattr *tb[])
+{
+	int err;
+
+	if (tb[IFLA_MTU]) {
+		err = dev_set_mtu(dev, nla_get_u32(tb[IFLA_MTU]));
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int bareudp_newlink(struct net *net, struct net_device *dev,
+			   struct nlattr *tb[], struct nlattr *data[],
+			   struct netlink_ext_ack *extack)
+{
+	struct bareudp_conf conf;
+	int err;
+
+	err = bareudp2info(data, &conf);
+	if (err)
+		return err;
+
+	err = bareudp_configure(net, dev, &conf);
+	if (err)
+		return err;
+
+	err = bareudp_link_config(dev, tb);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void bareudp_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	list_del(&bareudp->next);
+	unregister_netdevice_queue(dev, head);
+}
+
+static size_t bareudp_get_size(const struct net_device *dev)
+{
+	return  nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_PORT */
+		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
+		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
+		0;
+}
+
+static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	if (nla_put_be16(skb, IFLA_BAREUDP_PORT, bareudp->port))
+		goto nla_put_failure;
+	if (nla_put_be16(skb, IFLA_BAREUDP_ETHERTYPE, bareudp->ethertype))
+		goto nla_put_failure;
+	if (nla_put_u16(skb, IFLA_BAREUDP_SRCPORT_MIN, bareudp->sport_min))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static struct rtnl_link_ops bareudp_link_ops __read_mostly = {
+	.kind           = "bareudp",
+	.maxtype        = IFLA_BAREUDP_MAX,
+	.policy         = bareudp_policy,
+	.priv_size      = sizeof(struct bareudp_dev),
+	.setup          = bareudp_setup,
+	.validate       = bareudp_validate,
+	.newlink        = bareudp_newlink,
+	.dellink        = bareudp_dellink,
+	.get_size       = bareudp_get_size,
+	.fill_info      = bareudp_fill_info,
+};
+
+struct net_device *bareudp_dev_create(struct net *net, const char *name,
+				      u8 name_assign_type,
+				      struct bareudp_conf *conf)
+{
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct net_device *dev;
+	LIST_HEAD(list_kill);
+	int err;
+
+	memset(tb, 0, sizeof(tb));
+	dev = rtnl_create_link(net, name, name_assign_type,
+			       &bareudp_link_ops, tb, NULL);
+	if (IS_ERR(dev))
+		return dev;
+
+	err = bareudp_configure(net, dev, conf);
+	if (err) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
+	err = dev_set_mtu(dev, IP_MAX_MTU);
+	if (err)
+		goto err;
+
+	err = rtnl_configure_link(dev, NULL);
+	if (err < 0)
+		goto err;
+
+	return dev;
+err:
+	bareudp_dellink(dev, &list_kill);
+	unregister_netdevice_many(&list_kill);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(bareudp_dev_create);
+
+static __net_init int bareudp_init_net(struct net *net)
+{
+	struct bareudp_net *bn = net_generic(net, bareudp_net_id);
+
+	INIT_LIST_HEAD(&bn->bareudp_list);
+	return 0;
+}
+
+static void bareudp_destroy_tunnels(struct net *net, struct list_head *head)
+{
+	struct bareudp_net *bn = net_generic(net, bareudp_net_id);
+	struct bareudp_dev *bareudp, *next;
+
+	list_for_each_entry_safe(bareudp, next, &bn->bareudp_list, next)
+		unregister_netdevice_queue(bareudp->dev, head);
+}
+
+static void __net_exit bareudp_exit_batch_net(struct list_head *net_list)
+{
+	struct net *net;
+	LIST_HEAD(list);
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list)
+		bareudp_destroy_tunnels(net, &list);
+
+	/* unregister the devices gathered above */
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
+}
+
+static struct pernet_operations bareudp_net_ops = {
+	.init = bareudp_init_net,
+	.exit_batch = bareudp_exit_batch_net,
+	.id   = &bareudp_net_id,
+	.size = sizeof(struct bareudp_net),
+};
+
+static int __init bareudp_init_module(void)
+{
+	int rc;
+
+	rc = register_pernet_subsys(&bareudp_net_ops);
+	if (rc)
+		goto out1;
+
+	rc = rtnl_link_register(&bareudp_link_ops);
+	if (rc)
+		goto out2;
+
+	return 0;
+out2:
+	unregister_pernet_subsys(&bareudp_net_ops);
+out1:
+	return rc;
+}
+late_initcall(bareudp_init_module);
+
+static void __exit bareudp_cleanup_module(void)
+{
+	rtnl_link_unregister(&bareudp_link_ops);
+	unregister_pernet_subsys(&bareudp_net_ops);
+}
+module_exit(bareudp_cleanup_module);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Varghese <martin.varghese@nokia.com>");
+MODULE_DESCRIPTION("Interface driver for UDP encapsulated traffic");
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
new file mode 100644
index 0000000..513fae6
--- /dev/null
+++ b/include/net/bareudp.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __NET_BAREUDP_H
+#define __NET_BAREUDP_H
+
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+struct bareudp_conf {
+	__be16 ethertype;
+	__be16 port;
+	u16 sport_min;
+};
+
+struct net_device *bareudp_dev_create(struct net *net, const char *name,
+				      u8 name_assign_type,
+				      struct bareudp_conf *info);
+
+#endif
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 028eaea..8215d1b 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 		iptunnel_xmit_stats(dev, pkt_len);
 	}
 }
+
+static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
+						  struct net_device *dev,
+						  struct net *net,
+						  struct socket *sock,
+						  struct flowi6 *fl6,
+						  const struct ip_tunnel_info *info,
+						  bool use_cache)
+{
+	struct dst_entry *dst = NULL;
+#ifdef CONFIG_DST_CACHE
+	struct dst_cache *dst_cache;
+#endif
+	__u8 prio;
+
+	memset(fl6, 0, sizeof(*fl6));
+	fl6->flowi6_mark = skb->mark;
+	fl6->flowi6_proto = IPPROTO_UDP;
+	fl6->daddr = info->key.u.ipv6.dst;
+	fl6->saddr = info->key.u.ipv6.src;
+	prio = info->key.tos;
+
+	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
+					   info->key.label);
+#ifdef CONFIG_DST_CACHE
+	dst_cache = (struct dst_cache *)&info->dst_cache;
+	if (use_cache) {
+		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
+		if (dst)
+			return dst;
+	}
+#endif
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, fl6,
+					      NULL);
+	if (IS_ERR(dst)) {
+		netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (dst->dev == dev) { /* is this necessary? */
+		netdev_dbg(dev, "circular route to %pI6\n", &fl6->daddr);
+		dst_release(dst);
+		return ERR_PTR(-ELOOP);
+	}
+#ifdef CONFIG_DST_CACHE
+	if (use_cache)
+		dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
+#endif
+	return dst;
+}
+
 #endif
 #endif
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 236503a..a79c3a6 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -490,6 +490,53 @@ static inline int ip_tunnel_collect_metadata(void)
 	return static_branch_unlikely(&ip_tunnel_metadata_cnt);
 }
 
+static inline  struct rtable *iptunnel_get_rt(struct sk_buff *skb,
+					      struct net_device *dev,
+					      struct net *net,
+					      struct flowi4 *fl4,
+					      const struct ip_tunnel_info *info,
+					      bool  use_cache)
+{
+#ifdef CONFIG_DST_CACHE
+	struct dst_cache *dst_cache;
+#endif
+	struct rtable *rt = NULL;
+	__u8 tos;
+
+	memset(fl4, 0, sizeof(*fl4));
+	fl4->flowi4_mark = skb->mark;
+	fl4->flowi4_proto = IPPROTO_UDP;
+	fl4->daddr = info->key.u.ipv4.dst;
+	fl4->saddr = info->key.u.ipv4.src;
+
+	tos = info->key.tos;
+	fl4->flowi4_tos = RT_TOS(tos);
+
+#ifdef CONFIG_DST_CACHE
+	dst_cache = (struct dst_cache *)&info->dst_cache;
+	if (use_cache) {
+		rt = dst_cache_get_ip4(dst_cache, &fl4->saddr);
+		if (rt)
+			return rt;
+	}
+#endif
+	rt = ip_route_output_key(net, fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (rt->dst.dev == dev) { /* is this necessary? */
+		netdev_dbg(dev, "circular route to %pI4\n", &fl4->daddr);
+		ip_rt_put(rt);
+		return ERR_PTR(-ELOOP);
+	}
+#ifdef CONFIG_DST_CACHE
+	if (use_cache)
+		dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
+#endif
+	return rt;
+}
+
 void __init ip_tunnel_core_init(void);
 
 void ip_tunnel_need_metadata(void);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 024af2d..fb4b33a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -590,6 +590,17 @@ enum ifla_geneve_df {
 	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
 };
 
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
 /* PPP section */
 enum {
 	IFLA_PPP_UNSPEC,
-- 
1.8.3.1

