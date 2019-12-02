Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362410E49F
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLBCsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:48:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbfLBCsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575254904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eh/9LsFVVQglnm+8EHAX4r6c+/8Racl9Vyp+86QvbXA=;
        b=d4pNHGeebLPpDfnP6f9a3TtB5btRk3Q0Cf2Knhu8vyNcdVyMcpfUnZhf+2BLdnpkg/JSVp
        sAzUyUx45LvYUSFPUnQj8lvDN8VqCVrmwQMPYwSF9Xd4eW7iLCfdDP2R3lf9+JRau03iDj
        f80SJt1D5hAUVj6pwsqIMPjyCR9D17A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-fJPv4qOmNWG83CNuMLfuMA-1; Sun, 01 Dec 2019 21:48:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C59FA107ACC5;
        Mon,  2 Dec 2019 02:48:18 +0000 (UTC)
Received: from [10.72.12.226] (ovpn-12-226.pek2.redhat.com [10.72.12.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9017B5D9CA;
        Mon,  2 Dec 2019 02:48:08 +0000 (UTC)
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
To:     David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        kvm@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
 <20191128033255.r66d4zedmhudeaa6@ast-mbp.dhcp.thefacebook.com>
 <c6c6ca98-8793-5510-ad24-583e25403e35@redhat.com>
 <0aa6a69a-0bbe-e0fc-1e18-2114adb18c51@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c5d567f9-9926-8fbb-5bc7-9cccca658108@redhat.com>
Date:   Mon, 2 Dec 2019 10:48:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0aa6a69a-0bbe-e0fc-1e18-2114adb18c51@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: fJPv4qOmNWG83CNuMLfuMA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/2 =E4=B8=8A=E5=8D=8812:54, David Ahern wrote:
> On 11/27/19 10:18 PM, Jason Wang wrote:
>> We try to follow what NFP did by starting from a fraction of the whole
>> eBPF features. It would be very hard to have all eBPF features
>> implemented from the start.=C2=A0 It would be helpful to clarify what's =
the
>> minimal set of features that you want to have from the start.
> Offloading guest programs needs to prevent a guest XDP program from
> running bpf helpers that access host kernel data. e.g., bpf_fib_lookup


Right, so we probably need a new type of eBPF program on the host and=20
filter out the unsupported helpers there.

Thanks


>

