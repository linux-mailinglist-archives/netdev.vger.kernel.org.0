Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B5126ABDF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgIOS3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgIOSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EBCC061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:51 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l17so3970867edq.12
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IOg1xVU4SM6edz4CrwtEfVoIdKGFS+gO7jqioVPxwNg=;
        b=u8WfrNXU2lyppS1QfQ0hnijFncvvYVKAwix/TFGI+Ik8mGQcMdLdg1dHqjwhjzbm/S
         W0Xg06o9/FzqzxR2LOTZUg4v+TdeuKONCYYg7552gkY7tbhdx+DoxB3GMf69/6Pkd/p+
         kIOjZceBRqzw3jX9+JL15SkCf1SfOll8uic46HeqdRIapgo7f0qXN/EyoDbDU3T4zJak
         MV+e890zrEpSzpJ2NlY4T2L9+RfYdeTRpMYjv4WfO98Npyf5X/rvp1BdZaPXFKB3P7Jj
         usmNDD2la1RqJlBm7VYnVt7paRSEjK550hUBPe4PpqIr8wcgJAD0i0JAydFqIukq3eoS
         7W4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IOg1xVU4SM6edz4CrwtEfVoIdKGFS+gO7jqioVPxwNg=;
        b=cYfuA4nWpdoDXxWQ5aM9MqRJD78/KBCYIfFYO1R6MJTkTtykmi/WqfZ+qli2nYDHIv
         uol0J+NoxMhmw0hkyWeZ+Dd9kldXbK89//BLg8ERXFCffWP9O6JSOP9RnIdPZMyLBKCf
         YwxTcXvRUfxVKkJdKsxeEhoRroLie76hZYeNKjchMLrW5UebvSRehoAoR6XHkWohX6y7
         vusa4GFNhqVUK9lcwKaiwxreHaEAfVrkb1CwJshoKnqpTuznW36L7EabMIBaZPdOxmvN
         H8kL7Pmjb2LZ50bU9N7J/S24E3+My3URwlVel/Dhk3QlmGeC0F/CJHgPbm8zGvptnzgd
         yZMA==
X-Gm-Message-State: AOAM532PRiE6DMLujQRdeTRCUPmKI6+lPwqAmoSdaDs3EhkOQYTJ/P/w
        2T/yhB5e2RqO/RXDMNCDusVRYkixmXM=
X-Google-Smtp-Source: ABdhPJwUeCXXIF/qlTDHDqaVVdUQKSLKlci75sQySH4UXXqR8jALP3IHoLSkj1MdG4BTy+oFg9mJFA==
X-Received: by 2002:a50:fb98:: with SMTP id e24mr23396605edq.130.1600194170546;
        Tue, 15 Sep 2020 11:22:50 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 1/7] net: mscc: ocelot: fix race condition with TX timestamping
Date:   Tue, 15 Sep 2020 21:22:23 +0300
Message-Id: <20200915182229.69529-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The TX-timestampable skb is added late to the ocelot_port->tx_skbs. It
is in a race with the TX timestamp IRQ, which checks that queue trying
to match the timestamp with the skb by the ts_id. The skb should be
added to the queue before the IRQ can fire.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 0668d23cdbfa..cacabc23215a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -330,6 +330,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	u8 grp = 0; /* Send everything on CPU group 0 */
 	unsigned int i, count, last;
 	int port = priv->chip_port;
+	bool do_tstamp;
 
 	val = ocelot_read(ocelot, QS_INJ_STATUS);
 	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
@@ -344,10 +345,14 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	info.vid = skb_vlan_tag_get(skb);
 
 	/* Check if timestamping is needed */
+	do_tstamp = (ocelot_port_add_txtstamp_skb(ocelot_port, skb) == 0);
+
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
 		info.rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
+			ocelot_port->ts_id++;
+		}
 	}
 
 	ocelot_gen_ifh(ifh, &info);
@@ -380,12 +385,9 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
-	if (!ocelot_port_add_txtstamp_skb(ocelot_port, skb)) {
-		ocelot_port->ts_id++;
-		return NETDEV_TX_OK;
-	}
+	if (!do_tstamp)
+		dev_kfree_skb_any(skb);
 
-	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1

