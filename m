Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169AA16F7A9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBZFva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:51:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725789AbgBZFva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:51:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582696289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2AUO6DTg/3OFGGrxlQsEIfhX9z83fLojeGZS+4/9tI=;
        b=AqLrsNmJF5m16OfpDD1ye5kECBSE+iZq/w8OE0pcV3QVlQ9sxUsHKYCQHTE6/rvCHUzWRa
        5UtArpl71SSLlqK+giFmc/nTGQe7HYZYHKt9ASD581+SF3rRQYYvaUicOQ7WKAYWhzfwtq
        bzASBpKxr2fu5Wk3H9LYpHf5RsOVznI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-QgxU8KWeMZqFEFXeX1J3rQ-1; Wed, 26 Feb 2020 00:51:27 -0500
X-MC-Unique: QgxU8KWeMZqFEFXeX1J3rQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72F7C800D48;
        Wed, 26 Feb 2020 05:51:26 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5989E8C07C;
        Wed, 26 Feb 2020 05:51:04 +0000 (UTC)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     David Ahern <dsahern@gmail.com>,
        David Ahern <dahern@digitalocean.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
 <3ab884ab-f7f8-18eb-3d18-c7636c84f9b4@digitalocean.com>
 <cf132d5f-5359-b3a5-38c2-34583aae3f36@redhat.com>
 <5861350a-a0f6-9a74-e06d-4b7fd688e5e7@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9d2769ba-b104-dcd2-98f6-df9fa1f568ea@redhat.com>
Date:   Wed, 26 Feb 2020 13:51:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5861350a-a0f6-9a74-e06d-4b7fd688e5e7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8B=E5=8D=8812:35, David Ahern wrote:
> On 2/25/20 8:52 PM, Jason Wang wrote:
>> On 2020/2/26 =E4=B8=8A=E5=8D=8811:34, David Ahern wrote:
>>> On 2/25/20 8:29 PM, Jason Wang wrote:
>>>> TAP uses spinlock for XDP_TX.
>>> code reference? I can not find that.
>>>
>> In tun_xdp_xmit(), ptr_ring is synchronized through producer_lock.
>>
> thanks. I was confused by the tap comment when it is the tun code.


Ah, I see, yes, the tap is kind of confusing.


>
> So you mean a spinlock around virtnet_xdp_xmit for XDP_TX:
>
> +                       if (!vi->can_do_xdp_tx)
> +                               spin_lock(&vi->xdp_tx_lock);
>                          err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> +                       if (!vi->can_do_xdp_tx)
> +                               spin_unlock(&vi->xdp_tx_lock);


Something like this, but probably need to use __netif_tx_lock_bh()=20
inside virtnet_xdp_xmit().

Need to calculate a sendqueue before in virtnet_xdp_sq().

Thanks

>

