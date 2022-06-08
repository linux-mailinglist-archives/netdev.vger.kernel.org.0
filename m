Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621F5543EDE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiFHVrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFHVrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:47:46 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78580C59;
        Wed,  8 Jun 2022 14:47:42 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id CF7BA50486A;
        Thu,  9 Jun 2022 00:46:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru CF7BA50486A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1654724786; bh=R8MbAuHq/JqFY8/bX2UFTS/lEoJ4xg8CxPhif9CWD1o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=E6C2O6jWV7wzHGvLh2er/6dlbEf97E3UapkHAJ3cuRfxZLTALTBK1F6L+8hRS8Zmi
         dAiYbxNx5WpenewBH/FdmxUBsr0Pf6qVUF6nJLLUXVpZyu88oTNADc9XuiPZPpGMVy
         9YEUY66PLXqrNRkJsf63AS8Rf8hrATpZyGaRNoUw=
Message-ID: <3ec5fd68-a376-847a-2ad7-d352feea758c@novek.ru>
Date:   Wed, 8 Jun 2022 22:47:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 net-next 4/5] ptp_ocp: do not call
 pci_set_drvdata(pdev, NULL)
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-5-andriy.shevchenko@linux.intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220608120358.81147-5-andriy.shevchenko@linux.intel.com>
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
> Cleaning up driver data is actually already handled by driver core,
> so there is no need to do it manually.

I found a couple of places with exactly the same code in error path.
For example Marvell's OcteonX drivers in crypto and net subsystems.
Should we fix them too?

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Overall looks good.

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>

> ---
>   drivers/ptp/ptp_ocp.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 4e237f806085..857e35c68a04 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -3769,7 +3769,6 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   out:
>   	ptp_ocp_detach(bp);
> -	pci_set_drvdata(pdev, NULL);
>   out_disable:
>   	pci_disable_device(pdev);
>   out_free:
> @@ -3785,7 +3784,6 @@ ptp_ocp_remove(struct pci_dev *pdev)
>   
>   	devlink_unregister(devlink);
>   	ptp_ocp_detach(bp);
> -	pci_set_drvdata(pdev, NULL);
>   	pci_disable_device(pdev);
>   
>   	devlink_free(devlink);

