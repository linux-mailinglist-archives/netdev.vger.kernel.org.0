Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163833551F9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 13:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbhDFLYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 07:24:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234126AbhDFLYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 07:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617708238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYQ3YtBpeHIK673S3VDkRccmMvhpQ+SzBfcamGUP43M=;
        b=GaKGjwy54BIkz9yQ3k6BN9lQwbqoX8kobGHoQ92cG0hxkOwJ86bMf7/CGEjk3R8pFW7+nB
        eJzvfHHWRb/PIuWQZ+uleuXlxauwz0aDUby/Iw5vJeT+S8ZN0fW7KSwi98cb5TOrumcTBb
        7adig7439eEBsm10wKRCMfOb6vbA7gY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-TVTfb_ZSM2meOshkt7LSvg-1; Tue, 06 Apr 2021 07:23:53 -0400
X-MC-Unique: TVTfb_ZSM2meOshkt7LSvg-1
Received: by mail-ej1-f69.google.com with SMTP id p11so5307500eju.2
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 04:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kYQ3YtBpeHIK673S3VDkRccmMvhpQ+SzBfcamGUP43M=;
        b=YEa2yuReTi45fsuwyBd8uSqWOTrIEHzk42ki40fbIz7tz1vzOUvMdQzGud9Rj1Fox/
         cycPtqj7jpJWGMk3RtFQAlISEOumKDgjeeOXLrWk4g7jb3wwR7Mo0yzN4ay7LWNjlJuu
         oi6UGr+N43M7FfYNnbxW8V+uhckpjOALdTG0LPFOrD3I7CGEYRCAv9TckmH9Gzl7lbMR
         KtFgEMsPHS4L65glslSZkJbU8zasLDRUS5n0qqyKMAFjJhQ7evjdW1KRLksPBLUV2bey
         fhjBHeufYnJx/PcliHUpZfuCgeGfLwJm3LMr+FRYBxg0GNDTOQ+39DXpbFCCbcuXLIib
         /IIw==
X-Gm-Message-State: AOAM532zKHR/syCGUuJ68RW52fmGJTh11esg+EqrvaTjbiocDgaRmIhe
        gW94s2i49pTBj7zoRIF/qgs4ko4Uh7ut2k4FuvXueknneyfc3ggOhU1BNjs9iCRd4SJJONY0sIy
        09Arx590sZaFPIyYJ
X-Received: by 2002:a17:906:f8d2:: with SMTP id lh18mr9288098ejb.57.1617708231729;
        Tue, 06 Apr 2021 04:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2gylcLoj0DH7e3Cf8jPvpykRXJHsPynvNuUTlFOZ03zKg0Y1eYywshTRPydnUFTX6ynjMHw==
X-Received: by 2002:a17:906:f8d2:: with SMTP id lh18mr9288045ejb.57.1617708231237;
        Tue, 06 Apr 2021 04:23:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x24sm8494444edr.36.2021.04.06.04.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 04:23:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 05D76180300; Tue,  6 Apr 2021 13:23:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 9/9] net: enetc: add support for XDP_REDIRECT
In-Reply-To: <20210403121228.gfqbnyistngmf257@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <20210331200857.3274425-10-olteanv@gmail.com> <87blaynt4l.fsf@toke.dk>
 <20210401113133.vzs3uxkp52k2ctla@skbuf> <875z16nsiu.fsf@toke.dk>
 <20210401160943.frw7l3rio7spr33n@skbuf> <87lfa1nat5.fsf@toke.dk>
 <20210401193821.3fmfxvnpwzam7b6f@skbuf>
 <20210402105625.at6p3u6dh5zorwsz@skbuf> <87eefrd3ta.fsf@toke.dk>
 <20210403121228.gfqbnyistngmf257@skbuf>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Apr 2021 13:23:49 +0200
