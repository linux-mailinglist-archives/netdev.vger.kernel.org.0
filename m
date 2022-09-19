Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0C5BCA7F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiISLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiISLQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:16:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352D101E8;
        Mon, 19 Sep 2022 04:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YKIMbyBd6IxrYdJrLOS4dKO9Osny5oknx5qOjXOku6A=; b=PMlXkKi9U/nQtThWYCKYmdGKPk
        oD1BZJQEVOCRaQjFboOvk91o80FgT8rqXPr8sO7rmfBCw3uCcBvsHaskN6786FIsnCr2R9c2u5Us2
        8ox2jbAKJMq17DZ+ZZmPfzPc7E0c9JENCrk1426mWmdXHZd8FizZjBPEejvBGj6npzy+9BtNUw50X
        CWvvO1FPQ3OP8rK4DQvoGTXPBQHDLJv/3EWZaNt0LAVXduaTCuhIg/2TduauC8NZMfCI6FrMlHlHl
        9iIO3UR8NKo5VA8nTpeis0NLti4hROIxXzKwW0F+8RXXfme/MFA1bUY0ICE/biBWelDXzwzXqaloP
        gdiiOKHg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34398)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oaEkf-0000mu-1J; Mon, 19 Sep 2022 12:15:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oaEkZ-0006LY-JK; Mon, 19 Sep 2022 12:15:43 +0100
Date:   Mon, 19 Sep 2022 12:15:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexander Couzens <lynxis@fe80.eu>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/5] net: mediatek: sgmii: set the speed
 according to the phy interface in AN
Message-ID: <YyhPX33PPbV/XyoY@shell.armlinux.org.uk>
References: <20220919083713.730512-1-lynxis@fe80.eu>
 <20220919083713.730512-5-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919083713.730512-5-lynxis@fe80.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:37:11AM +0200, Alexander Couzens wrote:
> The non auto-negotioting code path is setting the correct speed for the
> interface. Ensure auto-negotiation code path is doing it as well.

While I see the logic in doing this in the autoneg path, if you look
at mtk_pcs_config(), you'll notice that this code you're adding is
unreachable.

If interface is PHY_INTERFACE_MODE_2500BASEX, then we will call
mtk_pcs_setup_mode_force(). We only call mtk_pcs_setup_mode_an() for
the PHY_INTERFACE_MODE_SGMII case when in-band mode is selected, so
this can become:

	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
	val &= ~RG_PHY_SPEED_MASK;
	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
