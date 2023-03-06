Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA606AC6FA
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjCFQCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCFQCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:02:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F23A38679;
        Mon,  6 Mar 2023 08:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E6E36102C;
        Mon,  6 Mar 2023 16:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD13C4339C;
        Mon,  6 Mar 2023 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678118474;
        bh=6/kPY6G6Svg0te3uLDPOCCrp1vKJWU98W01va9m9RUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N4210lP8/snfv9NbE3rzkqhrurDYhltsPmrhpiheJIMgs4l+xopd+EgARpaNVtr0W
         VBI/lHFigPwFt8oUpfG0SNQHwy7UQeTrgLCkPx/oOHNn2/ZqlTItn70StJ+0e4/Jmw
         99SofbWyC8LiZmrVbwbDxlgWFjT/mpYttWZec1ODRvqi1NDpjNtg4S4XuXGH7S0Hy7
         9i4T0HmN3eHOb5UmnHAJrzHzqb8AtMgRDmNVXgSd/a5bKOpX3jMUnnwg4X8AXB2Cnt
         tji5vN3Sc9eXnLvPtyf2+1TrYILt/rVEdHYQx/6fI+Gtg6/qrP8MlthRyWOf7Mhk4W
         WIV/aHM60KtSw==
Date:   Mon, 6 Mar 2023 17:01:10 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next] selftests/bpf: use ifname instead of ifindex in
 XDP compliance test tool
Message-ID: <ZAYORsGRSdCsV8fL@lore-desk>
References: <5d11c9163490126fdc391dacb122480e4c059e62.1677863821.git.lorenzo@kernel.org>
 <19947245-b305-f9c5-f79d-f79a152aaaaa@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CzwNbl2V2nYwT7nc"
Content-Disposition: inline
In-Reply-To: <19947245-b305-f9c5-f79d-f79a152aaaaa@iogearbox.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CzwNbl2V2nYwT7nc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 3/3/23 6:21 PM, Lorenzo Bianconi wrote:
> > Rely on interface name instead of interface index in error messages or =
logs
> > from XDP compliance test tool.
> > Improve XDP compliance test tool error messages.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   tools/testing/selftests/bpf/xdp_features.c | 92 ++++++++++++++--------
> >   1 file changed, 57 insertions(+), 35 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing=
/selftests/bpf/xdp_features.c
> > index fce12165213b..7414801cd7ec 100644
> > --- a/tools/testing/selftests/bpf/xdp_features.c
> > +++ b/tools/testing/selftests/bpf/xdp_features.c
> > @@ -25,6 +25,7 @@
> >   static struct env {
> >   	bool verbosity;
> > +	char ifname[IF_NAMESIZE];
> >   	int ifindex;
> >   	bool is_tester;
> >   	struct {
> > @@ -109,25 +110,25 @@ static int get_xdp_feature(const char *arg)
> >   	return 0;
> >   }
> > -static char *get_xdp_feature_str(void)
> > +static char *get_xdp_feature_str(bool color)
> >   {
> >   	switch (env.feature.action) {
> >   	case XDP_PASS:
> > -		return YELLOW("XDP_PASS");
> > +		return color ? YELLOW("XDP_PASS") : "XDP_PASS";
> >   	case XDP_DROP:
> > -		return YELLOW("XDP_DROP");
> > +		return color ? YELLOW("XDP_DROP") : "XDP_DROP";
> >   	case XDP_ABORTED:
> > -		return YELLOW("XDP_ABORTED");
> > +		return color ? YELLOW("XDP_ABORTED") : "XDP_ABORTED";
> >   	case XDP_TX:
> > -		return YELLOW("XDP_TX");
> > +		return color ? YELLOW("XDP_TX") : "XDP_TX";
> >   	case XDP_REDIRECT:
> > -		return YELLOW("XDP_REDIRECT");
> > +		return color ? YELLOW("XDP_REDIRECT") : "XDP_REDIRECT";
> >   	default:
> >   		break;
> >   	}
> >   	if (env.feature.drv_feature =3D=3D NETDEV_XDP_ACT_NDO_XMIT)
> > -		return YELLOW("XDP_NDO_XMIT");
> > +		return color ? YELLOW("XDP_NDO_XMIT") : "XDP_NDO_XMIT";
> >   	return "";
> >   }
>=20
> Please split this into multiple patches, logically separated. This one is=
 changing
> multiple things at once and above has not much relation to relying on int=
erface names.

ack, I will do.

Regards,
Lorenzo

>=20
> Thanks,
> Daniel

--CzwNbl2V2nYwT7nc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAYORgAKCRA6cBh0uS2t
rMVXAQCzzZntylSPJkLD+vXsYiIDrSSygM/F0fHvQkSbcTOcOwEAwMOH8HEWvyGu
cyVfEW7iScK/cHdOUtWNiPxSz47VZgM=
=/dnG
-----END PGP SIGNATURE-----

--CzwNbl2V2nYwT7nc--
