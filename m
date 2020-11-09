Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B70B2AC0D6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgKIQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:26:46 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45871 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729791AbgKIQ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:26:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEmInaP_1604939200;
Received: from B-44NBMD6M-0121.local(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEmInaP_1604939200)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 00:26:40 +0800
Subject: Re: [PATCH net v2] net: Update window_clamp if SOCK_RCVBUF is set
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
 <1604914417-24578-1-git-send-email-wenan.mao@linux.alibaba.com>
 <CANn89iKiNdtxaL_yMF6=_8=m001vXVaxvECMGbAiXTYZjfj3oQ@mail.gmail.com>
 <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com>
 <CANn89i+oS75TVKBDOBrr7Ff55Uctq4_HUcM_05Ed8kUL1HkHLw@mail.gmail.com>
 <CANn89iJ5kuEfKAJoWxM9MWV5X6nHXzbtcBkh1OBTak-Y6SzbPQ@mail.gmail.com>
 <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
Message-ID: <302ad089-9e82-1856-0652-b92251c14e37@linux.alibaba.com>
Date:   Tue, 10 Nov 2020 00:26:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/11/9 下午10:01, Eric Dumazet 写道:
> On Mon, Nov 9, 2020 at 12:41 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> Packetdrill test would be :
>>
>> // Force syncookies
>> `sysctl -q net.ipv4.tcp_syncookies=2`
>>
>>      0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>>     +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>>     +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [2048], 4) = 0
>>     +0 bind(3, ..., ...) = 0
>>     +0 listen(3, 1) = 0
>>
>> +0 < S 0:0(0) win 32792 <mss 1000,sackOK,TS val 100 ecr 0,nop,wscale 7>
>>     +0 > S. 0:0(0) ack 1 <mss 1460,sackOK,TS val 4000 ecr 100,nop,wscale 0>
>>    +.1 < . 1:1(0) ack 1 win 1024 <nop,nop,TS val 200 ecr 4000>
>>     +0 accept(3, ..., ...) = 4
>> +0 %{ assert tcpi_snd_wscale == 0, tcpi_snd_wscale }%
>>
> 
> Also, please add to your next submission an appropriate Fixes: tag :
> 
> Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's
> rcv-buffer via setsockopt")

OK, thanks, I can reproduce wscale=0 with your packetdrill, and I will 
send v3 with the fixes tag.

> 
>> On Mon, Nov 9, 2020 at 12:02 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>> On Mon, Nov 9, 2020 at 11:12 AM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> 在 2020/11/9 下午5:56, Eric Dumazet 写道:
>>>>> On Mon, Nov 9, 2020 at 10:33 AM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
>>>>>>
>>>>>> When net.ipv4.tcp_syncookies=1 and syn flood is happened,
>>>>>> cookie_v4_check or cookie_v6_check tries to redo what
>>>>>> tcp_v4_send_synack or tcp_v6_send_synack did,
>>>>>> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
>>>>>> which will make rcv_wscale is different, the client
>>>>>> still operates with initial window scale and can overshot
>>>>>> granted window, the client use the initial scale but local
>>>>>> server use new scale to advertise window value, and session
>>>>>> work abnormally.
>>>>>
>>>>> What is not working exactly ?
>>>>>
>>>>> Sending a 'big wscale' should not really matter, unless perhaps there
>>>>> is a buggy stack at the remote end ?
>>>> 1)in tcp_v4_send_synack, if SO_RCVBUF is set and
>>>> tcp_full_space(sk)=65535, pass req->rsk_window_clamp=65535 to
>>>> tcp_select_initial_window, rcv_wscale will be zero, and send to client,
>>>> the client consider wscale is 0;
>>>> 2)when ack is back from client, if there is no this patch,
>>>> req->rsk_window_clamp is 0, and pass to tcp_select_initial_window,
>>>> wscale will be 7, this new rcv_wscale is no way to advertise to client.
>>>> 3)if server send rcv_wind to client with window=63, it consider the real
>>>> window is 63*2^7=8064, but client consider the server window is only
>>>> 63*2^0=63, it can't send big packet to server, and the send-q of client
>>>> is full.
>>>>
>>>
>>> I see, please change your patches so that tcp_full_space() is used _once_
>>>
>>> listener sk_rcvbuf can change under us.
>>>
>>> I really have no idea how window can be set to 63, so please send us
>>> the packetdrill test once you have it.
