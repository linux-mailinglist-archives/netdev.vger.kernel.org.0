Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DB52F62E3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbhANOQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANOQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA3C0613ED
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:48 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c7so5852027edv.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HwbhHNVAIeAKdCRLISNvB3BWDgPem7dO+4VLkW+Ord4=;
        b=GSAGFnv3bIGlcV4gAMfn3/fE65Y24HWyaDXmAhKgb618w2luIUXAiIdEkadrpiA1yP
         TIz1sgy6b6eKMZAt/4NijE5VWHZr16ATvHq0nUEgwDeW4aRovHlrifl0ddprjnHnX7me
         M6NR6SM6iJwXyRObo3e+RMrsyxfKVkkO0h9PcNhT9UIl84+v+KZyqn34yrsyDP0yxCyt
         4QmEMc+pj31As3BA9GDLilx7OJdmaIdx9p8OpgeNhbxJuEctCvpi7IhsEZEslPUIjN/r
         v2DFdhQJqbo3gb9cCPhtAkcHJEoaLbGeneY8NlSSZbHcXEt2g+UZ3WREfDrGFH1TSURP
         5ZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HwbhHNVAIeAKdCRLISNvB3BWDgPem7dO+4VLkW+Ord4=;
        b=UKiXb0ihCZh2WO4iec1HkeAHNIapiGk9FRlE2B8rHgIR9LqQtKA52V/p4vunXFQRh4
         zKZsXyj+c2gt8L/yfNHeWijyILJg3jsQGxhenhOZ3LTL8QLNmCwhOwHUZjKbUJzGqZvX
         37QAgXP/xze2QRMeD2CQs6xxhvGvu372bXuZX2Q5UJMBlhK6jJ/Po+j3irSxVTx8hUCm
         xZ42U13yLZPOLnbnsYaYgv3xeNH1l7Ii5OqDgoLnUXovDrpM+LMCCDuPaSql9NJG4eoO
         k5K03PoRJN3J4N3NgSZjUt2/GUO8X5PeIuPoSxR/dJoiAzfbEEjCh/cjmgHkyUXtrLMp
         65MQ==
X-Gm-Message-State: AOAM533OJv/T3vLc9hPOLLYzr74zDILavzt8I0MVrTVLW/XrFMhPNtAg
        verIG15ZJu7fo/x8j1i6QTM=
X-Google-Smtp-Source: ABdhPJyQogNSJTmUFk/5+Jc3JwkhiPilGFa4mURQzDlxbWMR4BdchpfsKmsI25czUQ46bWqpWwRmeQ==
X-Received: by 2002:a50:eb96:: with SMTP id y22mr5958077edr.91.1610633747650;
        Thu, 14 Jan 2021 06:15:47 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Thu, 14 Jan 2021 16:15:17 +0200
Message-Id: <20210114141522.2478059-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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
Changes in v5:
None.

Changes in v4:
Removed the unnecessary if condition.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 532e038e8012..3ec06bdd175a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -610,14 +610,14 @@ static void felix_teardown(struct dsa_switch *ds)
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

