Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5D3EF317
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhHQULs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:11:48 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:48708 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQULq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 16:11:46 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 8895520BC0DB
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
 <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922A841D2C8E38D93A8E95086FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <071f3fd9-7280-f518-3e38-6456632cc11e@omp.ru>
Date:   Tue, 17 Aug 2021 23:11:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922A841D2C8E38D93A8E95086FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 2:24 PM, Biju Das wrote:

[...]
>>>>> -----Original Message-----
>>>>> On Mon, Aug 2, 2021 at 12:27 PM Biju Das
>>>>> <biju.das.jz@bp.renesas.com>
>>>>> wrote:
>>>>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L
>>>>>> SoC are similar to the R-Car Ethernet AVB IP. With a few changes
>>>>>> in the driver we can support both IPs.
>>>>>>
>>>>>> Currently a runtime decision based on the chip type is used to
>>>>>> distinguish the HW differences between the SoC families.
>>>>>>
>>>>>> The number of TX descriptors for R-Car Gen3 is 1 whereas on
>>>>>> R-Car
>>>>>> Gen2 and RZ/G2L it is 2. For cases like this it is better to
>>>>>> select the number of TX descriptors by using a structure with a
>>>>>> value, rather than a runtime decision based on the chip type.
>>>>>>
>>>>>> This patch adds the num_tx_desc variable to struct ravb_hw_info
>>>>>> and also replaces the driver data chip type with struct
>>>>>> ravb_hw_info by moving chip type to it.
>>>>>>
>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>> Reviewed-by: Lad Prabhakar
>>>>>> <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>>>
>>>>> Thanks for your patch!
>>>>>
>>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>>> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>>>>>>         RCAR_GEN3,
>>>>>>  };
>>>>>>
>>>>>> +struct ravb_hw_info {
>>>>>> +       enum ravb_chip_id chip_id;
>>>>>> +       int num_tx_desc;
>>>>>
>>>>> Why not "unsigned int"? ...
>>>>> This comment applies to a few more subsequent patches.
>>>>
>>>> To avoid signed and unsigned comparison warnings.
>>>>
>>>>>
>>>>>> +};
>>>>>> +
>>>>>>  struct ravb_private {
>>>>>>         struct net_device *ndev;
>>>>>>         struct platform_device *pdev; @@ -1040,6 +1045,8 @@
>>>>>> struct ravb_private {
>>>>>>         unsigned txcidm:1;              /* TX Clock Internal Delay
>>> Mode
>>>>> */
>>>>>>         unsigned rgmii_override:1;      /* Deprecated rgmii-*id
>>> behavior
>>>>> */
>>>>>>         int num_tx_desc;                /* TX descriptors per
>> packet
>>> */
>>>>>
>>>>> ... oh, here's the original culprit.
>>>>
>>>> Exactly, this the reason.
>>>>
>>>> Do you want me to change this into unsigned int? Please let me know.
>>>
>>> Up to you (or the maintainer? ;-)
>>>
>>> For new fields (in the other patches), I would use unsigned for all
>>> unsigned values.  Signed values have more pitfalls related to
>>> undefined behavior.
>>
>> Sergei, What is your thoughts here? Please let me know.
> 
> Here is my plan.
> 
> I will split this patch into two as Andrew suggested and 

   If you mran changing the ravb_private::num_tx_desc to *unsigned*, it'll be
a good cleanup. What's would be the 2nd part tho?

> Then on the second patch will add as info->unaligned_tx as Sergei suggested.

   OK.

> Now the only open point is related to the data type of "int num_tx_desc"
> and to align with sh_eth driver I will keep int.

   The sh_eth driver simply doesn't have this -- it always use 1 descriptor.

> Regards,
> Biju

MBR, Sergey
