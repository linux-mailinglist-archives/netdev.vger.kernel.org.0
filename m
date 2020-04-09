Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D571A32F4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDILKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 07:10:13 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36506 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDILKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 07:10:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 81A6D2979A5
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20200407174926.23971-1-andrzej.p@collabora.com>
 <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
Date:   Thu, 9 Apr 2020 13:10:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

W dniu 09.04.2020 o 12:29, Daniel Lezcano pisze:
> On 07/04/2020 19:49, Andrzej Pietrasiewicz wrote:
>> The current kernel behavior is to keep polling the thermal zone devices
>> regardless of their current mode. This is not desired, as all such "disabled"
>> devices are meant to be handled by userspace,> so polling them makes no sense.
> 
> Thanks for proposing these changes.
> 
> I've been (quickly) through the series and the description below. I have
> the feeling the series makes more complex while the current code which
> would deserve a cleanup.
> 
> Why not first:
> 
>   - Add a 'mode' field in the thermal zone device
>   - Kill all set/get_mode callbacks in the drivers which are duplicated code.
>   - Add a function:
> 
>   enum thermal_device_mode thermal_zone_get_mode( *tz)
>   {
> 	...
> 	if (tz->ops->get_mode)
> 		return tz->ops->get_mode();
> 
> 	return tz->mode;
>   }
> 
> 
>   int thermal_zone_set_mode(..*tz, enum thermal_device_mode mode)
>   {
> 	...
> 	if (tz->ops->set_mode)
> 		return tz->ops->set_mode(tz, mode);
> 
> 	tz->mode = mode;
> 
> 	return 0;
>   }
> 
>   static inline thermal_zone_enable(... *tz)
>   {
> 	thermal_zone_set_mode(tz, THERMAL_DEVICE_ENABLED);
>   }
> 
>   static inline thermal_zone_disable(... *tz) {
> 	thermal_zone_set_mode(tz, THERMAL_DEVICE_DISABLED);
>   }
> 
> And then when the code is consolidated, use the mode to enable/disable
> the polling and continue killing the duplicated code in of-thermal.c and
> anywhere else.
> 
> 

Thanks for feedback.

Anyone else?

Andrzej