Message-ID: <8735w34px6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Sat, Apr 03, 2021 at 01:07:29PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>>=20
>> > On Thu, Apr 01, 2021 at 10:38:21PM +0300, Vladimir Oltean wrote:
>> >> On Thu, Apr 01, 2021 at 08:01:42PM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
>> >> > Vladimir Oltean <olteanv@gmail.com> writes:
>> >> >=20
>> >> > > On Thu, Apr 01, 2021 at 01:39:05PM +0200, Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
>> >> > >> Vladimir Oltean <olteanv@gmail.com> writes:
>> >> > >>
>> >> > >> > On Thu, Apr 01, 2021 at 01:26:02PM +0200, Toke H=C3=B8iland-J=
=C3=B8rgensen wrote:
>> >> > >> >> > +int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
>> >> > >> >> > +		   struct xdp_frame **frames, u32 flags)
>> >> > >> >> > +{
>> >> > >> >> > +	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS=
] =3D {0};
>> >> > >> >> > +	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
>> >> > >> >> > +	struct enetc_bdr *tx_ring;
>> >> > >> >> > +	int xdp_tx_bd_cnt, i, k;
>> >> > >> >> > +	int xdp_tx_frm_cnt =3D 0;
>> >> > >> >> > +
>> >> > >> >> > +	tx_ring =3D priv->tx_ring[smp_processor_id()];
>> >> > >> >>
>> >> > >> >> What mechanism guarantees that this won't overflow the array?=
 :)
>> >> > >> >
>> >> > >> > Which array, the array of TX rings?
>> >> > >>
>> >> > >> Yes.
>> >> > >>
>> >> > >
>> >> > > The problem isn't even accessing an out-of-bounds element in the =
TX ring array.
>> >> > >
>> >> > > As it turns out, I had a relatively superficial understanding of =
how
>> >> > > things are organized, but let me try to explain.
>> >> > >
>> >> > > The number of TX rings is a configurable resource (between PFs an=
d VFs)
>> >> > > and we read the capability at probe time:
>> >> > >
>> >> > > enetc_get_si_caps:
>> >> > > 	val =3D enetc_rd(hw, ENETC_SICAPR0);
>> >> > > 	si->num_rx_rings =3D (val >> 16) & 0xff;
>> >> > > 	si->num_tx_rings =3D val & 0xff;
>> >> > >
>> >> > > enetc_init_si_rings_params:
>> >> > > 	priv->num_tx_rings =3D si->num_tx_rings;
>> >> > >
>> >> > > In any case, the TX array is declared as:
>> >> > >
>> >> > > struct enetc_ndev_priv {
>> >> > > 	struct enetc_bdr *tx_ring[16];
>> >> > > 	struct enetc_bdr *rx_ring[16];
>> >> > > };
>> >> > >
>> >> > > because that's the maximum hardware capability.
>> >> > >
>> >> > > The priv->tx_ring array is populated in:
>> >> > >
>> >> > > enetc_alloc_msix:
>> >> > > 	/* # of tx rings per int vector */
>> >> > > 	v_tx_rings =3D priv->num_tx_rings / priv->bdr_int_num;
>> >> > >
>> >> > > 	for (i =3D 0; i < priv->bdr_int_num; i++) {
>> >> > > 		for (j =3D 0; j < v_tx_rings; j++) {
>> >> > > 			if (priv->bdr_int_num =3D=3D ENETC_MAX_BDR_INT)
>> >> > > 				idx =3D 2 * j + i; /* 2 CPUs */
>> >> > > 			else
>> >> > > 				idx =3D j + i * v_tx_rings; /* default */
>> >> > >
>> >> > > 			priv->tx_ring[idx] =3D bdr;
>> >> > > 		}
>> >> > > 	}
>> >> > >
>> >> > > priv->bdr_int_num is set to "num_online_cpus()".
>> >> > > On LS1028A, it can be either 1 or 2 (and the ENETC_MAX_BDR_INT ma=
cro is
>> >> > > equal to 2).
>> >> > >
>> >> > > Otherwise said, the convoluted logic above does the following:
>> >> > > - It affines an MSI interrupt vector per CPU
>> >> > > - It affines an RX ring per MSI vector, hence per CPU
>> >> > > - It balances the fixed number of TX rings (say 8) among the avai=
lable
>> >> > >   MSI vectors, hence CPUs (say 2). It does this by iterating with=
 i
