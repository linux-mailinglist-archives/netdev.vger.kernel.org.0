Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72759620B0C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiKHIX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiKHIXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:51 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D29427B1C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:50 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C045A84F34;
        Tue,  8 Nov 2022 09:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895829;
        bh=+9d0loleSBLQE3udcwHEbOBMYujfJ70ZJ0Qtzvonwjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0NUSEStZEFtCdG7zqwmp7rE4jSis1rGaN/VEMk5bwBoRjcgfAtH7XoAisYrwgDcp
         0o6lt8fA/N77KvVQFalUHbh9gALISLyI2t9j7h+nYuXitCGJxMsIAxBaqBT1UdEIAL
         BnX4BkrZ5G+HeSqEbLMeDhHATUjPQS3fHrRK2ANOWp7/0pBur5nfSLdYsRQPbENGmm
         9T29UM3+ORzhTrTmeaG/SozNdNtL0zRrQX6Bm02h2Ew0KL19iUtBaAfvLnzhNOipQn
         CHsXhGfrAgzPliS8n+HiUbWaN2gpjOI5iiUHgRcKOqTccH8kcGdvaHErvE6jgIoq2B
         Z8k9R7LK7c3IQ==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Date:   Tue,  8 Nov 2022 09:23:24 +0100
Message-Id: <20221108082330.2086671-4-lukma@denx.de>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Avoid the need to specify a PHY for each physical port in the device tree
when phy_base_addr is not 0 (6250 and 6341 families).

This change should be backwards-compatible with existing device trees,
as it only adds sensible defaults where explicit definitions were
required before.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2479be3a1e35..d51fd1966be9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6362,6 +6362,13 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->tag_protocol;
 }
 
+static int mv88e6xxx_get_phy_address(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	return chip->phy_base_addr + port;
+}
+
 static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds,
 					 enum dsa_tag_protocol proto)
 {
@@ -6887,6 +6894,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
 	.get_strings		= mv88e6xxx_get_strings,
 	.get_ethtool_stats	= mv88e6xxx_get_ethtool_stats,
+	.get_phy_address        = mv88e6xxx_get_phy_address,
 	.get_sset_count		= mv88e6xxx_get_sset_count,
 	.port_enable		= mv88e6xxx_port_enable,
 	.port_disable		= mv88e6xxx_port_disable,
-- 
2.37.2

