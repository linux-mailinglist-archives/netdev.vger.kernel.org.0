Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2513926EA48
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRBHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRBHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:46 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D729DC06178B
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:45 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n22so4415335edt.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Hu8VdlegKI/1lhVBESROiNGyqeA3bjfSgyKXWbmCq8=;
        b=BSw9tUD7M/p6l/nVEU1LkF8SmDk3LKqAnnNRu9l2w3oC/r1gDMV9Yeox4Za4xBXBvb
         T1dvH0rdRXoKFKlyXaxJKLlgaZ+U+pQdLPqkUSOfguLGgm6QX9Z7KuVh4zkc931lJjPB
         HFblbS23WfL4HLzpLMkAAWXPbAky2/dsjI0lArAL23m9AAsJfKjhZGDw1yJ6SY451Nnm
         OJIoWgHKuXRNfagewc0ZW8qfDLASG2XCtao0L8iblUizB1sEworPbt+y0CEuD+SLyTV4
         7zLAsTDojN2RPtfasDJL06vXrBbwHMMrRlknYdjwxemisYIswqGuYXLCS89UH8uPvY04
         e6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Hu8VdlegKI/1lhVBESROiNGyqeA3bjfSgyKXWbmCq8=;
        b=bXLgNksYnvjufAMjDZwFs0XAMr0l1hYwRJvZ+W258Q2kUutNPdFYu1dw/2WdWQ51NH
         8DvtGaaSmfGnj9NMUyhw9xaj/YMIbQgPMDX/Hr5Vl0iZCRzvZg3gWCA00wuHAeu08TCz
         /Ufq7LKoPXbdRDhqmlBnRtfVcQagA4+7afHG80Hd9Ls5xMdMsRsr9QpsIVuQr2lineVr
         H5gKzrK+bkXMYdaHR4z4t9GpRia3HjUwpMS/wdoRvtFp9kgNUOQ3efpqecO697D0Ft0r
         voVgqnItf247hssxBdbnrL+y09KFc7VqVCXfnTsnRpGqtK+0qQoQkAXQVecdVTeCNDDF
         tKnA==
X-Gm-Message-State: AOAM531c6ZEVKgyOXD6TmuwEvJYHWb8IlaNmufpEflW4B6QHnPbLG7Ol
        9bm9wF3gsrpvEeWM2c2uzXA=
X-Google-Smtp-Source: ABdhPJyqp97dMrbdGJD6G0sPlhzXgvJHbYIacXWFAaGAa56FGg5sqTXCIUE/HkaZ8pUY4pc4dCFhWw==
X-Received: by 2002:aa7:c1c3:: with SMTP id d3mr36276701edp.228.1600391264567;
        Thu, 17 Sep 2020 18:07:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 8/8] net: mscc: ocelot: deinitialize only initialized ports
Date:   Fri, 18 Sep 2020 04:07:30 +0300
Message-Id: <20200918010730.2911234-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently mscc_ocelot_init_ports() will skip initializing a port when it
doesn't have a phy-handle, so the ocelot->ports[port] pointer will be
NULL. Take this into consideration when tearing down the driver, and add
a new function ocelot_deinit_port() to the switch library, mirror of
ocelot_init_port(), which needs to be called by the driver for all ports
it has initialized.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c             |  3 +++
 drivers/net/ethernet/mscc/ocelot.c         | 16 ++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
 include/soc/mscc/ocelot.h                  |  1 +
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f7b43f8d56ed..64939ee14648 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -624,10 +624,13 @@ static void felix_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
+	int port;
 
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_deinit_port(ocelot, port);
 	ocelot_deinit_timestamp(ocelot);
 	/* stop workqueue thread */
 	ocelot_deinit(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 83eb7c325061..8518e1d60da4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1550,18 +1550,18 @@ EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
-	struct ocelot_port *port;
-	int i;
-
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
-
-	for (i = 0; i < ocelot->num_phys_ports; i++) {
-		port = ocelot->ports[i];
-		skb_queue_purge(&port->tx_skbs);
-	}
 }
 EXPORT_SYMBOL(ocelot_deinit);
 
+void ocelot_deinit_port(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	skb_queue_purge(&ocelot_port->tx_skbs);
+}
+EXPORT_SYMBOL(ocelot_deinit_port);
+
 MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 252c49b5f22b..e02fb8bfab63 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -908,6 +908,8 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 		if (!ocelot_port)
 			continue;
 
+		ocelot_deinit_port(ocelot, port);
+
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4521dd602ddc..0ac4e7fba086 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -678,6 +678,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
+void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
 /* DSA callbacks */
 void ocelot_port_enable(struct ocelot *ocelot, int port,
-- 
2.25.1

