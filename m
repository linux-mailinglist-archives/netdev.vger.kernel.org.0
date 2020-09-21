Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238C272C0F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgIUQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:27:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728468AbgIUQ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600705618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2+uwvEiNHa4aouNC9wNaWxR76qMrVPlLtc8ZKmzEB4=;
        b=F4ZGPedA+jEUMlcQ/geC9P6A/AdRJaNWVW54Zd2eNjDwTzYDHiWWSrGNjBtZIPHlERIoMi
        I+fooT3ExPrDs4CWs3FIcRs/cdWnBVSC1P4DnMGRGSVUHnlP2TY7BOoVhz3dvfIuqK2X74
        r/3JF2sOUvT2DyAInbh7trc47m734hg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-xH5kqItFNx2NG482Spac9A-1; Mon, 21 Sep 2020 12:26:51 -0400
X-MC-Unique: xH5kqItFNx2NG482Spac9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A674C393B5;
        Mon, 21 Sep 2020 16:26:49 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A8655D9CD;
        Mon, 21 Sep 2020 16:26:40 +0000 (UTC)
Date:   Mon, 21 Sep 2020 18:26:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3Nr?= =?UTF-8?B?aQ==?= 
        <maze@google.com>, Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>, brouer@redhat.com
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
Message-ID: <20200921182638.5d8343fd@carbon>
In-Reply-To: <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
References: <20200917143846.37ce43a0@carbon>
        <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
        <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
        <20200918120016.7007f437@carbon>
        <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
        <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
        <20200921144953.6456d47d@carbon>
        <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 17:08:17 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote:
> > On Mon, 21 Sep 2020 11:37:18 +0100
> > Lorenz Bauer <lmb@cloudflare.com> wrote: =20
> >> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.co=
m> wrote: =20
> >>>    =20
> >>>> This is a good point.  As bpf_skb_adjust_room() can just be run after
> >>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> >>>> doesn't make much sense.  As clever/bad BPF program can then avoid t=
he
> >>>> MTU check anyhow.  This basically means that we have to do the MTU
> >>>> check (again) on kernel side anyhow to catch such clever/bad BPF
> >>>> programs.  (And I don't like wasting cycles on doing the same check =
two
> >>>> times). =20
> >>>
> >>> If you get rid of the check in bpf_redirect() you might as well get
> >>> rid of *all* the checks for excessive mtu in all the helpers that
> >>> adjust packet size one way or another way.  They *all* then become
> >>> useless overhead.
> >>>
> >>> I don't like that.  There may be something the bpf program could do to
> >>> react to the error condition (for example in my case, not modify
> >>> things and just let the core stack deal with things - which will
> >>> probably just generate packet too big icmp error).
> >>>
> >>> btw. right now our forwarding programs first adjust the packet size
> >>> then call bpf_redirect() and almost immediately return what it
> >>> returned.
> >>>
> >>> but this could I think easily be changed to reverse the ordering, so
> >>> we wouldn't increase packet size before the core stack was informed we
> >>> would be forwarding via a different interface. =20
> >>
> >> We do the same, except that we also use XDP_TX when appropriate. This
> >> complicates the matter, because there is no helper call we could
> >> return an error from. =20
> >=20
> > Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect the
> > MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also
> > happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
> > audited the drivers when I implemented xdp_buff.frame_sz, and they
> > handled (or I added) handling against max HW MTU. E.g. mlx5 [1].
> >=20
> > [1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethern=
et/mellanox/mlx5/core/en/xdp.c#L267
> >  =20
> >> My preference would be to have three helpers: get MTU for a device,
> >> redirect ctx to a device (with MTU check), resize ctx (without MTU
> >> check) but that doesn't work with XDP_TX. Your idea of doing checks
> >> in redirect and adjust_room is pragmatic and seems easier to
> >> implement. =20
> >  =20
> > I do like this plan/proposal (with 3 helpers), but it is not possible
> > with current API.  The main problem is the current bpf_redirect API
> > doesn't provide the ctx, so we cannot do the check in the BPF-helper.
> >=20
> > Are you saying we should create a new bpf_redirect API (that incl packe=
t ctx)? =20
>=20
> Sorry for jumping in late here... one thing that is not clear to me
> is that if we are fully sure that skb is dropped by stack anyway due
> to invalid MTU (redirect to ingress does this via dev_forward_skb(),

Yes, TC-redirecting to *INGRESS* have a slightly relaxed MTU check via
is_skb_forwardable() called via ____dev_forward_skb().  This MTU check
seems redundant as netstack will do MTU checks anyhow.

> it's not fully clear to me whether it's also the case for the
> dev_queue_xmit()),

This seems the problematic case; TC-ingress redirect to netdev-egress,
that basically calls dev_queue_xmit().  I tried to follow the code all
the way into ixgbe driver, and I didn't see any MTU checks.

We might have to add a MTU check here, as it could be considered a
bug/problematic that we allow this. (e.g. netdev with large MTU can
redirect frames larger than MTU of egress netdev).


> then why not dropping all the MTU checks aside
> from SKB_MAX_ALLOC sanity check for BPF helpers=20

I agree, and think that the MTU checks in the BPF-helpers, make little
sense, as we have found ways to circumvent these checks (as discussed
in thread).

> and have something like a device object (similar to e.g. TCP sockets)
> exposed to BPF prog where we can retrieve the object and read
> dev->mtu from the prog, so the BPF program could then do the
> "exception" handling internally w/o extra prog needed (we also
> already expose whether skb is GSO or not).

I do think we need some BPF-helper that allows BPF-prog to lookup MTU
of a netdev, so it can do proper ICMP exception handling.

I looked at doing ICMP exception handling on kernel-side, but realized
that this is not possible at the TC-redirect layer, as we have not
decoded the L3 protocol at this point (e.g. cannot know if I need to
call icmp_send or icmp6_send).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

