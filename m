Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8654617B20
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 11:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiKCKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 06:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiKCKyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 06:54:33 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1201D11149;
        Thu,  3 Nov 2022 03:54:31 -0700 (PDT)
X-UUID: b913a5e83cda489faf34184a5a20c9b4-20221103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=sfIykg/mNOJeqbyqBySUi21fd42j5gKT8WsS5aUZyns=;
        b=iAnw0oRueQNjHauEuLgut+vWpcOeW0vvoxnkHqz712Fqkpysq9RSZjCLvTt3eWrOnhUzikhTbaVNwAKYjTy0ilV6CnyVZyjdR9OAMKNRk3WdDYhfHzXV53+K1gsgDya2vxkzd4AeXBcIbUrf1qgeY03i50pGB8wcnFcSXzSLmtI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:928b5c8b-f32a-464b-a5cf-49e8ebfe7b8d,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.12,REQID:928b5c8b-f32a-464b-a5cf-49e8ebfe7b8d,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:62cd327,CLOUDID:7c2f55eb-84ac-4628-a416-bc50d5503da6,B
        ulkID:221103185429UYAVBFVI,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: b913a5e83cda489faf34184a5a20c9b4-20221103
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <zhaoping.shu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1500839941; Thu, 03 Nov 2022 18:54:29 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 3 Nov 2022 18:54:28 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 3 Nov 2022 18:54:26 +0800
From:   <zhaoping.shu@mediatek.com>
To:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <haijun.liu@mediatek.com>, <xiayu.zhang@mediatek.com>,
        <lambert.wang@mediatek.com>, HW He <hw.he@mediatek.com>,
        Zhaoping Shu <zhaoping.shu@mediatek.com>
Subject: [PATCH RESEND] net: wwan: mhi: fix memory leak in mhi_mbim_dellink
Date:   Thu, 3 Nov 2022 18:54:19 +0800
Message-ID: <20221103105419.159891-1-zhaoping.shu@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: HW He <hw.he@mediatek.com>

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch sets needs_free_netdev to true when registers
network device, which makes netdev subsystem call free_netdev()
automatically after unregister_netdevice().

Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
Signed-off-by: HW He <hw.he@mediatek.com>
Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 6872782e8dd8..ef70bb7c88ad 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -582,6 +582,7 @@ static void mhi_mbim_setup(struct net_device *ndev)
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = MHI_MAX_BUF_SZ - ndev->needed_headroom;
 	ndev->tx_queue_len = 1000;
+	ndev->needs_free_netdev = true;
 }
 
 static const struct wwan_ops mhi_mbim_wwan_ops = {
-- 
2.17.0

