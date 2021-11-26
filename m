Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1245445F674
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhKZVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:32:31 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:40158 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhKZVa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 16:30:28 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 734F720AD46A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 2/2] ravb: Add Rx checksum offload support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "Biju Das" <biju.das@bp.renesas.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
 <20211123133157.21829-3-biju.das.jz@bp.renesas.com>
 <912abe7c-3097-4d39-01b6-82385f001fa8@omp.ru>
 <OS0PR01MB592276607BD57AD29DEDB57F86629@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c48e2250-3fd1-dd0c-d187-6efc33609d15@omp.ru>
Date:   Sat, 27 Nov 2021 00:27:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB592276607BD57AD29DEDB57F86629@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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

On 11/25/21 1:15 PM, Biju Das wrote:

>>> TOE has hw support for calculating IP header checkum for IPV4 and
>>> TCP/UDP/ICMP checksum for both IPV4 and IPV6.
>>>
>>> This patch adds Rx checksum offload supported by TOE.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      |  4 +++
>>>  drivers/net/ethernet/renesas/ravb_main.c | 31
>>> ++++++++++++++++++++++++
>>>  2 files changed, 35 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index a96552348e2d..d0e5eec0636e 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
[...]
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index c2b92c6a6cd2..2533e3401593 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -720,6 +720,33 @@ static void ravb_get_tx_tstamp(struct net_device
[...]
>>> +	u8 *hw_csum;
>>> +
>>> +	/* The hardware checksum is contained in sizeof(__sum16) * 2 = 4
>> bytes
>>> +	 * appended to packet data. First 2 bytes is ip header csum and last
>>> +	 * 2 bytes is protocol csum.
>>> +	 */
>>> +	if (unlikely(skb->len < sizeof(__sum16) * 2))
>>> +		return;
>>> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
>>> +	csum_proto = csum_unfold((__force
>>> +__sum16)get_unaligned_le16(hw_csum));
>>> +
>>> +	hw_csum = skb_tail_pointer(skb) - 2 * sizeof(__sum16);
>>> +	csum_ip_hdr = csum_unfold((__force
>>> +__sum16)get_unaligned_le16(hw_csum));
>>> +
>>> +	skb->ip_summed = CHECKSUM_NONE;
>>> +	if (csum_proto == TOE_RX_CSUM_OK) {
>>> +		if (skb->protocol == htons(ETH_P_IP) && csum_ip_hdr ==
>> TOE_RX_CSUM_OK)
>>> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
>>> +		else if (skb->protocol == htons(ETH_P_IPV6) &&
>>> +			 csum_ip_hdr == TOE_RX_CSUM_UNSUPPORTED)
>>> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
>>
>>    Checksum is unsupported and you declare it unnecessary?
> 
> 
> Do you mean takeout the check for unsupported headercsum for IPV6 and the code like one below?

   No, I meant that the code looks strange. 

> If(!csum_proto) {
> 	if ((skb->protocol == htons(ETH_P_IP) && !csum_ip_hdr) || skb->protocol == htons(ETH_P_IPV6))

   I think this statement doesn't make sense, unless the TOE itself doesn't check the protocol ID in
the Ethernet frame (which it should). It also seems (after reading <linux/skbuff.h>) that enabling
IPv4 header checksum calculation is pointless -- you don't have the means to report it anyway...
You may want to set skb-csum_level though (not sure if that's not already 0).

> 		skb->ip_summed = CHECKSUM_UNNECESSARY;
> }
> 
> Snippet from H/W manual for reception handling
> 
> (1) Reception Handling
> The result of Checksum Calculation is attached to last 4 byte of Ethernet Frames like Figure 30.25. And then the 
> handled frames are transferred to memory by DMAC. If the frame does not have checksum error at the part of IPv4 
> Header or TCP/UDP/ICMP, the value of “0000h” is attached to each part as the result of Checksum Calculation. The 
> case of Unsupported Frame, the value of “FFFFh” is attached. For example, if the part of IP Header is unsupported, 
> “FFFFh” is set to both field of IPv4 Header and TCP/UDP/ICMP. The case of IPv6, IPv4 Header field is always set to 
> “FFFFh”. 
> 
>  
>>
>>> +	}
>>
>>    Now where's a call to skb_trim()?
> 
> Currently I haven't seen any issue without using skb_trim.
> 
> OK, as you suggested, will check and add skb_trim to takeout the last 4bytes.

   We do it for EtherAVB, why not do it for GbEther?

> Regards,
> Biju

MBR, Sergey
