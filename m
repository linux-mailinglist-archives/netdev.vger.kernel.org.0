Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB62B7045
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgKQUjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:39:07 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:51811 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgKQUjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:39:06 -0500
Received: from [192.168.1.41] ([92.131.86.32])
        by mwinf5d57 with ME
        id tYf4230020hrljw03Yf4ha; Tue, 17 Nov 2020 21:39:04 +0100
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 17 Nov 2020 21:39:04 +0100
X-ME-IP: 92.131.86.32
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>, jcliburn@gmail.com,
        chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, yanaijie@huawei.com, mst@redhat.com,
        leon@kernel.org, jesse.brandeburg@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <83ee32e6-9460-a1f1-8065-6e737edb5402@wanadoo.fr>
Date:   Tue, 17 Nov 2020 21:39:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 17/11/2020 à 03:55, Zhang Changzhong a écrit :
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
Hi, should it have any importance, the Fixes tag is wrong.

The issue was already there before 85eb5bc33717 which was just a 
mechanical update.

just my 2c

CJ

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>   drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 0c12cf7..3f65f2b 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	 * various kernel subsystems to support the mechanics required by a
>   	 * fixed-high-32-bit system.
>   	 */
> -	if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
> -	    (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (err) {
>   		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
>   		goto err_dma;
>   	}
