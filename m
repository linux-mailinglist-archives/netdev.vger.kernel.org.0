Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AF36EE557
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbjDYQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjDYQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:13:33 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D8F9000;
        Tue, 25 Apr 2023 09:13:32 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1prLIE-0004tQ-2k;
        Tue, 25 Apr 2023 18:13:26 +0200
Date:   Tue, 25 Apr 2023 17:11:36 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
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
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v2 13/14] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
Message-ID: <ZEf7uMIydCzxS437@makrotopia.org>
References: <cover.1680483895.git.daniel@makrotopia.org>
 <a426afba905ed4eb9878fbdc42b9f98e98c54e5f.1680483896.git.daniel@makrotopia.org>
 <20230425155137.GA19130@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425155137.GA19130@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 05:51:37PM +0200, Philipp Zabel wrote:
> Hi Daniel,
> 
> On Mon, Apr 03, 2023 at 02:19:40AM +0100, Daniel Golle wrote:
> > Add driver for the built-in Gigabit Ethernet switch which can be found
> > in the MediaTek MT7988 SoC.
> > 
> > The switch shares most of its design with MT7530 and MT7531, but has
> > it's registers mapped into the SoCs register space rather than being
> > connected externally or internally via MDIO.
> > 
> > Introduce a new platform driver to support that.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  MAINTAINERS                   |   2 +
> >  drivers/net/dsa/Kconfig       |  12 +++
> >  drivers/net/dsa/Makefile      |   1 +
> >  drivers/net/dsa/mt7530-mmio.c | 101 +++++++++++++++++++++++++
> [...]
> > diff --git a/drivers/net/dsa/mt7530-mmio.c b/drivers/net/dsa/mt7530-mmio.c
> > new file mode 100644
> > index 0000000000000..1a3d4b692f349
> > --- /dev/null
> > +++ b/drivers/net/dsa/mt7530-mmio.c
> > @@ -0,0 +1,101 @@
> [...]
> > +	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> 
> Please use devm_reset_control_get_exclusive() directly.
> 
> > +	if (IS_ERR(priv->rstc)) {
> > +		dev_err(&pdev->dev, "Couldn't get our reset line\n");
> > +		return PTR_ERR(priv->rstc);
> 
> Not sure if this can actually happen, but there is no need to warn on
> -EPROBE_DEFER. You could use return dev_err_probe(...) here.

Thank you for your comments. The series has already been picked to
net-next. Unless you want to send the suggested changes yourself, I will
prepare another series with your suggestions, and also apply them to
mt7530-mdio.c.

