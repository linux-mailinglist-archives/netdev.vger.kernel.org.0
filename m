Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97732358051
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHKKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 06:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDHKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 06:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617876627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UTr/e7iTYGD0N+XocUt6MT1hNOKxHbIF/br9tzGgYJQ=;
        b=fXGLbVfRyQkC9QwrD9nBPVq7UFI6pKtCYxumgyow/TY9V7yJ6n1DwQg7LJGXQwEMPjYvpZ
        U2NOPM6Ep0BA3HznqCIdMUcLhMwYUayuqQEgk0Pw+8Kzfq0+kDG7YQrsr1DhEvK72YxWEd
        L/+LbrULaW/Gfp4UlPm7WU6qiy35AjI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-RCXYQuxiOdSsNRWlHRt_JQ-1; Thu, 08 Apr 2021 06:10:24 -0400
X-MC-Unique: RCXYQuxiOdSsNRWlHRt_JQ-1
Received: by mail-ed1-f69.google.com with SMTP id r19so787312edv.3
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 03:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UTr/e7iTYGD0N+XocUt6MT1hNOKxHbIF/br9tzGgYJQ=;
        b=dSHwzI+rtocE83CuVcTMuUpGY+KifwkBPLpLV9zG95I1Ksjoof3qEhdoAKehMRiMO3
         /e4QFpmvTAJR7i1iq/R2cjCgCwOTGzF3GY17pWJjFRNFSEyqQuQZP6cY3WWQ5LKC+lBv
         BjtIMImx3KTzvNDE5oeku1VutbwKMBn/wvZtfB9yLQdC0nrn0IBxi1o8yJlNrJmwAC70
         Y49o3gC1MwAQmrSdH7GoM11Ljy90zOG2j/jMRT8vTxJnITqnJJ1Nmvgfn0UhfwzRbRlg
         Ym1lCPcWG9BWitLVG32oME0uu6NB3H4AZEByv1OFAIzpsPNoI3AIBJhlOAWccn1n+E3v
         n1eA==
X-Gm-Message-State: AOAM533aG+ADuXWT6/6ep+Z2XsfCu4/otFVsJZIzKmy4jnVixjidfaHC
        5f4AR4d5909dkSgU+c+82hm6I6u/y7kS8oCPRqSNwBuGIkDYbhJo8qxlV5MAhyTZ4gUFOus7OfO
        HuzJ8zeG919daGBmP
X-Received: by 2002:a17:906:54e:: with SMTP id k14mr7648297eja.149.1617876623785;
        Thu, 08 Apr 2021 03:10:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpnJjQy2rZdlAboIQBscmKQmo84RgWlmjXkcCNGPz1zcfUSVUF8HWkzTgefk3L069TwaB2mw==
X-Received: by 2002:a17:906:54e:: with SMTP id k14mr7648271eja.149.1617876623571;
        Thu, 08 Apr 2021 03:10:23 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id gq9sm14287766ejb.62.2021.04.08.03.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 03:10:23 -0700 (PDT)
Date:   Thu, 8 Apr 2021 12:10:19 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <YG7Wi/vFK+XFBUcQ@lore-desk>
References: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
 <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
 <YGX5j7RDQIXlh69L@lore-desk>
 <CAPhsuW7ih9ULA=aq0G7Ka+15KfSWgyuLXD_BxTUcRhn8++UNoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yqa6TSx8vTqTsFV8"
Content-Disposition: inline
In-Reply-To: <CAPhsuW7ih9ULA=aq0G7Ka+15KfSWgyuLXD_BxTUcRhn8++UNoQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Yqa6TSx8vTqTsFV8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 1, 2021 at 9:49 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > > On Thu, Apr 1, 2021 at 1:57 AM Lorenzo Bianconi <lorenzo@kernel.org> =
wrote:
> > > >
> >
> > [...]
> >
> > > > -                       /* Inject into network stack */
> > > > -                       ret =3D netif_receive_skb_core(skb);
> > > > -                       if (ret =3D=3D NET_RX_DROP)
> > > > -                               drops++;
> > >
> > > I guess we stop tracking "drops" with this patch?
> > >
> > > Thanks,
> > > Song
> >
> > Hi Song,
> >
> > we do not report the packets dropped by the stack but we still count th=
e drops
> > in the cpumap. If you think they are really important I guess we can ch=
ange
> > return value of netif_receive_skb_list returning the dropped packets or
> > similar. What do you think?
>=20
> I think we shouldn't silently change the behavior of the tracepoint below:
>=20
> trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
>=20
> Returning dropped packets from netif_receive_skb_list() sounds good to me.

Hi Song,

I reviewed the netif_receive_skb_list() and I guess the code needed to count
number of dropped frames is a bit intrusive and we need to add some checks
in the hot path.
Moreover the dropped frames are already accounted in the networking stack
(e.g. mib counters for the ip traffic).
Since drop counter is just exported in a tracepoint in cpu_map_kthread_run,
I guess we can just not count dropped packets in the networking stack here
and rely on the mib counters. What do you think?

@Jesper: since you added the original code, what do you think about it?

Regards,
Lorenzo

>=20
> Thanks,
> Song
>=20

--Yqa6TSx8vTqTsFV8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYG7WiAAKCRA6cBh0uS2t
rBYDAP0RCcYqwIC/AtBhEVkKZUoTdEjAGWpOeyNHj2d0LpEoFgEAny0pzyMyPYxZ
tutnWMeXubA5rheq8FbzRU/YzxKHLgU=
=PC/0
-----END PGP SIGNATURE-----

--Yqa6TSx8vTqTsFV8--

