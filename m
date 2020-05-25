Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B61E184C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgEYXmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:42:52 -0400
Received: from foss.arm.com ([217.140.110.172]:45214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEYXmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:42:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7902131B;
        Mon, 25 May 2020 16:42:51 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28BC03F305;
        Mon, 25 May 2020 16:42:51 -0700 (PDT)
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220127.GO1551@shell.armlinux.org.uk>
 <a9490c28-ebe1-ed6d-e65e-2e1d0a06386b@arm.com>
 <20200525230946.GR1551@shell.armlinux.org.uk>
 <ab756571-b269-ba7f-8e23-053098d9f470@arm.com>
 <20200525233335.GT1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <269de1a4-57cf-b175-3184-2f4604255bf7@arm.com>
Date:   Mon, 25 May 2020 18:42:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525233335.GT1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/25/20 6:33 PM, Russell King - ARM Linux admin wrote:
> On Mon, May 25, 2020 at 06:22:19PM -0500, Jeremy Linton wrote:
>> On 5/25/20 6:09 PM, Russell King - ARM Linux admin wrote:
>>> On Mon, May 25, 2020 at 05:22:07PM -0500, Jeremy Linton wrote:
>>>> On 5/25/20 5:01 PM, Russell King - ARM Linux admin wrote:
>>>>> On Mon, May 25, 2020 at 04:51:16PM -0500, Jeremy Linton wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 5/25/20 5:06 AM, Russell King - ARM Linux admin wrote:
>>>>>>> On Sun, May 24, 2020 at 10:34:13PM -0500, Jeremy Linton wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 5/23/20 1:37 PM, Russell King - ARM Linux admin wrote:
>>>>>>>>> On Fri, May 22, 2020 at 04:30:52PM -0500, Jeremy Linton wrote:
>>>>>>>>>> Until this point, we have been sanitizing the c22
>>>>>>>>>> regs presence bit out of all the MMD device lists.
>>>>>>>>>> This is incorrect as it causes the 0xFFFFFFFF checks
>>>>>>>>>> to incorrectly fail. Further, it turns out that we
>>>>>>>>>> want to utilize this flag to make a determination that
>>>>>>>>>> there is actually a phy at this location and we should
>>>>>>>>>> be accessing it using c22.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>>>>>>>>> ---
>>>>>>>>>>       drivers/net/phy/phy_device.c | 16 +++++++++++++---
>>>>>>>>>>       1 file changed, 13 insertions(+), 3 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>>>>>>>>> index f0761fa5e40b..2d677490ecab 100644
>>>>>>>>>> --- a/drivers/net/phy/phy_device.c
>>>>>>>>>> +++ b/drivers/net/phy/phy_device.c
>>>>>>>>>> @@ -689,9 +689,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
>>>>>>>>>>       		return -EIO;
>>>>>>>>>>       	*devices_in_package |= phy_reg;
>>>>>>>>>> -	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
>>>>>>>>>> -	*devices_in_package &= ~BIT(0);
>>>>>>>>>> -
>>>>>>>>>>       	return 0;
>>>>>>>>>>       }
>>>>>>>>>> @@ -742,6 +739,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>>>>>>>>>       	int i;
>>>>>>>>>>       	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>>>>>>>>>>       	u32 *devs = &c45_ids->devices_in_package;
>>>>>>>>>> +	bool c22_present = false;
>>>>>>>>>> +	bool valid_id = false;
>>>>>>>>>>       	/* Find first non-zero Devices In package. Device zero is reserved
>>>>>>>>>>       	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>>>>>>>>>> @@ -770,6 +769,10 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>>>>>>>>>       		return 0;
>>>>>>>>>>       	}
>>>>>>>>>> +	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
>>>>>>>>>> +	c22_present = *devs & BIT(0);
>>>>>>>>>> +	*devs &= ~BIT(0);
>>>>>>>>>> +
>>>>>>>>>>       	/* Now probe Device Identifiers for each device present. */
>>>>>>>>>>       	for (i = 1; i < num_ids; i++) {
>>>>>>>>>>       		if (!(c45_ids->devices_in_package & (1 << i)))
>>>>>>>>>> @@ -778,6 +781,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>>>>>>>>>       		ret = _get_phy_id(bus, addr, i, &c45_ids->device_ids[i], true);
>>>>>>>>>>       		if (ret < 0)
>>>>>>>>>>       			return ret;
>>>>>>>>>> +		if (valid_phy_id(c45_ids->device_ids[i]))
>>>>>>>>>> +			valid_id = true;
>>>>>>>>>
>>>>>>>>> Here you are using your "devices in package" validator to validate the
>>>>>>>>> PHY ID value.  One of the things it does is mask this value with
>>>>>>>>> 0x1fffffff.  That means you lose some of the vendor OUI.  To me, this
>>>>>>>>> looks completely wrong.
>>>>>>>>
>>>>>>>> I think in this case I was just using it like the comment in
>>>>>>>> get_phy_device() "if the phy_id is mostly F's, there is no device here".
>>>>>>>>
>>>>>>>> My understanding is that the code is trying to avoid the 0xFFFFFFFF returns
>>>>>>>> that seem to indicate "bus ok, phy didn't respond".
>>>>>>>>
>>>>>>>> I just checked the OUI registration, and while there are a couple OUI's
>>>>>>>> registered that have a number of FFF's in them, none of those cases seems to
>>>>>>>> overlap sufficiently to cause this to throw them out. Plus a phy would also
>>>>>>>> have to have model+revision set to 'F's. So while might be possible, if
>>>>>>>> unlikely, at the moment I think the OUI registration keeps this from being a
>>>>>>>> problem. Particularly, if i'm reading the mapping correctly, the OUI mapping
>>>>>>>> guarantees that the field cannot be all '1's due to the OUI having X & M
>>>>>>>> bits cleared. It sort of looks like the mapping is trying to lose those
>>>>>>>> bits, by tossing bit 1 & 2, but the X & M are in the wrong octet (AFAIK, I
>>>>>>>> just read it three times cause it didn't make any sense).
>>>>>>>
>>>>>>> I should also note that we have at least one supported PHY where one
>>>>>>> of the MMDs returns 0xfffe for even numbered registers and 0x0000 for
>>>>>>> odd numbered registers in one of the vendor MMDs for addresses 0
>>>>>>> through 0xefff - which has a bit set in the devices-in-package.
>>>>>>>
>>>>>>> It also returns 0x0082 for almost every register in MMD 2, but MMD 2's
>>>>>>> devices-in-package bit is clear in most of the valid MMDs, so we
>>>>>>> shouldn't touch it.
>>>>>>>
>>>>>>> These reveal the problem of randomly probing MMDs - they can return
>>>>>>> unexpected values and not be as well behaved as we would like them to
>>>>>>> be.  Using register 8 to detect presence may be beneficial, but that
>>>>>>> may also introduce problems as we haven't used that before (and we
>>>>>>> don't know whether any PHY that wrong.)  I know at least the 88x3310
>>>>>>> gets it right for all except the vendor MMDs, where the low addresses
>>>>>>> appear non-confromant to the 802.3 specs.  Both vendor MMDs are
>>>>>>> definitely implemented, just not with anything conforming to 802.3.
>>>>>>
>>>>>> Yes, we know even for the NXP reference hardware, one of the phy's doesn't
>>>>>> probe out correctly because it doesn't respond to the ieee defined
>>>>>> registers. I think at this point, there really isn't anything we can do
>>>>>> about that unless we involve the (ACPI) firmware in currently nonstandard
>>>>>> behaviors.
>>>>>>
>>>>>> So, my goals here have been to first, not break anything, and then do a
>>>>>> slightly better job finding phy's that are (mostly?) responding correctly to
>>>>>> the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
>>>>>> have IEEE conformant phy's you should be ok". So, for your example phy, I
>>>>>> guess the immediate answer is "use DT" or "find a conformant phy", or even
>>>>>> "abstract it in the firmware and use a mailbox interface".
>>>>>
>>>>> You haven't understood.  The PHY does conform for most of the MMDs,
>>>>> but there are a number that do not conform.
>>>>
>>>> Probably...
>>>>
>>>> Except that i'm not sure how that is a problem at the moment, its still
>>>> going to trigger as a found phy, and walk the same mmd list as before
>>>> requesting drivers. Those drivers haven't changed their behavior so where is
>>>> the problem? If there is a problem its in 7/11 where things are getting
>>>> kicked due to seemingly invalid Ids.
>>>>
>>>> The 1/11 devices=0 case actually appears to be a bug i'm fixing because you
>>>> won't get an ID or a MMD list from that (before or after).
>>>
>>> I think I've just flattened that argument in my immediately preceding
>>> reply on the Cortina situation; I think you've grossly misread that
>>> through not fully researching the history and then finding the
>>> existing users.
>>>
>>> There is no bug that you are fixing from what I can see.
>>
>> One of us is missing something,
>>
>> The "cortina" solution is broken in the current kernel. That is because
>> lines 726-742 are dead code due to line 693.
>>
>> I believe I've understood the problem there, and corrected it in this set
>> along with a few others, but its distinctly possible that isn't true.
> 
> The code you refer to above is NOT used on the platforms that I have
> identified use the Cortina PHY.  If this code is not used, it has not
> caused any issue, and there is no breakage due to the change you are
> referring to.
> 
Right, which is what I sort of expected. Because its falling back to a 
device list of 0xFFFFFFFF, which means probe every single MMD.

Combined with the lack of filtering means that your getting a bunch of 
MMD IDs that potentially are invalid, along with any that happen to be 
valid. Its that behavior (and some others) which were what blew this set 
up from a couple lines of tweaks into this mess.

I don't really see a way to guess at all the "wrong" ids that are being 
pushed into the system. Which is why I started to think about a "strict" 
mode later in the set. Maybe at this point the only way around some of 
these bugs/side effects/etc is just a second c45 probe routine if we 
don't think its possible to implement a variable strictness scanner in 
this code path without losing phys that previously were detected.


