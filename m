Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D608014F912
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 18:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgBARID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 12:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgBARIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 12:08:02 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D1A206D3;
        Sat,  1 Feb 2020 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580576882;
        bh=NWbZSUf90d7MXd1QTUP9Yw/ZMOYzUy8WrdA0zUkytsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CCw2DOQ6uJ0jiRb7cLWD5yKR3iq4nG5b4JhK9/4yMKa8DyjlqRmmriaFyZx/xlen+
         RasaNRXn0JjwosxSXP5tHR8uyXfFagxSp2csGs0RcoPi9iQHCQMC1FoCQmR2Y4p7cu
         Fiw0j5GaGmT12zNvjaXFFQAtry6VTtSxPRaz+9oE=
Date:   Sat, 1 Feb 2020 09:08:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, jbrouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <87ftfue0mw.fsf@toke.dk>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
        <20200128055752.617aebc7@cakuba>
        <87ftfue0mw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 01 Feb 2020 17:24:39 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > I'm weary of partially implemented XDP features, EGRESS prog does us
> > no good when most drivers didn't yet catch up with the REDIRECTs. =20
>=20
> I kinda agree with this; but on the other hand, if we have to wait for
> all drivers to catch up, that would mean we couldn't add *anything*
> new that requires driver changes, which is not ideal either :/

If EGRESS is only for XDP frames we could try to hide the handling in
the core (with slight changes to XDP_TX handling in the drivers),
making drivers smaller and XDP feature velocity higher.

I think loading the drivers with complexity is hurting us in so many
ways..

> > And we're adding this before we considered the queuing problem.
> >
> > But if I'm alone in thinking this, and I'm not convincing anyone we
> > can move on :) =20
>=20
> I do share your concern that this will end up being incompatible with
> whatever solution we end up with for queueing. However, I don't
> necessarily think it will: I view the XDP egress hook as something
> that in any case will run *after* packets are dequeued from whichever
> intermediate queueing it has been through (if any). I think such a
> hook is missing in any case; for instance, it's currently impossible
> to implement something like CoDel (which needs to know how long a
> packet spent in the queue) in eBPF.

Possibly =F0=9F=A4=94 I don't have a good mental image of how the XDP queui=
ng
would work.

Maybe once the queuing primitives are defined they can easily be
hooked into the Qdisc layer. With Martin's recent work all we need is=20
a fifo that can store skb pointers, really...

It'd be good if the BPF queuing could replace TC Qdiscs, rather than=20
layer underneath.
