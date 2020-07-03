Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63F821406E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGCUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgGCUsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 16:48:16 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B463120885;
        Fri,  3 Jul 2020 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593809296;
        bh=VwL3HsTOc8bmJDO/IUg/niAsa4TOrnwOX5/tHgoTjDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYZn+l7/EAiMIXMv1HI5QkaBQrlndDC+1S5vZrRWPxysfj5sUit+0YKG7BeS4RIe1
         lrc7NkYYALVOdWY1zMffLNVedQVt3VB/om70wgadg/ZvwqgU2PO3Lw6nYhNbuEUT1x
         UTSPaE/OqC+C4sxPsGoHmmdKfIszDRPFJeqeZRVs=
Date:   Fri, 3 Jul 2020 22:48:10 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v5 bpf-next 5/9] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
Message-ID: <20200703204810.GB1321275@localhost.localdomain>
References: <cover.1593521029.git.lorenzo@kernel.org>
 <a6bb83a429f3b073e97f81ec3935b8ebe89fbd71.1593521030.git.lorenzo@kernel.org>
 <1f4af1f3-10cf-57ca-4171-11d3bff51c99@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1f4af1f3-10cf-57ca-4171-11d3bff51c99@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 6/30/20 2:49 PM, Lorenzo Bianconi wrote:
> [...]

[...]

> >   	old_rcpu =3D xchg(&cmap->cpu_map[key_cpu], rcpu);
> >   	if (old_rcpu) {
> > +		if (old_rcpu->prog)
> > +			bpf_prog_put(old_rcpu->prog);
> >   		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
> >   		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
> >   		schedule_work(&old_rcpu->kthread_stop_wq);
>=20
> Hm, not quite sure I follow the logic here. Why is the bpf_prog_put() not=
 placed inside
> __cpu_map_entry_free(), for example? Wouldn't this at least leave a poten=
tial small race
> window of UAF given the rest is still live? If we already piggy-back from=
 RCU side on
> rcpu entry, why not having it in __cpu_map_entry_free()?

ack right, thanks for spotting this issue. I guess we can even move
"bpf_prog_put(rcpu->prog)" in put_cpu_map_entry() so the last consumer
of bpf_cpu_map_entry will free the attached program. Agree?

Regards,
Lorenzo

>=20
> Thanks,
> Daniel

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXv+ZhwAKCRA6cBh0uS2t
rIaPAQDI2dsANFG7ROCWhtnyEh5uM7SznjFrszCsJtv+oRLxNQD5Ad9bZMszE2k3
kz9N2zbUU24X3g4Lf45oPAZ6v9A+Xgw=
=/VV4
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
