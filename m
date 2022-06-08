Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428F2543ECA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiFHVqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFHVqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:46:22 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB68355010;
        Wed,  8 Jun 2022 14:46:20 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id AA68950486A;
        Thu,  9 Jun 2022 00:36:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru AA68950486A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1654724201; bh=iX5XhnoJ8IJeLdJYm71Tdp3Q8pDYLXJ2V7qlWvCBRro=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0c8hLYv9JJGlCMRjRNc1CUFUGTV6ZBloqA29nrnuYcjT2IscbwgvNMBk60ahCR/rF
         mrGgi42yAvTCYZ14hZH8VwrDqtjK6la97a+rnxb2tTPJGnDKp5egCcGyH5filuDLCl
         7WtB865QoSmM0eTxojCFuWYH9PMqwGEGelOuuFx4=
Message-ID: <5504ae89-befc-9db0-0cc5-6f425d5414be@novek.ru>
Date:   Wed, 8 Jun 2022 22:37:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2022 13:03, Andy Shevchenko wrote:
> Simplify the error path in ->probe() and unify message format a bit
> by using dev_err_probe().
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

LGTM

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>   drivers/ptp/ptp_ocp.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 4519ef42b458..17930762fde9 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -3722,14 +3722,12 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	int err;
>   
>   	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
> -	if (!devlink) {
> -		dev_err(&pdev->dev, "devlink_alloc failed\n");
> -		return -ENOMEM;
> -	}
> +	if (!devlink)
> +		return dev_err_probe(&pdev->dev, -ENOMEM, "devlink_alloc failed\n");
>   
>   	err = pci_enable_device(pdev);
>   	if (err) {
> -		dev_err(&pdev->dev, "pci_enable_device\n");
> +		dev_err_probe(&pdev->dev, err, "pci_enable_device\n");
>   		goto out_free;
>   	}
>   
> @@ -3745,7 +3743,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	 */
>   	err = pci_alloc_irq_vectors(pdev, 1, 17, PCI_IRQ_MSI | PCI_IRQ_MSIX);
>   	if (err < 0) {
> -		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
> +		dev_err_probe(&pdev->dev, err, "alloc_irq_vectors\n");
>   		goto out;
>   	}
>   	bp->n_irqs = err;
> @@ -3757,8 +3755,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	bp->ptp = ptp_clock_register(&bp->ptp_info, &pdev->dev);
>   	if (IS_ERR(bp->ptp)) {
> -		err = PTR_ERR(bp->ptp);
> -		dev_err(&pdev->dev, "ptp_clock_register: %d\n", err);
> +		err = dev_err_probe(&pdev->dev, PTR_ERR(bp->ptp), "ptp_clock_register\n");
>   		bp->ptp = NULL;
>   		goto out;
>   	}

