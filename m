Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208704F66AA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiDFRPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbiDFRPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:15:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A834D701A
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XVocJGw0syYpnJfzHYQoJ7e5WCFSCvmwf3JsfDKxORE=; b=HStDEVrJMxvoW1fCf4q7HpZHJ4
        sXul8yTcVhcd1yZRJhycRpQp4tIZb4ClisuuCF11mGe+tfAIRr9pLuUBD6OndEfFtud/lCV9kBPmP
        VRMzssRr0O6oIdbIBGcYMryvH+bzWI5VK8/T94wF2UYpcCcFwilQ6wHEs+d+yjGXRLcULL1ChCwH4
        9W2M5NqeQ7Em0uEUf0kdUrqGeM6RHSXEhw5SAzVcbrZ77PzGe4Gra1TeMS03BDMN3GLHI1VNQUOR/
        XPPzr0wBFNQle1qPk7jqYDcqHPr8NwdoMmfnt/5Zy3fY9Thxu9z74ipFRrfkMm2iKn4Ka3kQmoDF/
        DdMFpa5g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60678 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6ky-0002vs-8g; Wed, 06 Apr 2022 15:35:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6kx-004ikJ-CY; Wed, 06 Apr 2022 15:35:35 +0100
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 08/12] net: mtk_eth_soc: add fixme comment for
 state->speed use
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6kx-004ikJ-CY@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:35:35 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a fixme comment for the last remaining incorrect usage of
state->speed in the mac_config() method, which is strangely in a code
path which is only run when the PHY interface mode changes.

This means if we are in RGMII mode, changes in state->speed will not
cause the INTF_MODE, TRGMII_RCK_CTRL and TRGMII_TCK_CTRL registers to
be set according to the speed, nor will the TRGPLL clock be set to the
correct value.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a16f02ed921a..b605a823dcd4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -324,6 +324,14 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 							      state->interface))
 					goto err_phy;
 			} else {
+				/* FIXME: this is incorrect. Not only does it
+				 * use state->speed (which is not guaranteed
+				 * to be correct) but it also makes use of it
+				 * in a code path that will only be reachable
+				 * when the PHY interface mode changes, not
+				 * when the speed changes. Consequently, RGMII
+				 * is probably broken.
+				 */
 				mtk_gmac0_rgmii_adjust(mac->hw,
 						       state->interface,
 						       state->speed);
-- 
2.30.2

