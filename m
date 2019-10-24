Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF9DE3C45
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437006AbfJXTpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:45:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55013 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407590AbfJXTpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:45:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id g7so4110383wmk.4
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h4V97ZMmFwGmmA423IEXGZEdhm0T/YIb74sFVdI7yF0=;
        b=fJPXMhb9SLccgp5rbYLAp93c354uJ1lhNt2P94jE1Mri7gDOXQreAyTQyicuMQ4hU7
         ZJsHofo7zZy9a3/njK0CmXz1W0yGVnq3zv386EAeC5DCzpCA3aZL94SQxSsrFafJkoMs
         Ly5SCuZvtyFtLyd+1wEHIRyXorgIsWD6tlobwtT37LsYZOL4KdhkTwA+5BINps4Q8Tlm
         kCecka3+XIF36LGOxYZqjMReGuA2B6y/FnIqqYSE4BIK67qXyjHoC3pmANFuURl5b53q
         VK4T1ZF9ljGdx3s/uubgGMfYicO//xxNbHN0RLr+bSxD3ygt6IjhAOEaA0yIhQ7/QqUk
         ViXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h4V97ZMmFwGmmA423IEXGZEdhm0T/YIb74sFVdI7yF0=;
        b=lm+VIMYpLSSAFRDGbdBEc3+5HL8cOQnndX8fRosO7lnVlPSMN6UB6un/xOFWgop8r9
         ixupEqpmOoCKIGZkBTnppmI9ps83O4zEIuHK14mgsWDixf49MZV+JhnJFOJj6bWDmKVV
         CW85utxSj2oHQpJ+Cp/1ckReIbcUcL0sLDo6W68z5wcxRkFReATcQJJ8t/ygBbeRzKFv
         lwE0S5OwPEr40K9wmk28MQ35LSFfmEDs6XMVlGw7G4lqo5YI4Erpx5a9CE7S4MYwK3xd
         yuLifsrKzivkZLN1Vfvv9DDC7jby/pf9v/wHO29euShk6wPzB61v7KHmveU1++kj63Bh
         BlsQ==
X-Gm-Message-State: APjAAAVA0ZwWlWc0CDcGRLAhUo/uwBfHqEqmOJNAozgMcM49u+7urx3r
        DOLokgoKU47NoxCQs3AOnHbFooHW
X-Google-Smtp-Source: APXvYqz/DDIDBjvF8xTIcR++qze1wKqQTa3GZgYB4wIPbTjDoemut/benqUxCMGgWdOVjoU6nOcvzQ==
X-Received: by 2002:a1c:3284:: with SMTP id y126mr49962wmy.164.1571946317480;
        Thu, 24 Oct 2019 12:45:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 37sm39273250wrc.96.2019.10.24.12.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 12:45:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/2] net: dsa: b53: Add support for MDB
Date:   Thu, 24 Oct 2019 12:45:07 -0700
Message-Id: <20191024194508.32603-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024194508.32603-1-f.fainelli@gmail.com>
References: <20191024194508.32603-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting IGMP snooping with or without the use of
a bridge, add support within b53_common.c to program the ARL entries for
multicast operations. The key difference is that a multicast ARL entry
is comprised of a bitmask of enabled ports, instead of a port number.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 62 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/b53/b53_priv.h   |  8 ++++-
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index baadf622ac55..36828f210030 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1503,11 +1503,25 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		idx = 1;
 	}
 
-	memset(&ent, 0, sizeof(ent));
-	ent.port = port;
+	/* For multicast address, the port is a bitmask and the validity
+	 * is determined by having at least one port being still active
+	 */
+	if (!is_multicast_ether_addr(addr)) {
+		ent.port = port;
+		ent.is_valid = is_valid;
+	} else {
+		if (is_valid)
+			ent.port |= BIT(port);
+		else
+			ent.port &= ~BIT(port);
+
+		ent.is_valid = !!(ent.port);
+	}
+
 	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
+	ent.is_age = false;
 	memcpy(ent.mac, addr, ETH_ALEN);
 	b53_arl_from_entry(&mac_vid, &fwd_entry, &ent);
 
@@ -1626,6 +1640,47 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
+int b53_mdb_prepare(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct b53_device *priv = ds->priv;
+
+	/* 5325 and 5365 require some more massaging, but could
+	 * be supported eventually
+	 */
+	if (is5325(priv) || is5365(priv))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+EXPORT_SYMBOL(b53_mdb_prepare);
+
+void b53_mdb_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_mdb *mdb)
+{
+	struct b53_device *priv = ds->priv;
+	int ret;
+
+	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
+	if (ret)
+		dev_err(ds->dev, "failed to add MDB entry\n");
+}
+EXPORT_SYMBOL(b53_mdb_add);
+
+int b53_mdb_del(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb)
+{
+	struct b53_device *priv = ds->priv;
+	int ret;
+
+	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, false);
+	if (ret)
+		dev_err(ds->dev, "failed to delete MDB entry\n");
+
+	return ret;
+}
+EXPORT_SYMBOL(b53_mdb_del);
+
 int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct b53_device *dev = ds->priv;
@@ -1994,6 +2049,9 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_fdb_del		= b53_fdb_del,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
+	.port_mdb_prepare	= b53_mdb_prepare,
+	.port_mdb_add		= b53_mdb_add,
+	.port_mdb_del		= b53_mdb_del,
 };
 
 struct b53_chip_data {
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a7dd8acc281b..1877acf05081 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -250,7 +250,7 @@ b53_build_op(write48, u64);
 b53_build_op(write64, u64);
 
 struct b53_arl_entry {
-	u8 port;
+	u16 port;
 	u8 mac[ETH_ALEN];
 	u16 vid;
 	u8 is_valid:1;
@@ -351,6 +351,12 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
+int b53_mdb_prepare(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_mdb *mdb);
+void b53_mdb_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_mdb *mdb);
+int b53_mdb_del(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb);
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port);
-- 
2.17.1

