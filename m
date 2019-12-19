Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F81126E07
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfLSTdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:33:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27891 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726836AbfLSTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:33:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576784022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCvqPY+vnwTd5bbgsCTQ33owNN9RX4miC0ItjklZDLs=;
        b=IGOFwaaTbT9Yo7K56lvy899yOA4jzPugV7aUQeRDyW+Uj/dT1SAPBhRtxRz+XfT9rOQwb2
        b2bu03SnFBz2T4LLCH5sBfeNfRKQvjhvIW3WIAmc1kV0d1DQo/xXHld29gHwtreAry+GsK
        U/hpuwvTm87OgJk0Unv5by4gXFpUhv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-Cxcfj4yKM8a6uSiQ0x2sFA-1; Thu, 19 Dec 2019 14:33:38 -0500
X-MC-Unique: Cxcfj4yKM8a6uSiQ0x2sFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4C86800D48;
        Thu, 19 Dec 2019 19:33:36 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B536310013A1;
        Thu, 19 Dec 2019 19:33:30 +0000 (UTC)
Date:   Thu, 19 Dec 2019 20:33:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191219203329.75d4bead@carbon>
In-Reply-To: <CAEf4BzZab=FvCuvKOKsj0M5RRoGuuXW2ME5EoDuqT8sJOd2Xtg@mail.gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
        <20191218121132.4023f4f1@carbon>
        <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
        <20191218130346.1a346606@carbon>
        <CAEf4BzZab=FvCuvKOKsj0M5RRoGuuXW2ME5EoDuqT8sJOd2Xtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 16:39:08 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Wed, Dec 18, 2019 at 4:04 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Wed, 18 Dec 2019 12:39:53 +0100
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > =20
> > > On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.c=
om> wrote: =20
> > > >
> > > > On Wed, 18 Dec 2019 11:53:52 +0100
> > > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > > > =20
> > > > >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
> > > > >
> > > > >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> > > > >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> > > > >   XDP-RX          20      7723038        0           0
> > > > >   XDP-RX          total   7723038        0
> > > > >   cpumap_kthread  total   0              0           0
> > > > >   redirect_err    total   0              0
> > > > >   xdp_exception   total   0              0 =20
> > > >
> > > > Hmm... I'm missing some counters on the kthread side.
> > > > =20
> > >
> > > Oh? Any ideas why? I just ran the upstream sample straight off. =20
> >
> > Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
> > XDP samples to libbpf usage") (Cc Maciej).
> >
> > The old bpf_load.c will auto attach the tracepoints... for and libbpf
> > you have to be explicit about it. =20
>=20
> ... or you can use skeleton, which will auto-attach them as well,
> provided BPF program's section names follow expected naming
> convention. So it might be a good idea to try it out.

To Andrii, can you provide some more info on how to use this new
skeleton system of yours?  (Pointers to code examples?)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

