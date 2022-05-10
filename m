Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D6521132
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiEJJol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiEJJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:44:40 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29BFE49;
        Tue, 10 May 2022 02:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mCs9O3RJG01sw6qsZslsu692hG4UQ4nY/c7ZXZYpQ7k=; b=YA/qQ9JBLeM2/t9UBwl7vdtyKP
        fPVHEg/CLYnZKaPDVcnlMphhcN657ekRTJ5EvsJc4XP6wroRqsrh4D0TdYh71PLCDeP32jCRU/GK4
        GEK0f7TrBABDVp/03sBk8odbSJHkMolZz+RgOLtmeLy+bASDC9ja//Hnt7T6tiyeUs5c=;
Received: from [217.114.218.19] (helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noMLu-0005SZ-MI; Tue, 10 May 2022 11:40:22 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Date:   Tue, 10 May 2022 11:40:13 +0200
Message-Id: <20220510094014.68440-1-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Padding for transmitted packets needs to account for the special tag.
With not enough padding, garbage bytes are inserted by the switch at the
end of small packets.

Fixes: 5cd8985a1909 ("net-next: dsa: add Mediatek tag RX/TX handler")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/dsa/tag_mtk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 415d8ece242a..1d1f9dbd9e93 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -25,6 +25,14 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	u8 xmit_tpid;
 	u8 *mtk_tag;
 
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 64 bytes (including FCS) otherwise their padding might be
+	 * corrupted. With tags enabled, we need to make sure that packets are
+	 * at least 68 bytes (including FCS and tag).
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN + MTK_HDR_LEN, false))
+		return NULL;
+
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
 	 * being combined. Only in this way we can allow the switch can parse
-- 
2.36.1

