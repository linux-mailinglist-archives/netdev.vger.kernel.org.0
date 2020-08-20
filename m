Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7653924B101
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHTIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:25:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725824AbgHTIZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597911955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/NUw1qL/bzTA4qpBlCwBzMc0qVHyWlU5nHmGswtf9w=;
        b=XKTvqm+7QGV6UjghFKhbIRXfbOlSfBXHhYNm/HvoTbmUhd4eRGKDIfpU+UQb2XOpO6hrZw
        gE0b72NVZB8736l/IseyC7sSgiRAhxCV0PRv5UNdGIc9jYY8oHnLQwKT2w8dGZ5LHPcXDz
        M0eDNzGoTxakwAFW4N9WxsIdsweabB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-yfYegtHSP5ux-TSizW7jPQ-1; Thu, 20 Aug 2020 04:25:52 -0400
X-MC-Unique: yfYegtHSP5ux-TSizW7jPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 650A44239E;
        Thu, 20 Aug 2020 08:25:51 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 340125C893;
        Thu, 20 Aug 2020 08:25:40 +0000 (UTC)
Date:   Thu, 20 Aug 2020 10:25:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: Re: xdp generic default option
Message-ID: <20200820102539.35ad8687@carbon>
In-Reply-To: <CAEf4BzZSui9r=-yDzy0CjWKVx9zKvQWX6ZBNXmSUTOHCOR+7RA@mail.gmail.com>
References: <20200819092811.GA2420@lore-desk>
        <CAEf4BzZSui9r=-yDzy0CjWKVx9zKvQWX6ZBNXmSUTOHCOR+7RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 13:57:51 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Wed, Aug 19, 2020 at 2:29 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > Hi Andrii,
> >
> > working on xdp multi-buff I figured out now xdp generic is the default choice
> > if not specified by userspace. In particular after commit 7f0a838254bd
> > ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device"), running
> > the command below, XDP will run in generic mode even if the underlay driver
> > support XDP in native mode:
> >
> > $ip link set dev eth0 xdp obj prog.o
> > $ip link show dev eth0
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc mq state UP mode DEFAULT
> >    group default qlen 1024
> >    link/ether f0:ad:4e:09:6b:57 brd ff:ff:ff:ff:ff:ff
> >    prog/xdp id 1 tag 3b185187f1855c4c jited
> >
> > Is it better to use xdpdrv as default choice if not specified by userspace?
> > doing something like:
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index a00aa737ce29..1f85880ee412 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8747,9 +8747,9 @@ static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
> >  {
> >         if (flags & XDP_FLAGS_HW_MODE)
> >                 return XDP_MODE_HW;
> > -       if (flags & XDP_FLAGS_DRV_MODE)
> > -               return XDP_MODE_DRV;
> > -       return XDP_MODE_SKB;
> > +       if (flags & XDP_FLAGS_SKB_MODE)
> > +               return XDP_MODE_SKB;
> > +       return XDP_MODE_DRV;
> >  }
> >  
> 
> I think the better way would be to choose XDP_MODE_DRV if ndo_bpf !=
> NULL and XDP_MODE_SKB otherwise. That seems to be matching original
> behavior, no?

Yes, but this silent fallback to XDP_MODE_SKB (generic-XDP) have
cause a lot of support issues in the past.  I wish we could change it.
We already changed all the samples/bpf/ to ask for XDP_FLAGS_DRV_MODE,
so they behave this way.

d50ecc46d18f ("samples/bpf: Attach XDP programs in driver mode by default")
 https://git.kernel.org/torvalds/c/d50ecc46d18fa

> It was not my intent to change the behavior, sorry about that. I'll
> post patch a bit later today.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

