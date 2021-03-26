Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4AC34A5FF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhCZK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhCZK5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:57:34 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1588FC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:57:34 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id z25so6887828lja.3
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=eSlgjT7JFI4Q2bXZn5wbGG87Awrs5ECaXb6x1VVorfo=;
        b=Df7ojB5kGqg4fEyyEOf9HgFecumUYUsxvhzS588a7D/H7VeuxzOWDgvzO50qgjGf/F
         G4eyPmfp5WZsXQN2ImksxswRhO2McJfmMwNptXHpvO82PT7GNQTtzHAJGn6aUOaRruYN
         Cu3b8xaAIf+DwoJwXQNqUhyNPcAfH/GfV17elkm0qguGaiCUCVII+OSDsG2oVo+rhNz3
         3g7WVpSF+unQqnQ/GyRxcCvA/m2NUNYu0IAwgj3CEV9bWNVEiDONIdIDa3dvEVTBhF6y
         ahcg28ujM/tTk4s8pYaYDY7k+mcRO/61Taw9WWDnOpce/GAg6CiKfzTtSq6vX/Q9QxhE
         0fOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=eSlgjT7JFI4Q2bXZn5wbGG87Awrs5ECaXb6x1VVorfo=;
        b=Rr2ZW8r7gwEaVHRW4r83bHDPogzJI5qIYJvP3gDpXlZqLXgtlxU/DUoohgnRzChFGm
         vEhvMWXkSfe4dZCSQpIELFjO5IJwWNW4Kl7ifYx6P7SEUO2Jr4DopraaV5BFhWaHjuUv
         Ajv6jq3hUEuKaqICPolvKMP5F/SMUfCaEmZmXBWfI8fkU4R4kZ57vaC9kgdY3rKjAceV
         zqHgwonJJoKt6KOg/QIPa5KvHWmLajMwnS0e4yzoEKPmbgiijDlzWcuRFucDMlCO7j+J
         DgskoHbhDB3RkfPs3U1IYqfoVZR4LzAcefVN4cUD8wzuicU/pRH6su9wisDEgDjXARd0
         Fp7A==
X-Gm-Message-State: AOAM533WXAecHBGiZBLbfP7hLoFHTtnRSOGC9nYG4EktDxqOqTxZiZUU
        QoxT91/YZzU/oU99ORTZNFv1Tw==
X-Google-Smtp-Source: ABdhPJxVbgxhSJJMaaRRllqvBNNADgm3kXe62UMYMyZJxKfmc1uLOo48M5ml8BdDaeUvclX/F65KmQ==
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr8601431ljj.465.1616756252484;
        Fri, 26 Mar 2021 03:57:32 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n23sm832629lfq.121.2021.03.26.03.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:57:32 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
Date:   Fri, 26 Mar 2021 11:56:46 +0100
Message-Id: <20210326105648.2492411-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210326105648.2492411-1-tobias@waldekranz.com>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
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

