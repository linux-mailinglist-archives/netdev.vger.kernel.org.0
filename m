Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDD344B9F2
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 02:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhKJBgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 20:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhKJBgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 20:36:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5BC061764;
        Tue,  9 Nov 2021 17:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=+XZw4yRVZS/bKZWFEmNoHapyqN9V6ZLi69kqtxe/LOk=; b=RGUszAtH1fnG4zhManmjgok6wP
        N1itJxhF8WfU/ZgaijWWahGZnfitm5AaMEgFwK7kKCbfMVp8d5KEWvm3iMBuaMZlk/o6X0bftDiIQ
        JYsrHDGRRGTPYXEw7cN51hmIqh/DnVTs4AfssIzHCmYE2JAyDrNcW+dCMOBZDU1EY99XDgEK66afY
        EwHGJ6L6LFnnkK53m6Hd0mddFMwqhSJfBYrenTg6UUwbz6h0YeedfYwBwnLcXWsCTsFrLkE2HRkUk
        9kwmdhvfsNuWAXGcIvbCMN+Pu1++PcVHCl9OYbb+DGAzHSEJ0yUMRvhsT7kmMAegQA/Lz0jn7BURb
        qTN0ytIQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkcUG-008qM2-5W; Wed, 10 Nov 2021 01:33:16 +0000
Subject: Re: [PATCH net] net: ethernet: lantiq_etop: Fix compilation error
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <20211109222354.3688-1-olek2@wp.pl>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <af4c86bc-add3-1f88-c854-aba81251cf85@infradead.org>
Date:   Tue, 9 Nov 2021 17:33:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109222354.3688-1-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 2:23 PM, Aleksander Jan Bajkowski wrote:
> This fixes the error detected when compiling the driver.
> 
> Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>   drivers/net/ethernet/lantiq_etop.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> index 2258e3f19161..6433c909c6b2 100644
> --- a/drivers/net/ethernet/lantiq_etop.c
> +++ b/drivers/net/ethernet/lantiq_etop.c
> @@ -262,7 +262,7 @@ ltq_etop_hw_init(struct net_device *dev)
>   	/* enable crc generation */
>   	ltq_etop_w32(PPE32_CGEN, LQ_PPE32_ENET_MAC_CFG);
>   
> -	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
> +	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, priv->rx_burst_len);
>   
>   	for (i = 0; i < MAX_DMA_CHAN; i++) {
>   		int irq = LTQ_DMA_CH0_INT + i;
> 

Hi Aleksander,

That does indeed fix the first build problem that kernel test robot reported.

I was hoping that you would address the others also (quoting here):

    drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_probe':
>> drivers/net/ethernet/lantiq_etop.c:673:15: error: implicit declaration of function 'device_property_read_u32' [-Werror=implicit-function-declaration]
      673 |         err = device_property_read_u32(&pdev->dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
          |               ^~~~~~~~~~~~~~~~~~~~~~~~
    drivers/net/ethernet/lantiq_etop.c: At top level:
    drivers/net/ethernet/lantiq_etop.c:730:1: warning: no previous prototype for 'init_ltq_etop' [-Wmissing-prototypes]
      730 | init_ltq_etop(void)
          | ^~~~~~~~~~~~~
    drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
    drivers/net/ethernet/lantiq_etop.c:276:25: warning: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result' [-Wunused-result]
      276 |                         request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    drivers/net/ethernet/lantiq_etop.c:284:25: warning: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result' [-Wunused-result]
      284 |                         request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cc1: some warnings being treated as errors



If not, I can send the patch that I have prepared.

thanks.
-- 
~Randy
