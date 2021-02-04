Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523A830FFCE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBDWAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBDWAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:00:45 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2650C06178A
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:00:04 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id d7so4979837otf.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qqU53tgBg2nv83amFXPsQJ1KgpCCHS4E3smZEotoTAs=;
        b=fBa6Lkb1imoLWso/BdduesDLAfXVWX2XG1WazJlXcweVbmI05qsbU7nGG8Brl/nk/a
         XJrm7zyiVMd25HXJJHJr8FSUpkKX4ONfPMGfAXBI2MYT/f6bDCUZuaL+/tb3rgGzbVPl
         tD8MzVGlKzizeFyZULAEeybGfdHs0WJuPGnZgOJ+f7l+7GqFDQdYTds0bhBpXWR7XRJy
         qmXgX+khMUAeZatu8NgLa3R95BDcQeZBoLcY7m4ic319MfzXIsWqLnomriFdRbyt0ox5
         qQgPEX+rt1rCozs/aCn1ZQkJKhvLjnvagBmCgxfHsaG10tJxtZI06DW0nmFA/NYkkpN0
         Br8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qqU53tgBg2nv83amFXPsQJ1KgpCCHS4E3smZEotoTAs=;
        b=pIVqN2l9/kpPidj3CpPbh2+d642g36KAiUDabphpsGtglqOBRchYWX+XYTYciVa68M
         0FlSXyzVIvpvk9ylbp5ALVsBwWnPqit+Fa8VPjbsfpzKivMbGMvTqf/A/q/uN+2tqznz
         iI19ayanU1GUNs0+3W942bNx0Z3sX8UTq4eVDVM7j3pZSp4VTwHrijKLnztuhry3Gs7w
         GvLTmkiEC5/3L6PK+5zLAHwO5US5sYzsNynMhSMJhdgH+LOD4yymcW+FVKoN/Wu6n9ky
         nv43hob+cmoMiI+oDFRAbE2eR2qUQSAWXv8Wd0h/OwtEbWUcN0Lv+6ZLJGKyXUPMYOAi
         eJsg==
X-Gm-Message-State: AOAM531SNWaXhajgQ5KSthkvPtlAxOl9I07BaTwrE/TLsicNWWZz4S+6
        c0ELFWQRrc+lCTW/YGfEjA==
X-Google-Smtp-Source: ABdhPJx319lXQkQXfxSBEPhqELNzvGE0xnB2sBMQGnyPuI2ufHpGxpDxTsQ7GoaTpt+bNTcsgPsokg==
X-Received: by 2002:a9d:7b4d:: with SMTP id f13mr1110867oto.257.1612476004108;
        Thu, 04 Feb 2021 14:00:04 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y10sm1361395ooy.11.2021.02.04.14.00.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 14:00:03 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 2/4] net: hsr: add offloading support
Date:   Thu,  4 Feb 2021 15:59:24 -0600
Message-Id: <20210204215926.64377-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210204215926.64377-1-george.mccollister@gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
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
index 161b8da6a21d..1ff4fa3b383f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -418,6 +418,7 @@ static struct hsr_proto_ops hsr_ops = {
 	.send_sv_frame = send_hsr_supervision_frame,
 	.create_tagged_frame = hsr_create_tagged_frame,
 	.get_untagged_frame = hsr_get_untagged_frame,
+	.drop_frame = hsr_drop_frame,
 	.fill_frame_info = hsr_fill_frame_info,
 	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
 };
@@ -465,10 +466,11 @@ void hsr_dev_setup(struct net_device *dev)
 
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
@@ -521,16 +523,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
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
index c11be87daa8f..76c650fa7345 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -247,6 +247,8 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 		/* set the lane id properly */
 		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
 	/* Create the new skb with enough headroom to fit the HSR tag */
@@ -289,6 +291,8 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 			return NULL;
 		}
 		return skb_clone(frame->skb_prp, GFP_ATOMIC);
+	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
 	skb = skb_copy_expand(frame->skb_std, 0,
@@ -341,6 +345,14 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
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
@@ -357,6 +369,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 {
 	struct hsr_port *port;
 	struct sk_buff *skb;
+	bool sent = false;
 
 	hsr_for_each_port(frame->port_rcv->hsr, port) {
 		struct hsr_priv *hsr = port->hsr;
@@ -372,6 +385,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
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
@@ -403,10 +422,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
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

