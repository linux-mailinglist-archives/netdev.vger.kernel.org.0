Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F924AF24E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiBINGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiBINGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:20 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BFFC050CC2;
        Wed,  9 Feb 2022 05:06:17 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z20so3303347ljo.6;
        Wed, 09 Feb 2022 05:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=pe7DtCHDCmLRwyE/qHTyP5z+rDV+SzCi98cUiAV5b/4=;
        b=HKhR30nQqdmHPhN1YSs1FiKgidM0zc86mdOIAFMdvuvY7/Jefr18EmkN9sWb4CZfVv
         OXnWANyxGnOI3Xk3n5Yjwf8R8uNSE0lFjBsG+C14aKdQaYNK/eAzA91RIYwPAUjz8vKp
         MWKyimKf3rtEjom/a9PhtvV1qmqFeySYZH8BtmJfyYnpTeP3zhZfNOPK2xDFUWGTIkxS
         xJ2kO10Vbniwut3O1Q/IuEzt0FRnTt3zAoE7oEFAIRWQWImFka3ZZnvfO85Qx1DWbxa5
         cnkVjOnyRgh6W1NYyPMJWJGfYoTE0tme3bExP0ibP1vXD3P2/9Sxtt+nZ0ifZMF3h4nU
         dy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=pe7DtCHDCmLRwyE/qHTyP5z+rDV+SzCi98cUiAV5b/4=;
        b=G0ivSrNZkDSbTDch1SWsuO0LzcTZIyTAvOVIo1O4Fe5kO7VxWVUY1hPtohka01vzvk
         WM1LXhFAVtssjhiBVMr7jlDr1XZg0419Kyu0+d2uk1uSFPI6Bwd1Bhj2Rb4OgfxLaAeF
         YnVllXs4IRPpnxbym41YoJM9yUmHl9twtF2T52ZiCz/8S1a1kLgsURHIOz9hYBr5bTbB
         U66rpOy5Pvz4wG2AGCMXLt+CkuRFHW1nhPXbVDPMhjjHXClVRgK0IsT9W0oACxXcGOo0
         4PJaLUMEsgKH1+Xiy6XjDTuyRAyEFpK/E1PTpkZdYuxHPlRzqH98Oc0NnhlYC3h5f2C9
         aDeQ==
X-Gm-Message-State: AOAM5329eb/jS97IYuxRI6ByH3mCEeNUlV4ShgrgCdz+b1JvLx6oevuI
        9skBZoS7cBZl3akzMaloUmM=
X-Google-Smtp-Source: ABdhPJwgrnhOCwwLmTzqMPF79fJIQcadOKdfH0MNqKfYy9O1lkOWMy0nsB5lyRtMORdjAMrJh4UdqQ==
X-Received: by 2002:a2e:5c45:: with SMTP id q66mr1497374ljb.237.1644411975601;
        Wed, 09 Feb 2022 05:06:15 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k3sm2352608lfo.127.2022.02.09.05.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 05:06:15 -0800 (PST)
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
Subject: [PATCH net-next v2 4/5] net: dsa: mv88e6xxx: Add support for bridge port locked mode
Date:   Wed,  9 Feb 2022 14:05:36 +0100
Message-Id: <20220209130538.533699-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
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

Supporting bridge ports in locked mode using the drop on lock
feature in Marvell mv88e6xxx switchcores is described in the
'88E6096/88E6097/88E6097F Datasheet', sections 4.4.6, 4.4.7 and
5.1.2.1 (Drop on Lock).

This feature is implemented here facilitated by the locked port flag.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  9 ++++++++-
 3 files changed, 49 insertions(+), 2 deletions(-)

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
index ab41619a809b..46b7381899a0 100644
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
+	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
+	if (locked)
+		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
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
index 03382b66f800..3f70557f0d48 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -142,7 +142,11 @@
 /* Offset 0x04: Port Control Register */
 #define MV88E6XXX_PORT_CTL0					0x04
 #define MV88E6XXX_PORT_CTL0_USE_CORE_TAG			0x8000
-#define MV88E6XXX_PORT_CTL0_DROP_ON_LOCK			0x4000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_MASK			0xc000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DISABLED			0x0000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK		0x4000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_UNLOCK		0x8000
+#define MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_CPU		0xc000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_MASK			0x3000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_UNMODIFIED		0x0000
 #define MV88E6XXX_PORT_CTL0_EGRESS_MODE_UNTAGGED		0x1000
@@ -365,6 +369,9 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
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

