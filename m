Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5B931C982
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBPLQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhBPLPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:15:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB03C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:14:56 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f14so15849580ejc.8
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGxkM5Y9tXbUoxTYpD2WWNnkLLeDow7t7eqMV9C/bTU=;
        b=IF8NsJvpNC+XqdaJL910suE3hEQaKawU+Ed/eaBWB3s3740qXYzsztcccd7uPWzZ5d
         gdFi1r+ft6OEA7FMSpHFEOnknnGgTMIofc1ArwPGIaZOOxM5GHaXkg8zCux7XDeDGfEq
         ce1nUwbd9nD7ej/PPNSvIloy0RZgiD7n4e/MiLpAhU3PxrZNf5Q8rEe044gOSKv9+j/R
         mHs5nhXFDv/m/oP2Vsd1irovWsTqJSM5/r8rEAQTih1x9rJ4NwQ/rSu6Q+GMvrA/Nvgg
         8IM5LRNIASpzHtjApXxOkf3OJBNmE7dK6OG3A8LZsKj+5DJcCPozEO7dZU+cRrtpbUh1
         Q86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGxkM5Y9tXbUoxTYpD2WWNnkLLeDow7t7eqMV9C/bTU=;
        b=hZKsdneRs3zv/DyEr4Su34S4UJhzBG4BGO8kOp5qEpE2paQVoAvDNlU/PBQtSQxAdj
         i0JByP+kmGBRQG/CX2nXy5rFfooDbGXXMR8ZKAtMge6ja6RLQEPHaIY1ctkheGK75G0B
         /cV7FNy+R1T4N5uRVh/rR6gdOk1ZEX6XYMtXQ6kG3243NIv3wVy+g4wu6GYZapEcCjzV
         O5OUbncn9F3mjBmrtfHtislyCK1Jd3jpFE4aMaN5n99bA2OWVIbeqLfBXCw7l9hBGhT8
         Mf20TJ9nDh/MR4J/PjFkSIbQvaUj9UiJCMOnj11PLmDMfZauO2QsmdX8Ckv4ervOk/sW
         XbzQ==
X-Gm-Message-State: AOAM533wNBm2OmOT8WPmst8BpsJSgYlfZ6BmcMjmhCtyk7FgvN6LndNe
        ae2aW9lapxl8MqzPgS+0EcA=
X-Google-Smtp-Source: ABdhPJxSlwkgzWuIkPo3qYDgUfVTcMILO88UTkMA+Poz+d/TO/4J4sayqw79alv2F6aqVRrTpoO8Hw==
X-Received: by 2002:a17:906:564f:: with SMTP id v15mr17805871ejr.31.1613474094432;
        Tue, 16 Feb 2021 03:14:54 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lt22sm5673485ejb.80.2021.02.16.03.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 03:14:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: dsa: felix: don't deinitialize unused ports
Date:   Tue, 16 Feb 2021 13:14:46 +0200
Message-Id: <20210216111446.2850726-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_init_port is called only if dsa_is_unused_port == false, however
ocelot_deinit_port is called unconditionally. This causes a warning in
the skb_queue_purge inside ocelot_deinit_port saying that the spin lock
protecting ocelot_port->tx_skbs was not initialized.

Fixes: e5fb512d81d0 ("net: mscc: ocelot: deinitialize only initialized ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 800f27d65c6c..3e72f0a79918 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1262,8 +1262,12 @@ static void felix_teardown(struct dsa_switch *ds)
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
-	for (port = 0; port < ocelot->num_phys_ports; port++)
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
 		ocelot_deinit_port(ocelot, port);
+	}
 
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
-- 
2.25.1

