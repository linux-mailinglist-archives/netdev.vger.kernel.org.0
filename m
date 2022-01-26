Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D488549C478
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiAZHfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiAZHfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:41 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A9BC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so2650872pjy.1
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/EZz50VILe/l+6xWwleJqwMfw/JlLmewW/CJleRkfs=;
        b=Ee/S5OmclYgVUd16L7u6fDHZpq/PAyMfKwGt6+BbeXnEC+ydVnJ9Vtx+Mi8tO1E5Qx
         dsfn0HAoB1adkx0j+gmnYQnDaHTcq/zqfXx5cTUOwlbIKWGdqhQw+cir6+PoeAK6nAad
         k270QGkqgTmo5QciKq4atJ72AcEsqOw/L4tAPM3zZO5E41A/T3wkH2t2qOptd9NHVJAS
         mruiE+obouteE4ePeppCR05czbdmAQL+OQyPYYlH3P/nlGAksgPuTQZV8vJhqzogIfS3
         IDmJGv3kLvixcF3Q++JEbFXsQo8VYQCirbFBT5mqb1fS5b/clGjJkxN+0CJdSNMwvoDX
         ID1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/EZz50VILe/l+6xWwleJqwMfw/JlLmewW/CJleRkfs=;
        b=C6RsAF3Tgmg0ZZf598Sx4TJCYmOKxnFI8aNw5PnDIqhQHR1/rbaC19FNnA/qfnM8o4
         td2f1jM8KlVHwYXK5K+Y4UzUf7oIfnZwucqCw1rHLvDyFv7cf+cvj3tUPbmRrBMa5Bs6
         a/oFmfMZMZ9rldKlQ2kSNfzeVh+yFGGaN0Tq/+qTYtdeciw/s+0RIkqCJYOpK5KSzhTp
         GV7VWr/E4wkbB0+N4U40rVP+8g55AnGSs8nc0S+K4OON+QcPAo14R28BiMq4naRrl6zX
         AeKphAJWBAIdJQGCkgjHCOn6ZS9QWHnpwZK+YJmqkrqjRNk5hKcz5paNTqTKhj0rNOdp
         9lDg==
X-Gm-Message-State: AOAM5314gPfcQv6K5yBaQKzzh5DDEoKjJb3xV5erU3Y49IypdzberCAD
        cXO7dvuzdmvWg5kQGxrf5WVp8SEeV7E=
X-Google-Smtp-Source: ABdhPJxiAXltn/Zueczm/3/ivqiG/u0cX8FDXpMUoh6zTm3vZGa8GPBU9P2lEFBxRV1k4DlKjiv8ng==
X-Received: by 2002:a17:902:6ac1:b0:149:7087:7b8a with SMTP id i1-20020a1709026ac100b0014970877b8amr22844627plt.174.1643182540747;
        Tue, 25 Jan 2022 23:35:40 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:40 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 2/5] Bonding: split bond_handle_vlan from bond_arp_send
Date:   Wed, 26 Jan 2022 15:35:18 +0800
Message-Id: <20220126073521.1313870-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function bond_handle_vlan() is split from bond_arp_send() for later
IPv6 usage.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 57 +++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 07fc603c2fa7..0ff51207dd49 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2794,31 +2794,15 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
 	return ret;
 }
 
-/* We go to the (large) trouble of VLAN tagging ARP frames because
- * switches in VLAN mode (especially if ports are configured as
- * "native" to a VLAN) might not pass non-tagged frames.
- */
-static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
-			  __be32 src_ip, struct bond_vlan_tag *tags)
+static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
+			    struct sk_buff *skb)
 {
-	struct sk_buff *skb;
-	struct bond_vlan_tag *outer_tag = tags;
-	struct net_device *slave_dev = slave->dev;
 	struct net_device *bond_dev = slave->bond->dev;
-
-	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
-		  arp_op, &dest_ip, &src_ip);
-
-	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
-			 NULL, slave_dev->dev_addr, NULL);
-
-	if (!skb) {
-		net_err_ratelimited("ARP packet allocation failed\n");
-		return;
-	}
+	struct net_device *slave_dev = slave->dev;
+	struct bond_vlan_tag *outer_tag = tags;
 
 	if (!tags || tags->vlan_proto == VLAN_N_VID)
-		goto xmit;
+		return true;
 
 	tags++;
 
@@ -2835,7 +2819,7 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 						tags->vlan_id);
 		if (!skb) {
 			net_err_ratelimited("failed to insert inner VLAN tag\n");
-			return;
+			return false;
 		}
 
 		tags++;
@@ -2848,8 +2832,33 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 				       outer_tag->vlan_id);
 	}
 
-xmit:
-	arp_xmit(skb);
+	return true;
+}
+/* We go to the (large) trouble of VLAN tagging ARP frames because
+ * switches in VLAN mode (especially if ports are configured as
+ * "native" to a VLAN) might not pass non-tagged frames.
+ */
+static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
+			  __be32 src_ip, struct bond_vlan_tag *tags)
+{
+	struct sk_buff *skb;
+	struct net_device *slave_dev = slave->dev;
+	struct net_device *bond_dev = slave->bond->dev;
+
+	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
+		  arp_op, &dest_ip, &src_ip);
+
+	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
+			 NULL, slave_dev->dev_addr, NULL);
+
+	if (!skb) {
+		net_err_ratelimited("ARP packet allocation failed\n");
+		return;
+	}
+
+	if (bond_handle_vlan(slave, tags, skb))
+		arp_xmit(skb);
+	return;
 }
 
 /* Validate the device path between the @start_dev and the @end_dev.
-- 
2.31.1

