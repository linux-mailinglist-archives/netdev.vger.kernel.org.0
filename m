Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA76F2C390B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKYGWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:22:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgKYGWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 01:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606285331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mSLDibXdDhyTDavCf11nSYFrrSbOyY/Z0MxYwfAK1NU=;
        b=d+d1VFAEv/L148ZtiOn+bciJVCDjFlqZjv8sG5do+OSMAknfkC8w3+dey8fQDV+doAjeBt
        eDNrD4bIcWnt7sjnBBHL6z2WfCeYHLvuXlMaLJAIBAeCb5QtoN/+DR89TRAAIsq7OQAsAL
        2U2OdG03IX3Ck+7d4ZQKP6Zi4RubeqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-caX8nhwhOEiiRcw5KnoPAQ-1; Wed, 25 Nov 2020 01:22:06 -0500
X-MC-Unique: caX8nhwhOEiiRcw5KnoPAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C346E8A2A22;
        Wed, 25 Nov 2020 06:21:44 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D6485B4AE;
        Wed, 25 Nov 2020 06:21:13 +0000 (UTC)
Subject: Re: netconsole deadlock with virtnet
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Leon Romanovsky <leon@kernel.org>,
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
 <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
 <20201124082035.3e658fa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6e55048e-53ed-c196-729d-f7a5ab3c82fe@redhat.com>
Date:   Wed, 25 Nov 2020 14:21:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201124082035.3e658fa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/25 上午12:20, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 11:22:03 +0800 Jason Wang wrote:
>>>> Perhaps you need the trylock in virtnet_poll_tx()?
>>> That could work. Best if we used normal lock if !!budget, and trylock
>>> when budget is 0. But maybe that's too hairy.
>> If we use trylock, we probably lose(or delay) tx notification that may
>> have side effects to the stack.
> That's why I said only trylock with budget == 0. Only netpoll calls with
> budget == 0, AFAIK.


Oh right.

So I think maybe we can switch to use trylock when budget is zero and 
try to schedule another TX NAPI if we trylock fail.


>
>>> I'm assuming all this trickiness comes from virtqueue_get_buf() needing
>>> locking vs the TX path? It's pretty unusual for the completion path to
>>> need locking vs xmit path.
>> Two reasons for doing this:
>>
>> 1) For some historical reason, we try to free transmitted tx packets in
>> xmit (see free_old_xmit_skbs() in start_xmit()), we can probably remove
>> this if we remove the non tx interrupt mode.
>> 2) virtio core requires virtqueue_get_buf() to be synchronized with
>> virtqueue_add(), we probably can solve this but it requires some non
>> trivial refactoring in the virtio core
>>
>> Btw, have a quick search, there are several other drivers that uses tx
>> lock in the tx NAPI.
> Unless they do:
>
> 	netdev->priv_flags |= IFF_DISABLE_NETPOLL;
>
> they are all broken.


Yes.

Thanks

