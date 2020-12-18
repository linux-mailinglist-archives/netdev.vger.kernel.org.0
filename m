Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11952DDD27
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 03:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgLRC6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 21:58:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731506AbgLRC6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 21:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608260211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ePTASZu7o5kc6K1mUETLMnjXTOm0ohdFm+SE6FW+4Q=;
        b=iDUOz6fe0SdtebCgxYGcagAQsqZn98/UT8AtGoB06n/myxDlOX1GZRSkDbB2UMY+AzDy2D
        q0u/mJw0jhc+fW0+hI0kpkHl98g+N7gCPSL1195kmJ7WHEyVA9PpJ0PGd9A2SxW1xKXl6x
        14WR8weqf3WLfTrejHwu2KvenMsSrH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-OLEgDrvnOK2yHbrNBpqEig-1; Thu, 17 Dec 2020 21:56:48 -0500
X-MC-Unique: OLEgDrvnOK2yHbrNBpqEig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89BA7107ACF5;
        Fri, 18 Dec 2020 02:56:46 +0000 (UTC)
Received: from [10.72.12.111] (ovpn-12-111.pek2.redhat.com [10.72.12.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C19BB1A8A1;
        Fri, 18 Dec 2020 02:56:36 +0000 (UTC)
Subject: Re: [PATCH 00/21] Control VQ support in vDPA
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216044051-mutt-send-email-mst@kernel.org>
 <aa061fcb-9395-3a1b-5d6e-76b5454dfb6c@redhat.com>
 <20201217025410-mutt-send-email-mst@kernel.org>
 <61b60985-142b-10f2-58b8-1d9f57c0cfca@redhat.com>
 <20201217163513-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c120d0ce-7d42-ab6e-1040-ab85985f7cbe@redhat.com>
Date:   Fri, 18 Dec 2020 10:56:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201217163513-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/18 上午6:28, Michael S. Tsirkin wrote:
> On Thu, Dec 17, 2020 at 05:02:49PM +0800, Jason Wang wrote:
>> On 2020/12/17 下午3:58, Michael S. Tsirkin wrote:
>>> On Thu, Dec 17, 2020 at 11:30:18AM +0800, Jason Wang wrote:
>>>> On 2020/12/16 下午5:47, Michael S. Tsirkin wrote:
>>>>> On Wed, Dec 16, 2020 at 02:47:57PM +0800, Jason Wang wrote:
>>>>>> Hi All:
>>>>>>
>>>>>> This series tries to add the support for control virtqueue in vDPA.
>>>>>>
>>>>>> Control virtqueue is used by networking device for accepting various
>>>>>> commands from the driver. It's a must to support multiqueue and other
>>>>>> configurations.
>>>>>>
>>>>>> When used by vhost-vDPA bus driver for VM, the control virtqueue
>>>>>> should be shadowed via userspace VMM (Qemu) instead of being assigned
>>>>>> directly to Guest. This is because Qemu needs to know the device state
>>>>>> in order to start and stop device correctly (e.g for Live Migration).
>>>>>>
>>>>>> This requies to isolate the memory mapping for control virtqueue
>>>>>> presented by vhost-vDPA to prevent guest from accesing it directly.
>>>>>> To achieve this, vDPA introduce two new abstractions:
>>>>>>
>>>>>> - address space: identified through address space id (ASID) and a set
>>>>>>                     of memory mapping in maintained
>>>>>> - virtqueue group: the minimal set of virtqueues that must share an
>>>>>>                     address space
>>>>> How will this support the pretty common case where control vq
>>>>> is programmed by the kernel through the PF, and others by the VFs?
>>>> In this case, the VF parent need to provide a software control vq and decode
>>>> the command then send them to VF.
>>> But how does that tie to the address space infrastructure?
>> In this case, address space is not a must.
> That's ok, problem is I don't see how address space is going
> to work in this case at all.
>
> There's no address space there that userspace/guest can control.
>

The virtqueue group is mandated by parent but the association between 
virtqueue group and address space is under the control of userspace (Qemu).

A simple but common case is that:

1) Device advertise two virtqueue groups: group 0 contains RX and TX, 
group 1 contains CVQ.
2) Device advertise two address spaces

Then, for vhost-vDPA using by VM:

1) associate group 0 with as 0, group 1 with as 1 (via vhost-vDPA 
VHOST_VDPA_SET_GROUP_ASID)
2) Publish guest memory mapping via IOTLB asid 0
3) Publish control virtqueue mapping via IOTLB asid 1

Then the DMA is totally isolated in this case.

For vhost-vDPA using by DPDK or virtio-vDPA

1) associate group 0 and group 1 with as 0

since we don't need DMA isolation in this case.

In order to let it be controlled by Guest, we need extend virtio spec to 
support those concepts.

Thanks


