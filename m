Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5180534D7A2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhC2S4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:56:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhC2Szu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 14:55:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQx2p-00Drfi-AO; Mon, 29 Mar 2021 20:55:23 +0200
Date:   Mon, 29 Mar 2021 20:55:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH linux-next 1/1] phy: Sparx5 Eth SerDes: Use direct
 register operations
Message-ID: <YGIimz9UnVYWfcXH@lunn.ch>
References: <20210329081438.558885-1-steen.hegelund@microchip.com>
 <20210329081438.558885-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329081438.558885-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 10:14:38AM +0200, Steen Hegelund wrote:
> Use direct register operations instead of a table of register
> information to lower the stack usage.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/phy/microchip/sparx5_serdes.c | 1869 +++++++++++++------------
>  1 file changed, 951 insertions(+), 918 deletions(-)
> 
> diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
> index 06bcf0c166cf..43de68a62c2f 100644
> --- a/drivers/phy/microchip/sparx5_serdes.c
> +++ b/drivers/phy/microchip/sparx5_serdes.c
> @@ -343,12 +343,6 @@ struct sparx5_sd10g28_params {
>  	u8 fx_100;
>  };
>  
> -struct sparx5_serdes_regval {
> -	u32 value;
> -	u32 mask;
> -	void __iomem *addr;
> -};
> -
>  static struct sparx5_sd25g28_media_preset media_presets_25g[] = {
>  	{ /* ETH_MEDIA_DEFAULT */
>  		.cfg_en_adv               = 0,
> @@ -945,431 +939,411 @@ static void sparx5_sd25g28_reset(void __iomem *regs[],
>  	}
>  }
>  
> -static int sparx5_sd25g28_apply_params(struct device *dev,
> -				       void __iomem *regs[],
> -				       struct sparx5_sd25g28_params *params,
> -				       u32 sd_index)
> +static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
> +				       struct sparx5_sd25g28_params *params)
>  {
> -	struct sparx5_serdes_regval item[] = {

Could you just add const here, and then it is no longer on the stack?

   Andrew
