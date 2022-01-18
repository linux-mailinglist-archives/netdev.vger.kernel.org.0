Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F94913C4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiARBvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 20:51:52 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:38748 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S236467AbiARBvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 20:51:51 -0500
X-UUID: 7fe5b39085b348c1972f0ae24ea6cf92-20220118
X-UUID: 7fe5b39085b348c1972f0ae24ea6cf92-20220118
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 805230940; Tue, 18 Jan 2022 09:51:48 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 18 Jan 2022 09:51:47 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Jan 2022 09:51:45 +0800
Message-ID: <f9e3a862ecdb914a0efb52582989e975a742e918.camel@mediatek.com>
Subject: Re: [PATCH net-next v12 3/7] stmmac: dwmac-mediatek: re-arrange
 clock setting
From:   Biao Huang <biao.huang@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Date:   Tue, 18 Jan 2022 09:51:45 +0800
In-Reply-To: <2c62f337-5eb4-e525-7e3a-289435315c09@collabora.com>
References: <20220117070706.17853-1-biao.huang@mediatek.com>
         <20220117070706.17853-4-biao.huang@mediatek.com>
         <2c62f337-5eb4-e525-7e3a-289435315c09@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Angelo,
	Thanks for your comments.
On Mon, 2022-01-17 at 11:38 +0100, AngeloGioacchino Del Regno wrote:
> Il 17/01/22 08:07, Biao Huang ha scritto:
> > The rmii_internal clock is needed only when PHY
> > interface is RMII, and reference clock is from MAC.
> > 
> > Re-arrange the clock setting as following:
> > 1. the optional "rmii_internal" is controlled by devm_clk_get(),
> > 2. other clocks still be configured by devm_clk_bulk_get().
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 72 +++++++++++++-
> > -----
> >   1 file changed, 49 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > index 8747aa4403e8..2678d2deb26a 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > @@ -49,14 +49,15 @@ struct mac_delay_struct {
> >   struct mediatek_dwmac_plat_data {
> >   	const struct mediatek_dwmac_variant *variant;
> >   	struct mac_delay_struct mac_delay;
> > +	struct clk *rmii_internal_clk;
> >   	struct clk_bulk_data *clks;
> > -	struct device_node *np;
> >   	struct regmap *peri_regmap;
> > +	struct device_node *np;
> >   	struct device *dev;
> >   	phy_interface_t phy_mode;
> > -	int num_clks_to_config;
> >   	bool rmii_clk_from_mac;
> >   	bool rmii_rxc;
> > +	int num_clks;
> 
> I don't see any need to get a num_clks here, at this point: since all
> functions
> reading this are getting passed a pointer to this entire structure,
> you can
> simply always access plat->variant->num_clks.
> 
> Please, drop the addition of num_clks in this struct.
> 
> Regards,
> Angelo
OK, will remove it in next send.

