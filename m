Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63B221454
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOSgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:36:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:58078 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:36:18 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvmGK-0004f7-4M; Wed, 15 Jul 2020 20:36:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvmGJ-000KGB-UP; Wed, 15 Jul 2020 20:36:11 +0200
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb
 path
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        A.Zema@falconvsystems.com
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
 <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net>
 <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a6bee4f6-10a9-abbd-1b90-bf4a7c82dacc@iogearbox.net>
Date:   Wed, 15 Jul 2020 20:36:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25874/Wed Jul 15 16:18:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/20 9:39 AM, Magnus Karlsson wrote:
> On Sat, Jul 11, 2020 at 1:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 7/10/20 8:45 AM, Magnus Karlsson wrote:
>>> In the skb Tx path, transmission of a packet is performed with
>>> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
>>> routines, it returns NETDEV_TX_BUSY signifying that it was not
>>> possible to send the packet now, please try later. Unfortunately, the
>>> xsk transmit code discarded the packet, missed to free the skb, and
>>> returned EBUSY to the application. Fix this memory leak and
>>> unnecessary packet loss, by not discarding the packet in the Tx ring,
>>> freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
>>> application, it can then retry the send operation and the packet will
>>> finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
>>> state anymore. So EAGAIN tells the application that the packet was not
>>> discarded from the Tx ring and that it needs to call send()
>>> again. EBUSY, on the other hand, signifies that the packet was not
>>> sent and discarded from the Tx ring. The application needs to put the
>>> packet on the Tx ring again if it wants it to be sent.
>>>
>>> Fixes: 35fcde7f8deb ("xsk: support for Tx")
>>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>>> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
>>> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
>>> ---
>>> The v1 of this patch was called "xsk: do not discard packet when
>>> QUEUE_STATE_FROZEN".
>>> ---
>>>    net/xdp/xsk.c | 13 +++++++++++--
>>>    1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>> index 3700266..5304250 100644
>>> --- a/net/xdp/xsk.c
>>> +++ b/net/xdp/xsk.c
>>> @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
>>>                skb->destructor = xsk_destruct_skb;
>>>
>>>                err = dev_direct_xmit(skb, xs->queue_id);
>>> -             xskq_cons_release(xs->tx);
>>>                /* Ignore NET_XMIT_CN as packet might have been sent */
>>> -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
>>> +             if (err == NET_XMIT_DROP) {
>>>                        /* SKB completed but not sent */
>>> +                     xskq_cons_release(xs->tx);
>>>                        err = -EBUSY;
>>>                        goto out;
>>> +             } else if  (err == NETDEV_TX_BUSY) {
>>> +                     /* QUEUE_STATE_FROZEN, tell application to
>>> +                      * retry sending the packet
>>> +                      */
>>> +                     skb->destructor = NULL;
>>> +                     kfree_skb(skb);
>>> +                     err = -EAGAIN;
>>> +                     goto out;
>>
>> Hmm, I'm probably missing something or I should blame my current lack of coffee,
>> but I'll ask anyway.. What is the relation here to the kfree_skb{,_list}() in
>> dev_direct_xmit() when we have NETDEV_TX_BUSY condition? Wouldn't the patch above
>> double-free with NETDEV_TX_BUSY?
> 
> I think you are correct even without coffee :-). I misinterpreted the
> following piece of code in dev_direct_xmit():
> 
> if (!dev_xmit_complete(ret))
>       kfree_skb(skb);
> 
> If the skb was NOT consumed by the transmit, then it goes and frees
> the skb. NETDEV_TX_BUSY as a return value will make
> dev_xmit_complete() return false which triggers the freeing of the
> skb. So if I now understand dev_direct_xmit() correctly, it will
> always consume the skb, even when NETDEV_TX_BUSY is returned. And this
> is what I would like to avoid. If the skb is freed, the destructor is
> triggered and it will complete the packet to user-space, which is the
> same thing as dropping it, which is what I want to avoid in the first
> place since it is completely unnecessary.
> 
> So what would be the best way to solve this? Prefer to share the code
> with AF_PACKET if possible. Introduce a boolean function parameter to
> indicate if it should be freed in this case? Other ideas? Here are the
> users of dev_direct_xmit():

Another option could be looking at pktgen which mangles skb->users to keep
the skb alive.

Thanks,
Daniel
