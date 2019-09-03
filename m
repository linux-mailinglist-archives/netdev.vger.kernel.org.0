Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17855A646C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfICIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:55:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726946AbfICIzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 04:55:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9048D9AD3D7876E57CA4;
        Tue,  3 Sep 2019 16:55:43 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Sep 2019
 16:55:39 +0800
Subject: Re: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
To:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        <eric.dumazet@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "cpaasch@apple.com" <cpaasch@apple.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "aprout@ll.mit.edu" <aprout@ll.mit.edu>,
        "edumazet@google.com" <edumazet@google.com>,
        "jtl@netflix.com" <jtl@netflix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
 <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
 <20190830232657.GL45416@MacBook-Pro-64.local>
 <20190830.192049.1447010488040109227.davem@davemloft.net>
 <F95AC9340317A84688A5F0DF0246F3F21AAAA8E1@dggeml532-mbs.china.huawei.com>
 <CAOj+RUsqTUF9fuetskRRw26Z=sBM-mELSMcV21Ch06007aP5yQ@mail.gmail.com>
 <F95AC9340317A84688A5F0DF0246F3F21AAB8F82@dggeml512-mbx.china.huawei.com>
 <CAOj+RUvXMaoVKzSeDab4oTn3p=-BJtuhgqwKDCUuhCQWHO7bgQ@mail.gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <88936af6-4b98-c78f-930f-47e5d69c961d@huawei.com>
Date:   Tue, 3 Sep 2019 16:55:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <CAOj+RUvXMaoVKzSeDab4oTn3p=-BJtuhgqwKDCUuhCQWHO7bgQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/3 14:58, Tim Froidcoeur wrote:
> Hi,
> 
> I also tried to reproduce this in a targeted way, and run into the
> same difficulty as you: satisfying the first condition “
> (sk->sk_wmem_queued >> 1) > limit “.
> I will not have bandwidth the coming days to try and reproduce it in
> this way. Maybe simply forcing a very small send buffer using sysctl
> net.ipv4.tcp_wmem might even do the trick?
> 
> I suspect that the bug is easier to trigger with the MPTCP patch like
> I did originally, due to the way this patch manages the tcp subflow
> buffers (it can temporarily overfill the buffers, satisfying that
> first condition more often).
> 
> another thing, the stacktrace you shared before seems caused by
> another issue (corrupted socket?), it will not be solved by the patch
> we submitted.

The trace shows zero window probe message can be BUG_ON in skb_queue_prev,
this is reproduced on our platform with syzkaller. It can be resolved by
your fix patch.
The thing I need to think is why the first condition can be satisfied?
Eric, Do you have any comments to reproduce it as the first condition
is hard to be true?
(sk->sk_wmem_queued >> 1) > limit

> 
> kind regards,
> 
> Tim
> 
> 
> On Tue, Sep 3, 2019 at 5:22 AM maowenan <maowenan@huawei.com> wrote:
>>
>> Hi Tim,
>>
>>
>>
>> I try to reproduce it with packetdrill or user application, but I can’t.
>>
>> The first condition “ (sk->sk_wmem_queued >> 1) > limit “    can’t be satisfied,
>>
>> This condition is to avoid tiny SO_SNDBUF values set by user.
>>
>> It also adds the some room due to the fact that tcp_sendmsg()
>>
>> and tcp_sendpage() might overshoot sk_wmem_queued by about one full
>>
>> TSO skb (64KB size).
>>
>>
>>
>>         limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
>>
>>         if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
>>
>>                      skb != tcp_rtx_queue_head(sk) &&
>>
>>                      skb != tcp_rtx_queue_tail(sk))) {
>>
>>                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>>
>>                 return -ENOMEM;
>>
>>         }
>>
>>
>>
>> Can you try to reproduce it with packetdrill or C socket application?
>>
>>
> 
> 
> 

