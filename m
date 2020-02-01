Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C15114FA30
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgBAT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:27:14 -0500
Received: from foss.arm.com ([217.140.110.172]:43486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBAT1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:27:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2CCEFEC;
        Sat,  1 Feb 2020 11:27:13 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2B093F68E;
        Sat,  1 Feb 2020 11:27:12 -0800 (PST)
Subject: Re: [PATCH 6/6] net: bcmgenet: reduce severity of missing clock
 warnings
To:     Stefan Wahren <wahrenst@gmx.net>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-7-jeremy.linton@arm.com>
 <2dfd6cd2-1dd0-c8ff-8d83-aed3b4ea7a79@gmx.net>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <34aba1d9-5cad-0fee-038d-c5f3bfc9ed30@arm.com>
Date:   Sat, 1 Feb 2020 13:27:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2dfd6cd2-1dd0-c8ff-8d83-aed3b4ea7a79@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

First, thanks for looking at this!

On 2/1/20 10:44 AM, Stefan Wahren wrote:
> Hi Jeremy,
> 
> [add Nicolas as BCM2835 maintainer]
> 
> Am 01.02.20 um 08:46 schrieb Jeremy Linton:
>> If one types "failed to get enet clock" or similar into google
>> there are ~370k hits. The vast majority are people debugging
>> problems unrelated to this adapter, or bragging about their
>> rpi's. Given that its not a fatal situation with common DT based
>> systems, lets reduce the severity so people aren't seeing failure
>> messages in everyday operation.
>>
> i'm fine with your patch, since the clocks are optional according to the
> binding. But instead of hiding of those warning, it would be better to
> fix the root cause (missing clocks). Unfortunately i don't have the
> necessary documentation, just some answers from the RPi guys.

The DT case just added to my ammunition here :)

But really, I'm fixing an ACPI problem because the ACPI power management 
methods are also responsible for managing the clocks. Which means if I 
don't lower the severity (or otherwise tweak the code path) these errors 
are going to happen on every ACPI boot.

> 
> This is what i got so far:

BTW: For DT, is part of the problem here that the videocore mailbox has 
a clock management method? For ACPI one of the paths of investigation is 
to write AML which just interfaces to that mailbox interface for clock 
control here. (there is also SCMII to be considered).


> 
> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
> index 961bed8..d4ff370 100644
> --- a/arch/arm/boot/dts/bcm2711.dtsi
> +++ b/arch/arm/boot/dts/bcm2711.dtsi
> @@ -338,6 +338,8 @@
>                          reg = <0x0 0x7d580000 0x10000>;
>                          #address-cells = <0x1>;
>                          #size-cells = <0x1>;
> +                       clocks = <&clocks BCM2711_CLOCK_GENET250>;
> +                       clock-names = "enet";
>                          interrupts = <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>,
>                                       <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
>                          status = "disabled";
> diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
> index ded13cc..627f1b1 100644
> --- a/drivers/clk/bcm/clk-bcm2835.c
> +++ b/drivers/clk/bcm/clk-bcm2835.c
> @@ -116,6 +116,10 @@
>   #define CM_EMMCDIV             0x1c4
>   #define CM_EMMC2CTL            0x1d0
>   #define CM_EMMC2DIV            0x1d4
> +#define CM_GENET250CTL         0x1e8
> +#define CM_GENET250DIV         0x1ec
> +#define CM_GENET125CTL         0x210
> +#define CM_GENET125DIV         0x214
>   
>   /* General bits for the CM_*CTL regs */
>   # define CM_ENABLE                     BIT(4)
> @@ -2021,6 +2025,25 @@ static const struct bcm2835_clk_desc
> clk_desc_array[] = {
>                  .frac_bits = 8,
>                  .tcnt_mux = 42),
>   
> +       /* GENET clocks (only available for BCM2711) */
> +       [BCM2711_CLOCK_GENET250]        = REGISTER_PER_CLK(
> +               SOC_BCM2711,
> +               .name = "genet250",
> +               .ctl_reg = CM_GENET250CTL,
> +               .div_reg = CM_GENET250DIV,
> +               .int_bits = 4,
> +               .frac_bits = 8,
> +               .tcnt_mux = 45),
> +
> +       [BCM2711_CLOCK_GENET125]        = REGISTER_PER_CLK(
> +               SOC_BCM2711,
> +               .name = "genet125",
> +               .ctl_reg = CM_GENET125CTL,
> +               .div_reg = CM_GENET125DIV,
> +               .int_bits = 4,
> +               .frac_bits = 8,
> +               .tcnt_mux = 50),
> +
>          /* General purpose (GPIO) clocks */
>          [BCM2835_CLOCK_GP0]     = REGISTER_PER_CLK(
>                  SOC_ALL,
> diff --git a/include/dt-bindings/clock/bcm2835.h
> b/include/dt-bindings/clock/bcm2835.h
> index b60c0343..fca65ab 100644
> --- a/include/dt-bindings/clock/bcm2835.h
> +++ b/include/dt-bindings/clock/bcm2835.h
> @@ -60,3 +60,5 @@
>   #define BCM2835_CLOCK_DSI1P            50
>   
>   #define BCM2711_CLOCK_EMMC2            51
> +#define BCM2711_CLOCK_GENET250         52
> +#define BCM2711_CLOCK_GENET125         53
> 
> 

