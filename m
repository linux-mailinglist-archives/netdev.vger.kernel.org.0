Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2A310868B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 03:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKYCmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 21:42:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47175 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbfKYCmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 21:42:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574649732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3o2zb24kIRBTzY7PPr7Q4XXAwQkEmzRh8aDu2/bWy0w=;
        b=V2WWtcwRwOloWNaqM7lUtvJz3fVu7s2F0EhfaP5Muqog0ehzQ53C0m4JrDPL6AcixfdVgN
        NGBCpbl6Pli1BgPzFiE+BRYFsgHnvZm4FvVi+wfkOGNo0eoc0JNK3fMTyhFRPhYRUeUo++
        9x9nvKoaDI/T6oh8sOmECK03FmAj16M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-ef78lVTuMW-QOXqb2wgwmg-1; Sun, 24 Nov 2019 21:42:08 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE680800580;
        Mon, 25 Nov 2019 02:42:07 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53744600C1;
        Mon, 25 Nov 2019 02:42:02 +0000 (UTC)
Subject: Re: error loading xdp program on virtio nic
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
 <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
 <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
 <20191121072625.3573368f@carbon>
 <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
 <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com>
 <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com>
 <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
 <20191122175749.47728e42@carbon>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c55b35f-9ffe-c192-651c-f5ca3d02de52@redhat.com>
Date:   Mon, 25 Nov 2019 10:42:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191122175749.47728e42@carbon>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ef78lVTuMW-QOXqb2wgwmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/23 =E4=B8=8A=E5=8D=8812:57, Jesper Dangaard Brouer wrote:
> On Fri, 22 Nov 2019 08:43:50 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
>> On 11/21/19 11:09 PM, Jason Wang wrote:
>>>> Doubling the number of queues for each tap device adds overhead to the
>>>> hypervisor if you only want to allow XDP_DROP or XDP_DIRECT. Am I
>>>> understanding that correctly?
>>>
>>> Yes, but there's almost impossible to know whether or not XDP_TX will b=
e
>>> used by the program. If we don't use per CPU TX queue, it must be
>>> serialized through locks, not sure it's worth try that (not by default,
>>> of course).
>>>   =20
>> This restriction is going to prevent use of XDP in VMs in general cloud
>> hosting environments. 2x vhost threads for vcpus is a non-starter.
>>
>> If one XDP feature has high resource needs, then we need to subdivide
>> the capabilities to let some work and others fail. For example, a flag
>> can be added to xdp_buff / xdp_md that indicates supported XDP features.
>> If there are insufficient resources for XDP_TX, do not show support for
>> it. If a program returns XDP_TX anyways, packets will be dropped.
>>
> This sounds like concrete use-case and solid argument why we need XDP
> feature detection and checks. (Last part of LPC talk[1] were about
> XDP features).
>
> An interesting perspective you bring up, is that XDP features are not
> static per device driver.  It actually needs to be dynamic, as your
> XDP_TX feature request depend on the queue resources available.
>
> Implementation wise, I would not add flags to xdp_buff / xdp_md.
> Instead I propose in[1] slide 46, that the verifier should detect the
> XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
> XDP_TX, then you should be allowed to run it on a virtio_net device
> with less queue configured, right?


Yes, I think so. But I remember we used to have something like=20
header_adjust in the past but finally removed ...

Thanks


>
>
> [1] http://people.netfilter.org/hawk/presentations/LinuxPlumbers2019/xdp-=
distro-view.pdf

