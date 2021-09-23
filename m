Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9C41660D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbhIWTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:43:16 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:46592 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbhIWTnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:43:15 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru E0B10208EDBF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
 <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
 <OS0PR01MB5922F3EE90E79FDB0703BCEC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <484f6f91-c34d-935d-1f42-456d01e9b8ca@omp.ru>
Date:   Thu, 23 Sep 2021 22:41:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922F3EE90E79FDB0703BCEC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 10:13 PM, Biju Das wrote:

[...]
>>> R-Car supports gPTP feature whereas RZ/G2L does not support it.
>>> This patch excludes gtp feature support for RZ/G2L by enabling no_gptp
>>> feature bit.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>>  drivers/net/ethernet/renesas/ravb_main.c | 46
>>> ++++++++++++++----------
>>>  1 file changed, 28 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index d38fc33a8e93..8663d83507a0 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> [...]
>>> @@ -953,7 +954,7 @@ static irqreturn_t ravb_interrupt(int irq, void
>> *dev_id)
>>>  	}
>>>
>>>  	/* gPTP interrupt status summary */
>>> -	if (iss & ISS_CGIS) {
>>
>>    Isn't this bit always 0 on RZ/G2L?
> 
> This CGIM bit(BIT13) which is present on R-Car Gen3 is not present in RZ/G2L. As per the HW manual
> BIT13 is reserved bit and read is always 0.
> 
>>
>>> +	if (!info->no_gptp && (iss & ISS_CGIS)) {

   Then extending this check doesn't seem necessary?

>>>  		ravb_ptp_interrupt(ndev);
>>>  		result = IRQ_HANDLED;
>>>  	}
[...]
>>> @@ -2116,6 +2119,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
>>>  	.emac_init = ravb_rgeth_emac_init,
>>>  	.aligned_tx = 1,
>>>  	.tx_counters = 1,
>>> +	.no_gptp = 1,
>>
>>    Mhm, I definitely don't like the way you "extend" the GbEthernet info
>> structure. All the applicable flags should be set in the last patch of the
>> series, not amidst of it.
> 
> According to me, It is clearer with smaller patches like, what we have done with previous 2 patch sets for factorisation.
> Please correct me, if any one have different opinion.

   I'm afraid you'd get a partly functioning device with the RZ/G2 info introduced amidst of the series
and then the necessary flags/values added to it. This should definitely be avoided.

> Regards,
> Biju

MBR, Sergey
