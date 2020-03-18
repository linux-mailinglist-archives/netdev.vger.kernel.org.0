Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CAF18A348
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 20:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCRToc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Mar 2020 15:44:32 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47021 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCRTob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 15:44:31 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id B27DECECFD;
        Wed, 18 Mar 2020 20:53:59 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH 1/1] Bluetooth: Prioritize SCO traffic on slow interfaces
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CANFp7mXtrU8GwWASnfsKkeOyEFNcoCvPb1TJ6vvCtUBZEMKWBg@mail.gmail.com>
Date:   Wed, 18 Mar 2020 20:44:29 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D41D5EDA-AB6A-4900-B8B1-34C5C5C2DC69@holtmann.org>
References: <20200312181055.94038-1-abhishekpandit@chromium.org>
 <20200312111036.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
 <A79B48D3-D342-473C-B94A-A2E0AA83B505@holtmann.org>
 <CANFp7mXwWGZF80EBqEmacc5uQWkaC0pL1rp+x5Qa40kkAcod-Q@mail.gmail.com>
 <FFDE30C9-EE74-436D-8628-9FFC79114D3B@holtmann.org>
 <CANFp7mXtrU8GwWASnfsKkeOyEFNcoCvPb1TJ6vvCtUBZEMKWBg@mail.gmail.com>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

