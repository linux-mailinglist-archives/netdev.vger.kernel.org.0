Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA3E1BCF4C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgD1WAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:00:10 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:9196 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgD1WAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:00:10 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id 03SLxmQ8007882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 15:59:48 -0600 (CST)
Received: from [192.168.233.77] (ovpn77.sedsystems.ca [192.168.233.77])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id 03SLxji1033606
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 28 Apr 2020 15:59:46 -0600
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
Message-ID: <8a829647-34a8-6e6a-05cf-76f5e88b8410@sedsystems.ca>
Date:   Tue, 28 Apr 2020 15:59:45 -0600
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

I've been playing with this a bit on a 5.4 kernel with some of these 
patches backported. However, I'm running into something that my previous 
hacks for this basically dealt with as a side effect: when phylink_start 
is called, sfp_upstream_start gets called, an SFP module is detected, 
phylink_connect_phy gets called, but then it hits this condition and 
bails out, because we are using INBAND mode with 1000BaseX:

	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
		     phy_interface_mode_is_8023z(interface))))
		return -EINVAL;

That same code is still in the latest version in the arm-linux cex7 
branch, except now in phylink_attach_phy, and from what I can see would 
behave similarly.

I guess I'm not sure how this is supposed to work when the PHY on the 
SFP module gets detected, i.e. if there's supposed to be another code 
path that this is supposed to go down, or this is something that just 
hasn't been fully implemented yet?

-- 
Robert Hancock
Senior Hardware Designer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
