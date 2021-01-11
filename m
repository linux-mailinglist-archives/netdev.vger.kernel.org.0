Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2112F1CD8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389777AbhAKRo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389732AbhAKRoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:21 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41352C0617A5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:40 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jx16so793417ejb.10
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UU3FB+g8F4Nk3f4RaT1VmvnnzOjaL3mrsS+FSId6TB4=;
        b=C2/vt6pc5UvPBedaEho2aPdDmrAoQjcegSvVb1IqGx0zR1BRNgMemirzLYkuuyu2gp
         PXAdv07jLbl8KHcjg7CY+5fL7L+oqkRgBzVG5GPkE9Ar6Ib/eXJXJ58kpNMSArzf3grQ
         fiTRcalX7sFaLNL3lh2TyN1ytN2qFlzb08G45CYWZUcuYEQyviO0t7e9lLByYbzXWIQA
         GTmW6r0bymH+wnilacp0DIgLpVpxl8VaFooKMEn/Ro5ltD0ukszV6U+hq/FbKC0gdvWh
         mefM9EoHYCaNJaIFpewQdo/kI0CMdUx6S6qbZmAq8POffVYoBRm8o272/2K2HlrSBAja
         3wPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UU3FB+g8F4Nk3f4RaT1VmvnnzOjaL3mrsS+FSId6TB4=;
        b=i84UreUL8w/GW9YZB5K0fzwPdKHmouu1XyV8EFbtv4l/IgCiNh6cuy/dMNKDorFGvN
         ZxNXan0FmT21Y/Bea/isB447gA9bMiDn0yynwmbjhnMbDkBFUuk1l7Chro66mnpyy0rP
         pZKPraBj6kSZ0ZYV1u5Wg/ge2SX83vw/bEVnuQ8jiEMnY80O/hXmGUOL3Ar9/hNR1WOo
         dyLaGwlYmXNoy2tyaDbFcfOvEJGMtbvZcUz675thjoRjpaExYM70M5kE0nZNFReDSIFn
         utU4wNjWMMxpdFcsanxDvzs+dwLii9eO4Nj6eGr27gwfZZu2F4NImXcHoPsxpsE6jZrT
         i1xw==
X-Gm-Message-State: AOAM530uvq5Qfmpr+xA+3lGy+PpcwgLhgsU6EPDuTn7WCzRo0Hq7KNbY
        WEhHQUUQe+DMLahNnmACJkE=
X-Google-Smtp-Source: ABdhPJxxui7MF/k4lu2HL1Izl4+SW+wq2LbAacKt/faAZn74gwVvRyrV4w5iLF0P5JiZrCRYYQPQJg==
X-Received: by 2002:a17:906:31cb:: with SMTP id f11mr426112ejf.468.1610387019001;
        Mon, 11 Jan 2021 09:43:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Mon, 11 Jan 2021 19:43:11 +0200
Message-Id: <20210111174316.3515736-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In general it is desirable that cleanup is the reverse process of setup.
In this case I am not seeing any particular issue, but with the
introduction of devlink-sb for felix, a non-obvious decision had to be
made as to where to put its cleanup method. When there's a convention in
place, that decision becomes obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
Removed the unnecessary if condition.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 79d0508e5910..83c995360481 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -639,14 +639,14 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	if (felix->info->mdio_bus_free)
-		felix->info->mdio_bus_free(ocelot);
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_deinit_port(ocelot, port);
-	ocelot_deinit_timestamp(ocelot);
-	/* stop workqueue thread */
-	ocelot_deinit(ocelot);
+
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 }
 
 static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
-- 
2.25.1

