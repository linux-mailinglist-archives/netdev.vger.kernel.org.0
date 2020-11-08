Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215552AAB27
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgKHNWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgKHNUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:20:15 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CFFC0613D3;
        Sun,  8 Nov 2020 05:20:15 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cq7so5695143edb.4;
        Sun, 08 Nov 2020 05:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lpdz9hde6szrI40H2myatWiWZrz5F2eNJ3GGC/UNQXw=;
        b=rsSQheMVpiselxS+tPVy9yVz6qk9fLpF4I0AYg/Qp/54XXzvNT9Bse33Sgr/2oqIIg
         Wqtgbxwy7aZy1THr16HdBue5F7sTaHevsYljyDj0IkeH4vKSqDIn4YlazwvpliO0y71q
         j08GF0lPVujpjsj/Zfsb1pDh3vYKKBgCmmrwnQr67uX9XhPwoeLrTIY2ME8rA7iPDmL7
         cI9UhQP4UqbuuoBsph4wtB7ClOMJFvh8nDCzyAkj55rmNgkwyVKyyi8ENlCBQ3ZWO5oQ
         FVXOwlJpd4I46fqz2op5w+lBFQGyHERzn9cIudlY6cGtoq//bkYo66GfHHRLFJ/6pzz2
         D9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpdz9hde6szrI40H2myatWiWZrz5F2eNJ3GGC/UNQXw=;
        b=OeJqON30LmdoK0zspysZYVBC4vewfIDxOLnBtXsKz+g/A1Geik0Td0BmcZcOGXEAoi
         FrpINFsIoNfrUaPAjCpUM2NRqQWnUIJ0WIqGXX8aRz05fyvtk3l15IrAgvSE8jacHAIm
         q8b2O3Z0IUuuZl/67rMvMZKYzytr6/MhwKw+1Kh3PL44st7PO8uQtG/pYzR2ZWKK+AXQ
         gCuq6u74x4xOZE4kOGCWlqC/ntI4s3627knE/jNmoMDLGW90F2t0kbC5WAxnX+cYmYzE
         phD5BCHJqoOlKBzoa08h0g3bDH3XxRI1Z818x8F9KCiP6rs80JhGJ8V0vDC1qpp366ah
         pUyg==
X-Gm-Message-State: AOAM532cyLPP52ALSIvYzktjlCRjoh8/lCC8mt4NWoYgUWrkPPIFTOYy
        vCbfDEei9Y3hDwrt33OvS3Q=
X-Google-Smtp-Source: ABdhPJwM6EIsIRQemRI40yBUHDmanbtFBDwTFzjfFWw5eVpWWLfQ40JLfPVzPK62XwIljf+8CTKB8A==
X-Received: by 2002:aa7:d408:: with SMTP id z8mr10505109edq.166.1604841613697;
        Sun, 08 Nov 2020 05:20:13 -0800 (PST)
Received: from localhost.localdomain ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id og19sm5967094ejb.7.2020.11.08.05.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 05:20:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 2/3] net: dsa: move switchdev event implementation under the same switch/case statement
Date:   Sun,  8 Nov 2020 15:19:52 +0200
Message-Id: <20201108131953.2462644-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201108131953.2462644-1-olteanv@gmail.com>
References: <20201108131953.2462644-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
events even for interfaces where dsa_slave_dev_check returns false, so
we need that check inside the switch-case statement for SWITCHDEV_FDB_*.

This movement also avoids two useless allocation / free paths for
switchdev_work, which were difficult to avoid before, due to the code's
structure:
- on the untreated "default event" case.
- on the case where fdb_info->added_by_user is false.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 30db8230e30b..b34da39722c7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2130,50 +2130,45 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct dsa_port *dp;
 	int err;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET) {
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
-	}
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
-
-	dp = dsa_slave_to_port(dev);
-
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return NOTIFY_BAD;
-
-	INIT_WORK(&switchdev_work->work,
-		  dsa_slave_switchdev_event_work);
-	switchdev_work->ds = dp->ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
-
-	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = ptr;
 
-		if (!fdb_info->added_by_user) {
-			kfree(switchdev_work);
+		if (!dsa_slave_dev_check(dev))
+			return NOTIFY_DONE;
+
+		if (!fdb_info->added_by_user)
 			return NOTIFY_OK;
-		}
+
+		dp = dsa_slave_to_port(dev);
+
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
+
+		INIT_WORK(&switchdev_work->work,
+			  dsa_slave_switchdev_event_work);
+		switchdev_work->ds = dp->ds;
+		switchdev_work->port = dp->index;
+		switchdev_work->event = event;
 
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
 
 		dev_hold(dev);
+		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 
-	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
 }
 
-- 
2.25.1

