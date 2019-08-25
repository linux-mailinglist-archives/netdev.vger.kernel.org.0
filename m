Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B715E9C50F
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfHYR0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:26:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41570 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfHYR0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:26:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id i4so15805991qtj.8
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HXsmDRD3xQE0AkS+M8DsxXVlBU9UC3kWE6H1KYP8l4E=;
        b=qE1I/QhnkLs73WfjGvQV6CSTk7ujc6+MAoLzNVZwC4CtKl0M5v0ESYoGGJvZbGUHfX
         Y94LAHF+UEuvhU3WnlwEc1zlS3pUwT8UE17q0yIKHWYASgIs8jTRODLq1D/Xp6W+WSMf
         oa2CD/13qIcCL0kLXwKEzCLRg8aYC8xF11TLsBpX1yAq6GjV6hAfl9mTDBgumTI1qQ9W
         fFAC6hDOd1FWx3OSv/Rp6RH0JQqldpFkiPxHZovpjE8/OsM90Qi5e6iLgzWH46qLvJN1
         cBrftrJy07c4NY4g8e3LV8Nbo068dQB8idV1s144X3lBLmRUVCkVvYvdtvsbBP0AEScr
         +nJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXsmDRD3xQE0AkS+M8DsxXVlBU9UC3kWE6H1KYP8l4E=;
        b=ce8R+V/jPmMuhHb7ASWke4tQAotRJuPLaIhrA5+FuMD653Nw1pfK6JyNs/9mM/x7mj
         PDOZ04uvE67NENc7DdVZTB9nWu8SGzNfQS1o/Xrf2LQPCxST3abtYZwwcFPdObC83Xta
         WwE1SC6Zh65uyKCOSSzv9vhkqs+LEoJv+Tg7wmRGm+pXJ6Xp1SQz5XkiR+9K/qZhrABj
         fP1hCbELWrUGKGDjHRzQQqmmRhM4Yg/h9HjBaJA6yfVdEKlttyLucF8z1kfPclD5J41H
         mVhA85CwvwnlqgUWjC4Ys/exN82Eymdrq+CbW1bd6V7yCEBlfBACteF5VE3VrKwU/zxh
         nyRQ==
X-Gm-Message-State: APjAAAVjZqHkf4XIAXfr5fBKtFg9asabmpx060Y6MNE4ddtxVRm7LEpU
        bv2AxbdMFMgT10ksCZpwmSqKdfLt
X-Google-Smtp-Source: APXvYqyMMwIjY0ukfAo1CLKIQNpl8d295eb2grhgi58D9JhBacJd7cAnp0pkKWA5YzpEJU40OXuSnQ==
X-Received: by 2002:a0c:e1cd:: with SMTP id v13mr12291817qvl.245.1566753959627;
        Sun, 25 Aug 2019 10:25:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y1sm5379422qti.49.2019.08.25.10.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:25:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 3/6] net: dsa: add slave VLAN helpers
Date:   Sun, 25 Aug 2019 13:25:17 -0400
Message-Id: <20190825172520.22798-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dsa_slave_vlan_add and dsa_slave_vlan_del helpers to handle
SWITCHDEV_OBJ_ID_PORT_VLAN switchdev objects. Also copy the
switchdev_obj_port_vlan structure on add since we will modify it in
future patches.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9d61d9dbf001..8f5126c41282 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -312,6 +312,26 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	return ret;
 }
 
+static int dsa_slave_vlan_add(struct net_device *dev,
+			      const struct switchdev_obj *obj,
+			      struct switchdev_trans *trans)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan;
+	int err;
+
+	if (obj->orig_dev != dev)
+		return -EOPNOTSUPP;
+
+	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	err = dsa_port_vlan_add(dp, &vlan, trans);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
 				  struct switchdev_trans *trans,
@@ -339,10 +359,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 				       trans);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (obj->orig_dev != dev)
-			return -EOPNOTSUPP;
-		err = dsa_port_vlan_add(dp, SWITCHDEV_OBJ_PORT_VLAN(obj),
-					trans);
+		err = dsa_slave_vlan_add(dev, obj, trans);
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -352,6 +369,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	return err;
 }
 
+static int dsa_slave_vlan_del(struct net_device *dev,
+			      const struct switchdev_obj *obj)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	if (obj->orig_dev != dev)
+		return -EOPNOTSUPP;
+
+	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
+}
+
 static int dsa_slave_port_obj_del(struct net_device *dev,
 				  const struct switchdev_obj *obj)
 {
@@ -371,9 +399,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (obj->orig_dev != dev)
-			return -EOPNOTSUPP;
-		err = dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
+		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.23.0

