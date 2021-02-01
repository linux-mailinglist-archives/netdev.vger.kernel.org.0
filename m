Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694AE30A954
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhBAOGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhBAOGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:06:05 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F375BC0613D6
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:05:24 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id h6so18875751oie.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f5zo1h8BiBIBPLCDwMk9WjCKABCDEreQofZ1kFb4/4g=;
        b=lruCmfHCJTVZS430eZDDrjSBFkrvFmTYuXjixpitdZthkI3DKl+VJCUnhgX1Cgb+2u
         My5Onw0xi3OppNxPRepZxrXRtyWC+y/tT+d/oK0j6pPD7Z9NY5J0fAimv5L1PnLHPiVy
         br/VZaGO4mJ8YBDts+z6NallLVhjzkje1n+xfFoRZmWTVPJbDDTU4tnsQcCrlamIpos0
         LjwTslTuB0olRIt6Ddb12Gl6jPZId3wXK0jZfo8aRyg4yCe9pPG+nZhXFuhV2Oa0niie
         j3RQM/UpMUgTFuQ4d2U7TsaMjfNRUFXYe2aCWkWw4Rs9PSAvzmZfKW2qTbBWaCT9pPJ1
         TYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f5zo1h8BiBIBPLCDwMk9WjCKABCDEreQofZ1kFb4/4g=;
        b=qL3z/GHFai+gPLye9q6L8Qz31wvLA0bBM2ziyJSkgJvT9L0hR6CNRV69Ow1BNF+6e5
         N+n8Pp3Rw7Vy5SsWlW0sQCyX6Qr5d2G1PLRRu1IiWW/Mq0KfLWfUF1BkakojVzGy7tNj
         aHOKrHJKYT2sFHtkXoHJEcG3lHCKziAQF/2VkiWPUpN0n0KS/pIeAMj1HDJf+3BdQ8WI
         c0+BHq7Xpk4Sw/ITqwoPB3L1PpYHrM71sG1Et6KJ3SKKQfLW6eazOVSvZFpwJ3Ieha1o
         kAuqFF2mKEK1ubZYN/1o+YPV9qrJgyMKNIXQrXBqKXFXhFQKR0Ts1wcrepVZxHO2BI3/
         fxVA==
X-Gm-Message-State: AOAM531YFt3MSWVZGbzgT83EpcMTsJkWvhBUeokdYLc15CWz41ci4APq
        3wKbCo5jc7SUccJ0rST4PQ==
X-Google-Smtp-Source: ABdhPJwZUFPASfWMTxvLQ7+U8X1er6aMspqJSMDBgo9g8NnEcc7CHXzKUpa7Z+rgBf4Vs168/50geg==
X-Received: by 2002:aca:43c3:: with SMTP id q186mr3123507oia.77.1612188324306;
        Mon, 01 Feb 2021 06:05:24 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id q6sm3967972otm.68.2021.02.01.06.05.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 06:05:20 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RESEND PATCH net-next 2/4] net: hsr: add offloading support
Date:   Mon,  1 Feb 2021 08:05:01 -0600
Message-Id: <20210201140503.130625-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210201140503.130625-1-george.mccollister@gmail.com>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
tag removal, duplicate generation and forwarding.

Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
device so DSA can tell them apart from other devices in
dsa_slave_changeupper.

For HSR, insertion involves the switch adding a 6 byte HSR header after
the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.

Tag removal involves automatically stripping the HSR/PRP header/trailer
in the switch. This is possible when the switch also preforms auto
deduplication using the HSR/PRP header/trailer (making it no longer
required).

Forwarding involves automatically forwarding between redundant ports in
an HSR. This is crucial because delay is accumulated as a frame passes
through each node in the ring.

Duplication involves the switch automatically sending a single frame
from the CPU port to both redundant ports. This is required because the
inserted HSR/PRP header/trailer must contain the same sequence number
on the frames sent out both redundant ports.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/networking/netdev-features.rst | 20 ++++++++++++++++++++
 include/linux/if_hsr.h                       | 22 ++++++++++++++++++++++
 include/linux/netdev_features.h              |  9 +++++++++
 include/linux/netdevice.h                    | 13 +++++++++++++
 net/ethtool/common.c                         |  4 ++++
 net/hsr/hsr_device.c                         | 12 +++---------
 net/hsr/hsr_forward.c                        | 27 ++++++++++++++++++++++++---
 net/hsr/hsr_forward.h                        |  1 +
 net/hsr/hsr_main.c                           | 14 ++++++++++++++
 net/hsr/hsr_main.h                           |  8 +-------
 net/hsr/hsr_slave.c                          | 13 +++++++++----
 11 files changed, 120 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/if_hsr.h

diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
index a2d7d7160e39..4eab45405031 100644
--- a/Documentation/networking/netdev-features.rst
+++ b/Documentation/networking/netdev-features.rst
@@ -182,3 +182,23 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
 be re-segmentable by GSO or TSO back to the exact original packet stream.
 Hardware GRO is dependent on RXCSUM since every packet successfully merged
 by hardware must also have the checksum verified by hardware.
+
+* hsr-tag-ins-offload
+
+This should be set for devices which insert an HSR (highspeed ring) tag
+automatically when in HSR mode.
+
+* hsr-tag-rm-offload
+
+This should be set for devices which remove HSR (highspeed ring) tags
+automatically when in HSR mode.
+
+* hsr-fwd-offload
+
+This should be set for devices which forward HSR (highspeed ring) frames from
+one port to another in hardware.
+
+* hsr-dup-offload
+
+This should be set for devices which duplicate outgoing HSR (highspeed ring)
+frames in hardware.
diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
new file mode 100644
index 000000000000..eec9079efab0
--- /dev/null
+++ b/include/linux/if_hsr.h
@@ -0,0 +1,22 @@
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
+extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
+#else
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
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9e7ada07ea1..9ac6f30c4a51 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1526,6 +1526,7 @@ struct net_device_ops {
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
+ * @IFF_HSR: device is an hsr device
  */
 enum netdev_priv_flags {
 	IFF_802_1Q_VLAN			= 1<<0,
@@ -1559,6 +1560,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
+	IFF_HSR				= 1<<31,
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
@@ -1591,6 +1593,7 @@ enum netdev_priv_flags {
 #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
 #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
+#define IFF_HSR				IFF_HSR
 
 /**
  *	struct net_device - The DEVICE structure.
@@ -5003,6 +5006,16 @@ static inline bool netif_is_failover_slave(const struct net_device *dev)
 	return dev->priv_flags & IFF_FAILOVER_SLAVE;
 }
 
+static inline bool netif_is_hsr_master(const struct net_device *dev)
+{
+	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_HSR;
+}
+
+static inline bool netif_is_hsr_slave(const struct net_device *dev)
+{
+	return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_HSR;
+}
+
 /* This device needs to keep skb dst for qdisc enqueue or ndo_start_xmit() */
 static inline void netif_keep_dst(struct net_device *dev)
 {
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 181220101a6e..0298e5635ace 100644
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
index 161b8da6a21d..d9b033e9b18c 100644
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
@@ -521,15 +522,8 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
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
+	hsr_dev->flags |= IFF_MASTER;
+	hsr_dev->priv_flags |= IFF_HSR;
 
 	/* Make sure the 1st call to netif_carrier_on() gets through */
 	netif_carrier_off(hsr_dev);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index a5566b2245a0..9c79d602c4e0 100644
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
@@ -341,6 +343,14 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
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
@@ -357,6 +367,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 {
 	struct hsr_port *port;
 	struct sk_buff *skb;
+	bool sent = false;
 
 	hsr_for_each_port(frame->port_rcv->hsr, port) {
 		struct hsr_priv *hsr = port->hsr;
@@ -372,6 +383,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
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
@@ -403,10 +420,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
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
 
@@ -457,6 +476,7 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	struct hsr_port *port = frame->port_rcv;
 
 	if (port->type != HSR_PT_MASTER &&
+	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
 	    (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
@@ -478,6 +498,7 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	struct hsr_port *port = frame->port_rcv;
 
 	if (port->type != HSR_PT_MASTER &&
+	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
 	    rct &&
 	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
 		frame->skb_hsr = NULL;
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
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 2fd1976e5b1c..0e7b5b18b5e3 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -131,6 +131,20 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
 	return NULL;
 }
 
+int hsr_get_version(struct net_device *dev, enum hsr_version *ver)
+{
+	struct hsr_priv *hsr;
+
+	if (!(dev->priv_flags & IFF_HSR))
+		return -EINVAL;
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
index 7dc92ce5a134..7369b2febe0f 100644
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
index 36d5fcf09c61..59f8d2b68376 100644
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
 
@@ -137,6 +139,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	hsr_dev = master->dev;
 
+	dev->flags |= IFF_SLAVE;
+	dev->priv_flags |= IFF_HSR;
+
 	res = netdev_upper_dev_link(dev, hsr_dev, extack);
 	if (res)
 		goto fail_upper_dev_link;
-- 
2.11.0

