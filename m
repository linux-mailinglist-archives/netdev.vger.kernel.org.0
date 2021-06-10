Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67063A2568
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFJH0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:26:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230489AbhFJHZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623309843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5tlPw+fNQnyyXsv0Z5PViUY/ZrTm7CI6pUHe7QloYKE=;
        b=Oxu8BGK1M/8+HlDYuQpVcZx9J6zD1i8um11kaR3Laz14HzgtUhGJBncULf6OcbDgSiKjLM
        193CCd+i9ZhLsCg29Cw8TT3eHz9SpBN9IWyxt55UPGeq1G2ACx0gyQLy2chaPj9JyeFXOr
        OwQtap0TthOsj69V0t93pTdsgwwUthw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-a6msjkzjMG2iudv2Hx1kMQ-1; Thu, 10 Jun 2021 03:24:02 -0400
X-MC-Unique: a6msjkzjMG2iudv2Hx1kMQ-1
Received: by mail-ed1-f72.google.com with SMTP id x12-20020a05640226ccb0290393aaa6e811so3916534edd.19
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 00:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5tlPw+fNQnyyXsv0Z5PViUY/ZrTm7CI6pUHe7QloYKE=;
        b=c6pyu3Xb+GQxelWZAV9ms/d5a6JOoAIumiprvImYV/Oc/X8Fjh9ZOl6cRWElkO7LFw
         97R3TcFlFj3ywmwOqokBmWqZR6R0WDDJ1hrha50+HRobPxeqoPWW9wz+kyPuVQOQWl5b
         lvwElfI2VJfBdwf5AtPbH3xmsQ6klinH9F9dCIkIrhRDhVnGUlww1QwptE7MAPs9YiWd
         +CtwAYCouByP29DuSAYdFadzZWlvbjrvNg4non2J3dGS11dwA/MJMAkeBNPDuEqL+O4F
         NIn8iD0HlShXvTMeavkJX0CM5fUBrl5acj2+JtfnC9Q1LdzKFn9qbhzDgiQgGGngdU5G
         xQkw==
X-Gm-Message-State: AOAM531DIhQmySoyueQYyQyBF8umVPYFE25pr0Nsud+opa1UDm42Mj+K
        2msyQhzAnruTU0C5+jS02o28+WIPonaH2ZRaFYW+GpreJbVPHw3ONg+R7XWIT7/p7odI1YfzRcN
        WC4RKIr8U3ET4fUzF
X-Received: by 2002:a05:6402:31a2:: with SMTP id dj2mr3327564edb.206.1623309841253;
        Thu, 10 Jun 2021 00:24:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQjjBWn2tn5Hz5WlWbOxelGasgbyypBGGNi74+KR/G3TdCo5Fjc4YzbciAEeQef5nBrmemKQ==
X-Received: by 2002:a05:6402:31a2:: with SMTP id dj2mr3327543edb.206.1623309841108;
        Thu, 10 Jun 2021 00:24:01 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id o21sm651992ejg.49.2021.06.10.00.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 00:24:00 -0700 (PDT)
Date:   Thu, 10 Jun 2021 09:23:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Jiang Wang ." <jiang.wang@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?utf-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
Message-ID: <20210610072358.3fuvsahxec2sht4y@steredhat>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
 <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
 <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 12:02:35PM +0800, Jason Wang wrote:
>
>在 2021/6/10 上午11:43, Jiang Wang . 写道:
>>On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>>在 2021/6/10 上午7:24, Jiang Wang 写道:
>>>>This patchset implements support of SOCK_DGRAM for virtio
>>>>transport.
>>>>
>>>>Datagram sockets are connectionless and unreliable. To avoid unfair contention
>>>>with stream and other sockets, add two more virtqueues and
>>>>a new feature bit to indicate if those two new queues exist or not.
>>>>
>>>>Dgram does not use the existing credit update mechanism for
>>>>stream sockets. When sending from the guest/driver, sending packets
>>>>synchronously, so the sender will get an error when the virtqueue is 
>>>>full.
>>>>When sending from the host/device, send packets asynchronously
>>>>because the descriptor memory belongs to the corresponding QEMU
>>>>process.
>>>
>>>What's the use case for the datagram vsock?
>>>
>>One use case is for non critical info logging from the guest
>>to the host, such as the performance data of some applications.
>
>
>Anything that prevents you from using the stream socket?
>
>
>>
>>It can also be used to replace UDP communications between
>>the guest and the host.
>
>
>Any advantage for VSOCK in this case? Is it for performance (I guess 
>not since I don't exepct vsock will be faster).

I think the general advantage to using vsock are for the guest agents 
that potentially don't need any configuration.

>
>An obvious drawback is that it breaks the migration. Using UDP you can 
>have a very rich features support from the kernel where vsock can't.
>

Thanks for bringing this up!
What features does UDP support and datagram on vsock could not support?

>
>>
>>>>The virtio spec patch is here:
>>>>https://www.spinics.net/lists/linux-virtualization/msg50027.html
>>>
>>>Have a quick glance, I suggest to split mergeable rx buffer into an
>>>separate patch.
>>Sure.
>>
>>>But I think it's time to revisit the idea of unifying the virtio-net 
>>>and
>>>virtio-vsock. Otherwise we're duplicating features and bugs.
>>For mergeable rxbuf related code, I think a set of common helper
>>functions can be used by both virtio-net and virtio-vsock. For other
>>parts, that may not be very beneficial. I will think about more.
>>
>>If there is a previous email discussion about this topic, could you 
>>send me
>>some links? I did a quick web search but did not find any related
>>info. Thanks.
>
>
>We had a lot:
>
>[1] 
>https://patchwork.kernel.org/project/kvm/patch/5BDFF537.3050806@huawei.com/
>[2] 
>https://lists.linuxfoundation.org/pipermail/virtualization/2018-November/039798.html
>[3] https://www.lkml.org/lkml/2020/1/16/2043
>

When I tried it, the biggest problem that blocked me were all the 
features strictly related to TCP/IP stack and ethernet devices that 
vsock device doesn't know how to handle: TSO, GSO, checksums, MAC, napi, 
xdp, min ethernet frame size, MTU, etc.

So in my opinion to unify them is not so simple, because vsock is not 
really an ethernet device, but simply a socket.

But I fully agree that we shouldn't duplicate functionality and code, so 
maybe we could find those common parts and create helpers to be used by 
both.

Thanks,
Stefano

