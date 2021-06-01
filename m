Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72060397243
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhFALZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:25:53 -0400
Received: from phobos.denx.de ([85.214.62.61]:49358 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233669AbhFALZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 07:25:53 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 989B581E53;
        Tue,  1 Jun 2021 13:24:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1622546650;
        bh=RroPKtbFJQSMP/iLjGkKVj+A5yN19PkqgH8gsUMorI0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=h0GGXPmkBRsoC00pYZ7k3i7iFsPz/+gDpfI0vBNDB2OBknJgeurxTZ0Y1IMteciUu
         6qfIf7nOexoPa0i2kk0Mi17NV04E83sntgaSp6orkZYisHgVq1ttOX2EZEAGUTfx1W
         34Dxx20eUfKxkfdk7UE9QjmbJYUvraTVqW3XayNOwOih8r2oxoghZjnIEKHaqUy026
         i1C5VycWz7Ufn7FY3PJ2Pm214KJWxdtclzqwPaAqVEZAx2hQXKagxQiXBryE2wirzO
         KID/IdjMyHIFuCPU6iJFSaSrQc7tbTSbk73VngTDTjixhl9Emz4wkHBDKCWN8R+Rws
         7eo8YlqXmiTVg==
Subject: Re: [PATCH] rsi: fix broken AP mode due to unwanted encryption
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Angus Ainslie <angus@akkea.ca>,
        =?UTF-8?Q?Guido_G=c3=bcnther?= <agx@sigxcpu.org>
References: <1622222314-17192-1-git-send-email-martin.fuzzey@flowbird.group>
 <6f1d3952-c30e-4a6d-9857-5a6d68e962b2@denx.de>
 <CANh8QzykdFSvmEgY=iTyZdbzg5Uv785zVZdAoYbrx2--sDyiCQ@mail.gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <c503e8e8-6082-3f81-f22d-efdbf4a1b357@denx.de>
Date:   Tue, 1 Jun 2021 13:24:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CANh8QzykdFSvmEgY=iTyZdbzg5Uv785zVZdAoYbrx2--sDyiCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 11:02 AM, Fuzzey, Martin wrote:
> Hi Marek,
> thanks for the review.

Hi,

> On Fri, 28 May 2021 at 20:11, Marek Vasut <marex@denx.de> wrote:
>>
>>> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
>>> CC: stable@vger.kernel.org
>>
>> This likely needs a Fixes: tag ?
>>
> 
> I'm not quite sure what that should be.

Based on git log -p --follow drivers/net/wireless/rsi/rsi_91x_hal.c

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")

> The test involved here has been present since the very first version
> of the driver back in 2014 but at that time AP mode wasn't supported.
> 
> AP mode was added in 2017 by the patch series "rsi: support for AP mode" [1]
> In particular 38ef62353acb ("rsi: security enhancements for AP mode")
> does some stuff relating to AP key configuration but it doesn't
> actually change the behaviour concerning the encryption condition.
> 
> In fact I don't understand how it ever worked in AP WPA2 mode given
> that secinfo->security_enable (which is tested in the encryption
> condition) has always been unconditionally set in set_key (when
> setting not deleting).
> Yet the series cover letter [1] says "Tests are performed to confirm
> aggregation, connections in WEP and WPA/WPA2 security."

There are way too many bugs in that RSI driver, yes. Compared to the 
other WiFi vendors, this driver seems to be real poor.

> The problem is that in AP mode with WPA2 there is a set_key done at AP
> startup time to set the GTK (but not yet the pairwise key which is
> only done after the 4 way handshake) so this sets security_enable to
> true which later causes the EAPOL messages to be sent encrypted.
> 
> Maybe there have been userspace changes to hostapd that have changed
> the time at which the GTK is set?
> I had a quick look at the hostapd history but didn't see anything obvious.

I recall seeing a patched WPA supplicant in one set of the RSI 
downstream drivers. And then there is another older RSI "onebox" driver 
which definitely ships patched userspace components. So I wouldn't be 
surprised if some of that was involved.

> I'm going to send a V2 completely removing the security_enable flag in
> addition to adding the new test (which is what downstream has too).
> Keeping security_enable doesn't actually break anything but is
> redundant and confusing.
> 
> Unfortunately I cannot find any downstream history, I just have 2
> downstream tarballs, a "2.0 RC2" which has the same problem as
> mainline and a "2.0 RC4" which does not

Yes indeed, I pointed that out to RSI before, that this kind of release 
management is useless. I'm still waiting for any input from them.

> [1] https://www.spinics.net/lists/linux-wireless/msg165302.html
> 
>>>        if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
>>> +         (info->control.hw_key) &&
>>
>> The () are not needed.
>>
> 
> Ok, will fix for V2

Thanks
