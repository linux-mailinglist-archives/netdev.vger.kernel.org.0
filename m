Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C52B844CE
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfHGGuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfHGGuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 02:50:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2729730DDBD8;
        Wed,  7 Aug 2019 06:50:03 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BBF825263;
        Wed,  7 Aug 2019 06:49:58 +0000 (UTC)
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
 <11b2a930-eae4-522c-4132-3f8a2da05666@redhat.com>
 <20190806120416.GB11627@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4b448aa5-2c92-a6ca-67d6-d30fad67254c@redhat.com>
Date:   Wed, 7 Aug 2019 14:49:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806120416.GB11627@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 07 Aug 2019 06:50:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/6 下午8:04, Jason Gunthorpe wrote:
> On Mon, Aug 05, 2019 at 12:20:45PM +0800, Jason Wang wrote:
>> On 2019/8/2 下午8:46, Jason Gunthorpe wrote:
>>> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>>>>> This must be a proper barrier, like a spinlock, mutex, or
>>>>> synchronize_rcu.
>>>> I start with synchronize_rcu() but both you and Michael raise some
>>>> concern.
>>> I've also idly wondered if calling synchronize_rcu() under the various
>>> mm locks is a deadlock situation.
>>
>> Maybe, that's why I suggest to use vhost_work_flush() which is much
>> lightweight can can achieve the same function. It can guarantee all previous
>> work has been processed after vhost_work_flush() return.
> If things are already running in a work, then yes, you can piggyback
> on the existing spinlocks inside the workqueue and be Ok
>
> However, if that work is doing any copy_from_user, then the flush
> becomes dependent on swap and it won't work again...


Yes it do copy_from_user(), so we can't do this.


>
>>>> 1) spinlock: add lots of overhead on datapath, this leads 0 performance
>>>> improvement.
>>> I think the topic here is correctness not performance improvement>
>   
>> But the whole series is to speed up vhost.
> So? Starting with a whole bunch of crazy, possibly broken, locking and
> claiming a performance win is not reasonable.


Yes, I admit this patch is tricky, I'm not going to push this. Will post 
a V3.


>
>> Spinlock is correct but make the whole series meaningless consider it won't
>> bring any performance improvement.
> You can't invent a faster spinlock by opencoding some wild
> scheme. There is nothing special about the usage here, it needs a
> blocking lock, plain and simple.
>
> Jason


Will post V3. Let's see if you are happy with that version.

Thanks


