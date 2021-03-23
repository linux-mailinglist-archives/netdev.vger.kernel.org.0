Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1A345BD6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCWKYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhCWKXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:23:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D5C061756
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:23:36 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a198so25812056lfd.7
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=R5vyqdvQKWra7jAt7UHdh8c5uKVuo+2L4j2zPN3PxbQ=;
        b=yNOywE0I1mgy3dRCqwWqYbUGGGt6/v7thf/EcZGsPBzKqo2FX5a9Vksm5JGeukj4TX
         lS2xBKUmijbP60jI/ZV2wiu2f+iQFcEpV6HeGwT36LAWg3QU+YBqQFGdVk2B+W/3AnIX
         aaYbLaJMX4IwvsgHBjGMbt5uOJEyrRfi4+pABnTMh+lYVsoxE40CBH5aGzYlcRQTDs5q
         39eq74vf9AoJhLkyfNl0Nx7COi+mEFuLwr3V/XnZSjCzVj/yVKXpFn2rZ9kgfEIHT5a5
         4D84s1zUjjHcXz5BOwAAqq9lvHKqe9f1859ciPwDtuhGuhFXbVrUywjdRXrBflLoFPo3
         nGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=R5vyqdvQKWra7jAt7UHdh8c5uKVuo+2L4j2zPN3PxbQ=;
        b=aQKDkMHbqhiAxWgnrHZHy50Oj+EJRk3Ael+7nHkOtTOqPCH5P/0KdKK/0V3Qq+rP5B
         ihU6SBbm/QJAf64OXndEzB7jJTPLXZeDHboOjtbgXRYRLVLdp0zUKSA5nVeKCQQ5bzU2
         idC6+P6XvqvFa8dK8xABYL2NC2huu7WNMLtUsZlRoNH3WTz/xfUhUtSJ+xJ32W5tAD0y
         EB9tQLZlkgF95VGKaXnVpJN1hAwfpE1ZsbByaGFGnET3xCPy0rk+J15V3hCM/13zgQhs
         n/A8Z6TS7uyrrfHuD6n+tKXwb2IPCo8U3Jd4Bi4gibriclOwMO0r7rV3XQdV7WkpUM7y
         n+UQ==
X-Gm-Message-State: AOAM5313ckppOR9ySpPsI0GnCugjxVjEMnKy09a34VUlOEEHUAXomcWz
        QwMGzZVcbxNsG/EV7wTqbwmPvg==
X-Google-Smtp-Source: ABdhPJyMDVA6GAFmgYHsXO3OgY2V0ju5lumyQKW89/wX4ENW0IsvYYE3lIfGaX9tA+WCx+kJ11/T6A==
X-Received: by 2002:a05:6512:6cd:: with SMTP id u13mr2265385lff.326.1616495014771;
        Tue, 23 Mar 2021 03:23:34 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t200sm1858403lff.280.2021.03.23.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:23:34 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
Date:   Tue, 23 Mar 2021 11:23:26 +0100
Message-Id: <20210323102326.3677940-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All devices are capable of using regular DSA tags. Support for
Ethertyped DSA tags sort into three categories:

1. No support. Older chips fall into this category.

2. Full support. Datasheet explicitly supports configuring the CPU
   port to receive FORWARDs with a DSA tag.

3. Undocumented support. Datasheet lists the configuration from
   category 2 as "reserved for future use", but does empirically
   behave like a category 2 device.

Because there are ethernet controllers that do not handle regular DSA
tags in all cases, it is sometimes preferable to rely on the
undocumented behavior, as the alternative is a very crippled
system. But, in those cases, make sure to log the fact that an
undocumented feature has been enabled.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

In a system using an NXP T1023 SoC connected to a 6390X switch, we
noticed that TO_CPU frames where not reaching the CPU. This only
happened on hardware port 8. Looking at the DSA master interface
(dpaa-ethernet) we could see that an Rx error counter was bumped at
the same rate. The logs indicated a parser error.

It just so happens that a TO_CPU coming in on device 0, port 8, will
result in the first two bytes of the DSA tag being one of:

00 40
00 44
00 46

My guess is that since these values look like 802.3 length fields, the
controller's parser will signal an error if the frame length does not
match what is in the header.

As a workaround, switching to EDSA (thereby always having a proper
EtherType in the frame) solves the issue.

 drivers/net/dsa/mv88e6xxx/chip.c | 41 +++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  3 +++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 95f07fcd4f85..e7ec883d5f6b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2531,10 +2531,10 @@ static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
 		return mv88e6xxx_set_port_mode_normal(chip, port);
 
 	/* Setup CPU port mode depending on its supported tag format */
-	if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
+	if (chip->tag_protocol == DSA_TAG_PROTO_DSA)
 		return mv88e6xxx_set_port_mode_dsa(chip, port);
 
-	if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
+	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
 		return mv88e6xxx_set_port_mode_edsa(chip, port);
 
 	return -EINVAL;
@@ -5564,7 +5564,39 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	return chip->info->tag_protocol;
+	return chip->tag_protocol;
+}
+
+static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
+					 enum dsa_tag_protocol proto)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	enum dsa_tag_protocol old_protocol;
+	int err;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_EDSA:
+		if (chip->info->tag_protocol != DSA_TAG_PROTO_EDSA)
+			dev_warn(chip->dev, "Relying on undocumented EDSA tagging behavior\n");
+
+		break;
+	case DSA_TAG_PROTO_DSA:
+		break;
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	old_protocol = chip->tag_protocol;
+	chip->tag_protocol = proto;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_setup_port_mode(chip, port);
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err)
+		chip->tag_protocol = old_protocol;
+
+	return err;
 }
 
 static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
@@ -6029,6 +6061,7 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
 
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
+	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
@@ -6209,6 +6242,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out;
 
+	chip->tag_protocol = chip->info->tag_protocol;
+
 	mv88e6xxx_phy_init(chip);
 
 	if (chip->info->ops->get_eeprom) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index bce6e0dc8535..96b775f3fda2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -261,6 +261,9 @@ struct mv88e6xxx_region_priv {
 struct mv88e6xxx_chip {
 	const struct mv88e6xxx_info *info;
 
+	/* Currently configured tagging protocol */
+	enum dsa_tag_protocol tag_protocol;
+
 	/* The dsa_switch this private structure is related to */
 	struct dsa_switch *ds;
 
-- 
2.25.1

