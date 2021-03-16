Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005AE33E093
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCPVcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhCPVcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F8B264F90;
        Tue, 16 Mar 2021 21:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615930344;
        bh=A8tS3BLwnxw3/M8kJr1pEOw/ZrskCZFgDoMyFEzKfUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uIBaYEjHXoV2WZv0Cjk+kpgy2es1yrAwt2Ja7iQO0R0eH8npYVHk1+SLA2VsU/qDn
         n/TqTSMBAdefLX4s58L8SdQhJ/YBy6BERA7zScIb/FFaE54RdW7B3EaALBdi+OSCf2
         5FUbGaw07DRwiL9y6pAViUNpxriH8+1NTfuUBjnr616sh5o2yCobKEs8laSTFr1YLy
         FsaGGDepmh28SB/fnrCGbsE+IUBtIqwOvkz8MhTC6qoURPSa7Ma9clGb4GUgn26aX1
         kM1y1NcKh7FuX0kGqhBluWiKyte/W5M5V8WYIVD5422DtI2x2BDJkhmIBBbQyaF9BP
         csNkFnKDYnS1g==
Date:   Tue, 16 Mar 2021 14:32:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [RESEND v1 net-next 4/5] stmmac: intel: add support for
 multi-vector msi and msi-x
Message-ID: <20210316143222.74480318@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316121823.18659-5-weifeng.voon@intel.com>
References: <20210316121823.18659-1-weifeng.voon@intel.com>
        <20210316121823.18659-5-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 20:18:22 +0800 Voon Weifeng wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> Intel mgbe controller supports multi-vector interrupts:
> msi_rx_vec	0,2,4,6,8,10,12,14
> msi_tx_vec	1,3,5,7,9,11,13,15
> msi_sfty_ue_vec	26
> msi_sfty_ce_vec	27
> msi_lpi_vec	28
> msi_mac_vec	29
> 
> During probe(), the driver will starts with request allocation for
> multi-vector interrupts. If it fails, then it will automatically fallback
> to request allocation for single interrupts.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Co-developed-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

> +
> +static int stmmac_config_multi_msi(struct pci_dev *pdev,
> +				   struct plat_stmmacenet_data *plat,
> +				   struct stmmac_resources *res)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = pci_alloc_irq_vectors(pdev, 2, STMMAC_MSI_VEC_MAX,
> +				    PCI_IRQ_MSI | PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		dev_info(&pdev->dev, "%s: multi MSI enablement failed\n",
> +			 __func__);
> +		return ret;
> +	}
> +
> +	if (plat->msi_rx_base_vec >= STMMAC_MSI_VEC_MAX ||
> +	    plat->msi_tx_base_vec >= STMMAC_MSI_VEC_MAX) {
> +		dev_info(&pdev->dev, "%s: Invalid RX & TX vector defined\n",
> +			 __func__);
> +		return -1;

free_irq_vectors?  Or move the check before alloc if possible.

> +	}


> @@ -699,6 +786,19 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
>  		writel(tx_lpi_usec, res.addr + GMAC_1US_TIC_COUNTER);
>  	}
>  
> +	ret = stmmac_config_multi_msi(pdev, plat, &res);
> +	if (!ret)
> +		goto msi_done;

Please don't use gotos where an if statement would do perfectly well.

> +	ret = stmmac_config_single_msi(pdev, plat, &res);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s: ERROR: failed to enable IRQ\n",
> +			__func__);
> +		return ret;

return? isn't there some cleanup that needs to happen before exiting?

> +	}
> +
> +msi_done:
> +
>  	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
>  	if (ret) {
>  		pci_free_irq_vectors(pdev);

