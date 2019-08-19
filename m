Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9475B94EA6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfHSUBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:17 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35854 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbfHSUBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id z4so3332793qtc.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVmWxbkYpH4I6gtIKB4RTOdjZBT9l+h2VcfhhYX6be4=;
        b=CKMIiOZ22epgnROgfVHzq4/+qERwY2hvkMxsHWqTCOHDDsLcw0J9llIxdwEV/GsHRF
         85GlUWnL0ETADDsLa7pEJaUPlmeuk9i3T4tZzycsQQlIAxLqDcks9yZRT5d+YzWaEFvL
         hwT+aPLp9ti8KUL1iuk55I24+TLizkLKub3IeD5fAwIabFwjKFUFSyL9Pw1YFomX2vpv
         Pbc7h6z9csh9XthQp0sQU0QFMIMXIAFy/YWoDjNkeBRSfhuKBcb8PSnARnY4wPHOvU7x
         /qkO6I7mPJtyLjV056iQ5Ev7Qh236rGBgYXNR+0chKmkz9RrOQ3VK7sdXs31LkfuvMbZ
         wvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVmWxbkYpH4I6gtIKB4RTOdjZBT9l+h2VcfhhYX6be4=;
        b=fc2PxbX253JToZyR1LlCYUv3coGhKclOTuE9bnrH4JMTUGL1WodE1zlXXFER3DYQUY
         ZA/KxNKWXqOjex6ojvxfRaCzW833YANmgM6fpHZtPtDcWAqdAjGp9HsksOZNtvbGZ8sP
         wSZsQ8E44W3EWyVyGdXaMoeE68Iin2/Brh9YdR0H8aGWpUhoF/uSVdH/7V9B+vn77504
         0XqTEFa+4NlW0lwbguU5p1EFO/PUSpCNHu1lsBGLpuQtHj3/iFFIRMSa9C8RgieT5Ttz
         /pzdvmVNZhvu+goCFJcDm/MPhfmkjnkBskRs9MRDiy4HlHp3nF8nxNUEvBdsGGygq4DR
         SuDQ==
X-Gm-Message-State: APjAAAVpUUYvrkU/GHYDcFiSHiuh/J2HHz/oebfirRhBCOqjBDIbCli+
        64CAwTI5+ZwkmrL+7cNMwVHHw9Y4ZpY=
X-Google-Smtp-Source: APXvYqxOTepJw8ICcwEp86UYjFNxD62zUBpXqXrz6vAAQKsVbPlhxLfCnzP77Oqiia/xcQI7KdAOYg==
X-Received: by 2002:ac8:355d:: with SMTP id z29mr22946884qtb.366.1566244873904;
        Mon, 19 Aug 2019 13:01:13 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x206sm7471378qkb.127.2019.08.19.13.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:13 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 5/6] net: dsa: mv88e6xxx: enable SERDES after setup
Date:   Mon, 19 Aug 2019 16:00:52 -0400
Message-Id: <20190819200053.21637-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SERDES is powered on for CPU and DSA ports and powered down for unused
ports at setup time. But now that DSA calls mv88e6xxx_port_enable
and mv88e6xxx_port_disable for all ports, the SERDES power can now
be handled after setup inconditionally for all ports.

Using the port enable and disable callbacks also have the benefit to
handle the SERDES IRQ for non user ports as well.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 35 ++++----------------------------
 1 file changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 27e1622bb03b..c72b3db75c54 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2151,16 +2151,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Enable the SERDES interface for DSA and CPU ports. Normal
-	 * ports SERDES are enabled when the port is enabled, thus
-	 * saving a bit of power.
-	 */
-	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
-		err = mv88e6xxx_serdes_power(chip, port, true);
-		if (err)
-			return err;
-	}
-
 	/* Port Control 2: don't force a good FCS, set the maximum frame size to
 	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
@@ -2267,9 +2257,6 @@ static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_serdes_power(chip, port, true);
@@ -2286,9 +2273,6 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	mv88e6xxx_reg_lock(chip);
 
 	if (chip->info->ops->serdes_irq_free)
@@ -2461,27 +2445,16 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	/* Setup Switch Port Registers */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
+		if (dsa_is_unused_port(ds, i))
+			continue;
+
 		/* Prevent the use of an invalid port. */
-		if (mv88e6xxx_is_invalid_port(chip, i) &&
-		    !dsa_is_unused_port(ds, i)) {
+		if (mv88e6xxx_is_invalid_port(chip, i)) {
 			dev_err(chip->dev, "port %d is invalid\n", i);
 			err = -EINVAL;
 			goto unlock;
 		}
 
-		if (dsa_is_unused_port(ds, i)) {
-			err = mv88e6xxx_port_set_state(chip, i,
-						       BR_STATE_DISABLED);
-			if (err)
-				goto unlock;
-
-			err = mv88e6xxx_serdes_power(chip, i, false);
-			if (err)
-				goto unlock;
-
-			continue;
-		}
-
 		err = mv88e6xxx_setup_port(chip, i);
 		if (err)
 			goto unlock;
-- 
2.22.0

