Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C0620EED9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgF3Gy4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jun 2020 02:54:56 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36390 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbgF3Gy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:54:56 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id F0BB3CECE2;
        Tue, 30 Jun 2020 09:04:48 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH v1 1/2] Bluetooth: queue ACL packets if no handle is
 found
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAJQfnxFSfbUbPLVC-be41TqNXzr_6hLq2z=u521HL+BqxLHn_Q@mail.gmail.com>
Date:   Tue, 30 Jun 2020 08:54:54 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7BBB55E0-FBD9-40C0-80D9-D5E7FC9F80D2@holtmann.org>
References: <20200627105437.453053-1-apusaka@google.com>
 <20200627185320.RFC.v1.1.Icea550bb064a24b89f2217cf19e35b4480a31afd@changeid>
 <91CFE951-262A-4E83-8550-25445AE84B5A@holtmann.org>
 <CAJQfnxFSfbUbPLVC-be41TqNXzr_6hLq2z=u521HL+BqxLHn_Q@mail.gmail.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

>>> There is a possibility that an ACL packet is received before we
>>> receive the HCI connect event for the corresponding handle. If this
>>> happens, we discard the ACL packet.
>>> 
>>> Rather than just ignoring them, this patch provides a queue for
>>> incoming ACL packet without a handle. The queue is processed when
>>> receiving a HCI connection event. If 2 seconds elapsed without
>>> receiving the HCI connection event, assume something bad happened
>>> and discard the queued packet.
>>> 
>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>>> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> 
>> so two things up front. I want to hide this behind a HCI_QUIRK_OUT_OF_ORDER_ACL that a transport driver has to set first. Frankly if this kind of out-of-order happens on UART or SDIO transports, then something is obviously going wrong. I have no plan to fix up after a fully serialized transport.
>> 
>> Secondly, if a transport sets HCI_QUIRK_OUT_OF_ORDER_ACL, then I want this off by default. You can enable it via an experimental setting. The reason here is that we have to make it really hard and fail as often as possible so that hardware manufactures and spec writers realize that something is fundamentally broken here.
>> 
>> I have no problem in running the code and complaining loudly in case the quirk has been set. Just injecting the packets can only happen if bluetoothd explicitly enabled it.
> 
> Got it.
> 
>> 
>> 
>>> 
>>> ---
>>> 
>>> include/net/bluetooth/hci_core.h |  8 +++
>>> net/bluetooth/hci_core.c         | 84 +++++++++++++++++++++++++++++---
>>> net/bluetooth/hci_event.c        |  2 +
>>> 3 files changed, 88 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>>> index 836dc997ff94..b69ecdd0d15a 100644
>>> --- a/include/net/bluetooth/hci_core.h
>>> +++ b/include/net/bluetooth/hci_core.h
>>> @@ -270,6 +270,9 @@ struct adv_monitor {
>>> /* Default authenticated payload timeout 30s */
>>> #define DEFAULT_AUTH_PAYLOAD_TIMEOUT   0x0bb8
>>> 
>>> +/* Time to keep ACL packets without a corresponding handle queued (2s) */
>>> +#define PENDING_ACL_TIMEOUT          msecs_to_jiffies(2000)
>>> +
>> 
>> Do we have some btmon traces with timestamps. Isn’t a second enough? Actually 2 seconds is an awful long time.
> 
> When this happens in the test lab, the HCI connect event is about
> 0.002 second behind the first ACL packet. We can change this if
> required.
> 
>> 
>>> struct amp_assoc {
>>>      __u16   len;
>>>      __u16   offset;
>>> @@ -538,6 +541,9 @@ struct hci_dev {
>>>      struct delayed_work     rpa_expired;
>>>      bdaddr_t                rpa;
>>> 
>>> +     struct delayed_work     remove_pending_acl;
>>> +     struct sk_buff_head     pending_acl_q;
>>> +
>> 
>> can we name this ooo_q and move it to the other queues in this struct. Unless we want to add a Kconfig option around it, we don’t need to keep it here.
> 
> Ack.
> 
>> 
>>> #if IS_ENABLED(CONFIG_BT_LEDS)
>>>      struct led_trigger      *power_led;
>>> #endif
>>> @@ -1773,6 +1779,8 @@ void hci_le_start_enc(struct hci_conn *conn, __le16 ediv, __le64 rand,
>>> void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
>>>                             u8 *bdaddr_type);
>>> 
>>> +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *conn);
>>> +
>>> #define SCO_AIRMODE_MASK       0x0003
>>> #define SCO_AIRMODE_CVSD       0x0000
>>> #define SCO_AIRMODE_TRANSP     0x0003
>>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>>> index 7959b851cc63..30780242c267 100644
>>> --- a/net/bluetooth/hci_core.c
>>> +++ b/net/bluetooth/hci_core.c
>>> @@ -1786,6 +1786,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
>>>      skb_queue_purge(&hdev->rx_q);
>>>      skb_queue_purge(&hdev->cmd_q);
>>>      skb_queue_purge(&hdev->raw_q);
>>> +     skb_queue_purge(&hdev->pending_acl_q);
>>> 
>>>      /* Drop last sent command */
>>>      if (hdev->sent_cmd) {
>>> @@ -3518,6 +3519,78 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
>>>      return NOTIFY_STOP;
>>> }
>>> 
>>> +static void hci_add_pending_acl(struct hci_dev *hdev, struct sk_buff *skb)
>>> +{
>>> +     skb_queue_tail(&hdev->pending_acl_q, skb);
>>> +
>>> +     queue_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
>>> +                        PENDING_ACL_TIMEOUT);
>>> +}
>>> +
>>> +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *conn)
>>> +{
>>> +     struct sk_buff *skb, *tmp;
>>> +     struct hci_acl_hdr *hdr;
>>> +     u16 handle, flags;
>>> +     bool reset_timer = false;
>>> +
>>> +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
>>> +             hdr = (struct hci_acl_hdr *)skb->data;
>>> +             handle = __le16_to_cpu(hdr->handle);
>>> +             flags  = hci_flags(handle);
>>> +             handle = hci_handle(handle);
>>> +
>>> +             if (handle != conn->handle)
>>> +                     continue;
>>> +
>>> +             __skb_unlink(skb, &hdev->pending_acl_q);
>>> +             skb_pull(skb, HCI_ACL_HDR_SIZE);
>>> +
>>> +             l2cap_recv_acldata(conn, skb, flags);
>>> +             reset_timer = true;
>>> +     }
>>> +
>>> +     if (reset_timer)
>>> +             mod_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
>>> +                              PENDING_ACL_TIMEOUT);
>>> +}
>>> +
>>> +/* Remove the oldest pending ACL, and all pending ACLs with the same handle */
>>> +static void hci_remove_pending_acl(struct work_struct *work)
>>> +{
>>> +     struct hci_dev *hdev;
>>> +     struct sk_buff *skb, *tmp;
>>> +     struct hci_acl_hdr *hdr;
>>> +     u16 handle, oldest_handle;
>>> +
>>> +     hdev = container_of(work, struct hci_dev, remove_pending_acl.work);
>>> +     skb = skb_dequeue(&hdev->pending_acl_q);
>>> +
>>> +     if (!skb)
>>> +             return;
>>> +
>>> +     hdr = (struct hci_acl_hdr *)skb->data;
>>> +     oldest_handle = hci_handle(__le16_to_cpu(hdr->handle));
>>> +     kfree_skb(skb);
>>> +
>>> +     bt_dev_err(hdev, "ACL packet for unknown connection handle %d",
>>> +                oldest_handle);
>>> +
>>> +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
>>> +             hdr = (struct hci_acl_hdr *)skb->data;
>>> +             handle = hci_handle(__le16_to_cpu(hdr->handle));
>>> +
>>> +             if (handle == oldest_handle) {
>>> +                     __skb_unlink(skb, &hdev->pending_acl_q);
>>> +                     kfree_skb(skb);
>>> +             }
>>> +     }
>>> +
>>> +     if (!skb_queue_empty(&hdev->pending_acl_q))
>>> +             queue_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
>>> +                                PENDING_ACL_TIMEOUT);
>>> +}
>>> +
>> 
>> So I am wondering if we make this too complicated. Since generally speaking we can only have a single HCI connect complete anyway at a time. No matter if the controller serializes it for us or we do it for the controller. So hci_conn_add could just process the queue for packets with its handle and then flush it. And it can flush it no matter what since whatever other packets are in the queue, they can not be valid.
>> 
>> That said, we wouldn’t even need to check the packet handles at all. We just needed to flag them as already out-of-order queued once and hand them back into the rx_q at the top. Then the would be processed as usual. Already ooo packets would cause the same error as before if it is for a non-existing handle and others would end up being processed.
>> 
>> For me this means we just need another queue to park the packets until hci_conn_add gets called. I might have missed something, but I am looking for the least invasive option for this and least code duplication.
> 
> I'm not aware of the fact that we can only have a single HCI connect
> complete event at any time. Is this also true even if two / more
> peripherals connect at the same time?
> I was under the impression that if we have device A and B both are
> connecting to us at the same time, we might receive the packets in
> this order:
> (1) ACL A
> (2) ACL B
> (3) HCI conn evt B
> (4) HCI conn evt A
> Hence the queue and the handle check.

my reading from the LL state machine is that once the first LL_Connect_Req is processes, the controller moves out of the advertising state. So no other LL_Connect_Req can be processed. So that means that connection attempts are serialized.

Now if you run AE and multiple instances, that might be different, but then again, these instances are also offset in time and so I don’t see how we can get more than one HCI_Connection_Complete event at a time (and with that a leading ACL packet).

Regards

Marcel

