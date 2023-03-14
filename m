Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70B06B9E56
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjCNS2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCNS2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:28:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E36B4207;
        Tue, 14 Mar 2023 11:28:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so3924391wmb.2;
        Tue, 14 Mar 2023 11:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678818486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mejdm1PVBamcQlmV+ZPGdHyY8u7PvL3G0WvxDB+iTUc=;
        b=Dz4Fq0SkB1GGcjIAK2UqKsToHpEYEeivigC6CUyH97xIUBKHtFiWyNinxazqWqPI01
         iu+mXB0EDIhFonLyk06xP6H1yeo+1z9JGdzbFh/aEJcqpvw4eVr6D6C7+bMWxhHWq5bk
         6XlMDxLRJUjRhpsFhCEf2wTGr/fR93B/rPTk8khEdeY9ZQYGN251zUB7FqlldNfeHjL1
         hJQiLB2sP0oKmycpsW+kffpm0yrTz87ngB+7y22Fm4aOXlLjhYfz7vfY4pr7GKchsQkr
         I2g6QUfspicJOa2sQ8Q+IvMhowz2MFSkICPBRMjllPc+DDPz5IvKWpomtZMNu7g15W6o
         nNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678818486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mejdm1PVBamcQlmV+ZPGdHyY8u7PvL3G0WvxDB+iTUc=;
        b=y4ZSifVMI8vXaNi7JjKQ48PCtxYPahGvngz9DTqwDJ75KQGAWd5kerXxCkW+fTkd0m
         DAx67ZjFoEv3BjFv5dCHY61+Xkof++2Du6m+PfhYS05RJ+W/NUwXDaEOK7wFYuDlCgGa
         JyPQVvIgjDeJiZ5CJbsOcLQVaRHtnUerrteVUlHZwFj5+8ovE8Oh6Ir7uemTjUxkUxfl
         Ny+w1azS/Vjv1Rz5fNzr/ysdheayZaLjc8jVzLjCGTKD55K7sDc9WEntHGI8S8Sq/Bga
         0zJYIhwvZpwQwYBv2Uwg7RaMrYr6uTopBFeMj+eL5+7W1tchoflXr79DWLGUZvkH38Hl
         zRZg==
X-Gm-Message-State: AO0yUKUjKzh6jcQkeHiPqOp+iiVEAmfy0SguAvvLVIyMtcXSsaOqxP2e
        QXJuXs/jIt7AQtx3co+QxOo=
X-Google-Smtp-Source: AK7set8HaWF313rQh2Xnm405UFcOtov29/qY6dNQZEbMSDg2rw9QUKy9JGmPPzsu6iV4HNe6qG0Png==
X-Received: by 2002:a05:600c:4693:b0:3dc:4b87:a570 with SMTP id p19-20020a05600c469300b003dc4b87a570mr16917460wmo.35.1678818486569;
        Tue, 14 Mar 2023 11:28:06 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003e206cc7237sm3443490wmc.24.2023.03.14.11.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:28:06 -0700 (PDT)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v3 3/4] net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
Date:   Tue, 14 Mar 2023 19:26:58 +0100
Message-Id: <20230314182659.63686-4-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314182659.63686-1-klaus.kudielka@gmail.com>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the rather expensive mv88e6xxx_mdios_register() at the beginning of
mv88e6xxx_setup(). This avoids the double call via mv88e6xxx_probe()
during boot.

For symmetry, call mv88e6xxx_mdios_unregister() at the end of
mv88e6xxx_teardown().

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
v2: Extend the cleanup in mv88e6xxx_setup() to remove the mdio bus on failure
v3: No change

 drivers/net/dsa/mv88e6xxx/chip.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 496015baac..29b0f3bb1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3840,9 +3840,9 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 	}
 }
 
-static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
-				    struct device_node *np)
+static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip)
 {
+	struct device_node *np = chip->dev->of_node;
 	struct device_node *child;
 	int err;
 
@@ -3877,9 +3877,12 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 
 static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+
 	mv88e6xxx_teardown_devlink_params(ds);
 	dsa_devlink_resources_unregister(ds);
 	mv88e6xxx_teardown_devlink_regions_global(ds);
+	mv88e6xxx_mdios_unregister(chip);
 }
 
 static int mv88e6xxx_setup(struct dsa_switch *ds)
@@ -3889,6 +3892,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	int err;
 	int i;
 
+	err = mv88e6xxx_mdios_register(chip);
+	if (err)
+		return err;
+
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
 
@@ -4015,7 +4022,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-		return err;
+		goto out_mdios;
 
 	/* Have to be called without holding the register lock, since
 	 * they take the devlink lock, and we later take the locks in
@@ -4024,7 +4031,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	 */
 	err = mv88e6xxx_setup_devlink_resources(ds);
 	if (err)
-		return err;
+		goto out_mdios;
 
 	err = mv88e6xxx_setup_devlink_params(ds);
 	if (err)
@@ -4040,6 +4047,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	mv88e6xxx_teardown_devlink_params(ds);
 out_resources:
 	dsa_devlink_resources_unregister(ds);
+out_mdios:
+	mv88e6xxx_mdios_unregister(chip);
 
 	return err;
 }
@@ -7220,18 +7229,12 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_g1_atu_prob_irq;
 
-	err = mv88e6xxx_mdios_register(chip, np);
-	if (err)
-		goto out_g1_vtu_prob_irq;
-
 	err = mv88e6xxx_register_switch(chip);
 	if (err)
-		goto out_mdio;
+		goto out_g1_vtu_prob_irq;
 
 	return 0;
 
-out_mdio:
-	mv88e6xxx_mdios_unregister(chip);
 out_g1_vtu_prob_irq:
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
 out_g1_atu_prob_irq:
@@ -7268,7 +7271,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 
 	mv88e6xxx_phy_destroy(chip);
 	mv88e6xxx_unregister_switch(chip);
-	mv88e6xxx_mdios_unregister(chip);
 
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
 	mv88e6xxx_g1_atu_prob_irq_free(chip);
-- 
2.39.2

