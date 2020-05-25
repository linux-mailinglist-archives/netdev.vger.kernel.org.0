Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F379A1E05E8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 06:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgEYEUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 00:20:02 -0400
Received: from foss.arm.com ([217.140.110.172]:35792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgEYEUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 00:20:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC0C030E;
        Sun, 24 May 2020 21:20:01 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99C8D3F52E;
        Sun, 24 May 2020 21:20:01 -0700 (PDT)
Subject: Re: [RFC 07/11] net: phy: reset invalid phy reads of 0 back to
 0xffffffff
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-8-jeremy.linton@arm.com>
 <20200523184459.GA1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <d6d71908-58a0-96c9-b046-9a4739cc7bcd@arm.com>
Date:   Sun, 24 May 2020 23:20:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200523184459.GA1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/23/20 1:44 PM, Russell King - ARM Linux admin wrote:
> On Fri, May 22, 2020 at 04:30:55PM -0500, Jeremy Linton wrote:
>> MMD's in the device list sometimes return 0 for their id.
>> When that happens lets reset the id back to 0xfffffff so
>> that we don't get a stub device created for it.
>>
>> This is a questionable commit, but i'm tossing it out
>> there along with the comment that reading the spec
>> seems to indicate that maybe there are further registers
>> that could be probed in an attempt to resolve some futher
>> "bad" phys. It sort of comes down to do we want unused phy
>> devices floating around (potentially unmatched in dt) or
>> do we want to cut them off early and let DT create them
>> directly.
> 
> I'm not sure what you mean "stub device" or "unused phy devices
> floating around" - the individual MMDs are not treated as separate
> "phy devices", but as one PHY device as a whole.
> 

Well, I guess its clearer to say phy/mmd devices with a phy_id=0. Which 
is a problem if we don't have DT overriding the phy_id for a given 
address. Although AFAIK given a couple of the /sys/bus/mdio_bus/devices 
lists I've seen, and after studying this code for a while now, I think 
"bogus" phy's might be getting created*. I was far to easy, to upset the 
cart when I was hacking on this set, and end up with a directory chuck 
full of phys.

So this gets close to one of the questions I asked in the cover letter. 
This patch and 09/11 serve to cut off possibly valid phy's which are 
failing to identify themselves using the standard registers. Which per 
the 802.3 spec there is a blurb about 0 in the id registers for some 
cases. Its not really a critical problem for ACPI machines to have these 
phys around (OTOH, there might be issues with c22 phys on c45 electrical 
buses that respond to c45 reg requests but don't set the c22 regs flag, 
I haven't seen that yet.). I considered dropping this patch, and 9/11 
was a last minute addition. I kept it because I was worried all those 
extra "reserved" MMDs would end up with id = 0's in there and break 
something.

* In places where there isn't actually a phy, likely a large part of the 
problem was clearing the c22 bit, which allowed 0xFFFFFFFF returns to 
slip through the devices list.
