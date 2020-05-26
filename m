Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4302E1E27C0
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgEZQ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgEZQ42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:56:28 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229EEC03E96D;
        Tue, 26 May 2020 09:56:28 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 2D2A02A336C
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
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
 <802b4bd5-07c9-de3a-2ac6-5905b12d6adc@collabora.com>
 <b8b69bf3-07bf-8747-dce6-65a73c02fb88@linaro.org>
Message-ID: <5d59710a-3555-79ef-a354-a132b6084c63@collabora.com>
Date:   Tue, 26 May 2020 18:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b8b69bf3-07bf-8747-dce6-65a73c02fb88@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

W dniu 26.05.2020 o 00:08, Daniel Lezcano pisze:
> On 25/05/2020 21:35, Andrzej Pietrasiewicz wrote:
>> Hi Daniel,
>>
>> W dniu 23.05.2020 o 23:24, Daniel Lezcano pisze:
>>> Hi Andrzej,
>>>
>>> On 17/04/2020 18:20, Andrzej Pietrasiewicz wrote:
>>>> Thermal zone devices' mode is stored in individual drivers. This patch
>>>> changes it so that mode is stored in struct thermal_zone_device instead.
>>>>
>>>> As a result all driver-specific variables storing the mode are not
>>>> needed
>>>> and are removed. Consequently, the get_mode() implementations have
>>>> nothing
>>>> to operate on and need to be removed, too.
>>>>
>>>> Some thermal framework specific functions are introduced:
>>>>
>>>> thermal_zone_device_get_mode()
>>>> thermal_zone_device_set_mode()
>>>> thermal_zone_device_enable()
>>>> thermal_zone_device_disable()
>>>>
>>>> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
>>>> and the "set" calls driver's set_mode() if provided, so the latter must
>>>> not take this lock again. At the end of the "set"
>>>> thermal_zone_device_update() is called so drivers don't need to
>>>> repeat this
>>>> invocation in their specific set_mode() implementations.
>>>>
>>>> The scope of the above 4 functions is purposedly limited to the thermal
>>>> framework and drivers are not supposed to call them. This encapsulation
>>>> does not fully work at the moment for some drivers, though:
>>>>
>>>> - platform/x86/acerhdf.c
>>>> - drivers/thermal/imx_thermal.c
>>>> - drivers/thermal/intel/intel_quark_dts_thermal.c
>>>> - drivers/thermal/of-thermal.c
>>>>
>>>> and they manipulate struct thermal_zone_device's members directly.
>>>>
>>>> struct thermal_zone_params gains a new member called initial_mode, which
>>>> is used to set tzd's mode at registration time.
>>>>
>>>> The sysfs "mode" attribute is always exposed from now on, because all
>>>> thermal zone devices now have their get_mode() implemented at the
>>>> generic
>>>> level and it is always available. Exposing "mode" doesn't hurt the
>>>> drivers
>>>> which don't provide their own set_mode(), because writing to "mode" will
>>>> result in -EPERM, as expected.
>>>
>>> The result is great, that is a nice cleanup of the thermal framework.
>>>
>>> After review it appears there are still problems IMO, especially with
>>> the suspend / resume path. The patch is big, it is a bit complex to
>>> comment. I suggest to re-org the changes as following:
>>>
>>>    - patch 1 : Add the four functions:
>>>
>>>    * thermal_zone_device_set_mode()
>>>    * thermal_zone_device_enable()
>>>    * thermal_zone_device_disable()
>>>    * thermal_zone_device_is_enabled()
>>>
>>> *but* do not export thermal_zone_device_set_mode(), it must stay private
>>> to the thermal framework ATM.
>>
>> Not exporting thermal_zone_device_set_mode() implies not exporting
>> thermal_zone_device_enable()/thermal_zone_device_disable() because they
>> are implemented in terms of the former. Or do you have a different idea?
> 
> I meant no inline for them but as below:
> 
> in .h
> 
> extern int thermal_zone_device_enable();
> extern int thermal_zone_device_disable();
> extern int thermal_zone_device_is_enabled();
> 
> in .c
> 
> static int thermal_zone_device_set_mode()
> {
> 	...
> }
> 
> int thermal_zone_device_enable()
> {
> 	thermal_zone_device_set_mode();
> }
> EXPORT_SYMBOL_GPL(thermal_zone_device_enable);
> 

Hmm. I'm trying to proceed according to what you outline, but it
doesn't feel the right approach. Let me show you patch 1:

drivers/thermal/thermal_core.c:

