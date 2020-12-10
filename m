Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795112D6397
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392022AbgLJRck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:32:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392484AbgLJRc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:32:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607621455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5P/qDi7wA+rvW2gtSqVQu3jB6OGZe46xx+pWi2+9CM=;
        b=HYjAMUtaeUkDYDccW0TEui2cPnmzUDlchTCdSM2nw48IAyvE6gJkBWUE5FSdH4Vo62tw3e
        V8ZdQxTXYkjyGsxE76639AxDW+sC325qb7cPf6L3PXAn976hABdbhZfFiQcJ94rwI9TM+k
        18XHJ/VIVUsrE6Ycj6yG4Bw0kb+SUEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-fj061OEpOeyugu0E_N0B1g-1; Thu, 10 Dec 2020 12:30:43 -0500
X-MC-Unique: fj061OEpOeyugu0E_N0B1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A5E1107ACE6;
        Thu, 10 Dec 2020 17:30:40 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10BC71F442;
        Thu, 10 Dec 2020 17:30:24 +0000 (UTC)
Date:   Thu, 10 Dec 2020 18:30:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Frey Alfredsson <freysteinn@freysteinn.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Marek Majtyka <marekx.majtyka@intel.com>,
        Marek Majtyka <alardam@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>, brouer@redhat.com
Subject: Re: [Intel-wired-lan] Explaining XDP redirect bulk size design
 (Was: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set)
Message-ID: <20201210183023.4b299334@carbon>
In-Reply-To: <CAJ8uoz25rtO63-4nOSV-yr8bORNbNSquiBBWiEouLs-ZUv2o=A@mail.gmail.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204102901.109709-2-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
        <20201207135433.41172202@carbon>
        <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
        <20201207230755.GB27205@ranger.igk.intel.com>
        <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
        <20201209095454.GA36812@ranger.igk.intel.com>
        <20201209125223.49096d50@carbon>
        <6913010d-2fd6-6713-94e9-8f5b8ad4b708@gmail.com>
        <20201210143211.2490f7f4@carbon>
        <CAJ8uoz25rtO63-4nOSV-yr8bORNbNSquiBBWiEouLs-ZUv2o=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 15:14:18 +0100
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Thu, Dec 10, 2020 at 2:32 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Wed, 9 Dec 2020 08:44:33 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> > =20
> > > On 12/9/20 4:52 AM, Jesper Dangaard Brouer wrote: =20
> > > > But I have redesigned the ndo_xdp_xmit call to take a bulk of packe=
ts
> > > > (up-to 16) so it should not be a problem to solve this by sharing
> > > > TX-queue and talking a lock per 16 packets.  I still recommend that,
> > > > for fallback case,  you allocated a number a TX-queue and distribute
> > > > this across CPUs to avoid hitting a congested lock (above measureme=
nts
> > > > are the optimal non-congested atomic lock operation) =20
> > >
> > > I have been meaning to ask you why 16 for the XDP batching? If the
> > > netdev budget is 64, why not something higher like 32 or 64? =20
> >
> > Thanks you for asking as there are multiple good reasons and
> > consideration for this 16 batch size.  Notice cpumap have batch size 8,
> > which is also an explicit choice.  And AF_XDP went in the wrong
> > direction IMHO and I think have 256.  I designed this to be a choice in
> > the map code, for the level of bulking it needs/wants. =20
>=20
> FYI, as far as I know, there is nothing in AF_XDP that says bulking
> should be 256. There is a 256 number in the i40e driver that states
> the maximum number of packets to be sent within one napi_poll loop.
> But this is just a maximum number and only for that driver. (In case
> you wonder, that number was inherited from the original skb Tx
> implementation in the driver.)=20

Ah, that explains the issue I have on the production system that runs
the EDT-pacer[2].  I see that i40e function i40e_clean_tx_irq() ignores
napi_budget but uses it own budget, that defaults to 256.  Looks like I
can adjust this via ethtool -C tx-frames-irq.   I turned this down to
64 (32 was giving worse results, and below 16 system acted strange).

