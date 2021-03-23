Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC4B3455DE
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 04:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCWDBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 23:01:42 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:46352 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhCWDBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 23:01:32 -0400
Received: from [192.168.254.6] (unknown [50.34.172.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1A1BB13C2B4;
        Mon, 22 Mar 2021 20:01:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1A1BB13C2B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1616468487;
        bh=rQIz9Srsbox3KK9ITKyPEVOOf772HvkSawM6/pJCdiI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PgLrrxDwb6/rrdkZpHooO/DJHyiKBUD10HUxwKQW+Zfr6JxuUtbr1EEmZscxShfD2
         vTzeKS0R6Bbu4keJr0Sv/b1l80xRuO1ulLXGvlUw5VKB9nRZpugvys2jenD7RkKsbf
         TnZeoQXOAIkiSdFdarsp02lGDrE3KL4KenmiBaYY=
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
To:     Brian Norris <briannorris@chromium.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Evan Green <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
 <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
 <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
 <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
 <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com>
 <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <47d8be60-14ce-0223-bdf3-c34dc2451945@candelatech.com>
Date:   Mon, 22 Mar 2021 20:01:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 6:20 PM, Brian Norris wrote:
> On Mon, Mar 22, 2021 at 4:58 PM Ben Greear <greearb@candelatech.com> wrote:
>> On 7/22/20 6:00 AM, Felix Fietkau wrote:
>>> On 2020-07-22 14:55, Johannes Berg wrote:
>>>> On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:
>>>>
>>>>> I'm considering testing a different approach (with mt76 initially):
>>>>> - Add a mac80211 rx function that puts processed skbs into a list
>>>>> instead of handing them to the network stack directly.
>>>>
>>>> Would this be *after* all the mac80211 processing, i.e. in place of the
>>>> rx-up-to-stack?
>>> Yes, it would run all the rx handlers normally and then put the
>>> resulting skbs into a list instead of calling netif_receive_skb or
>>> napi_gro_frags.
>>
>> Whatever came of this?  I realized I'm running Felix's patch since his mt76
>> driver needs it.  Any chance it will go upstream?
> 
> If you're asking about $subject (moving NAPI/RX to a thread), this
> landed upstream recently:
> http://git.kernel.org/linus/adbb4fb028452b1b0488a1a7b66ab856cdf20715
> 
> It needs a bit of coaxing to work on a WiFi driver (including: WiFi
> drivers tend to have a different netdev for NAPI than they expose to
> /sys/class/net/), but it's there.
> 
> I'm not sure if people had something else in mind in the stuff you're
> quoting though.

No, I got it confused with something Felix did:

https://github.com/greearb/mt76/blob/master/patches/0001-net-add-support-for-threaded-NAPI-polling.patch

Maybe the NAPI/RX to a thread thing superceded Felix's patch?

Thanks,
Ben

> 
> Brian
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
