Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C84171E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436592AbfFKVsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38695 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436583AbfFKVsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so14323743qtl.5;
        Tue, 11 Jun 2019 14:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RBVgvFzzSTm72lnZLapEOcWtFT+j5+sMeOCdH7fyGU4=;
        b=fis3hSrdsn8VVdjKnam7hSZs13ZUL6ht9pAxYn0pEGm7nEqFhK1EpOZOmd/fUblXCX
         YEBE3UKwbVU4mZa4GsTx1uNgoA/x121cTJx2l7HDH7lJddvoByQ5KZ0EfLkMr+smfPm/
         Q8sZr3k67CNm073/qnxdocmVllNXGY+62Jbq8w/uxKGh2YOehtZLolmz13vT2gCvMAqd
         Hdkm8xhpklpGZWiW8ouFruE8VWw5vYPgcRAYXW5yMi+U15Ju178z/1+DRGOMPvC8i/RI
         RZDZYIlVlekYxBDW5seEyMOVhmwUYnOoxDH1r5uY9RatwH0UiVqom0NGpnAjB864FTJp
         LJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBVgvFzzSTm72lnZLapEOcWtFT+j5+sMeOCdH7fyGU4=;
        b=ZIXjll8V+JYuxwuXNRI3jYBjFSAuoX2KqAfboIbmj1mebIyFsC3xR2ms7SntVYw+F6
         mSJNjW4U/LtqDSLg0G1kNmSRlHoSRhBRf3L+iepiNewSrCVy0d0DP0d2YhfoUV/znPZ/
         trPNhxkhigrX5gdbbUGVIx/wyYindVaMSMvjfazIx42QqB7A1HsLBPrgklEB75a4c07b
         Xzi4A7m03oQYUFqfxsr15rYgG6ta2p2rmP4/hlp6R1c8ZzUudHUyX6boJnc2M0mcxPpc
         lbYUPJfrYyzvzVRcR/KjBQtr4VV4Az2fbTVyc8p3n7UygQawyBW6645UBOom4KKrK/+i
         nuuw==
X-Gm-Message-State: APjAAAUxwgNuMedzq+lM7JnS0TX1P9pAYDIA3vUTZujaKTxHAle4NYKy
        lOVx8yc27IDbPJI7oIdTiOiM/TI71Cc=
X-Google-Smtp-Source: APXvYqxbxxYh0r8jHcYbBsaPmgDXAaRX6lQfj0pyzT4LPViY4bw+HNG+pIBadPt/w8kE9RwlLhQMlg==
X-Received: by 2002:ac8:264a:: with SMTP id v10mr34839035qtv.255.1560289697650;
        Tue, 11 Jun 2019 14:48:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n124sm7253217qkf.31.2019.06.11.14.48.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:17 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next 4/4] net: dsa: use switchdev handle helpers
Date:   Tue, 11 Jun 2019 17:47:47 -0400
Message-Id: <20190611214747.22285-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611214747.22285-1-vivien.didelot@gmail.com>
References: <20190611214747.22285-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of the dsa_slave_switchdev_port_{attr_set,obj}_event functions
in favor of the switchdev_handle_port_{attr_set,obj_add,obj_del}
helpers which recurse into the lower devices of the target interface.

This has the benefit of being aware of the operations made on the
bridge device itself, where orig_dev is the bridge, and dev is the
slave. This can be used later to configure bridge-wide attributes on
the hardware switches.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c | 77 +++++++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 44 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index cb436a05c9a8..915dd43873f9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -283,6 +283,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
+	if (attr->orig_dev != dev)
+		return -EOPNOTSUPP;
+
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		ret = dsa_port_set_state(dp, attr->u.stp_state, trans);
@@ -311,11 +314,15 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
-				  struct switchdev_trans *trans)
+				  struct switchdev_trans *trans,
+				  struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (obj->orig_dev != dev)
+		return -EOPNOTSUPP;
+
 	/* For the prepare phase, ensure the full set of changes is feasable in
 	 * one go in order to signal a failure properly. If an operation is not
 	 * supported, return -EOPNOTSUPP.
@@ -350,6 +357,9 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (obj->orig_dev != dev)
+		return -EOPNOTSUPP;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
@@ -1479,19 +1489,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int
-dsa_slave_switchdev_port_attr_set_event(struct net_device *netdev,
-		struct switchdev_notifier_port_attr_info *port_attr_info)
-{
-	int err;
-
-	err = dsa_slave_port_attr_set(netdev, port_attr_info->attr,
-				      port_attr_info->trans);
-
-	port_attr_info->handled = true;
-	return notifier_from_errno(err);
-}
-
 struct dsa_switchdev_event_work {
 	struct work_struct work;
 	struct switchdev_notifier_fdb_info fdb_info;
@@ -1566,13 +1563,18 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct dsa_switchdev_event_work *switchdev_work;
+	int err;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     dsa_slave_dev_check,
+						     dsa_slave_port_attr_set);
+		return notifier_from_errno(err);
+	}
 
 	if (!dsa_slave_dev_check(dev))
 		return NOTIFY_DONE;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET)
-		return dsa_slave_switchdev_port_attr_set_event(dev, ptr);
-
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return NOTIFY_BAD;
@@ -1602,41 +1604,28 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	return NOTIFY_BAD;
 }
 
-static int
-dsa_slave_switchdev_port_obj_event(unsigned long event,
-			struct net_device *netdev,
-			struct switchdev_notifier_port_obj_info *port_obj_info)
-{
-	int err = -EOPNOTSUPP;
-
-	switch (event) {
-	case SWITCHDEV_PORT_OBJ_ADD:
-		err = dsa_slave_port_obj_add(netdev, port_obj_info->obj,
-					     port_obj_info->trans);
-		break;
-	case SWITCHDEV_PORT_OBJ_DEL:
-		err = dsa_slave_port_obj_del(netdev, port_obj_info->obj);
-		break;
-	}
-
-	port_obj_info->handled = true;
-	return notifier_from_errno(err);
-}
-
 static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 					      unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
+	int err;
 
 	switch (event) {
-	case SWITCHDEV_PORT_OBJ_ADD: /* fall through */
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    dsa_slave_dev_check,
+						    dsa_slave_port_obj_add);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_OBJ_DEL:
-		return dsa_slave_switchdev_port_obj_event(event, dev, ptr);
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    dsa_slave_dev_check,
+						    dsa_slave_port_obj_del);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_ATTR_SET:
-		return dsa_slave_switchdev_port_attr_set_event(dev, ptr);
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     dsa_slave_dev_check,
+						     dsa_slave_port_attr_set);
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
-- 
2.21.0

