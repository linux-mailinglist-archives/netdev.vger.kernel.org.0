Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E511284B0F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgJFLpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgJFLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601984752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dm2UtfzYXYdSOQnTVEkNER947es3Z2MFYURE38j/5RI=;
        b=Vvd8i5rhUBBoKmnst88WMI8r5Qub+7gXkUE44Dv0l5jDxkJXjsIwIBxoVz47R0aK/V3G0/
        povEz9Df8rHtx/Rj3jKbm3ePA3kpcFcUgw15sOgokMYcT0vg+hjuNtfpH/KUKBzXnulgq/
        odbD7L3UfK5I2VJsQxnNbnEpcqO14lE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-WVH2UPTRPj2t91wPEgNP5g-1; Tue, 06 Oct 2020 07:45:48 -0400
X-MC-Unique: WVH2UPTRPj2t91wPEgNP5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95FAF107AFD1;
        Tue,  6 Oct 2020 11:45:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD1FC702E7;
        Tue,  6 Oct 2020 11:45:36 +0000 (UTC)
Date:   Tue, 6 Oct 2020 13:45:35 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>, brouer@redhat.com
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
Message-ID: <20201006134535.08e1dbe5@carbon>
In-Reply-To: <5f68eb19cc0a2_17370208c9@john-XPS-13-9370.notmuch>
References: <20200917143846.37ce43a0@carbon>
        <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
        <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
        <20200918120016.7007f437@carbon>
        <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
        <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
        <20200921144953.6456d47d@carbon>
        <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
        <5f68eb19cc0a2_17370208c9@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 11:04:09 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Daniel Borkmann wrote:
> > On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote: =20
> > > On Mon, 21 Sep 2020 11:37:18 +0100
> > > Lorenz Bauer <lmb@cloudflare.com> wrote: =20
> > >> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.=
com> wrote: =20
> > >>>    =20
> > >>>> This is a good point.  As bpf_skb_adjust_room() can just be run af=
ter
> > >>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> > >>>> doesn't make much sense.  As clever/bad BPF program can then avoid=
 the
> > >>>> MTU check anyhow.  This basically means that we have to do the MTU
> > >>>> check (again) on kernel side anyhow to catch such clever/bad BPF
> > >>>> programs.  (And I don't like wasting cycles on doing the same chec=
k two
> > >>>> times). =20
> > >>>
> > >>> If you get rid of the check in bpf_redirect() you might as well get
> > >>> rid of *all* the checks for excessive mtu in all the helpers that
> > >>> adjust packet size one way or another way.  They *all* then become
> > >>> useless overhead.
> > >>>
[...]
> >=20
> > Sorry for jumping in late here... one thing that is not clear to me is =
that if
> > we are fully sure that skb is dropped by stack anyway due to invalid MT=
U (redirect
> > to ingress does this via dev_forward_skb(), it's not fully clear to me =
whether it's
> > also the case for the dev_queue_xmiy()), then why not dropping all the =
MTU checks
> > aside from SKB_MAX_ALLOC sanity check for BPF helpers and have somethin=
g like a
> > device object (similar to e.g. TCP sockets) exposed to BPF prog where w=
e can retrieve
> > the object and read dev->mtu from the prog, so the BPF program could th=
en do the
> > "exception" handling internally w/o extra prog needed (we also already =
expose whether
> > skb is GSO or not).
> >=20
> > Thanks,
> > Daniel =20
>=20
> My $.02 is MTU should only apply to transmitted packets so redirect to
> ingress should be OK. Then on transmit shouldn't the user know the MTU
> on their devices?

I like the point that "MTU should only apply to transmitted packets".=20
=20
> I'm for dropping all the MTU checks and if a driver tosses a packet then
> the user should be more careful. Having a bpf helper to check MTU of a
> dev seems useful although the workaround would be a map the user could
> put the max MTU in. Of course that would be a bit fragile if the BPF prog=
ram
> and person managing MTU are not in-sync.

I'm coding this up. Dropping all the MTU checks in helpers, but adding
helper to lookup/check the MTU.  I've also extended the bpf_fib_lookup
to return MTU value (it already does MTU check), as it can be more
specific.

The problematic code path seems to be when TC-ingress redirect packet
to egress on another netdev, then the normal netstack MTU checks are
skipped and driver level will not catch any MTU violation (only checked
ixgbe code path).

First I looked at adding MTU check in the egress code path of
skb_do_redirect() prior to calling dev_queue_xmit(), but I found this
to be the wrong approach.  This is because it is still possible to run
another BPF egress program that will shrink/consume headers, which will
make packet comply with netdev MTU. This use-case might already be in
production use (allowed if ingress MTU is larger than egress MTU).

Instead I'm currently coding up doing the MTU check after
sch_handle_egress() step, for the cases that require this.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

