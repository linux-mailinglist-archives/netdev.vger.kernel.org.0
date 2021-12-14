Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260F1474D14
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbhLNVLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbhLNVKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:39 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226E7C061574;
        Tue, 14 Dec 2021 13:10:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so68410698edu.4;
        Tue, 14 Dec 2021 13:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUPes/3MtaxDn8kCbGlju4ZLauNKEJ7jIp98yMyyHDo=;
        b=dX3TMkfLCP/SZLzjWwui4z2EIONdqrL5yPdJ4TPVA+bUfwZHCSRLAYYZ5U+CojEGsI
         NzNtST1MEakQZn/WFc0tiO5uaVxPNWZpWFbCXYLbRnGckJE3lNodYI2Kd2LFuT4f1b+3
         ZGEcaMVcW8frl0B5lTdGcsw4N3QL33o9ngpuFEkLIFGa9PIDnpWxmgm/57p4e7jgZRBX
         BH7LpHEH7YEl5sEJeBAaEJcJ6HiwwDtIAgAOaOW1eF+ut7+DtYn/5O1siVF7skoOCAuy
         XQMZ980T5YBoPfVBu1hgg11msQaVbSuwnaZVeqtCqHKMulkvuYcJLxYX0KRXejt48/2L
         d+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUPes/3MtaxDn8kCbGlju4ZLauNKEJ7jIp98yMyyHDo=;
        b=I7J+WitO8fnxhy8sIMo7U6cUut1PMO1QEZWtNNhWEZQgxXqGOjg4jmJVZ6QPajyYXM
         og2Z846AyVtxZXjpkGm6HkGca3t81OcMLpoNtUcihw2tD9vbaCWoNL6MWCHCAK8an46y
         F6eM0+Z1neCz9agFSeivqxsYjh/hEFevQb5/GIUzE/6/kYV581D+zIPy/gK232aIzlGn
         8d6t2OxeauEuWyAHlBWRhCrdP3/VgPby565hPAphjjSq00dAp83hE34/d7VuzRMumKWO
         dv1M4iCANOfezTlRlK/wKPS7guifS7A1hS1SCCF0TWF3osO7KFn8ZJpE1lKfpzZAEvpR
         z8Bg==
X-Gm-Message-State: AOAM530Q5AgjG9MStEdqQ2r0kpHUbPXGK7uu9FUlbvUGyeUdAjxyxL1F
        ZYfKBAd3/G0khoOtICSn/0g=
X-Google-Smtp-Source: ABdhPJxG321tyJvuvg5Hv9QxfZdFPOET8qdlaWOT2LV6GzqQjuq8T1ufJM/59F+pABLY/b9s0f/OcA==
X-Received: by 2002:a17:906:9144:: with SMTP id y4mr8330936ejw.98.1639516237565;
        Tue, 14 Dec 2021 13:10:37 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:37 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 11/16] net: dsa: qca8k: add tracking state of master port
Date:   Tue, 14 Dec 2021 22:10:06 +0100
Message-Id: <20211214211011.24850-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO/MIB Ethernet require the master port and the tagger availabale to
correctly work. Use the new api master_state_change to track when master
is operational or not and set a bool in qca8k_priv.
We cache the first cached master available and we check if other cpu
port are operational when the cached one goes down.
This cached master will later be used by mdio read/write and mib request to
correctly use the working function.

qca8k implementation for MDIO/MIB Ethernet is bad. CPU port0 is the only
one that answers with the ack packet or sends MIB Ethernet packets. For
this reason the master_state_change ignore CPU port6 and checkes only
CPU port0 if it's operational and enables this mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 18 ++++++++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..f317f527dd6d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2383,6 +2383,23 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
+static void
+qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
+		    bool operational)
+{
+	struct dsa_port *dp = master->dsa_ptr;
+	struct qca8k_priv *priv = ds->priv;
+
+	/* Ethernet MIB/MDIO is only supported for CPU port 0 */
+	if (dp->index != 0)
+		return;
+
+	if (operational)
+		priv->master = master;
+	else
+		priv->master = NULL;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2418,6 +2435,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.master_state_change	= qca8k_master_change,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..6edd6adc3063 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -353,6 +353,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

