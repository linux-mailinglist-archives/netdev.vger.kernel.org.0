Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4325850
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfEUTbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:31:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46096 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfEUTbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:31:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id z19so21859120qtz.13
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9yKfmidWdFQ7Ab3WtemRxXKGth/A6gmZuXkX6QohwHs=;
        b=qtLtHLV26BZVdXEKkkWd40sSYdpCMFAzqyXxuxpjWgXIuk5u9FuHDlEkWZLWEbQxcs
         nOnYtfesQx5Pbam1KOGslU1e2NEUsHgMNBODw/ClcpwB+zNnIpuFNglNvWxgJTWcisFk
         bzLiZv8ISoTrpGfkmzpc9nfYb2yFxeFt6Dnk9oav46/ug/hJlidWQUSUiLZeN7PqhJYC
         qHRiKh/QltKqqFOwO1BI318hiW0qCjzoyZ2ug6dVbzUhbsDLeIEQvcUzM3Wozp/x+g1M
         NEdaK5W/oFZY9UCr/fqzaoviJ33i99dwQkHH+Z6/TQCEwFkUUSJaoPcv1X4LgPk+LA+F
         5bwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9yKfmidWdFQ7Ab3WtemRxXKGth/A6gmZuXkX6QohwHs=;
        b=nOsrWxk3tqrSp7t0uFMFhfDM7U7QHOlMFtskW5IeorWCuR1qP9xPMfgnJRKc+VMFfc
         EtV88VOw0hs6+XzUk9lTdFS8kMX6t2pfP2NiEc3ob87N0mIOJbQxDnU8bNqfh9FcT5b8
         XOp7WMWq+GveRpWIWNrVwmhS7E9WXrT9diyOV6X3Tt95/lfQfvQTTypf5wwEt088hNqz
         EnSbROUWFpOX3MxvLE8HOj2mZTUO85Sqd+/f0FVKjpjTSJa7tYP+JkAZoxov+Hao6Rw+
         kLOENtHAHreR24sNn1m2wE3hXcFKmTfP3Yyi0MgDwfIwvj1hYkQV8EpOc+Pcrz7fFLjj
         zdCA==
X-Gm-Message-State: APjAAAXO/HXzLNkFSBXhWnKkr+LziKSiH8pUngDv1aEGGmBREX+08OLY
        QnP3drGDvD/w03qf+VbeVlSYHuUp
X-Google-Smtp-Source: APXvYqzmJS6QD6KYFLxlSVVYhVHbxiMXpxAKi8d361wIYh7jj7kKgsdJLWucHYeFwUFNH7RYpQj0Mw==
X-Received: by 2002:a0c:b8a7:: with SMTP id y39mr63868948qvf.66.1558467061688;
        Tue, 21 May 2019 12:31:01 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p37sm14048002qtj.90.2019.05.21.12.31.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:31:01 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 7/9] net: dsa: mv88e6xxx: implement RMU enable
Date:   Tue, 21 May 2019 15:30:02 -0400
Message-Id: <20190521193004.10767-8-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a new operation to enable the Remote Management Unit (RMU)
on a specified port. Add such support for 88E6352 and 88E6390 switches.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 10 ++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/global1.c | 56 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 4 files changed, 69 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 96e1886e05f0..3aa2b315b96d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3142,6 +3142,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
@@ -3225,6 +3226,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
@@ -3305,6 +3307,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
@@ -3350,6 +3353,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
@@ -3395,6 +3399,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
@@ -3442,6 +3447,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
@@ -3489,6 +3495,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
@@ -3747,6 +3754,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
@@ -3799,6 +3807,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
@@ -3848,6 +3857,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 860816ebb7ee..2af574169e14 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -459,6 +459,7 @@ struct mv88e6xxx_ops {
 	const struct mv88e6xxx_avb_ops *avb_ops;
 
 	/* Remote Management Unit operations */
+	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port, bool da_check);
 	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
 
 	/* Precision Time Protocol operations */
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 38e399e0f30e..523a7e297577 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -443,12 +443,68 @@ int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port, bool da_check)
+{
+	u16 mask = MV88E6352_G1_CTL2_RMU_MODE_MASK | MV88E6352_G1_CTL2_DA_CHECK;
+	u16 val;
+
+	switch (port) {
+	case 4:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
+		break;
+	case 5:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
+		break;
+	case 6:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (da_check)
+		val |= MV88E6352_G1_CTL2_DA_CHECK;
+
+	return mv88e6xxx_g1_ctl2_mask(chip, mask, val);
+}
+
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6390_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port, bool da_check)
+{
+	u16 mask = MV88E6390_G1_CTL2_RMU_MODE_MASK | MV88E6352_G1_CTL2_DA_CHECK;
+	u16 val;
+
+	switch (port) {
+	case 0:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_0;
+		break;
+	case 1:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_1;
+		break;
+	case 9:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_9;
+		break;
+	case 10:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_10;
+		break;
+	default:
+		/* 88E6390X can enable RMU on all (E)DSA ports as well,
+                 * but let's request a specific port for the moment.
+                 */
+		return -EINVAL;
+	}
+
+	if (da_check)
+		val |= MV88E6352_G1_CTL2_DA_CHECK;
+
+	return mv88e6xxx_g1_ctl2_mask(chip, mask, val);
+}
+
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_HIST_MODE_MASK,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index bef01331266f..c6057cdd547f 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -283,7 +283,9 @@ int mv88e6085_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port, bool da_check);
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port, bool da_check);
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index);
-- 
2.21.0

