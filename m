Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F41D69FECE
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjBVW62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjBVW61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:58:27 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71600D532;
        Wed, 22 Feb 2023 14:58:26 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A97FD85A08;
        Wed, 22 Feb 2023 23:58:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1677106704;
        bh=rJbcJMAe24GqriBCpZM1ShUUtpBmg7xuswb4wrQLlg4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Z/qzr3TZktyPmghYbTWoWUHtHEeBv0mpB5oFKkqFTbNXk88aOwGJJlRA+sD4fSQKA
         O99vVs5U/XtyaD6tEUSqjurYNS7pc2gzmhfeUejeXJQJpFTmKMswCoeKKuxGcXftnk
         f3myLHzkRDcLg412Ox8dcJX57d34935NAe372H/XObaZmZml4d5EbGAgJ1Obj5u3Yl
         wIudF4gsNpVXo2rWZcqKcrkYJXRH8dSxWoL0ixShsLDfq+c2a+SCOBO9Dc/RjmidXN
         GPqoxhvic/i6hz/gb9YVOI7N8aZngo+vM23cvDFinOUOX3ECbMT3XTja8RkO1rXrMx
         4rOAgU9xiu16w==
Message-ID: <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
Date:   Wed, 22 Feb 2023 23:58:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for
 KSZ87xx
Content-Language: en-US
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
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20230222223141.ozeis33beq5wpkfy@skbuf>
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

On 2/22/23 23:31, Vladimir Oltean wrote:
> On Wed, Feb 22, 2023 at 11:05:10PM +0100, Marek Vasut wrote:
>> On 2/22/23 22:08, Vladimir Oltean wrote:
>>> Please summarize in the commit title what is the user-visible impact of
>>> the problem that is being fixed. Short and to the point.
>>
>> Can you suggest a Subject which is acceptable ?
> 
> Nope. The thing is, I don't know what you're seeing, only you do. I can
> only review and comment if it's plausible or not. I'm sure you can come
> up with something.
> 
>>>> Currently, the driver uses PORT read function on register P_XMII_CTRL_1
>>>> to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.
>>>
>>> Provably false. The driver does do that, but not for KSZ87xx.
>>
>> The driver uses port read function with register value 0x56 instead of 0x06
>> , which means the remapping happens twice, which provably breaks the driver
>> since commit Fixes below .
> 
> The sentence is false in the context of ksz87xx, which is what is the
> implied context of this patch (see commit title written by yourself).
> The P_GMII_1GBIT_M field is not accessed, and that is a bug in itself.
> Also, the (lack of) access to the P_GMII_1GBIT_M field is not what
> causes the breakage that you see, but to other fields from that register.
> 
>>> There is no call site other than ksz_set_xmii(). Please delete false
>>> information from the commit message.
>>
>> $ git grep P_XMII_CTRL_1 drivers/net/dsa/microchip/
>> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x06,
>> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x0301,
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
>> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
>> drivers/net/dsa/microchip/ksz_common.h: P_XMII_CTRL_1,
>>
>> I count 6.
> 
> So your response to 2 reviewers wasting their time to do a detailed
> analysis of the code paths that apply to the KSZ87xx model in particular,
> to tell you precisely why your commit message is incorrect is "git grep"?
> 
>> OK, to make this simple, can you write a commit message which you consider
>> acceptable, to close this discussion ?
> 
> Nope. The thing is, I'm sure you can, too. Maybe you need to take a
> break and think about this some more.

Sorry, not like this and not with this feedback tone.

If Arun wants to send V2 to fix the actual bug, fine by me.
