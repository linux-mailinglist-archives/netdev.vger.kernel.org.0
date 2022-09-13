Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B935B6DE8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiIMNDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiIMND2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEFB48C92
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 06:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14D5461471
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1181C433D6;
        Tue, 13 Sep 2022 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663074206;
        bh=KfEDdDNmY8wTpANTF3pfkBvGM7Eiena7UYvAwq7O8bk=;
        h=From:To:Cc:Subject:Date:From;
        b=P596gJNMzVE+38u4A1E2yvZG32+rcl2CscYGEfgF2DbnoZAY5Z7jsdJXy+tnUjd6D
         sbKqGTuVVsKRjDLAZ8ggjU2yyQz1P1Goe/V25rmABqvmLlf/W9weV36vZKMlAcjCAl
         T0ug4HoCBCeoUzFeSkjd7SjXYdTUapAxa0dOsiEyh6cNWtlKpD2dw+54gLVTLsjyB8
         AIPbvWECYAB/BOvG61me6S89t11Ck9Kbo2lZ7xAQktwoylk6sSZB23W/KXQbns3hEF
         PA5QeVn44sLDbyDdM+R8byItp5fQr7jmiyULUD4LTJysaFqXGoLX0es+wqvIMkC0p0
         d23SYrYS61exw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        arinc.unal@arinc9.com, sergio.paracuellos@gmail.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: enable XDP support just for MT7986 SoC
Date:   Tue, 13 Sep 2022 15:03:05 +0200
Message-Id: <2bf31e27b888c43228b0d84dd2ef5033338269e2.1663074002.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable page_pool/XDP support for MT7621 SoC in order fix a regression
introduce adding XDP for MT7986 SoC. There is no a real use case for XDP
on MT7621 since it is a low-end cpu. Moreover this patch reduces the
memory footprint.

Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5ace4609de47..b344632beadd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1458,7 +1458,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *eth)
 
 static bool mtk_page_pool_enabled(struct mtk_eth *eth)
 {
-	return !eth->hwlro;
+	return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
 }
 
 static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
-- 
2.37.3

