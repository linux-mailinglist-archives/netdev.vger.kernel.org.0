Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A15859FFD0
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbiHXQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238546AbiHXQvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:51:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381144505A
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so15540504pgs.3
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=HcU7Ka55rBgHejqe9QLCDYqCDvEmpAXeRKcao/ZWmS8=;
        b=5GiHYTpbTKxMErAmVBAt35u5jzqRJ3WQWrMiZk4SDiPOL2qmx5FthNVT/YE+Cv4an8
         jXohV+Ga5y9qclBscCsOZANLqrMciLWJW5qbZG9desqA94nAFOMvXc+esBUN9ka73yto
         gdpn3JliDdK445h69EYyZa/Gu044dDA0XXuPI0+RgaNSgGUf0HIEIliPX/xA5/YEDaJe
         xCQ4aZEcsnuir7K9BxwBRJzwrq8alHQme2o8MjEnpDTlmnVXMgU78Ga462ujrJR+Yfys
         PsDknvxsKOivZfXlKqyp/enrg/XeJlideKXmo4c8R7Qaol9PDwgAHH0oYChX6+1TZ5Dt
         snDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=HcU7Ka55rBgHejqe9QLCDYqCDvEmpAXeRKcao/ZWmS8=;
        b=4M4wcMW9eQpKe+vUFrzaLhzz4OhgDr7AsBkoUU8NpCz0cQtyHm8Kd6+XvvrRg9bqpv
         nz4gklsA3QdaMTvPTVYtSrOCghj7YKCEcHPOAvuuKTJD0L1bE3bELHfdTUU2XC5d9dNa
         /tnzsZQ9d13tR+UHdN86ty0yymLmwv8CFkmN52aa1qJmPO4gv3kT16xRmT6yzSkxge4o
         7y+N9vzDn9WBQnxfMa6PUjJWGoVrcp5Lj6IdA8dmOwhlpXwFoefokrFGgyQ6JRHLQ2f5
         d2ezb6lFzDwbPnDqeEPfiNSRqDRqWaMC8i9XBci2TYha8jRuOKHur+pVF3CU1sfHJai7
         8ugQ==
X-Gm-Message-State: ACgBeo3DXAxQVuGhUpKVUKARGsUv2EVwIcG/Q/ifv3vO8UlAup0gPmKh
        8PlqdW6+ci8M6xyfvDBwdU/62u6Zpu4OBw==
X-Google-Smtp-Source: AA6agR6pDbgSnraus/uNdCfkCB7Ickm160jZpDECpWK1AqpFig6wZL3chXhMUp71sgV4mx7EuAeo3g==
X-Received: by 2002:a62:1c56:0:b0:536:4f4b:d99e with SMTP id c83-20020a621c56000000b005364f4bd99emr118526pfc.64.1661359862649;
        Wed, 24 Aug 2022 09:51:02 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a68-20020a621a47000000b005366280c39fsm8960349pfa.140.2022.08.24.09.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:51:02 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, mohamed@pensando.io,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 3/3] ionic: VF initial random MAC address if no assigned mac
Date:   Wed, 24 Aug 2022 09:50:51 -0700
Message-Id: <20220824165051.6185-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220824165051.6185-1-snelson@pensando.io>
References: <20220824165051.6185-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: R Mohamed Shah <mohamed@pensando.io>

Assign a random mac address to the VF interface station
address if it boots with a zero mac address in order to match
similar behavior seen in other VF drivers.  Handle the errors
where the older firmware does not allow the VF to set its own
station address.

Newer firmware will allow the VF to set the station mac address
if it hasn't already been set administratively through the PF.
Setting it will also be allowed if the VF has trust.

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: R Mohamed Shah <mohamed@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 92 ++++++++++++++++++-
 1 file changed, 87 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d4226999547e..0be79c516781 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1564,8 +1564,67 @@ static int ionic_set_features(struct net_device *netdev,
 	return err;
 }
 
+static int ionic_set_attr_mac(struct ionic_lif *lif, u8 *mac)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+
+	ether_addr_copy(ctx.cmd.lif_setattr.mac, mac);
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static int ionic_get_attr_mac(struct ionic_lif *lif, u8 *mac_addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_getattr = {
+			.opcode = IONIC_CMD_LIF_GETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	ether_addr_copy(mac_addr, ctx.comp.lif_getattr.mac);
+	return 0;
+}
+
+static int ionic_program_mac(struct ionic_lif *lif, u8 *mac)
+{
+	u8  get_mac[ETH_ALEN];
+	int err;
+
+	err = ionic_set_attr_mac(lif, mac);
+	if (err)
+		return err;
+
+	err = ionic_get_attr_mac(lif, get_mac);
+	if (err)
+		return err;
+
+	/* To deal with older firmware that silently ignores the set attr mac:
+	 * doesn't actually change the mac and doesn't return an error, so we
+	 * do the get attr to verify whether or not the set actually happened
+	 */
+	if (!ether_addr_equal(get_mac, mac))
+		return 1;
+
+	return 0;
+}
+
 static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 {
+	struct ionic_lif *lif = netdev_priv(netdev);
 	struct sockaddr *addr = sa;
 	u8 *mac;
 	int err;
@@ -1574,6 +1633,14 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	if (ether_addr_equal(netdev->dev_addr, mac))
 		return 0;
 
+	err = ionic_program_mac(lif, mac);
+	if (err < 0)
+		return err;
+
+	if (err > 0)
+		netdev_dbg(netdev, "%s: SET and GET ATTR Mac are not equal-due to old FW running\n",
+			   __func__);
+
 	err = eth_prepare_mac_addr_change(netdev, addr);
 	if (err)
 		return err;
@@ -3172,6 +3239,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 			.attr = IONIC_LIF_ATTR_MAC,
 		},
 	};
+	u8 mac_address[ETH_ALEN];
 	struct sockaddr addr;
 	int err;
 
@@ -3180,8 +3248,23 @@ static int ionic_station_set(struct ionic_lif *lif)
 		return err;
 	netdev_dbg(lif->netdev, "found initial MAC addr %pM\n",
 		   ctx.comp.lif_getattr.mac);
-	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
-		return 0;
+	ether_addr_copy(mac_address, ctx.comp.lif_getattr.mac);
+
+	if (is_zero_ether_addr(mac_address)) {
+		eth_hw_addr_random(netdev);
+		netdev_dbg(netdev, "Random Mac generated: %pM\n", netdev->dev_addr);
+		ether_addr_copy(mac_address, netdev->dev_addr);
+
+		err = ionic_program_mac(lif, mac_address);
+		if (err < 0)
+			return err;
+
+		if (err > 0) {
+			netdev_dbg(netdev, "%s:SET/GET ATTR Mac are not same-due to old FW running\n",
+				   __func__);
+			return 0;
+		}
+	}
 
 	if (!is_zero_ether_addr(netdev->dev_addr)) {
 		/* If the netdev mac is non-zero and doesn't match the default
@@ -3189,12 +3272,11 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 * likely here again after a fw-upgrade reset.  We need to be
 		 * sure the netdev mac is in our filter list.
 		 */
-		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
-				      netdev->dev_addr))
+		if (!ether_addr_equal(mac_address, netdev->dev_addr))
 			ionic_lif_addr_add(lif, netdev->dev_addr);
 	} else {
 		/* Update the netdev mac with the device's mac */
-		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
+		ether_addr_copy(addr.sa_data, mac_address);
 		addr.sa_family = AF_INET;
 		err = eth_prepare_mac_addr_change(netdev, &addr);
 		if (err) {
-- 
2.17.1

