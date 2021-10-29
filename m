Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D243F8AE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 10:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhJ2IVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Oct 2021 04:21:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45037 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhJ2IVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 04:21:30 -0400
Received: from smtpclient.apple (p4ff9fd51.dip0.t-ipconnect.de [79.249.253.81])
        by mail.holtmann.org (Postfix) with ESMTPSA id 503B3CED10;
        Fri, 29 Oct 2021 10:18:58 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] Bluetooth: Limit duration of Remote Name Resolve
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAJQfnxH=hN7ZzqNzyKqzb=wSCNktUiSnMeh77fghsudvzJyVvg@mail.gmail.com>
Date:   Fri, 29 Oct 2021 10:18:57 +0200
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
Message-Id: <E68EB205-8B05-4A44-933A-06C5955F561A@holtmann.org>
References: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
 <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org>
 <CABBYNZKpcXGD6=RrVRGiAtHM+cfKEOL=-_tER1ow_VPrm6fFhQ@mail.gmail.com>
 <CAJQfnxH=hN7ZzqNzyKqzb=wSCNktUiSnMeh77fghsudvzJyVvg@mail.gmail.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

>>>> When doing remote name request, we cannot scan. In the normal case it's
>>>> OK since we can expect it to finish within a short amount of time.
>>>> However, there is a possibility to scan lots of devices that
>>>> (1) requires Remote Name Resolve
>>>> (2) is unresponsive to Remote Name Resolve
>>>> When this happens, we are stuck to do Remote Name Resolve until all is
>>>> done before continue scanning.
>>>> 
>>>> This patch adds a time limit to stop us spending too long on remote
>>>> name request. The limit is increased for every iteration where we fail
>>>> to complete the RNR in order to eventually solve all names.
>>>> 
>>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>>>> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
>>>> 
>>>> ---
>>>> Hi maintainers, we found one instance where a test device spends ~90
>>>> seconds to do Remote Name Resolving, hence this patch.
>>>> I think it's better if we reset the time limit to the default value
>>>> at some point, but I don't have a good proposal where to do that, so
>>>> in the end I didn't.
>>> 
>>> do you have a btmon trace for this as well?
>>> 
> Yes, but only from the scanning device side. It's all lined up with
> your expectation (e.g. receiving Page Timeout in RNR Complete event).
> 
>>> The HCI Remote Name Request is essentially a paging procedure and then a few LMP messages. It is fundamentally a connection request inside BR/EDR and if you have a remote device that has page scan disabled, but inquiry scan enabled, then you get into this funky situation. Sadly, the BR/EDR parts don’t give you any hint on this weird combination. You can't configure BlueZ that way since it is really stupid setup and I remember that GAP doesn’t have this case either, but it can happen. So we might want to check if that is what happens. And of course it needs to be a Bluetooth 2.0 device or a device that doesn’t support Secure Simple Pairing. There is a chance of really bad radio interference, but that is then just bad luck and is only going to happen every once in a blue moon.
>> 
> It might be the case. I don't know the peer device, but it looks like
> the user has a lot of these exact peer devices sitting in the same
> room.
> Or another possibility would be the user just turned bluetooth off for
> these devices just after we scan them, such that they don't answer the
> RNR.
> 
>> I wonder what does the remote sets as Page_Scan_Repetition_Mode in the
>> Inquiry Result, it seems quite weird that the specs allows such stage
>> but it doesn't have a value to represent in the inquiry result, anyway
>> I guess changing that now wouldn't really make any different given
>> such device is probably never gonna update.
>> 
> The page scan repetition mode is R1

not sure if this actually matters if your clock drifted too much apart.

>>> That said, you should receive a Page Timeout in the Remote Name Request Complete event for what you describe. Or you just use HCI Remote Name Request Cancel to abort the paging. If I remember correctly then the setting for Page Timeout is also applied to Remote Name resolving procedure. So we could tweak that value. Actually once we get the “sync” work merged, we could configure different Page Timeout for connection requests and name resolving if that would help. Not sure if this is worth it, since we could as simple just cancel the request.
>> 
>> If I recall this correctly we used to have something like that back in
>> the days the daemon had control over the discovery, the logic was that
>> each round of discovery including the name resolving had a fixed time
>> e.g. 10 sec, so if not all device found had their name resolved we
>> would stop and proceed to the next round that way we avoid this
>> problem of devices not resolving and nothing being discovered either.
>> Luckily today there might not be many devices around without EIR
>> including their names but still I think it would be better to limit
>> the amount time we spend resolving names, also it looks like it sets
>> NAME_NOT_KNOWN when RNR fails and it never proceeds to request the
>> name again so I wonder why would it be waiting ~90 seconds, we don't
>> seem to change the page timeout so it should be using the default
>> which is 5.12s so I think there is something else at play.
>> 
> Yeah, we received the Page Timeout after 5s, but then we proceed to
> continue RNR the next device, which takes another 5s, and so on.
> A couple of these devices can push waiting time over 90s.
> Looking at this, I don't think cancelling RNR would help much.
> This patch would like to reintroduce the time limit, but I decided to
> make the time limit grow, otherwise the bad RNR might take the whole
> time limit and we can't resolve any names.

I am wondering if we should add a new flag to Device Found that will indicate Name Resolving Failed after the first Page Timeout and then bluetoothd can decide via Confirm Name mgmt command to trigger the resolving or not. We can even add a 0x02 for Don’t Care About The Name.

The one thing that I have a bit of a problem with is what time value we are going to pick for the resolving stage. Lets say we actually limit the time we spent there, then sure lets do that and pick a time. I wouldn’t be bothering with increasing it based on faulty devices. Just pick a time and that is what the kernel is allowed to spent on this. And it will abort. So we should be using a timer for this. That is just the fair thing to do and then you get an expected behavior every time. If we do the above extensions of mgmt, then bluetoothd can put a device back into the list if it really feels the kernel should keep trying to resolve the name.

