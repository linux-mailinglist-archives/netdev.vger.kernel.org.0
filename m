Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9991B454EFB
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhKQVJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240725AbhKQVI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE371C061202;
        Wed, 17 Nov 2021 13:05:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so17245656edd.0;
        Wed, 17 Nov 2021 13:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Vo6cAfjs/htr35w2rIRklqSudZBIEyLbTN6ICJxY3Uk=;
        b=LNCD6PsNRLRMGhp6gKBkoIaU+mV7Nhe3Ef/GTdf/F/Zf2rVgwMc1x8MzqQnd+FLLag
         M9tH7mr0NcKWwBHaMDGUmx92h+ErNwcxA+WXupn3HpmgC6yKSyDUlm4/3gRukIyofIE2
         Cu0ESfk1YwCZ/+f+5AD23af3/QAr6+hhLIXAzwKXSQm2Jgem0fzmKqv94BKynVnontzq
         4V65u1JDsGc21hUd8WL7hkRnwiBhBMcXPflrY5Pp4vCzu1doGX5nNO0rNxgaWlmK3kWy
         RIZXzzI8oWHIbUGLfOw5NJMEgAYx5Z8ejic8S2paOP6xFRQ/akRNrc5sAAnn217VVUuh
         xvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vo6cAfjs/htr35w2rIRklqSudZBIEyLbTN6ICJxY3Uk=;
        b=6ARXAYoFgoYV7WyrfZFs1dpRupAVHfWDXukCNDDW4R4QS1BS/5awyiPq+lcqUr2HXy
         Jdi62FlHgIQF/iWoOSWAYJZDOrU5R4nOG+GePPCNaevA6wqfvsruBM4KaS0dimNtS/tc
         Sw4xPzCTwQotJFwnHs0Aq4vrMP89mkrzb7qCRq6nTO9OQYUALHRkdOEcNVfj5DJyDVgy
         C958AyHAxI3FgRfhA6lEFbAs5wN0DzgVrodD8BlqS56mEqh2PEy4MYKdR4S61IXWsGl9
         AUCUFKcjctm8jsHiPIhOiGRDNwpCECkePPM+RRJrP9QSwzxb4jTnyjzhxgo34OnO8yVS
         l5fQ==
X-Gm-Message-State: AOAM53031GewRhSwzkaDVrSjil4ULkgg/7UFVx9mNHeJWEdBATq85SBs
        3AW7GfefcfS/qdEjqNIIqp0=
X-Google-Smtp-Source: ABdhPJxW1eYue4tIhZOFwIbC6kcXdkHrl2GStBjV9W4g2INHRXVlzzEX0JGt6agpaeloVle8MankdQ==
X-Received: by 2002:a17:906:ce2a:: with SMTP id sd10mr25635129ejb.154.1637183128359;
        Wed, 17 Nov 2021 13:05:28 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:28 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 10/19] net: dsa: qca8k: add support for port fast aging
Date:   Wed, 17 Nov 2021 22:04:42 +0100
Message-Id: <20211117210451.26415-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch doesn't support fast aging but it does support the flush of
the ARL table for a specific port. Add this function to simulate
fast aging and proprely support stp state set.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cf4f69b36b47..d73886b36e6a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1823,6 +1823,16 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
+static void
+qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
 static int
 qca8k_port_enable(struct dsa_switch *ds, int port,
 		  struct phy_device *phy)
@@ -2031,6 +2041,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_stp_state_set	= qca8k_port_stp_state_set,
 	.port_bridge_join	= qca8k_port_bridge_join,
 	.port_bridge_leave	= qca8k_port_bridge_leave,
+	.port_fast_age		= qca8k_port_fast_age,
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
-- 
2.32.0

