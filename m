Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B06CF408
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjC2UJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC2UJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:09:00 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1B930F0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=jVC71MKka5GwL22KLFhsCqjy1I9i
        gdQGt6oQsMi8/RU=; b=k15j8HHtG64h8Y/Yv4CTHSsDk7wcd6SuYASYOluR7ez9
        x9Ju76ikKEI4WHD77d0aI7PO+9x5ebECu507mVjsKTHpvIw5Np9C+hUQeHIr+b9t
        hvIrSq4y4u1t9CHl0JkVYnvpu5e2NLKzNoA3nyTBlfovBLlXME+6ad6OEr1uIak=
Received: (qmail 658237 invoked from network); 29 Mar 2023 21:48:56 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 29 Mar 2023 21:48:56 +0200
X-UD-Smtp-Session: l3s3148p1@X5gvRA/4BtIgAQnoAF81ABGoRcrvNTIr
Date:   Wed, 29 Mar 2023 21:48:55 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Message-ID: <ZCSWJxuu1EY/zBFm@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
 <20230329123958.045c9861@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GaZuoAIg4Gz9odJu"
Content-Disposition: inline
In-Reply-To: <20230329123958.045c9861@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GaZuoAIg4Gz9odJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 29, 2023 at 12:39:58PM -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 08:40:10 +0200 Wolfram Sang wrote:
> > Otherwise the clocks are not enabled and reading registers will OOPS.
> > Copy the behaviour from Renesas SH_ETH and use a custom flag because
> > using netif_running() is racy. A generic solution still needs to be
> > implemented. Tested on a Renesas APE6-EK.
>=20
> Hm, so you opted to not add the flag in the core?
> To keep the backport small? I think we should just add it..
> Clearly multiple drivers would benefit and it's not a huge change.

I did it this way for two reasons. First, yes, this is a minimal patch
for backporting. No dependency on core changes, very easy. Second, this
is a solution I could develop quickly. I am interested in finding
another solution, but I guess it needs more time, especially as it
probably touches 15 drivers. I created an action item for it. I hope
I'll be able to work on it somewhen. But for now, I just need the SMSC
bug fixed and need to move to the next issue. If we later have the
generic solution, converting this driver also won't make a lot of a
difference.


--GaZuoAIg4Gz9odJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQklicACgkQFA3kzBSg
KbZMkA/8CWM8Ei0PxOxZQ3W35STQePadi2e4+Uuydqfb7kc3xVhWa7MGrzyqFCKq
RyfjFDd2Xeo6UQOJE5UPjO8IdilZPnGAtJTSVRkXr5xPU4ozE3syuD4JkumHa2nx
lFtbl8+x4d5aNwlTqUGw48yxOTHB40bzNMPbAL3xP7L1VIiMcRUBy5LIgaTG36nh
Wu7rWm7zx73p7OYIiV7G2aTTOQRd0uoQ9PC3HoHE10s9ps6ulGOOpSyz4fJuXn3c
v7/pGTX6kCbxnFE5wlH4BwECG2bRid0/i6ZwWKJWK2W2HvXujZReo2eHdaAzEytb
DpNwGCKpPouf1NbNby8/yCoc/ncUPhC0x1uCbqOM+Il2olzh617xPDzvxV6388hn
HMMbL7MoNs+FXSllv7kKVxgrXfH5rhtFlvo1c5odL2/DKExuVoN2fCDya5aCAQTs
OhaZnfANPyhfZStnQSvPpzfeeIWXhvMOz+Pi9VlrZxAbEAdjPwJr+241GFI+J1V8
U6UmuA77jaut4oHFGEFqP6sJcSx/olxmyphiGF4DRXO2/9UQ8cjiq4m7rZNtbaas
ZVHUFdDy+Zmt976KrJXjtVL4HoRkZb95UZkBigC6FWNjPvwCfpnRyEwLCHihNfBL
iGAgrMVUgxM7MZTVxrzNyPdLLOt3VqIcifSmLCx31qU5vgwMNes=
=xZu0
-----END PGP SIGNATURE-----

--GaZuoAIg4Gz9odJu--
