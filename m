Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D156A454F03
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhKQVJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbhKQVI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:56 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B907C061208;
        Wed, 17 Nov 2021 13:05:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so514583eda.11;
        Wed, 17 Nov 2021 13:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Qmv8qo+QxDVPN6UIObyaH8GywsYhFGmXd4xEC2qvNt0=;
        b=lkS4girpWq6e+Bw4q/pxFbyJjxoSII8F7mm5xU88aktLy5s1tFmeE8pGJHZGkNNgah
         VqoU2USxjzQVFXenWvNIEytVVWaZKDtKs+3h4TdyaDBWc5csKmPhEAIIqxBXi2Gt0KCo
         rOLlhSEIhoeVyZOVwd2RlSnc9faYaA6zBaGaiTuxi/iIOQeUiVUlD0nfLvyyvx9GL5ME
         1MgOBTDWv0Cmetj4oaymQ4YRXZBypm8u3KOIBAnUH+EYc+zjNmXadd6jEy6YLxK61e5B
         Zps0JS1RnMGkogaOAUgGyjTX7/r7EnD0VQtMx4zy++SM3ZFIE0iSyUvBBpzNHto7cR/L
         aA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qmv8qo+QxDVPN6UIObyaH8GywsYhFGmXd4xEC2qvNt0=;
        b=cHgbXNh+G3YfVA722J1E3ptV1ENT8AoZSsfa1Z+lIhg5m7ARv8p0+F2G6u/8E0k5ik
         7b1VNk59D5NVx13nBxtXXqTMch4fdAjLgFlrobUVr2TjRj58LQOikmKIdK4bEV0qAOYs
         lKKlsxTUkIzCSxPWZpxjyNEC5gNAiHUG0+xvQ+wLVE+G5JKCYmdoMS/OPQj8bcL7kjga
         vHQQzagMTyb204Ark16b/YJMpXK/i45L5oyhVoUzHXhzw2wJQEtJx1AULxz2OHBzEEws
         cbdklsg9MHoHE5Kw9NnqYU4s8UdJXc8DWHlnzET729fwyKNAcRhii/DlIx46L76KNT0+
         L2jw==
X-Gm-Message-State: AOAM533Burrwb9c3X/EsmBp4A1V7aq6mZh94D1Up04BdWYfM72CrYRbo
        h9+n7TPV0KHYXUuH/sHS9pUtJ8//P6Y=
X-Google-Smtp-Source: ABdhPJzKubM5jPoYAyJYpFSMOiXVM7lLmZGfeKqZ+Sj4g9FiHP9R059s0t0/KxLoI/5i7nbGJeIINg==
X-Received: by 2002:a17:907:a40b:: with SMTP id sg11mr24991330ejc.534.1637183131680;
        Wed, 17 Nov 2021 13:05:31 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:31 -0800 (PST)
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
Subject: [net-next PATCH 14/19] net: dsa: qca8k: add support for mdb_add/del
Date:   Wed, 17 Nov 2021 22:04:46 +0100
Message-Id: <20211117210451.26415-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mdb add/del function. The ARL table is used to insert
the rule. A new search function is introduced to search the rule and add
additional port to it. If every port is removed from the rule, it's
removed. It's set STATIC in the ARL table (aka it doesn't age) to not be
flushed by fast age function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 82 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index dda99263fe8c..a217c842ab45 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -417,6 +417,23 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_fdb_search(struct qca8k_priv *priv, struct qca8k_fdb *fdb, const u8 *mac, u16 vid)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	ret = qca8k_fdb_read(priv, fdb);
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
 static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
@@ -1959,6 +1976,69 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int
+qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	struct qca8k_fdb fdb = { 0 };
+	const u8 *addr = mdb->addr;
+	u8 port_mask = BIT(port);
+	u16 vid = mdb->vid;
+	int ret;
+
+	/* Check if entry already exist */
+	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
+	if (ret < 0)
+		return ret;
+
+	/* Rule exist. Delete first */
+	if (!fdb.aging) {
+		ret = qca8k_fdb_del(priv, addr, fdb.port_mask, vid);
+		if (ret)
+			return ret;
+	}
+
+	/* Add port to fdb portmask */
+	fdb.port_mask |= port_mask;
+
+	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
+}
+
+static int
+qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	struct qca8k_fdb fdb = { 0 };
+	const u8 *addr = mdb->addr;
+	u8 port_mask = BIT(port);
+	u16 vid = mdb->vid;
+	int ret;
+
+	/* Check if entry already exist */
+	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
+	if (ret < 0)
+		return ret;
+
+	/* Rule doesn't exist. Why delete? */
+	if (!fdb.aging)
+		return -EINVAL;
+
+	ret = qca8k_fdb_del(priv, addr, port_mask, vid);
+	if (ret)
+		return ret;
+
+	/* Only port in the rule is this port. Don't re insert */
+	if (fdb.port_mask == port_mask)
+		return 0;
+
+	/* Remove port from port mask */
+	fdb.port_mask &= ~port_mask;
+
+	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
+}
+
 static int
 qca8k_port_mirror_add(struct dsa_switch *ds, int port,
 		      struct dsa_mall_mirror_tc_entry *mirror,
@@ -2160,6 +2240,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
+	.port_mdb_add		= qca8k_port_mdb_add,
+	.port_mdb_del		= qca8k_port_mdb_del,
 	.port_mirror_add	= qca8k_port_mirror_add,
 	.port_mirror_del	= qca8k_port_mirror_del,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
-- 
2.32.0

