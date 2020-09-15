Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9536426ABCA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgIOSZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgIOSXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9289C061352
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z23so6385424ejr.13
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bHMA1OZ71J24cXNTJ+Ui1obSZeD2uKalee+oYkWXVSo=;
        b=o3Zmi1BASo6TM8wuDMXiZEyslXtCmYHAvnnX8uQzlEg5z+ZnlMnyJaZkaR+fIXjr7c
         9LwwyQIDIPDRM6kwNtrR76W+DIkgV0BuoqsqCOkWOPI3ubiu8SJorYUEhRbIkysEmZcM
         aeufrGzmG0/KTofPtDqWa2BejUoEfRlcnx35ihAK5G5qDJKS+OC63krwvKuD9zNsH4Zl
         +av0nF8l4Sa9P0PcS3p3hRzRFVgD+s9u3Br2rCUwDEQknNsPPs368LiBuk88szvQEfqV
         wXzio2B9doND17j8jnbqPmwugKFcchweWxFSu5vdKnPJrlr6hyN6W46H9a9+UcdjPK0d
         RkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bHMA1OZ71J24cXNTJ+Ui1obSZeD2uKalee+oYkWXVSo=;
        b=uoQ59Z4lE9iBdUEqLnGwGEoPq84L5VSu+R4CQyFQmlN60uJM129kCAwk40FBIryO1x
         s1xNMkcjOUDHq9h0yePfiDlI9oNPB908ls4rzg6QLmnyidsIHHCtrb01r3XaNQwgU0dC
         MSDAxac3zeKRiKfourgCF1aIS3qHuCDNCKJm7LWNxTXl3MG091c0eC4uycs9mc+XLK8g
         pWN/wpC0tC15MKBoRpIOA0CPiEVzd+Uy7DqRwZByL6R9c85GJqV05JseUxN0UfwzixD2
         J9L18l28huiCTzNmU04BR6vZkWEg9sx0UKCmmeQQS7S5eu4YJ5k5MIN0vC87+QnB0JXE
         7D1Q==
X-Gm-Message-State: AOAM5323KMYiATQvexvfDHqsT+nnSZq2pylPEdKFZP/igT3z0WQh/22D
        5nEpOei82Zbxf/VLNDuLKng=
X-Google-Smtp-Source: ABdhPJzCx7lbcnICOWq2+HMh8ASb4UmQVzeIS8XESQ9UpfTkzmrj71yiwc/f6coONx8MLMz5W8OHuQ==
X-Received: by 2002:a17:906:2552:: with SMTP id j18mr21089605ejb.476.1600194177560;
        Tue, 15 Sep 2020 11:22:57 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 7/7] net: mscc: ocelot: unregister net devices on unbind
Date:   Tue, 15 Sep 2020 21:22:29 +0300
Message-Id: <20200915182229.69529-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This driver was not unregistering its network interfaces on unbind.
Now it is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 851e79e11aed..b8f895483653 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -896,6 +896,26 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.enable		= ocelot_ptp_enable,
 };
 
+static void mscc_ocelot_release_ports(struct ocelot *ocelot)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port_private *priv;
+		struct ocelot_port *ocelot_port;
+
+		ocelot_port = ocelot->ports[port];
+		if (!ocelot_port)
+			continue;
+
+		priv = container_of(ocelot_port, struct ocelot_port_private,
+				    port);
+
+		unregister_netdev(priv->dev);
+		free_netdev(priv->dev);
+	}
+}
+
 static int mscc_ocelot_init_ports(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
@@ -1008,6 +1028,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev)
 
 out_put_ports:
 	of_node_put(ports);
+	mscc_ocelot_release_ports(ocelot);
 	return err;
 }
 
@@ -1132,6 +1153,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
 	ocelot_deinit_timestamp(ocelot);
+	mscc_ocelot_release_ports(ocelot);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
-- 
2.25.1

