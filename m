Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF835B720
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 00:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhDKWHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 18:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhDKWHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 18:07:44 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17451C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 15:07:28 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso436666oto.3
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 15:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/lRla01KU0ybI4xpUqAJc8X9+MHM0a+SO6iOFLTi9nU=;
        b=f85+lsIWoE8r8uO/oVTyhLZWzUoLEIjb2vJcoaLyh00jQq7N+H7l30uviMerzgARd9
         q7sXL6q6VT5LLzTnQLQ0Q/IVDWly4eif1os4s4caUTYBjT26bpxzjywXSaU4c8idLT7N
         bPbSpAqG3fRzEo/4h5S4krhL3yD9z0Ji7U1XZ+lMGS0oxm2b2Tum263d7zQhkGJNpFJH
         GSkqsZxJgqRv9EgGaQfVoNoCbkOtNxOmyRbjfKvkcIlh+wKtu0zF5r6jpmlvU2OAyB+L
         jnjk/BP0ZPOMfsjU93TOVT+m3xUdIVtL4SBmqSFiuWf54D0bcu9jmCSOuiAqMiEPvoec
         zr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/lRla01KU0ybI4xpUqAJc8X9+MHM0a+SO6iOFLTi9nU=;
        b=TYkCuHMjQJq2jfiBBrdXkFAn3NsrTVQuUuT8fyo7zPPhi0EI/7agWVpKoWMUP4lDDI
         C9zf2e7vKWjqieGFczht+j71UnX5OF2aiIodZ3KDMy4OAL/eP0Pn5H9I4DMtizuYAoUX
         ubhneWeFoIrMAB3phgYQ78ommLumos/AOpBmf+pn97abRgbDhsQkFwMNx7hf/bZTjCWJ
         gHiUgUpwfatnblg8wno7cqvwvw0ZANedeYtWiCNW0mD8dpm0pXDJrTRCu9Pre4hHbDXO
         qQ+Hrj/VfoFzYsL3GZsYnykwAHdYEPMufjpZn2fyrgSM40XvbzsoCREnJU9MACD4QFYy
         U8WA==
X-Gm-Message-State: AOAM530Uk5SWRStX3LqiTAwIxGQ+t4A6dPLjnQpAvHHbNfqGhLu4zzWB
        GHXiK0YkISEJCsz9uuAhGU9cOY40+1k=
X-Google-Smtp-Source: ABdhPJzRm9ThUpvUGHE2v5+iEyTy/q2DYpwd0EvqeKjwazo67FYftgwMmykAZOX2LBgy1MzwYaVcxw==
X-Received: by 2002:a9d:2622:: with SMTP id a31mr22262354otb.275.1618178847473;
        Sun, 11 Apr 2021 15:07:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j4sm690533oiw.0.2021.04.11.15.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 15:07:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net>
 <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net>
 <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
 <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net>
 <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <ad232021-d30a-da25-c1d5-0bd79628b5e1@roeck-us.net>
Date:   Sun, 11 Apr 2021 15:07:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 2:43 PM, Eric Dumazet wrote:
> On Sun, Apr 11, 2021 at 11:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 4/11/21 2:23 PM, Eric Dumazet wrote:
>>> On Sun, Apr 11, 2021 at 10:37 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>> On 4/11/21 8:06 AM, Eric Dumazet wrote:
>>>>> On Sun, Apr 11, 2021 at 3:43 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>
>>>>>> This patch causes a virtio-net interface failure when booting sh4 images
>>>>>> in qemu. The test case is nothing special: Just try to get an IP address
>>>>>> using udhcpc. If it fails, udhcpc reports:
>>>>>>
>>>>>> udhcpc: started, v1.33.0
>>>>>> udhcpc: sending discover
>>>>>> FAIL
>>>>>>
>>>>>
>>>>> Can you investigate where the incoming packet is dropped ?
>>>>>
>>>>
>>>> Unless I am missing something, packets are not dropped. It looks more
>>>> like udhcpc gets bad indigestion in the receive path and exits immediately.
>>>> Plus, it doesn't happen all the time; sometimes it receives the discover
>>>> response and is able to obtain an IP address.
>>>>
>>>> Overall this is quite puzzling since udhcpc exits immediately when the problem
>>>> is seen, no matter which option I give it on the command line; it should not
>>>> really do that.
>>>
>>>
>>> Could you strace both cases and report differences you can spot ?
>>>
>>> strace -o STRACE -f -s 1000 udhcpc
>>>
>>
>> I'll give it a try. It will take a while; I'll need to add strace to my root
>> file systems first.
>>
>> As a quick hack, I added some debugging into the kernel; it looks like
>> the data part of the dhcp discover response may get lost with your patch
>> in place.
> 
> Data is not lost, the payload is whole contained in skb frags, which
> was expected from my patch.
> 
> Maybe this sh arch does something wrong in this case.
> 
> This could be checksuming...
> 
> Please check
> 
> nstat -n
> <run udhcpc>
> nstat
> 

Another tool to install.

While that builds, output from strace:

# strace -o /tmp/STRACE  -f -s 1000 udhcpc -n -q
udhcpc: started, v1.33.0
udhcpc: sending discover
udhcpc: received SIGTERM

and:

...
136   socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) = 5
136   bind(5, {sa_family=AF_PACKET, sll_protocol=htons(ETH_P_IP), sll_ifindex=if_nametoindex("eth0"), sll_hatype=ARPHRD_NETROM, sll_pkttype=PACKET_HOST, sll_halen=0}, 20) = 0
136   setsockopt(5, SOL_PACKET, PACKET_AUXDATA, [1], 4) = 0
136   fcntl64(5, F_SETFD, FD_CLOEXEC)   = 0
136   socket(AF_INET, SOCK_RAW, IPPROTO_RAW) = 6
136   ioctl(6, SIOCGIFINDEX, {ifr_name="eth0", }) = 0
136   ioctl(6, SIOCGIFHWADDR, {ifr_name="eth0", ifr_hwaddr={sa_family=ARPHRD_ETHER, sa_data=52:54:00:12:34:56}}) = 0
136   close(6)                          = 0
136   clock_gettime64(CLOCK_MONOTONIC, {tv_sec=161, tv_nsec=2180242}) = 0
136   write(2, "udhcpc: sending discover\n", 25) = 25
136   socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) = 6
136   bind(6, {sa_family=AF_PACKET, sll_protocol=htons(ETH_P_IP), sll_ifindex=if_nametoindex("eth0"), sll_hatype=ARPHRD_NETROM, sll_pkttype=PACKET_HOST, sll_halen=6, sll_addr=[0xff, 0xff, 0xff, 0xff, 0xff, 0xff]}, 20) = 0
136   sendto(6, "E\0\1H\0\0\0\0@\21y\246\0\0\0\0\377\377\377\377\0D\0C\0014\200\256\1\1\6\0\257\321\212P\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0RT\0\0224V\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0c\202Sc5\1\1=\7\1RT\0\0224V9\2\2@7\7\1\3\6\f\17\34*<\fudhcp 1.33.0\377\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 328, 0, {sa_family=AF_PACKET, sll_protocol=htons(ETH_P_IP), sll_ifindex=if_nametoindex("eth0"), sll_hatype=ARPHRD_NETROM, sll_pkttype=PACKET_HOST, sll_halen=6, sll_addr=[0xff, 0xff, 0xff, 0xff, 0xff, 0xff]}, 20

Guenter
