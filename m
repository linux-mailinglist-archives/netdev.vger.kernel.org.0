Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC1225EB5A
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgIEWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEWTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 18:19:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF2A20760;
        Sat,  5 Sep 2020 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599344356;
        bh=giYy482W45KqNp/kv7WjMS4COmd574mn6GIbXOcX/M8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqu23J6buas6SWpwZnYT8jxRWOZAgv6HfrV7pkYQ1lz+ZE3CFjAABcE58bK+wpZQn
         i80S0dHEn5a/yXXC+whS9rfzOdR2SJrhwKHpkFpjWTgZdITW+kVj0QsKHizxzHB6Pa
         aY2VrdufdxSdlwOjgkvxAkVwu8xtKdlFGcpeWg8o=
Date:   Sat, 5 Sep 2020 15:19:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200905151914.339b00e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <328d7cc0-9bf9-3051-52d5-9f7ac2fd4075@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
        <20200904000534.58052-3-snelson@pensando.io>
        <20200905130422.36e230df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <328d7cc0-9bf9-3051-52d5-9f7ac2fd4075@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 15:06:07 -0700 Shannon Nelson wrote:
> On 9/5/20 1:04 PM, Jakub Kicinski wrote:
> > On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote: =20
> >> +/* The worst case wait for the install activity is about 25 minutes w=
hen
> >> + * installing a new CPLD, which is very seldom.  Normal is about 30-35
> >> + * seconds.  Since the driver can't tell if a CPLD update will happen=
 we
> >> + * set the timeout for the ugly case. =20
> > 25 minutes is really quite scary. And user will see no notification
> > other than "Installing 50%" for 25 minutes? And will most likely not
> > be able to do anything that'd involve talking to the FW, like setting
> > port info/speed? =20
>=20
> Yeah, it's pretty annoying, and the READMEs with the FW will need to=20
> warn that the install time will be much longer than usual.
>=20
> > Is it possible for the FW to inform that it's updating the CPLD? =20
>=20
> We don't have any useful feedback mechanism for this kind of thing, but=20
> I'll think about how it might work and see if I can get something from=20
> the FW folks.=C2=A0 Another option would be for the driver to learn how t=
o=20
> read the FW blob, but I'd really rather not go down that road.

Yes, parsing the firmware blobs in the drivers in not advisable.

> > Can you release the dev_cmd_lock periodically to allow other commands
> > to be executed while waiting? =20
>=20
> I think this could be done.=C2=A0 I suspect I'll need to give the dev_cmd=
 the=20
> regular timeout and have this routine manage the longer potential=20
> timeout.=C2=A0 I'll likely have to mess with the low-level dev_cmd_wait t=
o=20
> not complain about a timeout when it is a FW status command.
>=20
> The status_notify messages could then be updated in order to show some=20
> progress, but would we base the 100% on the remote possibility that it=20
> might take 25 minutes?=C2=A0 Or use some scaled update time, taking longe=
r=20
> between updates as time goes on? Hmmm...

I wonder if we can steal a page from systemd's book and display
"time until timeout", or whatchamacallit, like systemd does when it's
waiting for processes to quit. All drivers have some timeout set on the
operation. If users knew the driver sets timeout to n minutes and they
see the timer ticking up they'd be less likely to think the command has
hanged..
