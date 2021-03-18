Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF613410EA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhCRXTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhCRXTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:05 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B5C06174A;
        Thu, 18 Mar 2021 16:19:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bx7so8665408edb.12;
        Thu, 18 Mar 2021 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6KnaRKz3FZky+YTs1fylHOv0wAd/1b2dy0PqKV1GgiQ=;
        b=uOvX+fEYDMQnS3cr87rrAy2BG5DFwX8cFlgz7HceQZu9kA4DOmibmfyzY/XKKJIZ8G
         aNpY1Q+pi3IHzZLafTz2bKOHsLF2vi59Jdgazk3WWVe53bKR+pDJYgxr0P5Xmsdzir8D
         ha/u7VJhAPHiqoDpuG/jOjXTOOslAwSv9VPqBujg4dosyl5wNoViTtG5THrYh1lbxaYi
         foCLCzBAirohefjK4giEH6tEzdgYkdMUsG4dnx7oRmMUw8SQyfL/ZX/EEuqZmsAyJEeT
         lh/2YbCqWVZ0PZRVCAYobKE9gp1kcnXIzWeggWq2OX+SZXYERZHvUjhfhB+lHhRgwz3K
         okCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6KnaRKz3FZky+YTs1fylHOv0wAd/1b2dy0PqKV1GgiQ=;
        b=YfD4+A50n1xt8whR242dgNGxKOr5HRS/lamIQO4OJJK0t7AaLu1uVTXI3aHq02/4dS
         2c3eTe0RTQfyBgsKAYFOGe9TFlHsTcmtmK3LeyFN2NUZal8D5zU69s4//piGHdY/cM2C
         PAK7pj9su7UQQDr+RNPXkzryS8WjDmyT+JYGT6XJz3CtetkYsQJmWjI6pHczZrcVnEF8
         JHkhmonLWdkBMdlvQ31TATNBCRi2TaRqhJ5yb3WcztW+umkBnsUOO05kXY/ojETzwtyK
         twgEh1pm3kPHcXxr1SbUBUh+a5Nn+MJ/tq0DCyr8k68VK/DpzOg30MLDreelJUbFtWHU
         fmPg==
X-Gm-Message-State: AOAM531hK8JrpW187w3TVdNrKeZ4xLx5BSO6QbRGQ1Mp8kt4zvZu0dQa
        KpNVs3GiZv7wVo6/g14cJu8=
X-Google-Smtp-Source: ABdhPJyOXzI4vllzQcOKzmhIAhLmSEBvt9kCZ7fdLUGy4NcIv3FU+kwDaxZlgyCLmr1F9paQzSKW5g==
X-Received: by 2002:aa7:cf16:: with SMTP id a22mr6346550edy.288.1616109544299;
        Thu, 18 Mar 2021 16:19:04 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:19:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 14/16] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
Date:   Fri, 19 Mar 2021 01:18:27 +0200
Message-Id: <20210318231829.3892920-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA has gained the recent ability to deal gracefully with upper
interfaces it cannot offload, such as the bridge, bonding or team
drivers. When such uppers exist, the ports are still in standalone mode
as far as the hardware is concerned.

But when we deliver packets to the software bridge in order for that to
do the forwarding, there is an unpleasant surprise in that the bridge
will refuse to forward them. This is because we unconditionally set
skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
were already forwarded in hardware by us.

Since dp->bridge_dev is populated only when there is hardware offload
for it, but not in the software fallback case, let's introduce a new
helper that can be called from the tagger data path which sets the
skb->offload_fwd_mark accordingly to zero when there is no hardware
offload for bridging. This lets the bridge forward packets back to other
interfaces of our switch, if needed.

Without this change, sending a packet to the CPU for an unoffloaded
interface triggers this WARN_ON:

