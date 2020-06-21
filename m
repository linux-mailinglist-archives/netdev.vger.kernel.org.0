Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE46202A61
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgFULq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbgFULqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:25 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F990C061795
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:24 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s28so11285629edw.11
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pE5gS7sVi0QXADyb6k2enuhYc+kVvVFjmUijg2pg3Q0=;
        b=jUV1d4ed6ubvYUSeur5ruFzGYmgHsvIcXGVj6UKwTAGiVJt4qSU1LRiyBEHQfWo11Z
         mP4oE+wGhsmTt4OkYmc2QN57zgjWOzd3g6Jku7c8WdfFjQAUzTQhYOQjmSVFwkwlJdNY
         mBeIZCXVbmjgLFVgjWMJ5DzAcPe3FHoVlEzQ/BcQ4ZtbQb1MoV+VBjurXzRtAeQr/XnH
         qbr3FRlEkA/RE8E4Rw6vFwGTVBNz4taQj2sper5GHwtpWM82vgZK91xK/x8uofeK2oyQ
         VvCCr3srsiMZ1izwsd69FB/4lU3FY+upLdRNeA0yOjQaJbKdM3RaPH8iiOWn+O0QljCM
         7xvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pE5gS7sVi0QXADyb6k2enuhYc+kVvVFjmUijg2pg3Q0=;
        b=UPzNX/A8ErDRbXQPx9DReYAGsm4FdLxfcfQ6P9emac8Og8CFjVJ8FXMUiDsNDtHWhE
         hGdH6MKA0M32kFMw0ycUSiJHJSJRO0jTGJGuqQnzCnFfp/F65RzjWbAZ/MfzPxhKF6kF
         tZSr/nNscVjT7eKgsM5ldkFfsPolrJS5b/A66qyKxB5YKJQn3MRkn1u5XxLSfl4R2ykn
         8Pmke1tBk7PR97HxhbsoaLdKfqIqzKH2fYCXXuQZDV+cvXg5TIF3jYPRfLGK4+UPaJvW
         5zUKRgbGgdn5Xe3qwIxlTZIFZGgeqOW2OaJxyUdZ97ZG09+/o1Xj/uwucarouafMzOlO
         gm8w==
X-Gm-Message-State: AOAM531rlQI3Ze0GqTzZmObQaXcXigFHZQ0FO30C0EhgKpXQAmZMBJwD
        zYMEVSwvJfsipi6WW2+ICHE=
X-Google-Smtp-Source: ABdhPJzuPjsNQae2Qyt606ZlTGNFnUQ7x3wFMEYXtL4tn+aQfmJ13LWdEusl2UWMikDn9xa6TaVQ3w==
X-Received: by 2002:a50:bf4c:: with SMTP id g12mr12339456edk.203.1592739982859;
        Sun, 21 Jun 2020 04:46:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 4/5] net: mscc: ocelot: introduce macros for iterating over PGIDs
Date:   Sun, 21 Jun 2020 14:46:02 +0300
Message-Id: <20200621114603.119608-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The current iterators are impossible to understand at first glance
without switching back and forth between the definitions and their
actual use in the for loops.

So introduce some convenience names to help readability.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     |  8 ++++----
 drivers/net/ethernet/mscc/ocelot_net.c |  2 +-
 include/soc/mscc/ocelot.h              | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 468eaf5916e5..b6254c20f2f0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1064,10 +1064,10 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	int i, port, lag;
 
 	/* Reset destination and aggregation PGIDS */
-	for (port = 0; port < ocelot->num_phys_ports; port++)
+	for_each_unicast_dest_pgid(ocelot, port)
 		ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, port);
 
-	for (i = PGID_AGGR; i < PGID_SRC; i++)
+	for_each_aggr_pgid(ocelot, i)
 		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
 				 ANA_PGID_PGID, i);
 
@@ -1089,7 +1089,7 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			aggr_count++;
 		}
 
-		for (i = PGID_AGGR; i < PGID_SRC; i++) {
+		for_each_aggr_pgid(ocelot, i) {
 			u32 ac;
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
@@ -1451,7 +1451,7 @@ int ocelot_init(struct ocelot *ocelot)
 	}
 
 	/* Allow broadcast MAC frames. */
-	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++) {
+	for_each_nonreserved_multicast_dest_pgid(ocelot, i) {
 		u32 val = ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports - 1, 0));
 
 		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 1bad146a0105..702b42543fb7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -422,7 +422,7 @@ static void ocelot_set_rx_mode(struct net_device *dev)
 	 * forwarded to the CPU port.
 	 */
 	val = GENMASK(ocelot->num_phys_ports - 1, 0);
-	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++)
+	for_each_nonreserved_multicast_dest_pgid(ocelot, i)
 		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
 
 	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 80415b63ccfa..e050f8121ba2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -65,6 +65,21 @@
 #define PGID_MCIPV4			62
 #define PGID_MCIPV6			63
 
+#define for_each_unicast_dest_pgid(ocelot, pgid)		\
+	for ((pgid) = 0;					\
+	     (pgid) < (ocelot)->num_phys_ports;			\
+	     (pgid)++)
+
+#define for_each_nonreserved_multicast_dest_pgid(ocelot, pgid)	\
+	for ((pgid) = (ocelot)->num_phys_ports + 1;		\
+	     (pgid) < PGID_CPU;					\
+	     (pgid)++)
+
+#define for_each_aggr_pgid(ocelot, pgid)			\
+	for ((pgid) = PGID_AGGR;				\
+	     (pgid) < PGID_SRC;					\
+	     (pgid)++)
+
 /* Aggregation PGIDs, one per Link Aggregation Code */
 #define PGID_AGGR			64
 
-- 
2.25.1

