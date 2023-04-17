Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD51D6E505C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDQSmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQSmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0C597;
        Mon, 17 Apr 2023 11:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B38620B2;
        Mon, 17 Apr 2023 18:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46916C433EF;
        Mon, 17 Apr 2023 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681756963;
        bh=ki4ES+2I8AB6U9GchiV3hNYyOL1Nyp5MfR+2cf6SL9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ScgRCUhNTe/wwXapdACaxswCx2wqc1a9KJ6jROXTWde78HroSE30ir00tCcPftXkm
         8lP6qBhvIODQycyB4alnaUd7eQToHB+1kfT5qDXueztophGhnntpxbZQasv+7NTA6A
         bJI5vop8nXizth7epyVgNXUc52GLcVyB66C6uhlfl7roStQpIVrOkbIilqcynQjEmx
         nmu+u7gOdDevPQBLffSczgwF735xaD4LiJ2vSB7/R4oZS1lUyKXaFXdSo/GpjG0hIa
         6LVIPXiN8t1EGOWhBoVNL35k2lUJVaOZdM9uYplrD/fDx35IVipjzjDbBD5sgonXWJ
         lUxWzC0HvIUCg==
Date:   Mon, 17 Apr 2023 20:42:39 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD2TH4PsmSNayhfs@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk>
 <20230417112346.546dbe57@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0ZbkaLD6THYBjI7F"
Content-Disposition: inline
In-Reply-To: <20230417112346.546dbe57@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0ZbkaLD6THYBjI7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 17 Apr 2023 20:17:45 +0200 Lorenzo Bianconi wrote:
> > > I do not see why this would be different than having buffers sitting
> > > in some tcp receive
> > > (or out or order) queues for a few minutes ? =20
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
>=20
> I've seen the page leaks too in my recent testing but I just assumed=20
> I fumbled the quick bnxt conversion to page pool. Could it be something
> with page frags? It happened a lot if I used page frags, IIRC mt76 is
> using page frags, too.

my device is allocating a full order 0 page from the pool so it is not rela=
ted
to fragmented pages as fixed for mt76 by Alex and Felix.

>=20
> Is drgn available for your target? You could try to scan the pages on
> the system and see if you can find what's still pointing to the page
> pool (assuming they are indeed leaked and not returned to the page
> allocator without releasing :()

I will test it but since setting sysctl_skb_defer_max to 0 fixes the issue,
I think the pages are still properly linked to the pool, they are just not
returned to it. I proved it using the other patch I posted [0] where I can =
see
the counter of returned pages incrementing from time to time (in a very long
time slot..).

Unrelated to this issue, but debugging it I think a found a page_pool leak =
in
skb_condense() [1] where we can reallocate the skb data using kmalloc for a
page_pool recycled skb.

Regards,
Lorenzo

[0] https://lore.kernel.org/netdev/20230417111204.08f19827@kernel.org/T/#t
[1] https://github.com/torvalds/linux/blob/master/net/core/skbuff.c#L6602

--0ZbkaLD6THYBjI7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD2THwAKCRA6cBh0uS2t
rNDUAP9l/oab/kBOC+oDTLQaUWpJ5MmnBOmHsQ8QN1Ie5A5u1AD9HdN4YDM76Xma
/78/yRj0u2ITSL0YXXl9uIbeYLa+nQo=
=BnxA
-----END PGP SIGNATURE-----

--0ZbkaLD6THYBjI7F--
