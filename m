Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB2315BDE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhBJBGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhBJBDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:03:33 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93979C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 17:02:53 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id e17so148067oow.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D0eI6Wk9UOPakTkWmv9Bv+gDrbRgFqz58arLk51dlIE=;
        b=A8mK226usquwV7OWononDgQdX9URFrM251f79uiT4i3WhZDkuYVhce/DOruJAqsrIA
         Zj/JKs1jBaDRFCqyTDoTJgCP2+6dDluPN01CSaXl6a3mD0fuHNZF6QJpa0WmyCWwmv9B
         GiL/Cs788IfpIaNr3BB9e4RzogP7R4Lv1ftRIH4cPu1I3h2BFpolVFYc/UD/HeC3yRM5
         79dBG7lEecPEioWNRckQOeHJSDkda0QKsmbqOO/Z8U3BylupWl+vrbVltg8MVsA8Jped
         34fBdwqVnpIAmo/Ns8WShFNXZdK3jzlu5tma0j/ddrCVTuBib62QDs00ZJPCFA3kxBGo
         Eepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D0eI6Wk9UOPakTkWmv9Bv+gDrbRgFqz58arLk51dlIE=;
        b=ehZ+3ENpU4HlXcJiu9P+FTxqFVBAsdhW0LrCprWvcNUuCGT3KqJO0tNln5zgYyVvfS
         f3WZwn9tY8A8uiD/gIinY9U5ZgfVX/IsZabRENwV68JCReQBxY1OoDuiKwUeQNuaGA/G
         rJCOY6xu+Hqx80fdLXljKfvI3VJ99h6d1fFwJipU224WXpHW7VmCvFb3WijkqNjg5ZVB
         HNeitRQHNsMf+egVUctREu6Wl+VrSqOL3tO58SIR/djWwo8wRkV0PJrUOAXTFvc9aP8z
         3WHKf5bCd/zKCC8hgf+1H8n1CyFagjAvY+suACl9716BCpshWLg/LfcJrlrJIDQjZX6H
         0NkQ==
X-Gm-Message-State: AOAM530qAo1NDlEATWSMUqgnpipSNeKyGFmUsA1QGh5jfWj3ZdFhgY91
        5CFj7RlzYU1AzpEwLMFjHg==
X-Google-Smtp-Source: ABdhPJx2bdulZAt+UKwWAg9nsleE6OEDz8DIf6sjeznCI+JWt/UPyMKV+sLpyXIryoVNTVO33yZX+w==
X-Received: by 2002:a4a:a22a:: with SMTP id m42mr455281ool.22.1612918972849;
        Tue, 09 Feb 2021 17:02:52 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id i9sm101811oii.34.2021.02.09.17.02.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 17:02:51 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 2/4] net: hsr: add offloading support
Date:   Tue,  9 Feb 2021 19:02:11 -0600
Message-Id: <20210210010213.27553-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210210010213.27553-1-george.mccollister@gmail.com>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
tag removal, duplicate generation and forwarding.

For HSR, insertion involves the switch adding a 6 byte HSR header after
the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.

Tag removal involves automatically stripping the HSR/PRP header/trailer
in the switch. This is possible when the switch also performs auto
deduplication using the HSR/PRP header/trailer (making it no longer
required).

Forwarding involves automatically forwarding between redundant ports in
an HSR. This is crucial because delay is accumulated as a frame passes
through each node in the ring.

Duplication involves the switch automatically sending a single frame
from the CPU port to both redundant ports. This is required because the
inserted HSR/PRP header/trailer must contain the same sequence number
on the frames sent out both redundant ports.

Export is_hsr_master so DSA can tell them apart from other devices in
dsa_slave_changeupper.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/networking/netdev-features.rst | 21 +++++++++++++++++++++
 include/linux/if_hsr.h                       | 27 +++++++++++++++++++++++++++
 include/linux/netdev_features.h              |  9 +++++++++
 net/ethtool/common.c                         |  4 ++++
 net/hsr/hsr_device.c                         | 14 +++-----------
 net/hsr/hsr_device.h                         |  1 -
 net/hsr/hsr_forward.c                        | 27 ++++++++++++++++++++++++---
 net/hsr/hsr_forward.h                        |  1 +
 net/hsr/hsr_framereg.c                       |  2 ++
 net/hsr/hsr_main.c                           | 11 +++++++++++
 net/hsr/hsr_main.h                           |  8 +-------
 net/hsr/hsr_slave.c                          | 10 ++++++----
 12 files changed, 109 insertions(+), 26 deletions(-)
 create mode 100644 include/linux/if_hsr.h

diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
index a2d7d7160e39..d7b15bb64deb 100644
--- a/Documentation/networking/netdev-features.rst
+++ b/Documentation/networking/netdev-features.rst
@@ -182,3 +182,24 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
 be re-segmentable by GSO or TSO back to the exact original packet stream.
 Hardware GRO is dependent on RXCSUM since every packet successfully merged
 by hardware must also have the checksum verified by hardware.
+
+* hsr-tag-ins-offload
+
+This should be set for devices which insert an HSR (High-availability Seamless
+Redundancy) or PRP (Parallel Redundancy Protocol) tag automatically.
+
+* hsr-tag-rm-offload
+
+This should be set for devices which remove HSR (High-availability Seamless
+Redundancy) or PRP (Parallel Redundancy Protocol) tags automatically.
+
+* hsr-fwd-offload
+
+This should be set for devices which forward HSR (High-availability Seamless
+Redundancy) frames from one port to another in hardware.
+
+* hsr-dup-offload
+
+This should be set for devices which duplicate outgoing HSR (High-availability
+Seamless Redundancy) or PRP (Parallel Redundancy Protocol) tags automatically
+frames in hardware.
diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
new file mode 100644
index 000000000000..38bbc537d4e4
--- /dev/null
+++ b/include/linux/if_hsr.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_IF_HSR_H_
+#define _LINUX_IF_HSR_H_
+
+/* used to differentiate various protocols */
+enum hsr_version {
+	HSR_V0 = 0,
+	HSR_V1,
+	PRP_V1,
+};
+
+#if IS_ENABLED(CONFIG_HSR)
+extern bool is_hsr_master(struct net_device *dev);
+extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
+#else
+static inline bool is_hsr_master(struct net_device *dev)
+{
+	return false;
+}
+static inline int hsr_get_version(struct net_device *dev,
+				  enum hsr_version *ver)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_HSR */
+
+#endif /*_LINUX_IF_HSR_H_*/
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index c06d6aaba9df..3de38d6a0aea 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -86,6 +86,11 @@ enum {
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
 	NETIF_F_GRO_UDP_FWD_BIT,	/* Allow UDP GRO for forwarding */
 
+	NETIF_F_HW_HSR_TAG_INS_BIT,	/* Offload HSR tag insertion */
+	NETIF_F_HW_HSR_TAG_RM_BIT,	/* Offload HSR tag removal */
+	NETIF_F_HW_HSR_FWD_BIT,		/* Offload HSR forwarding */
+	NETIF_F_HW_HSR_DUP_BIT,		/* Offload HSR duplication */
+
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -159,6 +164,10 @@ enum {
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 #define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
+#define NETIF_F_HW_HSR_TAG_INS	__NETIF_F(HW_HSR_TAG_INS)
+#define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
+#define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
+#define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 835b9bba3e7e..c6a383dfd6c2 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -69,6 +69,10 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 	[NETIF_F_GRO_UDP_FWD_BIT] =	 "rx-udp-gro-forwarding",
+	[NETIF_F_HW_HSR_TAG_INS_BIT] =	 "hsr-tag-ins-offload",
+	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
+	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
+	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
 };
 
 const char
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ec6a68b403d5..7444ec6e298e 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -417,6 +417,7 @@ static struct hsr_proto_ops hsr_ops = {
 	.send_sv_frame = send_hsr_supervision_frame,
 	.create_tagged_frame = hsr_create_tagged_frame,
 	.get_untagged_frame = hsr_get_untagged_frame,
+	.drop_frame = hsr_drop_frame,
 	.fill_frame_info = hsr_fill_frame_info,
 	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
 };
@@ -464,10 +465,11 @@ void hsr_dev_setup(struct net_device *dev)
 
 /* Return true if dev is a HSR master; return false otherwise.
  */
-inline bool is_hsr_master(struct net_device *dev)
+bool is_hsr_master(struct net_device *dev)
 {
 	return (dev->netdev_ops->ndo_start_xmit == hsr_dev_xmit);
 }
+EXPORT_SYMBOL(is_hsr_master);
 
 /* Default multicast address for HSR Supervision frames */
 static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
@@ -520,16 +522,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	hsr->prot_version = protocol_version;
 
-	/* FIXME: should I modify the value of these?
-	 *
-	 * - hsr_dev->flags - i.e.
-	 *			IFF_MASTER/SLAVE?
-	 * - hsr_dev->priv_flags - i.e.
-	 *			IFF_EBRIDGE?
-	 *			IFF_TX_SKB_SHARING?
-	 *			IFF_HSR_MASTER/SLAVE?
-	 */
-
 	/* Make sure the 1st call to netif_carrier_on() gets through */
 	netif_carrier_off(hsr_dev);
 
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index 868373822ee4..9060c92168f9 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -19,6 +19,5 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version,
 		     struct netlink_ext_ack *extack);
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
-bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
 #endif /* __HSR_DEVICE_H */
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index d32cd87d5c5b..ed82a470b6e1 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -249,6 +249,8 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 		/* set the lane id properly */
 		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
 	/* Create the new skb with enough headroom to fit the HSR tag */
