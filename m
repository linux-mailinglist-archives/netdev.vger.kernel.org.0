Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60356E31AB
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDOOCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOOCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:02:22 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67C53C11
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:02:20 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pngTm-0002gU-19;
        Sat, 15 Apr 2023 16:02:14 +0200
Date:   Sat, 15 Apr 2023 15:02:10 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <ZDquYkt_5Ku2ysSA@makrotopia.org>
References: <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
 <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
 <20230415134604.2mw3iodnrd2savs3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230415134604.2mw3iodnrd2savs3@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 04:46:04PM +0300, Vladimir Oltean wrote:
> On Sat, Apr 15, 2023 at 04:40:19PM +0300, Arınç ÜNAL wrote:
> > My wording was not great there. What I meant is that PHY muxing will be
> > configured before dsa_register_switch() is run.
> 
> And we're back to the discussion from the thread "Move MT7530 phy muxing
> from DSA to PHY driver". What if someone decides that they don't need
> the switch driver - can they disable it? No.
> 
> Your thoughts are stopping mid way. If you think that PHY muxing should
> work without registering the DSA switch, then it doesn't belong in the
> DSA driver, plain and simple. No "yeah, but I can move it here, and it
> could kinda work, as a side effect of a driver failing to probe, or
> probing successfully but not registering with the subsystems for its
> primary purpose, or ...".

As the PHYs are accessed over the MDIO bus which is exposed by the mt7530.c
DSA driver the only middle ground would possibly be to introduce a MFD
driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
expose the mt7530-controlled MDIO bus.

Obviously that'd be a bit more work than just moving some things from the
switch setup function to the probe function...
