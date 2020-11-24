Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC242C1BF6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 04:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgKXDWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 22:22:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbgKXDWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 22:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606188139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/cB4Y6zYi35tKuoN6G4/JIJq3FZA+1nclYd1TtN7K0=;
        b=g6B75bIaNbqnxqU1X6hesTkvX1oDJCteE61VEf//t0fdrzb86/81k43XCsCZUXVdmiyCgO
        fCBFWIkcB7daBI37eVS19/guWWPgYho46/Crw1hOZKfLPB+KYk27D7nYFuOufXue1ntSr4
        5DtM786PGjbxDzXg8fRWo1es1DDqzII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-4hhBCgcnN-6yIxgr9mr-og-1; Mon, 23 Nov 2020 22:22:14 -0500
X-MC-Unique: 4hhBCgcnN-6yIxgr9mr-og-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97F2110066FB;
        Tue, 24 Nov 2020 03:22:12 +0000 (UTC)
Received: from [10.72.13.198] (ovpn-13-198.pek2.redhat.com [10.72.13.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19D43620DE;
        Tue, 24 Nov 2020 03:22:04 +0000 (UTC)
Subject: Re: netconsole deadlock with virtnet
To:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
References: <20201117102341.GR47002@unreal>
 <20201117093325.78f1486d@gandalf.local.home>
 <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
 <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
 <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
 <20201118091257.2ee6757a@gandalf.local.home> <20201123110855.GD3159@unreal>
 <20201123093128.701cf81b@gandalf.local.home>
 <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201123140934.38748be3@gandalf.local.home>
 <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
Date:   Tue, 24 Nov 2020 11:22:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/24 上午3:21, Jakub Kicinski wrote:
> On Mon, 23 Nov 2020 14:09:34 -0500 Steven Rostedt wrote:
>> On Mon, 23 Nov 2020 10:52:52 -0800
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>
>>> On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:
>>>> On Mon, 23 Nov 2020 13:08:55 +0200
>>>> Leon Romanovsky <leon@kernel.org> wrote:
>>>>
>>>>      
>>>>>   [   10.028024] Chain exists of:
>>>>>   [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2
>>>> Note, the problem is that we have a location that grabs the xmit_lock while
>>>> holding target_list_lock (and possibly console_owner).
>>> Well, it try_locks the xmit_lock. Does lockdep understand try-locks?
>>>
>>> (not that I condone the shenanigans that are going on here)
>> Does it?
>>
>> 	virtnet_poll_tx() {
>> 		__netif_tx_lock() {
>> 			spin_lock(&txq->_xmit_lock);
> Umpf. Right. I was looking at virtnet_poll_cleantx()
>
>> That looks like we can have:
>>
>>
>> 	CPU0		CPU1
>> 	----		----
>>     lock(xmit_lock)
>>
>> 		    lock(console)
>> 		    lock(target_list_lock)
>> 		    __netif_tx_lock()
>> 		        lock(xmit_lock);
>>
>> 			[BLOCKED]
>>
>>     <interrupt>
>>     lock(console)
>>
>>     [BLOCKED]
>>
>>
>>
>>   DEADLOCK.
>>
>>
>> So where is the trylock here?
>>
>> Perhaps you need the trylock in virtnet_poll_tx()?
> That could work. Best if we used normal lock if !!budget, and trylock
> when budget is 0. But maybe that's too hairy.


If we use trylock, we probably lose(or delay) tx notification that may 
have side effects to the stack.


>
> I'm assuming all this trickiness comes from virtqueue_get_buf() needing
> locking vs the TX path? It's pretty unusual for the completion path to
> need locking vs xmit path.


Two reasons for doing this:

1) For some historical reason, we try to free transmitted tx packets in 
xmit (see free_old_xmit_skbs() in start_xmit()), we can probably remove 
this if we remove the non tx interrupt mode.
2) virtio core requires virtqueue_get_buf() to be synchronized with 
virtqueue_add(), we probably can solve this but it requires some non 
trivial refactoring in the virtio core

Btw, have a quick search, there are several other drivers that uses tx 
lock in the tx NAPI.

Thanks

>

