Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00A45AB5C5
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiIBPyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237462AbiIBPxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:53:43 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CE7EFD9;
        Fri,  2 Sep 2022 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CTrG12qWnI/c/AxI8kTL2+rjoFmKz1TXs568RjVaASw=; b=ifKtc5mRxPP/hgk+Ujk1yvgVcL
        Hd0Yi+M6uyrX3B0eqHzbr8jt3EzwK2h1hez7h9JQijZsTOI/t7b77YbQsg8TdY2kbc1MoO2iNRdqx
        fZW+VmZsVJeH2MySiJ5JZ5iiLwkpTJLYP/QJ+u3bsptU1mfzf971861j5yM7+VfOck15C0+diOs4j
        kL+vIvmkhQ8N98uA87gx95GTk2C+k7qFrK5CfD6L/Ay9F4DUKz0oBSilvXKQRLXbmkQV00XqhEMom
        Y3AJps/tqC2vkBIBL5YH8RPrRMTiOlGrInb/392Q1OI26agkHoUVlC5NwGEFsOUcCRbxKLExnQJoN
        wxDzstOA==;
Received: from [92.206.252.219] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oU8sx-005KhR-5H; Fri, 02 Sep 2022 15:47:11 +0000
Date:   Fri, 2 Sep 2022 17:47:10 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 3/4] net: mediatek: sgmii: mtk_pcs_setup_mode_an: don't
 rely on register defaults
Message-ID: <20220902174710.54a1d317@javelin>
In-Reply-To: <YwTyLwRnQ+eTXeDr@shell.armlinux.org.uk>
References: <20220820224538.59489-1-lynxis@fe80.eu>
        <20220820224538.59489-4-lynxis@fe80.eu>
        <YwTyLwRnQ+eTXeDr@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 16:28:47 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Sun, Aug 21, 2022 at 12:45:37AM +0200, Alexander Couzens wrote:
> > Ensure autonegotiation is enabled.
> > 
> > Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_sgmii.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> > b/drivers/net/ethernet/mediatek/mtk_sgmii.c index
> > 782812434367..aa69baf1a42f 100644 ---
> > a/drivers/net/ethernet/mediatek/mtk_sgmii.c +++
> > b/drivers/net/ethernet/mediatek/mtk_sgmii.c @@ -32,12 +32,13 @@
> > static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
> > regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
> > SGMII_LINK_TIMER_DEFAULT); 
> > +	/* disable remote fault & enable auto neg */
> >  	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
> > -	val |= SGMII_REMOTE_FAULT_DIS;
> > +	val |= SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN;  
> 
> Does SGMII_SPEED_DUPLEX_AN need to be cleared in
> mtk_pcs_setup_mode_force(), so mtk_pcs_link_up() can force the
> duplex setting for base-X protocols?
> 

Yes SGMII_SPEED_DUPLEX_AN needs to be cleared to have FORCE_DUPLEX
working. But mtk_pcs_setup_mode_force() is clearing it implicit by

val &= SGMII_DUPLEX_FULL & ~SGMII_IF_MODE_MASK

because it's included in the SGMII_IF_MODE_MASK.
I also don't understand why it's forcing it in the
mtk_pcs_link_up().
