Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB585BB51F
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 03:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiIQBAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 21:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIQBAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 21:00:06 -0400
X-Greylist: delayed 2552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 18:00:02 PDT
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83BA6383;
        Fri, 16 Sep 2022 18:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IkyT/SH0Avq5x9pAHQMFR5EvWvl2e975Bdszn8X9P9s=; b=S54Kp3bJO79v4211GDHYBIU+zV
        jL4e6Kja0mIZtuKhYb1cRkkeMIonNJEhCBWwuJ0t0JZs2F/R1XvxH1q3vxwuDYPZJXNO084kWy0um
        AlWk/CNQgTbt5NlPEWtmEV0kpiIBsUxNmRfzfNNe4mWnwPpNFb2v07r1VCgrVrBI5j5U8JQtkCvrY
        7cH5FhJjm7IEosL5ErHj0P/THGgTtwjERmZDd4rs/MnMQOi4x1z8OYBMuIXh1xeYheF6Iai1xV2Gw
        bjGN5PsS5W4i/5dyVTBKZ2w3rImDsxJzkYVzgK3K27MND4jvM0/2HTtyr7LNMPrYUFhuTGIsbcjmk
        aSG5Fj2Q==;
Received: from p4fd2bf05.dip0.t-ipconnect.de ([79.210.191.5] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oZLNF-000nP7-FD; Sat, 17 Sep 2022 00:07:57 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
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
Cc:     Alexander Couzens <lynxis@fe80.eu>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] net: mt7531: ensure all MACs are powered down before reset
Date:   Sat, 17 Sep 2022 02:07:34 +0200
Message-Id: <20220917000734.520253-3-lynxis@fe80.eu>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220917000734.520253-1-lynxis@fe80.eu>
References: <20220917000734.520253-1-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The datasheet [1] explicit describes it as requirement for a reset.

[1] MT7531 Reference Manual for Development Board rev 1.0, page 735

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 95a57aeb466e..409d5c3d76ea 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2329,6 +2329,10 @@ mt7531_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	/* all MACs must be forced link-down before sw reset */
+	for (i = 0; i < MT7530_NUM_PORTS; i++)
+		mt7530_write(priv, MT7530_PMCR_P(i), MT7531_FORCE_LNK);
+
 	/* Reset the switch through internal reset */
 	mt7530_write(priv, MT7530_SYS_CTRL,
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-- 
2.37.3