+int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode mode)
+{
+	int ret = 0;
+
+	mutex_lock(&tz->lock);
+
+	if (tz->ops->set_mode)
+		ret = tz->ops->set_mode(tz, mode);
+
+	mutex_unlock(&tz->lock);
+
+	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+
+	return ret;
+}
+
+int thermal_zone_device_enable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
+}
+EXPORT_SYMBOL(thermal_zone_device_enable);
+
+int thermal_zone_device_disable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
+}
+EXPORT_SYMBOL(thermal_zone_device_disable);
+
+int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
+{
+	enum thermal_device_mode mode = THERMAL_DEVICE_ENABLED;
+	int ret;
+
+	mutex_lock(&tz->lock);
+
+	if (tz->ops->get_mode)
+		ret = tz->ops->get_mode(tz, &mode);
+
+	mutex_unlock(&tz->lock);
+
+	return mode == THERMAL_DEVICE_ENABLED;
+}
+EXPORT_SYMBOL(thermal_zone_device_is_enabled);
+

plus prototypes of all except set_mode in include/linux/thermal.h

I can see 2 problems:

1) we add unused code to the kernel (perhaps this is ok if patches in this
series will start using it)
2) tzd *does not* store mode. These are drivers that provide mode access
with get_mode()/set_mode() - if they implement them. What if they don't?
If thermal_zone_device_set_mode() is introduced now its effect depends on
whether a driver implements set_mode() or not. If it doesn't then despite
thermal_zone_device_set_mode() being invoked the mode is not changed.
Then what does thermal_zone_device_is_enabled() mean? We don't know, because
we don't know what the effect of thermal_zone_device_set_mode() is in the
first place. And if the driver does not provide get_mode() then
thermal_zone_device_is_enabled() always returns "enabled".

Adding these functions now without mode being stored in tzd seems awkward
to me. Consequently, IMO the first thing to do is make tzd store device's
mode and this way be independent from whether drivers implement or not
implement get_mode()/set_mode().

> 
>>>    - patch 2 : Add the mode THERMAL_DEVICE_SUSPENDED
>>>
>>> In the thermal_pm_notify() in the:
>>>
>>>    - PM_SUSPEND_PREPARE case, set the mode to THERMAL_DEVICE_SUSPENDED if
>>> the mode is THERMAL_DEVICE_ENABLED
>>>
>>>    - PM_POST_SUSPEND case, set the mode to THERMAL_DEVICE_ENABLED, if the
>>> mode is THERMAL_DEVICE_SUSPENDED
>>>

drivers/thermal/thermal_core.c:

  	case PM_HIBERNATION_PREPARE:
  	case PM_RESTORE_PREPARE:
  	case PM_SUSPEND_PREPARE:
+		list_for_each_entry(tz, &thermal_tz_list, node) {
+			tz_mode = THERMAL_DEVICE_ENABLED;
+			if (tz->ops->get_mode)
+				tz->ops->get_mode(tz, &tz_mode);
+			if (tz_mode == THERMAL_DEVICE_ENABLED)
+				thermal_zone_device_set_mode(tz,
+						THERMAL_DEVICE_SUSPENDED);
+		}
  		atomic_set(&in_suspend, 1);
  		break;
  	case PM_POST_HIBERNATION:
