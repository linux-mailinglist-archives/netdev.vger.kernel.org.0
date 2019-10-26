Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4FE594E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 10:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJZI5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 04:57:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfJZI5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 04:57:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E1DEEA945B7A9401D90A;
        Sat, 26 Oct 2019 16:57:46 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 26 Oct 2019
 16:57:45 +0800
Subject: Re: [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
To:     Simon Horman <simon.horman@netronome.com>
References: <20191025133726.31796-1-yuehaibing@huawei.com>
 <20191026080929.GD31244@netronome.com>
CC:     <epomozov@marvell.com>, <igor.russkikh@aquantia.com>,
        <davem@davemloft.net>, <dmitry.bezrukov@aquantia.com>,
        <sergey.samoilenko@aquantia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <4edcf4c4-b8fc-00a1-5f13-6c41a27eb4a5@huawei.com>
Date:   Sat, 26 Oct 2019 16:57:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20191026080929.GD31244@netronome.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/26 16:09, Simon Horman wrote:
> On Fri, Oct 25, 2019 at 09:37:26PM +0800, YueHaibing wrote:
>> If PTP_1588_CLOCK is n, building fails:
>>
>> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c: In function aq_ptp_adjfine:
>> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:279:11:
>>  error: implicit declaration of function scaled_ppm_to_ppb [-Werror=implicit-function-declaration]
>>            scaled_ppm_to_ppb(scaled_ppm));
>>
>> Just cp scaled_ppm_to_ppb() from ptp_clock.c to fix this.
>>
>> Fixes: 910479a9f793 ("net: aquantia: add basic ptp_clock callbacks")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Hi YueHaibing,
> 
> thanks for your patch.
> 
> What is the motivation for not using the existing copy of this function?

I'm not sure if PTP_1588_CLOCK is needed at this config,
using the existing function need to PTP_1588_CLOCK is selected.

> 
>> ---
>>  drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
>> index 3ec0841..80c001d 100644
>> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
>> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
>> @@ -262,6 +262,26 @@ static void aq_ptp_tx_timeout_check(struct aq_ptp_s *aq_ptp)
>>  	}
>>  }
>>  
>> +static s32 scaled_ppm_to_ppb(long ppm)
>> +{
>> +	/*
>> +	 * The 'freq' field in the 'struct timex' is in parts per
>> +	 * million, but with a 16 bit binary fractional field.
>> +	 *
>> +	 * We want to calculate
>> +	 *
>> +	 *    ppb = scaled_ppm * 1000 / 2^16
>> +	 *
>> +	 * which simplifies to
>> +	 *
>> +	 *    ppb = scaled_ppm * 125 / 2^13
>> +	 */
>> +	s64 ppb = 1 + ppm;
>> +	ppb *= 125;
>> +	ppb >>= 13;
>> +	return (s32) ppb;
>> +}
>> +
>>  /* aq_ptp_adjfine
>>   * @ptp: the ptp clock structure
>>   * @ppb: parts per billion adjustment from base
>> -- 
>> 2.7.4
>>
>>
> 
> .
> 

