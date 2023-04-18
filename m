Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57666E5A92
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDRHg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDRHgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:36:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA74C1F;
        Tue, 18 Apr 2023 00:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9C762D6F;
        Tue, 18 Apr 2023 07:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AC2C433D2;
        Tue, 18 Apr 2023 07:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681803382;
        bh=E1EIySyr85mH28dqigAe0UMW4kBm9cIMgWf4lGA434Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jt2KCVvtGGVIeM4PDSCkgqGkbT+gt29mDtyO3GJO+f6LRY7iioOQ+L1/vhrefF3Ti
         OfSP9TCAwoERgJZLFb8TH7Z2eL8oFCS951vlFBM+Vz94J/4t+UM1PAPL5t8jGKeVG2
         bE7SWGZjcxnwW2MSnQvwdoACeEapvcaRF4AjZNI+3FkSEv71YCaEKNvdYfaoFSxv3q
         G90IRrDdqsurdrM4fH0JL0bQWt6SuNjfj4yl+hqaVCHr6V9nlXxBFGJpkscTFvOgXI
         gyJu0r8MFs1OOsAoHGUoCkPmt1Nqa4gcMUHF/1jJsUq0U2zVMI6/A7OWZU9ryOm7jd
         z81weMrFJsm2Q==
Date:   Tue, 18 Apr 2023 09:36:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD5IcgN5s9lCqIgl@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk>
 <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk>
 <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk>
 <20230417163210.2433ae40@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XpIrzH4lv/jz4U1A"
Content-Disposition: inline
In-Reply-To: <20230417163210.2433ae40@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XpIrzH4lv/jz4U1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
> > > If it's that then I'm with Eric. There are many ways to keep the pages
> > > in use, no point working around one of them and not the rest :( =20
> >=20
> > I was not clear here, my fault. What I mean is I can see the returned
> > pages counter increasing from time to time, but during most of tests,
> > even after 2h the tcp traffic has stopped, page_pool_release_retry()
> > still complains not all the pages are returned to the pool and so the
> > pool has not been deallocated yet.
> > The chunk of code in my first email is just to demonstrate the issue
> > and I am completely fine to get a better solution :)=20
>=20
> Your problem is perhaps made worse by threaded NAPI, you have
> defer-free skbs sprayed across all cores and no NAPI there to=20
> flush them :(

yes, exactly :)

>=20
> > I guess we just need a way to free the pool in a reasonable amount=20
> > of time. Agree?
>=20
> Whether we need to guarantee the release is the real question.

yes, this is the main goal of my email. The defer-free skbs behaviour seems=
 in
contrast with the page_pool pending pages monitor mechanism or at least they
do not work well together.

@Jesper, Ilias: any input on it?

> Maybe it's more of a false-positive warning.
>=20
> Flushing the defer list is probably fine as a hack, but it's not
> a full fix as Eric explained. False positive can still happen.

agree, it was just a way to give an idea of the issue, not a proper solutio=
n.

Regards,
Lorenzo

>=20
> I'm ambivalent. My only real request wold be to make the flushing=20
> a helper in net/core/dev.c rather than open coded in page_pool.c.
>=20
> Somewhat related - Eric, do we need to handle defer_list in dev_cpu_dead(=
)?

--XpIrzH4lv/jz4U1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD5IcgAKCRA6cBh0uS2t
rIqjAQDYt+gEaRt7vfajC3orbaGEGZW1pkY7eWVcst5V6UfQSAEAxTxX8Ry4wPh6
5yOcKeHWnsEuWXCC3QuiHpsgNIRCyg4=
=tNWN
-----END PGP SIGNATURE-----

--XpIrzH4lv/jz4U1A--
