Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FEA21BCAF
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGJSBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:01:15 -0400
Received: from out0-152.mail.aliyun.com ([140.205.0.152]:48495 "EHLO
        out0-152.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgGJSBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594404072; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=z5WgytqEuc4UcApXyhbv53Mgv61GhtsS8X7NVLViF+Y=;
        b=qWHy9CVGBqiuN/I6K7p8Ec6/nqgqcsYB08hEUL64+678q3M7he2WNJdJaJsKj4KRCEo6SAqXnABnvA2YMGhRQgpx37DJJCNsrosiuKSTKnkyyfaIhey39yjI6F+6IIf0Ez6Z4bWDD/T1UWC3k4v6EifyQSBsHgUIgGcDbbmb4Cc=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03305;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I.im52w_1594404070;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I.im52w_1594404070)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Jul 2020 02:01:11 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
 <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
 <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
 <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
 <CAM_iQpWAHdws4Zu=qD1g5E3tOShefQwK8Mbf9YNCiR2OvHA-Kw@mail.gmail.com>
 <f26ce874-dd33-5283-62ff-334c0c611d09@alibaba-inc.com>
 <CAM_iQpXjTO7T_i-9tPw_xtwc3G91GDVHF_xc=J3xN+2dU+-F_Q@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <5b02a8df-406a-06c2-3057-d4408ef51057@alibaba-inc.com>
Date:   Sat, 11 Jul 2020 02:01:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXjTO7T_i-9tPw_xtwc3G91GDVHF_xc=J3xN+2dU+-F_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 11:21 PM, Cong Wang wrote:
> On Thu, Jul 9, 2020 at 11:07 PM YU, Xiangning
> <xiangning.yu@alibaba-inc.com> wrote:
>>
>>
>> On 7/9/20 10:20 PM, Cong Wang wrote:
>>> On Thu, Jul 9, 2020 at 10:04 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>> IOW, without these *additional* efforts, it is broken in terms of
>>>> out-of-order.
>>>>
>>>
>>> Take a look at fq_codel, it provides a hash function for flow classification,
>>> fq_codel_hash(), as default, thus its default configuration does not
>>> have such issues. So, you probably want to provide such a hash
>>> function too instead of a default class.
>>>
>> If I understand this code correctly, this socket hash value identifies a flow. Essentially it serves the same purpose as socket priority. In this patch, we use a similar classification method like htb, but without filters.
> 
> How is it any similar to HTB? HTB does not have a per-cpu queue
> for each class. This is a huge difference.

I said 'similar classification method like htb'. Not similar to HTB in overall design. :)
 
> 
>>
>> We could provide a hash function, but I'm a bit confused about the problem we are trying to solve.
> 
> Probably more than that, you need to ensure the packets in a same flow
> are queued on the same queue.
> 
> Let say you have two packets P1 and P2 from the same flow (P1 is before P2),
> you can classify them into the same class of course, but with per-cpu queues
> they can be sent out in a wrong order too:
> 
> send(P1) on CPU1 -> classify() returns default class -> P1 is queued on
> the CPU1 queue of default class
> 
> (Now process is migrated to CPU2)
> 
> send(P2) on CPU2 -> classify() returns default class -> P2 is queued on
> the CPU2 queue of default class
> 
> P2 is dequeued on CPU2 before P1 dequeued on CPU1.
> 
> Now, out of order. :)
> 
> Hope it is clear now.

The assumption is that packet scheduler is faster than thread migration. If we constantly take that long to send one packet, we need to fix it.

Under light load, CPU1 is free enough to immediately trigger aggregation. Under heavy load, some other CPU could also help trigger aggregation in between.

As I responded in my first email, this is possible in theory. We are running a much lower kernel version, and the normal case is to have multiple flows/threads running in a large class, so far haven't seen big trouble with this approach.

But it's been years, if the above assumption changes, we do need to rethink about it.

Thanks,
- Xiangning
> 
> Thanks.
> 
