Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DCA26EA46
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRBHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgIRBHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:45 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8408C06178A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:44 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ay8so4367544edb.8
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UXyJVTLZgb57NxbzPrOGCROeLHJYT91XwtzL9vJNF84=;
        b=TzauTAOVqWipnHgtaXburYrL3Rj7386MCos1BoK2Ur7s9q+n7pDdcPTpbl7b0f7aS4
         WLt2gTnf6Xnsw7hhcyJe1FfPEAWgc0VETrLQA4MZjhvK9jWnY02SSSW15Wg2SzM2ppfN
         66KWF9q4OKkV7Y757TK56vf5abDCbquWzeMy2zXbAENn8txLKIB1B9xGJ6JUfV/j5xB7
         tXy9AaO+RH08NqwcCMKVvo6hmRaH4cIqtT2+1iJk9QOTkaEn2plWuzDbXkgOCZdJY3rS
         2FqYRdplI504nJq0Mk9P6iyp2rg6OI2VUB16lUINMGeHSdiZ4PgzVuY8fX9r0Z7zSEJ9
         OwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UXyJVTLZgb57NxbzPrOGCROeLHJYT91XwtzL9vJNF84=;
        b=th5jchm+b7nyd+Mm1KEqsf0ti+0mltIks3prfwrXwTuCKwuXt7i4bEQ4jVlBISA+zs
         dUBjk1FDut0ankG68tEIPo4pSDwtXnRFaBS4uChts2yeeMv7+Jtv+mrZfM4aPixLGhPg
         v3SCv+NYywvN5L+B/MnzU9IwgbLND2C0/nus7632JRH8tmfsUqjlvgpStGcO4WBQXlNz
         aZXWS2CJHOJ/TXop3w48257OfONq1Jmlwv4rboxVXxzESUWcO669t/1klF0TU51nPU7U
         QTlGqLxiUQ4JVuhOhcpc1MGpbpB6qRUsyHEl+r1gjaa88QASctQmYRvGCy7TZyRrQAA3
         OoGw==
X-Gm-Message-State: AOAM531XKGlB+TFWvoA6ZXBxz8yuxbP75Z39pyxi1SRe9fJ1Udf+OyAZ
        +htscqbjqSjQxW2sfVn6820=
X-Google-Smtp-Source: ABdhPJxOob0ifZk+gH7lJcTo94wF4TjEsP6o7d+6g7cOsLW+19cYBcWRdzyiyzGA6JSG0XqwVVllaA==
X-Received: by 2002:a05:6402:cb4:: with SMTP id cn20mr36242278edb.369.1600391263424;
        Thu, 17 Sep 2020 18:07:43 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 7/8] net: mscc: ocelot: unregister net devices on unbind
Date:   Fri, 18 Sep 2020 04:07:29 +0300
Message-Id: <20200918010730.2911234-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This driver was not unregistering its network interfaces on unbind.
Now it is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
No longer call mscc_ocelot_release_ports from the regular exit path of
mscc_ocelot_init_ports, which was incorrect.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ff4a01424953..252c49b5f22b 100644
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
 static int mscc_ocelot_init_ports(struct platform_device *pdev,
 				  struct device_node *ports)
 {
@@ -1132,6 +1152,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
 	ocelot_deinit_timestamp(ocelot);
+	mscc_ocelot_release_ports(ocelot);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
-- 
2.25.1

