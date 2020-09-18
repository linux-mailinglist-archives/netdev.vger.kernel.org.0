Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B0326F9C5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRKAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgIRKAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:00:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600423234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cowvnht1B16jwPncWxMnAZL5RCq0sW/QkuOVkiw3zTw=;
        b=TrlXWjdsBu0p5tiQ0ogVz14Q5AQ5g/0u5AigXe+cU1LaIMs/kBctESSA1NBqUBxBx8SYN9
        IWz0xH19ICHbPv03nCODceVLWJwFniqCJrh3Hs9Zi2et5B05a7DpLiL/FX3rBw2oetC8kx
        XFujKRRcgs3SumhXNYYUh819eKx9IOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-mtORsPYAPVCgbAVLXbbJRg-1; Fri, 18 Sep 2020 06:00:30 -0400
X-MC-Unique: mtORsPYAPVCgbAVLXbbJRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16ED64090;
        Fri, 18 Sep 2020 10:00:27 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E532073662;
        Fri, 18 Sep 2020 10:00:17 +0000 (UTC)
Date:   Fri, 18 Sep 2020 12:00:16 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>, brouer@redhat.com
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
Message-ID: <20200918120016.7007f437@carbon>
In-Reply-To: <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
References: <20200917143846.37ce43a0@carbon>
        <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
        <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 12:11:33 -0700
Saeed Mahameed <saeed@kernel.org> wrote:

> On Thu, 2020-09-17 at 05:54 -0700, Maciej =C5=BBenczykowski wrote:
> > On Thu, Sep 17, 2020 at 5:39 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote: =20
> > >=20
> > > As you likely know[1] I'm looking into moving the MTU check (for
> > > TC-BPF) in __bpf_skb_max_len() when e.g. called by
> > > bpf_skb_adjust_room(), because when redirecting packets to
> > > another netdev it is not correct to limit the MTU based on the
> > > incoming netdev.
> > >=20
> > > I was looking at doing the MTU check in bpf_redirect() helper,
> > > because at this point we know the redirect to netdev, and
> > > returning an indication/error that MTU was exceed, would allow
> > > the BPF-prog logic to react, e.g. sending ICMP (instead of packet
> > > getting silently dropped).=20
> > > BUT this is not possible because bpf_redirect(index, flags) helper
> > > don't provide the packet context-object (so I cannot lookup the
> > > packet length).
> > >=20
> > > Seeking input:
> > >=20
> > > Should/can we change the bpf_redirect API or create a new helper
> > > with packet-context?
> > >=20
> > >  Note: We have the same need for the packet context for XDP when
> > >  redirecting the new multi-buffer packets, as not all destination
> > >  netdev will support these new multi-buffer packets.
> > >=20
> > > I can of-cause do the MTU checks on kernel-side in
> > > skb_do_redirect, but then how do people debug this? as packet
> > > will basically be silently dropped.
> > >=20
> > >=20
> > >=20
> > > (Looking at how does BPF-prog logic handle MTU today)
> > >=20
> > > How do bpf_skb_adjust_room() report that the MTU was exceeded?
> > > Unfortunately it uses a common return code -ENOTSUPP which used
> > > for multiple cases (include MTU exceeded). Thus, the BPF-prog
> > > logic cannot use this reliably to know if this is a MTU exceeded
> > > event. (Looked BPF-prog code and they all simply exit with
> > > TC_ACT_SHOT for all error codes, cloudflare have the most
> > > advanced handling with metrics->errors_total_encap_adjust_failed++).
> > >=20
> > >=20
> > > [1]=20
> > > https://lore.kernel.org/bpf/159921182827.1260200.9699352760916903781.=
stgit@firesoul/
> > > --
> > > Best regards,
> > >   Jesper Dangaard Brouer
> > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > >   LinkedIn: http://www.linkedin.com/in/brouer
> > >  =20
> >=20
> > (a) the current state of the world seems very hard to use correctly,
> > so adding new apis, or even changing existing ones seems ok to me.
> > especially if this just means changing what error code they return
> >=20
> > (b) another complexity with bpf_redirect() is you can call it, it
> > can succeed, but then you can not return TC_ACT_REDIRECT from the
> > bpf program, which effectively makes the earlier *successful*
> > bpf_redirect() call an utter no-op.
> >=20
> > (bpf_redirect() just determines what a future return TC_ACT_REDIRECT
> > will do)
> >=20
> > so if you bpf_redirect to interface with larger mtu, then increase
> > packet size, =20
>=20
> why would you redirect then touch the packet afterwards ?=20
> if you have a bad program, then it is a user issue.
>=20
> > then return TC_ACT_OK, then you potentially end up with excessively
> > large packet egressing through original interface (with small mtu).
> >=20

