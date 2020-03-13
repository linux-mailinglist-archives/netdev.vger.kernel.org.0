Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982FE18400B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgCMEmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgCMEmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:42:01 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF746206E2;
        Fri, 13 Mar 2020 04:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584074521;
        bh=ea6a7mIpU4Dxs8t8AbjfKxnh6yd3VaGBrzBndKa8lXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Usut1indrNy7MVq3KV61wkXCx6wdUzic3toTF2alW5iWa8Y8uYPkWdouz8lLpOkav
         vJyPmrXTAlRA1c8ETlS8vyTxdqgyewXIGOI9YaxPhvsWhI2vICTKAA4KEp32pjAHVY
         yBpJgnr/90UcFySsxU1om1N4RHfiVj/XMqz0xWlU=
Date:   Thu, 12 Mar 2020 21:41:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] ionic: tx and rx queues state follows link
 state
Message-ID: <20200312214159.1c41209d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <af492e16-927e-e10f-1213-59d14634462d@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
        <20200312215015.69547-2-snelson@pensando.io>
        <20200312.154110.308373641367156886.davem@davemloft.net>
        <af492e16-927e-e10f-1213-59d14634462d@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 17:12:45 -0700 Shannon Nelson wrote:
> On 3/12/20 3:41 PM, David Miller wrote:
> > From: Shannon Nelson <snelson@pensando.io>
> > Date: Thu, 12 Mar 2020 14:50:09 -0700
> > =20
> >> +		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
> >> +		    netif_running(netdev)) {
> >> +			rtnl_lock();
> >> +			ionic_open(netdev);
> >> +			rtnl_unlock();
> >>   		} =20
> > You're running into a major problem area here.
> >
> > ionic_open() can fail, particularly because it allocates resources.
> >
> > Yet you are doing this in an operational path that doesn't handle
> > and unwind from errors.
> >
> > You must find a way to do this properly, because the current approach
> > can result in an inoperable interface. =20
>=20
> I don't see this as much different from how we use it in=20
> ionic_reset_queues(), which was modeled after some other drivers' uses=20
> of the open call.=C2=A0 In the fw reset case, though, the time between th=
e=20
> close and the open is many seconds.

Precedent does not make it any better. You're really pushing the
re-open hack to new levels here :(

Why don't you just unregister the netdev?  30 sec is orders of
magnitude past the point where "no impact to the user" could be
claimed.

FWIW please take a look at NFP, nfp_net_ring_reconfig() and its uses,
to see a better way of handling shutdown and reconfiguration.

> Yes, ionic_open() can fail, and it unwinds its own work.=C2=A0 There isn'=
t=20
> anything here in ionic_link_status_check() to unwind, and no one to=20
> report the error to, so we don't catch the error here. However, it would=
=20
> be better if I move the addition of the IONIC_LIF_F_TRANS flag and a=20
> couple other bits from patch 7 into this patch - I can do that for a v2=20
> patchset.

Those layers of "how open is the device _really_" state within drivers
are just a breeding ground for bugs. Already you're doing this:

+		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    netif_running(netdev)) {
+			rtnl_lock();
+			ionic_open(netdev);
+			rtnl_unlock();

A lot may happen right before rtnl_lock().

You got the UP bit, the RESET bit, and now TRANS bit..
