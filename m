Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA718418B09
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhIZUrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:47:33 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:34712 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhIZUrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 16:47:33 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru CCA82208DC33
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
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
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
 <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
Date:   Sun, 26 Sep 2021 23:45:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/21 9:34 AM, Biju Das wrote:

>> -----Original Message-----
>> Subject: Re: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
>>
>> On 9/23/21 5:08 PM, Biju Das wrote:
>>
>>> R-Car AVB-DMAC supports timestamp feature.
>>> Add a timestamp hw feature bit to struct ravb_hw_info to add this
>>> feature only for R-Car.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  2 +
>>>  drivers/net/ethernet/renesas/ravb_main.c | 68
>>> +++++++++++++++---------
>>>  2 files changed, 45 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index ab4909244276..2505de5d4a28 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -1034,6 +1034,7 @@ struct ravb_hw_info {
>>>  	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii
>> selection */
>>>  	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
>>>  	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX
>> */
>>> +	unsigned timestamp:1;		/* AVB-DMAC has timestamp */
>>
>>    Isn't this a matter of the gPTP support as well, i.e. no separate flag
>> needed?
> 
> Agreed. Previously it is suggested to use timestamp. I will change it to as part of gPTP support cases.

   TIA. :-)

>>
>> [...]
>>> @@ -1089,6 +1090,7 @@ struct ravb_private {
>>>  	unsigned int num_tx_desc;	/* TX descriptors per packet */
>>>
>>>  	int duplex;
>>> +	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
>>
>>    Strange place to declare this...
> 
> Agreed. This has to be on later patch. Will move it.

   I only meant that these fields should go together with rx_ring[]. Apparently
we have a case of wrong patch ordering here (as this patch needs this field declared)...

>>>  	const struct ravb_hw_info *info;
>>>  	struct reset_control *rstc;
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 9c0d35f4b221..2c375002ebcb 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -949,11 +949,14 @@ static bool ravb_queue_interrupt(struct
>>> net_device *ndev, int q)
>>>
>>>  static bool ravb_timestamp_interrupt(struct net_device *ndev)  {
>>> +	struct ravb_private *priv = netdev_priv(ndev);
>>> +	const struct ravb_hw_info *info = priv->info;
>>>  	u32 tis = ravb_read(ndev, TIS);
>>>
>>>  	if (tis & TIS_TFUF) {
>>>  		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
>>> -		ravb_get_tx_tstamp(ndev);
>>> +		if (info->timestamp)
>>> +			ravb_get_tx_tstamp(ndev);
>>
>>    Shouldn't we just disable TIS.TFUF permanently instead for the non-gPTP
>> case?
> 
> Good catch. As ravb_dmac_init_rgeth(will be renamed to "ravb_dmac_init_gbeth") is not enabling this interrupt as it is not documented in RZ/G2L hardware manual.
> So this function never gets called for non-gPTP case.
> 
> I will remove this check.

   TIA!

> Regards,
> Biju

MBR, Sergey
