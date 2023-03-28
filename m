Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599F86CC42E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjC1PAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbjC1PAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:00:44 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAADEE395;
        Tue, 28 Mar 2023 08:00:42 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phAoM-0008Nx-1D;
        Tue, 28 Mar 2023 17:00:34 +0200
Date:   Tue, 28 Mar 2023 16:00:30 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <ZCMBDm31AzDGBKyL@makrotopia.org>
References: <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCLmwm01FK7laSqs@makrotopia.org>
 <ZCLmwm01FK7laSqs@makrotopia.org>
 <20230328141628.ahteqtqniey45wb6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328141628.ahteqtqniey45wb6@skbuf>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 05:16:28PM +0300, Vladimir Oltean wrote:
> On Tue, Mar 28, 2023 at 02:08:18PM +0100, Daniel Golle wrote:
> > I agree that using regmap would be better and I have evaluated that
> > approach as well. As regmap doesn't allow lock-skipping and mt7530.c is
> > much more complex than xrs700x in the way indirect access to its MDIO bus
> > and interrupts work, using regmap accessors for everything would not be
> > trivial.
> > 
> > So here we can of course use regmap_read_poll_timeout and a bunch of
> > readmap_write operations. However, each of them will individually acquire
> > and release the mdio bus mutex while the current code acquires the lock
> > at the top of the function and then uses unlocked operations.
> > regmap currently doesn't offer any way to skip the locking and/or perform
> > locking manually. regmap_read, regmap_write, regmap_update_bits, ... always
> > acquire and release the lock on each operation.
> 
> What does struct regmap_config :: disable_locking do?

I thought I can't use that on a per-operation base because the
instance of struct regmap_config itself isn't protected by any lock
and hence setting disable_locking=false before calling one of the
accessor functions may affect also other congruent calls to the
accessors which will then ignore locking and screw things up.
Please correct me if I'm wrong there.

Yet another way I thought about now could also be to have two regmap
instances, one for locked and one for unlocked accessed to the same
regmap_bus.
