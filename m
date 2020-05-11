Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5311D1CDC18
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgEKNyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730358AbgEKNx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:59 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E2C05BD0A;
        Mon, 11 May 2020 06:53:58 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n5so4456876wmd.0;
        Mon, 11 May 2020 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OH1olGPnTpsv3T7idK9mBZYtn6ySoVmD3USmxlzU0iU=;
        b=uOgAoMxGkQM2FVnQsB3GyPUrSFm64+3MLp/UqNdnFWwrpc3JT7Q5Oh978nsZVIiXBb
         ZsJieF6TSQreeAqps7dqxLvRYl95Tw/3V1fOOYmn2wdCiuCT9BGtW7ov2yOzU528Qv8M
         PHdfpSWznPPAhBT2+FimU8OxxITiWmLqV2oTRtr8cphVtpDdHtio9ttkDJRK9zqxKQYf
         6pkmWwEUd9T42os5jYTcrS7B4r3PLSAjoLGyD/jW6fxaxcnhMFqMK9Up/GC3AV5L1uGH
         15md08L+ZnQMUFwGafyOoWcq8O1RTVQWSLuWsfuUMUrZx9jm7EnI8TNI0wyfA9zR+6q8
         n2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OH1olGPnTpsv3T7idK9mBZYtn6ySoVmD3USmxlzU0iU=;
        b=S+htrOSlqjmuF09qM0QdESdC9L7Pdp3waKTHTtrK4JCcn1Wa5xPKmEs9k8IoibxGTu
         I7Em4KtYYxzgWEn7b/heA63w7mSrtIiBhoIyCGt5vjNMdQoIUUX17gVqbIr8dILLgvfp
         4xU6krHpO8R9SEV3/huI6jiQfEvAsfSLa119n1YPuGlpCEHh0d+66TCd89Wxrx1aeIEw
         rEUqvQcd1ccOYjtLo6lj5p9jV1C9E0m4MV9zC7hGra/4sm2ycq7p/OX4jF+eWpvKlweh
         mYrfVDacJWJm09TeJThJT0U+IEFEuT91g8I/h+80awhn0uqx5i62Dv84lShFndSTGo3j
         yl5A==
X-Gm-Message-State: AGi0Pubfbov+PPw/eX7a3rAsKclxrWukzSRIRRCovFd2Xw8D4JjZh/FD
        0mpPJg8DvhgOr2hvMMTJO1I=
X-Google-Smtp-Source: APiQypIrPWj4Rjqwan79YFQXLtjkNMrIIi6sBOiUWCRiYxCSLkiI05XChdNhcVS1dwuWorMQiGvbrw==
X-Received: by 2002:a1c:4c3:: with SMTP id 186mr2465205wme.5.1589205237336;
        Mon, 11 May 2020 06:53:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 10/15] net: dsa: tag_sja1105: implement sub-VLAN decoding
Date:   Mon, 11 May 2020 16:53:33 +0300
Message-Id: <20200511135338.20263-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Create a subvlan_map as part of each port's tagger private structure.
This keeps reverse mappings of bridge-to-dsa_8021q VLAN retagging rules.

Note that as of this patch, this piece of code is never engaged, due to
the fact that the driver hasn't installed any retagging rule, so we'll
always see packets with a subvlan code of 0 (untagged).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c |  4 ++++
 include/linux/dsa/sja1105.h            |  1 +
 net/dsa/tag_sja1105.c                  | 19 +++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 042ecbbc5572..fe300cf94509 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2864,6 +2864,7 @@ static int sja1105_probe(struct spi_device *spi)
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
+		int subvlan;
 
 		if (!dsa_is_user_port(ds, port))
 			continue;
@@ -2884,6 +2885,9 @@ static int sja1105_probe(struct spi_device *spi)
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
+
+		for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+			sp->subvlan_map[subvlan] = VLAN_N_VID;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e47acf0965c5..cac168852321 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -54,6 +54,7 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
 
 struct sja1105_port {
+	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
 	struct kthread_worker *xmit_worker;
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 0a95fdd7bff8..f690511b6d31 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -241,6 +241,20 @@ static struct sk_buff
 	return skb;
 }
 
+static void sja1105_decode_subvlan(struct sk_buff *skb, u16 subvlan)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct sja1105_port *sp = dp->priv;
+	u16 vid = sp->subvlan_map[subvlan];
+	u16 vlan_tci;
+
+	if (vid == VLAN_N_VID)
+		return;
+
+	vlan_tci = (skb->priority << VLAN_PRIO_SHIFT) | vid;
+	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
@@ -250,6 +264,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
+	u16 subvlan = 0;
 	bool is_tagged;
 	bool is_meta;
 
@@ -273,6 +288,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+		subvlan = dsa_8021q_rx_subvlan(vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -297,6 +313,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	if (subvlan)
+		sja1105_decode_subvlan(skb, subvlan);
+
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
-- 
2.17.1

