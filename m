Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B707449756
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhKHPDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240669AbhKHPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:03:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E723BC061570;
        Mon,  8 Nov 2021 07:00:50 -0800 (PST)
Message-ID: <e021af48-52be-7288-0a71-503cb66bd25a@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636383649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ty680YT+bwvPMcSb1/D8WNDOqztuUzKMAze6te+xZcw=;
        b=f4arNSUPz3G30tLlD48t6UEGlO7LPoyllLMakKc5h1dtDiLiMOaAg0v34O6u+prUczI251
        Jz9YCL1V9a8ogYJaCsksxYDzvCtzjWyII8vweAD9hmtpeXfkp8E1cfAOGbPob7vAoh/e4y
        JwDDss685aNIn/zxCpe8RnKADlQrIJDLXwXrhUMwqYz9I2MMU1YuaEkC75KMtSTwN1Fn6N
        T5bUqCHf3M7GEWQ1v1g8u4NF8E3NHKhPF8DWXBg9QkZcPzZRsCrpGV+81KvLVPE2ailrD8
        URg8LBcBMeoTZahYoWVgfZ//SGbA/mCM4L0xbpfbPT55hfbZcUN77CkL/3+NQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636383649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ty680YT+bwvPMcSb1/D8WNDOqztuUzKMAze6te+xZcw=;
        b=Zash6zz9hdqNFRof8pH25R85jrynmEkLir5nMHen6On7rJLYb23RRlgy69QAzgsJp4HeGm
        CIGOCkcin346sgBQ==
Date:   Mon, 8 Nov 2021 16:00:48 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 4/7] net: dsa: b53: Add PHC clock support
Content-Language: de-DE
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-5-martin.kaistra@linutronix.de>
 <666b195b-e7d7-6f1f-e09d-bfe113c2f4fe@gmail.com>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <666b195b-e7d7-6f1f-e09d-bfe113c2f4fe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.11.21 um 03:32 schrieb Florian Fainelli:
