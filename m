Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6711E1E14CE
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390119AbgEYTfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389904AbgEYTfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 15:35:37 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E722C061A0E;
        Mon, 25 May 2020 12:35:37 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 812F52A17E9
Subject: Re: [RFC v3 1/2] thermal: core: Let thermal zone device's mode be
 stored in its struct
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
 <20200417162020.19980-1-andrzej.p@collabora.com>
 <20200417162020.19980-2-andrzej.p@collabora.com>
 <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <802b4bd5-07c9-de3a-2ac6-5905b12d6adc@collabora.com>
Date:   Mon, 25 May 2020 21:35:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

W dniu 23.05.2020 o 23:24, Daniel Lezcano pisze:
> Hi Andrzej,
> 
> On 17/04/2020 18:20, Andrzej Pietrasiewicz wrote:
>> Thermal zone devices' mode is stored in individual drivers. This patch
>> changes it so that mode is stored in struct thermal_zone_device instead.
>>
>> As a result all driver-specific variables storing the mode are not needed
>> and are removed. Consequently, the get_mode() implementations have nothing
>> to operate on and need to be removed, too.
>>
>> Some thermal framework specific functions are introduced:
>>
>> thermal_zone_device_get_mode()
>> thermal_zone_device_set_mode()
>> thermal_zone_device_enable()
>> thermal_zone_device_disable()
>>
>> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
>> and the "set" calls driver's set_mode() if provided, so the latter must
>> not take this lock again. At the end of the "set"
>> thermal_zone_device_update() is called so drivers don't need to repeat this
>> invocation in their specific set_mode() implementations.
>>
>> The scope of the above 4 functions is purposedly limited to the thermal
>> framework and drivers are not supposed to call them. This encapsulation
>> does not fully work at the moment for some drivers, though:
>>
>> - platform/x86/acerhdf.c
>> - drivers/thermal/imx_thermal.c
>> - drivers/thermal/intel/intel_quark_dts_thermal.c
>> - drivers/thermal/of-thermal.c
>>
>> and they manipulate struct thermal_zone_device's members directly.
>>
>> struct thermal_zone_params gains a new member called initial_mode, which
>> is used to set tzd's mode at registration time.
>>
>> The sysfs "mode" attribute is always exposed from now on, because all
>> thermal zone devices now have their get_mode() implemented at the generic
>> level and it is always available. Exposing "mode" doesn't hurt the drivers
>> which don't provide their own set_mode(), because writing to "mode" will
>> result in -EPERM, as expected.
> 
> The result is great, that is a nice cleanup of the thermal framework.
> 
> After review it appears there are still problems IMO, especially with
> the suspend / resume path. The patch is big, it is a bit complex to
> comment. I suggest to re-org the changes as following:
> 
>   - patch 1 : Add the four functions:
> 
>   * thermal_zone_device_set_mode()
>   * thermal_zone_device_enable()
>   * thermal_zone_device_disable()
>   * thermal_zone_device_is_enabled()
> 
> *but* do not export thermal_zone_device_set_mode(), it must stay private
> to the thermal framework ATM.

Not exporting thermal_zone_device_set_mode() implies not exporting
thermal_zone_device_enable()/thermal_zone_device_disable() because they
are implemented in terms of the former. Or do you have a different idea?

> 
>   - patch 2 : Add the mode THERMAL_DEVICE_SUSPENDED
> 
> In the thermal_pm_notify() in the:
> 
>   - PM_SUSPEND_PREPARE case, set the mode to THERMAL_DEVICE_SUSPENDED if
> the mode is THERMAL_DEVICE_ENABLED
> 
>   - PM_POST_SUSPEND case, set the mode to THERMAL_DEVICE_ENABLED, if the
> mode is THERMAL_DEVICE_SUSPENDED
> 
>   - patch 3 : Change the monitor function
> 
> Change monitor_thermal_zone() function to set the polling to zero if the
> mode is THERMAL_DEVICE_DISABLED

So we assume this: if a driver creates a tz which is initially ENABLED,
it will be polled. If a driver creates a tz which is initially DISABLED
(which is what you suggest the drivers should be doing, but not all of them
do), it won't be polled unless the driver explicitly enables its tz.

Am I concluding right that a suspended device will remain polled? Is it ok?

> 
>   - patch 4 : Do the changes to remove get_mode() ops
> 
> Make sure there is no access to tz->mode from the drivers anymore but
> use of the functions of patch 1. IMO, this is the tricky part because a
> part of the drivers are not calling the update after setting the mode
> while the function thermal_zone_device_enable()/disable() call update
> via the thermal_zone_device_set_mode(), so we must be sure to not break
> anything.

Ah, I guess now is the time to make the functions from patch 1 exported?

Ensuring no driver accesses tz->mode directly might be tricky, indeed.
If it can be shown that calling the update doesn't hurt a particular driver,
it can be converted to use the helpers instead of manipulating tz->mode
directly. If, however, it does make a difference then it all depends and
getting rid of accessing tz->mode directly might require help from the
respective maintainers.

This also calls for storing tz's mode in struct thermal_zone_device
rather than in individual drivers. In fact it seems the purpose
of ->get_mode() is to produce the state stored internally in drivers.
Removing ->get_mode() requires changing the place where the state is
stored. struct thermal_zone_device seems most appropriate. So this patch
is not going to be small.

Once we start storing tz's state in struct thermal_zone_device the
->set_mode() implementations need to be changed, too. To me it seems
awkward to split this change in two patches: if we keep the changes
split then in patch 4 we need to introduce code which implements
->set_mode() in terms of the new state location, only to remove it
in the very next patch.

While we are at it some drivers, namely acpi/thermal and int3400 store
their mode in an int rather than enum thermal_device_mode. So maybe
changing this should go even before patch 4? acerhdf does not store
its mode at all and on top of it it wants to manipulate the polling
delay directly and it has a module parameter which specifies it.

> 
>   - patch 5 : Do the changes to remove set_mode() ops users
> 
> As the patch 3 sets the polling to zero, the routine in the driver
> setting the polling to zero is no longer needed (eg. in the mellanox
> driver). I expect int300 to be the last user of this ops, hopefully we
> can find a way to get rid of the specific call done inside and then
> remove the ops.

acerhdf wants ->set_mode() desperately.

> 
> The initial_mode approach looks hackish, I suggest to make the default
> the thermal zone disabled after creating and then explicitly enable it.

Is it needed in drivers which create their thermal zone enabled?

Regards,

Andrzej
