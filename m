Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F189D19197D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgCXSxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbgCXSxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 14:53:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D5B2074D;
        Tue, 24 Mar 2020 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585076031;
        bh=zbUjVqmOQpHgft4VC/u9Z+h3ICSYIu6L90BtbphGNPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYFW9dgn4FhW7wsomQPnDyFo1ndJIRyy/GrXFbGR1cMpHFb1A3U5iBg6hKB4joVq7
         URoi5mmYwdT+ZRaSNM7KIGwUdexvd8IqCUaPJuk9vuYaRNy1y+crtDvUyn4TT4+yZ4
         x/GnvREx191KhJcE55V7oekwk9p1YIt9lb4n/DNc=
Date:   Tue, 24 Mar 2020 11:53:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200324115349.6447f99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87tv2e10ly.fsf@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 11:57:45 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > If everyone is using libbpf, does kernel system (bpf syscall vs
> > netlink) matter all that much? =20
>=20
> This argument works the other way as well, though: If libbpf can
> abstract the subsystem differences and provide a consistent interface to
> "the BPF world", why does BPF need to impose its own syscall API on the
> networking subsystem?

Hitting the nail on the head there, again :)

Once upon a time when we were pushing for libbpf focus & unification,
one of my main motivations was that a solid library that most people
use give us the ability to provide user space abstractions.

As much as adding new kernel interfaces "to rule them all" is fun, it
has a real cost.
