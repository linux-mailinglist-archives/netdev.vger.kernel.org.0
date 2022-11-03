Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83F5617AF8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 11:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiKCKkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 06:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKCKkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 06:40:14 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851D631A;
        Thu,  3 Nov 2022 03:40:07 -0700 (PDT)
X-UUID: f306009528b84759af3b0268b56d6354-20221103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=RS4R6dJj/EnLDYgD6nRRJQ0+JPQFSpc5AmVh0Qi2JWs=;
        b=Jet/jWYCuGLK0Y03QTfII5MSPTpBYQSTa4cty40yX+TpwkM3C7l9h+Dnvt3xUUjyWCtptSyjmsFqEAu0lnqjlPPGbXOdTgUzywttaBSMooT9p9boshXhW8FK1Y8ET+kgB/4pabQB2bxYBmjOrVZxew+fvj4Z9FUCpFx6dVDz0yg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:849f2281-cbf0-4eee-9874-c61debd7ed68,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.12,REQID:849f2281-cbf0-4eee-9874-c61debd7ed68,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:62cd327,CLOUDID:56a690f3-a19e-4b45-8bfe-6a73c93611e9,B
        ulkID:221103184005OG67EX2E,BulkQuantity:1,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: f306009528b84759af3b0268b56d6354-20221103
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <zhaoping.shu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1742624575; Thu, 03 Nov 2022 18:40:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 3 Nov 2022 18:40:03 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 3 Nov 2022 18:40:01 +0800
From:   <zhaoping.shu@mediatek.com>
To:     <m.chetan.kumar@intel.com>, <linuxwwan@intel.com>,
        <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <srv_heupstream@mediatek.com>, <haijun.liu@mediatek.com>,
        <xiayu.zhang@mediatek.com>, <lambert.wang@mediatek.com>,
        HW He <hw.he@mediatek.com>,
        Zhaoping Shu <zhaoping.shu@mediatek.com>
Subject: [PATCH RESEND] net: wwan: iosm: fix memory leak in ipc_wwan_dellink
Date:   Thu, 3 Nov 2022 18:40:00 +0800
Message-ID: <20221103104000.140643-1-zhaoping.shu@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: HW He <hw.he@mediatek.com>

IOSM driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch sets needs_free_netdev to true when registers
network device, which makes netdev subsystem call free_netdev()
automatically after unregister_netdevice().

Fixes: 2a54f2c77934 ("net: iosm: net driver")
Signed-off-by: HW He <hw.he@mediatek.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 2f1f8b5d5b59..0108d8d01ff2 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -168,6 +168,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->max_mtu = ETH_MAX_MTU;
 
 	iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	iosm_dev->needs_free_netdev = true;
 
 	iosm_dev->netdev_ops = &ipc_inm_ops;
 }
-- 
2.17.0

