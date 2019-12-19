Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1876E125F94
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfLSKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:44:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20652 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbfLSKoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576752293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcRebzZ7v8B4UQTgB0Ekbyw1ri+0Xejw/oV8dUxM5e4=;
        b=Z6n8tAVNe9WE4sFEJMeMAhlJvA10SYYko84xnvYy9OKJa/pT131p/piMv6k+vlTldiDcel
        wIBKYVAFxj0tASYPH+jBJ8dMg+92kkzk1l6OBqXCW7Fj497Sc8L35THBIVFreTtrtgFB/O
        kg1HevleyGPoOOTHO2rlVlc93+DLDvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-whER6HXzOGCFKCAFA1zQfA-1; Thu, 19 Dec 2019 05:44:51 -0500
X-MC-Unique: whER6HXzOGCFKCAFA1zQfA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99699800D48;
        Thu, 19 Dec 2019 10:44:49 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C78FA19C58;
        Thu, 19 Dec 2019 10:44:40 +0000 (UTC)
Date:   Thu, 19 Dec 2019 11:44:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     Luigi Rizzo <rizzo@iet.unipi.it>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: XDP multi-buffer design discussion
Message-ID: <20191219114438.0bcb33ea@carbon>
In-Reply-To: <fda0d409b60b4e0a94a0ed4f53f4a3cc@EX13D11EUB003.ant.amazon.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
        <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
        <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
        <20190823084704.075aeebd@carbon>
        <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
        <20191204155509.6b517f75@carbon>
        <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
        <20191216150728.38c50822@carbon>
        <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
        <20191217094635.7e4cac1c@carbon>
        <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
        <fda0d409b60b4e0a94a0ed4f53f4a3cc@EX13D11EUB003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 16:03:54 +0000
"Jubran, Samih" <sameehj@amazon.com> wrote:

> > -----Original Message-----
> > From: Luigi Rizzo <rizzo@iet.unipi.it>
> > Sent: Wednesday, December 18, 2019 12:30 AM
> > To: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Jubran, Samih <sameehj@amazon.com>; Machulsky, Zorik
> > <zorik@amazon.com>; Daniel Borkmann <borkmann@iogearbox.net>; David
> > Miller <davem@davemloft.net>; Tzalik, Guy <gtzalik@amazon.com>; Ilias
> > Apalodimas <ilias.apalodimas@linaro.org>; Toke H=C3=B8iland-J=C3=B8rgen=
sen
> > <toke@redhat.com>; Kiyanovski, Arthur <akiyano@amazon.com>; Alexei
> > Starovoitov <ast@kernel.org>; netdev@vger.kernel.org; David Ahern
> > <dsahern@gmail.com>
> > Subject: Re: XDP multi-buffer design discussion
> >=20
> > On Tue, Dec 17, 2019 at 12:46 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote: =20
> > >
> > > On Mon, 16 Dec 2019 20:15:12 -0800
> > > Luigi Rizzo <rizzo@iet.unipi.it> wrote:
> > >... =20
> > > > For some use cases, the bpf program could deduct the total length
> > > > looking at the L3 header. =20
> > >
> > > Yes, that actually good insight.  I guess the BPF-program could also
> > > use this to detect that it doesn't have access to the full-lineary
> > > packet this way(?)
> > > =20
> > > > It won't work for XDP_TX response though. =20
> > >
> > > The XDP_TX case also need to be discussed/handled. IMHO need to
> > > support XDP_TX for multi-buffer frames.  XDP_TX *can* be driver
> > > specific, but most drivers choose to convert xdp_buff to
> > > xdp_frame, which makes it possible to use/share part of the
> > > XDP_REDIRECT code from ndo_xdp_xmit. =20
> > >
> > > We also need to handle XDP_REDIRECT, which becomes challenging, as the
> > > ndo_xdp_xmit functions of *all* drivers need to be updated (or
> > > introduce a flag to handle this incrementally). =20
> >=20
> > Here is a possible course of action (please let me know if you find
> > loose ends)
> >=20
> > 1. extend struct xdp_buff with a total length and sk_buff * (NULL by de=
fault);
> >

I don't like extending xdp_buff with an skb pointer. (Remember xdp_buff
is only "allocated" on the stack).

Perhaps xdp_buff with a total-length, *BUT* this can also be solved in
other ways.  Extend xdp_buff with a flag indicating that this xdp_buff
have multiple-buffers (segments).  Then we know that the area we store
the segments is valid, and we can also store the total-length there.
(We need this total-length later after xdp_buff is freed)

