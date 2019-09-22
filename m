Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65778BA11C
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 07:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfIVFJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 01:09:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfIVFJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 01:09:12 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6BD0CFC1606C4BAC71CC;
        Sun, 22 Sep 2019 13:09:09 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sun, 22 Sep 2019
 13:09:06 +0800
Subject: Re: [PATCH net] net: ena: Add dependency for ENA_ETHERNET
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <netanel@amazon.com>, <saeedb@amazon.com>, <zorik@amazon.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>
References: <20190920084405.140750-1-maowenan@huawei.com>
 <20190921200741.1c3289e8@cakuba.netronome.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <256c3d2c-e900-8182-48e4-fb1cfcb53a74@huawei.com>
Date:   Sun, 22 Sep 2019 13:08:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190921200741.1c3289e8@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/9/22 11:07, Jakub Kicinski wrote:
> On Fri, 20 Sep 2019 16:44:05 +0800, Mao Wenan wrote:
>> If CONFIG_ENA_ETHERNET=y and CONFIG_DIMLIB=n,
>> below erros can be found:
>> drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_dim_work':
>> ena_netdev.c:(.text+0x21cc): undefined reference to `net_dim_get_rx_moderation'
>> ena_netdev.c:(.text+0x21cc): relocation truncated to
>> fit: R_AARCH64_CALL26 against undefined symbol `net_dim_get_rx_moderation'
>> drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_io_poll':
>> ena_netdev.c:(.text+0x7bd4): undefined reference to `net_dim'
>> ena_netdev.c:(.text+0x7bd4): relocation truncated to fit:
>> R_AARCH64_CALL26 against undefined symbol `net_dim'
>>
>> After commit 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive
>> interrupt moderation"), it introduces dim algorithm, which configured by CONFIG_DIMLIB.
>>
>> Fixes: 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive interrupt moderation")
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> Thank you Mao, shortly after you posted your patch Uwe proposed to make
> DIMLIB a hidden symbol:
> 
> https://lore.kernel.org/netdev/a85be675-ce56-f7ba-29e9-b749073aab6c@kleine-koenig.org/T/#t
> 
> That patch will likely be applied soon, could you please rework your
> patch to use the "select" keyword instead of "depends". That's what
> other users do.

Ok, I will send v2.
> 
>> diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
>> index 69ca99d..fe46df4 100644
>> --- a/drivers/net/ethernet/amazon/Kconfig
>> +++ b/drivers/net/ethernet/amazon/Kconfig
>> @@ -18,7 +18,7 @@ if NET_VENDOR_AMAZON
>>  
>>  config ENA_ETHERNET
>>  	tristate "Elastic Network Adapter (ENA) support"
>> -	depends on PCI_MSI && !CPU_BIG_ENDIAN
>> +	depends on PCI_MSI && !CPU_BIG_ENDIAN && DIMLIB
>>  	---help---
>>  	  This driver supports Elastic Network Adapter (ENA)"
>>  
> 
> 
> .
> 

