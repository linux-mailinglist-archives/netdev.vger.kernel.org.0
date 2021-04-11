Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0D35B709
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 23:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhDKVdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 17:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbhDKVdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 17:33:11 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3645C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:32:53 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id c6-20020a4aacc60000b02901e6260b12e2so119891oon.3
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FpqqOOu9vYS1RLHK9pwDr2YV0nLK6UfyVXjAHQu5DC0=;
        b=QGweP0ElvPgvnSOHnG3sogrflU8g6FcVdNoqWedhHsdCg7IuH6Cmc9+MFUNB0YWl7X
         M5Vegnxzu9q/2blCgMmdRfF3Rbijvvx739Es2pgUMlrdDf89/J0nt7XsndA5Tl1nETdz
         KcLhYQyoLJHiNNFe/en751I9gipsRz1yZZYgmp58U09vKPq2KRh/rRX57PcbATZpFFaZ
         qU8NApDlWAS0MyEI383jiP3HRooUdACwlp7dgQbsdrdd602bKXH6NCpSHqqMiwLzifL8
         u/Zgs6hL1RGRjlLuIpNDTpSni+IIhDd4+W0CFeRwz1/Ys8emek8mhXsc6JVl0cfkEJ2p
         MAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FpqqOOu9vYS1RLHK9pwDr2YV0nLK6UfyVXjAHQu5DC0=;
        b=MZanrmoSPEIKFZKqXQGMmjoLmDMKS1OK9XEM7SlZHK/+ccx7gHRNQimoMcOVTlW57M
         aZ9JcxgRr9iHZKB0l3ObTBKkiJBNcMao3q+FUL8hv06Z4jix7GujbQKX6XAwjeuIAyKk
         dPEvVU84HXvmnI5mOgWLPVtL99LqqceKEP7q/vfU9TMJr+rKRAtdsx7+9wZ8bEozPAVK
         MoU0GCORs40pkA9ri2T0zrpwPDLTFSIOFJAX8UwKvTM4y3x3GfuMTvBXUGbRS25OwjnI
         olhGfOoZP5qUggvep1pe8yW9RN7snOPEA6ZHjJbNcvPE462ZV0SlsnFdfaBHtwRYFH3F
         5d+g==
X-Gm-Message-State: AOAM5316Cek62VAXU8ThQQuo8KYgjGsXrPY1l4/p/lJf0PvQMMcjMocf
        IzCqP+VGLKov8dfduhSnVic=
X-Google-Smtp-Source: ABdhPJzLe/a8fvB3mojeEUhba3H2nF7yr+Mv0IAOx8liVQ+E7UETQ6X2IkwdFiGaGvcnGI/bV9TL5Q==
X-Received: by 2002:a4a:9823:: with SMTP id y32mr20251478ooi.35.1618176772914;
        Sun, 11 Apr 2021 14:32:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h10sm1022026otm.11.2021.04.11.14.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 14:32:52 -0700 (PDT)
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
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net>
Date:   Sun, 11 Apr 2021 14:32:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 2:23 PM, Eric Dumazet wrote:
> On Sun, Apr 11, 2021 at 10:37 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 4/11/21 8:06 AM, Eric Dumazet wrote:
>>> On Sun, Apr 11, 2021 at 3:43 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>>> This patch causes a virtio-net interface failure when booting sh4 images
>>>> in qemu. The test case is nothing special: Just try to get an IP address
>>>> using udhcpc. If it fails, udhcpc reports:
>>>>
>>>> udhcpc: started, v1.33.0
>>>> udhcpc: sending discover
>>>> FAIL
>>>>
>>>
>>> Can you investigate where the incoming packet is dropped ?
>>>
>>
>> Unless I am missing something, packets are not dropped. It looks more
>> like udhcpc gets bad indigestion in the receive path and exits immediately.
>> Plus, it doesn't happen all the time; sometimes it receives the discover
>> response and is able to obtain an IP address.
>>
>> Overall this is quite puzzling since udhcpc exits immediately when the problem
>> is seen, no matter which option I give it on the command line; it should not
>> really do that.
> 
> 
> Could you strace both cases and report differences you can spot ?
> 
> strace -o STRACE -f -s 1000 udhcpc
> 

I'll give it a try. It will take a while; I'll need to add strace to my root
file systems first.

As a quick hack, I added some debugging into the kernel; it looks like
the data part of the dhcp discover response may get lost with your patch
in place.

dhcp discover response with patch in place (bad):

