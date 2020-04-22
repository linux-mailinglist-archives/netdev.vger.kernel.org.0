Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17671B4A86
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDVQcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:32:23 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:34583 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDVQcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:32:22 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id 03MGVsjt025303
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 10:31:54 -0600 (CST)
Received: from [192.168.233.77] (ovpn77.sedsystems.ca [192.168.233.77])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id 03MGVq7S002698
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 22 Apr 2020 10:31:52 -0600
Subject: Re: Xilinx axienet 1000BaseX support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
 <20200110152215.GF25745@shell.armlinux.org.uk>
 <20200110170457.GH25745@shell.armlinux.org.uk>
 <20200118112258.GT25745@shell.armlinux.org.uk>
 <3b28dcb4-6e52-9a48-bf9c-ddad4cf5e98a@arm.com>
 <20200120154554.GD25745@shell.armlinux.org.uk>
 <20200127170436.5d88ca4f@donnerap.cambridge.arm.com>
 <20200127185344.GA25745@shell.armlinux.org.uk>
 <bf2448d0-390c-5045-3503-885240829fbf@sedsystems.ca>
 <20200422075124.GJ25745@shell.armlinux.org.uk>
From:   Robert Hancock <hancock@sedsystems.ca>
Message-ID: <21ed251b-964f-3f16-1a66-728bbeffa426@sedsystems.ca>
Date:   Wed, 22 Apr 2020 10:31:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422075124.GJ25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 1:51 a.m., Russell King - ARM Linux admin wrote:
> On Tue, Apr 21, 2020 at 07:45:47PM -0600, Robert Hancock wrote:
>> Hi Andre/Russell,
>>
>> Just wondering where things got to with the changes for SGMII on Xilinx
>> axienet that you were discussing (below)? I am looking into our Xilinx setup
>> using 1000BaseX SFP and trying to get it working "properly" with newer
>> kernels. My understanding is that the requirements for 1000BaseX and SGMII
>> are somewhat similar. I gathered that SGMII was working somewhat already,
>> but that not all link modes had been tested. However, it appears 1000BaseX
>> is not yet working in the stock kernel.
>>
>> The way I had this working before with a 4.19-based kernel was basically a
>> hack to phylink to allow the Xilinx PCS/PMA PHY to be configured
>> sufficiently as a PHY for it to work, and mostly ignored the link status of
>> the SFP PHY itself, even though we were using in-band signalling mode with
>> an SFP module. That was using this patch:
>>
>> https://patchwork.ozlabs.org/project/netdev/patch/1559330285-30246-5-git-send-email-hancock@sedsystems.ca/
>>
>> Of course, that's basically just a hack which I suspect mostly worked by
>> luck. I see that there are some helpers that were added to phylink to allow
>> setting PHY advertisements and reading PHY status from clause 22 PHY
>> devices, so I'm guessing that is the way to go in this case? Something like:
>>
>> axienet_mac_config: if using in-band mode, use
>> phylink_mii_c22_pcs_set_advertisement to configure the Xilinx PHY.
>>
>> axienet_mac_pcs_get_state: use phylink_mii_c22_pcs_get_state to get the MAC
>> PCS state from the Xilinx PHY
>>
>> axienet_mac_an_restart: if using in-band mode, use
>> phylink_mii_c22_pcs_an_restart to restart autonegotiation on Xilinx PHY
>>
>> To use those c22 functions, we need to find the mdio_device that's
>> referenced by the phy-handle in the device tree - I guess we can just use
>> some of the guts of of_phy_find_device to do that?
> 
> Please see the code for DPAA2 - it's changed slightly since I sent a
> copy to the netdev mailing list, and it still isn't clear whether this
> is the final approach (DPAA2 has some fun stuff such as several
> different PHYs at address 0.) NXP basically didn't like the approach
> I had in the patches I sent to netdev, we had a call, they presented
> an alternative appraoch, I implemented it, then they decided my
> original approach was the better solution for their situation.
> 
> See http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=cex7
> 
> specifically the patches from:
> 
>    "dpaa2-mac: add 1000BASE-X/SGMII PCS support"
> 
> through to:
> 
>    "net: phylink: add interface to configure clause 22 PCS PHY"
> 
> You may also need some of the patches further down in the net-queue
> branch:
> 
>    "net: phylink: avoid mac_config calls"
> 
> through to:
> 
>    "net: phylink: rejig link state tracking"

Thanks for the info. I've yet to decide whether or how I'm going to 
attempt this task at the moment - it seems like there have been a lot of 
changes to phylink and other related code lately and it appears to be a 
bit of a task to backport them all into a released kernel version, more 
so back to 5.4 which is the latest LTS kernel which we would ideally 
want to use. So I might end up trying to open-code this more inside the 
driver and eventually switching it to use the shared code when it's 
merged, or maybe just deferring the proper fix for this until the 
infrastructure is more in place in mainline.

> 
>> One concern I have is that there may be things that the PHY subsystem would
>> configure on the device that may need to be replicated in order to get it to
>> actually work - things like setting auto-negotiate enable/disable, the
>> BMCR_ISOLATE bit, etc - is that something that belongs in our mac_config or
>> in the phylink core in phylink_mii_c22_pcs_set_advertisement etc?
> 
> I think some of that is addressed in the above patches, except for
> the isolate bit - do your PHYs come up with the isolate bit set?
> Under what circumstances would you need to set it?

I believe it does come up isolated - from the Xilinx PG047 document for 
the PCS/PMA core:

"Start-up Sequencing
IEEE 802.3-2008 clause 22.2.4.1.6 states that by default, a PHY should 
power up in an isolate state (electrically isolated from the GMII).
If you are using the core with the optional management interface, it is 
necessary to write to the PCS Configuration Register 0 to take the core 
out of the isolate state."

Also, in PG138 for the AXI Ethernet core, under Gigabit Ethernet PCS/PMA 
Management Registers, it has this note:

"When using the 1000BASE-X TEMAC core (C_TYPE = 1 and C_PHY_TYPE = 5), 
set the isolate bit to zero (Control register 0 bit 10). The subsystem 
is not operational until this is completed."

> 
> Let me know how you get on.
> 
> Thanks.
> 

-- 
Robert Hancock
Senior Hardware Designer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
