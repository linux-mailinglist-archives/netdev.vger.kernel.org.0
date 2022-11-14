Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F81627E46
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiKNMnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiKNMnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:43:00 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41CA25EB2;
        Mon, 14 Nov 2022 04:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9y7P2AOYEluuMvwNtI2JOIUn32WWK6gjZOLBZl08Qkc=; b=Rsxs0CSLozVk4T+Vh6ToJXMrqc
        a/Szhu4OowHDqFGX+GA9yfyX55AGqmiflGsEPVhlHYOS/mxG01nN/GLArXNfjbGEdwdzYIjeAhUXK
        LFiCSF7jwaP2ljFYPmx15HbCeFUEBujiKLVRa4owzAtjI89g3y1bOYRqWLPinjhucmWI=;
Received: from p54ae9c3f.dip0.t-ipconnect.de ([84.174.156.63] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ouYn7-0021wc-IT; Mon, 14 Nov 2022 13:42:21 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/4] net: dsa: add support for DSA rx offloading via metadata dst
Date:   Mon, 14 Nov 2022 13:42:11 +0100
Message-Id: <20221114124214.58199-2-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124214.58199-1-nbd@nbd.name>
References: <20221114124214.58199-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
port netdev, assume that it carries the port number and that there is no DSA
tag present in the skb data.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/core/flow_dissector.c |  4 +++-
 net/dsa/dsa.c             | 19 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25cd35f5922e..3e81798ed3e0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -971,12 +971,14 @@ bool __skb_flow_dissect(const struct net *net,
 #if IS_ENABLED(CONFIG_NET_DSA)
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
 			     proto == htons(ETH_P_XDSA))) {
+			struct metadata_dst *md_dst = skb_metadata_dst(skb);
 			const struct dsa_device_ops *ops;
 			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
 			/* Only DSA header taggers break flow dissection */
-			if (ops->needed_headroom) {
+			if (ops->needed_headroom &&
+			    (!md_dst || md_dst->type != METADATA_HW_PORT_MUX)) {
 				if (ops->flow_dissect)
 					ops->flow_dissect(skb, &proto, &offset);
 				else
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 64b14f655b23..6caf2ec648fd 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
 #include <linux/ptp_classify.h>
+#include <net/dst_metadata.h>
 
 #include "dsa_priv.h"
 
@@ -216,6 +217,7 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
 static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 			  struct packet_type *pt, struct net_device *unused)
 {
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct sk_buff *nskb = NULL;
 	struct dsa_slave_priv *p;
@@ -229,7 +231,22 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb)
 		return 0;
 
-	nskb = cpu_dp->rcv(skb, dev);
+	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
+		unsigned int port = md_dst->u.port_info.port_id;
+
+		skb_dst_drop(skb);
+		if (!skb_has_extensions(skb))
+			skb->slow_gro = 0;
+
+		skb->dev = dsa_master_find_slave(dev, 0, port);
+		if (likely(skb->dev)) {
+			dsa_default_offload_fwd_mark(skb);
+			nskb = skb;
+		}
+	} else {
+		nskb = cpu_dp->rcv(skb, dev);
+	}
+
 	if (!nskb) {
 		kfree_skb(skb);
 		return 0;
-- 
2.38.1