>>>>> When scheduling TX packets, send all SCO/eSCO packets first and then
>>>>> send only 1 ACL/LE packet in a loop while checking that there are no SCO
>>>>> packets pending. This is done to make sure that we can meet SCO
>>>>> deadlines on slow interfaces like UART. If we were to queue up multiple
>>>>> ACL packets without checking for a SCO packet, we might miss the SCO
>>>>> timing. For example:
>>>>> 
>>>>> The time it takes to send a maximum size ACL packet (1024 bytes):
>>>>> t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
>>>>>      where 10/8 is uart overhead due to start/stop bits per byte
>>>>> 
>>>>> Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666
>>>>> and is pretty close to a common baudrate of 3000000 used for BT. At this
>>>>> baudrate, if we sent two 1024 byte ACL packets, we would miss the 3.75ms
>>>>> timing window.
>>>>> 
>>>>> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>>>>> ---
>>>>> 
>>>>> include/net/bluetooth/hci_core.h |  1 +
>>>>> net/bluetooth/hci_core.c         | 91 +++++++++++++++++++++++++-------
>>>>> 2 files changed, 73 insertions(+), 19 deletions(-)
>>>>> 
>>>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>>>>> index d4e28773d378..f636c89f1fe1 100644
>>>>> --- a/include/net/bluetooth/hci_core.h
>>>>> +++ b/include/net/bluetooth/hci_core.h
>>>>> @@ -315,6 +315,7 @@ struct hci_dev {
>>>>>     __u8            ssp_debug_mode;
>>>>>     __u8            hw_error_code;
>>>>>     __u32           clock;
>>>>> +     __u8            sched_limit;
>>>> 
>>>> why do you need this parameter?
>>> 
>>> This is really only necessary on systems where the data transfer rate
>>> to the controller is low. I want the driver to set whether we should
>>> aggressively schedule SCO packets. A quirk might actually be better
>>> than a variable (wasn't sure what is preferable).
>> 
>> or maybe we try without driver choice first. I would assume what is required for UART, will not harm USB or SDIO transports either.
> 
> Ack -- I can make this default behavior.
> 
>> 
>>>>>     __u16           devid_source;
>>>>>     __u16           devid_vendor;
>>>>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>>>>> index dbd2ad3a26ed..00a72265cd96 100644
>>>>> --- a/net/bluetooth/hci_core.c
>>>>> +++ b/net/bluetooth/hci_core.c
>>>>> @@ -4239,18 +4239,32 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
>>>>>     }
>>>>> }
>>>>> 
>>>>> -static void hci_sched_acl_pkt(struct hci_dev *hdev)
>>>>> +/* Limit packets in flight when SCO/eSCO links are active. */
>>>>> +static bool hci_sched_limit(struct hci_dev *hdev)
>>>>> +{
>>>>> +     return hdev->sched_limit && hci_conn_num(hdev, SCO_LINK);
>>>>> +}
>>>>> +
>>>>> +static bool hci_sched_acl_pkt(struct hci_dev *hdev)
>>>>> {
>>>>>     unsigned int cnt = hdev->acl_cnt;
>>>>>     struct hci_chan *chan;
>>>>>     struct sk_buff *skb;
>>>>>     int quote;
>>>>> +     bool sched_limit = hci_sched_limit(hdev);
>>>>> +     bool resched = false;
>>>>> 
>>>>>     __check_timeout(hdev, cnt);
>>>>> 
>>>>>     while (hdev->acl_cnt &&
>>>>>            (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
>>>>>             u32 priority = (skb_peek(&chan->data_q))->priority;
>>>>> +
>>>>> +             if (sched_limit && quote > 0) {
>>>>> +                     resched = true;
>>>>> +                     quote = 1;
>>>>> +             }
>>>>> +
>>>>>             while (quote-- && (skb = skb_peek(&chan->data_q))) {
>>>>>                     BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
>>>>>                            skb->len, skb->priority);
>>>>> @@ -4271,19 +4285,26 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
>>>>>                     chan->sent++;
>>>>>                     chan->conn->sent++;
>>>>>             }
>>>>> +
>>>>> +             if (resched && cnt != hdev->acl_cnt)
>>>>> +                     break;
>>>>>     }
>>>>> 
>>>>> -     if (cnt != hdev->acl_cnt)
>>>>> +     if (hdev->acl_cnt == 0 && cnt != hdev->acl_cnt)
>>>>>             hci_prio_recalculate(hdev, ACL_LINK);
>>>>> +
>>>>> +     return resched;
>>>>> }
>>>>> 
>>>>> -static void hci_sched_acl_blk(struct hci_dev *hdev)
>>>>> +static bool hci_sched_acl_blk(struct hci_dev *hdev)
>>>>> {
>>>>>     unsigned int cnt = hdev->block_cnt;
>>>>>     struct hci_chan *chan;
>>>>>     struct sk_buff *skb;
>>>>>     int quote;
>>>>>     u8 type;
>>>>> +     bool sched_limit = hci_sched_limit(hdev);
>>>>> +     bool resched = false;
>>>>> 
>>>>>     __check_timeout(hdev, cnt);
>>>>> 
>>>>> @@ -4297,6 +4318,12 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
>>>>>     while (hdev->block_cnt > 0 &&
>>>>>            (chan = hci_chan_sent(hdev, type, &quote))) {
>>>>>             u32 priority = (skb_peek(&chan->data_q))->priority;
>>>>> +
>>>>> +             if (sched_limit && quote > 0) {
>>>>> +                     resched = true;
>>>>> +                     quote = 1;
>>>>> +             }
>>>>> +
>>>>>             while (quote > 0 && (skb = skb_peek(&chan->data_q))) {
>>>>>                     int blocks;
>>>>> 
>>>>> @@ -4311,7 +4338,7 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
>>>>> 
>>>>>                     blocks = __get_blocks(hdev, skb);
>>>>>                     if (blocks > hdev->block_cnt)
>>>>> -                             return;
>>>>> +                             return false;
>>>>> 
>>>>>                     hci_conn_enter_active_mode(chan->conn,
>>>>>                                                bt_cb(skb)->force_active);
>>>>> @@ -4325,33 +4352,39 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
>>>>>                     chan->sent += blocks;
>>>>>                     chan->conn->sent += blocks;
>>>>>             }
>>>>> +
>>>>> +             if (resched && cnt != hdev->block_cnt)
>>>>> +                     break;
>>>>>     }
>>>>> 
>>>>> -     if (cnt != hdev->block_cnt)
>>>>> +     if (hdev->block_cnt == 0 && cnt != hdev->block_cnt)
>>>>>             hci_prio_recalculate(hdev, type);
>>>>> +
>>>>> +     return resched;
>>>>> }
>>>>> 
>>>>> -static void hci_sched_acl(struct hci_dev *hdev)
>>>>> +static bool hci_sched_acl(struct hci_dev *hdev)
>>>>> {
>>>>>     BT_DBG("%s", hdev->name);
>>>>> 
>>>>>     /* No ACL link over BR/EDR controller */
>>>>>     if (!hci_conn_num(hdev, ACL_LINK) && hdev->dev_type == HCI_PRIMARY)
>>>>> -             return;
>>>>> +             goto done;
>>>> 
>>>> Style wise the goto done is overkill. Just return false.
>>> 
>>> Will do.
>>> 
>>>> 
>>>>> 
>>>>>     /* No AMP link over AMP controller */
>>>>>     if (!hci_conn_num(hdev, AMP_LINK) && hdev->dev_type == HCI_AMP)
>>>>> -             return;
>>>>> +             goto done;
>>>>> 
>>>>>     switch (hdev->flow_ctl_mode) {
>>>>>     case HCI_FLOW_CTL_MODE_PACKET_BASED:
>>>>> -             hci_sched_acl_pkt(hdev);
>>>>> -             break;
>>>>> +             return hci_sched_acl_pkt(hdev);
>>>>> 
>>>>>     case HCI_FLOW_CTL_MODE_BLOCK_BASED:
>>>>> -             hci_sched_acl_blk(hdev);
>>>>> -             break;
>>>>> +             return hci_sched_acl_blk(hdev);
>>>> 
>>>> So the block based mode is for AMP controllers and not used on BR/EDR controllers. Since AMP controllers only transport ACL packet and no SCO/eSCO packets, we can ignore this here.
>>> 
>>> Ok, I'll remove it there.
>>> 
>>>> 
>>>>>     }
>>>>> +
>>>>> +done:
>>>>> +     return false;
>>>>> }
>>>>> 
>>>>> /* Schedule SCO */
>>>>> @@ -4402,16 +4435,18 @@ static void hci_sched_esco(struct hci_dev *hdev)
>>>>>     }
>>>>> }
>>>>> 
>>>>> -static void hci_sched_le(struct hci_dev *hdev)
>>>>> +static bool hci_sched_le(struct hci_dev *hdev)
>>>>> {
>>>>>     struct hci_chan *chan;
>>>>>     struct sk_buff *skb;
>>>>>     int quote, cnt, tmp;
>>>>> +     bool sched_limit = hci_sched_limit(hdev);
>>>>> +     bool resched = false;
>>>>> 
>>>>>     BT_DBG("%s", hdev->name);
>>>>> 
>>>>>     if (!hci_conn_num(hdev, LE_LINK))
>>>>> -             return;
>>>>> +             return resched;
>>>>> 
>>>>>     cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
>>>>> 
>>>>> @@ -4420,6 +4455,12 @@ static void hci_sched_le(struct hci_dev *hdev)
>>>>>     tmp = cnt;
>>>>>     while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
>>>>>             u32 priority = (skb_peek(&chan->data_q))->priority;
>>>>> +
>>>>> +             if (sched_limit && quote > 0) {
>>>>> +                     resched = true;
>>>>> +                     quote = 1;
>>>>> +             }
>>>>> +
>>>>>             while (quote-- && (skb = skb_peek(&chan->data_q))) {
>>>>>                     BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
>>>>>                            skb->len, skb->priority);
>>>>> @@ -4437,6 +4478,9 @@ static void hci_sched_le(struct hci_dev *hdev)
>>>>>                     chan->sent++;
>>>>>                     chan->conn->sent++;
>>>>>             }
>>>>> +
>>>>> +             if (resched && cnt != tmp)
>>>>> +                     break;
>>>>>     }
>>>>> 
>>>>>     if (hdev->le_pkts)
>>>>> @@ -4444,24 +4488,33 @@ static void hci_sched_le(struct hci_dev *hdev)
>>>>>     else
>>>>>             hdev->acl_cnt = cnt;
>>>>> 
>>>>> -     if (cnt != tmp)
>>>>> +     if (cnt == 0 && cnt != tmp)
>>>>>             hci_prio_recalculate(hdev, LE_LINK);
>>>>> +
>>>>> +     return resched;
>>>>> }
>>>>> 
>>>>> static void hci_tx_work(struct work_struct *work)
>>>>> {
>>>>>     struct hci_dev *hdev = container_of(work, struct hci_dev, tx_work);
>>>>>     struct sk_buff *skb;
>>>>> +     bool resched;
>>>>> 
>>>>>     BT_DBG("%s acl %d sco %d le %d", hdev->name, hdev->acl_cnt,
>>>>>            hdev->sco_cnt, hdev->le_cnt);
>>>>> 
>>>>>     if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
>>>>>             /* Schedule queues and send stuff to HCI driver */
>>>>> -             hci_sched_acl(hdev);
>>>>> -             hci_sched_sco(hdev);
>>>>> -             hci_sched_esco(hdev);
>>>>> -             hci_sched_le(hdev);
>>>>> +             do {
>>>>> +                     /* SCO and eSCO send all packets until emptied */
>>>>> +                     hci_sched_sco(hdev);
>>>>> +                     hci_sched_esco(hdev);
>>>>> +
>>>>> +                     /* Acl and Le send based on quota (priority on ACL per
>>>>> +                      * loop)
>>>>> +                      */
>>>>> +                     resched = hci_sched_acl(hdev) || hci_sched_le(hdev);
>>>>> +             } while (resched);
>>>>>     }
>>>> 
>>>> I am not in favor of this busy loop. We might want to re-think the whole scheduling by connection type and really only focus on scheduling ACL (BR/EDR and LE) and audio packets (SCO/eSCO and ISO).
>>> 
>>> I think the busy loop is the simplest solution if we want to solve the
>>> problem: don't send 2 ACL packets without checking if there is a SCO
>>> packet scheduled (which is the worst case I'm worried about on UART
>>> interfaces).
>>> 
>>> If we get rid of the connection type scheduling and only do audio and
>>> ACL, we would still need some mechanism to guarantee that you don't
>>> send >~1100 bytes without checking if SCO is queued (assuming 3000000
>>> baudrate and 3.75ms latency requirement).
>> 
>> Why don’t we just say that if SCO is queued up, then after each ACL packet we should send a SCO packet.
> 
> That sounds good. Effectively, this is what I wanted to achieve
> without modifying the ACL round robin mechanism too much.

