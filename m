Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D52C2099
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgKXI5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:57:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730896AbgKXI5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:57:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606208258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJwIP3nSo2Uj/Swvhl1TAV1Y63wZ0HYh6rGKpKJBlYE=;
        b=eD7NCZxbmxC7qf1Spt8mQGCl/9DGZLhTvK8ATAzecjPZrCzPARWpVdKhumZXRYy1PiXatM
        fGtfS+4r7qKilSzBJJXNwxNeypoi7XUvmmhWwqt37b02icgYCcnyUaVqpJvznQMzL9v4z3
        ZnJZCj17+ff4vnnRQWhM1jl2YZL0gKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-AYv1W39-MCqm9Pn8IDBYPw-1; Tue, 24 Nov 2020 03:57:34 -0500
X-MC-Unique: AYv1W39-MCqm9Pn8IDBYPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8383A0BD4;
        Tue, 24 Nov 2020 08:57:31 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D64160C13;
        Tue, 24 Nov 2020 08:57:24 +0000 (UTC)
Subject: Re: netconsole deadlock with virtnet
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
References: <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
 <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
 <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
 <20201118091257.2ee6757a@gandalf.local.home> <20201123110855.GD3159@unreal>
 <20201123093128.701cf81b@gandalf.local.home>
 <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201123140934.38748be3@gandalf.local.home>
 <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
 <20201124080152.GG3159@unreal>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6f046c51-cdcc-77f9-4859-2508d08126f8@redhat.com>
Date:   Tue, 24 Nov 2020 16:57:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201124080152.GG3159@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/24 下午4:01, Leon Romanovsky wrote:
> On Tue, Nov 24, 2020 at 11:22:03AM +0800, Jason Wang wrote:
>> On 2020/11/24 上午3:21, Jakub Kicinski wrote:
>>> On Mon, 23 Nov 2020 14:09:34 -0500 Steven Rostedt wrote:
>>>> On Mon, 23 Nov 2020 10:52:52 -0800
>>>> Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>>> On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:
>>>>>> On Mon, 23 Nov 2020 13:08:55 +0200
>>>>>> Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>
>>>>>>>    [   10.028024] Chain exists of:
>>>>>>>    [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2
>>>>>> Note, the problem is that we have a location that grabs the xmit_lock while
>>>>>> holding target_list_lock (and possibly console_owner).
>>>>> Well, it try_locks the xmit_lock. Does lockdep understand try-locks?
>>>>>
>>>>> (not that I condone the shenanigans that are going on here)
>>>> Does it?
>>>>
>>>> 	virtnet_poll_tx() {
>>>> 		__netif_tx_lock() {
>>>> 			spin_lock(&txq->_xmit_lock);
>>> Umpf. Right. I was looking at virtnet_poll_cleantx()
>>>
>>>> That looks like we can have:
>>>>
>>>>
>>>> 	CPU0		CPU1
>>>> 	----		----
>>>>      lock(xmit_lock)
>>>>
>>>> 		    lock(console)
>>>> 		    lock(target_list_lock)
>>>> 		    __netif_tx_lock()
>>>> 		        lock(xmit_lock);
>>>>
>>>> 			[BLOCKED]
>>>>
>>>>      <interrupt>
>>>>      lock(console)
>>>>
>>>>      [BLOCKED]
>>>>
>>>>
>>>>
>>>>    DEADLOCK.
>>>>
>>>>
>>>> So where is the trylock here?
>>>>
>>>> Perhaps you need the trylock in virtnet_poll_tx()?
>>> That could work. Best if we used normal lock if !!budget, and trylock
>>> when budget is 0. But maybe that's too hairy.
>>
>> If we use trylock, we probably lose(or delay) tx notification that may have
>> side effects to the stack.
>>
>>
>>> I'm assuming all this trickiness comes from virtqueue_get_buf() needing
>>> locking vs the TX path? It's pretty unusual for the completion path to
>>> need locking vs xmit path.
>>
>> Two reasons for doing this:
>>
>> 1) For some historical reason, we try to free transmitted tx packets in xmit
>> (see free_old_xmit_skbs() in start_xmit()), we can probably remove this if
>> we remove the non tx interrupt mode.
>> 2) virtio core requires virtqueue_get_buf() to be synchronized with
>> virtqueue_add(), we probably can solve this but it requires some non trivial
>> refactoring in the virtio core
> So how will we solve our lockdep issues?
>
> Thanks


It's not clear to me that whether it's a virtio-net specific issue. E.g 
the above deadlock looks like a generic issue so workaround it via 
virtio-net may not help for other drivers.

Thanks


>
>> Btw, have a quick search, there are several other drivers that uses tx lock
>> in the tx NAPI.
>>
>> Thanks
>>

