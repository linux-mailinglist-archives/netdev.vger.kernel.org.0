Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C51510C32F
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 05:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfK1ESo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 23:18:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42743 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbfK1ESo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 23:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574914722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZHfnpUHMVQfOJML2Ic3SHu+PaQ/ZeBlsp9ffMkTs9Y=;
        b=SSUrzqMdWLqPxNuri94nNSaIVppDHmJjVbyh3M2AW78pOxVtte4FAeBIv0BxjlvWt3/FQi
        iMA7a2SB6J2fFmLjh20m+Xlszj1AV86ZyRDt5awHndPoICCVVJbqrHNTH8FKdckx3lFPPk
        IEDyRZ2PtHEz+UaZKMwY5A8f7l45Pms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-phLk_qt-Pc6H7_DN1poGOw-1; Wed, 27 Nov 2019 23:18:41 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04631184CAA1;
        Thu, 28 Nov 2019 04:18:39 +0000 (UTC)
Received: from [10.72.12.231] (ovpn-12-231.pek2.redhat.com [10.72.12.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 114B1100164D;
        Thu, 28 Nov 2019 04:18:22 +0000 (UTC)
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c6c6ca98-8793-5510-ad24-583e25403e35@redhat.com>
Date:   Thu, 28 Nov 2019 12:18:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191128033255.r66d4zedmhudeaa6@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: phLk_qt-Pc6H7_DN1poGOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/28 =E4=B8=8A=E5=8D=8811:32, Alexei Starovoitov wrote:
> On Tue, Nov 26, 2019 at 12:35:14PM -0800, Jakub Kicinski wrote:
>> I'd appreciate if others could chime in.
> The performance improvements are quite appealing.
> In general offloading from higher layers into lower layers is necessary l=
ong term.
>
> But the approach taken by patches 15 and 17 is a dead end. I don't see ho=
w it
> can ever catch up with the pace of bpf development.


This applies for any hardware offloading features, isn't it?


>   As presented this approach
> works for the most basic programs and simple maps. No line info, no BTF, =
no
> debuggability. There are no tail_calls either.


If I understand correctly, neither of above were implemented in NFP. We=20
can collaborate to find solution for all of those.


>   I don't think I've seen a single
> production XDP program that doesn't use tail calls.


It looks to me we can manage to add this support.


> Static and dynamic linking
> is coming. Wraping one bpf feature at a time with virtio api is never goi=
ng to
> be complete.


It's a common problem for hardware that want to implement eBPF=20
offloading, not a virtio specific one.


> How FDs are going to be passed back? OBJ_GET_INFO_BY_FD ?
> OBJ_PIN/GET ? Where bpffs is going to live ?


If we want pinning work in the case of virt, it should live in both host=20
and guest probably.


>   Any realistic XDP application will
> be using a lot more than single self contained XDP prog with hash and arr=
ay
> maps.


It's possible if we want to use XDP offloading to accelerate VNF which=20
often has simple logic.


> It feels that the whole sys_bpf needs to be forwarded as a whole from
> guest into host. In case of true hw offload the host is managing HW. So i=
t
> doesn't forward syscalls into the driver. The offload from guest into hos=
t is
> different. BPF can be seen as a resource that host provides and guest ker=
nel
> plus qemu would be forwarding requests between guest user space and host
> kernel. Like sys_bpf(BPF_MAP_CREATE) can passthrough into the host direct=
ly.
> The FD that hosts sees would need a corresponding mirror FD in the guest.=
 There
> are still questions about bpffs paths, but the main issue of
> one-feature-at-a-time will be addressed in such approach.


We try to follow what NFP did by starting from a fraction of the whole=20
eBPF features. It would be very hard to have all eBPF features=20
implemented from the start.=C2=A0 It would be helpful to clarify what's the=
=20
minimal set of features that you want to have from the start.


> There could be other
> solutions, of course.
>
>

Suggestions are welcomed.

Thanks