Lets try this first and see how it goes. We might need to do some modifications, but it is worth a try.

>>>> In addition, we also need to check that SCO scheduling and A2DP media channel ACL packets do work together. I think that generally it would be best to have a clear rate at which SCO packets are require to pushed down to the hardware. So you really reserve bandwidth and not blindly prioritize them via a busy loop.
>>>> 
>>> I am less worried about bandwidth and more about latency. If I start
>>> sending really large ACL packets through UART, it could take multiple
>>> milliseconds. It really has to be reserved bandwidth per small
>>> timeslice (like 3.75ms) so I can guarantee that if a SCO packet is
>>> seen within that time slice, it will be transferred. There will still
>>> have to be a busy loop though because the amount of data you can send
>>> in the time slice will probably be less than the data that can be
>>> in-flight to the controller (i.e. acl_max_pkts).
>> 
>> Right now we kinda let the SCO socket application provide the correct timing. I was thinking that the kernel might need to enforce this.
> 
> I was under the assumption that the Num Completed Pkts event would
> actually help us regulate the timing (assuming controller sends that
> event once it actually sends SCO packet over the air). Currently, we
> don't seem to be using it for SCO.

That is a good question and I don’t have an answer on the top of my head. We would have to check the spec text and see if controllers really follow it.

> For the next patch revision, I will remove the driver specific enable,
> gotos and scheduling of acl block. I'll also add a limit to SCO
> packets sent so it observes and respects the number of sco packets
> completed (same as ACL).
> 
> I'm not yet comfortable refactoring the scheduling from per connection
> to per type, especially as I'm not sure what to do with ISO or ACL
> audio. I think those will require a bit more thought.

From a packet perspective, we have ACL and SCO/eSCO packets and ISO will be another type. That is just how it is defined  in the spec. However we are putting everything into data_q and I wonder if we should just add priority handling to the SCO/eSCO scheduling. We have done this for ACL so that high priority L2CAP connections come first. We would just need a way to say SCO/eSCO comes first.

Regards

Marcel

