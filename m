Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC13141E92A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352497AbhJAImq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhJAImo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:42:44 -0400
X-Greylist: delayed 168938 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Oct 2021 01:41:00 PDT
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A5EBC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 01:41:00 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 3A4288E1CA;
        Fri,  1 Oct 2021 09:40:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1633077659; bh=LiX86xvqcefFAtTdTii9I8A5NVl44Dp20SzXGYfzn8A=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Fri,=201=20Oct=202021=2009:40:59=20+0100|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Eyal=20Birger=20<eyal.birger@gm
         ail.com>|Cc:=20jchapman@katalix.com,=20netdev@vger.kernel.org|Subj
         ect:=20Re:=20[RFC=20PATCH=20net-next=200/3]=20support=20"flow-base
         d"=20datapath=20in=20l2tp|Message-ID:=20<20211001084058.GA5460@kat
         alix.com>|References:=20<20210929094514.15048-1-tparkin@katalix.co
         m>=0D=0A=20<1fe9bf2a-0650-a9ee-b91d-febcf3d22612@gmail.com>|MIME-V
         ersion:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<1fe9bf
         2a-0650-a9ee-b91d-febcf3d22612@gmail.com>;
        b=iAIJK/Dcq1eaHx6Rmea2WHcJidvl5i3/nhbKHrFlBJDl1b6LP6qP97k1F0h44GAaL
         +h7FDyQ+i3Rhu1hMAs+Su6ePRnFHp/LyYa4Rlp/RpVsLz8/+zuGykPIJsTUnvH2FLQ
         GPK8QTuRkTH+fklqBqVfuCxJnr6TRr3m8S1jkuDhPZJrKFZklYjkYNBavU+JNEO7P0
         PtdcEPio8aL3qUiwCvx/o1TvbNTz3khjIHCudA/2uhOV2HGbtjuKcskPt2ziMFBpz3
         jNp/px1oihm0iXR1MbhutfFBoi6sjkRKeYPeQmu/ho2Ja2/KDGE6mOTVQV00yQEUbD
         kVTQPlolzw5tQ==
Date:   Fri, 1 Oct 2021 09:40:59 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     jchapman@katalix.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/3] support "flow-based" datapath in l2tp
Message-ID: <20211001084058.GA5460@katalix.com>
References: <20210929094514.15048-1-tparkin@katalix.com>
 <1fe9bf2a-0650-a9ee-b91d-febcf3d22612@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1fe9bf2a-0650-a9ee-b91d-febcf3d22612@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Wed, Sep 29, 2021 at 13:03:21 +0300, Eyal Birger wrote:
> Hi Tom,
>=20
> On 29/09/2021 12:45, Tom Parkin wrote:
> ...
> >        The skb is then redirected to the tunnel virtual netdev: tc rules
> >        can then be added to match traffic based on the session ID and
> >        redirect it to the correct interface:
> >=20
> >              tc qdisc add dev l2tpt1 handle ffff: ingress
> >              tc filter add dev l2tpt1 \
> >                      parent ffff: \
> >                      flower enc_key_id 1 \
> >                      action mirred egress redirect dev eth0
> >=20
> >        In the case that no tc rule matches an incoming packet, the tunn=
el
> >        virtual device implements an rx handler which swallows the packet
> >        in order to prevent it continuing through the network stack.
>=20
> There are other ways to utilize the tunnel key on rx, e.g. in ip rules.
>=20
> IMHO it'd be nicer if the decision to drop would be an administrator
> decision which they can implement using a designated tc drop rule.

Good point, and one I hadn't considered.

My concern with letting the packet enter the stack is that it could
possibly cause issues, but maybe it's better to allow the admin to
make that call.

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmFWyZMACgkQlIwGZQq6
i9BeSQf/Qd0pyNYDhwbKQ2gz1eUhI0sW7/FFAbWukJb/6c73q6QfG9A9V51ORPfa
PJtXNogcd48giaxf4Ry8lIFEKQEN7tXVrcpNSHkW8y0HuWPUPGzi2e6252r+5tny
LjDyJyaejBXBqIdgLMUOUM9tFuBZZb/GN/05wxyvLtWeWCXE4rk5jFAD972kgw3g
IzP7vih7raRSlXeorHb/QNKYY2ib1zOzEMjR5gC8ZCa6vRbeganXaZHMJGT5FS2f
TXmtLlP+jX1aS/6OPbWPfp30rIWf4I9lH8naKvO1huVZtoYr2F/Ians3eau7y8Vu
2aTrmfuA2FxkubXJg5ODjI4KwhNmHg==
=Qqft
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
