Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D45416F61A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgBZDcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:32:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43726 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726671AbgBZDcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582687921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwHQvO/nMGy2fq6bfnFp7lNl4js9jld+laOgSD/TfnM=;
        b=a2YC3XvB4A59/NPP3q9m/21wiJaqSHuaNdL1hnrEt+kBAXsjnzAarjUa/6JLKvUASzv6aQ
        3HUCU1tX6za9RlIf1gkbo4rz6/BjlsxNV+dSZqDhKhQulKeGEofw8hueA009k1nMyLzrAr
        Aq9AkO//gxmEr1hmA/pLJRi/Yy3Sxgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-wcU_vmtBNFOv2vCoDcApdg-1; Tue, 25 Feb 2020 22:30:04 -0500
X-MC-Unique: wcU_vmtBNFOv2vCoDcApdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 515D98017CC;
        Wed, 26 Feb 2020 03:30:03 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DED5399;
        Wed, 26 Feb 2020 03:29:45 +0000 (UTC)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
Date:   Wed, 26 Feb 2020 11:29:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8A=E5=8D=8811:24, David Ahern wrote:
> On 2/25/20 8:00 PM, Jason Wang wrote:
>> On 2020/2/26 =E4=B8=8A=E5=8D=888:57, David Ahern wrote:
>>> From: David Ahern<dahern@digitalocean.com>
>>>
>>> virtio_net currently requires extra queues to install an XDP program,
>>> with the rule being twice as many queues as vcpus. From a host
>>> perspective this means the VM needs to have 2*vcpus vhost threads
>>> for each guest NIC for which XDP is to be allowed. For example, a
>>> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
>>>
>>> The extra queues are only needed in case an XDP program wants to
>>> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
>>> additional queues. Relax the queue requirement and allow XDP
>>> functionality based on resources. If an XDP program is loaded and
>>> there are insufficient queues, then return a warning to the user
>>> and if a program returns XDP_TX just drop the packet. This allows
>>> the use of the rest of the XDP functionality to work without
>>> putting an unreasonable burden on the host.
>>>
>>> Cc: Jason Wang<jasowang@redhat.com>
>>> Cc: Michael S. Tsirkin<mst@redhat.com>
>>> Signed-off-by: David Ahern<dahern@digitalocean.com>
>>> ---
>>>  =C2=A0 drivers/net/virtio_net.c | 14 ++++++++++----
>>>  =C2=A0 1 file changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 2fe7a3188282..2f4c5b2e674d 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -190,6 +190,8 @@ struct virtnet_info {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* # of XDP queue pairs currently use=
d by the driver */
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 xdp_queue_pairs;
>>>  =C2=A0 +=C2=A0=C2=A0=C2=A0 bool can_do_xdp_tx;
>>> +
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* I like... big packets and I cannot=
 lie! */
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool big_packets;
>>>  =C2=A0 @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(stru=
ct
>>> net_device *dev,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 len =3D xdp.data_end - xdp.data;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case XDP_TX:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (!vi->can_do_xdp_tx)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto err_xdp;
>> I wonder if using spinlock to synchronize XDP_TX is better than droppi=
ng
>> here?
> I recall you suggesting that. Sure, it makes for a friendlier user
> experience, but if a spinlock makes this slower then it goes against th=
e
> core idea of XDP.
>
>

Maybe we can do some benchmark. TAP uses spinlock for XDP_TX. If my=20
memory is correct, for the best case (no queue contention), it can only=20
have ~10% PPS drop on heavy workload.

Thanks

