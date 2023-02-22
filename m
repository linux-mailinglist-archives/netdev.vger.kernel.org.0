Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473A069FE18
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjBVWFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBVWFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:05:17 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800FF3D931;
        Wed, 22 Feb 2023 14:05:14 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4253F85911;
        Wed, 22 Feb 2023 23:05:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1677103512;
        bh=1IAlegq7EDrVDuMZUrtXnRLNt0MkiiFeaksJt0p5K6k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ynxihIKeuOGuBIMSLTlTQuKDbCj10c/pswJnzH0ARAbsqE6BfDMXd4fwwQt2+uPqc
         YEcenL6M8F+4lR4PcVwgmgSFB71c3qVe8+BTtueaI1++l7ZunDYvJaDm68sLAa4OuQ
         XQrQdO0gqo/YKHIiVuGNuhCb09hQWyyQM/eRHp3WugsD18m0yzmm+gv31nkVXqoSYu
         tpBDuWBS++5kMxFj9pzX+fL5dsKJMwWiR0Amyc4++SevawNVlQYrp5tYnGCr/5WvG7
         fMpyjccyJ4tnAiInoNCzBGOz9Ktip7Y3JiL2A1Fb7ZY6ou1DuAN37Ss4eRFJ452D93
         lECGbOAl+cYAw==
Message-ID: <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
Date:   Wed, 22 Feb 2023 23:05:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for
 KSZ87xx
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20230222210853.pilycwhhwmf7csku@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/23 22:08, Vladimir Oltean wrote:
> Please summarize in the commit title what is the user-visible impact of
> the problem that is being fixed. Short and to the point.

Can you suggest a Subject which is acceptable ?

> On Wed, Feb 22, 2023 at 04:17:38AM +0100, Marek Vasut wrote:
>> Per KSZ8794 [1] datasheet DS00002134D page 54 TABLE 4-4: PORT REGISTERS,
>> it is Register 86 (0x56): Port 4 Interface Control 6 which contains the
>> Is_1Gbps field.
> 
> Good thing you mention Is_1Gbps (even though it's irrelevant to the
> change you're proposing, since ksz_port_set_xmii_speed() is only called
> by ksz9477_phylink_mac_link_up()).
> 
> That is actually what I want to bring up. If you change the speed in
> your fixed-link nodes (CPU port and DSA master) to 100 Mbps on KSZ87xx,
> does it work? No, right? Because P_GMII_1GBIT_M always remains at its
> hardware default value, which is selected based on pin strapping.
> That's a bug, and should be fixed too.

Sure, separate patch. The system I use has gigabit link to the switch.

> Good thing you brought this up, I wouldn't have mentioned it if it
> wasn't in the commit message.
> 
>> Currently, the driver uses PORT read function on register P_XMII_CTRL_1
>> to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.
> 
> Provably false. The driver does do that, but not for KSZ87xx.

The driver uses port read function with register value 0x56 instead of 
0x06 , which means the remapping happens twice, which provably breaks 
the driver since commit Fixes below .

> Please delete red herrings from the commit message, they do not help
> assess users if they care about backporting a patch to a custom tree
> or not.
> 
>> The problem is, the register P_XMII_CTRL_1 address is already 0x56,
>> which is the converted PORT register address instead of the offset
>> within PORT register space that PORT read function expects and
>> converts into the PORT register address internally. The incorrectly
>> double-converted register address becomes 0xa6, which is what the PORT
>> read function ultimatelly accesses, and which is a non-existent
>                  ~~~~~~~~~~~
>                  ultimately
> 
>> register on the KSZ8794/KSZ8795 .
>>
>> The correct value for P_XMII_CTRL_1 is 0x6, which gets converted into
>> port address 0x56, which is Register 86 (0x56): Port 4 Interface Control 6
>> per KSZ8794 datasheet, i.e. the correct register address.
>>
>> To make this worse, there are multiple other call sites which read and
>                                  ~~~~~~~~
>                                  multiple implies more than 1.
> 
> There is no call site other than ksz_set_xmii(). Please delete false
> information from the commit message.

$ git grep P_XMII_CTRL_1 drivers/net/dsa/microchip/
drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] 
= 0x06,
drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] 
= 0x0301,
drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
regs[P_XMII_CTRL_1], &data8);
drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, 
regs[P_XMII_CTRL_1], data8);
drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
regs[P_XMII_CTRL_1], &data8);
drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
regs[P_XMII_CTRL_1], &data8);
drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
regs[P_XMII_CTRL_1], &data8);
drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, 
regs[P_XMII_CTRL_1], data8);
drivers/net/dsa/microchip/ksz_common.h: P_XMII_CTRL_1,

I count 6.

>> even write the P_XMII_CTRL_1 register, one of them is ksz_set_xmii(),
>> which is responsible for configuration of RGMII delays. These delays
>> are incorrectly configured and a non-existent register is written
>> without this change.
> 
> Not only RGMII delays, but also P_MII_SEL_M (interface mode selection).
> 
> The implication of writing the value at an undocumented address is that
> the real register 0x56 remains with the value decided by pin strapping
> (which may or may not be adequate for Linux runtime). This is absolutely
> the same class of bug as what happens with Is_1Gbps.
> 
>> Fix the P_XMII_CTRL_1 register offset to resolve these problems.
>>
>> [1] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/KSZ8794CNX-Data-Sheet-DS00002134.pdf
>>
>> Fixes: 46f80fa8981b ("net: dsa: microchip: add common gigabit set and get function")
> 
> Technically, the problem was introduced by:
> 
> Fixes: c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii function")
> 
> because that's when ksz87xx was transitioned from the old logic (which
> also used to set Is_1Gbps) to the new one.
> 
> And that same commit is also to blame for the Is_1Gbps bug, because the
> new logic from ksz8795_cpu_interface_select() should have called not
> only ksz_set_xmii(), but also ksz_set_gbit() for code-wise identical
> behavior. It didn't do that. Then with commit f3d890f5f90e ("net: dsa:
> microchip: add support for phylink mac config"), this incomplete
> configuration just got moved around.
> 
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> The contents of the patch is not wrong, but the commit message that
> describes it misses a lot of points which make non-zero difference to
> someone trying to assess whether a patch fixes a problem he's seeing or not.

OK, to make this simple, can you write a commit message which you 
consider acceptable, to close this discussion ?
