Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D62FD4BA
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390562AbhATP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:59:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388332AbhATP6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611158243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oUUOyV362+OhSybPskP69Na+MM+YsUEXsb1euz9ofeY=;
        b=FyXUnahsgz5/sTqeuPhiM21grKi+WspWYgQaVxYlqvqXEUCPJ+bV/JQ4QjTz2TOcxdaRKn
        GpwIuDbxQORgUH7GwFq+4e5JMkJeYPWWlGj6V26cRpASFyMtw2RzPzBFZOAN4hFRphPR3X
        SzhUtsUw+kclLMVWjstS+cbayNu9iCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-nl600YWCOFaFTKJEi_-O1g-1; Wed, 20 Jan 2021 10:57:19 -0500
X-MC-Unique: nl600YWCOFaFTKJEi_-O1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDF6C8066EA;
        Wed, 20 Jan 2021 15:57:16 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B60882C01B;
        Wed, 20 Jan 2021 15:57:09 +0000 (UTC)
Date:   Wed, 20 Jan 2021 16:57:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
        <kuba@kernel.org>, <jonathan.lemon@gmail.com>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>,
        <ciara.loftus@intel.com>, <weqaar.a.janjua@intel.com>
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
Message-ID: <20210120165708.243f83cb@carbon>
In-Reply-To: <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
        <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 15:15:22 +0200
Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

> On 2021-01-19 17:50, Bj=C3=B6rn T=C3=B6pel wrote:
> > This series extends bind() for XDP sockets, so that the bound socket
> > is added to the netdev_rx_queue _rx array in the netdevice. We call
> > this to register the socket. To redirect packets to the registered
> > socket, a new BPF helper is used: bpf_redirect_xsk().
> >=20
> > For shared XDP sockets, only the first bound socket is
> > registered. Users that need more complex setup has to use XSKMAP and
> > bpf_redirect_map().
> >=20
> > Now, why would one use bpf_redirect_xsk() over the regular
> > bpf_redirect_map() helper?
> >=20
> > * Better performance!
> > * Convenience; Most user use one socket per queue. This scenario is
> >    what registered sockets support. There is no need to create an
> >    XSKMAP. This can also reduce complexity from containerized setups,
> >    where users might what to use XDP sockets without CAP_SYS_ADMIN
> >    capabilities.

I'm buying into the convenience and reduce complexity, and XDP sockets
without CAP_SYS_ADMIN into containers.

People might be surprised that I'm actually NOT buying into the better
performance argument here.  At these speeds we are basically comparing
how close we are to zero (and have to use nanosec time scale for our
comparisons), more below.

=20
> > The first patch restructures xdp_do_redirect() a bit, to make it
> > easier to add the new helper. This restructure also give us a slight
> > performance benefit. The following three patches extends bind() and
> > adds the new helper. After that, two libbpf patches that selects XDP
> > program based on what kernel is running. Finally, selftests for the new
> > functionality is added.
> >=20
> > Note that the libbpf "auto-selection" is based on kernel version, so
> > it is hard coded to the "-next" version (5.12). If you would like to
> > try this is out, you will need to change the libbpf patch locally!
> >=20
> > Thanks to Maciej and Magnus for the internal review/comments!
> >=20
> > Performance (rxdrop, zero-copy)
> >=20
> > Baseline
> > Two cores:                   21.3 Mpps
> > One core:                    24.5 Mpps =20
>=20
> Two cores is slower? It used to be faster all the time, didn't it?
>=20
> > Patched
> > Two cores, bpf_redirect_map: 21.7 Mpps + 2%
> > One core, bpf_redirect_map:  24.9 Mpps + 2%
> >=20
> > Two cores, bpf_redirect_xsk: 24.0 Mpps +13% =20
>=20
> Nice, impressive improvement!

I do appreciate you work and performance optimizations at this level,
because when we are using this few CPU cycles per packet, then it is
really hard to find new ways to reduce cycles further.

Thank for you saying +13% instead of saying +2.7 Mpps.
It *is* impressive to basically reduce cycles with 13%.

 21.3 Mpps =3D 46.94 nanosec per packet
 24.0 Mpps =3D 41.66 nanosec per packet

 21.3 Mpps -> 24.0 Mpps =3D 5.28 nanosec saved

On my 3.60GHz testlab machine that gives me 19 cycles.

=20
> > One core, bpf_redirect_xsk:  25.5 Mpps + 4%
> >

 24.5 Mpps -> 25.5 Mpps =3D 1.6 nanosec saved

At this point with saving 1.6 ns this is around the cost of a function call=
 1.3 ns.


We still need these optimization in the kernel, but end-users in
userspace are very quickly going to waste the 19 cycles we found.
I still support/believe that the OS need to have a little overhead as
possible, but for me 42 nanosec overhead is close to zero overhead. For
comparison, I just ran a udp_sink[3] test, and it "cost" 625 ns for
delivery of UDP packets into socket (almost 15 times slower).

I guess my point is that with XDP we have already achieved and exceeded
(my original) performance goals, making it even faster is just showing off =
;-P
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib=
/time_bench_sample.c
[2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib=
/time_bench_memset.c
[3] https://github.com/netoptimizer/network-testing/blob/master/src/udp_sin=
k.c

