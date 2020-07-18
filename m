Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460B4224AB7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgGRKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:43:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51466 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbgGRKne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 06:43:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BBB4286EE2B8DA1DFB5D;
        Sat, 18 Jul 2020 18:43:31 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 18:43:25 +0800
Subject: Re: [PATCH net-next] tcp: Optimize the recovery of tcp when lack of
 SACK
To:     Neal Cardwell <ncardwell@google.com>
CC:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, <wangxiaogang3@huawei.com>,
        <jinyiting@huawei.com>, <xuhanbing@huawei.com>,
        <zhengshaoyu@huawei.com>, Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@cs.helsinki.fi>
References: <66945532-2470-4240-b213-bc36791b934b@huawei.com>
 <CADVnQyksf4Nt2hHsWaAs3wLOK+rDp79ph5TZywMqfEAPOVgzww@mail.gmail.com>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <0694e7d6-6cb2-d515-0bca-0ae4a3f68dc5@huawei.com>
Date:   Sat, 18 Jul 2020 18:43:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CADVnQyksf4Nt2hHsWaAs3wLOK+rDp79ph5TZywMqfEAPOVgzww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.32]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/17 22:44, Neal Cardwell wrote:
> On Fri, Jul 17, 2020 at 7:43 AM hujunwei <hujunwei4@huawei.com> wrote:
>>
>> From: Junwei Hu <hujunwei4@huawei.com>
>>
>> In the document of RFC2582(https://tools.ietf.org/html/rfc2582)
>> introduced two separate scenarios for tcp congestion control:
> 
> Can you please elaborate on how the sender is able to distinguish
> between the two scenarios, after your patch?
> 
> It seems to me that with this proposed patch, there is the risk of
> spurious fast recoveries due to 3 dupacks in the second second
> scenario (the sender unnecessarily retransmitted three packets below
> "send_high"). Can you please post a packetdrill test to demonstrate
> that with this patch the TCP sender does not spuriously enter fast
> recovery in such a scenario?
> 
Hi neal,
Thanks for you quick reply!
What I want to says is when these three numbers: snd_una, high_seq and
snd_nxt are the same, that means all data outstanding
when the Loss state began have successfully been acknowledged.
So the sender is time to exits to the Open state.
I'm not sure whether my understanding is correct.

>> This patch enhance the TCP congestion control algorithm for lack
>> of SACK.
> 
> You describe this as an enhancement. Can you please elaborate on the
> drawback/downside of staying in CA_Loss in this case you are
> describing (where you used kprobes to find that TCP stayed in CA_Loss
> state when high_seq was equal to snd_nxt)?
> 
I tried, but I can't reproduce it by packetdrill. This problem appeared
in our production environment. Here is part of the trace message:

First ack:
#tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
	packets_out=4 retrans_out=1 sacked_out=0 lost_out=4 snd_nxt=3427491485
	snd_una=3427485917 high_seq=3427491485 reordering=1 mss_cache=1392
	icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=1

#tcp_fastretrans_alert: (tcp_fastretrans_alert+0x0/0x7b0) prior_snd_una=3427485917
	num_dupack=0 packets_out=0 retrans_out=0 sacked_out=0 lost_out=0
	snd_nxt=3427491485 snd_una=3427491485 high_seq=3427491485 reordering=1
	mss_cache=1392 icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=1

As we can see by func tcp_fastretrans_alert icsk_ca_state remains CA_Loss (4),
and the numbers: snd_nxt, snd_una and high_seq are the same.

first dup ack:
#tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
	packets_out=2 retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427494269
	snd_una=3427491485 high_seq=3427491485 reordering=1 mss_cache=1392
	icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=2

#tcp_fastretrans_alert: (tcp_fastretrans_alert+0x0/0x7b0) num_dupack=1 packets_out=2
	retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427494269 snd_una=3427491485
	high_seq=3427491485 reordering=1 icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=2

second dup ack:
#tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
	packets_out=4 retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427497053
	snd_una=3427491485 high_seq=3427491485 reordering=1 mss_cache=1392
	icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=4

So, I really hope someone can answer whether my understanding is correct.

> To deal with sequence number wrap-around, sequence number comparisons
> in TCP need to use the before() and after() helpers, rather than
> comparison operators. Here it seems the patch should use after()
> rather than >. However,  I think the larger concern is the concern
> mentioned above.
> 
If this patch is useful, I will modify this.

Regards Junwei

