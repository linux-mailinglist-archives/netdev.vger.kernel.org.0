Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE65124711
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLRMkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:40:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34054 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726545AbfLRMkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576672815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vDXqS2/spb1yIJmrOHtwV66dHgnN5IvboMGxw/Q1J0=;
        b=VA/8yF/BHq53OLVflPHGaqJHtgI9WkAkv4nVqH7XcGDB2pBGCqZKAlLFXvpvvMavVA7lC5
        sk4rEJvVcy4/kuaDxtqoYBL8eyIlJh1sdom0xtpAZX/wC/lBM/ePju7LjDfs83zDsyB0G7
        fLeIwaAPEw9C1fQaFsVVGjjYMZpc/U8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-VT86JVg3Mkau2bWwanSSCQ-1; Wed, 18 Dec 2019 07:40:12 -0500
X-MC-Unique: VT86JVg3Mkau2bWwanSSCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED79F107ACFE;
        Wed, 18 Dec 2019 12:40:09 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59CCB60C18;
        Wed, 18 Dec 2019 12:40:03 +0000 (UTC)
Date:   Wed, 18 Dec 2019 13:40:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191218134001.319349bc@carbon>
In-Reply-To: <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
        <20191218121132.4023f4f1@carbon>
        <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
        <20191218130346.1a346606@carbon>
        <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 13:18:10 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On Wed, 18 Dec 2019 at 13:04, Jesper Dangaard Brouer <brouer@redhat.com> =
wrote:
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
> > you have to be explicit about it.
> >
> > Can I ask you to also run a test with --stress-mode for
> > ./xdp_redirect_cpu, to flush out any potential RCU race-conditions
> > (don't provide output, this is just a robustness test).
> > =20
>=20
> Sure! Other than that, does the command line above make sense? I'm
> blasting UDP packets to core 20, and the idea was to re-route them to
> 22.

Yes, and I love that you are using CPUMAP xdp_redirect_cpu as a test.

Explaining what is doing on (so you can say if this is what you wanted
to test):

The "XDP-RX" number is the raw XDP redirect number, but the remote CPU,
where the network stack is started, cannot operate at 7.7Mpps.  Which the
lacking tracepoint numbers should have shown. You still can observe
results via nstat, e.g.:

 # nstat -n && sleep 1 && nstat

On the remote CPU 22, the SKB will be constructed, and likely dropped
due overloading network stack and due to not having an UDP listen port.

I sometimes use:
 # iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
To drop the UDP packets in a earlier and consistent stage.

The CPUMAP have carefully been designed to avoid that a "producer" can
be slowed down by memory operations done by the "consumer", this is
mostly achieved via ptr_ring and careful bulking (cache-lines).  As
your driver i40e doesn't have 'page_pool', then you are not affected by
the return channel.

Funny test/details: i40e uses a refcnt recycle scheme, based off the
size of the RX-ring, thus it is affected by a longer outstanding queue.
The CPUMAP have an intermediate queue, that will be full in this
overload setting.  Try to increase or decrease the parameter --qsize
(remember to place it as first argument), and see if this was the
limiting factor for your XDP-RX number.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

