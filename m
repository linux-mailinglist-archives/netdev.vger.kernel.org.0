Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D81905B7
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgCXG1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Mar 2020 02:27:38 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:38241 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgCXG1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 02:27:37 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5FE72CED06;
        Tue, 24 Mar 2020 07:37:07 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2 1/1] Bluetooth: Prioritize SCO traffic
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZLBvyjDnLpH40u1Vq9DftyC0dty2NMf9QEsazas9Ktwvw@mail.gmail.com>
Date:   Tue, 24 Mar 2020 07:27:35 +0100
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <97B27CBF-B4F7-48E2-8512-CFF5481221EC@holtmann.org>
References: <20200320231928.137720-1-abhishekpandit@chromium.org>
 <20200320161922.v2.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
 <C09DCA09-A2C9-4675-B17B-05CE0B5DE172@holtmann.org>
 <CANFp7mXG1HXKNQKn2YTsEOX6puNz=8WY6AHWac4UOiVMVQyEkg@mail.gmail.com>
 <CABBYNZLBvyjDnLpH40u1Vq9DftyC0dty2NMf9QEsazas9Ktwvw@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>>>> When scheduling TX packets, send all SCO/eSCO packets first, check for
>>>> pending SCO/eSCO packets after every ACL/LE packet and send them if any
>>>> are pending.  This is done to make sure that we can meet SCO deadlines
>>>> on slow interfaces like UART.
>>>> 
>>>> If we were to queue up multiple ACL packets without checking for a SCO
>>>> packet, we might miss the SCO timing. For example:
>>>> 
>>>> The time it takes to send a maximum size ACL packet (1024 bytes):
>>>> t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
>>>>       where 10/8 is uart overhead due to start/stop bits per byte
>>>> 
>>>> Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.
>>>> 
>>>> At a baudrate of 3000000, if we didn't check for SCO packets within 1024
>>>> bytes, we would miss the 3.75ms timing window.
>>>> 
>>>> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>>>> ---
>>>> 
>>>> Changes in v2:
>>>> * Refactor to check for SCO/eSCO after each ACL/LE packet sent
>>>> * Enabled SCO priority all the time and removed the sched_limit variable
>>>> 
>>>> net/bluetooth/hci_core.c | 111 +++++++++++++++++++++------------------
>>>> 1 file changed, 61 insertions(+), 50 deletions(-)
>>>> 
>>>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>>>> index dbd2ad3a26ed..a29177e1a9d0 100644
>>>> --- a/net/bluetooth/hci_core.c
>>>> +++ b/net/bluetooth/hci_core.c
>>>> @@ -4239,6 +4239,60 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
>>>>      }
>>>> }
>>>> 
>>>> +/* Schedule SCO */
>>>> +static void hci_sched_sco(struct hci_dev *hdev)
>>>> +{
>>>> +     struct hci_conn *conn;
>>>> +     struct sk_buff *skb;
>>>> +     int quote;
>>>> +
>>>> +     BT_DBG("%s", hdev->name);
>>>> +
>>>> +     if (!hci_conn_num(hdev, SCO_LINK))
>>>> +             return;
>>>> +
>>>> +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
>>>> +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
>>>> +                     BT_DBG("skb %p len %d", skb, skb->len);
>>>> +                     hci_send_frame(hdev, skb);
>>>> +
>>>> +                     conn->sent++;
>>>> +                     if (conn->sent == ~0)
>>>> +                             conn->sent = 0;
>>>> +             }
>>>> +     }
>>>> +}
>>>> +
>>>> +static void hci_sched_esco(struct hci_dev *hdev)
>>>> +{
>>>> +     struct hci_conn *conn;
>>>> +     struct sk_buff *skb;
>>>> +     int quote;
>>>> +
>>>> +     BT_DBG("%s", hdev->name);
>>>> +
>>>> +     if (!hci_conn_num(hdev, ESCO_LINK))
>>>> +             return;
>>>> +
>>>> +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
>>>> +                                                  &quote))) {
>>>> +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
>>>> +                     BT_DBG("skb %p len %d", skb, skb->len);
>>>> +                     hci_send_frame(hdev, skb);
>>>> +
>>>> +                     conn->sent++;
>>>> +                     if (conn->sent == ~0)
>>>> +                             conn->sent = 0;
>>>> +             }
>>>> +     }
>>>> +}
>>>> +
>>>> +static void hci_sched_sync(struct hci_dev *hdev)
>>>> +{
>>>> +     hci_sched_sco(hdev);
>>>> +     hci_sched_esco(hdev);
>>>> +}
>>>> +
>>> 
>>> scrap this function. It has almost zero benefit.
>> 
>> Done.
>> 
>>> 
>>>> static void hci_sched_acl_pkt(struct hci_dev *hdev)
>>>> {
>>>>      unsigned int cnt = hdev->acl_cnt;
>>>> @@ -4270,6 +4324,9 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
>>>>                      hdev->acl_cnt--;
>>>>                      chan->sent++;
>>>>                      chan->conn->sent++;
>>>> +
>>>> +                     /* Send pending SCO packets right away */
>>>> +                     hci_sched_sync(hdev);
>>> 
>>>                        hci_sched_esco();
>>>                        hci_sched_sco();
>>> 
>>>>              }
>>>>      }
>>>> 
>>>> @@ -4354,54 +4411,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
>>>>      }
>>>> }
>>>> 
>>>> -/* Schedule SCO */
>>>> -static void hci_sched_sco(struct hci_dev *hdev)
>>>> -{
>>>> -     struct hci_conn *conn;
>>>> -     struct sk_buff *skb;
>>>> -     int quote;
>>>> -
>>>> -     BT_DBG("%s", hdev->name);
>>>> -
>>>> -     if (!hci_conn_num(hdev, SCO_LINK))
>>>> -             return;
>>>> -
>>>> -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
>>>> -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
>>>> -                     BT_DBG("skb %p len %d", skb, skb->len);
>>>> -                     hci_send_frame(hdev, skb);
>>>> -
>>>> -                     conn->sent++;
>>>> -                     if (conn->sent == ~0)
>>>> -                             conn->sent = 0;
>>>> -             }
>>>> -     }
>>>> -}
>>>> -
>>>> -static void hci_sched_esco(struct hci_dev *hdev)
>>>> -{
>>>> -     struct hci_conn *conn;
>>>> -     struct sk_buff *skb;
>>>> -     int quote;
>>>> -
>>>> -     BT_DBG("%s", hdev->name);
>>>> -
>>>> -     if (!hci_conn_num(hdev, ESCO_LINK))
>>>> -             return;
>>>> -
>>>> -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
>>>> -                                                  &quote))) {
>>>> -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
>>>> -                     BT_DBG("skb %p len %d", skb, skb->len);
>>>> -                     hci_send_frame(hdev, skb);
>>>> -
>>>> -                     conn->sent++;
>>>> -                     if (conn->sent == ~0)
>>>> -                             conn->sent = 0;
>>>> -             }
>>>> -     }
>>>> -}
>>>> -
>>>> static void hci_sched_le(struct hci_dev *hdev)
>>>> {
>>>>      struct hci_chan *chan;
>>>> @@ -4436,6 +4445,9 @@ static void hci_sched_le(struct hci_dev *hdev)
>>>>                      cnt--;
>>>>                      chan->sent++;
>>>>                      chan->conn->sent++;
>>>> +
>>>> +                     /* Send pending SCO packets right away */
>>>> +                     hci_sched_sync(hdev);
>>> 
>>> Same as above. Just call the two functions.
>> 
>> Done
>> 
>>> 
>>>>              }
>>>>      }
>>>> 
>>>> @@ -4458,9 +4470,8 @@ static void hci_tx_work(struct work_struct *work)
>>>> 
>>>>      if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
>>>>              /* Schedule queues and send stuff to HCI driver */
>>>> +             hci_sched_sync(hdev);
>>>>              hci_sched_acl(hdev);
>>>> -             hci_sched_sco(hdev);
>>>> -             hci_sched_esco(hdev);
>>>>              hci_sched_le(hdev);
>>> 
>>> I would actually just move _le up after _acl and then keep _sco and _esco at the bottom. The calls here are just for the case there are no ACL nor LE packets.
>> 
>> Then we would send at least 1 ACL/LE packet before SCO even if there
>> were SCO pending when we entered this function. I think it is still
>> better to keep SCO/eSCO at the top.
> 
> I wonder it wouldn't be better to have such prioritization done by the
> driver though, since this might just be spending extra cpu cycles in
> case there is enough bandwidth at the transport chances are the
> reordering here just doesn't make any difference in the end, you
> probably don't even need any changes to the core in order for the
> driver to detect what type of frame it is based on the skb, I recall
> we do already have such information in the driver so it just a matter
> to reorder the frames as needed there.

We could hide the extra _acl and _le calls inside _sco and _esco behind a QUIRK that the UART driver just sets. However I am not sure that will be actually much different. Even for USB transports it would be good to get the ISCO URBs on the way as quickly as possible.

What I was wondering why we actually do scheduling per connection type. In the original code base it was ACL and SCO. We only had two connection types and two packet types. So that kind made sense. However I wonder if we were misguided by doing this per connection type and not focusing on keeping this per packet type.

To that extend we introduced priority handling for the ACL and LE links. So no matter what the ACL and LE links will reorder their packets as needed. And the driver just executes this. So the core already reorders it.

I wonder really why we just not make the core insert the SCO packets accordingly into the ACL/LE stream so that the driver really only just has to transport them. What is good for an UART transport, will not be bad for an USB transport.

Regards

Marcel

