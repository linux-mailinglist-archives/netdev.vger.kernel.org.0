Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D01261712
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgIHRY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731742AbgIHRYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 13:24:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB959206B5;
        Tue,  8 Sep 2020 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599585883;
        bh=G0TuQ82fo+GvEL2cxufvVOauUBhWkmjojqObsOrnW3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A8EAdpexRDHFNVyoeRKruq7rvuO4/s7lZFJrsAj9lHWyN3xDZShJg0vUmdwjEmKqd
         AZVxlayjy5Skf/iTKz0yalbe/v+rDusInFU/cp6U18+gmju+KC77+8UxgnnIT6xYb2
         6dvUfcZwRmaJ8l04YCSKmjf2lR1IJW+MmtV8iBWc=
Date:   Tue, 8 Sep 2020 10:24:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
Message-ID: <20200908102438.28351aab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8f698ac5-916f-9bb0-cce2-f00fba6ba407@intel.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904162751.632c4443@carbon>
        <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
        <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
        <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8f698ac5-916f-9bb0-cce2-f00fba6ba407@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 08:58:30 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> >> As for this patch set, I think it would make sense to pull it in since
> >> it makes the single-core scenario *much* better, and it is pretty
> >> simple. Then do the application polling as another, potentially,
> >> improvement series. =20
> >=20
> > Up to you, it's extra code in the driver so mostly your code to
> > maintain.
> >=20
> > I think that if we implement what I described above - everyone will
> > use that on a single core setup, so this set would be dead code
> > (assuming RQ is sized appropriately). But again, your call :)
>=20
> Now, I agree that the busy-poll you describe above would be the best
> option, but from my perspective it's a much larger set that involves
> experimenting. I will explore that, but I still think this series should
> go in sooner to make the single core scenario usable *today*.
>=20
> Ok, back to the busy-poll ideas. I'll call your idea "strict busy-poll",
> i.e. the NAPI loop is *only* driven by userland, and interrupts stay
> disabled. "Syscall driven poll-mode driver". :-)
>=20
> On the driver side (again, only talking Intel here, since that's what I
> know the details of), the NAPI context would only cover AF_XDP queues,
> so that other queues are not starved.
>=20
> Any ideas how strict busy-poll would look, API/implmentation-wise? An
> option only for AF_XDP sockets? Would this make sense to regular
> sockets? If so, maybe extend the existing NAPI busy-poll with a "strict"
> mode?

For AF_XDP and other sockets I think it should be quite straightforward.

For AF_XDP just implement current busy poll.

Then for all socket types add a new sockopt which sets "timeout" on how
long the IRQs can be suppressed for (we don't want application crash or
hang to knock the system off the network), or just enables the feature
and the timeout is from a sysctl.

Then make sure that at the end of polling napi doesn't get scheduled,
and set some bit which will prevent napi_schedule_prep() from letting
normal IRQ processing from scheduling it, too. Set a timer for the
timeout handling to undo all this.

What I haven't figured out in my head is how/if this relates to the
ongoing wq/threaded NAPI polling work =F0=9F=A4=94 but that shouldn't stop =
you.

> I'll start playing around a bit, but again, I think this simple series
> should go in just to make AF_XDP single core usable *today*.

No objection from me.
