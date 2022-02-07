Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6CC4AB884
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241889AbiBGKNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244994AbiBGKIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:08:07 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29032C043181;
        Mon,  7 Feb 2022 02:08:06 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id x23so25894360lfc.0;
        Mon, 07 Feb 2022 02:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=cEAT+Hy10Io/v/6MX2mvQJLKyjX37zLdKJy2cGs9ssg=;
        b=VyAN6wJkNW7abvMrzl7SF3wzE97exy5eu7WmTzSN/TOxB5I/EWFzIYd7yfLAUu21Xu
         BYgDBMggIiQ1lmLxYy0ZdfIkXc58GNd+CKyEvB7BCXkEWoQeRyxPI/jpCUcwMOow3JNB
         gxoWkImounf5/SN0rcQHZBn0tri5gozybXcsJwayWGf3AtiY5c8bzX0YhjGn7e+TIdLE
         tAhkQEEGaI0NmkuNjZarowcREP1UowuHaFpfBXbGCaAGxoML6WxJ4X5YIz2xz8vXBzX2
         wE/3+A63YSnzIROSRsFCuaynNLRM1RQhhYSfaBL3UEfbaqtnJwvTNuz9+TqCLxfQyBrA
         XBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=cEAT+Hy10Io/v/6MX2mvQJLKyjX37zLdKJy2cGs9ssg=;
        b=XjcxSrgGp/YoCtjwqJpX90eb8+K91D+zk3GIPaeMMJ+PdErEzux4hkxufCuaUoL/MS
         abMPgxMyD7fLrQJtK3OVHl6jRjCoQTShVI6qjo+7dYCW8O3cqGss3ViAGxxralOB3rl2
         7VP5alX3Tcjb+xtb2UlmAl6te2D1k5Da203h2rRlcD5wOKxcZJysRIU0JpdAdKK1F3zW
         AiUebcPBVl6XeV+Sxzfz92rYfziOFEPRJByQ/W/hLVEOQZRXMLifRyTRkOKLAo/L4F/F
         W4lR19ZzroZsGPegyyKM//3YUl1IpNUBaV3eqcasEq/w4QuNZrdIEFIIerx2N4jZzlfi
         cOYw==
X-Gm-Message-State: AOAM53376lCRxt+jvcqFBSjmXCI7FM3DTovIkUeXkM6j+4v5baJtsGX9
        el4yHhZ3bZLSTELjyTYNU60=
X-Google-Smtp-Source: ABdhPJyQW07MI6sMuY6Nkop9ESztUBKa8lVcQLLrm1lvEue2qyLWdRiRnAgkjYWXinKAN2kFkAibTw==
X-Received: by 2002:ac2:54b7:: with SMTP id w23mr7704396lfk.6.1644228484590;
        Mon, 07 Feb 2022 02:08:04 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k12sm1546034ljh.45.2022.02.07.02.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:08:04 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: dsa: mv88e6xxx: Add support for bridge port locked feature
Date:   Mon,  7 Feb 2022 11:07:41 +0100
Message-Id: <20220207100742.15087-4-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting bridge port locked mode using the 802.1X mode in Marvell
mv88e6xxx switchcores is described in the '88E6096/88E6097/88E6097F
Datasheet', sections 4.4.6, 4.4.7 and 5.1.2.1 (Drop on Lock).

This feature is implemented here facilitated by the locked port flag.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  3 +++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..eed3713b97ae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5881,7 +5881,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	const struct mv88e6xxx_ops *ops;
 
 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-			   BR_BCAST_FLOOD))
+			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5939,6 +5939,13 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 			goto out;
 	}
 
+	if (flags.mask & BR_PORT_LOCKED) {
+		bool locked = !!(flags.val & BR_PORT_LOCKED);
+
+		err = mv88e6xxx_port_set_lock(chip, port, locked);
+		if (err)
+			goto out;
+	}
 out:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index ab41619a809b..2279936429f9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1234,6 +1234,39 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
+int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
+			    bool locked)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_CTL0_DROP_ON_LOCK;
+	if (locked)
+		reg |= MV88E6XXX_PORT_CTL0_DROP_ON_LOCK;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+	if (locked)
+		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03382b66f800..655d942ac657 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -365,6 +365,9 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
 int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, u16 *pvid);
 int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
 
+int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
+			    bool locked);
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode);
 int mv88e6095_port_tag_remap(struct mv88e6xxx_chip *chip, int port);
-- 
2.30.2

