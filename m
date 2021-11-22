Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF824587A3
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhKVBHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhKVBHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:14 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED483C061574;
        Sun, 21 Nov 2021 17:04:08 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y13so69265239edd.13;
        Sun, 21 Nov 2021 17:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bj/ZGzTlOIjbh8J+ewvdyxGtHN1892UFRCLl4rttRs=;
        b=MhkYzxn5NXdyqL2YXwn9LP+wXA85HrkazmKQHiuvew0dWhOb53rC1y1la41S6sZ5A6
         5ezxUnsIjeOhKerALsQjm4+JaFAS+ORwAqzzsyNMrL7JyPtvsHYXEbdSjNo9W9/teiM3
         Oga7WzPla6yUOpgjvURRDV/g+1y/AffpkEn7Tt+Iu+Je4MmWwkUMrJegWUURTdDqNevB
         E0T4DTzbq+qr3pmZb46IhNJTucqCI/AYRSfbCZWlcf0Ett9KW3PIXi8JuECrVOYkbIHC
         6mk8vZGdQvD6X0Ha3UDgxG5qHb0TZwk+L7QBWPwOSlulDIJsB5SQ2sfkW8fgOp3dB8RV
         psKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bj/ZGzTlOIjbh8J+ewvdyxGtHN1892UFRCLl4rttRs=;
        b=F3jyhFEy9H/8J+UIEcxvHvh8E0+n7QZ7ta0QTfmo1HrupE9L+rg3HVkW6ObgqFCUjq
         WwdAtnh7CPh2jXJeyNqSvD3Dg5qGGv0OKvjGfTiF8oIQrITAMpZPpWLlMNl2qhUW/uku
         7HzLgXMm5dnJ1zV/1Mm2s7jCGD52H59vBibtZPouShxgb9PJcHE+Lef2ZllsRtlcakp6
         Df3pik4psPFW9xXoPKAG6LYwaImo9a8OZo+UH0mmLJjG/5yruoTRBkhwjCK+uoYod2km
         9OfeivX0FOWPI14uS7b6rPwRbQBHQcc/HUhz45kSZTilkLIwHMRlHvgumdpEmODsKAY7
         fjwg==
X-Gm-Message-State: AOAM533BPAtttBt1UKe85la3QXUhNlxQxS2T8lbvu73R2MztPkk4UZ4V
        c+gXtS9Ib+/UssP9cd9C58s=
X-Google-Smtp-Source: ABdhPJzAzuyEqsR5/PXbhP0ncjNxBOe6y9VMUDCC/x/0Msh/e2vANgZlx//lvz0kvgVbHXEN0y4Aug==
X-Received: by 2002:a17:907:60ca:: with SMTP id hv10mr35011562ejc.500.1637543047389;
        Sun, 21 Nov 2021 17:04:07 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 9/9] net: dsa: qca8k: add support for mdb_add/del
Date:   Mon, 22 Nov 2021 02:03:13 +0100
Message-Id: <20211122010313.24944-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
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
---
 drivers/net/dsa/qca8k.c | 97 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 21a7f1ed7a5c..e37528c8dbf2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -417,6 +417,79 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask, const u8 *mac, u16 vid)
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
+qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask, const u8 *mac, u16 vid)
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
@@ -1915,6 +1988,28 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
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
@@ -2023,6 +2118,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
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

