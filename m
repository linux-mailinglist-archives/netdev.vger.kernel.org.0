Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4A86E5009
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjDQSSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjDQSR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCE110C4;
        Mon, 17 Apr 2023 11:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 751A462281;
        Mon, 17 Apr 2023 18:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEFC433EF;
        Mon, 17 Apr 2023 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681755470;
        bh=u8RO3q/EPUqyW8b/h/8J8mneFaR3qRLFSHONAXxidzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cB0JZRf07MYR2QZdkw+Ax/y5WqYn+uGSW+FRLLxK6YpPiMu+KaVUuWRRyX7KJstIb
         ppICCXf+oNa83fakgtyscyq7r5zfFQogrhBcM+v8nWHI1t2dem3ATuTCkFER7LGEFN
         2hlj9LOBsh2BgdP9DzbjWpCDcYb/VEG7+nNKJh31iC926/KaKpcjTiLC/+JiKpifd9
         oLpNrzePyF6yXKVHT/8fIdHxyRWGC7O4TER5PFtTNOHXmz4r3/sB9YakKXOG/xDCLK
         +7PyCkLM6liwVl+n6Imh17Zq9s6jimxGhg4ui6EByIxjc6QUSxj84R5PCKow2iqvBs
         tELu+yDjstTeA==
Date:   Mon, 17 Apr 2023 20:17:45 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD2NSSYFzNeN68NO@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZVHCXjE8VfIJ1RVD"
Content-Disposition: inline
In-Reply-To: <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZVHCXjE8VfIJ1RVD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Apr 17, 2023 at 7:53=E2=80=AFPM Lorenzo Bianconi <lorenzo@kernel.=
org> wrote:
> >
> > Hi all,
> >
> > I am triggering an issue with a device running the page_pool allocator.
> > In particular, the device is running an iperf tcp server receiving traf=
fic
> > from a remote client. On the driver I loaded a simple xdp program retur=
ning
> > xdp_pass. When I remove the ebpf program and destroy the pool, page_pool
> > allocator starts complaining in page_pool_release_retry() that not all =
the pages
> > have been returned to the allocator. In fact, the pool is not really de=
stroyed
> > in this case.
> > Debugging the code it seems the pages are stuck softnet_data defer_list=
 and
> > they are never freed in skb_defer_free_flush() since I do not have any =
more tcp
> > traffic. To prove it, I tried to set sysctl_skb_defer_max to 0 and the =
issue
> > does not occur.
> > I developed the poc patch below and the issue seems to be fixed:
>=20
> I do not see why this would be different than having buffers sitting
> in some tcp receive
> (or out or order) queues for a few minutes ?

The main issue in my tests (and even in mt76 I think) is the pages are not =
returned
to the pool for a very long time (even hours) and doing so the pool is like=
 in a
'limbo' state where it is not actually deallocated and page_pool_release_re=
try
continues complaining about it. I think this is because we do not have more=
 tcp
traffic to deallocate them, but I am not so familiar with tcp codebase :)

Regards,
Lorenzo

>=20
> Or buffers transferred to another socket or pipe (splice() and friends)

--ZVHCXjE8VfIJ1RVD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD2NSQAKCRA6cBh0uS2t
rLcRAP95LCnX8EAfhoDxA5tMbp9qJhAzcUepUbgXDpIFtRWN1QD/Wq6WWTX8Ftdd
pLNLRRQARCIuKxQeQ/rDOvIjmSTQrQo=
=ePva
-----END PGP SIGNATURE-----

--ZVHCXjE8VfIJ1RVD--