void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
			      struct sk_buff *skb)
{
	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
}

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa_priv.h         | 14 ++++++++++++++
 net/dsa/tag_brcm.c         |  2 +-
 net/dsa/tag_dsa.c          | 15 +++++++++++----
 net/dsa/tag_hellcreek.c    |  2 +-
 net/dsa/tag_ksz.c          |  2 +-
 net/dsa/tag_lan9303.c      |  3 ++-
 net/dsa/tag_mtk.c          |  2 +-
 net/dsa/tag_ocelot.c       |  2 +-
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_rtl4_a.c       |  2 +-
 net/dsa/tag_sja1105.c      |  4 ++--
 net/dsa/tag_xrs700x.c      |  2 +-
 12 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 92282de54230..b61bef79ce84 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -349,6 +349,20 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	return skb;
 }
 
+/* If the ingress port offloads the bridge, we mark the frame as autonomously
+ * forwarded by hardware, so the software bridge doesn't forward in twice, back
+ * to us, because we already did. However, if we're in fallback mode and we do
+ * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * pointer is not populated, and flooding needs to be done by software (we are
+ * effectively operating in standalone ports mode).
+ */
+static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+
+	skb->offload_fwd_mark = !!(dp->bridge_dev);
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e2577a7dcbca..a8880b3bb106 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -150,7 +150,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7e7b7decdf39..09ab9c25e686 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -162,8 +162,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
+	bool trap = false, trunk = false;
 	int source_device, source_port;
-	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -174,8 +174,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	cmd = dsa_header[0] >> 6;
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
-		skb->offload_fwd_mark = 1;
-
 		trunk = !!(dsa_header[1] & 7);
 		break;
 
@@ -194,7 +192,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			 * device (like a bridge) that forwarding has
 			 * already been done by hardware.
 			 */
-			skb->offload_fwd_mark = 1;
 			break;
 		case DSA_CODE_MGMT_TRAP:
 		case DSA_CODE_IGMP_MLD_TRAP:
@@ -202,6 +199,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			/* Traps have, by definition, not been
 			 * forwarded by hardware, so don't mark them.
 			 */
+			trap = true;
 			break;
 		default:
 			/* Reserved code, this could be anything. Drop
@@ -235,6 +233,15 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
+	/* When using LAG offload, skb->dev is not a DSA slave interface,
+	 * so we cannot call dsa_default_offload_fwd_mark and we need to
+	 * special-case it.
+	 */
+	if (trunk)
+		skb->offload_fwd_mark = true;
+	else if (!trap)
+		dsa_default_offload_fwd_mark(skb);
+
 	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
 	 * tag, and delete the ethertype (extra) if applicable. If the
 	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index a09805c8e1ab..c1ee6eefafe4 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -44,7 +44,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..8eee63a5b93b 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -24,7 +24,7 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - len);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index aa1318dccaf0..3a5494d2f7b1 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -115,7 +115,8 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_pull_rcsum(skb, 2 + 2);
 	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
 		2 * ETH_ALEN);
-	skb->offload_fwd_mark = !(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU);
+	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
+		dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index f9b2966d1936..92ab21d2ceca 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -92,7 +92,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index f9df9cac81c5..1deba3f1bb82 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -123,7 +123,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 		 */
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
 
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 5f3e8e124a82..447e1eeb357c 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -81,7 +81,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
 
 	return skb;
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index e9176475bac8..1864e3a74df8 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -114,7 +114,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
 		2 * ETH_ALEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 50496013cdb7..45cdf64f0e88 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -295,8 +295,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-	skb->offload_fwd_mark = 1;
-
 	if (is_tagged) {
 		/* Normal traffic path. */
 		skb_push_rcsum(skb, ETH_HLEN);
@@ -339,6 +337,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	dsa_default_offload_fwd_mark(skb);
+
 	if (subvlan)
 		sja1105_decode_subvlan(skb, subvlan);
 
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index 858cdf9d2913..1208549f45c1 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -46,7 +46,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
 		return NULL;
 
 	/* Frame is forwarded by hardware, don't forward in software. */
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
-- 
2.25.1

