Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760994715EC
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhLKT6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhLKT61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:27 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3848C061714;
        Sat, 11 Dec 2021 11:58:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y13so39585431edd.13;
        Sat, 11 Dec 2021 11:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jpcobtTbBZ1w887AMWL3/EJGu3y4OL0zdgkB+Vu4530=;
        b=MU436WRoWzQtR/Zi3RsnOKAR6tmXltJTkty3Z7dbWFoX84lbbgINxOVwPg7aCk7/gr
         P+LxC8GRHrLgj0fcqg3OcNRs4hYnvTptGG03F9qW1aw36EPIv4RY7ypYbToW7C5QRtWy
         K8x1Jrkod3Sk9AE/Ci2qUeC4tCne+KvjVSaEvn/dvH3yUhsh1CthQr2M3Be1wjm+YrGv
         oKngfQYa35hwMEiqoA4d7EMOFMT7W3oLkEmN2vU+Zcb1TG4efwPMUK8nKU7GvjIotGG1
         fMgkOHupUDoput9JDAs96Fl/3tB9bYxpYGjU6Cga69/7gcxrMV3DNMyrpdFPAevNOb28
         ySaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jpcobtTbBZ1w887AMWL3/EJGu3y4OL0zdgkB+Vu4530=;
        b=ID3k4OaW8QBFYHp1zG0fdgug35RFIxFka2Nq+i4+fzklLN4LeSo32A8qrAApCk7CyR
         3E9lVyYWsH9cwgh8sNOlrr2iozH0OQGEqcRREvy4/s5adJbtLeYtYqOsHSo6nJWiy28o
         65+Z7GYl5oP/lLJ821TKlXwwPuYSMmfnuefeCgrD0HKOE7qrLCXzbCsfsnPyul+u12GM
         dBRc8SKN5amUmfscAa+ma0jiXeZo2PjNzEayng31G3SyRnpi/jVwGamphpvaOVe+kAIj
         wzqybBXC4StBg0ib/wnHG6FE7ZKZGMtTdbt7QCkUIf68LTkXGLMdyPM13K3ZPRHbd0dc
         41Vw==
X-Gm-Message-State: AOAM531V917PUYN6HcrfGkdAdZCtjrB39Y5pdd/cAN+KRDbv4wGmcN6D
        CYUsdcugn42Hfl8Q0CQ6sjY=
X-Google-Smtp-Source: ABdhPJzsyRYSSPj9YO66lBksPIc03scs9965o25BDZDAu8K9fd/B0PP6j4g7cd8v0YgQ6Q/I8q6Pcw==
X-Received: by 2002:aa7:d695:: with SMTP id d21mr48722382edr.378.1639252705408;
        Sat, 11 Dec 2021 11:58:25 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:25 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 11/15] net: dsa: qca8k: add tracking state of master port
Date:   Sat, 11 Dec 2021 20:57:54 +0100
Message-Id: <20211211195758.28962-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO/MIB Ethernet require the master port and the tagger availabale to
correctly work. Use the new api master_state_change to track when master
is operational or not and set a bool in qca8k_priv.
This bool will later be used by mdio read/write and mib request to
correctly use the working function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 13 +++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..905fae26e05b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2383,6 +2383,18 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
+static void
+qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
+		    bool operational)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	if (operational)
+		priv->master_oper = true;
+	else
+		priv->master_oper = false;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2418,6 +2430,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.master_state_change	= qca8k_master_change,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..fb98536bf3e8 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -342,6 +342,7 @@ struct qca8k_priv {
 	u8 mirror_rx;
 	u8 mirror_tx;
 	u8 lag_hash_mode;
+	bool master_oper; /* Track if mdio/mib Ethernet is available */
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
-- 
2.32.0

