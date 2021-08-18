Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3933F0162
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHRKMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:12:30 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:60846 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhHRKM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 06:12:28 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 95F0920EF7AC
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
 <071f3fd9-7280-f518-3e38-6456632cc11e@omp.ru>
 <OS0PR01MB59225D98CEA7E2E0FD959B3186FF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <dcbf2171-080c-d743-6aeb-6936b498d1fd@omp.ru>
Date:   Wed, 18 Aug 2021 13:11:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59225D98CEA7E2E0FD959B3186FF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 18.08.2021 9:29, Biju Das wrote:

[...]
>>>>>>> -----Original Message-----
>>>>>>> On Mon, Aug 2, 2021 at 12:27 PM Biju Das
>>>>>>> <biju.das.jz@bp.renesas.com>
>>>>>>> wrote:
>>>>>>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L
>>>>>>>> SoC are similar to the R-Car Ethernet AVB IP. With a few changes
>>>>>>>> in the driver we can support both IPs.
>>>>>>>>
>>>>>>>> Currently a runtime decision based on the chip type is used to
>>>>>>>> distinguish the HW differences between the SoC families.
>>>>>>>>
>>>>>>>> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car
>>>>>>>> Gen2 and RZ/G2L it is 2. For cases like this it is better to
>>>>>>>> select the number of TX descriptors by using a structure with a
>>>>>>>> value, rather than a runtime decision based on the chip type.
>>>>>>>>
>>>>>>>> This patch adds the num_tx_desc variable to struct ravb_hw_info
>>>>>>>> and also replaces the driver data chip type with struct
>>>>>>>> ravb_hw_info by moving chip type to it.
>>>>>>>>
>>>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>>>> Reviewed-by: Lad Prabhakar
>>>>>>>> <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>>>>>
>>>>>>> Thanks for your patch!
>>>>>>>
>>>>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>>>>> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>>>>>>>>          RCAR_GEN3,
>>>>>>>>   };
>>>>>>>>
>>>>>>>> +struct ravb_hw_info {
>>>>>>>> +       enum ravb_chip_id chip_id;
>>>>>>>> +       int num_tx_desc;
>>>>>>>
>>>>>>> Why not "unsigned int"? ...
>>>>>>> This comment applies to a few more subsequent patches.
>>>>>>
>>>>>> To avoid signed and unsigned comparison warnings.
>>>>>>
>>>>>>>
>>>>>>>> +};
>>>>>>>> +
>>>>>>>>   struct ravb_private {
>>>>>>>>          struct net_device *ndev;
>>>>>>>>          struct platform_device *pdev; @@ -1040,6 +1045,8 @@
>>>>>>>> struct ravb_private {
>>>>>>>>          unsigned txcidm:1;              /* TX Clock Internal Delay
>>>>> Mode
>>>>>>> */
>>>>>>>>          unsigned rgmii_override:1;      /* Deprecated rgmii-*id
>>>>> behavior
>>>>>>> */
>>>>>>>>          int num_tx_desc;                /* TX descriptors per
>>>> packet
>>>>> */
>>>>>>>
>>>>>>> ... oh, here's the original culprit.
>>>>>>
>>>>>> Exactly, this the reason.
>>>>>>
>>>>>> Do you want me to change this into unsigned int? Please let me know.
>>>>>
>>>>> Up to you (or the maintainer? ;-)
>>>>>
>>>>> For new fields (in the other patches), I would use unsigned for all
>>>>> unsigned values.  Signed values have more pitfalls related to
>>>>> undefined behavior.
>>>>
>>>> Sergei, What is your thoughts here? Please let me know.
>>>
>>> Here is my plan.
>>>
>>> I will split this patch into two as Andrew suggested and
>>
>>     If you mran changing the ravb_private::num_tx_desc to *unsigned*, it'll
>> be a good cleanup. What's would be the 2nd part tho?
> 
> OK in that case, I will split this patch into 3.
> 
> First patch for adding struct ravb_hw_info to driver data and replace
> driver data chip type with struct ravb_hw_info

    Couldn't this be a 2nd patch?..

> Second patch for changing ravb_private::num_tx_desc from int to unsigned int.

    ... and this one the 1st?

> Third patch for adding aligned_tx to struct ravb_hw_info.
> 
> Regards,
> Biju

MBR, Sergey
