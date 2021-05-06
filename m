Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F1F374DEB
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 05:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhEFDYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 23:24:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhEFDYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 23:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620271424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tRwXkOR/k+ENBKPwJaIaNJZfD4OuzxyeOruC4qrPzjc=;
        b=K4XN1jthP3ELHnCbdk2fNCmGl37q/lqnrJAXYpwnO/M5kFAiR9FlrR5FWYsFFQNdThCkgG
        O024o42oudzaSlxNxQWOp+eMbpzLcMlgVsuRhrI08o5PsxJnn89oAJkjlHO6oSCCQs10rE
        cFaeWZZmcUtt4pz7KZl9XEnIJVJ6UNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-l9YlslM7PzO3CrdpIASveA-1; Wed, 05 May 2021 23:23:40 -0400
X-MC-Unique: l9YlslM7PzO3CrdpIASveA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1550C801B13;
        Thu,  6 May 2021 03:23:39 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 582185C3DF;
        Thu,  6 May 2021 03:23:34 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in
 skb_gro_receive
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
References: <1620030574.9881887-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <770ce8e6-4948-2977-4d63-7d82075e7fc8@redhat.com>
Date:   Thu, 6 May 2021 11:23:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1620030574.9881887-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/3 下午4:29, Xuan Zhuo 写道:
> On Mon, 3 May 2021 04:00:13 -0400, Michael S. Tsirkin<mst@redhat.com>  wrote:
>> On Fri, Apr 23, 2021 at 12:33:09PM +0800, Jason Wang wrote:
>>> 在 2021/4/23 下午12:19, Xuan Zhuo 写道:
>>>> On Fri, 23 Apr 2021 12:08:34 +0800, Jason Wang<jasowang@redhat.com>  wrote:
>>>>> 在 2021/4/22 下午11:16, Xuan Zhuo 写道:
>>>>>> When "headroom" > 0, the actual allocated memory space is the entire
>>>>>> page, so the address of the page should be used when passing it to
>>>>>> build_skb().
>>>>>>
>>>>>> BUG: KASAN: use-after-free in skb_gro_receive (net/core/skbuff.c:4260)
>>>>>> Write of size 16 at addr ffff88811619fffc by task kworker/u9:0/534
>>>>>> CPU: 2 PID: 534 Comm: kworker/u9:0 Not tainted 5.12.0-rc7-custom-16372-gb150be05b806 #3382
>>>>>> Hardware name: QEMU MSN2700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>>>>> Workqueue: xprtiod xs_stream_data_receive_workfn [sunrpc]
>>>>>> Call Trace:
>>>>>>     <IRQ>
>>>>>> dump_stack (lib/dump_stack.c:122)
>>>>>> print_address_description.constprop.0 (mm/kasan/report.c:233)
>>>>>> kasan_report.cold (mm/kasan/report.c:400 mm/kasan/report.c:416)
>>>>>> skb_gro_receive (net/core/skbuff.c:4260)
>>>>>> tcp_gro_receive (net/ipv4/tcp_offload.c:266 (discriminator 1))
>>>>>> tcp4_gro_receive (net/ipv4/tcp_offload.c:316)
>>>>>> inet_gro_receive (net/ipv4/af_inet.c:1545 (discriminator 2))
>>>>>> dev_gro_receive (net/core/dev.c:6075)
>>>>>> napi_gro_receive (net/core/dev.c:6168 net/core/dev.c:6198)
>>>>>> receive_buf (drivers/net/virtio_net.c:1151) virtio_net
>>>>>> virtnet_poll (drivers/net/virtio_net.c:1415 drivers/net/virtio_net.c:1519) virtio_net
>>>>>> __napi_poll (net/core/dev.c:6964)
>>>>>> net_rx_action (net/core/dev.c:7033 net/core/dev.c:7118)
>>>>>> __do_softirq (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:346)
>>>>>> irq_exit_rcu (kernel/softirq.c:221 kernel/softirq.c:422 kernel/softirq.c:434)
>>>>>> common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
>>>>>> </IRQ>
>>>>>>
>>>>>> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
>>>>>> Signed-off-by: Xuan Zhuo<xuanzhuo@linux.alibaba.com>
>>>>>> Reported-by: Ido Schimmel<idosch@nvidia.com>
>>>>>> Tested-by: Ido Schimmel<idosch@nvidia.com>
>>>>>> ---
>>>>> Acked-by: Jason Wang<jasowang@redhat.com>
>>>>>
>>>>> The codes became hard to read, I think we can try to do some cleanups on
>>>>> top to make it easier to read.
>>>>>
>>>>> Thanks
>>>> Yes, this piece of code needs to be sorted out. Especially the big and mergeable
>>>> scenarios should be handled separately. Remove the mergeable code from this
>>>> function, and mergeable uses a new function alone.
>>> Right, another thing is that we may consider to relax the checking of len <
>>> GOOD_COPY_LEN.
>> Want to post a patch on top?
> Yes, I have completed the refactoring of this part of the code, and the related
> testing work is in progress. I will submit the patch after the complete test is
> completed.
>
> Thanks.


Cool, one thing in my mind is we'd better pack the correct truesize (e.g 
PAGE_SIZE in the case of XDP) in the ctx and avoid tricky codes like:

                 /* Buffers with headroom use PAGE_SIZE as alloc size,
                  * see add_recvbuf_mergeable() + get_mergeable_buf_len()
                  */

Thanks


>

