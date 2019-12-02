Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF210E492
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfLBCoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:44:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32123 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfLBCoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575254693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSf88/Ymm45hVchy24xxnNDl7fg3cEgjk/44EM+Uozc=;
        b=MobWEOH6wuagXBXOg+MkICgdw28yULk217TjIUy1dGSJP0KbYeG7SxKbx7rcyw8dPjn7/a
        ymN4qoTU9428lcvINA7hBke2N73HFNZV4cIopcna8Mey5mNdsTQa7imSKFWVcWc9ibLi8G
        LWeID1t2spY3TWwfxK6bM2DQYAOr/dg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-BAKKw8eROF-P6vqOzIgWug-1; Sun, 01 Dec 2019 21:44:50 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 877B18017CC;
        Mon,  2 Dec 2019 02:44:47 +0000 (UTC)
Received: from [10.72.12.226] (ovpn-12-226.pek2.redhat.com [10.72.12.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04E095D9CA;
        Mon,  2 Dec 2019 02:44:38 +0000 (UTC)
Subject: Re: [RFC net-next 07/18] tun: set offloaded xdp program
To:     David Ahern <dsahern@gmail.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-8-prashantbhole.linux@gmail.com>
 <e0631f09-28ce-7d13-e58c-87a700a39353@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <10625932-aa8b-f8ff-b835-7b142d9f45a2@redhat.com>
Date:   Mon, 2 Dec 2019 10:44:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e0631f09-28ce-7d13-e58c-87a700a39353@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: BAKKw8eROF-P6vqOzIgWug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/2 =E4=B8=8A=E5=8D=8812:35, David Ahern wrote:
> On 11/26/19 4:07 AM, Prashant Bhole wrote:
>> From: Jason Wang <jasowang@redhat.com>
>>
>> This patch introduces an ioctl way to set an offloaded XDP program
>> to tun driver. This ioctl will be used by qemu to offload XDP program
>> from virtio_net in the guest.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   drivers/net/tun.c           | 19 ++++++++++++++-----
>>   include/uapi/linux/if_tun.h |  1 +
>>   2 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index d078b4659897..ecb49101b0b5 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -241,6 +241,7 @@ struct tun_struct {
>>   =09struct bpf_prog __rcu *xdp_prog;
>>   =09struct tun_prog __rcu *steering_prog;
>>   =09struct tun_prog __rcu *filter_prog;
>> +=09struct tun_prog __rcu *offloaded_xdp_prog;
> I have been looking into running XDP pograms in the TX path of a tap
> device [1] where the program is installed and managed by a process in
> the host. The code paths are the same as what you are doing with XDP
> offload, so how about calling this xdp_prog_tx?
>
> [1]
> https://github.com/dsahern/linux/commit/f2303d05187c8a604cdb70b288338e9b1=
d1b0db6
>

I think it's fine, btw, except for the netlink part there should be no=20
much difference.

Thanks

