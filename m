Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550BF1E17C8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389460AbgEYWR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:17:29 -0400
Received: from foss.arm.com ([217.140.110.172]:44840 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbgEYWR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 18:17:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C20F31B;
        Mon, 25 May 2020 15:17:28 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F12E3F6C4;
        Mon, 25 May 2020 15:17:28 -0700 (PDT)
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
Date:   Mon, 25 May 2020 17:17:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525220614.GC768009@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/25/20 5:06 PM, Andrew Lunn wrote:
>> Yes, we know even for the NXP reference hardware, one of the phy's doesn't
>> probe out correctly because it doesn't respond to the ieee defined
>> registers. I think at this point, there really isn't anything we can do
>> about that unless we involve the (ACPI) firmware in currently nonstandard
>> behaviors.
>>
>> So, my goals here have been to first, not break anything, and then do a
>> slightly better job finding phy's that are (mostly?) responding correctly to
>> the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
>> have IEEE conformant phy's you should be ok". So, for your example phy, I
>> guess the immediate answer is "use DT" or "find a conformant phy", or even
>> "abstract it in the firmware and use a mailbox interface".
>   
> Hi Jeremy
> 
> You need to be careful here, when you say "use DT". With a c45 PHY
> of_mdiobus_register_phy() calls get_phy_device() to see if the device
> exists on the bus. So your changes to get_phy_device() etc, needs to
> continue to find devices it used to find, even if they are not fully
> complient to 802.3.
> 

Yes, that is my "don't break anything". But, in a number of cases I 
can't tell if something is an intentional "bug", or what exactly the 
intended side effect actually was. The c22 bit0 sanitation is in this 
bucket, because its basically disabling the MMD0 probe..

I know for sure we find phys that previously weren't found. OTOH, i'm 
not sure how many that were previously "found" are now getting kicked 
out by because they are doing something "bad" that looked like a bug.


