Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D7DBF3BD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfIZNId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:08:33 -0400
Received: from 3.mo68.mail-out.ovh.net ([46.105.58.60]:60745 "EHLO
        3.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfIZNId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:08:33 -0400
X-Greylist: delayed 4204 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2019 09:08:32 EDT
Received: from player688.ha.ovh.net (unknown [10.109.159.136])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id BD6511436D2
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 13:52:17 +0200 (CEST)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player688.ha.ovh.net (Postfix) with ESMTPSA id 1EFA2A2EC583;
        Thu, 26 Sep 2019 11:52:07 +0000 (UTC)
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy crashes
To:     Jouni Malinen <j@w1.fi>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.infradead.org,
        openwrt-devel@lists.openwrt.org
References: <20190920133708.15313-1-zajec5@gmail.com>
 <20190920140143.GA30514@w1.fi>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <4f6f37e5-802c-4504-3dcb-c4a640d138bd@milecki.pl>
Date:   Thu, 26 Sep 2019 13:52:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190920140143.GA30514@w1.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11993367286735539761
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrfeeggdeggecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.09.2019 16:01, Jouni Malinen wrote:
> On Fri, Sep 20, 2019 at 03:37:08PM +0200, Rafał Miłecki wrote:
>> Hardware or firmware instability may result in unusable wiphy. In such
>> cases usually a hardware reset is needed. To allow a full recovery
>> kernel has to indicate problem to the user space.
> 
> Why? Shouldn't the driver be able to handle this on its own since all
> the previous configuration was done through the driver anyway. As far as
> I know, there are drivers that do indeed try to do this and handle it
> successfully at least for station mode. AP mode may be more complex, but
> for that one, I guess it would be fine to drop all associations (and
> provide indication of that to user space) and just restart the BSS.

Indeed my main concert is AP mode. I'm afraid that cfg80211 doesn't
cache all settings, consider e.g. nl80211_start_ap(). It builds
struct cfg80211_ap_settings using info from nl80211 message and
passes it to the driver (rdev_start_ap()). Once it's done it
caches only a small subset of all setup data.

In other words driver doesn't have enough info to recover interfaces
setup.


>> This new nl80211 command lets user space known wiphy has crashed and has
>> been just recovered. When applicable it should result in supplicant or
>> authenticator reconfiguring all interfaces.
> 
> For me, that is not really "recovered" if some additional
> reconfiguration steps are needed.. I'd like to get a more detailed view
> on what exactly might need to be reconfigured and how would user space
> know what exactly to do. Or would the plan here be that the driver would
> not even indicate this crash if it is actually able to internally
> recover fully from the firmware restart?

I meant that hardware has been recovered & is operational again (driver
can talk to it). I expected user space to reconfigure all interfaces
using the same settings that were used on previous run.

If driver were able to recover interfaces setup on its own (with a help
of cfg80211) then user space wouldn't need to be involved.


>> I'd like to use this new cfg80211_crash_report() in brcmfmac after a
>> successful recovery from a FullMAC firmware crash.
>>
>> Later on I'd like to modify hostapd to reconfigure wiphy using a
>> previously used setup.
> 
> So this implies that at least something would need to happen in AP mode.
> Do you have a list of items that the driver cannot do on its own and why
> it would be better to do them from user space?

First of all I was wondering how to handle interfaces creation. After a
firmware crash we have:
1) Interfaces created in Linux
2) No corresponsing interfaces in firmware

Syncing that (re-creating in-firmware firmwares) may be a bit tricky
depending on a driver and hardware. For some cases it could be easier to
delete all interfaces and ask user space to setup wiphy (create required
interfaces) again. I'm not sure if that's acceptable though?

If we agree interfaces should stay and driver simply should configure
firmware properly, then we need all data as explained earlier. struct
cfg80211_ap_settings is not available during runtime. How should we
handle that problem?


>> I'm OpenWrt developer & user and I got annoyed by my devices not auto
>> recovering after various failures. There are things I cannot fix (hw
>> failures or closed fw crashes) but I still expect my devices to get
>> back to operational state as soon as possible on their own.
> 
> I fully agree with the auto recovery being important thing to cover for
> this, but I'm not yet convinced that this needs user space action. Or if
> it does, there would need to be more detailed way of indicating what
> exactly is needed for user space to do. The proposed change here is just
> saying "hey, I crashed and did something to get the hardware/firmware
> responding again" which does not really tell much to user space other
> than potentially requiring full disable + re-enable for the related
> interfaces. And that is something that should not actually be done in
> all cases of firmware crashes since there are drivers that handle
> recovery in a manner that is in practice completely transparent to user
> space.

I was aiming for a brutal force solution: just make user space
interfaces need a full setup just at they were just created.
