Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE4931C9BA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBPLdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhBPLdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:33:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B88C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:32:23 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id do6so5504343ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S+kXSrKu/VHSFbRfdiANJw3TdGnhPGjGtViqpZoq1I=;
        b=lInqdYsDXCbjDSJKcOmlgL7xaueiSYwPJ7btFoa1IjO97Y6RcUTwzDKVHYj7J2d36h
         tsDXkX8S/U2kH4jjhEmDS38ClcEILrt3pFXeC+k531hTkM249J+78SEKQQ6KGItivlwE
         6GzPG9LqxAkIdBYATYiXpzGdg17GUc8viDFAs7/qmflGxdHd393qVnWfnKn8hfKoPakp
         i1h6TaVFzqLBdBPPkd3Ln1eCkBUoHwzvJbaTmysU6G9rHKjMfeOtDYe0ET3gY7dyI3Fr
         fgpmw3ZtStRTquVvCwoMnKjbjtZ+7rzxnD8hgTzxkErtJc86rqhWw+TvbiMUwHQZAFFR
         SFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S+kXSrKu/VHSFbRfdiANJw3TdGnhPGjGtViqpZoq1I=;
        b=TcgwQ/IUmS2NR7SY0mlNvUD55g7r8MJPCFzVRVUYVeVP8BYfMukN3Kkkx/EvpeeVeW
         iGOXwiGxnhAiR0nhKReGXmeyCAex6CXnRJnlqkX0sQwdFANTUj6NEVO2h5tXvHPav9wo
         YjmiBIKx5/IYbFr+CM/rj+aGz3QesSzo7W1xQOvGveZljKJOSble/BBLuSwxWfUdmEsB
         /nppwG/VJhW0Iv3krEJhmcpxAwf8FdT0BabFyFT/XrhR55XvkFRQyzaS3Jr05yrhLPLN
         /qAHI/xV2NsBaheZGQqyOJSeHgPYFnXXdHdannuEnS3ftPAl8rv//28F1V/WlwriV598
         EqmA==
X-Gm-Message-State: AOAM533k8hXZ+Bb6/pg7Ehzbd8DzlRdI5dMvmJdyzslkK5uEGC+FW9qB
        fHQ6GYpu52uKPOF04eXWtwE=
X-Google-Smtp-Source: ABdhPJzbtd9yJmDD7ORE9dqgCkAetmeQ0VJl4bU7l3Avsyr0swqWiNi3iGLHOPnBwRn0UcYc7dHfOw==
X-Received: by 2002:a17:907:3f13:: with SMTP id hq19mr20100988ejc.142.1613475142532;
        Tue, 16 Feb 2021 03:32:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hd39sm12363636ejc.116.2021.02.16.03.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 03:32:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: dsa: felix: perform teardown on error in felix_setup
Date:   Tue, 16 Feb 2021 13:32:13 +0200
Message-Id: <20210216113213.2854324-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If the driver fails to probe, it would be nice to not leak memory.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I've decided to target this patch towards net-next because:
- no user has complained about this being an issue
- in theory there should be a Fixes: 56051948773e ("net: dsa: ocelot:
  add driver for Felix switch family") but the fix already conflicts
  with some patches that are in net-next:
  * f59fd9cab730 ("net: mscc: ocelot: configure watermarks using devlink-sb")
  * c54913c1d4ee ("net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port")
  and it would unnecessarily cause maintainance headaches to resolve the
  conflicts.
  Alternatively I could wait until net-next is merged into net and send
  the bugfix at that point, but the result would be the same: the patch
  would not be backportable basically anywhere.

 drivers/net/dsa/ocelot/felix.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e72f0a79918..4a300ef41de6 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1202,7 +1202,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	err = ocelot_init(ocelot);
 	if (err)
-		return err;
+		goto out_mdiobus_free;
 
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, felix->info->ptp_caps);
@@ -1227,7 +1227,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
-		return err;
+		goto out_deinit_ports;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (!dsa_is_cpu_port(ds, port))
@@ -1243,6 +1243,23 @@ static int felix_setup(struct dsa_switch *ds)
 	ds->assisted_learning_on_cpu_port = true;
 
 	return 0;
+
+out_deinit_ports:
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		ocelot_deinit_port(ocelot, port);
+	}
+
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
+
+out_mdiobus_free:
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
+
+	return err;
 }
 
 static void felix_teardown(struct dsa_switch *ds)
-- 
2.25.1

