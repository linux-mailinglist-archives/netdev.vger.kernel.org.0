Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCEC163EFB
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 09:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgBSI03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 03:26:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726001AbgBSI03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 03:26:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582100787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7GifVFb+0Kxr3UdPmgjUJ5WdA1mThVqvy94SyaGNd6c=;
        b=WC75XsfJ/cioReVuc53ep0mNVB2kbDWMGlhcgsrugKxDEQk+I9rKPZOkkmuzmU096bqdpS
        GPnlX8Z57QXLR9dLoIcpkGEaTw3bQ6imtFBpROzYkM4LnNRCZkmpmyRSQ2z+k+tzGDYh1t
        RT0mySonNC9UKrRHqhqShFXi9k2I9Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-msCJ53M5OICQ-DahCdb5Lw-1; Wed, 19 Feb 2020 03:26:25 -0500
X-MC-Unique: msCJ53M5OICQ-DahCdb5Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2D8118AB2C3;
        Wed, 19 Feb 2020 08:26:23 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0FD55D9E5;
        Wed, 19 Feb 2020 08:26:12 +0000 (UTC)
Date:   Wed, 19 Feb 2020 09:26:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     toke@redhat.com, kuba@kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, andrew@lunn.ch, dsahern@kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200219092611.1060dbb0@carbon>
In-Reply-To: <20200218.154713.1411536344737312845.davem@davemloft.net>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
        <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN>
        <87eeury1ph.fsf@toke.dk>
        <20200218.154713.1411536344737312845.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 15:47:13 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Tue, 18 Feb 2020 23:23:22 +0100
>=20
> > Jakub Kicinski <kuba@kernel.org> writes:
> >  =20
> >> On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote: =20
> >>> Introduce "rx" prefix in the name scheme for xdp counters
> >>> on rx path.
> >>> Differentiate between XDP_TX and ndo_xdp_xmit counters
> >>>=20
> >>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org> =20
> >>
> >> Sorry for coming in late.
> >>
> >> I thought the ability to attach a BPF program to a fexit of another BPF
> >> program will put an end to these unnecessary statistics. IOW I maintain
> >> my position that there should be no ethtool stats for XDP.
> >>
> >> As discussed before real life BPF progs will maintain their own stats
> >> at the granularity of their choosing, so we're just wasting datapath
> >> cycles.

Well, in practice we see that real-life[1] BPF progs don't maintain
stats (as I agree they _should_), and an end-user of this showed up on
XDP-newbies list, and I helped out, going in the complete wrong
direction, when it was simply the XDP prog dropping these packets, due
to builtin rate limiter.  It would have been so much easier to identify
via a simple counter, that I could have asked for from the sysadm.

[1] https://gitlab.com/Dreae/compressor/

> >>
> >> The previous argument that the BPF prog stats are out of admin control
> >> is no longer true with the fexit option (IIUC how that works). =20
> >=20
> > So you're proposing an admin that wants to keep track of XDP has to
> > (permantently?) attach an fexit program to every running XDP program and
> > use that to keep statistics? But presumably he'd first need to discover
> > that XDP is enabled; which the ethtool stats is a good hint for :) =20
>=20
> Really, mistakes happen and a poorly implemented or inserted fexit
> module should not be a reason to not have access to accurate and
> working statistics for fundamental events.

Yes, exactly.  These statistics counters are only "basic" XDP events,
that e.g. don't count the bytes.  They are only the first level of
identifying what the system is doing.  When digging deeper we need
tracepoint and fexit.

> I am therefore totally against requiring fexit for this functionality.
> If you want more sophisticated events or custome ones, sure, but not
> for this baseline stuff.

I fully agree.

> I do, however, think we need a way to turn off these counter bumps if
> the user wishes to do so for maximum performance.

I sort of agree, but having a mechanism to turn on/off these "basic"
counters might cost more than just always having them always on.  Even
the static_key infra will create sub-optimal code, which can throw-off
the advantage.

Maybe it is worth pointing out, that Lorenzo's code is doing something
smart, which lowers the overhead.  The stats struct (mvneta_stats) that
is passed to mvneta_run_xdp is not global, it only counts events in
this NAPI cycle, and is first transferred to the global counters when
drivers NAPI functions end, calling mvneta_update_stats().  (We can
optimized this a bit more on this HW as it is not necessary to have u64
long counters for these temp/non-global stats).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

