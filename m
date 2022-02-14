Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34294B5C3F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiBNVDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:03:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiBNVDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:03:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714A2EBACE;
        Mon, 14 Feb 2022 13:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26626B816C2;
        Mon, 14 Feb 2022 21:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BFAC340F1;
        Mon, 14 Feb 2022 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644872618;
        bh=Vzr6XeMghrQMZf6dR4Z9pFif4dP5e/3n3DhBqODDXDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ix5Kler5zTcUBj+9I29YvlqPLmQgwLTHe7qBZyzSMD9qrYB5NJUcc6UdEBq/1Ycu9
         ZK0NTZKeENw8rXHCfwYgehwZp3bSWQTlI0D4lasRE0FA2kXDul2MzxwLxb52vIBae9
         7B4PHUFZ5bC6MhyZ34nCwm0DwMNiDEpax7LE7fb29m0UZ6+Dj6nCOq4R+jFSzeFBj5
         KSju1XZ8IdrdPnaH61ZdYSVmUZ09p1hIsKg4UE94SV6cgBiURAyBYpt8oaIHETZ2zf
         7iqo4U8OoRwVwrPzM/If3v2aDX7KKXS0vTieQABF40KGZ80ox2+cFrkaL6+MoanLde
         9tGDbBAAH935A==
Date:   Mon, 14 Feb 2022 22:03:34 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to
 accept non-linear skb
Message-ID: <YgrDppq+PRD7j/C8@lore-desk>
References: <cover.1644541123.git.lorenzo@kernel.org>
 <8c5e6e5f06d1ba93139f1b72137f8f010db15808.1644541123.git.lorenzo@kernel.org>
 <20220211170414.7223ff09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgeUFb4LIP7VfeL9@lore-desk>
 <20220214074824.370d7ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r0qIdVg9eNDG7qVF"
Content-Disposition: inline
In-Reply-To: <20220214074824.370d7ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r0qIdVg9eNDG7qVF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 12 Feb 2022 12:03:49 +0100 Lorenzo Bianconi wrote:
> > On Feb 11, Jakub Kicinski wrote:
> > > On Fri, 11 Feb 2022 02:20:31 +0100 Lorenzo Bianconi wrote: =20
> > > > +	if (skb_shared(skb) || skb_head_is_locked(skb)) { =20
> > >=20
> > > Is this sufficient to guarantee that the frags can be written?
> > > skb_cow_data() tells a different story. =20
> >=20
> > Do you mean to consider paged part of the skb always not writable, righ=
t?
> > In other words, we should check something like:
> >=20
> > 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> > 	    skb_shinfo(skb)->nr_frags) {
> > 	    ...
> > 	}
>=20
> Yes, we do have skb_has_shared_frag() but IDK if it guarantees frags
> are writable :S

ack, I will add skb_shinfo(skb)->nr_frags check in v2.

Regards,
Lorenzo

--r0qIdVg9eNDG7qVF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYgrDpgAKCRA6cBh0uS2t
rGOKAQDR2myo8QXwC7qrn0mBpZuffKnp7rwLHWl8IrSMUVSIKgD+POuZknmEswXs
+d2Ldcx6aRJxPIO05wFHsPBfD3wwUgo=
=gYuF
-----END PGP SIGNATURE-----

--r0qIdVg9eNDG7qVF--
