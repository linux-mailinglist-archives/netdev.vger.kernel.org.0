Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5416036414D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbhDSMQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:16:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhDSMQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 08:16:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYSo4-00HWif-T8; Mon, 19 Apr 2021 14:15:12 +0200
Date:   Mon, 19 Apr 2021 14:15:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next 2/2] net: ethernet: mediatek: support custom
 GMAC label
Message-ID: <YH10UNuJZ5s7dfLh@lunn.ch>
References: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
 <20210419040352.2452-3-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419040352.2452-3-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 09:03:52PM -0700, Ilya Lipnitskiy wrote:
> The MAC device name can now be set within DTS file instead of always
> being "ethX". This is helpful for DSA to clearly label the DSA master
> device and distinguish it from DSA slave ports.
> 
> For example, some devices, such as the Ubiquiti EdgeRouter X, may have
> ports labeled ethX. Labeling the master GMAC with a different prefix
> than DSA ports helps with clarity.
> 
> Suggested-by: René van Dorst <opensource@vdorst.com>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 6b00c12c6c43..4c0ce4fb7735 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2845,6 +2845,7 @@ static const struct net_device_ops mtk_netdev_ops = {
>  
>  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  {
> +	const char *label = of_get_property(np, "label", NULL);
>  	const __be32 *_id = of_get_property(np, "reg", NULL);
>  	phy_interface_t phy_mode;
>  	struct phylink *phylink;
> @@ -2940,6 +2941,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  	else
>  		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
>  
> +	if (label)
> +		strscpy(eth->netdev[id]->name, label, IFNAMSIZ);

It is better to use alloc_netdev_mqs() so you get validation the name
is unique.

   Andrew
