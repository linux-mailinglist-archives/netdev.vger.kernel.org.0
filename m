Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0021A0747
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfH1Q1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:27:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34632 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfH1Q1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:27:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id a13so230400qtj.1
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 09:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcwMoGCnjuEeccmaTez/I5aABRocrRvpNj9ce8BjD44=;
        b=fzwRW1topaV3rNMBCsLUWG4kpUgC2oFMauXQ4VJMd4oOcRVO6mZ7Es/tvmM62ejPxT
         ptkhqVcc0sjAPj44FdWZ9NdVOTGWMmHEGYkSyPxsXmJxOIqHiFJ1v5kSjaA8RI/6CC/Z
         W1W4xF3Nrp5QCcQpjZaZcla6JZme9mtnEfcOC8zYcQD0qHyno9wVRy6dDxgJ+YX9DrY1
         Nc0MGps5SAco8rOZat6mIkYVghSosW9CnEH1IEhO7Yl2su2zpMn0ItWNqQKVb8120r8Z
         9fLFgJdDd6hv2Ym8Duwq6xPWSt5WHV9S/vwVKPAwkzpSWOkkB+EQwUI5MbLJH27zgUcb
         SaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcwMoGCnjuEeccmaTez/I5aABRocrRvpNj9ce8BjD44=;
        b=o7PAz8Y/77mHHDZS71fTT+6bbkfVYk50/btg791iCAwQQZ6RdVFrQGIC9RP5dhNjE7
         8yz7AB4+HbCu7No73spc3zRhxdWBEAZ1nsqLOkQEi+hBq0WAaiAyckopYSksrCe2oxuz
         akP7e7Q5MZdHE7u+Fix0o5gm5kJfe6rLU/vk3xU0r4EXbg/oHmw6pUmEQWRrTe286e49
         rcBoox1f9vw92JIXG7E4HDzjdEkQnDexxLmCrr3DBJ8xpr5rTg5mzmsJyfZXd2Zrd8vL
         8Hv17mm2nVGJQGMVihveSlYGANLmpaBCp64+8WV2tZ5dPuVoCfVGfNXutJjQn6vyr6Sx
         al0w==
X-Gm-Message-State: APjAAAU/xHS9b6k++OgCVDptdAZPjEw5Saht3SHkf47AX6PJ20QPdaAB
        /27tYgpEArsNr7mM5jlmLfskXmH/
X-Google-Smtp-Source: APXvYqwj1DPffa5MupFNrWqcv6z75hu/5WjWzIipSsXYDv00rT+wm+P4tU2UuRchqBx6aS8pm4br3A==
X-Received: by 2002:a0c:eccf:: with SMTP id o15mr3323200qvq.15.1567009626838;
        Wed, 28 Aug 2019 09:27:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a23sm1292944qtj.5.2019.08.28.09.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 09:27:06 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: keep CMODE writable code private
Date:   Wed, 28 Aug 2019 12:26:59 -0400
Message-Id: <20190828162659.10306-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up patch for commit 7a3007d22e8d ("net: dsa:
mv88e6xxx: fully support SERDES on Topaz family").

Since .port_set_cmode is only called from mv88e6xxx_port_setup_mac and
mv88e6xxx_phylink_mac_config, it is fine to keep this "make writable"
code private to the mv88e6341_port_set_cmode implementation, instead
of adding yet another operation to the switch info structure.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 --------
 drivers/net/dsa/mv88e6xxx/chip.h | 1 -
 drivers/net/dsa/mv88e6xxx/port.c | 9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.h | 1 -
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 54e88aafba2f..6525075f6bd3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -454,12 +454,6 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			goto restore_link;
 	}
 
-	if (chip->info->ops->port_set_cmode_writable) {
-		err = chip->info->ops->port_set_cmode_writable(chip, port);
-		if (err && err != -EOPNOTSUPP)
-			goto restore_link;
-	}
-
 	if (chip->info->ops->port_set_cmode) {
 		err = chip->info->ops->port_set_cmode(chip, port, mode);
 		if (err && err != -EOPNOTSUPP)
@@ -2919,7 +2913,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
-	.port_set_cmode_writable = mv88e6341_port_set_cmode_writable,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
@@ -3618,7 +3611,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
-	.port_set_cmode_writable = mv88e6341_port_set_cmode_writable,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index d6b1aa35aa1a..421e8b84bec3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -400,7 +400,6 @@ struct mv88e6xxx_ops {
 	/* CMODE control what PHY mode the MAC will use, eg. SGMII, RGMII, etc.
 	 * Some chips allow this to be configured on specific ports.
 	 */
-	int (*port_set_cmode_writable)(struct mv88e6xxx_chip *chip, int port);
 	int (*port_set_cmode)(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
 	int (*port_get_cmode)(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 542201214c36..4f841335ea32 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -510,7 +510,8 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_set_cmode(chip, port, mode);
 }
 
-int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip, int port)
+static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
+					     int port)
 {
 	int err, addr;
 	u16 reg, bits;
@@ -537,6 +538,8 @@ int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip, int port)
 int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode)
 {
+	int err;
+
 	if (port != 5)
 		return -EOPNOTSUPP;
 
@@ -551,6 +554,10 @@ int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		break;
 	}
 
+	err = mv88e6341_port_set_cmode_writable(chip, port);
+	if (err)
+		return err;
+
 	return mv88e6xxx_port_set_cmode(chip, port, mode);
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index e78d68c3e671..d4e9bea6e82f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -336,7 +336,6 @@ int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
-int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode);
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-- 
2.23.0

