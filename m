Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1FD14F2FA
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgAaT52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:57:28 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57064 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaT51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 14:57:27 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VJvN6m083311;
        Fri, 31 Jan 2020 13:57:23 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580500643;
        bh=aKowKe42ihGou9BZv9xiLNDP/sParsGV17KSoR247LQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gj+D0AFE/W8Z1nTAgJa+J/leeSZHLH52eL7OyBUSPlWn1P40o8H70It5fpaHF3hhx
         mSw5JfG/ypw/8fYKVO8DRW0RuE6oNSffQqNI7zyTp+GdTz+hvjKs72obdElTbTYHeJ
         qJefTnLOc+wcuQVsrYIOKvY+Wi1ycoJ7q2Gvc+fM=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VJvNs2051034
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 13:57:23 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 13:57:22 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 13:57:22 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VJvMZJ044834;
        Fri, 31 Jan 2020 13:57:22 -0600
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
 <d03b5867-a55b-9abc-014f-69ce156b09f3@ti.com>
 <5c956a5a-cd83-f290-9995-6ea35383f5f0@gmail.com>
 <516ae353-e068-fe5e-768f-52308ef670a9@ti.com>
 <77b55164-5fc3-6022-be72-4d58ef897019@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <07701542-2a94-7333-6682-a8e8986ea6d4@ti.com>
Date:   Fri, 31 Jan 2020 13:54:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <77b55164-5fc3-6022-be72-4d58ef897019@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 1/31/20 1:29 PM, Florian Fainelli wrote:
> On 1/31/20 11:14 AM, Dan Murphy wrote:
>> Florian
>>
>> On 1/31/20 12:42 PM, Florian Fainelli wrote:
>>> On 1/31/20 10:29 AM, Dan Murphy wrote:
>>>> Florian
>>>>
>>>> On 1/31/20 11:49 AM, Florian Fainelli wrote:
>>>>> On 1/31/20 7:11 AM, Dan Murphy wrote:
>>>>>> Set the speed optimization bit on the DP83867 PHY.
>>>>>> This feature can also be strapped on the 64 pin PHY devices
>>>>>> but the 48 pin devices do not have the strap pin available to enable
>>>>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>>> OK, but why and how does that optimization work exactly?
>>>> I described this in the cover letter.  And it is explained in the data
>>>> sheet Section 8.4.6.6
>>> Sorry I complete missed that and just focused on the patch, you should
>>> consider not providing a cover letter for a single patch, and especially
>>> not when the cover letter contains more information than the patch
>>> commit message itself.
>> Sorry I usually give a cover letter to all my network related patches.
>>
>> Unless I misinterpreted David on his reply to me about cover letters.
>>
>> https://www.spinics.net/lists/netdev/msg617575.html
> This was a 2 patches series, for which a cover letter is mandatory:
>
> but for single patches, there really is no need, and having to replicate
> the same information in two places is just error prone.
>
>> And I seemed to have missed David on the --cc list so I will add him for
>> v2.
>>
>> I was also asked not to provide the same information in the cover letter
>> and the commit message.
> The cover letter is meant to provide some background about choices you
> have made, or how to merge the patches, or their dependencies, and
> describe the changes in a big picture. The patches themselves are
> supposed to be comprehensive.

As always thank you for the guidance.  I will update the commit with 
better information and remove the cover letter.


>
>> Either way I am ok with not providing a cover letter and updating the
>> commit message with more information.
>>
>>
>>>>>     Departing from
>>>>> the BMSR reads means you possibly are going to introduce bugs and/or
>>>>> incomplete information. For instance, you set phydev->pause and
>>>>> phydev->asym_pause to 0 now, is there no way to extract what the link
>>>>> partner has advertised?
>>>> I was using the marvel.c as my template as it appears to have a separate
>>>> status register as well.
>>>>
>>>> Instead of setting those bits in the call back I can call the
>>>> genphy_read_status then override the duplex and speed based on the
>>>> physts register like below.  This way link status and pause values can
>>>> be updated and then we can update the speed and duplex settings.
>>>>
>>>>         ret = genphy_read_status(phydev);
>>>>       if (ret)
>>>>           return ret;
>>>>
>>>>       if (status < 0)
>>>>           return status;
>>>>
>>>>       if (status & DP83867_PHYSTS_DUPLEX)
>>>>           phydev->duplex = DUPLEX_FULL;
>>>>       else
>>>>           phydev->duplex = DUPLEX_HALF;
>>>>
>>>>       if (status & DP83867_PHYSTS_1000)
>>>>           phydev->speed = SPEED_1000;
>>>>       else if (status & DP83867_PHYSTS_100)
>>>>           phydev->speed = SPEED_100;
>>>>       else
>>>>           phydev->speed = SPEED_10;
>>>>
>>> OK, but what if they disagree, are they consistently latched with
>>> respect to one another?
>> Well in parsing through the code for genphy read status when auto
>> negotiation is set the phydev structure appears to be setup per what has
>> been configured.  I did not see any reading of speed or duplex when auto
>> neg is set it is just taking the LPA register. But I am probably not
>> right here.  So we and our customers found that the phy was always
>> reporting a 1Gbps connection when the 4 wire cable connected when using
>> genphy_read_status.  This PHYSTS register provides a single location
>> within the register set for quick access to commonly accessed
>> information.
> That is the kind of information that you want to put in the commit
> message, and that sounds like a Fix more than a feature to me. If the
> BMSR is not reflecting the correct speed, clearly something is not quite
> good. You may also consider reflecting whether downshift was in action
> and that led to reducing the speed, something like
> m88e1011_link_change_notify() does.

But what is it fixing?  When the driver was originally submitted it was 
meant to be a Giga bit PHY.  No requirement for any connection less then 
1Gbps. Now we have a customer who wants to use this feature and they 
want it upstreamed.  (YAY for them pushing upstream).

Do I reference my original commit?  Because I am actually flipping the 
bits to turn it on as well only way this was a fix is if the user had 
the feature strapped to on.  But to date we have not had any requests 
for this support.

So then it would be ok to do a genphy_read_status and then override the 
speed and duplex mode from the PHYSTS register?

I don't think that the link change notification is needed.  The speed 
should not change once the cable is plugged in and the speed is negotiated.

Dan


