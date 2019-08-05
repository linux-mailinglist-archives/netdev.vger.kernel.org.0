Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE93C8110F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 06:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHEEdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 00:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbfHEEdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 00:33:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E5ED793C9;
        Mon,  5 Aug 2019 04:33:51 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D987960127;
        Mon,  5 Aug 2019 04:33:46 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com> <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802094331-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c3a0a1c-ce87-907b-7bc8-ec41bf9056d8@redhat.com>
Date:   Mon, 5 Aug 2019 12:33:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802094331-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 05 Aug 2019 04:33:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/2 下午10:03, Michael S. Tsirkin wrote:
> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>> Btw, I come up another idea, that is to disable preemption when vhost thread
>> need to access the memory. Then register preempt notifier and if vhost
>> thread is preempted, we're sure no one will access the memory and can do the
>> cleanup.
> Great, more notifiers :(
>
> Maybe can live with
> 1- disable preemption while using the cached pointer
> 2- teach vhost to recover from memory access failures,
>     by switching to regular from/to user path


I don't get this, I believe we want to recover from regular from/to user 
path, isn't it?


>
> So if you want to try that, fine since it's a step in
> the right direction.
>
> But I think fundamentally it's not what we want to do long term.


Yes.


>
> It's always been a fundamental problem with this patch series that only
> metadata is accessed through a direct pointer.
>
> The difference in ways you handle metadata and data is what is
> now coming and messing everything up.


I do propose soemthing like this in the past: 
https://www.spinics.net/lists/linux-virtualization/msg36824.html. But 
looks like you have some concern about its locality.

But the problem still there, GUP can do page fault, so still need to 
synchronize it with MMU notifiers. The solution might be something like 
moving GUP to a dedicated kind of vhost work.


>
> So if continuing the direct map approach,
> what is needed is a cache of mapped VM memory, then on a cache miss
> we'd queue work along the lines of 1-2 above.
>
> That's one direction to take. Another one is to give up on that and
> write our own version of uaccess macros.  Add a "high security" flag to
> the vhost module and if not active use these for userspace memory
> access.


Or using SET_BACKEND_FEATURES? But do you mean permanent GUP as I did in 
original RFC https://lkml.org/lkml/2018/12/13/218?

Thanks

>
>
