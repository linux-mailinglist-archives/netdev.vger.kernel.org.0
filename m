Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0ABE91863
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfHRRgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:21 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37197 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfHRRgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id s14so8841937qkm.4
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVmWxbkYpH4I6gtIKB4RTOdjZBT9l+h2VcfhhYX6be4=;
        b=I8+GsgzX4/DRAM599pmWKTnzrRQfsxrCpzLgerh4b0fE00cuVREZ60sj6n6edTpuIn
         hdOXWmsRoGUMF3C6lRDIg6t2xIb+53A2K33bps8kjObsYiJEaGSvQpQDlQHjXP4+50K6
         yX4JWuG9gahiq8egWVpzEOQOV5sCiBjRXrAQXnYCk/DQaMTVe1+1zjrK5b/k9+RiNyKq
         bcUJCMj69CqjcFVjyKaMsgtpnU3VZ7b8MS3lXjawHO4GVVm3z2XB7o/YRFGLps/utycK
         861ggXFHtWxzrjtPmeOvxy1hfabzjqyMm/kU3BGorUB4X1Ch2EGro8KMf28Ulj2Vid4F
         NslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVmWxbkYpH4I6gtIKB4RTOdjZBT9l+h2VcfhhYX6be4=;
        b=oIiGluy0DhmD4tPaBAlEy2RrLadCml0/mzIz8OBun2QZMWZnWZGnNyddHX+lvG9fYg
         5bnnzZBi+N7v+IaPChKne/ZeZqhm84dFH8sQgLPEwJ8ManIYmFZvb3BWC1X8L0fFRFoE
         UMo203xFzu7wFtDXp6BHpIFlh7mRS49Y31jEeoJf2YqoIsic3CjqZsrEH9Api7AFzHvW
         Urmsp/jcPtEVOKhaNc8ON9nKJcKVmbwifLM0EZ97iWeVIUE0B9J5V+0eqM61csrPHEUf
         1egnRojjuXibmh1ntH0S2DvtDzoZ0eK+TNHmW7A2Y6WglV1MxD779pLGNUKnFtnN+gfd
         oqrg==
X-Gm-Message-State: APjAAAW6UeSR3kms2yYYlSyszKx7jBQbzS8+aI+kemPLzME3rPS2Um7F
        /0zaQawJdHLez9bZwhE3pzcINTuH
X-Google-Smtp-Source: APXvYqzWI42mGqxnFv5HRLUlS7noIZcF5Jjreq+h+WVicAeJHWQ18neK9fS27xGyrT1i3UVIOl0o2Q==
X-Received: by 2002:a37:6944:: with SMTP id e65mr16161550qkc.119.1566149778083;
        Sun, 18 Aug 2019 10:36:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t26sm7054937qtc.95.2019.08.18.10.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:17 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: mv88e6xxx: enable SERDES after setup
Date:   Sun, 18 Aug 2019 13:35:47 -0400
Message-Id: <20190818173548.19631-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
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