>> >> > >   through the RX MSI interrupt vectors, and with j through the nu=
mber of
>> >> > >   TX rings per MSI vector.
>> >> > >
>> >> > > This logic maps:
>> >> > > - the even TX rings to CPU 0 and the odd TX rings to CPU 1, if 2 =
CPUs
>> >> > >   are used
>> >> > > - all TX rings to CPU 0, if 1 CPU is used
>> >> > >
>> >> > > This is done because we have this logic in enetc_poll:
>> >> > >
>> >> > > 	for (i =3D 0; i < v->count_tx_rings; i++)
>> >> > > 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
>> >> > > 			complete =3D false;
>> >> > >
>> >> > > for processing the TX completions of a given group of TX rings in=
 the RX
>> >> > > MSI interrupt handler of a certain CPU.
>> >> > >
>> >> > > Otherwise said, priv->tx_ring[i] is always BD ring i, and that ma=
pping
>> >> > > never changes. All 8 TX rings are enabled and available for use.
>> >> > >
>> >> > > What I knew about tc-taprio and tc-mqprio is that they only enque=
ue to
>> >> > > TX queues [0, num_tc-1] because of this, as it turns out:
>> >> > >
>> >> > > enetc_xmit:
>> >> > > 	tx_ring =3D priv->tx_ring[skb->queue_mapping];
>> >> > >
>> >> > > where skb->queue_mapping is given by:
>> >> > > 	err =3D netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
>> >> > > and by this, respectively, from the mqprio code path:
>> >> > > 	netif_set_real_num_tx_queues(ndev, num_tc);
>> >> > >
>> >> > > As for why XDP works, and priv->tx_ring[smp_processor_id()] is:
>> >> > > - TX ring 0 for CPU 0 and TX ring 1 for CPU 1, if 2 CPUs are used
>> >> > > - TX ring 0, if 1 CPU is used
>> >> > >
>> >> > > The TX completions in the first case are handled by:
>> >> > > - CPU 0 for TX ring 0 (because it is even) and CPU 1 for TX ring 1
>> >> > >   (because it is odd), if 2 CPUs are used, due to the mapping I t=
alked
>> >> > >   about earlier
>> >> > > - CPU 0 if only 1 CPU is used
>> >> >=20
>> >> > Right - thank you for the details! So what are the constraints on t=
he
>> >> > configuration. Specifically, given two netdevs on the same device, =
is it
>> >> > possible that the system can ever end up in a situation where one d=
evice
>> >> > has two *RXQs* configured, and the other only one *TXQ*. Because th=
en
>> >> > you could get a redirect from RXQ 1 on one device, which would also=
 end