@@ -291,6 +293,8 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 			return NULL;
 		}
 		return skb_clone(frame->skb_prp, GFP_ATOMIC);
+	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
 	skb = skb_copy_expand(frame->skb_std, 0,
@@ -343,6 +347,14 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 		 port->type ==  HSR_PT_SLAVE_A));
 }
 
+bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
+{
+	if (port->dev->features & NETIF_F_HW_HSR_FWD)
+		return prp_drop_frame(frame, port);
+
+	return false;
+}
+
 /* Forward the frame through all devices except:
  * - Back through the receiving device
  * - If it's a HSR frame: through a device where it has passed before
@@ -359,6 +371,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 {
 	struct hsr_port *port;
 	struct sk_buff *skb;
+	bool sent = false;
 
 	hsr_for_each_port(frame->port_rcv->hsr, port) {
 		struct hsr_priv *hsr = port->hsr;
@@ -374,6 +387,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
 			continue;
 
+		/* If hardware duplicate generation is enabled, only send out
+		 * one port.
+		 */
+		if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
+			continue;
+
 		/* Don't send frame over port where it has been sent before.
 		 * Also fro SAN, this shouldn't be done.
 		 */
@@ -405,10 +424,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		}
 
 		skb->dev = port->dev;
-		if (port->type == HSR_PT_MASTER)
+		if (port->type == HSR_PT_MASTER) {
 			hsr_deliver_master(skb, port->dev, frame->node_src);
-		else
-			hsr_xmit(skb, port, frame);
+		} else {
+			if (!hsr_xmit(skb, port, frame))
+				sent = true;
+		}
 	}
 }
 
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index 618140d484ad..b6acaafa83fc 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -23,6 +23,7 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port);
 bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
+bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
 void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			 struct hsr_frame_info *frame);
 void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 5c97de459905..f9a8cc82ae2e 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -277,6 +277,8 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		skb = frame->skb_hsr;
 	else if (frame->skb_prp)
 		skb = frame->skb_prp;
+	else if (frame->skb_std)
+		skb = frame->skb_std;
 	if (!skb)
 		return;
 
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 2fd1976e5b1c..f7e284f23b1f 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -131,6 +131,17 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
 	return NULL;
 }
 
+int hsr_get_version(struct net_device *dev, enum hsr_version *ver)
+{
+	struct hsr_priv *hsr;
+
+	hsr = netdev_priv(dev);
+	*ver = hsr->prot_version;
+
+	return 0;
+}
+EXPORT_SYMBOL(hsr_get_version);
+
 static struct notifier_block hsr_nb = {
 	.notifier_call = hsr_netdev_notify,	/* Slave event notifications */
 };
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index a9c30a608e35..a169808ee78a 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include <linux/list.h>
 #include <linux/if_vlan.h>
+#include <linux/if_hsr.h>
 
 /* Time constants as specified in the HSR specification (IEC-62439-3 2010)
  * Table 8.
@@ -171,13 +172,6 @@ struct hsr_port {
 	enum hsr_port_type	type;
 };
 
-/* used by driver internally to differentiate various protocols */
-enum hsr_version {
-	HSR_V0 = 0,
-	HSR_V1,
-	PRP_V1,
-};
-
 struct hsr_frame_info;
 struct hsr_node;
 
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 36d5fcf09c61..c5227d42faf5 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -48,12 +48,14 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		goto finish_consume;
 	}
 
-	/* For HSR, only tagged frames are expected, but for PRP
-	 * there could be non tagged frames as well from Single
-	 * attached nodes (SANs).
+	/* For HSR, only tagged frames are expected (unless the device offloads
+	 * HSR tag removal), but for PRP there could be non tagged frames as
+	 * well from Single attached nodes (SANs).
 	 */
 	protocol = eth_hdr(skb)->h_proto;
-	if (hsr->proto_ops->invalid_dan_ingress_frame &&
+
+	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	    hsr->proto_ops->invalid_dan_ingress_frame &&
 	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
 		goto finish_pass;
 
-- 
2.11.0

