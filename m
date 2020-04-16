Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5E1ABF10
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633015AbgDPLZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 07:25:32 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39140 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2632946AbgDPLZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 07:25:18 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03GBBqgN030064;
        Thu, 16 Apr 2020 06:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587035512;
        bh=k2DSChJsC5w+CN2J7vJJZEb4snfJnHNW2TEax9vEJxE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gsrVZ52WgX3/SSFrPRLL1lrPY58rVMmheeKgXIPDzVjmXLAObAK/LTdeY5alA5Z0b
         GQH+gXyvthVFqnRQhnXlCgFNI6FQMfJDimrawb3qzGOymtIouq+WKHdfiy/HqMw9Tc
         ENwgjYlewGgZOr0up4Zf0YMWGN3Mc0sJ1EVNG1eM=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03GBBqQI073223
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Apr 2020 06:11:52 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 16
 Apr 2020 06:11:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 16 Apr 2020 06:11:52 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03GBBjD0122831;
        Thu, 16 Apr 2020 06:11:48 -0500
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Clay McClure <clay@daemons.net>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200416085627.1882-1-clay@daemons.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
Date:   Thu, 16 Apr 2020 14:11:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416085627.1882-1-clay@daemons.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/04/2020 11:56, Clay McClure wrote:
> CPTS_MOD merely implies PTP_1588_CLOCK; it is possible to build cpts
> without PTP clock support. In that case, ptp_clock_register() returns
> NULL and we should not WARN_ON(cpts->clock) when downing the interface.
> The ptp_*() functions are stubbed without PTP_1588_CLOCK, so it's safe
> to pass them a null pointer.

Could you explain the purpose of the exercise (Enabling CPTS with PTP_1588_CLOCK disabled), pls?

> 
> Signed-off-by: Clay McClure <clay@daemons.net>
> ---
>   drivers/net/ethernet/ti/cpts.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
> index fd214f8730a9..daf4505f4a70 100644
> --- a/drivers/net/ethernet/ti/cpts.c
> +++ b/drivers/net/ethernet/ti/cpts.c
> @@ -646,7 +646,7 @@ EXPORT_SYMBOL_GPL(cpts_register);
>   
>   void cpts_unregister(struct cpts *cpts)
>   {
> -	if (WARN_ON(!cpts->clock))
> +	if (IS_REACHABLE(PTP_1588_CLOCK) && WARN_ON(!cpts->clock))
>   		return;
>   
>   	ptp_clock_unregister(cpts->clock);
> 

-- 
Best regards,
grygorii
