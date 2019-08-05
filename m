Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57841810D7
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 06:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfHEEUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 00:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfHEEUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 00:20:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E8B5A3EB3;
        Mon,  5 Aug 2019 04:20:53 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 870955D9E2;
        Mon,  5 Aug 2019 04:20:47 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com> <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <11b2a930-eae4-522c-4132-3f8a2da05666@redhat.com>
Date:   Mon, 5 Aug 2019 12:20:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802124613.GA11245@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 05 Aug 2019 04:20:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/2 下午8:46, Jason Gunthorpe wrote:
> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>>> This must be a proper barrier, like a spinlock, mutex, or
>>> synchronize_rcu.
>>
>> I start with synchronize_rcu() but both you and Michael raise some
>> concern.
> I've also idly wondered if calling synchronize_rcu() under the various
> mm locks is a deadlock situation.


Maybe, that's why I suggest to use vhost_work_flush() which is much 
lightweight can can achieve the same function. It can guarantee all 
previous work has been processed after vhost_work_flush() return.


>
>> Then I try spinlock and mutex:
>>
>> 1) spinlock: add lots of overhead on datapath, this leads 0 performance
>> improvement.
> I think the topic here is correctness not performance improvement


But the whole series is to speed up vhost.


>
>> 2) SRCU: full memory barrier requires on srcu_read_lock(), which still leads
>> little performance improvement
>   
>> 3) mutex: a possible issue is need to wait for the page to be swapped in (is
>> this unacceptable ?), another issue is that we need hold vq lock during
>> range overlap check.
> I have a feeling that mmu notififers cannot safely become dependent on
> progress of swap without causing deadlock. You probably should avoid
> this.


Yes, so that's why I try to synchronize the critical region by myself.


>>> And, again, you can't re-invent a spinlock with open coding and get
>>> something better.
>> So the question is if waiting for swap is considered to be unsuitable for
>> MMU notifiers. If not, it would simplify codes. If not, we still need to
>> figure out a possible solution.
>>
>> Btw, I come up another idea, that is to disable preemption when vhost thread
>> need to access the memory. Then register preempt notifier and if vhost
>> thread is preempted, we're sure no one will access the memory and can do the
>> cleanup.
> I think you should use the spinlock so at least the code is obviously
> functionally correct and worry about designing some properly justified
> performance change after.
>
> Jason


Spinlock is correct but make the whole series meaningless consider it 
won't bring any performance improvement.

Thanks


