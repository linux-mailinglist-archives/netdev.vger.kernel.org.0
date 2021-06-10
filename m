Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6307A3A242D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 08:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFJGC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 02:02:27 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56370 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJGC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 02:02:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UbwMPbj_1623304827;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UbwMPbj_1623304827)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 14:00:28 +0800
Subject: Re: [PATCH net-next] net: tcp: Updating MSS, when the sending window
 is smaller than MSS.
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
References: <1623058534-78782-1-git-send-email-chengshuyi@linux.alibaba.com>
 <CANn89iLNf+73MsPH7O7wX3PrN26FVLcjw_SmsN6jNwnjrYg4KQ@mail.gmail.com>
 <0e938649-986d-ce79-e3c4-1f29bdcb64e0@linux.alibaba.com>
 <CANn89iKnT5Ebk5vovFJKHY4Fe7ERkN3ak_Nkqyc=vXL=VWvyPg@mail.gmail.com>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <258e3c94-f479-509c-a4b0-5a881779dd14@linux.alibaba.com>
Date:   Thu, 10 Jun 2021 14:00:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKnT5Ebk5vovFJKHY4Fe7ERkN3ak_Nkqyc=vXL=VWvyPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/21 11:56 PM, Eric Dumazet wrote:
> On Tue, Jun 8, 2021 at 4:26 AM Shuyi Cheng <chengshuyi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 6/7/21 7:34 PM, Eric Dumazet wrote:
>>> On Mon, Jun 7, 2021 at 11:35 AM Shuyi Cheng
>>> <chengshuyi@linux.alibaba.com> wrote:
>>>>
>>>> When the lo network card is used for communication, the tcp server
>>>> reduces the size of the receiving buffer, causing the tcp client
>>>> to have a delay of 200ms. Examples are as follows:
>>>>
>>>> Suppose that the MTU of the lo network card is 65536, and the tcp server
>>>> sets the receive buffer size to 42KB. According to the
>>>> tcp_bound_to_half_wnd function, the MSS of the server and client is
>>>> 21KB. Then, the tcp server sets the buffer size of the connection to
>>>> 16KB. At this time, the MSS of the server is 8KB, and the MSS of the
>>>> client is still 21KB. But it will cause the client to fail to send the
>>>> message, that is, tcp_write_xmit fails. Mainly because tcp_snd_wnd_test
>>>> failed, and then entered the zero window detection phase, resulting in a
>>>> 200ms delay.
>>>>
>>>> Therefore, we mainly modify two places. One is the tcp_current_mss
>>>> function. When the sending window is smaller than the current mss, mss
>>>> needs to be updated. The other is the tcp_bound_to_half_wnd function.
>>>> When the sending window is smaller than the current mss, the mss value
>>>> should be calculated according to the current sending window, not
>>>> max_window.
>>>>
>>>> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
>>>> ---
>>>>    include/net/tcp.h     | 11 ++++++++---
>>>>    net/ipv4/tcp_output.c |  3 ++-
>>>>    2 files changed, 10 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>>>> index e668f1b..fcdef16 100644
>>>> --- a/include/net/tcp.h
>>>> +++ b/include/net/tcp.h
>>>> @@ -641,6 +641,11 @@ static inline void tcp_clear_xmit_timers(struct sock *sk)
>>>>    static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
>>>>    {
>>>>           int cutoff;
>>>> +       int window;
>>>> +
>>>> +       window = tp->max_window;
>>>> +       if (tp->snd_wnd && tp->snd_wnd < pktsize)
>>>> +               window = tp->snd_wnd;
>>>>
>>>>           /* When peer uses tiny windows, there is no use in packetizing
>>>>            * to sub-MSS pieces for the sake of SWS or making sure there
>>>> @@ -649,10 +654,10 @@ static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
>>>>            * On the other hand, for extremely large MSS devices, handling
>>>>            * smaller than MSS windows in this way does make sense.
>>>>            */
>>>> -       if (tp->max_window > TCP_MSS_DEFAULT)
>>>> -               cutoff = (tp->max_window >> 1);
>>>> +       if (window > TCP_MSS_DEFAULT)
>>>> +               cutoff = (window >> 1);
>>>>           else
>>>> -               cutoff = tp->max_window;
>>>> +               cutoff = window;
>>>>
>>>>           if (cutoff && pktsize > cutoff)
>>>>                   return max_t(int, cutoff, 68U - tp->tcp_header_len);
>>>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>>> index bde781f..88dcdf2 100644
>>>> --- a/net/ipv4/tcp_output.c
>>>> +++ b/net/ipv4/tcp_output.c
>>>> @@ -1833,7 +1833,8 @@ unsigned int tcp_current_mss(struct sock *sk)
>>>>
>>>>           if (dst) {
>>>>                   u32 mtu = dst_mtu(dst);
>>>> -               if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
>>>> +               if (mtu != inet_csk(sk)->icsk_pmtu_cookie ||
>>>> +                   (tp->snd_wnd && tp->snd_wnd < mss_now))
>>>>                           mss_now = tcp_sync_mss(sk, mtu);
>>>
>>>
>>> I do not think we want to add code in fast path only to cope with
>>> pathological user choices.
>>>
>>
>> Thank you very much for your reply!
>>
>> I very much agree with your point of view. However, the kernel currently
>> accepts the unreasonable RCVBUF set by the developer, that is, the set
>> RCVBUF is smaller than MSS. Perhaps, we can avoid setting RCVBUF to be
>> smaller than MSS in the sock_setsockopt function. What do you think?
> 
> I think this is not trivial to make the limit being MSS dependent,
> because SO_RCVBUF can be set before connection is attempted.
> (So the MSS is not yet known)
>

Thank you very much for your reply!

Maybe it's not clear enough that I described it. The scenario where the 
above problem occurs is precisely because the tcp server sets the size 
of RCVBUFF to be smaller after the connection is established. Here is a 
sample code that caused the problem.

# default tcp_rmem is 87380
tcpServerSocket= socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpServerSocket.bind(server_addr)
tcpServerSocket.listen()
while True:
     connection,client_addr = tcpServerSocket.accept()
     # Shrink rmem
     connection.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 16*1024)

Therefore, when the developer calls the sock_setsockopt function to 
reset RCVBUF, we can use sock to determine the TCP state. When in the 
connected state, it is not allowed to set RCVBUF smaller than mss.

Thanks.


> I would rather simply add a sysctl to set a floor for TCP SO_RCVBUF,
> and default it to a reasonable value (128KB ?)
> 
> The sysctl might be needed for some crazy environments (one million
> TCP flows on a host with only 8 GB of memory for example...)
> 
>>
>> Thanks.
>>
>>> Maybe it is time to accept the fact that setting the receive buffer
>>> size to 42KB is dumb nowadays.
>>>
>>> TCP needs to have at least two buffers in flight to avoid 'strange' stalls.
>>>
>>> If loopback MTU is 64KB  (and TSO/GRO sizes also can reach 64K), maybe
>>> we need to ensure a minimal rcvbuf.
>>>
>>> If applications set 42KB window size, they get what they asked for :
>>> damn slow TCP communications.
>>>
>>> We do not want to make them happy, while increasing cpu costs for 99%
>>> of other uses cases which are not trying to make TCP miserable.
>>>
>>> I would rather add a sysctl or something to ensure rcvbuf has a
>>> minimal sane value, instead of risking subtle TCP regressions.
>>>
>>> In 2021, we should not limit ourselves to memory constraints that were
>>> common 40 years ago when TCP was invented.
>>>
>>> References :
>>> commit 9eb5bf838d06aa6ddebe4aca6b5cedcf2eb53b86 net: sock: fix
>>> TCP_SKB_MIN_TRUESIZE
>>> commit eea86af6b1e18d6fa8dc959e3ddc0100f27aff9f net: sock: adapt
>>> SOCK_MIN_RCVBUF and SOCK_MIN_SNDBUF
>>>
