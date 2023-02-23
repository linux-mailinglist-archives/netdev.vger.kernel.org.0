Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2BD6A024E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 06:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjBWFRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 00:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBWFRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 00:17:36 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C9D3C79D;
        Wed, 22 Feb 2023 21:17:32 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2F16085ACE;
        Thu, 23 Feb 2023 06:17:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1677129450;
        bh=fJHlxWY8ZxK1Vd/aqi5+cmgOg2ytZN4jMXo7vHyv/yc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fX70mkvo0K99FIbhNwOcPwnw7HywkEoPm4ytSp1nWs3syYpR8C76HU6nPe7bg/ILQ
         oZu2gpzfSbNQGH+xZrrl7z4SZB2lbBfJpmrjjm9if1t2JtLuSCOjqYdagEeLzcazjn
         5LB/jEpF2ZCKzyhxQC5fP4sdMoYpF3LZSkrtRSuLZwJgzIsqh3bAlh6c1PaLwroGX0
         24Y1Mtex8+STEJnoTryySTWOlX9ULq8BX6FA89Ytf631FqKic5/a2LmkePr1RrZUaP
         +UpQ6LHvUGw5z462P76bihO7ubBbGQUS1R9slmD1UmR4R/QtQWfkA9+PTDg1/8TJaG
         rXKLaRyDdw/LA==
Message-ID: <2a7696ff-eceb-2feb-0cce-d9910b5ad81f@denx.de>
Date:   Thu, 23 Feb 2023 06:17:28 +0100
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
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
 <20230222232112.v7gokdmr34ii2lgt@skbuf>
 <35a4df8a-7178-20de-f433-e2c01e5eaaf7@denx.de>
 <20230223002224.k5odesikjebctouc@skbuf>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20230223002224.k5odesikjebctouc@skbuf>
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

On 2/23/23 01:22, Vladimir Oltean wrote:
> Hi Marek,
> 
> On Thu, Feb 23, 2023 at 12:55:08AM +0100, Marek Vasut wrote:
>> The old code, removed in:
>> c476bede4b0f0 ("net: dsa: microchip: ksz8795: use common xmii function")
>> used ksz_write8() (this part is important):
>> ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
>> where:
>> drivers/net/dsa/microchip/ksz8795_reg.h:#define REG_PORT_5_CTRL_6
>> 0x56
>>
>> The new code, where the relevant part is added in (see Fixes tag)
>> 46f80fa8981bc ("net: dsa: microchip: add common gigabit set and get
>> function")
>> +++ b/drivers/net/dsa/microchip/ksz_common.c
>> @@ -257,6 +257,7 @@ static const u16 ksz8795_regs[] = {
>> +       [P_XMII_CTRL_1]                 = 0x56,
>> uses ksz_pwrite8() (with p in the function name, p means PORT):
>> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
>> which per drivers/net/dsa/microchip/ksz_common.h translates to
>> ksz_write8(dev, dev->dev_ops->get_port_addr(port, offset), data);
>> and that dev->dev_ops->get_port_addr(port, offset) remapping function is per
>> drivers/net/dsa/microchip/ksz8795.c really call to the following macro:
>> PORT_CTRL_ADDR(port, offset)
>> which in turn from drivers/net/dsa/microchip/ksz8795_reg.h becomes
>> #define PORT_CTRL_ADDR(port, addr) ((addr) + REG_PORT_1_CTRL_0 + (port) * (REG_PORT_2_CTRL_0 - REG_PORT_1_CTRL_0))
>>
>> That means:
>> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
>> writes register 0xa6 instead of register 0x56, because it calls the
>> PORT_CTRL_ADDR(port, 0x56)=0xa6, but in reality it should call
>> PORT_CTRL_ADDR(port, 0x06)=0x56, i.e. the remapping should happen ONCE, the
>> value 0x56 is already remapped .
> 
> I never had any objection to this part.
> 
>> All the call-sites which do
>> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
>> or
>> ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8)
>> are affected by this, all six, that means the ksz_[gs]et_xmii() and the
>> ksz_[gs]et_gbit().
> 
> I'm going to say this with a very calm tone, please tell me where it's wrong
> and we can go from there.
> 
>   Not for the ksz_switch_chips[] elements which point to ksz8795_regs (which
>   had the incorrect value you're fixing), it isn't. You're making an argument
>   for code which never executes (5 out of 6 call paths), and basing your commit
>   message off of it. Your commit message reads as if you didn't even notice
>   that ksz_set_gbit() isn't called for ksz87xx, and that this is a bug in itself.
>   Moreover, the problem you're seeing (I may speculate what that is, but
>   I don't know) is surely not due to ksz_set_gbit() being called on the
>   wrong register, because it's not called at all *for that hardware*.
> 
> That gigabit bug was pointed out to you by reviewers, and you refuse to
> acknowledge this and keep bringing forth some other stuff which was never
> debated by anyone. The lack of acknowledgement plus your continuation to
> randomly keep singing another tune in another key completely is irritating
> to me on a very personal (non-technical) level. To respond to you, I am
> exercising some mental muscles which I wish I wouldn't have needed to,
> here, in this context. The same muscles I use when I need to identify
> manipulation on tass.com.
> 
> [ in case the message above is misinterpreted: I did not say that you
>    willingly manipulate. I said that your lack of acknowledgement to what
>    is being said to you is giving me the same kind of frustration ]
> 
> This is my feedback to the tone in your replies. I want you to give your
> feedback to my tone now too. You disregarded that.
> 
>> ...
>>
>> If all that should be changed in the commit message is "to access the
>> P_GMII_1GBIT_M, i.e. Is_1Gbps, bit" to something from the "ksz_set_xmii()"
>> function instead, then just say so.
>>
>> [...]
> 
> No, this is not all that I want.
> 
> The gigabit bug changes things in ways in which I'm curious how you're
> going to try to defend, with this attitude of responding to anything
> except to what was asked. Your commit says it fixes gigabit on KSZ87xx

No, it does not say it fixes gigabit on KSZ87xx, the commit message says 
it fixes gigabit accessor functions, but what it really fixes (and what 
is the bulk of the commit message) is the incorrectly double-remapped 
register 0x56 used in those gigabit accessor functions and which is also 
used in the ksz_[gs]et_xmii function.

> but the gigabit bug which *was pointed out to you by others* is still
> there. Your patch fixes something else, but *it says* it fixes a gigabit
> bug. What I want is for you to describe exactly what it fixes, or if you
> just don't know, say you noticed the bug during code review and you
> don't know what is its real life impact (considering pin strapping).

I believe I wrote what the problem is in my previous email, the 
incorrectly double-remapped XMII_1 register . The register wasn't 
updated in my case in ksz_set_xmii() with RGMII delays.

Why I picked the is_1Gbit bit for the commit message, probably was tired 
after lengthy debugging session of this problem.

> I don't want a patch to be merged which says it fixes something it doesn't
> fix, while leaving the exact thing it says it fixes unfixed.
> 
> I also don't want to entertain this game of "if it's just this small
> thing, why didn't you say so". I would be setting myself up for an
> endless time waste if I were to micromanage your commit message writing.
> 
> I am looking forward to a productive conversation with you, but if your
> next reply is going to have the same strategy of avoiding my key message
> and focusing on some other random thing, then I'm very sorry, but I'll
> just have to focus my attention somewhere else.

[...]
