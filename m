Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6A6EF525
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbjDZNKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZNKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:10:12 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C77BAF;
        Wed, 26 Apr 2023 06:10:11 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pretn-0004ob-2w;
        Wed, 26 Apr 2023 15:09:32 +0200
Date:   Wed, 26 Apr 2023 14:07:45 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 04/24] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
Message-ID: <ZEkiIQZsspBlDyEn@makrotopia.org>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-5-arinc.unal@arinc9.com>
 <ZEfsCit0XX8zqUIJ@makrotopia.org>
 <ce681fac-5f00-f0fc-b2cf-89907c50ee7c@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce681fac-5f00-f0fc-b2cf-89907c50ee7c@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 11:12:09AM +0300, Arınç ÜNAL wrote:
> On 25.04.2023 18:04, Daniel Golle wrote:
> > On Tue, Apr 25, 2023 at 11:29:13AM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > Introduce the p5_sgmii pointer to store the information for whether port 5
> > > has got SGMII or not.
> > 
> > The p5_sgmii your are introducing to struct mt7530_priv is a boolean
> > variable, and not a pointer.
> 
> I must've meant to say field.

Being just a single boolean variable also 'field' would not be the right
word here. We use 'field' as in 'bitfield', ie. usually disguised integer
types in which each bit has an assigned meaning.

> 
> > 
> > > 
> > > Move the comment about MT7531AE and MT7531BE to mt7531_setup(), where the
> > > switch is identified.
> > > 
> > > Get rid of mt7531_dual_sgmii_supported() now that priv->p5_sgmii stores the
> > > information. Address the code where mt7531_dual_sgmii_supported() is used.
> > > 
> > > Get rid of mt7531_is_rgmii_port() which just prints the opposite of
> > > priv->p5_sgmii.
> > > 
> > > Remove P5_INTF_SEL_GMAC5_SGMII. The p5_interface_select enum is supposed to
> > > represent the mode that port 5 is being used in, not the hardware
> > > information of port 5. Set p5_intf_sel to P5_INTF_SEL_GMAC5 instead, if
> > > port 5 is not dsa_is_unused_port().
> > > 
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > 
> > Other than the comment above this change makes sense and looks good to
> > me, so once you correct the commit message, you may add my Acked-by.
> 
> Will do, thanks.
> 
> Arınç
