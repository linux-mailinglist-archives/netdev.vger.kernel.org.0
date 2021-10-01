Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0077441E970
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhJAJPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:15:25 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:56012 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhJAJPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 05:15:23 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 6FAB5210DAC4
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
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
 <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
 <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
 <OS0PR01MB59221BB67442BD5CA5898D9E86AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <3fb8b4e0-e9d6-5ddf-2eae-1d1117dd668f@omp.ru>
Date:   Fri, 1 Oct 2021 12:13:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59221BB67442BD5CA5898D9E86AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.2021 9:53, Biju Das wrote:

[...]
>>> This patch adds set_feature support for RZ/G2L.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>>   drivers/net/ethernet/renesas/ravb.h      | 32 ++++++++++++++
>>>   drivers/net/ethernet/renesas/ravb_main.c | 56
>>> +++++++++++++++++++++++-
>>>   2 files changed, 87 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index d42e8ea981df..2275f27c0672 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -209,6 +209,8 @@ enum ravb_reg {
>>>   	CXR56	= 0x0770,	/* Documented for RZ/G2L only */
>>>   	MAFCR	= 0x0778,
>>>   	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
>>> +	CSR1     = 0x0804,	/* Documented for RZ/G2L only */
>>> +	CSR2     = 0x0808,	/* Documented for RZ/G2L only */
>>
>>     These are the TOE regs (CSR0 included), they only exist on RZ/G2L, no?
> 
> See just one line above you can see CSR0 registers and comments on the right clearly
> mentions "/* Documented for RZ/G2L only */

    What I meant was commenting on them as /* RZ/GL2 only */ or some such. 
Sorry for not being clear enough.

> OK will do CSR0 initialisation as part of this patch instead of patch #10.

    TIA!

>> [...]
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 72aea5875bc5..641ae5553b64 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> [...]
>>> @@ -2290,7 +2308,38 @@ static void ravb_set_rx_csum(struct net_device
>>> *ndev, bool enable)  static int ravb_set_features_rgeth(struct
>> net_device *ndev,
>>>   				   netdev_features_t features)
>>>   {
>>> -	/* Place holder */
>>> +	netdev_features_t changed = features ^ ndev->features;
>>> +	unsigned int reg;
>>
>>     u32 reg;
>>
>>> +	int error;
>>> +
>>> +	reg = ravb_read(ndev, CSR0);
>>
>>     ... as this function returns u32.

    I'm even suggesting to call this variable 'csr0'.

[...]

> Regards,
> Biju

MBR, Sergey
