Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869FE1BE07C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgD2OQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:16:06 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:15306 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgD2OQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588169765; x=1619705765;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fUIXPujQe0+9QpgzpvomVP/BdpWJkMkzfXPolLDQ6R0=;
  b=hIiC1FDC/Dd+UN4XMsnNauC5T/W7ZM/ALBkkIROeT5HarED2Zv02YTxQ
   yEUsCKeTsJPakd9Qfk/LO8ZfjKssGRj8vsUzWrMRqP4fpEQHEPnKHJJFn
   0+CvwlGGj3cUdVGOdZgSFQbjWhUQIyDAaZhi5kRhR1rjwyk0cwAkBul3Y
   jpAuaiYTuILPwQnMy+rVTIPu5RT8lWNYk4YFp+/RMoS2dWF85gq81lfg4
   sOAM77qfO9oS99p42OVmjcxJss+U8M8/jmx64DHrkySC4p37wFaHufrZm
   8ybBCcEfHsusTirpnDYhnHJ8OfCrUEpCZCELZvJtL8kh75mVW5Ous/8jc
   A==;
IronPort-SDR: C29Q0VgoMsJXcLV7bfoL0uqaItF7K9hkaz9JgETNTvrIcskJOJ2ykCdh2XNZllOQyA7osCm6Wu
 64bNCk/stk/Si0pFz1ijBTEAywYeyCJEM84YekOle0LVirYepVo/xsbZ68Mpl5KbW1zVGbzHMX
 LvgxicFjNJJRlqxEu/O+zAk0mX4Xe0px+Yb5qf2I/adJzvLwmuONtRL0/6SQvU9AOeYK7xlySY
 9PCRT515OlSSdqZCcT8khlUD6lbLZi42JwMX9sBIia2QyNGdVXPsZD7Toy3kZFodl82EkqaDkL
 4l4=
X-IronPort-AV: E=Sophos;i="5.73,332,1583218800"; 
   d="scan'208";a="74958230"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Apr 2020 07:16:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 29 Apr 2020 07:16:03 -0700
Received: from [10.205.29.86] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 29 Apr 2020 07:16:01 -0700
Subject: Re: [PATCH net v2] net: macb: fix an issue about leak related system
 resources
To:     Dejin Zheng <zhengdejin5@gmail.com>, <davem@davemloft.net>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <yash.shah@sifive.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <20200429135651.32635-1-zhengdejin5@gmail.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <3ed83017-f3de-b6b0-91d0-d9075ad9eed5@microchip.com>
Date:   Wed, 29 Apr 2020 16:15:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429135651.32635-1-zhengdejin5@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2020 at 15:56, Dejin Zheng wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> A call of the function macb_init() can fail in the function
> fu540_c000_init. The related system resources were not released
> then. use devm_platform_ioremap_resource() to replace ioremap()
> to fix it.
> 
> Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Yash Shah <yash.shah@sifive.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v1 -> v2:
>          - Nicolas and Andy suggest use devm_platform_ioremap_resource()
>            to repalce devm_ioremap() to fix this issue. Thanks Nicolas
>            and Andy.
>          - Yash help me to review this patch, Thanks Yash!
> 
>   drivers/net/ethernet/cadence/macb_main.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a0e8c5bbabc0..99354e327d1f 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4172,13 +4172,7 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
> 
>   static int fu540_c000_init(struct platform_device *pdev)
>   {
> -       struct resource *res;
> -
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       if (!res)
> -               return -ENODEV;
> -
> -       mgmt->reg = ioremap(res->start, resource_size(res));
> +       mgmt->reg = devm_platform_ioremap_resource(pdev, 1);
>          if (!mgmt->reg)

Is your test valid then?

Please use:
if (IS_ERR(base))
    return PTR_ERR(base);
As advised by:
lib/devres.c:156

Regards,
   Nicolas

>                  return -ENOMEM;
> 
> --
> 2.25.0
> 


-- 
Nicolas Ferre
