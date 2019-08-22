Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF9F9A0E7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392859AbfHVUNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:13:54 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37698 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392846AbfHVUNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so9177825qto.4
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HXsmDRD3xQE0AkS+M8DsxXVlBU9UC3kWE6H1KYP8l4E=;
        b=O6WAd/nPzMoRCucqlSUo5giv6ydVvQ14hc1YVHeGMGXzBU+o1tLROj9okOxRxhCiCW
         JCWC/0BcUevAYrOq9qmb2pGkhu2QBaMmH2Lo1FbWrh12bqEmUQGPKPKgiomSykhSAB+2
         XrpjU3JK9/A17iTM5pRfYDhOisoHSHifAo50unDfFwJvmXnnH/URf22zR5jp5AE6e0iX
         3Prgog4d9ViAaX7nXIzksIoKO0fDtsfJqeAltgRPTu2rYYu8/r896G23e559iZg7Wk3o
         sEtDOha//EQF8jrquWgPmB0bgr9L0HgcmF1Sp+NjppDCStlvZuBa+EaV0qoCugCSlaem
         7bIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXsmDRD3xQE0AkS+M8DsxXVlBU9UC3kWE6H1KYP8l4E=;
        b=I1CgxmjPVAlw5e2eMvF/fkOSHbIF4gI7kGgImtoAB/gBMwKUqG8yQOQXU6rAf0uR/q
         6ZeiWT1n9NLajb6l0ZVEAvylzhq682JGFIPT4Q18FfbkokX2+ldfSmi7AWMxyt36RSAT
         WNQDhgJffFtb9DK7hc49f2f4qdGA06VPfjJ55tJmItDJhAAdYXfTw4F+nhHGnHCJTq7M
         Ma1sPkD9ZR8QUyTVjfQerQzjb9oC6ROztkgkQMsyzGf/QaG+apVD2ekb91d5zuN5vo6+
         LBYfeDRCylN+0uqgpOFW2WTE5Y22blh2JCddRNYlFCc8tbvkUQA+JN8sRg1yjScV8oeV
         DiKw==
X-Gm-Message-State: APjAAAXuxKABx2cfEHJyTayoNrUZfWkhzeh+OcbEzK109TwZIkYZLWZo
        Marzm8tL5EFVDR54CWVgQZCVU88J
X-Google-Smtp-Source: APXvYqziiSbKgXOjef8ft8mXOWHZnNVGzs+/wBH7X6BcO2PAbbKd9dW5AsVNE6skdjValzEe5bVwfA==
X-Received: by 2002:ac8:41d6:: with SMTP id o22mr1536169qtm.248.1566504832548;
        Thu, 22 Aug 2019 13:13:52 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o200sm413567qke.66.2019.08.22.13.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:52 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: add slave VLAN helpers
Date:   Thu, 22 Aug 2019 16:13:20 -0400
Message-Id: <20190822201323.1292-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
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

