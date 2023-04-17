Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7406E507D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjDQTAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDQTAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:00:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E993594;
        Mon, 17 Apr 2023 12:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23AE362079;
        Mon, 17 Apr 2023 19:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2B3C433EF;
        Mon, 17 Apr 2023 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681758037;
        bh=Ieb2T9q3VFxs2dTsu9bUlfQj5INYqMWicbMHmv2GEk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrFjHSnsfFbDF3DKeUORX68ReWzIgiyh0DhkRtcJOMdZCmH6Wmk88igXL0OjhmsS+
         cqk+z/KFk5T64aI2iHzC7cTtFDeY0NZM15uwoY7KkMqBnf6ndNZ2EGTpNp2Sus3B2F
         khpy3VFdGhu5czdCPxUNfIErRvEyq60pJQ26VYCtB6rsJ8I7wcDY3GU87ieJmMGg94
         FrVZ6d908P63Tp2I+fEQ5+2GDf5goPMb58Rymb/XCaD+Le5VqMtCg4853NXOYoHJaS
         VDJp6BcdTnImhBkgeBoGF9x3pt4nWWi6O9YZVlcIrp/hE9Ga1B9bkWElHV9Of+DnCo
         DeqbRdRFBm0jA==
Date:   Mon, 17 Apr 2023 21:00:33 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD2XURJiV+PTpZ3a@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk>
 <4520b112-96c7-2dd8-b2c0-027961eb3a7c@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3i/09exFkAMOBkPR"
Content-Disposition: inline
In-Reply-To: <4520b112-96c7-2dd8-b2c0-027961eb3a7c@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3i/09exFkAMOBkPR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 17.04.23 20:17, Lorenzo Bianconi wrote:
> > > On Mon, Apr 17, 2023 at 7:53=E2=80=AFPM Lorenzo Bianconi <lorenzo@ker=
nel.org> wrote:
> > > >=20
> > > > Hi all,
> > > >=20
> > > > I am triggering an issue with a device running the page_pool alloca=
tor.
> > > > In particular, the device is running an iperf tcp server receiving =
traffic
> > > > from a remote client. On the driver I loaded a simple xdp program r=
eturning
> > > > xdp_pass. When I remove the ebpf program and destroy the pool, page=
_pool
> > > > allocator starts complaining in page_pool_release_retry() that not =
all the pages
> > > > have been returned to the allocator. In fact, the pool is not reall=
y destroyed
> > > > in this case.
> > > > Debugging the code it seems the pages are stuck softnet_data defer_=
list and
> > > > they are never freed in skb_defer_free_flush() since I do not have =
any more tcp
> > > > traffic. To prove it, I tried to set sysctl_skb_defer_max to 0 and =
the issue
> > > > does not occur.
> > > > I developed the poc patch below and the issue seems to be fixed:
> > >=20
> > > I do not see why this would be different than having buffers sitting
> > > in some tcp receive
> > > (or out or order) queues for a few minutes ?
> >=20
> > The main issue in my tests (and even in mt76 I think) is the pages are =
not returned
> > to the pool for a very long time (even hours) and doing so the pool is =
like in a
> > 'limbo' state where it is not actually deallocated and page_pool_releas=
e_retry
> > continues complaining about it. I think this is because we do not have =
more tcp
> > traffic to deallocate them, but I am not so familiar with tcp codebase =
:)
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > Or buffers transferred to another socket or pipe (splice() and friend=
s)
>=20
> I'm not absolutely sure that it is the same problem, but I also saw some
> problems with page_pool destroying and page_pool_release_retry(). I did
> post it, but I did not get any reply:
>=20
> https://lore.kernel.org/bpf/20230311213709.42625-1-gerhard@engleder-embed=
ded.com/T/
>=20
> Could this be a similar issue?

I am not sure too. In order to prove it is the same issue, I would say you =
can try to
run the test applying my poc patch or setting sysctl_skb_defer_max to 0.

Regards,
Lorenzo

>=20
> Gerhard

--3i/09exFkAMOBkPR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD2XUQAKCRA6cBh0uS2t
rFtsAP0SaHw57p8Rs+E9GelfUs46j5SEB2fWbbxuFHpfQ3pvdgEAichFfiJTdYJV
wWMh5n9u6NIkdD4AdZXItcPe23fgNwg=
=pzTl
-----END PGP SIGNATURE-----

--3i/09exFkAMOBkPR--
