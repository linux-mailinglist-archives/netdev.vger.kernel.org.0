Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42F166C320
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbjAPPA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjAPPAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:00:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74406222CC;
        Mon, 16 Jan 2023 06:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673880630; x=1705416630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vwtYbLrA2oTbDo1HOHwwRKLWlo8AMmLQ34Uv58yjfws=;
  b=YlLXbD/xH8kgQTkLRr+JqKIq4TuKZXlbZIHxgkTu5vCDdLk4dwTsABmQ
   AeuYF6TBiiy6T0I1KMKlz4xfCjKe+GGFTLIr7xSGeJF6hGmvdJ3hElLEF
   4XNPoK6pLIEzpHwSedvvoLSCcK1flJQ4APf8vwFUWkIggnIOrHLU72K8y
   LSPmKsDYmjApKJHoWfcsexl7ta3hAP7GbdSHuQrT0op44Eu9yy+vXdNxH
   hn/mDQg731eiNGebP//OejsTY+JjXE9gcm2hF+QQk98gFaqh4gW60BePD
   D/yfqeL3k7gSFIL3tRPGtUB6INH746et/jMqkI32RQWqq8DhKDM1wqzW0
   A==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="132549087"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 07:49:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 07:49:09 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 07:49:05 -0700
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
Subject: [PATCH net-next v2 1/6] net: dcb: modify dcb_app_add to take list_head ptr as parameter
Date:   Mon, 16 Jan 2023 15:48:48 +0100
Message-ID: <20230116144853.2446315-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116144853.2446315-1-daniel.machon@microchip.com>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
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

