Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4526E2C5A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDNWLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDNWLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A649ED3;
        Fri, 14 Apr 2023 15:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C53664AA4;
        Fri, 14 Apr 2023 22:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAA5C433D2;
        Fri, 14 Apr 2023 22:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510240;
        bh=m8ztmkxGHLpNvwlcZaVUqweOfgxcnEEnJ5XyWqlY8CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=garkfzQfIFv1yYfM31+29JOxqg3MAXv+Ce70Q+DO3UXIaM1Y4afPSjHyqAXrMtyg5
         vU7LnvLwSSFOK/gbS9dAXYcuPFmbGRfA3lTKceAIB58BTMdDoBV/mqdG6+dAxNtQH3
         LbXFBIMXpnrtkfsK5J4e99jHkkWrIQw+2zbih6Gh0c0LtKWXErx7uGRjZTq1l9FIuc
         byFOK+KcVrnzQfaxqy1+dJyTDd7Vry+UxhjDlM8wFKANHnCdxEyjJLftfb020gQiWk
         Z4R0dLsTtf1un1wlxOP0x7gTgRYmdh+5MkwcIIncN6GAevcnA+B8bTC866G6HnVWE1
         dnDWhDBFVdmFA==
Date:   Sat, 15 Apr 2023 00:10:37 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, joamaki@gmail.com
Subject: Re: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features for
 xdp_bonding selftest
Message-ID: <ZDnPXYvfu46i0YpE@lore-desk>
References: <73f0028461c4f3fa577e24d8d797ddd76f1d17c6.1681507058.git.lorenzo@kernel.org>
 <dc994c7b-c8fe-df8e-7203-0d6dae8dee9f@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4w4QKCOT6HRniluA"
Content-Disposition: inline
In-Reply-To: <dc994c7b-c8fe-df8e-7203-0d6dae8dee9f@iogearbox.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4w4QKCOT6HRniluA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 4/14/23 11:21 PM, Lorenzo Bianconi wrote:
> > NETDEV_XDP_ACT_NDO_XMIT is not enabled by default for veth driver but it
> > depends on the device configuration. Fix XDP_REDIRECT xdp-features in
> > xdp_bonding selftest loading a dummy XDP program on veth2_2 device.
> >=20
> > Fixes: fccca038f300 ("veth: take into account device reconfiguration fo=
r xdp_features flag")
>=20
> Hm, does that mean we're changing^breaking existing user behavior iff aft=
er
> fccca038f300 you can only make it work by loading dummy prog?

nope, even before in order to enable ndo_xdp_xmit for veth you should load =
a dummy
program on the device peer or enable gro on the device peer:

https://github.com/torvalds/linux/blob/master/drivers/net/veth.c#L477

we are just reflecting this behaviour in the xdp_features flag.

Regards,
Lorenzo

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   tools/testing/selftests/bpf/prog_tests/xdp_bonding.c | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> >=20
> > diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/too=
ls/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > index 5e3a26b15ec6..dcbe30c81291 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > @@ -168,6 +168,17 @@ static int bonding_setup(struct skeletons *skeleto=
ns, int mode, int xmit_policy,
> >   		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_pro=
g, "veth1_2"))
> >   			return -1;
> > +
> > +		if (!ASSERT_OK(setns_by_name("ns_dst"), "set netns to ns_dst"))
> > +			return -1;
> > +
> > +		/* Load a dummy XDP program on veth2_2 in order to enable
> > +		 * NETDEV_XDP_ACT_NDO_XMIT feature
> > +		 */
> > +		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog=
, "veth2_2"))
> > +			return -1;
> > +
> > +		restore_root_netns();
> >   	}
> >   	SYS("ip -netns ns_dst link set veth2_1 master bond2");
> >=20
>=20

--4w4QKCOT6HRniluA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZDnPXQAKCRA6cBh0uS2t
rEgkAQC7bbdVcHdcWxHXqaujUS1MUUCfLARedDYXzIVi5tVyWwEApzcoPikfRCxD
w4NhE142M+nV2UwB1GBcAI5c9DKX9A4=
=aqKn
-----END PGP SIGNATURE-----

--4w4QKCOT6HRniluA--
