Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F508111C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 06:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfHEEjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 00:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfHEEjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 00:39:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D37428110A;
        Mon,  5 Aug 2019 04:39:40 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34BC819C59;
        Mon,  5 Aug 2019 04:39:35 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
 <20190804001400.GA25543@ziepe.ca>
 <20190804040034-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8e0812e4-f618-8a9c-38ce-d45f6c897c52@redhat.com>
Date:   Mon, 5 Aug 2019 12:39:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190804040034-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 05 Aug 2019 04:39:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/4 下午4:07, Michael S. Tsirkin wrote:
> On Sat, Aug 03, 2019 at 09:14:00PM -0300, Jason Gunthorpe wrote:
>> On Sat, Aug 03, 2019 at 05:36:13PM -0400, Michael S. Tsirkin wrote:
>>> On Fri, Aug 02, 2019 at 02:24:18PM -0300, Jason Gunthorpe wrote:
>>>> On Fri, Aug 02, 2019 at 10:27:21AM -0400, Michael S. Tsirkin wrote:
>>>>> On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
>>>>>> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>>>>>>>> This must be a proper barrier, like a spinlock, mutex, or
>>>>>>>> synchronize_rcu.
>>>>>>>
>>>>>>> I start with synchronize_rcu() but both you and Michael raise some
>>>>>>> concern.
>>>>>> I've also idly wondered if calling synchronize_rcu() under the various
>>>>>> mm locks is a deadlock situation.
>>>>>>
>>>>>>> Then I try spinlock and mutex:
>>>>>>>
>>>>>>> 1) spinlock: add lots of overhead on datapath, this leads 0 performance
>>>>>>> improvement.
>>>>>> I think the topic here is correctness not performance improvement
>>>>> The topic is whether we should revert
>>>>> commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")
>>>>>
>>>>> or keep it in. The only reason to keep it is performance.
>>>> Yikes, I'm not sure you can ever win against copy_from_user using
>>>> mmu_notifiers?
>>> Ever since copy_from_user started playing with flags (for SMAP) and
>>> added speculation barriers there's a chance we can win by accessing
>>> memory through the kernel address.
>> You think copy_to_user will be more expensive than the minimum two
>> atomics required to synchronize with another thread?
> I frankly don't know. With SMAP you flip flags twice, and with spectre
> you flush the pipeline. Is that cheaper or more expensive than an atomic
> operation? Testing is the only way to tell.


Let me test, I only did test on a non SMAP machine. Switching to 
spinlock kills all performance improvement.

Thanks


>
>>>> Also, why can't this just permanently GUP the pages? In fact, where
>>>> does it put_page them anyhow? Worrying that 7f466 adds a get_user page
>>>> but does not add a put_page??
>> You didn't answer this.. Why not just use GUP?
>>
>> Jason
> Sorry I misunderstood the question. Permanent GUP breaks lots of
> functionality we need such as THP and numa balancing.
>
> release_pages is used instead of put_page.
>
>
>
>
