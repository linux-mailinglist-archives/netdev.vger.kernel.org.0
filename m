Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2751442C517
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhJMPsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:48:09 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:34764 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhJMPsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 11:48:08 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 49DD420DCD02
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
 <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
 <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <0517bd54-2da8-82cb-c844-bd5b73febd8f@omp.ru>
Date:   Wed, 13 Oct 2021 18:46:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 9:55 PM, Biju Das wrote:

[...]
>>>>>>> This patch enables Receive/Transmit port of TOE and removes the
>>>>>>> setting of promiscuous bit from EMAC configuration mode register.
>>>>>>>
>>>>>>> This patch also update EMAC configuration mode comment from "PAUSE
>>>>>>> prohibition" to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC
>>>>>>> Pass Through".
>>>>>>
>>>>>>    I'm not sure why you set ECMR.RCPT while you don't have the
>>>>>> checksum offloaded...
>>>>>>
>>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>>> ---
>>>>>>> v2->v3:
>>>>>>>  * Enabled TPE/RPE of TOE, as disabling causes loopback test to
>>>>>>> fail
>>>>>>>  * Documented CSR0 register bits
>>>>>>>  * Removed PRM setting from EMAC configuration mode
>>>>>>>  * Updated EMAC configuration mode.
>>>>>>> v1->v2:
>>>>>>>  * No change
>>>>>>> V1:
>>>>>>>  * New patch.
>>>>>>> ---
>>>>>>>  drivers/net/ethernet/renesas/ravb.h      | 6 ++++++
>>>>>>>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>>>>>>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>>>>> index 69a771526776..08062d73df10 100644
>>>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>>>> @@ -204,6 +204,7 @@ enum ravb_reg {
>>>>>>>  	TLFRCR	= 0x0758,
>>>>>>>  	RFCR	= 0x0760,
>>>>>>>  	MAFCR	= 0x0778,
>>>>>>> +	CSR0    = 0x0800,	/* RZ/G2L only */
>>>>>>>  };
>>>>>>>
>>>>>>>
>>>>>>> @@ -964,6 +965,11 @@ enum CXR31_BIT {
>>>>>>>  	CXR31_SEL_LINK1	= 0x00000008,
>>>>>>>  };
>>>>>>>
>>>>>>> +enum CSR0_BIT {
>>>>>>> +	CSR0_TPE	= 0x00000010,
>>>>>>> +	CSR0_RPE	= 0x00000020,
>>>>>>> +};
>>>>>>> +
>>>>>>
>>>>>>   Is this really needed if you have ECMR.RCPT cleared?
>>>>>
>>>>> Yes it is required. Please see the current log and log with the
>>>>> changes you suggested
>>>>>
>>>>> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
>>>>> [   39.646891] ravb 11c20000.ethernet eth0: Link is Down
>>>>> [   39.715127] ravb 11c30000.ethernet eth1: Link is Down
>>>>> [   39.895680] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-
>>>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-
>>>> ffffffff:07, irq=POLL)
>>>>> [   39.966370] Microchip KSZ9131 Gigabit PHY 11c30000.ethernet-
>>>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c30000.ethernet-
>>>> ffffffff:07, irq=POLL)
>>>>> [   42.988573] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>>>> [   42.995119] ravb 11c20000.ethernet eth0: Link is Up - 1Gbps/Full -
>>>> flow control off
>>>>> [   43.052541] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>>>>> [   43.055710] ravb 11c30000.ethernet eth1: Link is Up - 1Gbps/Full -
>>>> flow control off
>>>>>
>>>>> EXIT|PASS||[422391:43:00] ||
>>>>>
>>>>> root@smarc-rzg2l:/rzg2l-test-scripts#
>>>>>
>>>>>
>>>>> with the changes you suggested
>>>>> ----------------------------
>>>>>
>>>>> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
>>>>> [   23.300520] ravb 11c20000.ethernet eth0: Link is Down
>>>>> [   23.535604] ravb 11c30000.ethernet eth1: device will be stopped
>> after
>>>> h/w processes are done.
>>>>> [   23.547267] ravb 11c30000.ethernet eth1: Link is Down
>>>>> [   23.802667] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-
>>>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-
>>>> ffffffff:07, irq=POLL)
>>>>> [   24.031711] ravb 11c30000.ethernet eth1: failed to switch device to
>>>> config mode
>>>>> RTNETLINK answers: Connection timed out
>>>>>
>>>>> EXIT|FAIL||[422391:42:32] Failed to bring up ETH1||
>>>>>
>>>>> root@smarc-rzg2l:/rzg2l-test-scripts#
>>>>
>>>>    Hm... :-/
>>>>    What if you only clear ECMR.RCPT but continue to set CSR0?
>>>
>>> We already seen, RCPT=0, RCSC=1 with similar Hardware checksum
>>> function like R-Car, System crashes.
>>
>>    I didn't tell you to set ECMR.RCSC this time. :-)
> 
> Theoretically, It should work as it is. As we are not doing any hardware checksum,
> 
> H/W is just passing RX CSUM to TOE without any software intervention.
> 
> It is clearly mentioned in data sheet, it is HW controlled.
> 
> 25 RCPT B’0 R/W Reception CRC Pass Through
> 1: CRC of received frame is transferred to TOE.
> RCSC (auto calculation of checksum of received frame data part) function is disabled
> at this time.
> 0: CRC of received frame is not transferred to TOE.

   Ah, I think it's the (usual) checksum-vs-CRC mixup. I don't know why TOE needs CRC tho
but it's 4 bytes at the end of a frame, not having much toi do with the 2-byte checksums...

> Regards,
> Biju

[...]

MBR, Sergey
