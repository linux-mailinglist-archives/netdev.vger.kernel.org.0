Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9270F2F1019
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbhAKK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:29:41 -0500
Received: from mail.katalix.com ([3.9.82.81]:36800 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbhAKK3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 05:29:40 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 25C947D722;
        Mon, 11 Jan 2021 10:28:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1610360939; bh=bTpyf17xeL+79t4qa6NHSCi5T21B9QFRslHYKCcMj/k=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2011=20Jan=202021=2010:28:58=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[PATCH=20net=20v3]=20ppp:=20fix=20refcount=20underfl
         ow=20on=20channel=20unbridge|Message-ID:=20<20210111102858.GA6062@
         katalix.com>|References:=20<20210107181315.3128-1-tparkin@katalix.
         com>=0D=0A=20<20210108205750.GA14215@linux.home>|MIME-Version:=201
         .0|Content-Disposition:=20inline|In-Reply-To:=20<20210108205750.GA
         14215@linux.home>;
        b=SzBnEmd/uBu4ZYo09QNHPtPowcILETmK9PMZC3Zq/vUpAZDvgKzhlULtHGxQ36+qM
         WBAEX64uWgGfuZ7KaSBmFCah1huz3Xsgk+oJkG0pvcKkdXtCHkaA/DIIuQtH64Km2E
         QenG0k64CfZbxv+eEJH6yRywEX76Omlg1sfY4VBWm4XiVdkJD3UgrY3dKhcdF/W1vH
         8vbvV3UzKcYDTY63T/TVOnds6cyeNA9oaJ5qdLepy/o/c+XWc9tOr1wZbNDMJxMzdq
         L8vHBckUiqKLQ1fFCClLRHCVjotGUrLAOPWVGFj8JQEKCuFOsTjFrdG0rhsN9LV5q6
         Zds/2EarJh7uQ==
Date:   Mon, 11 Jan 2021 10:28:58 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net v3] ppp: fix refcount underflow on channel unbridge
Message-ID: <20210111102858.GA6062@katalix.com>
References: <20210107181315.3128-1-tparkin@katalix.com>
 <20210108205750.GA14215@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20210108205750.GA14215@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 08, 2021 at 21:57:50 +0100, Guillaume Nault wrote:
> On Thu, Jan 07, 2021 at 06:13:15PM +0000, Tom Parkin wrote:
> > When setting up a channel bridge, ppp_bridge_channels sets the
> > pch->bridge field before taking the associated reference on the bridge
> > file instance.
> >=20
> > This opens up a refcount underflow bug if ppp_bridge_channels called
> > via. iotcl runs concurrently with ppp_unbridge_channels executing via.
> > file release.
> >=20
> > The bug is triggered by ppp_bridge_channels taking the error path
> > through the 'err_unset' label.  In this scenario, pch->bridge is set,
> > but the reference on the bridged channel will not be taken because
> > the function errors out.  If ppp_unbridge_channels observes pch->bridge
> > before it is unset by the error path, it will erroneously drop the
> > reference on the bridged channel and cause a refcount underflow.
> >=20
> > To avoid this, ensure that ppp_bridge_channels holds a reference on
> > each channel in advance of setting the bridge pointers.
>=20
> Thanks for following up on this!
>=20
> Acked-by: Guillaume Nault <gnault@redhat.com>

Thanks again for reviewing, Guillaume.

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/8KGUACgkQlIwGZQq6
i9AC4gf+NOEQkelSMa+Z9nVcCS777yaxKRrwyIroX8i2gZag5scN+d2gl8I8qnNC
VvNNky+/4IkEK17KAhpdxvaSFQPDukSLVfq/gcOXb7u/PED4JhB2JU7Uzy2XMtRH
KIwLrGJ+mmdD1z0bso4+DjFxQvPewKHfy2KcDYN6nl0jlZQ6UFJ+BseA5Dy9MVE2
Bn1QAZkOp9qpPYNwbdRKqc54EGfUZItck8Gk6oVYKlSjZTxzS/Lv8gbG7ztei50i
HNyCvW+LJTQaPwvlayqw9prrVBXNJ/+bVr9GR4Ajn1P2sMtZLHrvEZmcwf9lkjT6
MmhoNTCSIq3q+ZWCoAUhSPh5UfyGwA==
=O4Kq
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
