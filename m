Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011972DC3AE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgLPQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:44 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D4C061282
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:02:03 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 23so49612527lfg.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=+hAk/vmovDE/urE2Pq9HRbef7bP2ufQL7iLEf5MXpgg=;
        b=vtWkupwiayE9uGlEeDkdOSswdiAUHuDQFrBmrsDFWsiv1A5FQgcHba4hJJqNlC3WHg
         WFrNj1zrmRReOvGizK+dvJehk4E0geHvGuoPM9+iwLptFwqwAP0cxtYlGm60E34hclRs
         Xql5pUNxuWndacfgLcrayQxBfkJQpbkTJ/A7C1zoSJxrzowMRmGNNaVjFsHCQREVI4/L
         QyV8LT927+VGnes4Jo5+GGuifrpl6iaawu6T2yL6jwQKkNk4Gk51Mkf2+loA+TozwDau
         TGlYL3P4KiCLPqfEJnbWBmJhrO5tV4XNExO2aWt9ouzKLQ211eVGM3+M3P8tefMGpQaJ
         rHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=+hAk/vmovDE/urE2Pq9HRbef7bP2ufQL7iLEf5MXpgg=;
        b=D9LCywEGvkSmwzPUo4bkIwR+MJKJElWhN1DmKka5MCJOUHP0EdBdsefCLfEunpuJn+
         vbgjfewFFs15SStjF8om5qz8KikTcI0zVxC9nndBswjDUe0jKmXezhLP99cObrOUKNbN
         X/CYRPseG6AjSCElCKOKyBjJXUqpLl1bEh+hBgOqRMWIjT5IJTTdzkHdj4XEXMqQmOjZ
         Myd0cD4lVz1rtBLaFPnT6rW5KzKK4iVQOY7/RzG2hQPZNE3f4BpCdx9NZxfHiyH6xvUl
         GuWDiK1tc7dWO87GhEbqLz7uAp6o5VpyYCSal1SlWuoWoshmTIwyVOXMalMF/0WnmPr8
         bpOA==
X-Gm-Message-State: AOAM531jgCRknj5u4QDUmuOo4BbrfD71khJj8wSWzhtL3UtZajlHwQGR
        hT3PG1yBnGrJS8fc3NZXg4etHA==
X-Google-Smtp-Source: ABdhPJxp3smsXxMad4/JIls9dmsnMfljqVmws2Bz/MU7a562QtYD+VFLu6fcmY8w1dZI8Z3x6Bxing==
X-Received: by 2002:a2e:2a86:: with SMTP id q128mr14748389ljq.158.1608134519850;
        Wed, 16 Dec 2020 08:01:59 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:58 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 5/5] net: dsa: tag_dsa: Support reception of packets from LAG devices
Date:   Wed, 16 Dec 2020 17:00:56 +0100
Message-Id: <20201216160056.27526-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216160056.27526-1-tobias@waldekranz.com>
References: <20201216160056.27526-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets ingressing on a LAG that egress on the CPU port, which are not
classified as management, will have a FORWARD tag that does not
contain the normal source device/port tuple. Instead the trunk bit
will be set, and the port field holds the LAG id.

Since the exact source port information is not available in the tag,
frames are injected directly on the LAG interface and thus do never
pass through any DSA port interface on ingress.

Management frames (TO_CPU) are not affected and will pass through the
DSA port interface as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa.c     | 12 +++++++++++-
 net/dsa/tag_dsa.c | 17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..7325bf4608e9 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -219,11 +219,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	skb = nskb;
-	p = netdev_priv(skb->dev);
 	skb_push(skb, ETH_HLEN);
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
+		/* Packet is to be injected directly on an upper
+		 * device, e.g. a team/bond, so skip all DSA-port
+		 * specific actions.
+		 */
+		netif_rx(skb);
+		return 0;
+	}
+
+	p = netdev_priv(skb->dev);
+
 	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
 		nskb = dsa_untag_bridge_pvid(skb);
 		if (!nskb) {
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 112c7c6dd568..7e7b7decdf39 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -163,6 +163,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
 	int source_device, source_port;
+	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -174,6 +175,8 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
 		skb->offload_fwd_mark = 1;
+
+		trunk = !!(dsa_header[1] & 7);
 		break;
 
 	case DSA_CMD_TO_CPU:
@@ -216,7 +219,19 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	source_device = dsa_header[0] & 0x1f;
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
-	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
+	if (trunk) {
+		struct dsa_port *cpu_dp = dev->dsa_ptr;
+
+		/* The exact source port is not available in the tag,
+		 * so we inject the frame directly on the upper
+		 * team/bond.
+		 */
+		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port);
+	} else {
+		skb->dev = dsa_master_find_slave(dev, source_device,
+						 source_port);
+	}
+
 	if (!skb->dev)
 		return NULL;
 
-- 
2.17.1