This is a good point.  As bpf_skb_adjust_room() can just be run after
bpf_redirect() call, then a MTU check in bpf_redirect() actually
doesn't make much sense.  As clever/bad BPF program can then avoid the
MTU check anyhow.  This basically means that we have to do the MTU
check (again) on kernel side anyhow to catch such clever/bad BPF
programs.  (And I don't like wasting cycles on doing the same check two
times).

If we do the MTU check on the kernel side, then there are no feedback
to the program, and how are end-users going to debug this?


> > My vote would be to return a new distinct error from bpf_redirect()
> > based on then current packet size and interface being redirected
> > to, save this interface mtu  somewhere, then in operations that
> > increase packet size check against this saved mtu, for correctness
> > you still have to check mtu after the bpf program is done,
> > but this is then just to deal with braindead bpf code (that calls
> > bpf_redirect and returns TC_ACT_OK, or calls bpf_redirect() multiple
> > times, or something...).
> >  =20

Hmm, I don't like wasting cycles on doing the same check multiple times.

In bpf_redirect() we store the netdev we want to redirect to, thus, if
bpf_skb_adjust_room() is run after bpf_redirect(), we could also do a
MTU check in bpf_skb_adjust_room() based on this netdev. (maybe there
are still ways for a BPF-prog to cheat the MTU check?).

>=20
> Another solution is to have an exception function defined in the
> BPF_prog, this function by itself is another program that can be
> executed to notify the prog about any exception/err that happened
> after the main BPF_program exited and let the XDP program react by
> its own logic.

We are talking about TC-BPF programs here, but the concept and
usability issue with bpf_redirect() is the same for XDP.

If doing the MTU check (and drop) on kernel side, as was thinking about
adding a simple tracepoint, for end-users to debug this. It would also
allow for attaching a BPF-prog to the tracepoint to get more direct
feedback, but it would not allow sending back an ICMP response.

Your approach of calling a 2nd BPF-prog to deal with exceptions, and
allow it to alter the packet and flow "action" is definitely
interesting.  What do others think?


> example:
>=20
> BPF_prog:
>     int XDP_main_prog(xdp_buff) {
>         xdp_adjust_head/tail(xdp_buff);
>         return xdp_redirect(ifindex, flags);
>     }
>=20
>     int XDP_exception(xdp_buff, excption_code) {
>         if (excetption_code =3D=3D XDP_REDIRECRT_MTU_EXCEEDED) {
>                 ICMP_response(xdp_buff);
>                 return XDP_TX;
>         }
>         return XDP_DROP;
>     }
>=20
>=20
> netdev_driver_xdp_handle():
>    act =3D bpf_prog_run_xdp(prog, xdp); // Run XDP_main_prog
>    if (act =3D=3D XDP_REDIRECT)
>        err =3D xdp_do_redirect(netdev, xdp, prog);
>        if (err) {=20
>           // Run XDP_exception() function in the user prog
>           // finds the exception handler of active program
>           act =3D bpf_prog_run_xdp_exciption(prog, xdp, err);
>           // then handle exception action in the driver
> (XDP_TX/DROP/FORWARD)..=20
>        }
>=20
> of-course a user program will be notified only on the first err ..=20
> if it fails on the 2nd time .. just drop..


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

