Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA33A23BE93
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgHDRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:07:01 -0400
Received: from mxwww.masterlogin.de ([95.129.51.220]:46876 "EHLO
        mxwww.masterlogin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729853AbgHDRFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 13:05:46 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2020 13:05:45 EDT
Received: from mxout4.routing.net (unknown [192.168.10.112])
        by forward.mxwww.masterlogin.de (Postfix) with ESMTPS id AD31796135;
        Tue,  4 Aug 2020 16:56:10 +0000 (UTC)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout4.routing.net (Postfix) with ESMTP id 65C451014A6;
        Tue,  4 Aug 2020 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1596560170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sO6tybaMOJ1Y/9jRMHEuMbPOV8G3l1zST2AlvdQbQc4=;
        b=G5QrEXusd7O180Uc4HbCX88/NhgIAjUvUG/poFT8KiVuY+bL5KLI7P/3YGHEXMXVv5TjT3
        qhJxbMsqIrF5w4ESj438PffNefB0XFfEYy7yyKexhi36jJiz2qIRjPqK+POzfHiQ3Ie6AK
        op1YFQPXAET5ZGv7kQUNBgD8QrCh2YM=
Received: from localhost.localdomain (fttx-pool-217.61.144.119.bambit.de [217.61.144.119])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 5B5443601C7;
        Tue,  4 Aug 2020 16:56:09 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Landen Chao <landen.chao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4] net: ethernet: mtk_eth_soc: fix MTU warnings
Date:   Tue,  4 Aug 2020 18:55:50 +0200
Message-Id: <20200804165555.75159-3-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200804165555.75159-1-linux@fw-web.de>
References: <20200804165555.75159-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>

in recent kernel versions there are warnings about incorrect MTU size
like these:

eth0: mtu greater than device maximum
mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
Signed-off-by: Landen Chao <landen.chao@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v3->v4
  - fix commit-message (hyphernations,capitalisation) as suggested by Russell
  - add Signed-off-by Landen
  - dropped wrong signed-off from rene (because previous v1/2 was from him)
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 85735d32ecb0..a1c45b39a230 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2891,6 +2891,8 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->irq = eth->irq[0];
 	eth->netdev[id]->dev.of_node = np;
 
+	eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+
 	return 0;
 
 free_netdev:
-- 
2.25.1

