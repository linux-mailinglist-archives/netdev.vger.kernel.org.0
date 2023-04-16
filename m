Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A656E37D6
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 13:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjDPL53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 07:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjDPL51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 07:57:27 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3A9D
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 04:57:25 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1po10R-0007qP-1l;
        Sun, 16 Apr 2023 13:57:19 +0200
Date:   Sun, 16 Apr 2023 12:57:10 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <ZDvilj5xRmXQwQ89@makrotopia.org>
References: <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
 <20230415134604.2mw3iodnrd2savs3@skbuf>
 <ZDquYkt_5Ku2ysSA@makrotopia.org>
 <20230415142014.katsq5axop6gov3i@skbuf>
 <ef677f5f-07a3-2cf7-79d1-ae8980b73701@arinc9.com>
 <2f3796e3-438c-604f-1e61-ccb2fa118aff@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f3796e3-438c-604f-1e61-ccb2fa118aff@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 12:38:03PM +0300, Arınç ÜNAL wrote:
> On 15.04.2023 17:57, Arınç ÜNAL wrote:
> > On 15.04.2023 17:20, Vladimir Oltean wrote:
> > > On Sat, Apr 15, 2023 at 03:02:10PM +0100, Daniel Golle wrote:
> > > > As the PHYs are accessed over the MDIO bus which is exposed by
> > > > the mt7530.c
> > > > DSA driver the only middle ground would possibly be to introduce a MFD
> > > > driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
> > > > expose the mt7530-controlled MDIO bus.
> > > 
> > > Which is something I had already mentioned as a possible way forward in
> > > the other thread. One would need to take care of ensuring a reasonable
> > > migration path in terms of device tree compatibility though.
> > > 
> > > > 
> > > > Obviously that'd be a bit more work than just moving some things
> > > > from the
> > > > switch setup function to the probe function...
> > > 
> > > On the other hand, it would actually work reliably, and would not depend
> > > on whomever wanted to reorder things just a little bit differently for
> > > his system to probe faster.
> > 
> > Ok thanks. I will investigate how the switch would be set up with an MFD
> > driver, and how it would affect dt-bindings.
> > 
> > Looking back at my patch series, currently with this [0], SGMII on
> > MT7531BE's port 6 starts working, and with Daniel's addition [1], the
> > regulator warnings disappear.
> > 
> > I will submit the patch series as an RFC after addressing Daniel's
> > inline functions suggestion.
> 
> I've been giving this some thought. My understanding of probe in this
> context has changed drastically. The probe here is supposed to probe the
> driver, like setting up the pointers, reading from the devicetree, filling
> up the info table, and finally calling dsa_register_switch(). It would not
> necessarily do anything to the switch hardware like resetting and reading
> information from the registers. This is currently how mt7530-mdio and
> mt7530-mmio already operate. So I'm not going to move anything from setup to
> probe.
> 
> The duplicate code on mt7530_setup() and mt7531_setup() could rather be put
> on mt753x_setup() instead. But now there's ID_MT7988 also going through
> mt753x_setup, so it's not very feasible to do this anymore, too many ID
> checks there would be.
> 
> Moving forward, I will send a separate bugfix patch that makes port 6 on
> MT7531BE work. My patch series will solely be for improving the driver.
> 
> Daniel, can you confirm this patch is enough to make port 6 work on
> MT7531BE? I won't touch the PCS creation code here as it'd be an improvement
> rather than a fix, if this works.
> 
> https://github.com/arinc9/linux/commit/bb55b97b8f600cf28433e7ff494d296a15191cb3

Why don't we use my original solution [1] which has some advantages:

 * It doesn't requrire additional export of mt7530_regmap_bus

 * It doesn't move PCS creation to mt7530.c, hence PCS_MTK_LYNXI is
   only required for MDIO-connected switches
   (with your patch we would have to move the dependency on PCS_MTK_LYNXI
   from NET_DSA_MT7530_MDIO to NET_DSA_MT7530)

 * It doesn't expose the dysfunctional SerDes PCS for port 5 on MT7531BE
   This will still fail and hence result in probing on MT7531 to exit
   prematurely, preventing the switch driver from being loaded.
   Before 9ecc00164dc23 ("net: dsa: mt7530: refactor SGMII PCS creation")
   the return value of mtk_pcs_lynxi_create was ignored, now it isn't...

 * It changes much less in terms of LoC


I've of course also already addressed the comments of Jesse Brandeburg
and will submit it in a few moments.


[1]: https://patchwork.kernel.org/project/linux-mediatek/patch/ZDSlm-0gyyDZXy_k@makrotopia.org/

Thank you anyway for eyes and brains on this, I appreciate that.
