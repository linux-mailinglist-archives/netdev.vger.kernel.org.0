Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A986780B66
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfHDPLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:11:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40158 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfHDPLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:11:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so70754529wmj.5
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=xPBgLlcvH5hwo9tAoKvRN7BFd4s2xUaRMMATVlCRpaA=;
        b=vaqMpBjtOO89g98bBUEtFPka+lg3JOr5ObJDZnJHT2eSmRBgWdoXts4rQV+p1mB07k
         uRqC6QdHR7v7Cd1zK5IH8isr4U3PU58LzGExcexUEW2m7uHrzkAc/EGFlRrIGlWVvz2m
         +r/+o3xn/hXgPd4hfSDW1FAhAl540bUvS+mi0fVxb/GDlm2NeZB1Npy4PpcHhY6cAn5r
         QRhC3CQU8/2zj4AvRB7q9qkiJgS9umOUtkx65DusNanAUZQ7HMdH0Wa5BhBqJZFiTxsX
         7p6KYoa3htGydaEzdrk4reR/DHNN15xW4IbRGa/BN1wqh/66/tDJPCnJugULDybpf4Mn
         mkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xPBgLlcvH5hwo9tAoKvRN7BFd4s2xUaRMMATVlCRpaA=;
        b=aiTYdZBj/X1ZkyM0X2LuLX4GwxpBrHpqF5MHp3OjH3vrSYMyt8U5KkwW0o1Rkxum+8
         1mS8mUuzW3BChldMsSP3efD8vh1TtST0Qa9YO3aV//f3jXLQ0AoRnyeUCeQaEaE6/BT/
         wnIhgrSTo83GFfbmHw5CSMV/B/zCMUR1KhJEf3tzriPh5wT0x94ZbdMzxR6MVPzUHKQM
         VkS/bXUHiDj9/OVUGGd00o4v1ExVuMxQKWWVUVY5YXz4caHpaaWha5DD3jNGAnxkh9Eh
         qMti+20QYneaATCoSdn4bqiOEgEvJ8NjQFzGzpX+0ipxB+o57s4nA+x14zSNEKVSepP8
         dE3g==
X-Gm-Message-State: APjAAAXZnIPXoxcj88T0ZvmB0bgJHSPR09N/6EtInHs5t+73SA3gZ2AH
        qVvYOddRRxSy0Gi9vyH9wRpShcsIVX0=
X-Google-Smtp-Source: APXvYqyGD7lPz51op+gjn2d8apB2hy06w74POaP90Q6qxUCQZcGFH7dJvHzNKVIv26rOCBGBTgiZ5Q==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr13545523wma.23.1564931458626;
        Sun, 04 Aug 2019 08:10:58 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id z1sm103728510wrv.90.2019.08.04.08.10.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:58 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 10/10] nfp: flower: encode mac indexes with pre-tunnel rule check
Date:   Sun,  4 Aug 2019 16:10:49 +0100
Message-Id: <1564931449-1225-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a tunnel packet arrives on the NFP card, its destination MAC is
looked up and MAC index returned for it. This index can help verify the
tunnel by, for example, ensuring that the packet arrived on the expected
port. If the packet is destined for a known MAC that is not connected to a
given physical port then the mac index can have a global value (e.g. when
a series of bonded ports shared the same MAC).

If the packet is to be detunneled at a bridge device or internal port like
an Open vSwitch VLAN port, then it should first match a 'pre-tunnel' rule
to direct it to that internal port.

Use the MAC index to indicate if a packet should match a pre-tunnel rule
before decap is allowed. Do this by tracking the number of internal ports
associated with a MAC address and, if the number if >0, set a bit in the
mac_index to forward the packet to the pre-tunnel table before continuing
with decap.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 71 +++++++++++++++++-----
 1 file changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index a61e7f2..def8c19 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -17,6 +17,7 @@
 
 #define NFP_TUN_PRE_TUN_RULE_LIMIT	32
 #define NFP_TUN_PRE_TUN_RULE_DEL	0x1
