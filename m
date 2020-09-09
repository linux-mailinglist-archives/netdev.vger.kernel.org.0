Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B899926368D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgIITWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIITWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 15:22:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C7F21D6C;
        Wed,  9 Sep 2020 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599679356;
        bh=t9KYrLFVXfokdDnHSvlUJapZ7dWT2P5PGQeGmZe5oy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJz/6fSiAFbgS4T7i8ZvDhBzpoTvXCe00L5nEGaIGyNgeD1RE2iO2eGl8wwO0r6m1
         yY6qx1+pkDiBnMfU730Bl9jhThcW2nmd79Kvaf5szv1KuSAq/17J88slGpaBvdn/Nv
         VE7UWSbS450yn9lZddsz2rACjtoCmxYHs4gFgXtw=
Date:   Wed, 9 Sep 2020 12:22:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 10:58:19 -0700 Shannon Nelson wrote:
> On 9/9/20 9:44 AM, Jakub Kicinski wrote:
> > On Wed, 9 Sep 2020 09:23:08 -0700 Shannon Nelson wrote: =20
> >> On 9/8/20 4:54 PM, Jakub Kicinski wrote: =20
> >>> On Tue,  8 Sep 2020 15:48:12 -0700 Shannon Nelson wrote: =20
> >>>> +	dl =3D priv_to_devlink(ionic);
> >>>> +	devlink_flash_update_status_notify(dl, label, NULL, 1, timeout);
> >>>> +	start_time =3D jiffies;
> >>>> +	end_time =3D start_time + (timeout * HZ);
> >>>> +	do {
> >>>> +		mutex_lock(&ionic->dev_cmd_lock);
> >>>> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
> >>>> +		err =3D ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> >>>> +		mutex_unlock(&ionic->dev_cmd_lock);
> >>>> +
> >>>> +		devlink_flash_update_status_notify(dl, label, NULL,
> >>>> +						   (jiffies - start_time) / HZ,
> >>>> +						   timeout); =20
> >>> That's not what I meant. I think we can plumb proper timeout parameter
> >>> through devlink all the way to user space. =20
> >> Sure, but until that gets worked out, this should suffice. =20
> > I don't understand - what will get worked out? =20
>=20
> I'm suggesting that this implementation using the existing devlink=20
> logging services should suffice until someone can design, implement, and=
=20
> get accepted a different bit of plumbing.=C2=A0 Unfortunately, that's not=
 a=20
> job that I can get to right now.

This hack is too nasty to be accepted.

So to be clear your options are:
 - plumb the single extra netlink parameter through to devlink
 - wait for someone else to do that for you, before you get firmware
   flashing accepted upstream.

Your "NIC" is quite "special", so you gotta be willing to lay the
groundwork it you want it to be supported upstream.

I already regret acking your weird live reset without proper APIs.
Now Mellanox is doing the plumbing for the exact same feature.
