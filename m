Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932A92AB488
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgKIKMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:12:45 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:53982 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:12:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEhrQpj_1604916760;
Received: from B-44NBMD6M-0121.local(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0UEhrQpj_1604916760)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Nov 2020 18:12:40 +0800
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
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
Message-ID: <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com>
Date:   Mon, 9 Nov 2020 18:12:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CANn89iKiNdtxaL_yMF6=_8=m001vXVaxvECMGbAiXTYZjfj3oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/11/9 下午5:56, Eric Dumazet 写道:
> On Mon, Nov 9, 2020 at 10:33 AM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
>>
>> When net.ipv4.tcp_syncookies=1 and syn flood is happened,
>> cookie_v4_check or cookie_v6_check tries to redo what
>> tcp_v4_send_synack or tcp_v6_send_synack did,
>> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
>> which will make rcv_wscale is different, the client
>> still operates with initial window scale and can overshot
>> granted window, the client use the initial scale but local
>> server use new scale to advertise window value, and session
>> work abnormally.
> 
> What is not working exactly ?
> 
> Sending a 'big wscale' should not really matter, unless perhaps there
> is a buggy stack at the remote end ?
1)in tcp_v4_send_synack, if SO_RCVBUF is set and 
tcp_full_space(sk)=65535, pass req->rsk_window_clamp=65535 to 
tcp_select_initial_window, rcv_wscale will be zero, and send to client, 
the client consider wscale is 0;
2)when ack is back from client, if there is no this patch, 
req->rsk_window_clamp is 0, and pass to tcp_select_initial_window, 
wscale will be 7, this new rcv_wscale is no way to advertise to client.
3)if server send rcv_wind to client with window=63, it consider the real
window is 63*2^7=8064, but client consider the server window is only 
63*2^0=63, it can't send big packet to server, and the send-q of client
is full.


> 
>>
>> Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
>> ---
>>   v2: fix for ipv6.
>>   net/ipv4/syncookies.c | 4 ++++
>>   net/ipv6/syncookies.c | 5 +++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
>> index 6ac473b..57ce317 100644
>> --- a/net/ipv4/syncookies.c
>> +++ b/net/ipv4/syncookies.c
>> @@ -427,6 +427,10 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
>>
>>          /* Try to redo what tcp_v4_send_synack did. */
>>          req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
>> +       /* limit the window selection if the user enforce a smaller rx buffer */
>> +       if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
>> +           (req->rsk_window_clamp > tcp_full_space(sk) || req->rsk_window_clamp == 0))
>> +               req->rsk_window_clamp = tcp_full_space(sk);
> 
> This seems not needed to me.
> 
> We call tcp_select_initial_window() with tcp_full_space(sk) passed as
> the 2nd parameter.
> 
> tcp_full_space(sk) will then apply :
> 
> space = min(*window_clamp, space);

if cookie_v4_check pass window_clamp=0 to tcp_select_initial_window, it 
will set window_clamp to max value.
(*window_clamp) = (U16_MAX << TCP_MAX_WSCALE);

but space will fetch from sysctl_rmem_max and sysctl_tcp_rmem[2] which 
is also big value.
space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
space = max_t(u32, space, sysctl_rmem_max);

Then,space = min(*window_clamp, space) is a big value, lead wscale to 7,
is different from tcp_v4_send_synack.


> 
> Please cook a packetdrill test to demonstrate what you are seeing ?
> 
I have real environment and reproduce this case, this patch can fix 
that, i will try to use packetdrill with syn cookies and syn flood happen.

