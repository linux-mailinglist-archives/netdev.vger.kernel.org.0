Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654A41CCC4F
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgEJQnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729184AbgEJQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C98C061A0E;
        Sun, 10 May 2020 09:43:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k12so15373249wmj.3;
        Sun, 10 May 2020 09:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wuNa9dUTzo5dhNeShT+Z0EUvQDKyte55bwDEiseFjgE=;
        b=naL1fUrkes4Xk2tRknh7wo+NnUipoSbirgCAzpRaj+3S39UKrOxEoR9cOTIcTjH+0L
         N+dpYjN8nERaL14WE10JwSHpiUD8600A46S6pLBE7MTF0VTwFkiwNJ/ecj1Acnc/jvRZ
         y1qEz8sWKcQ33mjm//4kD+ARAwv4KbSmAxgj0NyBy6VoA0FuzWTbMWIHhpcDXIvULpVd
         oydXaRBzWYMHTLm35qaiXe6XXXYk8l8w6g+TGpmYgI2aAxalhiPI6PNwigxRKgD/dyLr
         ywUma8C27v6IXrRKmaNHVAJdDcfobn9HYP+IaWojTaM3D/o5z9pjiLUs2HMyM0UOjwf9
         cO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wuNa9dUTzo5dhNeShT+Z0EUvQDKyte55bwDEiseFjgE=;
        b=I6X9yEf1uqUC7Q4fuzRrX0Z0bwixvTSJvERO4H7za6DcisFKxbWjAyOaF2tJLMVkZV
         QeH5RDrJIURkr0L0B96pTNUYsM6/MPGVT0LG4+eqzvbOuEVfIMx4ypzDmSmcDJlcoq03
         MW5K4T0ULsM2IvszoiBL+iBHEmyDqy+Zm8tcuMPowoopEG7DCyq4Sj/AfIAexuHW/237
         UL9RdpZnuY7jv4niRxhyF7QzbMkUHt6dTm8Os8J5Q/IA0yawJkOdLozYJFGuMxX+iG9x
         ORlsjuSIlde1XVNOmm5/1pFv4Z7yTqES16tj5isFa4sbjUiOIKjsijuZjINiDtQfxlEw
         bxPA==
X-Gm-Message-State: AGi0PuarZzkeFvcTrZv6vhUGR4IqSrb4QI5ap8JxPHf0Az39dBIa5fkj
        ia50zr0SY3IRmTA5WzlsX44=
X-Google-Smtp-Source: APiQypK20K1daP+sQfApitxQsnIhmLeFGIKDF1+/V8mIJOiGnoTnaS9h2gaMrA73Ya3pUW7FE/LMrw==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr5281428wml.72.1589129017242;
        Sun, 10 May 2020 09:43:37 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/15] net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN simultaneously
Date:   Sun, 10 May 2020 19:42:48 +0300
Message-Id: <20200510164255.19322-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In VLAN-unaware mode, sja1105 uses VLAN tags with a custom TPID of
0xdadb. While in the yet-to-be introduced best_effort_vlan_filtering
mode, it needs to work with normal VLAN TPID values.

A complication arises when we must transmit a VLAN-tagged packet to the
switch when it's in VLAN-aware mode. We need to construct a packet with
2 VLAN tags, and the switch will use the outer header for routing and
pop it on egress. But sadly, here the 2 hardware generations don't
behave the same:

- E/T switches won't pop an ETH_P_8021AD tag on egress, it seems
  (packets will remain double-tagged).
- P/Q/R/S switches will drop a packet with 2 ETH_P_8021Q tags (it looks
  like it tries to prevent VLAN hopping).

But looks like the reverse is also true:

- E/T switches have no problem popping the outer tag from packets with
  2 ETH_P_8021Q tags.
- P/Q/R/S will have no problem popping a single tag even if that is
  ETH_P_8021AD.

So it is clear that if we want the hardware to work with dsa_8021q
tagging in VLAN-aware mode, we need to send different TPIDs depending on
revision. Keep that information in priv->info->qinq_tpid.

The per-port tagger structure will hold an xmit_tpid value that depends
not only upon the qinq_tpid, but also upon the VLAN awareness state
itself (in case we must transmit using 0xdadb).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  6 ++++++
 include/linux/dsa/sja1105.h            |  2 ++
 net/dsa/tag_sja1105.c                  | 17 +++++++----------
 5 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index c80f1999c694..a019ffae38f1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -87,6 +87,12 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
+	/* Both E/T and P/Q/R/S have quirks when it comes to popping the S-Tag
+	 * from double-tagged frames. E/T will pop it only when it's equal to
+	 * TPID from the General Parameters Table, while P/Q/R/S will only
+	 * pop it when it's equal to TPID2.
+	 */
+	u16 qinq_tpid;
 	int (*reset_cmd)(struct dsa_switch *ds);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8cf17238bc6a..34006b2def32 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2136,6 +2136,15 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		tpid2 = ETH_P_SJA1105;
 	}
 
+	for (port = 0; port < ds->num_ports; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+
+		if (enabled)
+			sp->xmit_tpid = priv->info->qinq_tpid;
+		else
+			sp->xmit_tpid = ETH_P_SJA1105;
+	}
+
 	if (!enabled)
 		state = SJA1105_VLAN_UNAWARE;
 	else
@@ -2845,6 +2854,7 @@ static int sja1105_probe(struct spi_device *spi)
 			goto out;
 		}
 		skb_queue_head_init(&sp->xmit_queue);
+		sp->xmit_tpid = ETH_P_SJA1105;
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 0be75c49e6c3..a0dacae803cc 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -512,6 +512,7 @@ struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
@@ -526,6 +527,7 @@ struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
@@ -540,6 +542,7 @@ struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -555,6 +558,7 @@ struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -570,6 +574,7 @@ struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -586,6 +591,7 @@ struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 136481ce3c6f..e47acf0965c5 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -9,6 +9,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/8021q.h>
 #include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
@@ -59,6 +60,7 @@ struct sja1105_port {
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
+	u16 xmit_tpid;
 };
 
 bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds);
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5368cd34bcf4..0a95fdd7bff8 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -96,6 +96,11 @@ static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
 	return NULL;
 }
 
+static u16 sja1105_xmit_tpid(struct sja1105_port *sp)
+{
+	return sp->xmit_tpid;
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -111,15 +116,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	if (unlikely(sja1105_is_link_local(skb)))
 		return sja1105_defer_xmit(dp->priv, skb);
 
-	/* If we are under a vlan_filtering bridge, IP termination on
-	 * switch ports based on 802.1Q tags is simply too brittle to
-	 * be passable. So just defer to the dsa_slave_notag_xmit
-	 * implementation.
-	 */
-	if (dsa_port_is_vlan_filtering(dp))
-		return skb;
-
-	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
+	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
@@ -258,7 +255,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	hdr = eth_hdr(skb);
 	tpid = ntohs(hdr->h_proto);
-	is_tagged = (tpid == ETH_P_SJA1105);
+	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-- 
2.17.1

