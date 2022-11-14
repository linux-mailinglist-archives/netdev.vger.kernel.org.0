Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA1627E4A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiKNMns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiKNMnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:43:09 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC57252B3;
        Mon, 14 Nov 2022 04:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XKOsIjWD9UiWHhSPTpYvwZctofSL/DoRkI6SCzJGFi8=; b=mpH1bONmjSCvOi0+J+hPhjU8mC
        1oswAP9yAi37PrMZNA8IxVosUeXdtgxMiZvyEb5db48xJYzlS24FUVO8xJoKMkJYuBPLajw02u9CN
        paP0lkBfKFQjAbPqtNyfTDwXTmoyjO1ZXjP0OwGobN6abNAkVW8u4sq9bOrF+5zqzam4=;
Received: from p54ae9c3f.dip0.t-ipconnect.de ([84.174.156.63] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ouYn8-0021wc-7O; Mon, 14 Nov 2022 13:42:22 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 2/4] net: ethernet: mtk_eth_soc: pass correct VLAN protocol ID to the network stack
Date:   Mon, 14 Nov 2022 13:42:12 +0100
Message-Id: <20221114124214.58199-3-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124214.58199-1-nbd@nbd.name>
References: <20221114124214.58199-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the id from the DMA descriptor instead of hardcoding 802.1q

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1cf76fd7afbc..891dd6937f89 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1936,7 +1936,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 						htons(RX_DMA_VPID(trxd.rxd4)),
 						RX_DMA_VID(trxd.rxd4));
 			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
 						       RX_DMA_VID(trxd.rxd3));
 			}
 
-- 
2.38.1

