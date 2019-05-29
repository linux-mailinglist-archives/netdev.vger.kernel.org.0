Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB8A2E7A8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfE2Vvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:51:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36208 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2Vve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:51:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so2537367wml.1
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x4yLH6jX61pVus2bl3CXDjhOsRJCRMH5gkVfPZAMGtE=;
        b=blkfkgr6d9PpzYi/ldPKm8Rh522bh1cl9DdFbi/x0nw5bqj+1KBTkgpy0TJk2+HSIA
         CgSlc8CfvG1vIOEqObqKFBO/HgMlkdhRaYfBlRhsO1VRNzpF1t1JrQbPEQUrJlahKWLV
         7mQvj5fuQlRCzpuW/oRLVundMlDSWID9QVz4LaBur2R6B6yk7YVJzDsOVNeyrrZ/Hb9r
         u88AqFEeRfk+m3KkjSDDEu6Xy2PpXhOscHrAwogCROzmM6frbsFysLi7aJbRQQMU2PfQ
         eLwEwQ8bHw4fv+WtIkTn7TbzVAbNbWuglavIVtkK/T59tKYCrMolJ6yyFy/f2xXPd9fQ
         MItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x4yLH6jX61pVus2bl3CXDjhOsRJCRMH5gkVfPZAMGtE=;
        b=Cnt5VcwLlrNHEnnV4WimKGN+4hIuT3HrZpFOKDjsQtyl3FdNEkLXhRq9mxZJiKi0DE
         valNde+LXaQ5/b0zr/Fp6hU2fEtZikC5vz1tn5UfjJU9sjXSQjNrWP0yA8faBWfMFE/n
         EB/7v0ShTeEUbTmm79noc4pjxN1F5TSfC2/umrrsjUFXSHpf8m7hkYOBMRbo8yLfirjk
         ncLIkyNNEH0tA3LFsYxOvvIYgxWjjrSWIvjY026an+OE0mtkWabzGY916ua9BPqwpqLm
         j/sjIpRVJaaaakOnjxmov9nxMv/3fXO2FMFMHIiMOH5WtMxfVuPZVjJ065427TYzBzmN
         V3ag==
X-Gm-Message-State: APjAAAVw+ULQ1lO0zC3id/0xg0DHsfyvcaL0zt+k/EWzKx/hIDHmyYnJ
        CKfIaA5WltnhmHrYpRxdbx8=
X-Google-Smtp-Source: APXvYqxSSfZicpy87Hj0A7m7T3RPdQP5q4QOBhkoLEr7yqoqFHnor/DlTlqPnki8ZloqhDmkruxXug==
X-Received: by 2002:a1c:d182:: with SMTP id i124mr141456wmg.102.1559166693118;
        Wed, 29 May 2019 14:51:33 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id c14sm571643wrt.45.2019.05.29.14.51.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:51:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/1] net: dsa: sja1105: Don't store frame type in skb->cb
Date:   Thu, 30 May 2019 00:51:26 +0300
Message-Id: <20190529215126.13129-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to a confusion I thought that eth_type_trans() was called by the
network stack whereas it can actually be called by network drivers to
figure out the skb protocol and next packet_type handlers.

In light of the above, it is not safe to store the frame type from the
DSA tagger's .filter callback (first entry point on RX path), since GRO
is yet to be invoked on the received traffic.  Hence it is very likely
that the skb->cb will actually get overwritten between eth_type_trans()
and the actual DSA packet_type handler.

Of course, what this patch fixes is the actual overwriting of the
SJA1105_SKB_CB(skb)->type field from the GRO layer, which made all
frames be seen as SJA1105_FRAME_TYPE_NORMAL (0).

Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/dsa/sja1105.h | 12 ------------
 net/dsa/tag_sja1105.c       | 10 +++-------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 603a02e5a8cb..e46e18c47d41 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -20,18 +20,6 @@
 #define SJA1105_LINKLOCAL_FILTER_B		0x011B19000000ull
 #define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFF000000ull
 
-enum sja1105_frame_type {
-	SJA1105_FRAME_TYPE_NORMAL = 0,
-	SJA1105_FRAME_TYPE_LINK_LOCAL,
-};
-
-struct sja1105_skb_cb {
-	enum sja1105_frame_type type;
-};
-
-#define SJA1105_SKB_CB(skb) \
-	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
-
 struct sja1105_port {
 	struct dsa_port *dp;
 	int mgmt_slot;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 969402c7dbf1..d43737e6c3fb 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -28,14 +28,10 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (sja1105_is_link_local(skb)) {
-		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_LINK_LOCAL;
+	if (sja1105_is_link_local(skb))
 		return true;
-	}
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr)) {
-		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_NORMAL;
+	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
 		return true;
-	}
 	return false;
 }
 
@@ -84,7 +80,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	skb->offload_fwd_mark = 1;
 
-	if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_LINK_LOCAL) {
+	if (sja1105_is_link_local(skb)) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
-- 
2.17.1

