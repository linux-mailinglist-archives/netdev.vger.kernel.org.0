Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACCE12932C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 09:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfLWIfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 03:35:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37703 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbfLWIfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 03:35:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577090112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kng5BQ6geTO5G0IpIO7Umq6s36/qDOoUa1RGRiwKVg=;
        b=K8tNF+dhaZS+s3uIrQ+4kt6ZiCv/WjMvV1RXrHeShnvwCuSMlputhIJfkyZUkSWNBJI6iD
        XZ440PEnmwFuMUqPJ3wMz1QUNqXa/hLIA1P2OJl4TxrBRXTPPOTZHw5vZ+6b45Pj/GhTZu
        gnR55W6vjQUX1Ztj/57E9Q5OFuqsbsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-Zfx20ylTNoqnKVp7lrUVfA-1; Mon, 23 Dec 2019 03:35:10 -0500
X-MC-Unique: Zfx20ylTNoqnKVp7lrUVfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78C70800EBF;
        Mon, 23 Dec 2019 08:35:08 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57F19605FF;
        Mon, 23 Dec 2019 08:34:56 +0000 (UTC)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
 <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
 <58e0f61d-cb17-f517-d76d-8a665af31618@gmail.com>
 <4d1847f1-73c2-7cf2-11e4-ce66c268b386@redhat.com>
 <09118670-b0c7-897c-961d-022ad4dfb093@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2ca3d486-a5ee-5c78-e957-74f8932f1f62@redhat.com>
Date:   Mon, 23 Dec 2019 16:34:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <09118670-b0c7-897c-961d-022ad4dfb093@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/23 =E4=B8=8B=E5=8D=884:09, Prashant Bhole wrote:
>
>
> On 12/23/19 3:05 PM, Jason Wang wrote:
>>
>> On 2019/12/21 =E4=B8=8A=E5=8D=886:17, Prashant Bhole wrote:
>>>
>>>
>>> On 12/21/2019 1:11 AM, David Ahern wrote:
>>>> On 12/19/19 9:46 PM, Prashant Bhole wrote:
>>>>>
>>>>> "It can improve container networking where veth pair links the=20
>>>>> host and
>>>>> the container. Host can set ACL by setting tx path XDP to the veth
>>>>> iface."
>>>>
>>>> Just to be clear, this is the use case of interest to me, not the
>>>> offloading. I want programs managed by and viewable by the host OS a=
nd
>>>> not necessarily viewable by the guest OS or container programs.
>>>>
>>>
>>> Yes the plan is to implement this while having a provision to impleme=
nt
>>> offload feature on top of it.
>>
>>
>> I wonder maybe it's easier to focus on the TX path first then=20
>> consider building offloading support on top.
> Currently working on TX path. I will try make sure that we will be able
> to implement offloading on top of it later.
>
> Thanks.


Right, then I think it's better to drop patch 13 and bring it back in=20
the offloading series.

Thanks

