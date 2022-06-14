Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661CB54B26C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiFNNmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 09:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbiFNNmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 09:42:54 -0400
Received: from giacobini.uberspace.de (giacobini.uberspace.de [185.26.156.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A4A205E0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:42:51 -0700 (PDT)
Received: (qmail 12563 invoked by uid 990); 14 Jun 2022 13:42:49 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
Message-ID: <22131ee2-914c-3aad-d2c3-f340ad0c8ad0@eknoes.de>
Date:   Tue, 14 Jun 2022 15:42:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220610110749.110881-1-soenke.huster@eknoes.de>
 <CANn89i+YHqMddY68Qk1rZexqhYYX9gah-==WGttFbp4urLS7Qg@mail.gmail.com>
 <9f214837-dc68-ef1a-0199-27d6af582115@eknoes.de>
 <CANn89iKS7npfHvBJNP2PBtR9RAQGsVdykELX8mK8DQbFbLeybA@mail.gmail.com>
From:   =?UTF-8?Q?S=c3=b6nke_Huster?= <soenke.huster@eknoes.de>
Subject: Re: [PATCH v2] Bluetooth: RFCOMM: Use skb_trim to trim checksum
In-Reply-To: <CANn89iKS7npfHvBJNP2PBtR9RAQGsVdykELX8mK8DQbFbLeybA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-2.992468) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -1.592468
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Tue, 14 Jun 2022 15:42:49 +0200
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 10.06.22 18:55, Eric Dumazet wrote:
> On Fri, Jun 10, 2022 at 8:35 AM Sönke Huster <soenke.huster@eknoes.de> wrote:
>>
>> Hi Eric,
>>
>> On 10.06.22 15:59, Eric Dumazet wrote:
>>> On Fri, Jun 10, 2022 at 4:08 AM Soenke Huster <soenke.huster@eknoes.de> wrote:
>>>>
>>>> As skb->tail might be zero, it can underflow. This leads to a page
>>>> fault: skb_tail_pointer simply adds skb->tail (which is now MAX_UINT)
>>>> to skb->head.
>>>>
>>>>     BUG: unable to handle page fault for address: ffffed1021de29ff
>>>>     #PF: supervisor read access in kernel mode
>>>>     #PF: error_code(0x0000) - not-present page
>>>>     RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:1751)
>>>>
>>>> By using skb_trim instead of the direct manipulation, skb->tail
>>>> is reset. Thus, the correct pointer to the checksum is used.
>>>>
>>>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
>>>> ---
>>>> v2: Clarified how the bug triggers, minimize code change
>>>>
>>>>  net/bluetooth/rfcomm/core.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>>>> index 7324764384b6..443b55edb3ab 100644
>>>> --- a/net/bluetooth/rfcomm/core.c
>>>> +++ b/net/bluetooth/rfcomm/core.c
>>>> @@ -1747,7 +1747,7 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
>>>>         type = __get_type(hdr->ctrl);
>>>>
>>>>         /* Trim FCS */
>>>> -       skb->len--; skb->tail--;
>>>> +       skb_trim(skb, skb->len - 1);
>>>>         fcs = *(u8 *)skb_tail_pointer(skb);
>>>>
>>>>         if (__check_fcs(skb->data, type, fcs)) {
>>>> --
>>>> 2.36.1
>>>>
>>>
>>> Again, I do not see how skb->tail could possibly zero at this point.
>>>
>>> If it was, skb with illegal layout has been queued in the first place,
>>> we need to fix the producer, not the consumer.
>>>
>>
>> Sorry, I thought that might be a right place as there is not much code in the kernel
>> that manipulates ->tail directly.
>>
>>> A driver missed an skb_put() perhaps.
>>>
>>
>> I am using the (I guess quite unused) virtio_bt driver, and figured out that the following
>> fixes the bug:
>>
>> --- a/drivers/bluetooth/virtio_bt.c
>> +++ b/drivers/bluetooth/virtio_bt.c
>> @@ -219,7 +219,7 @@ static void virtbt_rx_work(struct work_struct *work)
>>         if (!skb)
>>                 return;
>>
>> -       skb->len = len;
>> +       skb_put(skb, len);
> 
> Removing skb->len=len seems about right.
> But skb_put() should be done earlier.
> 
> We are approaching the skb producer :)
> 
> Now you have to find/check who added this illegal skb in the virt queue.
> 
> Maybe virtbt_add_inbuf() ?

I think here, the length of the skb can't really be known - an empty SKB is put into
the virtqueue, and then filled with data in the device, which is implemented in a Hypervisor.
Maybe my implementation of that device might then be wrong, on the other hand I am pretty
sure the driver should be the one that sets the length of the skb. But the driver only
knows it in virtbt_rx_work, as it learns the size of the added buffer there for the first time.

> 
> Also there is kernel info leak I think.
> 

I think your are right!

> diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
> index 67c21263f9e0f250f0719b8e7f1fe15b0eba5ee0..c9b832c447ee451f027430b284d7bb246f6ecb24
> 100644
> --- a/drivers/bluetooth/virtio_bt.c
> +++ b/drivers/bluetooth/virtio_bt.c
> @@ -37,6 +37,9 @@ static int virtbt_add_inbuf(struct virtio_bluetooth *vbt)
>         if (!skb)
>                 return -ENOMEM;
> 
> +       skb_put(skb, 1000);
> +       memset(skb->data, 0, 1000);
> +
>         sg_init_one(sg, skb->data, 1000);
> 
>         err = virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);
> 
> 
>>         virtbt_rx_handle(vbt, skb);
>>
>>         if (virtbt_add_inbuf(vbt) < 0)
>>
>> I guess this is the root cause? I just used Bluetooth for a while in the VM
>> and no error occurred, everything worked fine.
>>
>>> Can you please dump the skb here  ?
>>>
>>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>>> index 7324764384b6773074032ad671777bf86bd3360e..358ccb4fe7214aea0bb4084188c7658316fe0ff7
>>> 100644
>>> --- a/net/bluetooth/rfcomm/core.c
>>> +++ b/net/bluetooth/rfcomm/core.c
>>> @@ -1746,6 +1746,11 @@ static struct rfcomm_session
>>> *rfcomm_recv_frame(struct rfcomm_session *s,
>>>         dlci = __get_dlci(hdr->addr);
>>>         type = __get_type(hdr->ctrl);
>>>
>>> +       if (!skb->tail) {
>>> +               DO_ONCE_LITE(skb_dump(KERN_ERR, skb, false));
>>> +               kfree_skb(skb);
>>> +               return s;
>>> +       }
>>>         /* Trim FCS */
>>>         skb->len--; skb->tail--;
>>>         fcs = *(u8 *)skb_tail_pointer(skb);
>>
>> If it might still help:
>>
>> skb len=4 headroom=9 headlen=4 tailroom=1728
>> mac=(-1,-1) net=(0,-1) trans=-1
>> shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
>> csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
>> hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0
>> skb linear:   00000000: 03 3f 01 1c
>>