virtio_net virtio0 eth0: __udp4_lib_rcv: data 0x8ca4cc44 head 0x8ca4cc00 tail 0x8ca4cc4c len 556 datalen 548 caller ip_protocol_deliver_rcu+0xac/0x178
00000000: 70 c1 a9 8c 00 00 00 00 00 00 00 00 20 ee c3 7b 34 00 e0 7b 08 00 00 00 00 00 00 00 00 00 00 00  p........... ..{4..{............
00000020: 60 c8 ff ff ff ff ff ff 52 55 0a 00 02 02 08 00 45 10 02 40 00 00 00 00 40 11 6c 9c 0a 00 02 02  `.......RU......E..@....@.l.....
00000040: ff ff ff ff 00 43 00 44 02 2c e1 21 00 00 00 00 f0 6f a4 7b 00 00 80 00 ff ff ff ff 7f 45 4c 46  .....C.D.,.!.....o.{.........ELF
                      ^^ udp header
                                  ^^^^^ UDP length (556)
                                              ^^ start of UDP data (dhcp discover reply)
00000060: 01 01 01 00 00 00 00 00 00 00 00 00 02 00 2a 00 01 00 00 00 b0 6e 40 00 34 00 00 00 2c f6 0a 00  ..............*......n@.4...,...
00000080: 17 00 00 00 34 00 20 00 08 00 28 00 16 00 15 00 06 00 00 00 34 00 00 00 34 00 40 00 34 00 40 00  ....4. ...(.........4...4.@.4.@.
000000a0: 00 01 00 00 00 01 00 00 04 00 00 00 04 00 00 00 03 00 00 00 34 01 00 00 34 01 40 00 34 01 40 00  ....................4...4.@.4.@.
000000c0: 15 00 00 00 15 00 00 00 04 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00 00 00 40 00 00 00 40 00  ..........................@...@.
000000e0: 1c e2 0a 00 1c e2 0a 00 05 00 00 00 00 00 01 00 01 00 00 00 38 ef 0a 00 38 ef 4b 00 38 ef 4b 00  ....................8...8.K.8.K.
00000100: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00  ................................
00000120: b8 00 00 00 00 4c f9 8f 24 02 00 00 36 00 00 00 50 e5 74 64 88 e0 0a 00 88 e0 4a 00 88 e0 4a 00  .....L..$...6...P.td......J...J.
00000140: 2c 00 00 00 2c 00 00 00 04 00 00 00 04 00 00 00 51 e5 74 64 00 00 00 00 00 00 00 00 00 00 00 00  ,...,...........Q.td............
00000160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
00000180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
00000200: 1c 63 5a 8c 00 3e a4 8c 88 f9 50 8c 0c ce a4 8c 0c ce a4 8c 24 81 a1 8c 00 00 00 00 1c 5c 5a 8c  .cZ..>....P.........$........\Z.
00000220: 04 b8 a5 8c 01 00 00 00 03 00 00 00                                                              ............

dhcp discover response with patch reverted (ok):

virtio_net virtio0 eth0: __udp4_lib_rcv: data 0x8ca4ca44 head 0x8ca4ca00 tail 0x8ca4cb00 len 556 datalen 368 caller ip_protocol_deliver_rcu+0xac/0x178
                                                              ^^^^^^^^^^      ^^^^^^^^^^                 ^^^
00000000: 4c bd ab 8c 00 00 00 00 00 00 00 00 20 2e 85 7b 34 00 e0 7b 08 00 00 00 00 00 00 00 00 00 00 00  L........... ..{4..{............
00000020: 40 9a ff ff ff ff ff ff 52 55 0a 00 02 02 08 00 45 10 02 40 00 00 00 00 40 11 6c 9c 0a 00 02 02  @.......RU......E..@....@.l.....
                                                                ^^^^^ ip length (576)
00000040: ff ff ff ff 00 43 00 44 02 2c 06 18 02 01 06 00 e6 fd ce 5b 00 00 00 00 00 00 00 00 0a 00 02 0f  .....C.D.,.........[............
                      ^^ udp header
                                  ^^^^^ UDP length (556)
                                              ^^ start of UDP data
00000060: 0a 00 02 02 00 00 00 00 52 54 00 12 34 56 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ........RT..4V..................
00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
00000100: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00  ................................
00000120: b8 00 00 00 00 4d f9 8f 70 01 00 00 ea 00 00 00 50 e5 74 64 88 e0 0a 00 88 e0 4a 00 88 e0 4a 00  .....M..p.......P.td......J...J.
00000140: 2c 00 00 00 2c 00 00 00 04 00 00 00 04 00 00 00 51 e5 74 64 00 00 00 00 00 00 00 00 00 00 00 00  ,...,...........Q.td............
00000160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
00000180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
000001e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
00000200: 00 00 00 00 00 00 00 00 06 00 01 00 54 cc a4 8c 08 00 00 00 02 00 00 00 00 00 00 00 01 00 00 00  ............T...................
00000220: 08 00 00 00 00 00 00 00 14 cd a4 8c                                                              ............
