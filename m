Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F726CF2B4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjC2TFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjC2TFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:05:14 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04F1198C;
        Wed, 29 Mar 2023 12:05:13 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phb6a-0005fL-2y;
        Wed, 29 Mar 2023 21:05:09 +0200
Date:   Wed, 29 Mar 2023 20:05:06 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [RFC PATCH net-next v3 14/15] net: dsa: mt7530: introduce driver
 for MT7988 built-in switch
Message-ID: <ZCSL4l/Fd37CgGBa@makrotopia.org>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <371f0586e257d098993847e71d0c916a03c04191.1680105013.git.daniel@makrotopia.org>
 <8fe9c1b6-a533-4ad9-8a23-4f16547476ed@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fe9c1b6-a533-4ad9-8a23-4f16547476ed@lunn.ch>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 06:57:54PM +0200, Andrew Lunn wrote:
> > @@ -18,6 +18,7 @@ enum mt753x_id {
> >  	ID_MT7530 = 0,
> >  	ID_MT7621 = 1,
> >  	ID_MT7531 = 2,
> > +	ID_MT7988 = 3,
> >  };
> >  
> >  #define	NUM_TRGMII_CTRL			5
> > @@ -54,11 +55,11 @@ enum mt753x_id {
> >  #define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
> >  #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
> >  
> > -#define MT753X_MIRROR_REG(id)		(((id) == ID_MT7531) ? \
> > +#define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
> >  					 MT7531_CFC : MT7530_MFC)
> > -#define MT753X_MIRROR_EN(id)		(((id) == ID_MT7531) ? \
> > +#define MT753X_MIRROR_EN(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
> >  					 MT7531_MIRROR_EN : MIRROR_EN)
> > -#define MT753X_MIRROR_MASK(id)		(((id) == ID_MT7531) ? \
> > +#define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
> >  					 MT7531_MIRROR_MASK : MIRROR_MASK)
> 
> Are there more devices coming soon? I'm just wondering if these should
> change into static inline functions with a switch statement? The
> current code is not going to scale too much more.

Afaik no devices with different built-in switches are in the pipe at
this time, so this should be fine for a while.
