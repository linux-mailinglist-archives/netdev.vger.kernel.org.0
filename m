Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E925F595E2F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiHPOQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 10:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHPOQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 10:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1831B1BA8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 07:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A6A60FCA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D205C433B5;
        Tue, 16 Aug 2022 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660659386;
        bh=hZ4gm5cAZEwvQ6ksizWao2p94DF6cvRGVeeX7yEOIMc=;
        h=From:To:Cc:Subject:Date:From;
        b=udCQE+WACI8+9JCL6QArkC+BwW58WbbawBoH3IVaFVnNok+UvBQ/UKBY/ejdpc5hx
         k7GAC2RySGPjxADV9uHAbZPMcLzx8+SkqYp+cLq4bjfQfbZ0Ha6u8jNaG7cDOEWPir
         1G6f7lRUEtdlxoiGRTDmivHGhRoGAwzAYlNep/F4z8CjUt6RlNseMgS8gHNTThACzC
         KWGc77j5XQAurAVPANaHWKIatp3aS/Lt/xuUv0qykHM6ZL/xa533f2wuILewKcRSBe
         Cd2o6c4VgoJvIWliZayGeN25s0FP7+kj/Xd8K4SSiEQuhbhix+Mbjb5baw+R0xTohQ
         kAxOxjTVhp3OQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix possible NULL pointer dereference in mtk_xdp_run
Date:   Tue, 16 Aug 2022 16:16:15 +0200
Message-Id: <627a07d759020356b64473e09f0855960e02db28.1660659112.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
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

Fix possible NULL pointer dereference in mtk_xdp_run() if the
ebpf program returns XDP_TX and xdp_convert_buff_to_frame routine fails
returning NULL.

Fixes: 5886d26fd25bb ("net: ethernet: mtk_eth_soc: add xmit XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9426b01f462..8aff4c0c28bd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1732,7 +1732,7 @@ static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 	case XDP_TX: {
 		struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 
-		if (mtk_xdp_submit_frame(eth, xdpf, dev, false)) {
+		if (!xdpf || mtk_xdp_submit_frame(eth, xdpf, dev, false)) {
 			count = &hw_stats->xdp_stats.rx_xdp_tx_errors;
 			act = XDP_DROP;
 			break;
-- 
2.37.2

