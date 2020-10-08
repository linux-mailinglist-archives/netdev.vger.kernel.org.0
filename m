Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E36287071
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgJHIHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:07:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgJHIHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602144457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LN2yGARkzqh6107vzgAEFEAJDYjudMQSVB45mtuXmuU=;
        b=RAPDwJYTuGkv/55SFs17llfDzqSOeW+4TSkb95yjnoCUIMPKM3fWvbain24K1Di6e9xxEM
        Y5QCCiHDQk21OOy1fBO8IK1Yg/vRTvGS5eTuj5HbT1Zt1wo9x6nJ/uEBIrKVuY2y3zMFYH
        zwWI2nkIOVKTCh2EsHhW+hVvpatXFU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-wcdW0DAfP365DL7kxnJD8A-1; Thu, 08 Oct 2020 04:07:35 -0400
X-MC-Unique: wcdW0DAfP365DL7kxnJD8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C69DB425E0;
        Thu,  8 Oct 2020 08:07:32 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9403B702E7;
        Thu,  8 Oct 2020 08:07:25 +0000 (UTC)
Date:   Thu, 8 Oct 2020 10:07:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
Message-ID: <20201008100723.33e14dca@carbon>
In-Reply-To: <5f7e854b111fc_2acac2087e@john-XPS-13-9370.notmuch>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
        <160208778070.798237.16265441131909465819.stgit@firesoul>
        <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
        <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
        <CANP3RGdcqmcrxWDKPsZ8A0+qK1hzD0tZvRFsVMPvSCNDk+LrHA@mail.gmail.com>
        <5f7e854b111fc_2acac2087e@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 07 Oct 2020 20:19:39 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Maciej =C5=BBenczykowski wrote:
> > On Wed, Oct 7, 2020 at 3:37 PM John Fastabend <john.fastabend@gmail.com=
> wrote: =20
> > >
> > > Daniel Borkmann wrote: =20
> > > > On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
> > > > [...] =20
> > > > >   net/core/dev.c |   24 ++++++++++++++++++++++--
> > > > >   1 file changed, 22 insertions(+), 2 deletions(-) =20
> > >
> > > Couple high-level comments. Whats the problem with just letting the d=
river
> > > consume the packet? I would chalk it up to a buggy BPF program that is
> > > sending these packets. The drivers really shouldn't panic or do anyth=
ing
> > > horrible under this case because even today I don't think we can be
> > > 100% certain MTU on skb matches set MTU. Imagine the case where I cha=
nge
> > > the MTU from 9kB->1500B there will be some skbs in-flight with the la=
rger
> > > length and some with the shorter. If the drivers panic/fault or other=
wise
> > > does something else horrible thats not going to be friendly in genera=
l case
> > > regardless of what BPF does. And seeing this type of config is all do=
ne
> > > async its tricky (not practical) to flush any skbs in-flight.
> > >
> > > I've spent many hours debugging these types of feature flag, mtu
> > > change bugs on the driver side I'm not sure it can be resolved by
> > > the stack easily. Better to just build drivers that can handle it IMO.
> > >
> > > Do we know if sending >MTU size skbs to drivers causes problems in re=
al
> > > cases? I haven't tried on the NICs I have here, but I expect they sho=
uld
> > > be fine. Fine here being system keeps running as expected. Dropping t=
he
> > > skb either on TX or RX side is expected. Even with this change though
> > > its possible for the skb to slip through if I configure MTU on a live
> > > system. =20
> >=20
> > I wholeheartedly agree with the above.
> >=20
> > Ideally the only >mtu check should happen at driver admittance.
> > But again ideally it should happen in some core stack location not in
> > the driver itself. =20
>=20
> Ideally maybe, but IMO we should just let the skb go to the driver
> and let the driver sort it out. Even if this means pushing the packet
> onto the wire then the switch will drop it or the receiver, etc. A
> BPF program can do lots of horrible things that should never be
> on the wire otherwise. MTU is just one of them, but sending corrupted
> payloads, adding bogus headers, checksums etc. so I don't think we can
> reasonable protect against all of them.

That is a good point.

> Of course if the driver is going to hang/panic then something needs
> to be done. Perhaps a needs_mtu_check feature flag, although thats
> not so nice either so perhaps drivers just need to handle it themselves.
> Also even today the case could happen without BPF as best I can tell
> so the drivers should be prepared for it.

Yes, borderline cases do exist already today (like your reconf with
inflight packets), so I guess drivers should at-least not hang/panic
and be robust enough that we can drop this check.

I think you have convinced me that we can drop this check.  My only
concern is how people can troubleshoot this, but its not different from
current state.


> > However, due to both gso and vlan offload, even this is not trivial to =
do...
> > The mtu is L3, but drivers/hardware/the wire usually care about L2...

If net_device->mtu is L3 (1500) and XDP (and TC, right?) operate at L2,
that likely means that the "strict" bpf_mtu_check (in my BPF-helper) is
wrong, as XDP (and TC) length at this point include the 14 bytes
Ethernet header.  I will check and fix.

Is this accounted for via net_device->hard_header_len ?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

