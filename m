Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6FB3803C5
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhENGvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:51:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231741AbhENGvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620975006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WryXNKzHBf+U+FRAhkOnw8sHZGpDGcdZ7IuPAI0tQ+s=;
        b=ZiIPhshQ5rav6BgMZ7eg2K+n0RQe94JIGuirHPxc88kQwPuiGpWMUKWblMLBePKXFAPZaT
        THsZcWTsOP9Pey4t6mYXt63QnMLEP3CV/Stu0QBgguKb6V7AUU4I36KncMwp3pRjA/PNMa
        dH3p5XQSvb26SxN8yfoaEyRppNp3fuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-xlw6VoJYNaOK-LsVZslTEA-1; Fri, 14 May 2021 02:50:02 -0400
X-MC-Unique: xlw6VoJYNaOK-LsVZslTEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44CB46D4E0;
        Fri, 14 May 2021 06:50:01 +0000 (UTC)
Received: from carbon (unknown [10.36.110.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AB7560BF1;
        Fri, 14 May 2021 06:49:57 +0000 (UTC)
Date:   Fri, 14 May 2021 08:49:56 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCH RESEND v11 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210514084956.2e41f3dd@carbon>
In-Reply-To: <20210513070447.1878448-2-liuhangbin@gmail.com>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
        <20210513070447.1878448-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 15:04:44 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
>=20
> This changes the devmap XDP program support to run the program when the
> bulk queue is flushed instead of before the frame is enqueued. This has
> a couple of benefits:
>=20
> - It "sorts" the packets by destination devmap entry, and then runs the
>   same BPF program on all the packets in sequence. This ensures that we
>   keep the XDP program and destination device properties hot in I-cache.
>=20
> - It makes the multicast implementation simpler because it can just
>   enqueue packets using bq_enqueue() without having to deal with the
>   devmap program at all.
>=20
> The drawback is that if the devmap program drops the packet, the enqueue
> step is redundant. However, arguably this is mostly visible in a
> micro-benchmark, and with more mixed traffic the I-cache benefit should
> win out. The performance impact of just this patch is as follows:
>=20
> Using 2 10Gb i40e NIC, redirecting one to another, or into a veth interfa=
ce,
> which do XDP_DROP on veth peer. With xdp_redirect_map in sample/bpf, send
> pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t =
10 -s 64
>=20
> There are about +/- 0.1M deviation for native testing, the performance
> improved for the base-case, but some drop back with xdp devmap prog attac=
hed.
>=20
> Version          | Test                           | Generic | Native | Na=
tive + 2nd xdp_prog
> 5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M |  8=
.4M
> 5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M |  9=
.8M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M |  8=
.0M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M |  9=
.4M
>=20
> When bq_xmit_all() is called from bq_enqueue(), another packet will
> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush(),
> and only check them once in bq_enqueue() since they are all modified
> together.
>=20
> This change also has the side effect of extending the lifetime of the
> RCU-protected xdp_prog that lives inside the devmap entries: Instead of
> just living for the duration of the XDP program invocation, the
> reference now lives all the way until the bq is flushed. This is safe
> because the bq flush happens at the end of the NAPI poll loop, so
> everything happens between a local_bh_disable()/local_bh_enable() pair.
> However, this is by no means obvious from looking at the call sites; in
> particular, some drivers have an additional rcu_read_lock() around only
> the XDP program invocation, which only confuses matters further.
> Cleaning this up will be done in a separate patch series.
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

For the sake of good order

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

