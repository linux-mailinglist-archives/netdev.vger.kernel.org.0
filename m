Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B7607424
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJUJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJUJfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:35:13 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E013913FDF8;
        Fri, 21 Oct 2022 02:35:09 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 21 Oct 2022 18:35:09 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 1B97620584CE;
        Fri, 21 Oct 2022 18:35:09 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 21 Oct 2022 18:35:09 +0900
Received: from [10.212.242.61] (unknown [10.212.242.61])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 92D0DB62B3;
        Fri, 21 Oct 2022 18:35:08 +0900 (JST)
Subject: Re: [PATCH net] net: phy: Avoid WARN_ON for PHY_NOLINK during
 resuming
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221021074154.25906-1-hayashi.kunihiko@socionext.com>
 <4d2d6349-6910-3e73-e6c5-db9041bcfdb8@gmail.com>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <86262217-a620-dc5b-cf5a-3a23ea869834@socionext.com>
Date:   Fri, 21 Oct 2022 18:35:09 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4d2d6349-6910-3e73-e6c5-db9041bcfdb8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

Thank you for your comment.

On 2022/10/21 17:38, Heiner Kallweit wrote:
> On 21.10.2022 09:41, Kunihiko Hayashi wrote:
>> When resuming from sleep, if there is a time lag from link-down to link-up
>> due to auto-negotiation, the phy status has been still PHY_NOLINK, so
>> WARN_ON dump occurs in mdio_bus_phy_resume(). For example, UniPhier AVE
>> ethernet takes about a few seconds to link up after resuming.
>>
> That autoneg takes some time is normal. If this would actually the root
> cause then basically every driver should be affected. But it's not.

Although the auto-neg should happen normally, I'm not sure about other
platforms.

>> To avoid this issue, should remove PHY_NOLINK the WARN_ON conditions.
>>
>> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> ---
>>   drivers/net/phy/phy_device.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 57849ac0384e..c647d027bb5d 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -318,12 +318,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct
>> device *dev)
>>   	phydev->suspended_by_mdio_bus = 0;
>>
>>   	/* If we managed to get here with the PHY state machine in a state
>> -	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
>> -	 * that something went wrong and we should most likely be using
>> -	 * MAC managed PM, but we are not.
>> +	 * neither PHY_HALTED, PHY_READY, PHY_UP nor PHY_NOLINK, this is an
>> +	 * indication that something went wrong and we should most likely
>> +	 * be using MAC managed PM, but we are not.
>>   	 */
> 
> Did you read the comment you're changing? ave_resume() calls phy_resume(),
> so you should follow the advice in the comment.

I understand something is wrong with "PHY_NOLINK" here, and need to investigate
the root cause of the phy state issue.

Thank you,

---
Best Regards
Kunihiko Hayashi
