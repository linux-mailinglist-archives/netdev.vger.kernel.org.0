Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061E4B56E0
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 22:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfIQUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 16:24:58 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36654 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfIQUY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 16:24:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id f2so4564286edw.3
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 13:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=EMVeWX/4rd9EtUE0NDDMmIiWhzSfMYnF1NdsVH7aCwg=;
        b=uiA2mg99qrvNa0WxKDs9gMYKt4iDjFAzsIBvh9/BZsBGx4PnJT7dA2k2tC7iP68w93
         XRJSGim8Z4ldmi8Jy9JNYu0DLFj3TSVIohhVIThRmJaQsVRHmYyGXJGVMryAdNCqNmMe
         gB+TlC3drAzrWBacVPaMgRgT6r9rgKzfDasyUcp6S14SPm7bp/bkwNXcr3mS/jrSYnND
         MXn/x53djOaTb6lEomKD09BZUE6K8SfTg3V0inwmLuuY6UDdg9W+wAaR2a0vbhfjGGpu
         c6AaZx0+GN7/z+AopW8mCGTDQcA3EfVCtqLUXKcjmnhLA/jgH1Ghks2mFsa9mVfBsID0
         IYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=EMVeWX/4rd9EtUE0NDDMmIiWhzSfMYnF1NdsVH7aCwg=;
        b=tvONCKSiP7AGsOfy28t52PewgW/rbk9WQkIz9mCT30tGNdWAMKBz+MB02mUl8qQgr/
         p6Yt9m3H3URPjZOfVFeAh6sSGrtYTwZTXfb15X4OOyo8DQPNBjrX7tCGfDpEpbIgS0Y6
         6TSOtxCP7k8xy4WClFWt6Oqi4uLTMsLGO8pUIYZZS9MQ//zv6Wc+mLUgxs5r8VwFDArS
         wNBFWwWmhDwvfmZUhsSZNp5ej+lPWAxMrCrAatxLPZ0OzULXo80+EV5HyTZlvupxf/DL
         R9NhDEQJbhc8utOVbAH7Pnbsswj69NBB/JuEIejdlNamF39Shf8q43yE6kyyOHpXV1Lx
         XCOg==
X-Gm-Message-State: APjAAAVeXwdcLXbXljYr4w06ihEd1GzFGj2SQxPHWK7E3mTKwVR2r8Up
        WDWvKeZPlZfqARwvFF2X4Mg=
X-Google-Smtp-Source: APXvYqxyg7omYWFSMLKWlItt83PX78pRBC+ygR/ZQbXIEbCviPUFSylg5fUcdLWYlQDUCij2YeaCNw==
X-Received: by 2002:a17:906:6848:: with SMTP id a8mr6645110ejs.104.1568751895792;
        Tue, 17 Sep 2019 13:24:55 -0700 (PDT)
Received: from i5wan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id q33sm613113eda.60.2019.09.17.13.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 13:24:55 -0700 (PDT)
Date:   Tue, 17 Sep 2019 22:23:01 +0200
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Add support for port mirroring
Message-ID: <20190917202301.GA29966@i5wan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring port mirroring through the cls_matchall
classifier. We do a full ingress and/or egress capture towards the
capture port, configured with set_egress_port.

Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 36 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0a97eb73a37..3a48f9d07cbf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4595,6 +4595,40 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
+				     struct dsa_mall_mirror_tc_entry *mirror,
+				     bool ingress)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = -EOPNOTSUPP;
+
+	mutex_lock(&chip->reg_lock);
+	if (chip->info->ops->set_egress_port)
+		err = chip->info->ops->set_egress_port(chip,
+						       mirror->to_local_port);
+
+	if (err)
+		goto out;
+
+	err = mv88e6xxx_port_set_mirror(chip, port, true, ingress);
+out:
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
+				      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mutex_lock(&chip->reg_lock);
+	if (mv88e6xxx_port_set_mirror(chip, port, false, false))
+		dev_err(ds->dev, "p%d: failed to disable mirroring\n", port);
+
+	mutex_unlock(&chip->reg_lock);
+}
+
 static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 					 bool unicast, bool multicast)
 {
@@ -4647,6 +4681,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_prepare       = mv88e6xxx_port_mdb_prepare,
 	.port_mdb_add           = mv88e6xxx_port_mdb_add,
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
+	.port_mirror_add	= mv88e6xxx_port_mirror_add,
+	.port_mirror_del	= mv88e6xxx_port_mirror_del,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04309ef0a1cc..301bf704c877 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1086,6 +1086,27 @@ int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      bool mirror, bool ingress)
+{
+	u16 reg;
+	u16 bit;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
+	if (err)
+		return err;
+
+	bit = ingress ? MV88E6XXX_PORT_CTL2_INGRESS_MONITOR :
+			MV88E6XXX_PORT_CTL2_EGRESS_MONITOR;
+	reg &= ~bit;
+
+	if (mirror)
+		reg |= bit;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 8d5a6cd6fb19..40ed60a2099b 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -347,6 +347,8 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      bool mirror, bool ingress);
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port);
-- 
2.23.0

