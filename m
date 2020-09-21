Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC92272430
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIUMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:50:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46366 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgIUMu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600692623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8FYoiLkZ3dhNRNCRps//s4ti79qQ2LdE4GQS/Ewevk=;
        b=Jpxl/HrCJ5W41PuLBDbzz8D69vOpH5LTMNII8qP3/NHynAM5kA0544R6kMmRrfPZNIOR7d
        8gsRmP3vkgIeo3nXR+b1y02EznWj1Seefev/ZrqFqkhgShZ2sgVbqir1qIHOrkmgLIt2gT
        JUSKHmUn/BL5FJKovn/Rts1dGBUc7+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-2dfw4JwMMLeIDt5okIbtug-1; Mon, 21 Sep 2020 08:50:14 -0400
X-MC-Unique: 2dfw4JwMMLeIDt5okIbtug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FABC802B6B;
        Mon, 21 Sep 2020 12:50:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBB5B5C1DC;
        Mon, 21 Sep 2020 12:49:54 +0000 (UTC)
Date:   Mon, 21 Sep 2020 14:49:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
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
Message-ID: <20200921144953.6456d47d@carbon>
In-Reply-To: <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
References: <20200917143846.37ce43a0@carbon>
        <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
        <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
        <20200918120016.7007f437@carbon>
        <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
        <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 11:37:18 +0100
Lorenz Bauer <lmb@cloudflare.com> wrote:

> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
> > =20
> > > This is a good point.  As bpf_skb_adjust_room() can just be run after
> > > bpf_redirect() call, then a MTU check in bpf_redirect() actually
> > > doesn't make much sense.  As clever/bad BPF program can then avoid the
> > > MTU check anyhow.  This basically means that we have to do the MTU
> > > check (again) on kernel side anyhow to catch such clever/bad BPF
> > > programs.  (And I don't like wasting cycles on doing the same check t=
wo
> > > times). =20
> >
> > If you get rid of the check in bpf_redirect() you might as well get
> > rid of *all* the checks for excessive mtu in all the helpers that
> > adjust packet size one way or another way.  They *all* then become
> > useless overhead.
> >
> > I don't like that.  There may be something the bpf program could do to
> > react to the error condition (for example in my case, not modify
> > things and just let the core stack deal with things - which will
> > probably just generate packet too big icmp error).
> >
> > btw. right now our forwarding programs first adjust the packet size
> > then call bpf_redirect() and almost immediately return what it
> > returned.
> >
> > but this could I think easily be changed to reverse the ordering, so
> > we wouldn't increase packet size before the core stack was informed we
> > would be forwarding via a different interface. =20
>=20
> We do the same, except that we also use XDP_TX when appropriate. This
> complicates the matter, because there is no helper call we could
> return an error from.

Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect the
MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also
happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
audited the drivers when I implemented xdp_buff.frame_sz, and they
handled (or I added) handling against max HW MTU. E.g. mlx5 [1].

[1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethernet/m=
ellanox/mlx5/core/en/xdp.c#L267



> My preference would be to have three helpers: get MTU for a device,
> redirect ctx to a device (with MTU check), resize ctx (without MTU
> check) but that doesn't work with XDP_TX. Your idea of doing checks
> in redirect and adjust_room is pragmatic and seems easier to
> implement.
=20
I do like this plan/proposal (with 3 helpers), but it is not possible
with current API.  The main problem is the current bpf_redirect API
doesn't provide the ctx, so we cannot do the check in the BPF-helper.

Are you saying we should create a new bpf_redirect API (that incl packet ct=
x)?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