>> Or perhaps it is finally time to drop legacy name resolution? At this
>> point they should be very rare and those keeping some ancient device
>> around will just have to deal with the address directly so we can get
>> rid of paging devices while discovery which is quite a big burden I'd
>> say.

I rather not do that. There are still 2.0 device out there.

>>>> include/net/bluetooth/hci_core.h |  5 +++++
>>>> net/bluetooth/hci_event.c        | 12 ++++++++++++
>>>> 2 files changed, 17 insertions(+)
>>>> 
>>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>>>> index dd8840e70e25..df9ffedf1d29 100644
>>>> --- a/include/net/bluetooth/hci_core.h
>>>> +++ b/include/net/bluetooth/hci_core.h
>>>> @@ -87,6 +87,8 @@ struct discovery_state {
>>>>      u8                      (*uuids)[16];
>>>>      unsigned long           scan_start;
>>>>      unsigned long           scan_duration;
>>>> +     unsigned long           name_resolve_timeout;
>>>> +     unsigned long           name_resolve_duration;
>>>> };
>>>> 
>>>> #define SUSPEND_NOTIFIER_TIMEOUT      msecs_to_jiffies(2000) /* 2 seconds */
>>>> @@ -805,6 +807,8 @@ static inline void sco_recv_scodata(struct hci_conn *hcon, struct sk_buff *skb)
>>>> #define INQUIRY_CACHE_AGE_MAX   (HZ*30)   /* 30 seconds */
>>>> #define INQUIRY_ENTRY_AGE_MAX   (HZ*60)   /* 60 seconds */
>>>> 
>>>> +#define NAME_RESOLVE_INIT_DURATION   5120    /* msec */
>>>> +
>>>> static inline void discovery_init(struct hci_dev *hdev)
>>>> {
>>>>      hdev->discovery.state = DISCOVERY_STOPPED;
>>>> @@ -813,6 +817,7 @@ static inline void discovery_init(struct hci_dev *hdev)
>>>>      INIT_LIST_HEAD(&hdev->discovery.resolve);
>>>>      hdev->discovery.report_invalid_rssi = true;
>>>>      hdev->discovery.rssi = HCI_RSSI_INVALID;
>>>> +     hdev->discovery.name_resolve_duration = NAME_RESOLVE_INIT_DURATION;
>>>> }
>>>> 
>>>> static inline void hci_discovery_filter_clear(struct hci_dev *hdev)
>>>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>>>> index 3cba2bbefcd6..104a1308f454 100644
>>>> --- a/net/bluetooth/hci_event.c
>>>> +++ b/net/bluetooth/hci_event.c
>>>> @@ -2086,6 +2086,15 @@ static bool hci_resolve_next_name(struct hci_dev *hdev)
>>>>      if (list_empty(&discov->resolve))
>>>>              return false;
>>>> 
>>>> +     /* We should stop if we already spent too much time resolving names.
>>>> +      * However, double the name resolve duration for the next iterations.
>>>> +      */
>>>> +     if (time_after(jiffies, discov->name_resolve_timeout)) {
>>>> +             bt_dev_dbg(hdev, "Name resolve takes too long, stopping.");
>>>> +             discov->name_resolve_duration *= 2;
>>>> +             return false;
>>>> +     }
>>>> +
>>>>      e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEEDED);
>>>>      if (!e)
>>>>              return false;
>>>> @@ -2634,6 +2643,9 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
>>>>      if (e && hci_resolve_name(hdev, e) == 0) {
>>>>              e->name_state = NAME_PENDING;
>>>>              hci_discovery_set_state(hdev, DISCOVERY_RESOLVING);
>>>> +
>>>> +             discov->name_resolve_timeout = jiffies +
>>>> +                             msecs_to_jiffies(discov->name_resolve_duration);
>>> 
>>> So if this is really caused by a device with page scan disabled and inquiry scan enabled, then this fix is just a paper over hole approach. If you have more devices requiring name resolving, you end up penalizing them and make the discovery procedure worse up to the extend that no names are resolved. So I wouldn’t be in favor of this.
>>> 
> I agree this could potentially penalize good devices that require name
> resolving. However, this wouldn't worsen the procedure to the extent
> where no names are resolved, since the time limit is growing, so at
> some point all names (from good devices) are bound to be resolved.
> Also, I expect the user would bring the target peer devices closer,
> therefore hopefully increasing the RSSI and making them appear sooner
> in the next iteration of RNR, since we order the requests by RSSI.
> So, this change might also reward good devices by giving them a chance
> to 'cut the RNR queue'.
> 
>>> What LE scan window/interval is actually working against what configured BR/EDR page timeout here? The discovery procedure is something that a user triggers so we always had that one take higher priority since the user is expecting results. This means any tweaking needs to be considered carefully since it is an immediate user impact if the name is missing.
>>> 
>>> Is this a LE background scan you are worried about or an LE active scan that runs in parallel during discovery?
>>> 
> This doesn't need to be related to LE. I believe what the user experienced is:
> (1) The user activates scanning on the host device
> (2) The host device scans lots of bad peers. After 10 seconds, the
> host device stop scanning and begin RNR.
> (3) The user put the target peer device into discoverable mode
> (4) The host device spends 90 seconds doing RNR, before eventually
> successfully discovering the target peer device.
> 
> Of course, step (3) could be performed earlier but by luck the host
> fails to discover the target peer in 10 seconds.

I agree that the 90 seconds is just insane. Keep in mind that this code is roughly running in devices since 2015. So it couldn’t have been all that bad. Nevertheless, you encountered a case where this needs improvement.

Regards

Marcel

