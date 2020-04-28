Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF321BC482
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgD1QG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:06:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728130AbgD1QG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:06:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588089986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44TaYzj1mXVkpvAsz6mI1B0uXcADj590Ox/GtOY9fQo=;
        b=ZTg5PiRPjV7+9IpT5TkLZ4ghpg56fHWf1eqGYHGtRpRhb6bVll+jNNMLtwJWp0i63B7A7x
        z9WmPLPR3ix3c4P9akkabXMk8E9Jug6Wg0VtSoNk9lF2zbEYKqS4/MHM5XbV4YFEZtqKdC
        LO03JjJ0noIHMek8sTepBuIllO9LFqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-NjJboJZQOcKT0w8eDYDqBQ-1; Tue, 28 Apr 2020 12:06:23 -0400
X-MC-Unique: NjJboJZQOcKT0w8eDYDqBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A6701899525;
        Tue, 28 Apr 2020 16:06:21 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A7175C240;
        Tue, 28 Apr 2020 16:06:15 +0000 (UTC)
Date:   Tue, 28 Apr 2020 18:06:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200428180613.7980ea7a@carbon>
In-Reply-To: <87eesd3rvu.fsf@toke.dk>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757164613.1370371.2655437650342381672.stgit@firesoul>
        <87eesd3rvu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 16:00:53 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > XDP have evolved to support several frame sizes, but xdp_buff was not
> > updated with this information. The frame size (frame_sz) member of
> > xdp_buff is introduced to know the real size of the memory the frame is
> > delivered in.
> >
> > When introducing this also make it clear that some tailroom is
> > reserved/required when creating SKBs using build_skb().
> >
> > It would also have been an option to introduce a pointer to
> > data_hard_end (with reserved offset). The advantage with frame_sz is
> > that (like rxq) drivers only need to setup/assign this value once per
> > NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
> > store frame_sz inside xdp_rxq_info, because it's varies per packet as it
> > can be based/depend on packet length.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com> =20
>=20
> With one possible nit below:
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

thx

> > ---
> >  include/net/xdp.h |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 40c6d3398458..1ccf7df98bee 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -6,6 +6,8 @@
> >  #ifndef __LINUX_NET_XDP_H__
> >  #define __LINUX_NET_XDP_H__
> > =20
> > +#include <linux/skbuff.h> /* skb_shared_info */
> > +
> >  /**
> >   * DOC: XDP RX-queue information
> >   *
> > @@ -70,8 +72,19 @@ struct xdp_buff {
> >  	void *data_hard_start;
> >  	unsigned long handle;
> >  	struct xdp_rxq_info *rxq;
> > +	u32 frame_sz; /* frame size to deduct data_hard_end/reserved tailroom=
*/ =20
>=20
> I think maybe you want to s/deduct/deduce/ here?

Okay, queued for V2.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