+#define NFP_TUN_PRE_TUN_IDX_BIT		0x8
 
 /**
  * struct nfp_tun_pre_run_rule - rule matched before decap
@@ -141,11 +142,12 @@ enum nfp_flower_mac_offload_cmd {
 
 /**
  * struct nfp_tun_offloaded_mac - hashtable entry for an offloaded MAC
- * @ht_node:	Hashtable entry
- * @addr:	Offloaded MAC address
- * @index:	Offloaded index for given MAC address
- * @ref_count:	Number of devs using this MAC address
- * @repr_list:	List of reprs sharing this MAC address
+ * @ht_node:		Hashtable entry
+ * @addr:		Offloaded MAC address
+ * @index:		Offloaded index for given MAC address
+ * @ref_count:		Number of devs using this MAC address
+ * @repr_list:		List of reprs sharing this MAC address
+ * @bridge_count:	Number of bridge/internal devs with MAC
  */
 struct nfp_tun_offloaded_mac {
 	struct rhash_head ht_node;
@@ -153,6 +155,7 @@ struct nfp_tun_offloaded_mac {
 	u16 index;
 	int ref_count;
 	struct list_head repr_list;
+	int bridge_count;
 };
 
 static const struct rhashtable_params offloaded_macs_params = {
@@ -573,6 +576,8 @@ nfp_tunnel_offloaded_macs_inc_ref_and_link(struct nfp_tun_offloaded_mac *entry,
 			list_del(&repr_priv->mac_list);
 
 		list_add_tail(&repr_priv->mac_list, &entry->repr_list);
+	} else if (nfp_flower_is_supported_bridge(netdev)) {
+		entry->bridge_count++;
 	}
 
 	entry->ref_count++;
@@ -589,20 +594,35 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
 	if (entry && nfp_tunnel_is_mac_idx_global(entry->index)) {
-		nfp_tunnel_offloaded_macs_inc_ref_and_link(entry, netdev, mod);
-		return 0;
+		if (entry->bridge_count ||
+		    !nfp_flower_is_supported_bridge(netdev)) {
+			nfp_tunnel_offloaded_macs_inc_ref_and_link(entry,
+								   netdev, mod);
+			return 0;
+		}
+
+		/* MAC is global but matches need to go to pre_tun table. */
+		nfp_mac_idx = entry->index | NFP_TUN_PRE_TUN_IDX_BIT;
 	}
 
-	/* Assign a global index if non-repr or MAC address is now shared. */
-	if (entry || !port) {
-		ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
-					 NFP_MAX_MAC_INDEX, GFP_KERNEL);
-		if (ida_idx < 0)
-			return ida_idx;
+	if (!nfp_mac_idx) {
+		/* Assign a global index if non-repr or MAC is now shared. */
+		if (entry || !port) {
+			ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
+						 NFP_MAX_MAC_INDEX, GFP_KERNEL);
+			if (ida_idx < 0)
+				return ida_idx;
 
-		nfp_mac_idx = nfp_tunnel_get_global_mac_idx_from_ida(ida_idx);
-	} else {
-		nfp_mac_idx = nfp_tunnel_get_mac_idx_from_phy_port_id(port);
+			nfp_mac_idx =
+				nfp_tunnel_get_global_mac_idx_from_ida(ida_idx);
+
+			if (nfp_flower_is_supported_bridge(netdev))
+				nfp_mac_idx |= NFP_TUN_PRE_TUN_IDX_BIT;
+
+		} else {
+			nfp_mac_idx =
+				nfp_tunnel_get_mac_idx_from_phy_port_id(port);
+		}
 	}
 
 	if (!entry) {
@@ -671,6 +691,25 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		list_del(&repr_priv->mac_list);
 	}
 
+	if (nfp_flower_is_supported_bridge(netdev)) {
+		entry->bridge_count--;
+
+		if (!entry->bridge_count && entry->ref_count) {
+			u16 nfp_mac_idx;
+
+			nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
+			if (__nfp_tunnel_offload_mac(app, mac, nfp_mac_idx,
+						     false)) {
+				nfp_flower_cmsg_warn(app, "MAC offload index revert failed on %s.\n",
+						     netdev_name(netdev));
+				return 0;
+			}
+
+			entry->index = nfp_mac_idx;
+			return 0;
+		}
+	}
+
 	/* If MAC is now used by 1 repr set the offloaded MAC index to port. */
 	if (entry->ref_count == 1 && list_is_singular(&entry->repr_list)) {
 		u16 nfp_mac_idx;
-- 
2.7.4

