Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8F54557C0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhKRJLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:11:19 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:52080 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242855AbhKRJLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:11:00 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 591F620CDD6D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Message-ID: <6851a10a-e7cf-b533-ab9d-0df539bbba00@omp.ru>
Date:   Thu, 18 Nov 2021 12:07:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH -next] ethernet: renesas: Use div64_ul instead of do_div
To:     Yang Li <yang.lee@linux.alibaba.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1637203805-125780-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Language: en-US
Organization: Open Mobile Platform
In-Reply-To: <1637203805-125780-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

    Why you didn't Cc me (as a reviewer)?

On 18.11.2021 5:50, Yang Li wrote:

> do_div() does a 64-by-32 division. Here the divisor is an
> unsigned long which on some platforms is 64 bit wide. So use
> div64_ul instead of do_div to avoid a possible truncation.
> 
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:2742:1-7: WARNING:
> do_div() does a 64-by-32 division, please consider using div64_ul
> instead.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index b4c597f..2b89710 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2489,7 +2489,7 @@ static int ravb_set_gti(struct net_device *ndev)
>   		return -EINVAL;
>   
>   	inc = 1000000000ULL << 20;
> -	do_div(inc, rate);
> +	inc = div64_ul(inc, rate);

    Why not just:

	inc = div64_ul(1000000000ULL << 20, rate);

>   	if (inc < GTI_TIV_MIN || inc > GTI_TIV_MAX) {
>   		dev_err(dev, "gti.tiv increment 0x%llx is outside the range 0x%x - 0x%x\n",

MBR, Sergey
