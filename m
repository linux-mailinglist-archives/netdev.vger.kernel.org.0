Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81411291BA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfLWGGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:06:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42353 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbfLWGGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 01:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577081171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HktJH0dvsHvV7SiBs6r9/N1aqb3VBRmcc3Ui6snl00=;
        b=iI8sloR81oKFvCeo5jE3jZFLpJSOb4i8z6nC98biP7qraVrvZTLWhyyw4qPiT3W0lYrn2B
        pqBdTu/7H4C6ECGImdVOY4qlnSmYvWHrw03clktIvBqhYswtHZWT+ATuMzKb07MZTCnqAK
        iAAFam8jtkz2TWFLl51kmLsXWbvP6jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-d_4RgNUXPKOlRs2TezPmfA-1; Mon, 23 Dec 2019 01:06:09 -0500
X-MC-Unique: d_4RgNUXPKOlRs2TezPmfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 036C21856A60;
        Mon, 23 Dec 2019 06:06:07 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52481001DF0;
        Mon, 23 Dec 2019 06:05:40 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4d1847f1-73c2-7cf2-11e4-ce66c268b386@redhat.com>
Date:   Mon, 23 Dec 2019 14:05:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <58e0f61d-cb17-f517-d76d-8a665af31618@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/21 =E4=B8=8A=E5=8D=886:17, Prashant Bhole wrote:
>
>
> On 12/21/2019 1:11 AM, David Ahern wrote:
>> On 12/19/19 9:46 PM, Prashant Bhole wrote:
>>>
>>> "It can improve container networking where veth pair links the host a=
nd
>>> the container. Host can set ACL by setting tx path XDP to the veth
>>> iface."
>>
>> Just to be clear, this is the use case of interest to me, not the
>> offloading. I want programs managed by and viewable by the host OS and
>> not necessarily viewable by the guest OS or container programs.
>>
>
> Yes the plan is to implement this while having a provision to implement
> offload feature on top of it.


I wonder maybe it's easier to focus on the TX path first then consider=20
building offloading support on top.

Thanks