> 
> 
> On 11/4/2021 6:31 AM, Martin Kaistra wrote:
>> The BCM53128 switch has an internal clock, which can be used for
>> timestamping. Add support for it.
>>
>> The 32-bit free running clock counts nanoseconds. In order to account
>> for the wrap-around at 999999999 (0x3B9AC9FF) while using the cycle
>> counter infrastructure, we need to set a 30bit mask and use the
>> overflow_point property.
>>
>> Enable the Broadsync HD timestamping feature in b53_ptp_init() for PTPv2
>> Ethertype (0x88f7).
>>
>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>> ---
> 
> [snip]
> 
> 
>> +int b53_ptp_init(struct b53_device *dev)
>> +{
>> +    mutex_init(&dev->ptp_mutex);
>> +
>> +    INIT_DELAYED_WORK(&dev->overflow_work, b53_ptp_overflow_check);
>> +
>> +    /* Enable BroadSync HD for all ports */
>> +    b53_write16(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_EN_CTRL1, 
>> 0x00ff);
> 
> Can you do this for all enabled user ports instead of each port, that 
> way it is clera that this register is supposed to be a bitmask of ports 
> for which you desire PTP timestamping to be enabled?
> 
>> +
>> +    /* Enable BroadSync HD Time Stamping Reporting (Egress) */
>> +    b53_write8(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TS_REPORT_CTRL, 
>> 0x01);
> 
> Can you add a define for this bit in b53_regs.h and name it:
> 
> #define TSRPT_PKT_EN    BIT(0)
> 
> which will enable timestamp reporting towards the IMP port.
> 
>> +
>> +    /* Enable BroadSync HD Time Stamping for PTPv2 ingress */
>> +
>> +    /* MPORT_CTRL0 | MPORT0_TS_EN */
>> +    b53_write16(dev, B53_ARLCTRL_PAGE, 0x0e, (1 << 15) | 0x01);
> 
> Please add a definition for 0x0e which is the multi-port control 
> register and is 16-bit wide.
> 
> Bit 15 is MPORT0_TS_EN and it will ensure that packets matching 
> multiport 0 (address or ethertype) will be timestamped.
> 
> and then add a macro or generic definitions that are applicable to all 
> multiport control registers, something like:
> 
> #define MPORT_CTRL_DIS_FORWARD    0
> #define MPORT_CTRL_CMP_ADDR    1
> #define MPORT_CTRL_CMP_ETYPE    2
> #define MPORT_CTRL_CMP_ADDR_ETYPE 3
> 
> #define MPORT_CTRL_SHIFT(x)    ((x) << 2)
> #define MPORT_CTRL_MASK        0x3
> 
>> +    /* Forward to IMP port 8 */
>> +    b53_write64(dev, B53_ARLCTRL_PAGE, 0x18, (1 << 8));
> 
> 0x18 is the multiport vector N register so we would want a macro to 
> define the multiprot vector being used (up to 6 of them), and this is a 
> 32-bit register, not a 64-bit register. The 8 here should be checked 
> against the actual CPU port index number, it is 8 for you, it could be 5 
> for someone else, or 7, even.
> 
>> +    /* PTPv2 Ether Type */
>> +    b53_write64(dev, B53_ARLCTRL_PAGE, 0x10, (u64)0x88f7 << 48);
> 
> Use ETH_P_1588 here and 0x10 deserves a define which is the multiport 
> address N register. Likewise, we need a base offset of 0x10 and then a 
> macro to address the 6 multiports that exists.
> 
>> +
>> +    /* Setup PTP clock */
>> +    dev->ptp_clock_info.owner = THIS_MODULE;
>> +    snprintf(dev->ptp_clock_info.name, sizeof(dev->ptp_clock_info.name),
>> +         dev_name(dev->dev));
>> +
>> +    dev->ptp_clock_info.max_adj = 1000000000ULL;
>> +    dev->ptp_clock_info.n_alarm = 0;
>> +    dev->ptp_clock_info.n_pins = 0;
>> +    dev->ptp_clock_info.n_ext_ts = 0;
>> +    dev->ptp_clock_info.n_per_out = 0;
>> +    dev->ptp_clock_info.pps = 0;
> 
> memset the structure ahead of time so you only need explicit 
> initialization where needed?
> 
>> +    dev->ptp_clock_info.adjfine = b53_ptp_adjfine;
>> +    dev->ptp_clock_info.adjtime = b53_ptp_adjtime;
>> +    dev->ptp_clock_info.gettime64 = b53_ptp_gettime;
>> +    dev->ptp_clock_info.settime64 = b53_ptp_settime;
>> +    dev->ptp_clock_info.enable = b53_ptp_enable;
>> +
>> +    dev->ptp_clock = ptp_clock_register(&dev->ptp_clock_info, dev->dev);
>> +    if (IS_ERR(dev->ptp_clock))
>> +        return PTR_ERR(dev->ptp_clock);
>> +
>> +    /* The switch provides a 32 bit free running counter. Use the Linux
>> +     * cycle counter infrastructure which is suited for such scenarios.
>> +     */
>> +    dev->cc.read = b53_ptp_read;
>> +    dev->cc.mask = CYCLECOUNTER_MASK(30);
>> +    dev->cc.overflow_point = 999999999;
>> +    dev->cc.mult = (1 << 28);
>> +    dev->cc.shift = 28;
>> +
>> +    b53_write32(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TIMEBASE_ADJ1, 
>> 40);
> 
> You are writing the default value of the register, is that of any use?

Appearently not, I just tested it without this line and it seems to work 
fine.

It just seemed strange to me, that while the datasheet mentions 40 as 
the default value, when reading the register without writing this 
initial value, I just get back 0.

I'll remove the line for v2.

Thanks,
Martin
