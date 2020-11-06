Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB82A9585
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgKFLeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 06:34:25 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39670 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgKFLeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 06:34:23 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A6BXrpT076586;
        Fri, 6 Nov 2020 05:33:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604662434;
        bh=DcQpD/+WVWEG8zUZCk/U6AoWPUg3QwRD4/zJ7DpRABA=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=Tcg+Vtw1XcBAGyHpmM5ODdc7C/XQ8UsBEX8CLXtl5BAWv+FJvK15YMV43NEx6kHWp
         pKXDEyYeRnpJdAKhJUsu0StbhAMrupaRZiIXgn7nzZCpdprUK7cVnzDzxJMZ/dtfbH
         jHemuLSH2N/fOMHIoo4TqOznKjdawLR5U13eIG4U=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A6BXrGr058656
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Nov 2020 05:33:53 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 6 Nov
 2020 05:33:53 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 6 Nov 2020 05:33:53 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A6BXoea087317;
        Fri, 6 Nov 2020 05:33:51 -0600
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
To:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
Date:   Fri, 6 Nov 2020 13:34:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/11/2020 09:56, Wang Qing wrote:
> We always have to update the value of ret, otherwise the
>   error value may be the previous one.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>   drivers/net/ethernet/ti/am65-cpts.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index 75056c1..b77ff61
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,

there is
	cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);


>   	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {

And ptp_clock_register() can return NULL only if PTP support is disabled.
In which case, we should not even get here.

So, I'd propose to s/IS_ERR_OR_NULL/IS_ERR above,
and just assign ret = PTR_ERR(cpts->ptp_clock) here.

>   		dev_err(dev, "Failed to register ptp clk %ld\n",
>   			PTR_ERR(cpts->ptp_clock));
> -		if (!cpts->ptp_clock)
> -			ret = -ENODEV;
> +		ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
>   		goto refclk_disable;
>   	}
>   	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
> 

-- 
Best regards,
grygorii
