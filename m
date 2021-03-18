Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB173407A9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhCROQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhCROQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:19 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92721C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:18 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id r20so7697067ljk.4
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=EggvG2GyysNMviaqbbxN4WtDUlXGEfcdhFqI6EzPQ/M=;
        b=ledON4+hMRJ4TST81JzVc747fSTswlQfq1my37nzbLVP0GUfCU1GUyEZjwK/+FpasV
         5Dlv72+NVPvLUqGV1XKWVGIbF4Y6AvTqrN3pD504IX/IyCVS0pK+eBS3eA1T4fOoQGZf
         cr92/r9zUtBNiwungnUB42pvVdXDHKd9+CIFPMf/PXGcxq0UCSNH3pjxzBNXwYuSmt8c
         WfI+dHKIMHHCO0sxl6fofjFQG1KgGLlVd2EOyfBPPKY8WRuRv7oqquA+bXc3EsNfUhsj
         3GmluUZQZvbJpv3Q9WrtTMzzic76fvDrKP49+t3U8xp32Gs8XHm43RYY2yyHHlYDnG9E
         xxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=EggvG2GyysNMviaqbbxN4WtDUlXGEfcdhFqI6EzPQ/M=;
        b=nG7YG6XKrIweIAzRWqNNqOpEtbMNPZUq4ZvWx1s+v7v1nbx1sK63U5ejXpAqG5vyF2
         qYypg86qRDXcfO7gUlD+aLS0VEHV6h40DxOxhy9EXUo9jM2AZVvEDlPfyr7gPHhWP0zQ
         7NN7tqO8J3xZcV4nmWqjHdf60CWKFfsbWrMi3ZMnBmzbOiDE7NLLg2h+RAqzbPtL3CHO
         D7N89wW+NgBV6CkEsT/s8OHMGMn7UTVnMK9gBKaWnYrruc4bAvVZMPo7bNHV9TXmj+Pq
         zt/5N5qTRNPoJZGQySMSdqNq0mlftT/KSnCqYXMI+D40MVZay2RjU5Sa91t79tunGPMB
         AotQ==
X-Gm-Message-State: AOAM533po0H8Xmrfmb3TlsTOMdrsdUaCztS2ae3AOq+LqVF4i68uSGGy
        VBK/Op2fB7M44gTaKBnJFN/lbw==
X-Google-Smtp-Source: ABdhPJwXXniZQM+nPY2lNORK+ODHQc62irkJoeBGWcKvwA9NT0pKUXNdvvGvl7pjrVxYXfvchdhGig==
X-Received: by 2002:a05:651c:303:: with SMTP id a3mr5245821ljp.290.1616076977134;
        Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:16 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 7/8] net: dsa: mv88e6xxx: Offload bridge learning flag
Date:   Thu, 18 Mar 2021 15:15:49 +0100
Message-Id: <20210318141550.646383-8-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow a user to control automatic learning per port.

Many chips have an explicit "LearningDisable"-bit that can be used for
this, but we opt for setting/clearing the PAV instead, as it works on
all devices at least as far back as 6083.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 37 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/port.c | 21 ++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 3 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 587959b78c7f..7976fb699086 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2740,15 +2740,20 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
-	/* Port Association Vector: when learning source addresses
-	 * of packets, add the address to the address database using
-	 * a port bitmap that has only the bit for this port set and
-	 * the other bits clear.
+	/* Port Association Vector: disable automatic address learning
+	 * on all user ports since they start out in standalone
+	 * mode. When joining a bridge, learning will be configured to
+	 * match the bridge port settings. Enable learning on all
+	 * DSA/CPU ports. NOTE: FROM_CPU frames always bypass the
+	 * learning process.
+	 *
+	 * Disable HoldAt1, IntOnAgeOut, LockedPort, IgnoreWrongData,
+	 * and RefreshLocked. I.e. setup standard automatic learning.
 	 */
-	reg = 1 << port;
-	/* Disable learning for CPU port */
-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_user_port(ds, port))
 		reg = 0;
+	else
+		reg = 1 << port;
 
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
 				   reg);
@@ -5604,7 +5609,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 
-	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5623,10 +5628,23 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 				       struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	bool do_fast_age = false;
 	int err = -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
+	if (flags.mask & BR_LEARNING) {
+		bool learning = !!(flags.val & BR_LEARNING);
+		u16 pav = learning ? (1 << port) : 0;
+
+		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
+		if (err)
+			goto out;
+
+		if (!learning)
+			do_fast_age = true;
+	}
+
 	if (flags.mask & BR_FLOOD) {
 		bool unicast = !!(flags.val & BR_FLOOD);
 
@@ -5648,6 +5666,9 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 out:
 	mv88e6xxx_reg_unlock(chip);
 
+	if (do_fast_age)
+		mv88e6xxx_port_fast_age(ds, port);
+
 	return err;
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 6a9c45c2127a..f77e2ee64a60 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1309,6 +1309,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
 				    0x0001);
 }
 
+/* Offset 0x0B: Port Association Vector */
+
+int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
+				    u16 pav)
+{
+	u16 reg, mask;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
+				  &reg);
+	if (err)
+		return err;
+
+	mask = mv88e6xxx_port_mask(chip);
+	reg &= ~mask;
+	reg |= pav & mask;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
+				    reg);
+}
+
 /* Offset 0x0C: Port ATU Control */
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 921d54969dad..b10e5aebacf6 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -407,6 +407,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 				  size_t size);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
+				    u16 pav);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
-- 
2.25.1

