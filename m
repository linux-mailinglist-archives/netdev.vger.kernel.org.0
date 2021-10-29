Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9FA43FA87
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhJ2KNu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Oct 2021 06:13:50 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:39360 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhJ2KNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:13:49 -0400
Received: from smtpclient.apple (p4ff9fd51.dip0.t-ipconnect.de [79.249.253.81])
        by mail.holtmann.org (Postfix) with ESMTPSA id D38D7CED12;
        Fri, 29 Oct 2021 12:11:19 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] Bluetooth: Limit duration of Remote Name Resolve
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAJQfnxHn51XRywv68xcL4u=qERyi2S0boLBOGBnBbUfu9pQWGQ@mail.gmail.com>
Date:   Fri, 29 Oct 2021 12:11:19 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BEAEDCF9-75D7-4D34-B272-AD044533B311@holtmann.org>
References: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
 <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org>
 <CABBYNZKpcXGD6=RrVRGiAtHM+cfKEOL=-_tER1ow_VPrm6fFhQ@mail.gmail.com>
 <CAJQfnxH=hN7ZzqNzyKqzb=wSCNktUiSnMeh77fghsudvzJyVvg@mail.gmail.com>
 <E68EB205-8B05-4A44-933A-06C5955F561A@holtmann.org>
 <CAJQfnxHn51XRywv68xcL4u=qERyi2S0boLBOGBnBbUfu9pQWGQ@mail.gmail.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

>>>>>> When doing remote name request, we cannot scan. In the normal case it's
>>>>>> OK since we can expect it to finish within a short amount of time.
>>>>>> However, there is a possibility to scan lots of devices that
>>>>>> (1) requires Remote Name Resolve
>>>>>> (2) is unresponsive to Remote Name Resolve
>>>>>> When this happens, we are stuck to do Remote Name Resolve until all is
>>>>>> done before continue scanning.
>>>>>> 
>>>>>> This patch adds a time limit to stop us spending too long on remote
>>>>>> name request. The limit is increased for every iteration where we fail
>>>>>> to complete the RNR in order to eventually solve all names.
>>>>>> 
>>>>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>>>>>> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
>>>>>> 
>>>>>> ---
>>>>>> Hi maintainers, we found one instance where a test device spends ~90
>>>>>> seconds to do Remote Name Resolving, hence this patch.
>>>>>> I think it's better if we reset the time limit to the default value
>>>>>> at some point, but I don't have a good proposal where to do that, so
>>>>>> in the end I didn't.
>>>>> 
>>>>> do you have a btmon trace for this as well?
>>>>> 
>>> Yes, but only from the scanning device side. It's all lined up with
>>> your expectation (e.g. receiving Page Timeout in RNR Complete event).
>>> 
>>>>> The HCI Remote Name Request is essentially a paging procedure and then a few LMP messages. It is fundamentally a connection request inside BR/EDR and if you have a remote device that has page scan disabled, but inquiry scan enabled, then you get into this funky situation. Sadly, the BR/EDR parts don’t give you any hint on this weird combination. You can't configure BlueZ that way since it is really stupid setup and I remember that GAP doesn’t have this case either, but it can happen. So we might want to check if that is what happens. And of course it needs to be a Bluetooth 2.0 device or a device that doesn’t support Secure Simple Pairing. There is a chance of really bad radio interference, but that is then just bad luck and is only going to happen every once in a blue moon.
>>>> 
>>> It might be the case. I don't know the peer device, but it looks like
>>> the user has a lot of these exact peer devices sitting in the same
>>> room.
>>> Or another possibility would be the user just turned bluetooth off for
>>> these devices just after we scan them, such that they don't answer the
>>> RNR.
>>> 
>>>> I wonder what does the remote sets as Page_Scan_Repetition_Mode in the
>>>> Inquiry Result, it seems quite weird that the specs allows such stage
>>>> but it doesn't have a value to represent in the inquiry result, anyway
>>>> I guess changing that now wouldn't really make any different given
>>>> such device is probably never gonna update.
>>>> 
>>> The page scan repetition mode is R1
>> 
>> not sure if this actually matters if your clock drifted too much apart.
>> 
>>>>> That said, you should receive a Page Timeout in the Remote Name Request Complete event for what you describe. Or you just use HCI Remote Name Request Cancel to abort the paging. If I remember correctly then the setting for Page Timeout is also applied to Remote Name resolving procedure. So we could tweak that value. Actually once we get the “sync” work merged, we could configure different Page Timeout for connection requests and name resolving if that would help. Not sure if this is worth it, since we could as simple just cancel the request.
>>>> 
>>>> If I recall this correctly we used to have something like that back in
>>>> the days the daemon had control over the discovery, the logic was that
>>>> each round of discovery including the name resolving had a fixed time
>>>> e.g. 10 sec, so if not all device found had their name resolved we
>>>> would stop and proceed to the next round that way we avoid this
>>>> problem of devices not resolving and nothing being discovered either.
>>>> Luckily today there might not be many devices around without EIR
>>>> including their names but still I think it would be better to limit
>>>> the amount time we spend resolving names, also it looks like it sets
>>>> NAME_NOT_KNOWN when RNR fails and it never proceeds to request the
>>>> name again so I wonder why would it be waiting ~90 seconds, we don't
>>>> seem to change the page timeout so it should be using the default
>>>> which is 5.12s so I think there is something else at play.
>>>> 
>>> Yeah, we received the Page Timeout after 5s, but then we proceed to
>>> continue RNR the next device, which takes another 5s, and so on.
>>> A couple of these devices can push waiting time over 90s.
>>> Looking at this, I don't think cancelling RNR would help much.
>>> This patch would like to reintroduce the time limit, but I decided to
>>> make the time limit grow, otherwise the bad RNR might take the whole
>>> time limit and we can't resolve any names.
>> 
>> I am wondering if we should add a new flag to Device Found that will indicate Name Resolving Failed after the first Page Timeout and then bluetoothd can decide via Confirm Name mgmt command to trigger the resolving or not. We can even add a 0x02 for Don’t Care About The Name.
>> 
> This is a great idea.
> However I checked that we remove the discovered device cache after
> every scan iteration.
> While I am not clear about the purpose of the cache cleanup, I had
> assumed that keeping a list of devices with bad RNR record would go
> against the intention of cleaning up the cache.
> 
> If we are to bookkeep the list of bad devices, we might as well take
> this record into account when sorting the RNR queue, so the bad
> devices will be sent to the back of the queue regardless how good the
> RSSI is.

the inquiry cache is solely for name resolving and connection request so that you are able to fill in the right values to speed up the paging.

I think it is just enough to include a flag hinting the resolving failure into the Device Found message. We are sending two Device Found anyway on success. So now we get one on failure as well. And then lets bluetoothd do all the caching if it wants to.

Regards

Marcel

