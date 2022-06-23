Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57825587A8
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiFWSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiFWSgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:36:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD848F9F9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:37:31 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1o4QkO-00079c-Ee; Thu, 23 Jun 2022 19:36:04 +0200
Message-ID: <ec4168b6-36f1-0183-b1ed-6a33d9fa1bbc@pengutronix.de>
Date:   Thu, 23 Jun 2022 19:35:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when
 fw_devlink.strict=1
Content-Language: en-US
To:     Saravana Kannan <saravanak@google.com>,
        sascha hauer <sha@pengutronix.de>
Cc:     andrew lunn <andrew@lunn.ch>, peng fan <peng.fan@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linus walleij <linus.walleij@linaro.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        eric dumazet <edumazet@google.com>,
        pavel machek <pavel@ucw.cz>, will deacon <will@kernel.org>,
        kevin hilman <khilman@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        joerg roedel <joro@8bytes.org>,
        russell king <linux@armlinux.org.uk>,
        linux-acpi@vger.kernel.org, jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>, kernel-team@android.com,
        Len Brown <lenb@kernel.org>, len brown <len.brown@intel.com>,
        kernel@pengutronix.de, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        david ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        Daniel Scally <djrscally@gmail.com>,
        iommu@lists.linux-foundation.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        netdev@vger.kernel.org, "david s. miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, heiner kallweit <hkallweit1@gmail.com>
References: <20220623080344.783549-1-saravanak@google.com>
 <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de>
 <CAGETcx_eVkYtVX9=TOKnhpP2_ZpJwRDoBye3i7ND2u5Q-eQfPg@mail.gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <CAGETcx_eVkYtVX9=TOKnhpP2_ZpJwRDoBye3i7ND2u5Q-eQfPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Saravana,

On 23.06.22 19:26, Saravana Kannan wrote:
> On Thu, Jun 23, 2022 at 3:05 AM sascha hauer <sha@pengutronix.de> wrote:
>>
>> On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
>>> Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
>>> enabled iommus and dmas dependency enforcement by default. On some
>>> systems, this caused the console device's probe to get delayed until the
>>> deferred_probe_timeout expires.
>>>
>>> We need consoles to work as soon as possible, so mark the console device
>>> node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
>>> the probe of the console device for suppliers without drivers. The
>>> driver can then make the decision on where it can probe without those
>>> suppliers or defer its probe.
>>>
>>> Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
>>> Reported-by: Sascha Hauer <sha@pengutronix.de>
>>> Reported-by: Peng Fan <peng.fan@nxp.com>
>>> Signed-off-by: Saravana Kannan <saravanak@google.com>
>>> Tested-by: Peng Fan <peng.fan@nxp.com>
>>> ---
>>>  drivers/of/base.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>>> index d4f98c8469ed..a19cd0c73644 100644
>>> --- a/drivers/of/base.c
>>> +++ b/drivers/of/base.c
>>> @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>>>                       of_property_read_string(of_aliases, "stdout", &name);
>>>               if (name)
>>>                       of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
>>> +             if (of_stdout)
>>> +                     of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
>>
>> The device given in the stdout-path property doesn't necessarily have to
>> be consistent with the console= parameter. The former is usually
>> statically set in the device trees contained in the kernel while the
>> latter is dynamically set by the bootloader. So if you change the
>> console uart in the bootloader then you'll still run into this trap.
>>
>> It's problematic to consult only the device tree for dependencies. I
>> found several examples of drivers in the tree for which dma support
>> is optional. They use it if they can, but continue without it when
>> not available. "hwlock" is another property which consider several
>> drivers as optional. Also consider SoCs in early upstreaming phases
>> when the device tree is merged with "dmas" or "hwlock" properties,
>> but the corresponding drivers are not yet upstreamed. It's not nice
>> to defer probing of all these devices for a long time.
>>
>> I wonder if it wouldn't be a better approach to just probe all devices
>> and record the device(node) they are waiting on. Then you know that you
>> don't need to probe them again until the device they are waiting for
>> is available.
> 
> That actually breaks things in a worse sense. There are cases where
> the consumer driver is built in and the optional supplier driver is
> loaded at boot. Without fw_devlink and the deferred probe timeout, we
> end up probing the consumer with limited functionality. With the
> current setup, sure we delay some probes a bit but at least everything
> works with the right functionality. And you can reduce or remove the
> delay if you want to optimize it.

I have a system that doesn't use stdout-path and has the bootloader
set console= either to ttynull when secure booting or to an UART
when booting normally. How would I optimize the kernel to avoid
my UART being loaded after DMA controller probe without touching
the bootloader?

Cheers,
Ahmad

> 
> -Saravana
> 
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
