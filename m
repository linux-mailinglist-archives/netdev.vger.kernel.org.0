Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF1120901
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfLPO4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:56:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54378 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728014AbfLPO4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:56:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576508163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80cPIrEPrAz8MQFVQ8nJfsh1nESLSt1pzoh4IiK7L4I=;
        b=WprQpgZPvv7PKlxtB0A9jPsrV8BtglO1JZA2Nsc4ITMRlEKMtMwff4cimWu4TYbbIhIH+V
        13k1hJ/NxKGgehPH6R2rOuXDVS93CzfttoG8LySEhsmziYF/sF978H/aGtRBflvuFsLBoP
        7dJPkUPfCGvvRS5h27d0Snfk2ZRIyQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-hllR0CC2MqyQIy99aJVs3g-1; Mon, 16 Dec 2019 09:55:58 -0500
X-MC-Unique: hllR0CC2MqyQIy99aJVs3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94BB5108BD0D;
        Mon, 16 Dec 2019 14:55:57 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 138935D9C9;
        Mon, 16 Dec 2019 14:55:50 +0000 (UTC)
Date:   Mon, 16 Dec 2019 15:55:49 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next] samples/bpf: Attach XDP programs in driver
 mode by default
Message-ID: <20191216155549.14d2a661@carbon>
In-Reply-To: <20191216153501.0c5c036a@carbon>
References: <20191216110742.364456-1-toke@redhat.com>
        <20191216153501.0c5c036a@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 15:35:01 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Mon, 16 Dec 2019 12:07:42 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>=20
> > When attaching XDP programs, userspace can set flags to request the att=
ach
> > mode (generic/SKB mode, driver mode or hw offloaded mode). If no such f=
lags
> > are requested, the kernel will attempt to attach in driver mode, and th=
en
> > silently fall back to SKB mode if this fails.
> >=20
> > The silent fallback is a major source of user confusion, as users will =
try
> > to load a program on a device without XDP support, and instead of an er=
ror
> > they will get the silent fallback behaviour, not notice, and then wonder
> > why performance is not what they were expecting.
> >=20
> > In an attempt to combat this, let's switch all the samples to default to
> > explicitly requesting driver-mode attach. As part of this, ensure that =
all
> > the userspace utilities have a switch to enable SKB mode. For those that
> > have a switch to request driver mode, keep it but turn it into a no-op.
> >=20
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > --- =20
>=20
> I agree, that this is a good way forward.
>=20
> What is the observed behavior / error-message after this change?

The error message looks fine:

 $ sudo ./xdp1 enp0s31f6
 libbpf: Kernel error message: underlying driver does not support XDP in na=
tive mode
 link set xdp fd failed
=20
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> I wanted to test this myself, but compiling samples/bpf/ is breaking
> (again) on my system...

I saw your other compile fixes on the list and used those... thanks!


> > diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
> > index 3e553eed95a7..38a8852cb57f 100644
> > --- a/samples/bpf/xdp1_user.c
> > +++ b/samples/bpf/xdp1_user.c
> > @@ -98,7 +98,7 @@ int main(int argc, char **argv)
> >  			xdp_flags |=3D XDP_FLAGS_SKB_MODE;
> >  			break;
> >  		case 'N':
> > -			xdp_flags |=3D XDP_FLAGS_DRV_MODE;
> > +			/* default, set below */
> >  			break;
> >  		case 'F':
> >  			xdp_flags &=3D ~XDP_FLAGS_UPDATE_IF_NOEXIST;
> > @@ -109,6 +109,9 @@ int main(int argc, char **argv)
> >  		}
> >  	}
> > =20
> > +	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
> > +		xdp_flags |=3D XDP_FLAGS_DRV_MODE;
> > +
> >  	if (optind =3D=3D argc) {
> >  		usage(basename(argv[0]));
> >  		return 1; =20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

