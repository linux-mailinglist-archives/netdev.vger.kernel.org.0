Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8629469A
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 04:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440034AbgJUChQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 22:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440051AbgJUChE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 22:37:04 -0400
Received: from [10.44.0.192] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CD722251;
        Wed, 21 Oct 2020 02:37:02 +0000 (UTC)
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
To:     Andy Duan <fugang.duan@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
 <AM8PR04MB73153FA5CF4C0B88CE65EF87FF1C0@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   Greg Ungerer <gerg@linux-m68k.org>
Message-ID: <bdf3f11b-a62e-405c-fb7a-bcd7491937fd@linux-m68k.org>
Date:   Wed, 21 Oct 2020 12:37:10 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM8PR04MB73153FA5CF4C0B88CE65EF87FF1C0@AM8PR04MB7315.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On 21/10/20 12:19 pm, Andy Duan wrote:
> From: Greg Ungerer <gerg@linux-m68k.org> Sent: Wednesday, October 21, 2020 9:52 AM
>> Hi Andrew,
>>
>> Thanks for the quick response.
>>
>>
>> On 20/10/20 12:40 pm, Andrew Lunn wrote:
>>> On Tue, Oct 20, 2020 at 12:14:04PM +1000, Greg Ungerer wrote:
>>>> Hi Andrew,
>>>>
>>>> Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt
>>>> driven MDIO with polled IO") breaks the FEC driver on at least one of
>>>> the ColdFire platforms (the 5208). Maybe others, that is all I have
>>>> tested on so far.
>>>>
>>>> Specifically the driver no longer finds any PHY devices when it
>>>> probes the MDIO bus at kernel start time.
>>>>
>>>> I have pinned the problem down to this one specific change in this commit:
>>>>
>>>>> @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct
>> platform_device *pdev)
>>>>>      if (suppress_preamble)
>>>>>              fep->phy_speed |= BIT(7);
>>>>> +   /* Clear MMFR to avoid to generate MII event by writing MSCR.
>>>>> +    * MII event generation condition:
>>>>> +    * - writing MSCR:
>>>>> +    *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
>>>>> +    *        mscr_reg_data_in[7:0] != 0
>>>>> +    * - writing MMFR:
>>>>> +    *      - mscr[7:0]_not_zero
>>>>> +    */
>>>>> +   writel(0, fep->hwp + FEC_MII_DATA);
>>>>
>>>> At least by removing this I get the old behavior back and everything
>>>> works as it did before.
>>>>
>>>> With that write of the FEC_MII_DATA register in place it seems that
>>>> subsequent MDIO operations return immediately (that is FEC_IEVENT is
>>>> set) - even though it is obvious the MDIO transaction has not completed yet.
>>>>
>>>> Any ideas?
>>>
>>> Hi Greg
>>>
>>> This has come up before, but the discussion fizzled out without a
>>> final patch fixing the issue. NXP suggested this
>>>
>>> writel(0, fep->hwp + FEC_MII_DATA);
>>>
>>> Without it, some other FEC variants break because they do generate an
>>> interrupt at the wrong time causing all following MDIO transactions to
>>> fail.
>>>
>>> At the moment, we don't seem to have a clear understanding of the
>>> different FEC versions, and how their MDIO implementations vary.
>>
>> Based on Andy and Chris' comments is something like the attached patch what
>> we need?
> 
> Greg, imx28 platform also requires the flag.

Got it, thanks. I will update the patch. I won't resend a v2 just yet, 
wait and see if there is any other comments.

Regards
Greg


