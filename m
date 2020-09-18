Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7777726EA42
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIRBHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIRBHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B202C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id r7so5780860ejs.11
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+kWCR6aUEJm2UH9U9WnCYeVYUUyNOBgXHiL7tHQV/g0=;
        b=rdWj32tLSyQ8XfssA+jsfNQVWmRTg//l6qn8HWQFYnOXrPZ6Bty9VxCwSLhuHJEtej
         23GXai+euyGfS1UUuianpJjverGFniDh0Si63gW4sO4iAtpw53hHoQatAFAHzh33QzeQ
         tZS/91WPAeX1x1128wcajjjn4F+pLBrkzsgWZG/ooQO/OrCOSjITC2okvnqekxoxe0ci
         w0CEvAi4XiGM3XLx5lr2a8/3/ODFVJbCbqU6IgD4zPzQhZ5Z4RG4lOjRbHuzSQvCZscI
         ZTVeXccZKfdPjzE5pvQxeMpQ+1p0mRihhhSMmlDM7HbNUgDLE5B3QNwbnEwig+DvVABm
         0ZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+kWCR6aUEJm2UH9U9WnCYeVYUUyNOBgXHiL7tHQV/g0=;
        b=aF/bUNnYg1m582K5cthkgWF4qc/w8aat2XuzAOOdnQMyS5ykgHFfxzbd6rAYRDIr5o
         2FdDRVwqYp+CTdjrjFzNzDYWmIqpKUMz9lz11mU493HQcQ5YMSMaHfNpMFWCue4UbSw1
         9iUUJhjj6BNe93djjz/rlZQhp/Kcx8GyLoRkCtlVPXufKgufgVFYNyVGpwLyuEgjo6aQ
         G1zatDg9l7EXBHgbnX1fz/JXzz0ih+5IPPQIKsXrZcGWxFsifh2KVq3uUVYQAePf1e+w
         fixFHhOyyLH25G828tMwDXXQz4IerqPnXzCxsfr6qD1F+VUuH6tniw8ujk0uPbFigEXk
         uzQA==
X-Gm-Message-State: AOAM533E+2Krs2lZnMxmp0dA95zJI5DmJSKGLfADgLNtgv4m2jpFtsBq
        xgJb692pYxEGd83K5gNCuCBCrXt2YrI=
X-Google-Smtp-Source: ABdhPJy4DFXG9vjRvk6CQ8RqWm+QGjSQZqJ80h3Gl0FedcA5wHFbSAud9tI/NDpeOU3SR1BVuOvmxA==
X-Received: by 2002:a17:906:7c82:: with SMTP id w2mr32873346ejo.87.1600391256731;
        Thu, 17 Sep 2020 18:07:36 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 1/8] net: mscc: ocelot: fix race condition with TX timestamping
Date:   Fri, 18 Sep 2020 04:07:23 +0300
Message-Id: <20200918010730.2911234-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
None.

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

