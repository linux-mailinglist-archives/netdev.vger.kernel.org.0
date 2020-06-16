Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600881FABED
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgFPJJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:09:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgFPJJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 05:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592298577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51BAkyLImqbEYwUqTNMdCgD6S574WH5eIIC98MtFJoI=;
        b=M7yy8BTy3gVnT+6p86i/ReWEnJIGM2pGXc/o0Sr7cKKHtErnS0f2e/DpaIx/fAVeHzXfIw
        onRdRvg2gEKffM5UEG/PjQbCCGGbELw2pfSM7F7Pp7zL+oX0iLx4Ce39dvUbLwBH/w32CV
        phtNN8MrzA1ojL1rIOaoXIeR31hwL4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-mQL88YqeOtafgpkKkzIXVw-1; Tue, 16 Jun 2020 05:09:35 -0400
X-MC-Unique: mQL88YqeOtafgpkKkzIXVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 444208BF94F;
        Tue, 16 Jun 2020 09:09:34 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E10C60BEC;
        Tue, 16 Jun 2020 09:09:23 +0000 (UTC)
Date:   Tue, 16 Jun 2020 11:09:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200616110922.1219ec5e@carbon>
In-Reply-To: <87lfld1krx.fsf@toke.dk>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200526140539.4103528-1-liuhangbin@gmail.com>
        <87zh9t1xvh.fsf@toke.dk>
        <20200527123858.GH102436@dhcp-12-153.nay.redhat.com>
        <87lfld1krx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 17:04:50 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Hangbin Liu <liuhangbin@gmail.com> writes:
>=20
> > On Wed, May 27, 2020 at 12:21:54PM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote: =20
> >> > The example in patch 2 is functional, but not a lot of effort
> >> > has been made on performance optimisation. I did a simple test(pkt s=
ize 64)
> >> > with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
> >> > arrays:
> >> >
> >> > bpf_redirect_map() with 1 ingress, 1 egress:
> >> > generic path: ~1600k pps
> >> > native path: ~980k pps
> >> >
> >> > bpf_redirect_map_multi() with 1 ingress, 3 egress:
> >> > generic path: ~600k pps
> >> > native path: ~480k pps
> >> >
> >> > bpf_redirect_map_multi() with 1 ingress, 9 egress:
> >> > generic path: ~125k pps
> >> > native path: ~100k pps
> >> >
> >> > The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we=
 loop
> >> > the arrays and do clone skb/xdpf. The native path is slower than gen=
eric
> >> > path as we send skbs by pktgen. So the result looks reasonable. =20
> >>=20
> >> How are you running these tests? Still on virtual devices? We really =
=20
> >
> > I run it with the test topology in patch 2/2. The test is run on physic=
al
> > machines, but I use veth interface. Do you mean use a physical NIC driv=
er
> > for testing? =20
>=20
> Yes, sorry, when I said 'physical machine' I should have also 'physical
> NIC'. We really need to know how the performance of this is on the XDP
> fast path, i.e., when there are no skbs involved at all.
>=20
> > BTW, when using pktgen, I got an panic because the skb don't have enough
> > header room. The code path looks like
> >
> > do_xdp_generic()
> >   - netif_receive_generic_xdp()
> >     - skb_headroom(skb) < XDP_PACKET_HEADROOM
> >       - pskb_expand_head()
> >         - BUG_ON(skb_shared(skb))
> >
> > So I added a draft patch for pktgen, not sure if it has any influence. =
=20
>=20
> Hmm, as Jesper said pktgen was really not intended to be used this way,
> so I guess that's why. I guess I'll let him comment on whether he thinks
> it's worth fixing; or you could send this as a proper patch and see if
> anyone complains about it ;)

Don't use pktgen in this way with veth.  If anything pktgen should
detect that you use pktgen in virtual interfaces and reject/disallow
that you do this.

=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