To make life easier for BPF-developers, we could export/create a
BPF-helper bpf_xdp_total_len(ctx), that hide whether segments are there
or not.


> > 2. add a netdev callback to construct the skb for the current
> >    packet. This code obviously already in all drivers, just needs to
> >    be exposed as function callable by a bpf helper (next bullet);
> >

Today we already have functions that create an SKB from an xdp_frame.

First the xdp_buff is converted to an xdp_frame, which memory area
lives in the top (32 bytes) of the packet-page.
(See function call convert_to_xdp_frame() in include/net/xdp.h).

Today two function create an SKB from this xdp_frame, and they should
likely be consolidated.  Functions: (1) cpu_map_build_skb and (2)
veth_xdp_rcv_one (and dive into veth_build_skb). (Hint both use a
variant of build_skb).

The challenge for you, Samih, is the placement of skb_shared_info
within the packet-page memory area.  These two xdp_frame->SKB
functions, place skb_shared_info after xdp_frame->len packet len
(aligned).  IMHO the placement of skb_shared_info should NOT vary this
much. Instead this should be xdp->data_hard_end - 320 bytes (size of
skb_shared_info).  First challenge is fixing this...


> > 3. add a new helper 'bpf_create_skb' that when invoked calls the
> >    previously mentioned netdev callback to  constructs an skb for
> >    the current packet, and sets the pointer in the xdp_buff, if not
> >    there already. A bpf program that needs to access segments beyond
> >    the first one can call bpf_create_skb() if needed, and then use
> >    existing helpers skb_load_bytes, skb_store_bytes, etc) to access
> >    the skb.
> >

I respectfully disagree with this approach.

One reason is that we want to support creating SKBs on a remote CPU.
Like we do today with CPUMAP redirect.  The proposed helper 'bpf_create_skb'
implies that this happens in BPF-context, during the NAPI loop.


> >   My rationale is that if we need to access multiple segments, we
> >   are already in an expensive territory and it makes little sense to
> >   define a multi segment format that would essentially be an skb.
> >

I also disagree. Multi-egment frames also have some high speed
use-cases.  Especially HW header-split at IP+TCP boundry is
interesting.


> >=20
> > 4. implement a mechanism to let so the driver know whether the
> >    currently loaded bpf program understands the new format.  There
> >    are multiple ways to do that, a trivial one would be to check,
> >    during load, that the program calls some known helper eg
> >    bpf_understands_fragments() which is then jit-ed to somethijng
> >    inexpensive
> >=20
> >   Note that today, a netdev that cannot guarantee single segment
> > packets would not be able to enable xdp. Hence, without loss of
> > functionality, such netdev can refuse to load a program without
> > bpf_undersdands_fragments().
> >=20
> >
> > With all the above, the generic xdp handler would do the following:
> >  if (!skb_is_linear() && !bpf_understands_fragments()) {
> >     < linearize skb>;
> >  }
> >   <construct xdp_buff with first segment and skb> // skb is unused by o=
ld style programs
> >   <call bpf program>
> >=20
> > The native driver for a device that cannot guarantee a single
> > segment would just refuse to load a program that does not
> > understand them (same as today), so the code would be:
> >
> > <construct xdp_buff with first segment and empty skb>  <call bpf progra=
m>
> >
> > On return, we might find that an skb has been built by the xdp
> > program, and can be immediately used for XDP_PASS (or dropped in
> > case of XDP_DROP)

I also disagree here.  SKB should first be created AFTER we know if
this will be a XDP_PASS action.=20


> > For XDP_TX and XDP_REDIRECT, something similar:
> > if the packet is a single segment and there is no skb, use the
> > existing accelerated path. If there are multiple segments,
> > construct the skb if not existing already, and pass it to the
> > standard tx path.
> >=20
> > cheers
> > luigi =20
>=20
> I have went over your suggestion, it looks good to me! I couldn't
> find any loose ends. One thing to note is that the driver now needs
> to save the context of the currently processed packet in for each
> queue so that it can support the netdev callback for creating the skb.
>
> This sounds a bit messy, but I think it should work.
>=20
> I'd love to hear more thoughts on this,
> Jesper, Toke what do you guys think?

As you can see from my comments I (respectfully) disagree with this
approach.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

