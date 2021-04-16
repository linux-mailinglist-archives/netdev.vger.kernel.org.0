Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2FE3626B7
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbhDPR1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235935AbhDPR1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618594016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jST+c6JvcilFW3RUQaV4kF2IbtPXcWWGuH6bp9G+J2U=;
        b=YTXjVMOnA7Mm68ga2pRRrFKg3UWgGVuzMMMKw4ZLXI6kfUd3cchLLtI6IHb6L8un+p/flY
        eUzeCiyCnZyEFYauDDV61ZmdAUJCbIFGdif9PL7axSt9TtxMu7SsZWPoDYrbLOaBqW61M1
        RhvLp1OHigPZWfj7Osg0Kil2/u0a0ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-7XBOMTXGOhW4R3MyIWzzqQ-1; Fri, 16 Apr 2021 13:26:52 -0400
X-MC-Unique: 7XBOMTXGOhW4R3MyIWzzqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884D287A83B;
        Fri, 16 Apr 2021 17:26:51 +0000 (UTC)
Received: from ovpn-114-195.ams2.redhat.com (ovpn-114-195.ams2.redhat.com [10.36.114.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03FDA10023B5;
        Fri, 16 Apr 2021 17:26:46 +0000 (UTC)
Message-ID: <9111f5868bac3d3d4de52263f6df8da051cdfcf9.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Fri, 16 Apr 2021 19:26:45 +0200
In-Reply-To: <87blaegsda.fsf@toke.dk>
References: <cover.1617965243.git.pabeni@redhat.com>
         <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
         <87v98vtsgg.fsf@toke.dk>
         <d9b5f599380d32a28026d5a758cc46edf2ba23d8.camel@redhat.com>
         <87blaegsda.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-16 at 17:29 +0200, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> > On Fri, 2021-04-09 at 16:58 +0200, Toke Høiland-Jørgensen wrote:
> > > Paolo Abeni <pabeni@redhat.com> writes:
> > > 
> > > > Currently the veth device has the GRO feature bit set, even if
> > > > no GRO aggregation is possible with the default configuration,
> > > > as the veth device does not hook into the GRO engine.
> > > > 
> > > > Flipping the GRO feature bit from user-space is a no-op, unless
> > > > XDP is enabled. In such scenario GRO could actually take place, but
> > > > TSO is forced to off on the peer device.
> > > > 
> > > > This change allow user-space to really control the GRO feature, with
> > > > no need for an XDP program.
> > > > 
> > > > The GRO feature bit is now cleared by default - so that there are no
> > > > user-visible behavior changes with the default configuration.
> > > > 
> > > > When the GRO bit is set, the per-queue NAPI instances are initialized
> > > > and registered. On xmit, when napi instances are available, we try
> > > > to use them.
> > > 
> > > Am I mistaken in thinking that this also makes XDP redirect into a veth
> > > work without having to load an XDP program on the peer device? That's
> > > been a long-outstanding thing we've been meaning to fix, so that would
> > > be awesome! :)
> > 
> > I have not experimented that, and I admit gross ignorance WRT this
> > argument, but AFAICS the needed bits to get XDP redirect working on
> > veth are the ptr_ring initialization and the napi instance available.
> > 
> > With this patch both are in place when GRO is enabled, so I guess XPD
> > redirect should work, too (modulo bugs for untested scenario).
> 
> OK, finally got around to testing this; it doesn't quite work with just
> your patch, because veth_xdp_xmit() still checks for rq->xdp_prog
> instead of rq->napi. Fixing this indeed enabled veth to be an
> XDP_REDIRECT target without an XDP program loaded on the peer. So yay!
> I'll send a followup fixing that check.

Thank you for double checking!

> So with this we seem to have some nice improvements in both
> functionality and performance when GRO is turned on; so any reason why
> we shouldn't just flip the default to on?

Uhmmm... patch 3/4 should avoid the GRO overhead for most cases where
we can't leverage the aggregation benefit, but I'm not 110% sure that
enabling GRO by default will not cause performance regressions in some
scenarios.

It this proves to be always a win we can still change the default
later, I think.

Cheers,

Paolo


