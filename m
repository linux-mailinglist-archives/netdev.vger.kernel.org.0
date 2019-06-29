Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1334E5AADF
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfF2MYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 08:24:35 -0400
Received: from mx.0dd.nl ([5.2.79.48]:50808 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfF2MYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 08:24:35 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id E3A885FE8C;
        Sat, 29 Jun 2019 14:24:32 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="navb87/B";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 9732F1CE6915;
        Sat, 29 Jun 2019 14:24:32 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 9732F1CE6915
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561811072;
        bh=S+aJCigz6fwF72k/RqnynZOytfAg53dL/P7AVyy/NFk=;
        h=From:To:Cc:Subject:Date:From;
        b=navb87/BGORIBmdir2smL2aIK21EEZq2HP+PltawpWQYfmzKTjVx+3QYR67t7AhRX
         L7UDL5GxjJt/Id8r6I6XZZ7rqhVh/KtetRwoi3HNDedY6/TeydYoZHgFcVew8CUOzh
         bWNsobgeyJ6htLWRdiQ1DpEJZX2VLrl8sOkNUTi6iIAzyJ6sEsWVkF+F6CI08eJ/1G
         IPKKdGoPV3wurvB4l4/UZG0x9/7RHUoMqw4dsYVSOAOJPC+LSLo3QWxBv93lg3uFXK
         97R3GO41An50a3+Z8CD1065fnJjMAr/Gvf8aFWyuKmAnc6/LdVyzrCwWmtkOFDSLvH
         gM+XEOYFWBMtw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH] net: ethernet: mediatek: Fix overlapping capability bits.
Date:   Sat, 29 Jun 2019 14:24:19 +0200
Message-Id: <20190629122419.19026-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both MTK_TRGMII_MT7621_CLK and MTK_PATH_BIT are defined as bit 10.

This causes issues on non-MT7621 devices which has the
MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) capability set.
The wrong TRGMII setup code is executed.

Moving the MTK_PATH_BIT to bit 11 fixes the issue.

Fixes: 8efaa653a8a5 ("net: ethernet: mediatek: Add MT7621 TRGMII mode
support")
Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 876ce6798709..2cb8a915731c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -626,7 +626,7 @@ enum mtk_eth_path {
 #define MTK_TRGMII_MT7621_CLK		BIT(10)
 
 /* Supported path present on SoCs */
-#define MTK_PATH_BIT(x)         BIT((x) + 10)
+#define MTK_PATH_BIT(x)         BIT((x) + 11)
 
 #define MTK_GMAC1_RGMII \
 	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) | MTK_RGMII)
-- 
2.20.1

