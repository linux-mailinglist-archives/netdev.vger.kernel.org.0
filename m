Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E8C26EA43
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRBHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgIRBHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:39 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE44C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:39 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q13so5796036ejo.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gMnn+3ijzX9xUjpcQpFh+UbI23b8gpkZfS877nin950=;
        b=jHWhDRDEhnjyqlonIiGsyJJnu+iLgcSfCLV7/8QnqGkxULYDbrAQTDl+iPRvmN340h
         4ZmLpWN5iFXMamgEWT40Pjr+iVqOFWV54leFCq4Gt7tozlVr6uqaIqS7G4IpyxQjFJnB
         0173b5imWUEAkQBOkVQ9SJWmWhi2A2XBYh1+kIC1wdD38pfsYAE/1skcRCM9HkxuxZ7+
         rjkSowm34Olb2VuR0mEDVSVFQjvi+roOL/eyeKBoz9w7fnupb9KMhngpxxWCLiHtTBCg
         vO93uWlpZoaM/yE/lTnxL1eu0SIA/O+4YZJa7da7glOGmuWZ5rSXyKwk0J6UStsiv0j/
         8zCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gMnn+3ijzX9xUjpcQpFh+UbI23b8gpkZfS877nin950=;
        b=WFC77QhhQc2tAhcu26gp/3/BqOhw0BnsY5+Be9RrlJr+BmHuWyKsHu6ZOtIxa8ySQo
         YLRgbCeCDxOQtF3C6eDfdzfpOyCPdJg/vGSLsBShTiyMxCDM5xv8ELk7rIrFapyQI0QI
         HrwtRj5cKkRUNgfoWga/ETgn9TfYpbW7kDgPhVFxlEM4ZfVqCD9xiVXyHIVcaMAz6sst
         oOjdRSXKPhf3quXQHOkTubLkdfb8g3X1HyzwcH6oI5kXdOqjrAOyYD/kFJBqmV6c7cad
         cHVNOAYzmesIq6nO08jYsq3m+F3HWov07oS/GQ50aKhGc9Hq0w0UWxF5/glv6bymwOUE
         wOmg==
X-Gm-Message-State: AOAM53054qMUx6LtWsU9+KHw0cVtTlnxj3l/xfbcrN7TaA9wsLWCPe/k
        UrGH01m1PEE0d0HbIOuc2WQ=
X-Google-Smtp-Source: ABdhPJynxj89yr59WS1v5qc2Mq9TDC5yJcE9iU5/Wyd4cV6YXyw0Wd3lZmPmfD6amrsgfaug7hY7ng==
X-Received: by 2002:a17:907:aa9:: with SMTP id bz9mr32563451ejc.421.1600391257900;
        Thu, 17 Sep 2020 18:07:37 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 2/8] net: mscc: ocelot: add locking for the port TX timestamp ID
Date:   Fri, 18 Sep 2020 04:07:24 +0300
Message-Id: <20200918010730.2911234-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot_port->ts_id is used to:
(a) populate skb->cb[0] for matching the TX timestamp in the PTP IRQ
    with an skb.
(b) populate the REW_OP from the injection header of the ongoing skb.
Only then is ocelot_port->ts_id incremented.

This is a problem because, at least theoretically, another timestampable
skb might use the same ocelot_port->ts_id before that is incremented.
Normally all transmit calls are serialized by the netdev transmit
spinlock, but in this case, ocelot_port_add_txtstamp_skb() is also
called by DSA, which has started declaring the NETIF_F_LLTX feature
since commit 2b86cb829976 ("net: dsa: declare lockless TX feature for
slave ports").  So the logic of using and incrementing the timestamp id
should be atomic per port.

The solution is to use the global ocelot_port->ts_id only while
protected by the associated ocelot_port->ts_id_lock. That's where we
populate skb->cb[0]. Note that for ocelot, ocelot_port_add_txtstamp_skb
is called for the actual skb, but for felix, it is called for the skb's
clone. That is something which will also be changed in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
Added an extra explanation about NETIF_F_LLTX in commit message.

 drivers/net/ethernet/mscc/ocelot.c     |  8 +++++++-
 drivers/net/ethernet/mscc/ocelot_net.c |  6 ++----
 include/soc/mscc/ocelot.h              |  1 +
 net/dsa/tag_ocelot.c                   | 11 +++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5abb7d2b0a9e..83eb7c325061 100644
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
@@ -1300,6 +1305,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	skb_queue_head_init(&ocelot_port->tx_skbs);
+	spin_lock_init(&ocelot_port->ts_id_lock);
 
 	/* Basic L2 initialization */
 
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

