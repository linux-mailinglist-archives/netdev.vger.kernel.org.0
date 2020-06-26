Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CB320B5A4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgFZQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFZQJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:09:00 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE976C03E979;
        Fri, 26 Jun 2020 09:09:00 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id CD5392A2DA9
Subject: Re: [PATCH v4 07/11] thermal: Use mode helpers in drivers
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@collabora.com
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
 <CGME20200528192211eucas1p1dc9b49e1288321503954ed16d9e3001b@eucas1p1.samsung.com>
 <20200528192051.28034-8-andrzej.p@collabora.com>
 <313ca24a-0cc4-a976-19bb-0f30aa845226@samsung.com>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <fd77c8e7-25a2-49ca-676a-b8669d848adb@collabora.com>
Date:   Fri, 26 Jun 2020 18:08:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <313ca24a-0cc4-a976-19bb-0f30aa845226@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bartlomiej,

W dniu 24.06.2020 o 11:51, Bartlomiej Zolnierkiewicz pisze:
> 
> On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
>> Use thermal_zone_device_{en|dis}able() and thermal_zone_device_is_enabled().
>>
>> Consequently, all set_mode() implementations in drivers:
>>
>> - can stop modifying tzd's "mode" member,
>> - shall stop taking tzd's lock, as it is taken in the helpers
>> - shall stop calling thermal_zone_device_update() as it is called in the
>> helpers
>> - can assume they are called when the mode truly changes, so checks to
>> verify that can be dropped
>>
>> Not providing set_mode() by a driver no longer prevents the core from
>> being able to set tzd's mode, so the relevant check in mode_store() is
>> removed.
>>
>> Other comments:
>>
>> - acpi/thermal.c: tz->thermal_zone->mode will be updated only after we
>> return from set_mode(), so use function parameter in thermal_set_mode()
>> instead, no need to call acpi_thermal_check() in set_mode()
>> - thermal/imx_thermal.c: regmap writes and mode assignment are done in
>> thermal_zone_device_{en|dis}able() and set_mode() callback
>> - thermal/intel/intel_quark_dts_thermal.c: soc_dts_{en|dis}able() are a
>> part of set_mode() callback, so they don't need to modify tzd->mode, and
>> don't need to fall back to the opposite mode if unsuccessful, as the return
>> value will be propagated to thermal_zone_device_{en|dis}able() and
>> ultimately tzd's member will not be changed in thermal_zone_device_set_mode().
>> - thermal/of-thermal.c: no need to set zone->mode to DISABLED in
>> of_parse_thermal_zones() as a tzd is kzalloc'ed so mode is DISABLED anyway
>>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>> ---
>>   drivers/acpi/thermal.c                        | 21 ++++++-----
>>   .../ethernet/mellanox/mlxsw/core_thermal.c    | 37 +++++++++----------
>>   drivers/platform/x86/acerhdf.c                | 17 +++++----
>>   drivers/thermal/da9062-thermal.c              |  6 ++-
>>   drivers/thermal/hisi_thermal.c                |  6 ++-
>>   drivers/thermal/imx_thermal.c                 | 33 +++++++----------
>>   .../intel/int340x_thermal/int3400_thermal.c   |  5 +--
>>   .../thermal/intel/intel_quark_dts_thermal.c   | 18 ++-------
>>   drivers/thermal/rockchip_thermal.c            |  6 ++-
>>   drivers/thermal/sprd_thermal.c                |  6 ++-
>>   drivers/thermal/thermal_core.c                |  2 +-
>>   drivers/thermal/thermal_of.c                  | 10 +----
>>   drivers/thermal/thermal_sysfs.c               | 11 ++----
>>   13 files changed, 80 insertions(+), 98 deletions(-)
> 
> [...]
> 
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
>> index 32c5fe16b7f7..3efe749dc5a0 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -397,19 +397,16 @@ static inline void acerhdf_revert_to_bios_mode(void)
>>   {
>>   	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>>   	kernelmode = 0;
>> -	if (thz_dev) {
>> -		thz_dev->mode = THERMAL_DEVICE_DISABLED;
>> +	if (thz_dev)
>>   		thz_dev->polling_delay = 0;
>> -	}
>> +
>>   	pr_notice("kernel mode fan control OFF\n");
>>   }
>>   static inline void acerhdf_enable_kernelmode(void)
>>   {
>>   	kernelmode = 1;
>> -	thz_dev->mode = THERMAL_DEVICE_ENABLED;
>>   
>>   	thz_dev->polling_delay = interval*1000;
>> -	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
>>   	pr_notice("kernel mode fan control ON\n");
>>   }
>>   
>> @@ -723,6 +720,8 @@ static void acerhdf_unregister_platform(void)
>>   
>>   static int __init acerhdf_register_thermal(void)
>>   {
>> +	int ret;
>> +
>>   	cl_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
>>   						 &acerhdf_cooling_ops);
>>   
>> @@ -736,8 +735,12 @@ static int __init acerhdf_register_thermal(void)
>>   	if (IS_ERR(thz_dev))
>>   		return -EINVAL;
>>   
>> -	thz_dev->mode = kernelmode ?
>> -		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
>> +	if (kernelmode)
>> +		ret = thermal_zone_device_enable(thz_dev);
>> +	else
>> +		ret = thermal_zone_device_disable(thz_dev);
>> +	if (ret)
> 
> Cleanup on error seems to be missing here.

It does seem so, but it is not the case.

acerhdf_register_thermal() is called from acerhdf_init().
The latter checks the return value of the former and on error
jumps to the err_unreg label, where thermal zone(s) is/are unregistered.

Regards,

Andrzej
