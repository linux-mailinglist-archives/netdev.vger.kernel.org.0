Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2001F299ED3
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440808AbgJ0ARi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440744AbgJ0ARf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 20:17:35 -0400
Received: from [192.168.0.244] (118-211-2-196.tpgi.com.au [118.211.2.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1229520708;
        Tue, 27 Oct 2020 00:17:32 +0000 (UTC)
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
To:     Andy Duan <fugang.duan@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Dave Karr <dkarr@vyex.com>,
        Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
 <20201021133758.GL139700@lunn.ch>
 <16e85e61-ed25-c6be-ed4a-4c4708e724ea@linux-m68k.org>
 <AM8PR04MB731512CC1B16C307C4543B90FF1D0@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   Greg Ungerer <gerg@linux-m68k.org>
Message-ID: <a1f62ee2-3013-50fe-4069-e63f87a984ce@linux-m68k.org>
Date:   Tue, 27 Oct 2020 10:17:30 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM8PR04MB731512CC1B16C307C4543B90FF1D0@AM8PR04MB7315.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On 22/10/20 7:04 pm, Andy Duan wrote:
> From: Greg Ungerer <gerg@linux-m68k.org> Sent: Thursday, October 22, 2020 9:14 AM
>> Hi Andrew,
>>
>> On 21/10/20 11:37 pm, Andrew Lunn wrote:
>>>> +    if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
>>>> +            /* Clear MMFR to avoid to generate MII event by writing
>> MSCR.
>>>> +             * MII event generation condition:
>>>> +             * - writing MSCR:
>>>> +             *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
>>>> +             *        mscr_reg_data_in[7:0] != 0
>>>> +             * - writing MMFR:
>>>> +             *      - mscr[7:0]_not_zero
>>>> +             */
>>>> +            writel(0, fep->hwp + FEC_MII_DATA);
>>>> +    }
>>>
>>> Hi Greg
>>>
>>> The last time we discussed this, we decided that if you cannot do the
>>> quirk, you need to wait around for an MDIO interrupt, e.g. call
>>> fec_enet_mdio_wait() after setting FEC_MII_SPEED register.
>>>
>>>>
>>>>       writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>>
>> The code following this is:
>>
>>           writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>>
>>           /* Clear any pending transaction complete indication */
>>           writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
>>
>>
>> So this is forcing a clear of the event here. Is that not good enough?
>>
>> For me on my ColdFire test target I always get a timeout if I wait for a
>> FEC_IEVENT after the FEC_MII_SPEED write.
>>
>> Regards
>> Greg
> 
> Dave Karr's last patch can fix the issue, but it may introduce 30ms delay during boot.
> Greg's patch is to add quirk flag to distinguish platform before clearing mmfr operation,
> which also can fix the issue.

Do you mean that we can use either fix - and that is ok for all hardware 
types?

Regards
Greg

