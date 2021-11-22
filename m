Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8EA45914B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhKVP1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239949AbhKVP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:35 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFE4C061714;
        Mon, 22 Nov 2021 07:24:28 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y13so78437063edd.13;
        Mon, 22 Nov 2021 07:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NcTOXmVVw9zRFvYTLlGm+coSHyzynVZURNrWJ5Vxv2c=;
        b=OV0g6WmhwOjVwt3cF4Uf62xHkXkvwb3ab3jiwajcBpvd2oeLhrT7e0krRauCVFtLsw
         f935rfRT+Fc2t2wFrps1n39ynAkBjKIPxZNR1Gs/GKcHtTgCUiyQ/sJd+yMKEc6m/G2v
         hjKym5U4gljxtoR1/Gef1rUOtye2+0AuB9n7K/95BC/yYk98pkO3ruC0ZTyoHu/9nXUA
         zND2VA419ZKmv2kX7+jG3praIrRwlloSQKV6mCIoXhGAPJQ9vLPDfwbjTt9ZeztGDgeN
         lMRKfevS2mJM3aD3sDgNNJdHsYBDQhMMqrvvbpdKlLn7HQN2uvWrLT9EpQTVaFVFjucc
         mUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NcTOXmVVw9zRFvYTLlGm+coSHyzynVZURNrWJ5Vxv2c=;
        b=TvL6se8Un6xkGwofGyolq/LdpwYEDZpbLQBIqMm2YpGTmr5Kl/wuy1KKF3xsqI8Cgw
         YFy92yeVybzcZrBLu0kK0/T57aYRc1t2gLUaUbwPQBDNhwgrQRZxYK3H3a4z7XSOXwcU
         eOiW1XSa/Lo+dSWqQfySw+ximZihZWX9+FaQTxzs2cKbPtj4TEWcuZK7o9EDKNqIYHqK
         rQhiX+AWczwbLeaAuLTtP+I+QtPoApZAGbSJ6+9F6892i1HY/wSgaDOdNa3ED+LKAaQn
         OB+bTYqRse+LMbTDx8zUpPRs7fOsvw17dVDBT+WPfMTk0TDyUoNthwQrdMrl4a2G4orA
         9S/A==
X-Gm-Message-State: AOAM532T1V9YJU+ThgMDVDO0HQvbYRdCC1q8GrVdUGvtji4gnxBjGImG
        F5s5WGAAcFTwsmPbEDPt5XQ=
X-Google-Smtp-Source: ABdhPJzOsBgpBFP9cqqOcq+5C22KWUUPzxgFpjVwnVP/M3vMZ7xFPy4lM4aZQTXgPaPjNfpm5SnnMg==
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr42563895ejc.507.1637594662981;
        Mon, 22 Nov 2021 07:24:22 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:22 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 7/9] net: dsa: qca8k: add support for port fast aging
Date:   Mon, 22 Nov 2021 16:23:46 +0100
Message-Id: <20211122152348.6634-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch supports fast aging by flushing any rule in the ARL
table for a specific port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 11 +++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bedaaa6b9a1d..d988df913ae0 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1786,6 +1786,16 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
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
@@ -1994,6 +2004,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_stp_state_set	= qca8k_port_stp_state_set,
 	.port_bridge_join	= qca8k_port_bridge_join,
 	.port_bridge_leave	= qca8k_port_bridge_leave,
+	.port_fast_age		= qca8k_port_fast_age,
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 91c94dfc9789..a533b8cf143b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -262,6 +262,7 @@ enum qca8k_fdb_cmd {
 	QCA8K_FDB_FLUSH	= 1,
 	QCA8K_FDB_LOAD = 2,
 	QCA8K_FDB_PURGE = 3,
+	QCA8K_FDB_FLUSH_PORT = 5,
 	QCA8K_FDB_NEXT = 6,
 	QCA8K_FDB_SEARCH = 7,
 };
-- 
2.32.0