>> >> > up trying to transmit on TXQ 1 on the other device; and that would =
break
>> >> > if that other device only has TXQ 0 configured... Same thing if a s=
ingle
>> >> > device has 2 RXQs but only one TXQ (it can redirect to itself).
>> >>=20
>> >> I discover more and more of the driver as I talk to you, I like it :D
>> >>=20
>> >> So I said that there is a maximum number of RX and TX rings splittable
>> >> between the PF and its VFs, but I wasn't exactly sure where that
>> >> configuration is done. I found it now.
>> >>=20
>> >> enetc_port_si_configure: (SI =3D=3D station interface)
>> >> 	- read Port capability register 0 (PCAPR0) to determine how many
>> >> 	  RX rings and TX rings the hardware has for this port (PFs + VFs)
>> >> 	  in total.
>> >> 	- assign num_rings =3D min(TX rings, RX rings)
>> >> 	- try to assign 8 TX rings and 8 RX rings to the PF
>> >> 	  - if this fails, just assign ${num_rings} TX rings and
>> >> 	    ${num_rings} RX rings to the PF
>> >> 	- split the remaining RX and TX rings to the number of
>> >> 	  configured VFs (example: if there are 16 RX rings and 16 TX
>> >> 	  rings for a port with 2 VFs, the driver assigns 8RX/8TX rings
>> >> 	  for the PF, and 4RX/4TX rings for each VF).
>> >> 	   - if we couldn't assign 8RX/8TX rings for the PF in the
>> >> 	     previous step, we don't assign any ring to the VF
>> >>=20
>> >> So yeah, we have an equal number of RX and TX rings. The driver,
>> >> however, only uses 2 RX rings _actively_: one per CPU. The other 6, I
>> >> don't know, I guess I can use them for AF_XDP (I haven't looked very
>> >> closely at that yet), at the moment they're pretty much unused, even =
if
>> >> reserved and not given to VFs.
>> >>=20
>> >> > >> > You mean that it's possible to receive a TC_SETUP_QDISC_MQPRIO=
 or
>> >> > >> > TC_SETUP_QDISC_TAPRIO with num_tc =3D=3D 1, and we have 2 CPUs?
>> >> > >>
>> >> > >> Not just that, this ndo can be called on arbitrary CPUs after a
>> >> > >> redirect. The code just calls through from the XDP receive path =
so which
>> >> > >> CPU it ends up on depends on the RSS+IRQ config of the other dev=
ice,
>> >> > >> which may not even be the same driver; i.e., you have no control=
 over
>> >> > >> that... :)
>> >> > >>
>> >> > >
>> >> > > What do you mean by "arbitrary" CPU? You can't plug CPUs in, it's=
 a dual
>> >> > > core system... Why does the source ifindex matter at all? I'm usi=
ng the
>> >> > > TX ring affined to the CPU that ndo_xdp_xmit is currently running=
 on.
>> >> >=20
>> >> > See, this is why I asked 'what mechanism ensures'. Because if that
>> >> > mechanism is 'this driver is only ever used on a system with fewer =
CPUs
>> >> > than TXQs', then that's of course fine :)
>> >> >=20
>> >> > But there are drivers that do basically the same thing as what you'=
ve
>> >> > done here, *without* having such an assurance, and just looking at =
that
>> >> > function it's not obvious that there's an out-of-band reason why it=
's
>> >> > safe. And I literally just came from looking at such a case when I
>> >> > replied to your initial patch...
>> >>=20
>> >> Maybe you were confused seeing that this is a PCI device, thinking it=
's
>> >> a plug-in card or something, therefore we don't get to choose the num=
ber
>> >> of CPUs that the host has. In hindsight, I don't know why you didn't =
ask
>> >> about this, it is pretty strange when you think about it.
>> >>=20
>> >> It is actually more like a platform device with a PCI front-end - we
>> >> found this loophole in the PCI standard where you can create a "root
>> >> complex/integrated endpoint" which is basically an ECAM where the con=
fig
>> >> space contains PFs corresponding to some platform devices in the SoC =
(in
>> >> our case, all 4 Ethernet ports have their own PF, the switch has its =
own
>> >> PF, same thing for the MDIO controller and the 1588 timer). Their
>> >> register map is exposed as a number of BARs which use Enhanced
>> >> Allocation, so the generic PCI ECAM driver doesn't need to create any
>> >> translation windows for these addresses, it just uses what's in there,
>> >> which, surprise, is the actual base address of the peripheral in the
>> >> SoC's memory space.
>> >>=20
>> >> We do that because we gain a lot of cool stuff by appearing as PCI
>> >> devices to system software, like for example multiple interfaces on t=
op
>> >> of a 'shared MAC' are simply mapped over SR-IOV.
>> >>=20
>> >> So it just 'smells' like PCI, but they're regular memory-mapped devic=
es,
>> >> there is no PCI transaction layer or physical layer. At the moment the
>> >> LS1028A is the only SoC running Linux that integrates the ENETC block,
>> >> so we fully control the environment.
>> >>=20
>> >> > >> > Well, yeah, I don't know what's the proper way to deal with th=
at. Ideas?
>> >> > >>
>> >> > >> Well the obvious one is just:
>> >> > >>
>> >> > >> tx_ring =3D priv->tx_ring[smp_processor_id() % num_ring_ids];
>> >> > >>
>> >> > >> and then some kind of locking to deal with multiple CPUs accessi=
ng the
>> >> > >> same TX ring...
>> >> > >
>> >> > > By multiple CPUs accessing the same TX ring, you mean locking bet=
ween
>> >> > > ndo_xdp_xmit and ndo_start_xmit? Can that even happen if the hard=
ware
>> >> > > architecture is to have at least as many TX rings as CPUs?
>> >> > >
>> >> > > Because otherwise, I see that ndo_xdp_xmit is only called from
>> >> > > xdp_do_flush, which is in softirq context, which to my very rudim=
entary
>> >> > > knowledge run with bottom halves, thus preemption, disabled? So I=
 don't
