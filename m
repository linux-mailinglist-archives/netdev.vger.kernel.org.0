Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D126C2255A4
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgGTBzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:55:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726468AbgGTBzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:55:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 42F5A7AA4415AC5604F1;
        Mon, 20 Jul 2020 09:55:04 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:54:54 +0800
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
 <0694e7d6-6cb2-d515-0bca-0ae4a3f68dc5@huawei.com>
 <CADVnQymfO7EDqUvhtE=n=AGmND1ajfUPzcPLR6wB7PBVzYRSZA@mail.gmail.com>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <79e3e009-3e34-3fb7-3b55-23819e3696b5@huawei.com>
Date:   Mon, 20 Jul 2020 09:54:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CADVnQymfO7EDqUvhtE=n=AGmND1ajfUPzcPLR6wB7PBVzYRSZA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.32]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/19 11:29, Neal Cardwell wrote:
> On Sat, Jul 18, 2020 at 6:43 AM hujunwei <hujunwei4@huawei.com> wrote:
>>
>>
>> On 2020/7/17 22:44, Neal Cardwell wrote:
>>> On Fri, Jul 17, 2020 at 7:43 AM hujunwei <hujunwei4@huawei.com> wrote:
>>>>
>>>> From: Junwei Hu <hujunwei4@huawei.com>
>>>>
>>>> In the document of RFC2582(https://tools.ietf.org/html/rfc2582)
>>>> introduced two separate scenarios for tcp congestion control:
>>>
>>> Can you please elaborate on how the sender is able to distinguish
>>> between the two scenarios, after your patch?
>>>
>>> It seems to me that with this proposed patch, there is the risk of
>>> spurious fast recoveries due to 3 dupacks in the second second
>>> scenario (the sender unnecessarily retransmitted three packets below
>>> "send_high"). Can you please post a packetdrill test to demonstrate
>>> that with this patch the TCP sender does not spuriously enter fast
>>> recovery in such a scenario?
>>>
>> Hi neal,
>> Thanks for you quick reply!
>> What I want to says is when these three numbers: snd_una, high_seq and
>> snd_nxt are the same, that means all data outstanding
>> when the Loss state began have successfully been acknowledged.
> 
> Yes, that seems true.
> 
>> So the sender is time to exits to the Open state.
>> I'm not sure whether my understanding is correct.
> 
> I don't think we want the sender to exit to the CA_Open state in these
> circumstances. I think section 5 ("Avoiding Multiple Fast
> Retransmits") of RFC 2582 states convincingly that senders should take
> steps to avoid having duplicate acknowledgements at high_seq trigger a
> new fast recovery. The Linux TCP implements those steps by *not*
> exiting to the Open state, and instead staying in CA_Loss or
> CA_RecoverThanks neal,
After reading the section 5 of RFC 2582, I think you are right.

> 
> To make things more concrete, here is the kind of timeline/scenario I
> am concerned about with your proposed patch. I have not had cycles to
> cook a packetdrill test like this, but this is the basic idea:
> 
> [connection does not have SACK or TCP timestamps enabled]
> app writes 4*SMSS
> Send packets P1, P2, P3, P4
> TLP, spurious retransmit of P4
> spurious RTO, set cwnd to 1, enter CA_Loss, retransmit P1
> receive ACK for P1 (original copy)
> slow-start, increase cwnd to 2, retransmit P2, P3
> receive ACK for P2 (original copy)
> slow-start, increase cwnd to 3, retransmit P4
> receive ACK for P3 (original copy)
> slow-start, increase cwnd to 4
> receive ACK for P4 (original copy)
> slow-start, increase cwnd to 5
> [with your patch, at this point the sender does not meet the
>  conditions for "Hold old state until something *above* high_seq is ACKed.",
>  so sender exits CA_Loss and enters Open]
> app writes 4*MSS
> send P5, P6, P7, P8
> receive dupack for P4 (due to spurious TLP retransmit of P4)
> receive dupack for P4 (due to spurious CA_Loss retransmit of P1)
> receive dupack for P4 (due to spurious CA_Loss retransmit of P2)
> [with your patch, at this point we risk spuriously entering
>  fast recovery because we have  received 3 duplicate ACKs for P4]
> 
> A packetdrill test that shows that this is not the behavior of your
> proposed patch would help support your proposed patch (presuming > is
> replaced by after()).
> 
> best,
> neal

Thank you for your detailed answer, I felt that I learned a lot.

Regards Junwei

