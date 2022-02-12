Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF54B3466
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 12:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiBLLD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 06:03:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiBLLD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 06:03:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EAD26118;
        Sat, 12 Feb 2022 03:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F82260C39;
        Sat, 12 Feb 2022 11:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E3BC340E7;
        Sat, 12 Feb 2022 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644663833;
        bh=WBxU8KD2tx8yFPWkCbVlkknktZ8woK4/C70+cUT2Zn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gDxvQMLVmTUQ1ghllMVEXweI3x22o77EItHUL5WrNFsZ0E+5OgBRB8Dv6aghQYEmK
         JGxWiNMXtyBol3MPipq0Rh3EEslCpO7n9q1Gglt+ayjgdwW+y0CWIZrLxZsGzTdldE
         CFGKMpxRjZtBv8H9Q3akx4S47zQvFOCex/QPtHBT4X2MfhWehAWVwoJNsAZcxqI+uw
         9UYMOqfd0HMpVVgZ4IoK7R/ueLHVcEzf0hMj+OQuFysyETcJ4RBe6rSd6c+yhxn7VX
         AuNk8HdjnTbZoxGNiM4NycKfMVYod5d7z3OHTun+L8MaMk4ihEBS3WT8sWrbZRYA+5
         8TsZ8+YVKg9TA==
Date:   Sat, 12 Feb 2022 12:03:49 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to
 accept non-linear skb
Message-ID: <YgeUFb4LIP7VfeL9@lore-desk>
References: <cover.1644541123.git.lorenzo@kernel.org>
 <8c5e6e5f06d1ba93139f1b72137f8f010db15808.1644541123.git.lorenzo@kernel.org>
 <20220211170414.7223ff09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kY1oPGr7SkP0djq6"
Content-Disposition: inline
In-Reply-To: <20220211170414.7223ff09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kY1oPGr7SkP0djq6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb 11, Jakub Kicinski wrote:
> On Fri, 11 Feb 2022 02:20:31 +0100 Lorenzo Bianconi wrote:
> > +	if (skb_shared(skb) || skb_head_is_locked(skb)) {
>=20
> Is this sufficient to guarantee that the frags can be written?
> skb_cow_data() tells a different story.

Do you mean to consider paged part of the skb always not writable, right?
In other words, we should check something like:

	if (skb_shared(skb) || skb_head_is_locked(skb) ||
	    skb_shinfo(skb)->nr_frags) {
	    ...
	}

Regards,
Lorenzo

--kY1oPGr7SkP0djq6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYgeUFQAKCRA6cBh0uS2t
rK7TAP49QVtQPAOU594/gvg59ydlesiIqubsDusmQOqoDMhDhgEA0SHdxUlB09Wb
9xBPXSmUIHZZVcxFXdfZzXHM0t1mJwo=
=AcAC
-----END PGP SIGNATURE-----

--kY1oPGr7SkP0djq6--
