Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8396B124668
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLRMEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:04:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfLRMEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:04:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576670640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9oNiKDgk5MckkZyQbcIpTr/UDbrx/rihO1sn62VSoM=;
        b=B9yXTdG1bJC3O0V/jza86Nw9oSQskt+xce2aKcc01sSFUEW1tWy1dkDrcqzSHnkeRGoWAJ
        oFa2P82nvL3MUjrqrmsEBMrxQ8p+y7QnR+xKIBpgD+lMZPZULzJYaOq2SLwqo1XqKOPxgq
        nrIk4qhl5CL3n0nhOGfxBq/kPhAu5R8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-0QdREHYNP_KmiqODgNd6mQ-1; Wed, 18 Dec 2019 07:03:55 -0500
X-MC-Unique: 0QdREHYNP_KmiqODgNd6mQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F868800EBF;
        Wed, 18 Dec 2019 12:03:54 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C04AB5C28D;
        Wed, 18 Dec 2019 12:03:47 +0000 (UTC)
Date:   Wed, 18 Dec 2019 13:03:46 +0100
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
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191218130346.1a346606@carbon>
In-Reply-To: <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
        <20191218121132.4023f4f1@carbon>
        <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 12:39:53 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.com> =
wrote:
> >
> > On Wed, 18 Dec 2019 11:53:52 +0100
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > =20
> > >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
> > >
> > >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> > >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> > >   XDP-RX          20      7723038        0           0
> > >   XDP-RX          total   7723038        0
> > >   cpumap_kthread  total   0              0           0
> > >   redirect_err    total   0              0
> > >   xdp_exception   total   0              0 =20
> >
> > Hmm... I'm missing some counters on the kthread side.
> > =20
>=20
> Oh? Any ideas why? I just ran the upstream sample straight off.

Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
XDP samples to libbpf usage") (Cc Maciej).

The old bpf_load.c will auto attach the tracepoints... for and libbpf
you have to be explicit about it.

Can I ask you to also run a test with --stress-mode for
./xdp_redirect_cpu, to flush out any potential RCU race-conditions
(don't provide output, this is just a robustness test).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

