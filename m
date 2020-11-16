Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961302B5528
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgKPXhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729638AbgKPXhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:37:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1FA22314;
        Mon, 16 Nov 2020 23:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605569823;
        bh=ihmiklUfC1+9o6mC+hzNds+MVWdt2vSFfFVLsdxTiSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=efLc/0ubXKpHhvnLvoTU/vOId5vZQqyXfM9ZPFcY6KRdVOCKyduRqjv6fDXJGrzdJ
         6aBVqGTv+pOD66o9YxpFed2l/wxSMsakEoH4f49Z0Tbk+63WkloeqtA6g5/K7uukNH
         YkfB5eiDyk15SKpIJStB0TCfC/o3e58iTTBGyK/w=
Date:   Mon, 16 Nov 2020 15:37:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <vineetha.g.jaya.kumaran@intel.com>,
        <rusaimi.amira.rusaimi@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: stmmac: dwmac-intel-plat: fix error return
 code in intel_eth_plat_probe()
Message-ID: <20201116153702.55e55d6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605249243-17262-1-git-send-email-zhangchangzhong@huawei.com>
References: <1605249243-17262-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 14:34:03 +0800 Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
> index f61cb99..82b1c7a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
> @@ -113,8 +113,10 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
>  		/* Enable TX clock */
>  		if (dwmac->data->tx_clk_en) {
>  			dwmac->tx_clk = devm_clk_get(&pdev->dev, "tx_clk");
> -			if (IS_ERR(dwmac->tx_clk))
> +			if (IS_ERR(dwmac->tx_clk)) {
> +				ret = PTR_ERR(dwmac->tx_clk);
>  				goto err_remove_config_dt;
> +			}
>  
>  			clk_prepare_enable(dwmac->tx_clk);

Someone should take the look at the error handling later in this
function. It's not checking ret from clk_prepare_enable(), and even tho
top half of this function uses goto, the rest suddenly starts doing
direct returns :S


                        clk_prepare_enable(dwmac->tx_clk);                       
                                                                                 

                        /* Check and configure TX clock rate */                  
                        rate = clk_get_rate(dwmac->tx_clk);                      
                        if (dwmac->data->tx_clk_rate &&                          
                            rate != dwmac->data->tx_clk_rate) {                  
                                rate = dwmac->data->tx_clk_rate;                 
                                ret = clk_set_rate(dwmac->tx_clk, rate);         
                                if (ret) {                                       
                                        dev_err(&pdev->dev,                      
                                                "Failed to set tx_clk\n");       
                                        return ret;                              
                                }                                                
                        }                                                        
                }                                                                
                                                                                 
                /* Check and configure PTP ref clock rate */                     
                rate = clk_get_rate(plat_dat->clk_ptp_ref);                      
                if (dwmac->data->ptp_ref_clk_rate &&                             
                    rate != dwmac->data->ptp_ref_clk_rate) {                     
                        rate = dwmac->data->ptp_ref_clk_rate;                    
                        ret = clk_set_rate(plat_dat->clk_ptp_ref, rate);         
                        if (ret) {                                               
                                dev_err(&pdev->dev,                              
                                        "Failed to set clk_ptp_ref\n");          
                                return ret;                                      
                        }                                                        
                }                                                                
        }        
