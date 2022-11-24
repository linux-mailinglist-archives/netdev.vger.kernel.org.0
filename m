Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572736375ED
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKXKHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKXKHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:07:53 -0500
Received: from mail.katalix.com (mail.katalix.com [3.9.82.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7DA1286FA
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:07:52 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id EB3707DACC;
        Thu, 24 Nov 2022 10:07:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1669284472; bh=dpSC8SCYIaor6R/RST2fo2VXoP/UpFIlng0KL5Wk/Wo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=2024=20Nov=202022=2010:07:51=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20Tetsuo=20Handa=20<penguin-kernel@i-love.sakura.ne.
         jp>,=0D=0A=09Jakub=20Sitnicki=20<jakub@cloudflare.com>,=20netdev@v
         ger.kernel.org,=0D=0A=09"David=20S.=20Miller"=20<davem@davemloft.n
         et>,=0D=0A=09Eric=20Dumazet=20<edumazet@google.com>,=0D=0A=09Jakub
         =20Kicinski=20<kuba@kernel.org>,=20Paolo=20Abeni=20<pabeni@redhat.
         com>,=0D=0A=09syzbot+703d9e154b3b58277261@syzkaller.appspotmail.co
         m,=0D=0A=09syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,=
         0D=0A=09syzbot+de987172bb74a381879b@syzkaller.appspotmail.com|Subj
         ect:=20Re:=20[PATCH=20net]=20l2tp:=20Don't=20sleep=20and=20disable
         =20BH=20under=20writer-side=0D=0A=20sk_callback_lock|Message-ID:=2
         0<20221124100751.GA6671@katalix.com>|References:=20<a850c224-f728-
         983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>=0D=0A=20<87wn7o7k7r.fs
         f@cloudflare.com>=0D=0A=20<ef09820a-ca97-0c50-e2d8-e1344137d473@I-
         love.SAKURA.ne.jp>=0D=0A=20<87fseb7vbm.fsf@cloudflare.com>=0D=0A=2
         0<f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>=0D=0A=
         20<871qpvmfab.fsf@cloudflare.com>=0D=0A=20<a3b7d8cd-0c72-8e6b-78f2
         -71b92e70360f@I-love.SAKURA.ne.jp>=0D=0A=20<20221122141011.GA3303@
         pc-4.home>=0D=0A=20<c50bb326-7946-82b9-418a-95638818aa84@I-love.SA
         KURA.ne.jp>=0D=0A=20<20221123152400.GA18177@pc-4.home>|MIME-Versio
         n:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20221123152
         400.GA18177@pc-4.home>;
        b=X8xYMO+5J/gb+LrJAn2x/KJ4ajnPeX9Ad7MGWSVK4APgl80/MseDNQjdzK6kRBTPc
         huqaH+QH20j6LeUXkpf/2vsbwGfqIZE+ka5k/4Yh8I9FAoXM25Rile52e8uDVgc9Y6
         hLhC93/Wu1LFyGPlbxKHLeDLV+Z1EO5AInr7LbWwVfwnekERxfve6Xupod+3iGq4qQ
         MgL14er5fr2XxDvX3rjYVciZlE/9u3IBXqx7emdzLWKLFRyIe8bKxlqlubOsm37NfU
         vqHC1F1vr+ONKrzruQlZUXfHPqsyZiCpIFk5YPjy7tq6IAwfcKxagPosh47ZDDS2uo
         Scu1ngqWBeQJg==
Date:   Thu, 24 Nov 2022 10:07:51 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Message-ID: <20221124100751.GA6671@katalix.com>
References: <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
 <871qpvmfab.fsf@cloudflare.com>
 <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
 <20221122141011.GA3303@pc-4.home>
 <c50bb326-7946-82b9-418a-95638818aa84@I-love.SAKURA.ne.jp>
 <20221123152400.GA18177@pc-4.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20221123152400.GA18177@pc-4.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Wed, Nov 23, 2022 at 16:24:00 +0100, Guillaume Nault wrote:
> On Tue, Nov 22, 2022 at 11:28:45PM +0900, Tetsuo Handa wrote:
> > That's what I thought at https://lkml.kernel.org/r/c64284f4-2c2a-ecb9-a=
08e-9e49d49c720b@I-love.SAKURA.ne.jp .
> >=20
> > But the problem is not that setup_udp_tunnel_sock() can sleep. The prob=
lem is that lockdep
> > gets confused due to changing lockdep class after the socket is already=
 published. We need
> > to avoid calling lockdep_set_class_and_name() on a socket retrieved via=
 sockfd_lookup().
>=20
> This is a second problem. The problem of setting sk_user_data under
> sk_callback_lock write protection (while still calling
> udp_tunnel_encap_enable() from sleepable context) still remains.
>=20
> For lockdep_set_class_and_name(), maybe we could store the necessary
> socket information (addresses, ports and checksum configuration) in the
> l2tp_tunnel structure, thus avoiding the need to read them from the
> socket. This way, we could stop locking the user space socket in
> l2tp_xmit_core() and drop the lockdep_set_class_and_name() call.
> I think either you or Jakub proposed something like this in another
> thread.

I note that l2tp_xmit_core calls ip_queue_xmit which expects a socket
atomic context*.

It also accesses struct inet_sock corking data which may also need locks
to safely access.

Possibly we could somehow work around that, but on the face of it we'd
need to do a bit more work to avoid the socket lock in the tx path.

* davem fixed locking in the l2tp xmit path in:

6af88da14ee2 ("l2tp: Fix locking in l2tp_core.c")
--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmN/QnMACgkQlIwGZQq6
i9A6Nwf/exjZ9k78BOqCIAbnGfl5l54ORpYoydj4mzrWGIbAJr2ndQUwLG4Ck7rC
i4HdKMW3XvHetM706wl31oBazMTmDnEKr4beXF7xc9a1hf1TavdWSFGp3MGhbgl/
4EaHHDdqIKCK9juX/Htk0JROx7c+GLZlSmngxRaJ9ndKa1kTsrY3/IWT6/+vURgQ
eu1kZ+S6/IP60nsyNjJx7mrJJ38ud494vbyDyjjgSl7P9bDxjrKRue2LFCNSpBie
i/aPSu8x9tRICbWVDTKLMx4rhsPOOPxRoWvgnWV6jP2oE0j0T/4qZfzWz1qRjVz0
pVPQ31mXQe6fIL2XeRCt/sQ7MjUe9w==
=J7gW
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