>> >> > > think it's possible for ndo_xdp_xmit and ndo_xmit, or even two
>> >> > > ndo_xdp_xmit instances, to access the same TX ring?
>> >> >=20
>> >> > Yup, I think you're right about that. The "we always have more TXQs=
 than
>> >> > CPUs" condition was the bit I was missing (and of course you're *su=
re*
>> >> > that this would never change sometime in the future, right? ;)).
>> >>=20
>> >> I'm pretty sure, yeah, we build the SoCs and one of the requirements =
we
>> >> have is that every ENETC PF has enough TX rings in order for every CPU
>> >> to have its own one. That helps a lot with avoiding contention and
>> >> simplifying the driver. Maybe I'll use this opportunity to talk again=
 to
>> >> the hardware design guys and make sure that the next SoCs with Linux
>> >> follow the same pattern as LS1028A, although I see no reason why not.
>> >>=20
>> >> > > Sorry, I'm sure these are trivial questions, but I would like to =
really
>> >> > > understand what I need to change and why :D
>> >> >=20
>> >> > Given the above I think the only potentially breaking thing is the
>> >> > #RXQ > #TXQ case I outlined. And maybe a comment documenting why in=
dexing
>> >> > the tx_ring array by smp_processor_id() is safe would be nice? :)
>> >>=20
>> >> Sure, which part exactly do you think would explain it best? Should I
>> >> add a reference to enetc_port_si_configure?
>> >
>> > After discussing a bit more with Claudiu, I think we do have a problem,
>> > and it has to do with concurrent ndo_xdp_xmit on one CPU and ndo_start=
_xmit
>> > on another CPU.
>> >
>> > See, even if we have 8 TX rings, they are not really affined to any CP=
U.
>> > Instead, when we call netif_set_real_num_tx_queues, we allow netdev_pi=
ck_tx
>> > to hash amongs the TX queues of the same priority. There are three con=
sequences:
>> > - Traffic with the same hash will be sent to the same TX queue, thus
>> >   avoiding reordering for packets belonging to the same stream.
>> > - Traffic with different hashes are distributed to different TX queues.
>> > - If we have two CPUs sending traffic with the same hash, they will
>> >   serialize on the TX lock of the same netdev queue.
>> >
>> > The last one is a problem because our XDP_REDIRECT tries to associate
>> > one TX ring with one CPU, and, as explained above, that TX ring might
>> > already be used by our ndo_start_xmit on another CPU, selected by
>> > netdev_pick_tx.
>> >
>> > The first idea was to implement ndo_select_queue for the network stack,
>> > and select the TX ring based on smp_processor_id(). But we know that
>> > this will break the first two effects of netdev_pick_tx, which are very
>> > much desirable. For example, if we have a user space process sending a
>> > TCP stream, and the scheduler migrates that process from one CPU to
>> > another, then the ndo_select_queue output for that TCP stream will
>> > change, and we will have TX reordering for packets belonging to the sa=
me
>> > stream. Not at all ideal.
>> >
>> > Another idea is to just crop some TX queues from the network stack, and
>> > basically call netif_set_real_num_tx_queues(6), leaving one TX ring per
>> > CPU dedicated to XDP. This will work just fine for normal qdiscs, exce=
pt
>> > that with mqprio/taprio we have a problem. Our TX rings have a configu=
rable
>> > strict priority for the hardware egress scheduler. When we don't have
>> > mqprio/taprio, all TX rings have the same priority of 0 (therefore it =
is
>> > safe to allow hashing to select one at random), but when we have mqprio
>> > or taprio, we enjoy the benefit of configuring the priority of each TX
>> > ring using the "map" option. The problem, of course, is that if we crop
>> > 2 TX rings out of what the network stack sees, then we are no longer
>> > able to configure their queue-to-traffic-class mapping through
>> > mqprio/taprio, so we cannot change their prioritization relative to the
>> > network stack queues. In a way, this seems to be in line with the XDP
>> > design because that bypasses anything that has to do with qdiscs, but =
we
>> > don't really like that. We also have some other qdisc-based offloads
>> > such as Credit Based Shaper, and we would very much like to be able to
>> > set bandwidth profiles for the XDP rings, for AVB/TSN use cases.
>>=20
>> You'd not be the first driver to solve this by just carving out a couple
>> of TX rings for XDP :)
>>=20
>> And while I get the desire for being able to configure these things for
>> XDP as well, I'm not sure that the qdisc interface is the right one to
>> use for that. There was a general TXQ allocation idea that unfortunately
>> stalled out, but there is also ongoing work on XDP+TSN - I'm hoping
>> Jesper can chime in with the details...
>
> See, the reason why I don't like this answer is because when we tried to
> upstream our genetlink-based TSN configuration:
> https://patchwork.ozlabs.org/project/netdev/patch/1545968945-7290-1-git-s=
end-email-Po.Liu@nxp.com/
> we were told that it's a QoS feature and QoS belongs to the qdisc layer.
>
> I get the impression that XDP is largely incompatible with QoS by design,
> which sounds to me like a bit of a foot gun. For example, we have some
> customers interested in building an AVB application stack on top of AF_XD=
P,
> and for the endpoints (talker/listener) they really need to be able to
> configure bandwidth profiles for Stream Reservation classes A and B on
> the AF_XDP rings.
>
> To us, tc is mostly just a configuration interface for hardware features,
> the deal was that this is fine as long as they have a software counterpart
> with identical semantics. I think I understand the basic problem in that
> a software shaper would be bypassed by XDP, and therefore, the bandwidth
> profile would not be observed properly by the AVB talker if we were to
> rely on that. So that sounds indeed like we shouldn't even attempt to
> manage any TX queues on which XDP traffic is possible with tc, unless
> we're willing to pass XDP_REDIRECT through the qdisc layer (which I'm
> not suggesting is a good idea). But with the hardware offload that
> wouldn't be the case, so it's almost as if what would work for us would
> be to have some 'dummy' TX queues for XDP manageable by tc qdiscs where
> we could attach our offloadable filters and shapers and policers. I just
> don't want them to be completely invisible as far as tc is concerned.
> Managing which TX queues go to XDP, and not letting the driver choose
> that, would be even nicer.

I'm not objecting to being able to configure the hardware queues that
will be used for XDP, I'm just saying that doing so via TC is not a very
good interface for it... Rather, we need an interface for configuring
hardware queues that can be used by *both* XDP and TC.

And yeah, the lack of queueing and bandwidth management is a major
footgun in XDP, which we do want to fix (also for regular XDP_REDIRECT,
not just AF_XDP).

-Toke

