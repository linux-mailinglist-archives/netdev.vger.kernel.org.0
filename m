Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE8913216B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 09:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgAGIbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 03:31:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727167AbgAGIbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 03:31:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578385877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vF6sDbkc+WEm8XglHdUKDkPI3i4BPn8PiMseQ0QvR8o=;
        b=DUWyglsB2giCwW9RMk2msv1MTqUslNbWJkX6E6wgtNRBaqcNTRnP+UY0msjeIl+Xq5YjM2
        EBzu8li+jyIOr92yD5inoU9SERyk5bcS7CMTK9ETci2kdZ9Ord73WZgSJ6VG2zk6tMr9RC
        SXZkaTzMUJJ7dqNNxXMWMaomZaa0Ao0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-0qH6OMJ0PnqNauFDKp8scQ-1; Tue, 07 Jan 2020 03:31:14 -0500
X-MC-Unique: 0qH6OMJ0PnqNauFDKp8scQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B10F1807465;
        Tue,  7 Jan 2020 08:31:13 +0000 (UTC)
Received: from [10.72.12.248] (ovpn-12-248.pek2.redhat.com [10.72.12.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FE3F85EE6;
        Tue,  7 Jan 2020 08:31:07 +0000 (UTC)
Subject: Re: [PATCH v2] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Alistair Delva <adelva@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200105132120.92370-1-mst@redhat.com>
 <2d7053b5-295c-4051-a722-7656350bdb74@redhat.com>
 <20200106074426-mutt-send-email-mst@kernel.org>
 <eab75b06-453d-2e17-1e77-439a66c3c86a@redhat.com>
 <20200107020303-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6febe3fd-f243-13d2-b3cf-efd172f229c7@redhat.com>
Date:   Tue, 7 Jan 2020 16:31:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200107020303-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/7 =E4=B8=8B=E5=8D=883:06, Michael S. Tsirkin wrote:
> On Tue, Jan 07, 2020 at 10:29:08AM +0800, Jason Wang wrote:
>> On 2020/1/6 =E4=B8=8B=E5=8D=888:54, Michael S. Tsirkin wrote:
>>> On Mon, Jan 06, 2020 at 10:47:35AM +0800, Jason Wang wrote:
>>>> On 2020/1/5 =E4=B8=8B=E5=8D=889:22, Michael S. Tsirkin wrote:
>>>>> The only way for guest to control offloads (as enabled by
>>>>> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
>>>>> through CTRL_VQ. So it does not make sense to
>>>>> acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
>>>>> VIRTIO_NET_F_CTRL_VQ.
>>>>>
>>>>> The spec does not outlaw devices with such a configuration, so we h=
ave
>>>>> to support it. Simply clear VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>>>>> Note that Linux is still crashing if it tries to
>>>>> change the offloads when there's no control vq.
>>>>> That needs to be fixed by another patch.
>>>>>
>>>>> Reported-by: Alistair Delva <adelva@google.com>
>>>>> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>>>>> Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if =
possible on XDP set")
>>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>>> ---
>>>>>
>>>>> Same patch as v1 but update documentation so it's clear it's not
>>>>> enough to fix the crash.
>>>>>
>>>>>     drivers/net/virtio_net.c | 9 +++++++++
>>>>>     1 file changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>> index 4d7d5434cc5d..7b8805b47f0d 100644
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -2971,6 +2971,15 @@ static int virtnet_validate(struct virtio_de=
vice *vdev)
>>>>>     	if (!virtnet_validate_features(vdev))
>>>>>     		return -EINVAL;
>>>>> +	/* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
>>>>> +	 * VIRTIO_NET_F_CTRL_VQ. Unfortunately spec forgot to
>>>>> +	 * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
>>>>> +	 * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
>>>>> +	 * not the former.
>>>>> +	 */
>>>>> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>>>>> +			__virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
>>>> If it's just because a bug of spec, should we simply fix the bug and=
 fail
>>>> the negotiation in virtnet_validate_feature()?
>>> One man's bug is another man's feature: arguably leaving the features
>>> independent in the spec might allow reuse of the feature bit without
>>> breaking guests.
>>>
>>> And even if we say it's a bug we can't simply fix the bug in the
>>> spec: changing the text for a future version does not change the fact
>>> that devices behaving according to the spec exist.
>>>
>>>> Otherwise there would be inconsistency in handling feature dependenc=
ies for
>>>> ctrl vq.
>>>>
>>>> Thanks
>>> That's a cosmetic problem ATM. It might be a good idea to generally
>>> change our handling of dependencies, and clear feature bits instead o=
f
>>> failing probe on a mismatch.
>>
>> Something like I proposed in the past ? [1]
>>
>> [1] https://lore.kernel.org/patchwork/patch/519074/
>
> No that still fails probe.
>
> I am asking whether it's more future proof to fail probe
> on feature combinations disallowed by spec, or to clear bits
> to get to an expected combination.


Sorry wrong link.

It should be: https://lkml.org/lkml/2014/11/17/82


>
> In any case, we should probably document in the spec how
> drivers behave on such combinations.


Yes.

Thanks


>
>
>>>    It's worth thinking  - at the spec level -
>>> how we can best make the configuration extensible.
>>> But that's not something spec should worry about.
>>>
>>>
>>>>> +
>>>>>     	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>>>>>     		int mtu =3D virtio_cread16(vdev,
>>>>>     					 offsetof(struct virtio_net_config,

