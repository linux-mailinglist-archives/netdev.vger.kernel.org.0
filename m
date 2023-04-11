Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7026DE511
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDKTnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDKTnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:43:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEEA1BCE;
        Tue, 11 Apr 2023 12:43:23 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pmJtb-00082q-2B;
        Tue, 11 Apr 2023 21:43:15 +0200
Date:   Tue, 11 Apr 2023 20:43:10 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix support for MT7531BE
Message-ID: <ZDW4Tr4bIGcxwDgs@makrotopia.org>
References: <ZDSlm-0gyyDZXy_k@makrotopia.org>
 <13aedaa6-6b7b-727e-e932-4a5139c54f39@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13aedaa6-6b7b-727e-e932-4a5139c54f39@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 10:30:06PM +0300, Arınç ÜNAL wrote:
> On 11.04.2023 03:11, Daniel Golle wrote:
> > There are two variants of the MT7531 switch IC which got different
> > features (and pins) regarding port 5:
> >   * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes
> >   * MT7531BE: RGMII
> > 
> > Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
> > with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to
> > mt7530_probe function") works fine for MT7531AE which got two instances
> > of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup to setup
> > clocks before the single PCS on port 6 (usually used as CPU port)
> > starts to work and hence the PCS creation failed on MT7531BE.
> > 
> > Fix this by introducing a pointer to mt7531_create_sgmii function in
> > struct mt7530_priv and call it again at the end of mt753x_setup like it
> > was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
> > creation to mt7530_probe function").
> 
> If I understand correctly, this patch does two things.
> 
> Run mt7531_create_sgmii() from mt753x_setup(), after mt7531_setup() and
> mt7531_setup_common() is run so that PCS on MT7531BE works.

> 
> Run the PCS creation code inside the loop only once if
> mt7531_dual_sgmii_supported() is false so it doesn't set the nonexistent
> port 5 SGMII on MT7531BE.

Yes, both is correct.

> 
> Regarding the first part:
> I was actually in the middle of moving the code until after
> mt7530_pll_setup() and mt7531_pll_setup() on mt7530_setup() and
> mt7531_setup() to mt7530_probe(). To me it makes more sense to run them on
> mt7530_probe() as there's a good amount of duplicate code on mt7530_setup()
> and mt7531_setup().

I thought about doing that as well, however, note that you will have to
move all the reset and regulator setup procedure to mt7530_probe() as
well then, as PLL setup currently happens after that, and that's
probably for a reason.

As the reset and regulator setup works differently on MT7530 and
MT7531, and depending on whether it's a standalone IC package or MCM, I
believe changes unifying this will have to be tested on a lot of
boards...

> 
> This will resolve the problem here, and make my future work regarding the
> PHY muxing feature on the MT7530 switch possible to do.
> 
> Regarding the second part:
> I'll take your changes to my current RFC patch series while addressing
> Jesse's suggestion if this is fine by you.

Yes, I'd appreciate that and I'm ready to test and review once you post
your updated series.
