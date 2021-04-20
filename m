Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74892365ED3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhDTRvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTRvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:51:41 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC60C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 10:51:10 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id e25so9820261oii.2
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 10:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ma8RB468K5ozpJVFM08soA8jp4YERHtbyX5vWDxStvU=;
        b=akZdFn4TvvUl7qwYE8jvPPQtDK6VdcOdYP8W1VDxC28LUJfeBeig08unB2ssAzsAGX
         /oCyGqBxU6tf6RKK9b/CK+U3+S7yYebD64HRSEBdC3jtwU2+/p+TkRaOQbJNWn7gi4gb
         KQA5L/8ZXSGt8KINZGWz3exWWWX8CxquhBVZsLhxn9Jc4utNsuyGU8W1qUjdAbPsrKCh
         fVmWjkIamXXgFHZC18if2H5CsNi0PZ5gjytSKMBM1JpTAngYhIkA4GA+iKT4N5w3k1Cu
         OR6dFv0yGoaX8N2t7lGg9ikZRuYYJUbtM6+g67V2FnCoyirhaXZx/BF2TOdl/e8zO/v7
         hwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ma8RB468K5ozpJVFM08soA8jp4YERHtbyX5vWDxStvU=;
        b=BRKNe0LplgI9/45Hym6BVCwpx3NJBACj26lJvdVTBiqFZX7xIs0U0T5YtgucsjHk7b
         OmRErSCdujdk3ORlube1crSyz0r9N4mRonKS2DD0uMoTxOJXFqWCOFmyuBRMRkY5MOp5
         l5sg++wRAsR8dbOVI/0kpzF75kXimq4gzNPZLIf9dq6aawtKCFS6S0k+SqWabbJfZr2U
         9k2OT8L0L55Nwd40Preq4Qoxo20AKDQqjiHEk2gJ5R/ZJL8AkH55ax65IzuqixkuGJVH
         4BI3FbAbM1M4jOHBvbKbTAqzIxhp4wl5f9U8XLfB3PDcgMS2rU7igXfumx4WqgVmrMfT
         0UrA==
X-Gm-Message-State: AOAM5335qavF8PfhwleFJamx8MpYA7jeWw5Ob/D9a0i/LJjUGF+eCybM
        Hcpizl2Q5dISFSq8hAoje9I=
X-Google-Smtp-Source: ABdhPJzgTMnwZYUk3vKixuhsumkvasqZ6F+UmNGMPSoURgUUxQMgb6jHliEYMFCmKgKTWQTPzau4dg==
X-Received: by 2002:aca:408a:: with SMTP id n132mr4038699oia.70.1618941069421;
        Tue, 20 Apr 2021 10:51:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o20sm3586515oos.19.2021.04.20.10.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 10:51:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
 <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net>
 <CANn89iKMbUtDhU+B5dFJDABUSJJ3rnN0PWO0TDY=mRYEbNpHZw@mail.gmail.com>
 <20210420154240.GA115350@roeck-us.net>
 <CANn89iKqx69Xe9x3BzDrybqwgAfiASXZ8nOC7KN8dmADonOBxw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <335cc59c-47c4-2781-7146-6c671c2ee62c@roeck-us.net>
