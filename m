Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B694C9CE4
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 06:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiCBFBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 00:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiCBFBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 00:01:51 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABC421E3E1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 21:01:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55D4D106F;
        Tue,  1 Mar 2022 21:01:08 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 049BB3F73D;
        Tue,  1 Mar 2022 21:01:07 -0800 (PST)
Message-ID: <aab96097-e461-7f8b-dbde-10819d711c25@arm.com>
Date:   Tue, 1 Mar 2022 23:00:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Peter Robinson <pbrobinson@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/23/22 11:35, Florian Fainelli wrote:
> 
> 
> On 2/23/2022 3:40 AM, Peter Robinson wrote:
>> On Tue, Feb 22, 2022 at 8:15 PM Florian Fainelli 
>> <f.fainelli@gmail.com> wrote:
>>>
>>>
>>>
>>> On 2/22/2022 12:07 PM, Peter Robinson wrote:
>>>>> On 2/22/2022 1:53 AM, Peter Robinson wrote:
>>>>>> The ethtool WoL enable function wasn't checking if the device
>>>>>> has the optional WoL IRQ and hence on platforms such as the
>>>>>> Raspberry Pi 4 which had working ethernet prior to the last
>>>>>> fix regressed with the last fix, so also check if we have a
>>>>>> WoL IRQ there and return ENOTSUPP if not.
>>>>>>
>>>>>> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
>>>>>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
>>>>>> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
>>>>>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
>>>>>> ---
>>>>>>     drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
>>>>>>     1 file changed, 4 insertions(+)
>>>>>>
>>>>>> We're seeing this crash on the Raspberry Pi 4 series of devices on
>>>>>> Fedora on 5.17-rc with the top Fixes patch and wired ethernet 
>>>>>> doesn't work.
>>>>>
>>>>> Are you positive these two things are related to one another? The
>>>>> transmit queue timeout means that the TX DMA interrupt is not 
>>>>> firing up
>>>>> what is the relationship with the absence/presence of the Wake-on-LAN
>>>>> interrupt line?
>>>>
>>>> The first test I did was revert 9deb48b53e7f and the problem went
>>>> away, then poked at a few bits and the patch also fixes it without
>>>> having to revert the other fix. I don't know the HW well enough to
>>>> know more.
>>>>
>>>> It seems there's other fixes/improvements that could be done around
>>>> WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
>>>> support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.
>>>
>>> There is no question we can report information more accurately and your
>>> patch fixes that.
>>>
>>>>
>>>> This fix at least makes it work again in 5.17, I think improvements
>>>> can be looked at later by something that actually knows their way
>>>> around the driver and IP.
>>>
>>> I happen to be that something, or rather consider myself a someone. But
>>> the DTS is perfectly well written and the Wake-on-LAN interrupt is
>>> optional, the driver assumes as per the binding documents that the
>>> Wake-on-LAN is the 3rd interrupt, when available.
>>>
>>> What I was hoping to get at is the output of /proc/interrupts for the
>>> good and the bad case so we can find out if by accident we end-up not
>>> using the appropriate interrupt number for the TX path. Not that I can
>>> see how that would happen, but since we have had some interesting issues
>>> being reported before when mixing upstream and downstream DTBs, I just
>>> don't fancy debugging that again:
>>
>> The top two are pre/post plugging an ethernet cable with the patched
>> kernel, the last two are the broken kernel. There doesn't seem to be a
>> massive difference in interrupts but you likely know more of what
>> you're looking for.
> 
> There is not a difference in the hardware interrupt numbers being 
> claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and 
> 158 + 32). In the broken case we can see that the second interrupt line 
> (interrupt 190), which is the one that services the non-default TX 
> queues does not fire up at all whereas it does in the patched case.
> 
> The transmit queue timeout makes sense given that transmit queue 2 
> (which is not the default one, default is 0) has its interrupt serviced 
> by the second interrupt line (190). We can see it not firing up, hence 
> the timeout.
> 
> What I *think* might be happening here is the following:
> 
> - priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative 
> error code we do not install the interrupt handler for the WoL interrupt 
> since it is not valid
> 
> - bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we 
> call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is 
> able to resolve that irq number to a valid interrupt descriptor

That should not be possible, see below.

> 
> - eventually we just mess up the interrupt descriptor for interrupt 49 
> and it stops working
> 
> Now since this appears to be an ACPI-enabled system, we may be hitting 
> this part of the code in platform_get_irq_optional():
> 
>            r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>            if (has_acpi_companion(&dev->dev)) {
>                    if (r && r->flags & IORESOURCE_DISABLED) {
>                            ret = acpi_irq_get(ACPI_HANDLE(&dev->dev), 
> num, r);
>                            if (ret)
>                                    goto out;
>                    }
>            }

As Peter points out, he is using uboot/DT. I on the other hand am not 
having any issues with fedora on the edk2/ACPI rpi4 with 5.17rc's.

Although, I found this series interesting because I didn't (still don't, 
although I have a couple theories) see why the same bug shouldn't be 
affecting ACPI.

Also, I don't actually understand how Peter's patch fixes the problem. 
That is because, device_set_wakeup_capable() isn't setting can_wakeup, 
thus the machine should immediately be returning from 
bcmgetnet_set_wol() when it checks device_can_wakeup(). Meaning it 
shouldn't ever execute the wol_irq <= 0 check being added by this patch.

On the working/ACPI machine that is true, and it actually results in an 
unusual ethtool error. So, understanding how that gets set (and maybe 
adding an wakeup_capable(,false), like a couple other drivers) is the 
right path here? It should be 0, but I can't prove that to myself right now.

Which brings me to my second point about ethtool. The return from 
bcmgenet_get_wol() is incorrect on these platforms, and that is why 
bcmgetnet_set_wol() is even being called. I have a patch I will post, to 
fix it, but its basically adding a device_can_wakeup() check to 
_get_wol() and returning wol->supported = 0; wol->wolopts=0;

Finally, more on the thinking out loud theory, it came to my attention 
that some of the fedora kernels were being built with gcc11 (my rpi test 
kernels for sure) and some with gcc12? Is the failing kernel built with 
gcc12?


> 
> and then I am not clear what interrupt this translates into here, or 
> whether it is possible to get a valid interrupt descriptor here.
> 
> The patch is fine in itself, but I would really prefer that we get to 
> the bottom of this rather than have a superficial understanding of the 
> nature of the problem.
> 
> Thanks for providing these dumps.

