Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CEA620B0E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiKHIYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiKHIXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:53 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62B327B11
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:52 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E155684FAC;
        Tue,  8 Nov 2022 09:23:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895830;
        bh=xzSyd5yI9MJDufr4RuTyWI2LqmKTCp4NW9Jyp55qKvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUjulGKvxGpg6mtRVCqZBZBJyf2WQ8TEc4wcdR3tbq7lP1h4jQowK8A7cZ4Vr/Gl0
         yhnAubOB+9KxonivmeSdCDFY5kHjAPUltYxGG9JhR7FvcZTv+ysaG7Vma3NvcPDJQ4
         hdwCZUZwLmdHweydvp4/51vvLYMnl1I/uXqfs5A3NkBhI5I4A07EtnG5a7hELTBvvv
         mvny38r0kZOaOth3xU6/xhAasSVOrvZgODGvtdTrVdvy2muub6WnNoKXxGyoea97mo
         SAYaC+Bg78V0tWQus+70m45ds0Hso6NI0EfCxPNKJZcp3VeEb5rVLVd9gG3dW1LOoG
         Xt3qtlGW/Eh3A==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 6/9] net: dsa: marvell: Provide per device information about max frame size
Date:   Tue,  8 Nov 2022 09:23:27 +0100
Message-Id: <20221108082330.2086671-7-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Different Marvell DSA switches support different size of max frame
bytes to be sent.

For example mv88e6185 supports max 1632B, which is now in-driver
standard value. On the other hand - mv88e6071 supports 2048 bytes.

As this value is internal and may be different for each switch IC
new entry in struct mv88e6xxx_info has been added to store it.

When the 'max_frame_size' is not defined (and hence zeroed by
the kvzalloc()) the default of 1632 bytes is used.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 ++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 09877a464665..d90835b4c606 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3542,11 +3542,19 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int max_frame_size;
 
 	if (chip->info->ops->port_set_jumbo_size)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	else if (chip->info->ops->set_max_frame_size) {
+		if (chip->info->max_frame_size)
+			max_frame_size = chip->info->max_frame_size;
+		else
+			max_frame_size = 1632;
+
+		return max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	}
+
 	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2fcab41e03b7..6ec4010fd634 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -132,6 +132,7 @@ struct mv88e6xxx_info {
 	unsigned int num_ports;
 	unsigned int num_internal_phys;
 	unsigned int num_gpio;
+	unsigned int max_frame_size;
 	unsigned int max_vid;
 	unsigned int max_sid;
 	unsigned int port_base_addr;
-- 
2.37.2

