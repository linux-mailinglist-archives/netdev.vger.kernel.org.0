Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555BA623039
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiKIQe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKIQew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:34:52 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5530A1A06F;
        Wed,  9 Nov 2022 08:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W2E4Ms9uc9J9Ds/fMfsOB8+k0By+V4+l9wVONX22uWE=; b=pA8lzr+rM2UmcM0MV2wVv0Kw4C
        fyf9BHbCCg2RLB0h0MPAXyJR70KaGvc28usii6aQo4415C3/S/LcHMO0L+SEQTSbO/+RpvrrbfScD
        0ydNos+7lUENHNS+21V+Mo82l7pniop4A4kl9lVI/WJUN/LNmCs88s8AwHc6XYSAr8b8=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso23-000l4N-2z; Wed, 09 Nov 2022 17:34:31 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 01/12] net: ethernet: mtk_eth_soc: account for vlan in rx header length
Date:   Wed,  9 Nov 2022 17:34:15 +0100
Message-Id: <20221109163426.76164-2-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
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

The network stack assumes that devices can handle an extra VLAN tag without
increasing the MTU

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 589f27ddc401..3d7cdc1efbbc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -29,7 +29,7 @@
 #define MTK_TX_DMA_BUF_LEN_V2	0xffff
 #define MTK_DMA_SIZE		512
 #define MTK_MAC_COUNT		2
-#define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
+#define MTK_RX_ETH_HLEN		(VLAN_ETH_HLEN + ETH_FCS_LEN)
 #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
 #define MTK_DMA_DUMMY_DESC	0xffffffff
 #define MTK_DEFAULT_MSG_ENABLE	(NETIF_MSG_DRV | \
-- 
2.38.1

