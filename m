Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506426729F7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjARVI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjARVIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:08:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706AE58961;
        Wed, 18 Jan 2023 13:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076135; x=1705612135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vwtYbLrA2oTbDo1HOHwwRKLWlo8AMmLQ34Uv58yjfws=;
  b=MQV7F+wYXY5Zbe2dVTEv/jGjCpzSTJ1GMT6M4cY8DrqGe/A5vFTrZIm0
   hGnHHvGCmMBQckCwl2ezmCcIJ1eUIsxnQrAjk5Enm0wxeGcVOee6pL2J8
   a6cjYd6UwkNJZLNlQdEPD+h/oAur8WWxGaVf81Z+JsIWJMt89s33P66Kc
   JnShQsjeprHOPyLgOsr3xOryn/AEzvMNZgDkwxiS52IEwkgzXczc0hmrV
   80UOQjtYBft/CO9xmw36JVZ3XCJQKn70YE+G0Xulkr6ztp7+krPEDzufR
   N2ajZE2B/hd+zjTcKR36TUk/gLPawr/qVEgZ7SDHcI01zJOUEPnqy2HPb
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197370502"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:08:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:08:48 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:08:44 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 1/6] net: dcb: modify dcb_app_add to take list_head ptr as parameter
Date:   Wed, 18 Jan 2023 22:08:25 +0100
Message-ID: <20230118210830.2287069-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118210830.2287069-1-daniel.machon@microchip.com>
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to DCB rewrite. Modify dcb_app_add to take new struct
list_head * as parameter, to make the used list configurable. This is
done to allow reusing the function for adding rewrite entries to the
rewrite table, which is introduced in a later patch.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 net/dcb/dcbnl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index f9949e051f49..a76bdf6f0198 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1955,7 +1955,8 @@ static struct dcb_app_type *dcb_app_lookup(const struct dcb_app *app,
 	return NULL;
 }
 
-static int dcb_app_add(const struct dcb_app *app, int ifindex)
+static int dcb_app_add(struct list_head *list, const struct dcb_app *app,
+		       int ifindex)
 {
 	struct dcb_app_type *entry;
 
@@ -1965,7 +1966,7 @@ static int dcb_app_add(const struct dcb_app *app, int ifindex)
 
 	memcpy(&entry->app, app, sizeof(*app));
 	entry->ifindex = ifindex;
-	list_add(&entry->list, &dcb_app_list);
+	list_add(&entry->list, list);
 
 	return 0;
 }
@@ -2028,7 +2029,7 @@ int dcb_setapp(struct net_device *dev, struct dcb_app *new)
 	}
 	/* App type does not exist add new application type */
 	if (new->priority)
-		err = dcb_app_add(new, dev->ifindex);
+		err = dcb_app_add(&dcb_app_list, new, dev->ifindex);
 out:
 	spin_unlock_bh(&dcb_lock);
 	if (!err)
@@ -2088,7 +2089,7 @@ int dcb_ieee_setapp(struct net_device *dev, struct dcb_app *new)
 		goto out;
 	}
 
-	err = dcb_app_add(new, dev->ifindex);
+	err = dcb_app_add(&dcb_app_list, new, dev->ifindex);
 out:
 	spin_unlock_bh(&dcb_lock);
 	if (!err)
-- 
2.34.1

