Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA900263630
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIISn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIISn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:43:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21915C061573;
        Wed,  9 Sep 2020 11:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=EaCCaUS/GA5zKTWx+EqB8AflyC7OJgYop8KOzI5rmeE=; b=GomwRcHmRkv+TFrVR0WQdaBrR0
        IdVlKI/PUaruAuCEPKQBmtZ7JZL4we75h3/irAUxJ5gsU6M6mTs94C2fOhTV5pfIxcT3EddDzUl3v
        bu8NKjOCp53mKvhHgrfPPxWkyrooRmtL8rXlsAQoHv7o2YfeSyCdsDl3NgWQ472DZXJGPePZ55nSQ
        2OKgY8UtasfDK043LRoY1nwBTIYe2u5DI6qP7K08HwvybWJBo+CFTJ2p/0tzGYKZYGX/OGo7ChH74
        BOTNo89H1Y+r6WmkB5DnHB9RsbMya/p7/YqieedDFsC5IKr9tKeJzgWaoH852g0zCtGTfYU7xTrVI
        PBNIWO2Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG549-0005ns-Am; Wed, 09 Sep 2020 18:43:34 +0000
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=c5=99ej_Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-3-marek.behun@nic.cz>
 <84bfc0ce-752d-9d1f-1043-fabe4cc25b15@infradead.org>
 <20200909203121.73bfcfa1@dellmb.labs.office.nic.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <444169ca-cfd7-dcb5-3ce6-59d3bfea6190@infradead.org>
Date:   Wed, 9 Sep 2020 11:43:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909203121.73bfcfa1@dellmb.labs.office.nic.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 11:31 AM, Marek Behún wrote:
> On Wed, 9 Sep 2020 11:20:00 -0700
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> Hi,
>>
>> On 9/9/20 9:25 AM, Marek Behún wrote:
>>> Many an ethernet PHY (and other chips) supports various HW control
>>> modes for LEDs connected directly to them.
>>>
>>> This patch adds a generic API for registering such LEDs when
>>> described in device tree. This API also exposes generic way to
>>> select between these hardware control modes.
>>>
>>> This API registers a new private LED trigger called dev-hw-mode.
>>> When this trigger is enabled for a LED, the various HW control
>>> modes which are supported by the device for given LED can be
>>> get/set via hw_mode sysfs file.
>>>
>>> Signed-off-by: Marek Behún <marek.behun@nic.cz>
>>> ---
>>>  .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
>>>  drivers/leds/Kconfig                          |  10 +
>>>  drivers/leds/Makefile                         |   1 +
>>>  drivers/leds/leds-hw-controlled.c             | 227
>>> ++++++++++++++++++ include/linux/leds-hw-controlled.h            |
>>> 74 ++++++ 5 files changed, 320 insertions(+)
>>>  create mode 100644
>>> Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
>>> create mode 100644 drivers/leds/leds-hw-controlled.c create mode
>>> 100644 include/linux/leds-hw-controlled.h 
>>
>>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>>> index 1c181df24eae4..5e47ab21aafb4 100644
>>> --- a/drivers/leds/Kconfig
>>> +++ b/drivers/leds/Kconfig
>>> @@ -49,6 +49,16 @@ config LEDS_BRIGHTNESS_HW_CHANGED
>>>  
>>>  	  See Documentation/ABI/testing/sysfs-class-led for
>>> details. 
>>> +config LEDS_HW_CONTROLLED
>>> +	bool "API for LEDs that can be controlled by hardware"
>>> +	depends on LEDS_CLASS  
>>
>> 	depends on OF || COMPILE_TEST
>> ?
>>
> 
> I specifically did not add OF dependency so that this can be also used
> on non-OF systems. A device driver may register such LED itself...
> That's why hw_controlled_led_brightness_set symbol is exported.
> 
> Do you think I shouldn't do it?

I have no problem with it as it is.

>>> +	select LEDS_TRIGGERS
>>> +	help
>>> +	  This option enables support for a generic API via which
>>> other drivers
>>> +	  can register LEDs that can be put into hardware
>>> controlled mode, eg.  

thanks.
-- 
~Randy

