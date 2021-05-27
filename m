Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AAB39348A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhE0RIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:08:44 -0400
Received: from phobos.denx.de ([85.214.62.61]:38450 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235279AbhE0RIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:08:41 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 91EE182A8D;
        Thu, 27 May 2021 19:07:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1622135226;
        bh=+E8QvEVlUcPn0+wkeL13KnnBaduvv01SOpA+5jCMOEw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FjV+jqOhx0Pg/7AhNTXgVsOOsJyPA2M0DxpFfDDnSJzQ0JSmzjZUnVvRa7uNei+6F
         Tj8++aprBzx1JQZbpK18SBI6aNi/cUHzGkdiTJepUBKvksHJkh0Zo3P78NWKKkrGzU
         hDwmcGVoOsd6ocum7G+O4e7aqaRVGIF4V1ngXqKN2Xmr51/UaZ5CJDOtpx4a5dqh8Y
         5mTFlgHMK2noy4dqN8AfB5Xy0Ob7a6buVO/LVMpqPXcu6crE5Ji+gCnPthrrwr4gyG
         gXS5o3zOVPqKTy8PpqeBbG+vB/jvx35uWUQY8By6NrPZEWewsftUs9+qnO/PyWw42s
         ha4PmuHmSjE2w==
Subject: Re: [PATCH] rsi: Fix TX EAPOL packet handling against iwlwifi AP
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        netdev@vger.kernel.org
Cc:     Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20201015111616.429220-1-marex@denx.de>
 <ba9013a8-38e4-f1ee-05a7-c3cf668bf449@flowbird.group>
From:   Marek Vasut <marex@denx.de>
Message-ID: <2550c80c-471b-4723-4061-a488b8b85fd8@denx.de>
Date:   Thu, 27 May 2021 19:07:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <ba9013a8-38e4-f1ee-05a7-c3cf668bf449@flowbird.group>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/21 6:52 PM, Martin Fuzzey wrote:
> Hi Marek,

Hi,

> I've just run into the same problem (on -5.4) and found your (now 
> merged) patch

The patch should already be part of 5.4.y, no ?

> On 15/10/2020 13:16, Marek Vasut wrote:
>> In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in 
>> AP mode,
>> the association fails. The former is using wpa_supplicant during 
>> association,
>> the later is set up using hostapd:
>>
>> iwl$ cat hostapd.conf
>> interface=wlp1s0
>> ssid=test
>> country_code=DE
>> hw_mode=g
>> channel=1
>> wpa=2
>> wpa_passphrase=test
>> wpa_key_mgmt=WPA-PSK
>> iwl$ hostapd -d hostapd.conf
>>
>> rsi$ wpa_supplicant -i wlan0 -c <(wpa_passphrase test test)
>>
>> The problem is that the TX EAPOL data descriptor 
>> RSI_DESC_REQUIRE_CFM_TO_HOST
>> flag and extended descriptor EAPOL4_CONFIRM frame type are not set in 
>> case the
>> AP is iwlwifi, because in that case the TX EAPOL packet is 2 bytes 
>> shorter.
>>
>> The downstream vendor driver has this change in place already [1], 
>> however
>> there is no explanation for it, neither is there any commit history 
>> from which
>> such explanation could be obtained.
>>
> 
> I get this using 2 RSI9116 s, for both AP and STA using hostapd.

Do I understand it correctly that two RSI9116 did not even work against 
one another as STA and AP respectively ? Sigh ...

> Comparing packet captures in the working and non working (without your 
> patch) case shows that
> the working case has a 802.11 QOS header whereas the non working case 
> does not, hence the 2 byte difference.
> The size of the EAPOL data is the same, it's the previous header that 
> causes the problem...
> 
> This whole use the message size to determine the messages to ACK seems 
> very fragile...

I'm not surprised, the quality of this driver is low and the 
documentation is lacking. Thanks for clarifying.

Do you think you can write and submit a patch which would fix this in a 
better way?
