Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10B4A2DBA
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 11:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiA2KiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 05:38:06 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:36760 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA2KiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 05:38:05 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B94F522F7969
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] ravb: ravb_close() always returns 0
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>
References: <20220128203838.17423-1-s.shtylyov@omp.ru>
 <20220128203838.17423-2-s.shtylyov@omp.ru>
 <20220128135139.292aab45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <50b5fab3-6e06-165d-43eb-dc17c7b3ff99@omp.ru>
Date:   Sat, 29 Jan 2022 13:38:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220128135139.292aab45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/29/22 12:51 AM, Jakub Kicinski wrote:

>> ravb_close() always returns 0, hence the check in ravb_wol_restore() is
>> pointless (however, we cannot change the prototype of ravb_close() as it
>> implements the driver's ndo_stop() method).
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
>> analysis tool.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>> ---
>>  drivers/net/ethernet/renesas/ravb_main.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
>> index b215cde68e10..02fa8cfc2b7b 100644
>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> @@ -2863,9 +2863,7 @@ static int ravb_wol_restore(struct net_device *ndev)
>>  	/* Disable MagicPacket */
>>  	ravb_modify(ndev, ECMR, ECMR_MPDE, 0);
>>  
>> -	ret = ravb_close(ndev);
>> -	if (ret < 0)
>> -		return ret;
>> +	ravb_close(ndev);
>>  
>>  	return disable_irq_wake(priv->emac_irq);
>>  }
> 
> drivers/net/ethernet/renesas/ravb_main.c:2857:13: warning: unused variable ‘ret’ [-Wunused-variable]
>  2857 |         int ret;
>       |             ^~~

   Oops, sorry about that!
   This patch was created during the merge window and when it finally closed, I rushed
to send this series before the end of week, and forgot to sanity check it (thinking it
has been checked already)... :-/
   I'll fix and resend...

MBR, Sergey
