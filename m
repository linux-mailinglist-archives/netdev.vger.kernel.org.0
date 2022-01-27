Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8FC49D6ED
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiA0Ar2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:47:28 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35466 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229510AbiA0Ar2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:47:28 -0500
X-UUID: 4c149d6ec5384f4d85be8f6fccfb7b9b-20220127
X-UUID: 4c149d6ec5384f4d85be8f6fccfb7b9b-20220127
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1125597474; Thu, 27 Jan 2022 08:47:24 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 08:47:23 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 08:47:22 +0800
Message-ID: <9793dc8c5c30db9342eb54c1b9c0a10b339d2860.camel@mediatek.com>
Subject: Re: [PATCH net-next v1 1/9] net: ethernet: mtk-star-emac: store
 bit_clk_div in compat structure
From:   Biao Huang <biao.huang@mediatek.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
CC:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felix Fietkau" <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Date:   Thu, 27 Jan 2022 08:47:22 +0800
In-Reply-To: <CAMRc=Mc+DqcQFGqxoYXYG-VCuaKkJusoVGSHb0G-MtYsiVCxVw@mail.gmail.com>
References: <20220120070226.1492-1-biao.huang@mediatek.com>
         <20220120070226.1492-2-biao.huang@mediatek.com>
         <CAMRc=Mc+DqcQFGqxoYXYG-VCuaKkJusoVGSHb0G-MtYsiVCxVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Bartosz,
	Thanks for your comments!

On Tue, 2022-01-25 at 10:50 +0100, Bartosz Golaszewski wrote:
> On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com>
> wrote:
> > 
> > From: Fabien Parent <fparent@baylibre.com>
> > 
> > Not all the SoC are using the same clock divider. Move the divider
> > into
> > a compat structure specific to the SoCs.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > Signed-off-by: Fabien Parent <fparent@baylibre.com>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_star_emac.c | 23
> > +++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > index 1d5dd2015453..26f5020f2e9c 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/module.h>
> >  #include <linux/netdevice.h>
> >  #include <linux/of.h>
> > +#include <linux/of_device.h>
> >  #include <linux/of_mdio.h>
> >  #include <linux/of_net.h>
> >  #include <linux/platform_device.h>
> > @@ -232,6 +233,10 @@ struct mtk_star_ring {
> >         unsigned int tail;
> >  };
> > 
> > +struct mtk_star_compat {
> > +       unsigned char bit_clk_div;
> > +};
> > +
> >  struct mtk_star_priv {
> >         struct net_device *ndev;
> > 
> > @@ -257,6 +262,8 @@ struct mtk_star_priv {
> >         int duplex;
> >         int pause;
> > 
> > +       const struct mtk_star_compat *compat_data;
> > +
> >         /* Protects against concurrent descriptor access. */
> >         spinlock_t lock;
> > 
> > @@ -899,7 +906,7 @@ static void mtk_star_init_config(struct
> > mtk_star_priv *priv)
> >         regmap_write(priv->regs, MTK_STAR_REG_SYS_CONF, val);
> >         regmap_update_bits(priv->regs, MTK_STAR_REG_MAC_CLK_CONF,
> >                            MTK_STAR_MSK_MAC_CLK_CONF,
> > -                          MTK_STAR_BIT_CLK_DIV_10);
> > +                          priv->compat_data->bit_clk_div);
> >  }
> > 
> >  static void mtk_star_set_mode_rmii(struct mtk_star_priv *priv)
> > @@ -1461,6 +1468,7 @@ static int mtk_star_probe(struct
> > platform_device *pdev)
> > 
> >         priv = netdev_priv(ndev);
> >         priv->ndev = ndev;
> > +       priv->compat_data = of_device_get_match_data(&pdev->dev);
> >         SET_NETDEV_DEV(ndev, dev);
> >         platform_set_drvdata(pdev, ndev);
> > 
> > @@ -1556,10 +1564,17 @@ static int mtk_star_probe(struct
> > platform_device *pdev)
> >         return devm_register_netdev(dev, ndev);
> >  }
> > 
> > +static struct mtk_star_compat mtk_star_mt8516_compat = {
> 
> static const ... ?
Yes, will fix it in next send.
> 
> > +       .bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
> > +};
> > +
> >  static const struct of_device_id mtk_star_of_match[] = {
> > -       { .compatible = "mediatek,mt8516-eth", },
> > -       { .compatible = "mediatek,mt8518-eth", },
> > -       { .compatible = "mediatek,mt8175-eth", },
> > +       { .compatible = "mediatek,mt8516-eth",
> > +         .data = &mtk_star_mt8516_compat },
> > +       { .compatible = "mediatek,mt8518-eth",
> > +         .data = &mtk_star_mt8516_compat },
> > +       { .compatible = "mediatek,mt8175-eth",
> > +         .data = &mtk_star_mt8516_compat },
> >         { }
> >  };
> >  MODULE_DEVICE_TABLE(of, mtk_star_of_match);
> > --
> > 2.25.1
> > 

