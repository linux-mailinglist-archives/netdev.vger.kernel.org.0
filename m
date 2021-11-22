Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6444A45914D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhKVP1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbhKVP1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B46C06173E;
        Mon, 22 Nov 2021 07:24:30 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so78953195edd.0;
        Mon, 22 Nov 2021 07:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/xHrwBXHCYGGobA/XwgxAVUGJtHC2+MbSesHo+s9ndk=;
        b=gBx5I9yDzUbKQoTPluhdGl2RPka6MnmRMgE958EP2tXu9FSNyx2x8f39nbBFgWoerm
         9bhg+/fxuIgubhYWjTYbieWuSX233lJGXq2saVospYZynz7TkdP9pT5HC1r0Y/3InCoX
         s+rlDiALO3Z5M51FGL9sKe2M75aHhaQg5OdDQzAsmGedxhA7EPVyq0ge+UmuHPxi2h/8
         t5g73nzeger91SE03rOBTUoIDSaNcelD1ZIWL+ofVdBC5ir2lNMkK0AQLlSAJdrzrbmU
         jZlqEdyTKwPp4lxJ6NP4s8VeeK5Fcznpk4BZ9KpQe44oGc0K8iYfY5JHLkZcYLGaeF6A
         33JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/xHrwBXHCYGGobA/XwgxAVUGJtHC2+MbSesHo+s9ndk=;
        b=GUqPjaPVvSRiMYb5qlnWmaBR9DRu3PlPGmDyGFv7DCV6OW69P2h2ca7uGNdCBq/bI2
         bFJOrm5hqBVSZbwskkXx2taqHrtPTdhaMTj0/dIFoWdMORg5l+qejynoCyyKMnK00QOE
         Litjznn/4eHU1zunVFEnlTB7h3ZzcaOkuJCMlL8rYt1yS1Z67LN84mWNqlUQDbrqSt2K
         p1JSMqg7/vZMZ2nY8MMfThQ7mUFwfGqc4X2QGeLDcqWtny26qFrjDiHVgUEs335jqZKq
         LFurhHEppaSnetk+dOzsQNhehLyKxf1l1wKjWpviI2fxwdjeb0CrwMdP83BKydiahyqA
         ITKg==
X-Gm-Message-State: AOAM531rz8ShImi+8ZGBTN/qV6kUEYIP6ux/NyY6zPziuBE6yRKLG138
        Dg4Rrd0K8SF7tpBQftDRIhE=
X-Google-Smtp-Source: ABdhPJy/X7D6Yb8pPW5Nzxx6E/zP1Gyg1U011yW8LRaUK0LKxi3+RX9DpDF0wczu1bJFus2fjiegjQ==
X-Received: by 2002:a17:906:1256:: with SMTP id u22mr43517915eja.317.1637594665476;
        Mon, 22 Nov 2021 07:24:25 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:25 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 9/9] net: dsa: qca8k: add support for mdb_add/del
Date:   Mon, 22 Nov 2021 16:23:48 +0100
Message-Id: <20211122152348.6634-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mdb add/del function. The ARL table is used to insert
the rule. The rule will be searched, deleted and reinserted with the
port mask updated. The function will check if the rule has to be updated
or insert directly with no deletion of the old rule.
If every port is removed from the port mask, the rule is removed.
The rule is set STATIC in the ARL table (aka it doesn't age) to not be
flushed by fast age function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 99 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 45e769b9166b..67742fbd8040 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -435,6 +435,81 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
+			    const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	ret = qca8k_fdb_read(priv, &fdb);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule exist. Delete first */
+	if (!fdb.aging) {
+		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+		if (ret)
+			goto exit;
+	}
+
+	/* Add port to fdb portmask */
+	fdb.port_mask |= port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+static int
+qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
+			 const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule doesn't exist. Why delete? */
+	if (!fdb.aging) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+	if (ret)
+		goto exit;
+
+	/* Only port in the rule is this port. Don't re insert */
+	if (fdb.port_mask == port_mask)
+		goto exit;
+
+	/* Remove port from port mask */
+	fdb.port_mask &= ~port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
 static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
@@ -1925,6 +2000,28 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int
+qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
+}
+
+static int
+qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
+}
+
 static int
 qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
@@ -2033,6 +2130,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
+	.port_mdb_add		= qca8k_port_mdb_add,
+	.port_mdb_del		= qca8k_port_mdb_del,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
-- 
2.32.0

