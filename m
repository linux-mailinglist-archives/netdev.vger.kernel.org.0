Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9738562EE8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfGIDbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37043 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfGIDbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:31:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so7689569qto.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3d1OuAqYK/uy2YupoXsEWAjAcdAxhZe9vgreHB9qCk=;
        b=F45UW6TgrtuDYK55o5mctXq8ds3BZXe2IXy03tNgd+yMHtOk0GYeZ7OgWx0c6ezWm2
         5oWSpF4AsjTlB203KJQuGfcWIgcQgZl2TdeHG8vSjRHKZjYVi380JfWPKV9RakjmPT67
         sTnEb0Huvqxf3ts8DYj3bEl1gsGeJMWyMPqriG5ZYLmODmBAKH+inFn9iONUvahPFO7g
         UBQiURM5q2hdmYG/GEeWWWunGacQ4f/P3MDObV+EOps9IDb5wyD3KVeEqeq6l/3kpRXu
         tHl/5Buvdvla0OKKXBw2Acpv20Ppu6pHOOeHLCvvzBgubxtOVAHQsOgX6tkgHEW3Vbw7
         UKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3d1OuAqYK/uy2YupoXsEWAjAcdAxhZe9vgreHB9qCk=;
        b=ttrrXt6tyufE0KyyVMO/iUQ86S8H0dr+ihOY82OwyNh+3ovdrsCDKxt+ZjGXD5JpHF
         YPf1Q83S7MoWFOhFBV1YP2I9zE7R7V5mXy6Kdf7Gppt356vpHXZgZb6GK1qtuY52+ZCJ
         wldtkmfhxW9MjXYmBo0cBSXY40AXxPCvQrswfWypCABnBlbD0REPrp0aieqIjYGY2mnB
         cln51DwpWRAHBIsQ4kbQzBVuP8B0zogKDQZjnnVQPkQ58LXVqDP6yFyMqOLzODzjU1tn
         CZdIdWVWaVN9lXjRPtoh4cso0REJztnNNy+s+ufsop6yKN8bFIYIzlK6hhLK8Zsp8PDb
         OoZg==
X-Gm-Message-State: APjAAAVQnTFalqjp0/F9GU0gXQCe7TMHDDOOwqkytZYmmHbcZtStUXwO
        MKV5oCp+nsOTyYjNGFkY8ZzikS9PbP0=
X-Google-Smtp-Source: APXvYqwgl0KW0gG/vYFlFppOuMf0KT9h4iqNh9X3vA7HG2aGO/VIgjLsI9NhnhGMlpEMr6c18+iS2Q==
X-Received: by 2002:ad4:4562:: with SMTP id o2mr16666574qvu.116.1562643096572;
        Mon, 08 Jul 2019 20:31:36 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m19sm8396519qkk.29.2019.07.08.20.31.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 20:31:35 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, idosch@mellanox.com,
        andrew@lunn.ch, davem@davemloft.net,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: add support for BRIDGE_MROUTER attribute
Date:   Mon,  8 Jul 2019 23:31:13 -0400
Message-Id: <20190709033113.8837-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for enabling or disabling the flooding of
unknown multicast traffic on the CPU ports, depending on the value
of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute.

The current behavior is kept unchanged but a user can now prevent
the CPU conduit to be flooded with a lot of unregistered traffic that
the network stack needs to filter in software with e.g.:

    echo 0 > /sys/class/net/br0/multicast_router

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 12 ++++++++++++
 net/dsa/slave.c    |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a4853c22c2ff..d240c191392f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -163,6 +163,8 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			      struct switchdev_trans *trans);
 int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			  struct switchdev_trans *trans);
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
+		     struct switchdev_trans *trans);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct switchdev_trans *trans);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d2b65e8dc60c..f071acf2842b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -261,6 +261,18 @@ int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 	return err;
 }
 
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
+		     struct switchdev_trans *trans)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return ds->ops->port_egress_floods ? 0 : -EOPNOTSUPP;
+
+	return ds->ops->port_egress_floods(ds, port, true, mrouter);
+}
+
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index db58e748557d..247f3deed593 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -302,6 +302,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, trans);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
+		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, trans);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.22.0

