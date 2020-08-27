Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B159A25508A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 23:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0VZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 17:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgH0VZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 17:25:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA11320825;
        Thu, 27 Aug 2020 21:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598563538;
        bh=A5It0BUySqvUM5WKtDRjc78xDg5fUydkP319uzdaroI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYMVq359h0poiRDS/R1A/rF5QGGEab0TwFSZ+l8BCJSwj8Edjl4gj6bGFi9VF3ANg
         mkPynb+EYMD1QaiGox8R9EfBFO2ChnsHeVXXvZfMBsoQJJnXLKMA9CCzv9EkBF/HSM
         ADu75L92y7PiWCjxqot/1B35AiLuAdWmVEcJbMX0=
Date:   Thu, 27 Aug 2020 14:25:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
Message-ID: <20200827142536.587f0ecc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bd9b0427-6772-068e-d7bd-b1aabf1ac6ed@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
        <20200827180735.38166-8-snelson@pensando.io>
        <20200827124625.511ef647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bd9b0427-6772-068e-d7bd-b1aabf1ac6ed@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 12:53:17 -0700 Shannon Nelson wrote:
> On 8/27/20 12:46 PM, Jakub Kicinski wrote:
> > On Thu, 27 Aug 2020 11:07:30 -0700 Shannon Nelson wrote: =20
> >> +	q_base =3D (void *)PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE); =20
> > The point of PTR_ALIGN is to make the casts unnecessary. Does it not
> > work? =20
> Here's what I see from two different compiler versions:
>=20
> drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning:=20
> assignment makes pointer from integer without a cast [-Wint-conversion]
>  =C2=A0 q_base =3D PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
>=20
>=20
> drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning:=20
> assignment to 'void *' from 'long unsigned int' makes pointer from=20
> integer without a cast [-Wint-conversion]
>  =C2=A0 q_base =3D PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);

Just

	q_base =3D PTR_ALIGN(new->q_base, PAGE_SIZE);
