Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450D8E6B9A
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 04:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfJ1DvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 23:51:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24223 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731480AbfJ1DvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 23:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572234666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c3g4UjEb9DWKqjphn6WUlg8TodMgT3MFxKe3D2APMzQ=;
        b=O58oaPqCBm2CehB2m7pxkM4bzB0imAOwss6cOANmChQeDoeCTrPTwiZ5U6RX96sVWjjJ4y
        nPBhsvxi6fn1I8KvNcNKAG63lZa8RQiULW2ewId2F3t5W0ALB8KCS2Pac/5oGmk2n+pBEk
        r0uzNzFFjOr9AcIFKcv14Ne9osO85c8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-ZuWQpeT7OoiBddLiSa6f_Q-1; Sun, 27 Oct 2019 23:51:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C975EC;
        Mon, 28 Oct 2019 03:51:00 +0000 (UTC)
Received: from [10.72.12.246] (ovpn-12-246.pek2.redhat.com [10.72.12.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0AC35C219;
        Mon, 28 Oct 2019 03:50:51 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, maxime.coquelin@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
 <20191023101135.GA6367@___> <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
 <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
 <20191025080143-mutt-send-email-mst@kernel.org> <20191028015842.GA9005@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5e8a623d-9d91-607a-1f9e-7a7086ba9a68@redhat.com>
Date:   Mon, 28 Oct 2019 11:50:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191028015842.GA9005@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ZuWQpeT7OoiBddLiSa6f_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/28 =E4=B8=8A=E5=8D=889:58, Tiwei Bie wrote:
> On Fri, Oct 25, 2019 at 08:16:26AM -0400, Michael S. Tsirkin wrote:
>> On Fri, Oct 25, 2019 at 05:54:55PM +0800, Jason Wang wrote:
>>> On 2019/10/24 =E4=B8=8B=E5=8D=886:42, Jason Wang wrote:
>>>> Yes.
>>>>
>>>>
>>>>>  =C2=A0 And we should try to avoid
>>>>> putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
>>>>> guests having the chance to bypass the host (e.g. QEMU) to
>>>>> setup the backend accelerator directly.
>>>>
>>>> That's really good point.=C2=A0 So when "vhost" type is created, paren=
t
>>>> should assume addr of ctrl_vq is hva.
>>>>
>>>> Thanks
>>>
>>> This works for vhost but not virtio since there's no way for virtio ker=
nel
>>> driver to differ ctrl_vq with the rest when doing DMA map. One possible
>>> solution is to provide DMA domain isolation between virtqueues. Then ct=
rl vq
>>> can use its dedicated DMA domain for the work.
> It might not be a bad idea to let the parent drivers distinguish
> between virtio-mdev mdevs and vhost-mdev mdevs in ctrl-vq handling
> by mdev's class id.


Yes, that should work, I have something probable better, see below.


>
>>> Anyway, this could be done in the future. We can have a version first t=
hat
>>> doesn't support ctrl_vq.
> +1, thanks
>
>>> Thanks
>> Well no ctrl_vq implies either no offloads, or no XDP (since XDP needs
>> to disable offloads dynamically).
>>
>>          if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLO=
ADS)
>>              && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) |=
|
>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) |=
|
>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM)))=
 {
>>                  NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is=
 implementing LRO/CSUM, disable LRO/CSUM first");
>>                  return -EOPNOTSUPP;
>>          }
>>
>> neither is very attractive.
>>
>> So yes ok just for development but we do need to figure out how it will
>> work down the road in production.
> Totally agree.
>
>> So really this specific virtio net device does not support control vq,
>> instead it supports a different transport specific way to send commands
>> to device.
>>
>> Some kind of extension to the transport? Ideas?


So it's basically an issue of isolating DMA domains. Maybe we can start=20
with transport API for querying per vq DMA domain/ASID?

- for vhost-mdev, userspace can query the DMA domain for each specific=20
virtqueue. For control vq, mdev can return id for software domain, for=20
the rest mdev will return id of VFIO domain. Then userspace know that it=20
should use different API for preparing the virtqueue, e.g for vq other=20
than control vq, it should use VFIO DMA API. The control vq it should=20
use hva instead.

- for virito-mdev, we can introduce per-vq DMA device, and route DMA=20
mapping request for control vq back to mdev instead of the hardware. (We=20
can wrap them into library or helpers to ease the development of vendor=20
physical drivers).

Thanks


>>
>>
>> --=20
>> MST

