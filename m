Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E126ABBF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgIOSZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbgIOSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:31 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFCEC06178A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:53 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lo4so6431755ejb.8
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hjGO74Y14ZZkNh5mrFNoDF9W9sEHp4cM7sgDblbixg=;
        b=C6p40KrGTAKu1SHv54+M9hNw1gZDOTzWhYnkC/hTU1F3+q++lDxaMPrvOoPw1WIXBh
         J0OxWdZ2+P+FmVvfuRfFpM971uGKEddURX3ifybTfdDzVfwfJOYWIJh6vQwuHlqC8cc4
         d1QlXHTL3F2e9k7T7SEhgu9V6X/eMx1hHI0swYH3fp+3YTLmvKPj7LosKjqkaC0/lcZH
         lgul467lD8wvqn0eDgMpnOS/fO9s/pzXUe2ittJiEwxM7rjP4cpgPqGyAIu18FQR/UEH
         qWXkM6JSgngW9cs9ePYMIRBelr2BrJRhhJwJfKfMktWxRJLBfcVoZcc7PqtiP7+rhIcF
         LLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hjGO74Y14ZZkNh5mrFNoDF9W9sEHp4cM7sgDblbixg=;
        b=Vzx1JFY8U3Rq5g4UmN6mZSxrY9QKmEPYpiO6RetZU2ufNEudTtLzBMGMsC3GkEa0tc
         d66FImH6ioe90G3UASAwsDG5xG1eQb2oqvSy5Ainb3kn9S0rKhdZpKMpwIU2BRlmq5W+
         v5HzYDiwlqp029iWtFvm0DAshx4pLvfg83So9jZnDsOa4W0WOxl5tHvgGp83UGiavqvW
         hBz4oux0g9fHVfCeTFBFHqp4iuOQNvTUzlaI6MnIP+GUGEbYmgEte5l4OIlwXGtSKYtZ
         NdE5J9jklO9esZFk3cIBmkPxs9pq+uZZge7cTr7JMgNgh0xRVz8l5s71CP0aNKZVRNTw
         RdKQ==
X-Gm-Message-State: AOAM531xmts/LJwmjYbIPaxp1mRh5uFLGzuPBZtQYJ575gbM6aLEsdCW
        VdY/X3siSk1MTfUlCycjVsI=
X-Google-Smtp-Source: ABdhPJwHR+829lW0kpxk1Xt0L7RtEv62ILK9Y8ZUxSKRcOTEVU9XynPV65tMxEQ5+tZbDeItMmZmLQ==
X-Received: by 2002:a17:906:3791:: with SMTP id n17mr21133462ejc.216.1600194171657;
        Tue, 15 Sep 2020 11:22:51 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 2/7] net: mscc: ocelot: add locking for the port TX timestamp ID
Date:   Tue, 15 Sep 2020 21:22:24 +0300
Message-Id: <20200915182229.69529-3-olteanv@gmail.com>
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

The ocelot_port->ts_id is used to:
- populate skb->cb[0] for matching the TX timestamp in the PTP IRQ with
  an skb.
- populate the REW_OP from the injection header of the ongoing skb.
Only then is ocelot_port->ts_id incremented.

This is a problem because, at least theoretically, another timestampable
skb might use the same ocelot_port->ts_id before that is incremented. So
the logic of using and incrementing the timestamp id should be atomic
per port.

The solution is to use the global ocelot_port->ts_id only while
protected by the associated ocelot_port->ts_id_lock. That's where we
populate skb->cb[0]. Note that for ocelot,
ocelot_port_add_txtstamp_skb() is called for the actual skb, but for
felix, it is called for the skb's clone. That is something which will
also be changed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 13 ++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c |  6 ++----
 include/soc/mscc/ocelot.h              |  1 +
 net/dsa/tag_ocelot.c                   | 11 +++++++----
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5abb7d2b0a9e..8caf3afd464d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -421,10 +421,15 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
 	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		spin_lock(&ocelot_port->ts_id_lock);
+
 		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
 		/* Store timestamp ID in cb[0] of sk_buff */
-		skb->cb[0] = ocelot_port->ts_id % 4;
+		skb->cb[0] = ocelot_port->ts_id;
+		ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
 		skb_queue_tail(&ocelot_port->tx_skbs, skb);
+
+		spin_unlock(&ocelot_port->ts_id_lock);
 		return 0;
 	}
 	return -ENODATA;
@@ -1443,6 +1448,12 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		spin_lock_init(&ocelot_port->ts_id_lock);
+	}
+
 	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index cacabc23215a..8490e42e9e2d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -349,10 +349,8 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
 		info.rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
-			ocelot_port->ts_id++;
-		}
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			info.rew_op |= skb->cb[0] << 3;
 	}
 
 	ocelot_gen_ifh(ifh, &info);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index da369b12005f..4521dd602ddc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -566,6 +566,7 @@ struct ocelot_port {
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
+	spinlock_t			ts_id_lock;
 
 	phy_interface_t			phy_mode;
 
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 42f327c06dca..b4fc05cafaa6 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -160,11 +160,14 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
 
 	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+
 		rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-			rew_op |= (ocelot_port->ts_id  % 4) << 3;
-			ocelot_port->ts_id++;
-		}
+		/* Retrieve timestamp ID populated inside skb->cb[0] of the
+		 * clone by ocelot_port_add_txtstamp_skb
+		 */
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			rew_op |= clone->cb[0] << 3;
 
 		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
 	}
-- 
2.25.1