@@ -1530,6 +1538,9 @@ static int thermal_pm_notify(struct notifier_block *nb,
   			tz_mode = THERMAL_DEVICE_ENABLED;
  			if (tz->ops->get_mode)
  				tz->ops->get_mode(tz, &tz_mode);

  			if (tz_mode == THERMAL_DEVICE_DISABLED)
  				continue;
+			if (tz_mode == THERMAL_DEVICE_SUSPENDED)
+				thermal_zone_device_set_mode(tz,
+						THERMAL_DEVICE_ENABLED);


include/linux/thermal.h:
  enum thermal_device_mode {
  	THERMAL_DEVICE_DISABLED = 0,
  	THERMAL_DEVICE_ENABLED,
+	THERMAL_DEVICE_SUSPENDED,

We don't know if set_mode() was effective in PM_SUSPEND_PREPARE_PATH.
If it wasn't then instead of being SUSPENDED the device is still ENABLED.
If still enabled it doesn't need enabling so the last "if" does the
right thing, but does not feel right.

>>>    - patch 3 : Change the monitor function
>>>
>>> Change monitor_thermal_zone() function to set the polling to zero if the
>>> mode is THERMAL_DEVICE_DISABLED
>>
>> So we assume this: if a driver creates a tz which is initially ENABLED,
>> it will be polled. If a driver creates a tz which is initially DISABLED
>> (which is what you suggest the drivers should be doing, but not all of them
>> do), it won't be polled unless the driver explicitly enables its tz.
> 
> Yes.
> 
>> Am I concluding right that a suspended device will remain polled? Is it ok?
> 
> Actually it is not ok but AFAICT, it is the current behavior. The
> polling do not stop but the 'in_suspend' prevent an update. I thought we
> can post-pone the suspend case later when the ENABLED/DISABLED changes
> are consolidated, so SUSPENDED will act as DISABLED.
> 

drivers/thermal/thermal_core.c:

  static void monitor_thermal_zone(struct thermal_zone_device *tz)
  {
+	enum thermal_device_mode tz_mode = THERMAL_DEVICE_ENABLED;
+
  	mutex_lock(&tz->lock);

-	if (tz->passive)
+	if (tz->ops->get_mode)
+		tz->ops->get_mode(tz, &tz_mode);
+
+	if (tz->passive && mode != THERMAL_DEVICE_DISABLED)
  		thermal_zone_device_set_polling(tz, tz->passive_delay);
-	else if (tz->polling_delay)
+	else if (tz->polling_delay && mode != THERMAL_DEVICE_DISABLED)
  		thermal_zone_device_set_polling(tz, tz->polling_delay);
  	else
  		thermal_zone_device_set_polling(tz, 0);

If the driver does not implement get_mode() then we assume ENABLED.
What if it is actually DISABLED?

How does this depend on patch 1 or patch 2?

>>>    - patch 4 : Do the changes to remove get_mode() ops
>>>
>>> Make sure there is no access to tz->mode from the drivers anymore but
>>> use of the functions of patch 1. IMO, this is the tricky part because a
>>> part of the drivers are not calling the update after setting the mode
>>> while the function thermal_zone_device_enable()/disable() call update
>>> via the thermal_zone_device_set_mode(), so we must be sure to not break
>>> anything.
>>

I haven't started this yet, but again it seems to me that drivers need
to start storing their mode in tzd->mode in the first place

So what I envision is this:

1) Make all drivers store their state still locally, but using the enum
(not all of them do)

2) Once all drivers store their state in the enum, store the enum in
struct tzd instead of locally in drivers. This makes get_mode() driver
op redundant, but if you prefer more granularity removing it might be
done in a separate patch (at the expense of modifying it now to use
tzd's member instead of driver-local variable). This also impacts set_mode()
ops, because they need to actually change tzd's member instead of some
driver-level variable. Changing set_mode() IMO needs to be done in one go.

3) Remove get_mode() driver op altogether, as the mode is stored in
struct tzd.

4) patch 1 you outlined - set_mode() and is_enabled() will now operate
on tzd's members, so their effect does not depend on drivers implementing
or not implementing set_mode(). These effects don't depend on get_mode()
any more because of 3). set_mode() would still be calling the set_mode()
op in drivers before modifying tzd->mode.

5) patch 2 you outlined - but it can't use thermal_zone_device_set_mode(),
because if it gets and then changes tzd's mode, it must do so under
tzd->lock. This is ok as this is the very implementation of thermal_core,
so accessing "private" members of tzd is a valid approach here.

6) patch 3 you outlined - now it makes much more sense to query tzd's member
for mode instead of relying on drivers implementing get_mode().

7) patch 4 you outlined but under a different name, because get_mode()
is already gone. The guts of the patch should be doing what you wrote,
though, which is use the helpers instead of directly modifying tzd's
members in drivers.

8) patch 5 you outlined - perhaps under a different name, but still
doing the same thing: removing portions of code which set polling time to
zero in drivers, as that is already being done at tzd's level. This would
hopefully make at least some set_mode() implementations no-ops and,
consequently, redundant. I can see these drivers: mellanox, part of
acerhdf (this driver wants to know when it is becoming enabled/disabled,
but the part setting polling can be removed), part of imx (similar
situation to that of acerhdf) and of-thermal.

After 8) there would be 5 non-empty set_mode() implementations:

acpi - but apparently only to print some debug, maybe can be removed
acerhdf - no idea if it can live without knowing when the mode changes
imx - ditto
int3400 - ditto
quark - ditto

Perhaps after 8) instead of removing set_mode() maybe we should change
its name to better reflect its purpose: mode_changing() ? Or maybe
even such a change should be a part of 4)?

Regards,

Andrzej