Now the issue is gone, which was that if TX-DMA completion was running
(i40e_clean_tx_irq()) on the same CPU that send packets via FQ-pacer
qdisc, then the pacing was not accurate, and was sending too bursty.

System have already tuned "net/core/dev_weight" and RX/TX-bias to
reduce bulking, as this can influence latency and the EDT-pacing
accuracy. (It is a middlebox bridging VLANs and BPF-EDT tiemstamping and
FQ-pacing packets to solve bursts overflowing switch ports).

  sudo sysctl net/core/dev_weight
  net.core.dev_weight =3D 1
  net.core.dev_weight_rx_bias =3D 32
  net.core.dev_weight_tx_bias =3D 1

This net.core.dev_weight_tx_bias=3D1 (together with dev_weight=3D1) cause
qdisc transmit budget to become one packet, cycling through
NET_TX_SOFTIRQ which consumes time and gives a little more pacing space
for the packets.


> The actual batch size is controlled by
> the application. If it puts 1 packet in the Tx ring and calls send(),
> the batch size will be 1. If it puts 128 packets in the Tx ring and
> calls send(), you get a batch size of 128, and so on. It is flexible,
> so you can trade-off latency with throughput in the way the
> application desires. Rx batch size has also become flexible now with
> the introduction of Bj=C3=B6rn's prefer_busy_poll patch set [1].
>=20
> [1] https://lore.kernel.org/netdev/20201130185205.196029-1-bjorn.topel@gm=
ail.com/

This looks like a cool trick, to get even more accurate packet scheduling.

I played with the tunings, and could see changed behavior with mpstat,
but ended up tuning it off again, as I could not measure a direct
correlation with the bpftrace tools[3].


> > The low level explanation is that these 8 and 16 batch sizes are
> > optimized towards cache sizes and Intel's Line-Fill-Buffer (prefetcher
> > with 10 elements).  I'm betting on that memory backing these 8 or 16
> > packets have higher chance to remain/being in cache, and I can prefetch
> > them without evicting them from cache again.  In some cases the pointer
> > to these packets are queued into a ptr_ring, and it is more optimal to
> > write cacheline sizes 1 (8 pointers) or 2 (16 pointers) into the ptr_ri=
ng.
> >
> > The general explanation is my goal to do bulking without adding latency.
> > This is explicitly stated in my presentation[1] as of Feb 2016, slide 2=
0.
> > Sure, you/we can likely make the micro-benchmarks look better by using
> > 64 batch size, but that will introduce added latency and likely shoot
> > our-selves in the foot for real workloads.  With experience from
> > bufferbloat and real networks, we know that massive TX bulking have bad
> > effects.  Still XDP-redirect does massive bulking (NIC flush is after
> > full 64 budget) and we don't have pushback or a queue mechanism (so I
> > know we are already shooting ourselves in the foot) ...  Fortunately we
> > now have a PhD student working on queuing for XDP.
> >
> > It is also important to understand that this is an adaptive bulking
> > scheme, which comes from NAPI.  We don't wait for packets arriving
> > shortly, we pickup what NIC have available, but by only taking 8 or 16
> > packets (instead of emptying the entire RX-queue), and then spending
> > some time to send them along, I'm hoping that NIC could have gotten
> > some more frame.  For cpumap and veth (in-some-cases) they can start to
> > consume packets from these batches, but NIC drivers gets XDP_XMIT_FLUSH
> > signal at NAPI-end (xdp_do_flush). Still design allows NIC drivers to
> > update their internal queue state (and BQL), and if it gets close to
> > full they can choose to flush/doorbell the NIC earlier.  When doing
> > queuing for XDP we need to expose these NIC queue states, and having 4
> > calls with 16 packets (64 budget) also gives us more chances to get NIC
> > queue state info which the NIC already touch.
> >
> >
> > [1] https://people.netfilter.org/hawk/presentations/devconf2016/net_sta=
ck_challenges_100G_Feb2016.pdf

[2] https://github.com/netoptimizer/bpf-examples/tree/master/traffic-pacing=
-edt/

[3] https://github.com/netoptimizer/bpf-examples/tree/master/traffic-pacing=
-edt/bpftrace


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

