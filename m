Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF9A6D3F3E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjDCImY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjDCImU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:42:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB1CD32F
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 01:42:13 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pjFlE-0008IB-6R; Mon, 03 Apr 2023 10:41:56 +0200
Message-ID: <33b8501c-f617-3f66-91c4-02f9963e2a2f@pengutronix.de>
Date:   Mon, 3 Apr 2023 10:41:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Linux-stm32] [PATCH] net: stmmac: remove the limitation of
 adding vlan in promisc mode
Content-Language: en-US
To:     Clark Wang <xiaoning.wang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230403081717.2047939-1-xiaoning.wang@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230403081717.2047939-1-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-3.6 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Clark,

On 03.04.23 10:17, Clark Wang wrote:
> When using brctl to add eqos to a bridge, it will frist set eqos to
> promisc mode and then set a VLAN for this bridge with a filer VID value
> of 1.
> 
> These two error returns limit the use of brctl, resulting in the
> inability of the bridge to be enabled on eqos. So remove them.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Please add a suitable Fixes: tag pointing at the commit introducing
the regression.

Thanks,
Ahmad

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> index 8c7a0b7c9952..64bbe15a699e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -472,12 +472,6 @@ static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
>  	if (vid > 4095)
>  		return -EINVAL;
>  
> -	if (hw->promisc) {
> -		netdev_err(dev,
> -			   "Adding VLAN in promisc mode not supported\n");
> -		return -EPERM;
> -	}
> -
>  	/* Single Rx VLAN Filter */
>  	if (hw->num_vlan == 1) {
>  		/* For single VLAN filter, VID 0 means VLAN promiscuous */
> @@ -527,12 +521,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
>  {
>  	int i, ret = 0;
>  
> -	if (hw->promisc) {
> -		netdev_err(dev,
> -			   "Deleting VLAN in promisc mode not supported\n");
> -		return -EPERM;
> -	}
> -
>  	/* Single Rx VLAN Filter */
>  	if (hw->num_vlan == 1) {
>  		if ((hw->vlan_filter[0] & GMAC_VLAN_TAG_VID) == vid) {

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