Date:   Tue, 20 Apr 2021 10:51:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKqx69Xe9x3BzDrybqwgAfiASXZ8nOC7KN8dmADonOBxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/21 9:31 AM, Eric Dumazet wrote:
> On Tue, Apr 20, 2021 at 5:42 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Tue, Apr 20, 2021 at 04:00:07PM +0200, Eric Dumazet wrote:
>>> On Tue, Apr 20, 2021 at 3:48 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>> On 4/20/21 2:43 AM, Eric Dumazet wrote:
>>>
>>>>>
>>>>
>>>> Unfortunately that doesn't fix the problem for me. With this patch applied
>>>> on top of next-20210419, I still get the same crash as before:
>>>>
>>>> udhcpc: sending discover^M
>>>> Unable to handle kernel paging request at virtual address 0000000000000004^M
>>>> udhcpc(169): Oops -1^M
>>>> pc = [<0000000000000004>]  ra = [<fffffc0000b8c5b8>]  ps = 0000    Not tainted^M
>>>> pc is at 0x4^M
>>>> ra is at napi_gro_receive+0x68/0x150^M
>>>> v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000^M
>>>> t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038^M
>>>> t5 = 000000000000ffff  t6 = fffffc00002f298a  t7 = fffffc0002c78000^M
>>>> s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0^M
>>>> s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f2940^M
>>>> s6 = fffffc00025f2040^M
>>>> a0 = fffffc00025f2008  a1 = fffffc00002f2940  a2 = fffffc0002ca000c^M
>>>> a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000^M
>>>> t8 = fffffc00010b3c80  t9 = fffffc0002ca04cc  t10= 0000000000000000^M
>>>> t11= 00000000000004c0  pv = fffffc0000b8bc40  at = 0000000000000000^M
>>>> gp = fffffc00010f9fb8  sp = 00000000df74db09^M
>>>> Disabling lock debugging due to kernel taint^M
>>>> Trace:^M
>>>> [<fffffc0000b8c5b8>] napi_gro_receive+0x68/0x150^M
>>>> [<fffffc00009b409c>] receive_buf+0x50c/0x1b80^M
>>>> [<fffffc00009b58b8>] virtnet_poll+0x1a8/0x5b0^M
>>>> [<fffffc00009b58ec>] virtnet_poll+0x1dc/0x5b0^M
>>>> [<fffffc0000b8d17c>] __napi_poll+0x4c/0x270^M
>>>> [<fffffc0000b8d670>] net_rx_action+0x130/0x2c0^M
>>>> [<fffffc0000bd6cb0>] sch_direct_xmit+0x170/0x360^M
>>>> [<fffffc0000bd7000>] __qdisc_run+0x160/0x6c0^M
>>>> [<fffffc0000337b64>] do_softirq+0xa4/0xd0^M
>>>> [<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120^M
>>>> [<fffffc0000b89554>] __dev_queue_xmit+0x484/0xa60^M
>>>> [<fffffc0000cd072c>] packet_sendmsg+0xe7c/0x1ba0^M
>>>> [<fffffc0000b53338>] __sys_sendto+0xf8/0x170^M
>>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
>>>> [<fffffc0000a9bf7c>] ehci_irq+0x2cc/0x5c0^M
>>>> [<fffffc0000a71334>] usb_hcd_irq+0x34/0x50^M
>>>> [<fffffc0000b521bc>] move_addr_to_kernel+0x3c/0x60^M
>>>> [<fffffc0000b532e4>] __sys_sendto+0xa4/0x170^M
>>>> [<fffffc0000b533d4>] sys_sendto+0x24/0x40^M
>>>> [<fffffc0000cfea38>] _raw_spin_lock+0x18/0x30^M
>>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
>>>> [<fffffc0000325298>] clipper_enable_irq+0x98/0x100^M
>>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
>>>> [<fffffc0000311514>] entSys+0xa4/0xc0^M
>>>
>>> OK, it would be nice if you could get line number from this stack trace.
>>>
>>
>> Here you are:
>>
>> napi_gro_receive (net/core/dev.c:6196)
>> receive_buf (drivers/net/virtio_net.c:1150)
>> virtnet_poll (drivers/net/virtio_net.c:1414 drivers/net/virtio_net.c:1519)
>> clipper_srm_device_interrupt (arch/alpha/kernel/sys_dp264.c:256)
>> virtnet_poll (drivers/net/virtio_net.c:1413 drivers/net/virtio_net.c:1519)
>> __napi_poll (net/core/dev.c:6962)
>> net_rx_action (net/core/dev.c:7029 net/core/dev.c:7116)
>> __qdisc_run (net/sched/sch_generic.c:376 net/sched/sch_generic.c:384)
>> do_softirq (./include/asm-generic/softirq_stack.h:10 kernel/softirq.c:460 kernel/softirq.c:447)
>> __local_bh_enable_ip (kernel/softirq.c:384)
>> __dev_queue_xmit (./include/linux/bottom_half.h:32 ./include/linux/rcupdate.h:746 net/core/dev.c:4272)
>> packet_sendmsg (net/packet/af_packet.c:3009 net/packet/af_packet.c:3034)
>> __sys_sendto (net/socket.c:654 net/socket.c:674 net/socket.c:1977)
>> __d_alloc (fs/dcache.c:1744)
>> packet_create (net/packet/af_packet.c:1192 net/packet/af_packet.c:3296)
>> move_addr_to_kernel (./include/linux/uaccess.h:192 net/socket.c:198 net/socket.c:192)
>> __sys_sendto (net/socket.c:1968)
>> sys_sendto (net/socket.c:1989 net/socket.c:1985)
>> sys_bind (net/socket.c:1648 net/socket.c:1646)
>> entSys (arch/alpha/kernel/entry.S:477)
>>
>> Guenter
> 
> OK, I guess we are back to unaligned access, right ?
> I guess sh arch should have failed as well ?
> 

sh does indeed fail, with the same symptoms as before, but so far I was not
able to track it down to a specific commit. The alpha failure is different,
though. It is a NULL pointer access.

Anyway, testing ...

The patch below does indeed fix the problem I am seeing on sh.

... and it does fix the alpha problem as well. Neat, though I don't really understand
what a NULL pointer access and an unaligned access have to do with each other.

Great catch, thanks!

Guenter


> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8cd76037c72481200ea3e8429e9fdfec005dad85..0579914d3dd84c24982c1ff85314cc7b8d0f8d2d
> 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -415,7 +415,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 
>         shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> 
> -       if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> +       if (len > GOOD_COPY_LEN && tailroom >= shinfo_size &&
> +           (!NET_IP_ALIGN || ((unsigned long)p & 3) == 2)) {
>                 skb = build_skb(p, truesize);
>                 if (unlikely(!skb))
>                         return NULL;
> 

