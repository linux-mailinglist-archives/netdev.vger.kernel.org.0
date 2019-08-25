Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578869C5ED
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 21:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfHYTqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 15:46:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37968 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfHYTqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 15:46:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so13310712wrr.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 12:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=73kotSlmFW5HPznXmJxO/lAptpida7kA+BzlW3sRFCY=;
        b=b6FWnZGlCfBPMD/S4M4IlX5tYFvd99WOLZPydWz6X9tKdrecHtV4uxl+KmmRS0Rq6i
         tFkvkh4xy+JKvI0HfUPxL3xGzCH0fKvPKAzN948aQQcqRcZJRW+9mUmrwuAHJkft61xg
         BODYbzOe0CQgH38Oqe47T5Qp934g0wq2CudrOwIHDyjdBBavb1N5MuaKGVPXTky2fH3V
         8Clf8Mq6QABH1xGY4VhRvnn6la6MJsyx8cVZuDg/Xmm19y02DdHIES/9jWBsRiBAaBJN
         whm6wqyeHGEqMFXl57Rt4DrzMGFtEqcaZ8n2M07833yQ24eQQKyGBaehwicFIbhYkOgr
         adEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=73kotSlmFW5HPznXmJxO/lAptpida7kA+BzlW3sRFCY=;
        b=EqX7n9zErGpgZn1U38dS32spdqt8XAr7OIEXIMia/6z3fGnR5jF7/8R3YrnyFmLtHm
         sK4waDN3MtKcxIrW88GhBROeAphzvoejbbPRnhT4wusDB9n3drxemGAb6y8sdP80ZTo0
         flSqvjg1XJZ8tEhUMoOb8j/jP0j83r4+dQAntg4+cCReh7XU0LBMZVriN9OJ626yhaQY
         WiRun/JWAazJttP3YJ45MacFZyx8k9bA45gdDyXBYBif387v2lqQEUjOK+00C5jMrIu+
         b/y3oMH8KE9lh7fBeC8mkhbb6lGh2k4MuS9a2eBULYeYbPSI6Wjw9Oynj7cV5Ax0nfBu
         iSqg==
X-Gm-Message-State: APjAAAX0Si0yt7CrC2KP9r7eIUZqRw8eZKIAh+3DQh8qChTtlZ1QQUpy
        +oXYcKvp51C6kaTIMUPDiCRjqxtT
X-Google-Smtp-Source: APXvYqy/ZlzkC17RCY7R6PjGRd1tM3c9dEJHYnKxlhrktH/7ZMnClYFSXx1Ovrlx4b0MthFaqKCvTw==
X-Received: by 2002:a5d:44cf:: with SMTP id z15mr18094248wrr.324.1566762403775;
        Sun, 25 Aug 2019 12:46:43 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id v124sm19770974wmf.23.2019.08.25.12.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 12:46:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: Clear VLAN filtering offload netdev feature
Date:   Sun, 25 Aug 2019 22:46:30 +0300
Message-Id: <20190825194630.12404-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190825194630.12404-1-olteanv@gmail.com>
References: <20190825194630.12404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch barely supports traffic I/O, and it does that by repurposing
VLANs when there is no bridge that is taking control of them.

Letting DSA declare this netdev feature as supported (see
dsa_slave_create) would mean that VLAN sub-interfaces created on sja1105
switch ports will be hardware offloaded. That means that
net/8021q/vlan_core.c would install the VLAN into the filter tables of
the switch, potentially interfering with the tag_8021q VLANs.

We need to prevent that from happening and not let the 8021q core
offload VLANs to the switch hardware tables. In vlan_filtering=0 modes
of operation, the switch ports can pass through VLAN-tagged frames with
no problem.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index df976b259e43..d8cff0107ec4 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1728,6 +1728,21 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_static_config_free(&priv->static_config);
 }
 
+static int sja1105_port_enable(struct dsa_switch *ds, int port,
+			       struct phy_device *phy)
+{
+	struct net_device *slave;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	slave = ds->ports[port].slave;
+
+	slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+
+	return 0;
+}
+
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 			     struct sk_buff *skb, bool takets)
 {
@@ -2049,6 +2064,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
+	.port_enable		= sja1105_port_enable,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
-- 
2.17.1

