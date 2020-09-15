Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92D326B148
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgIOW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgIOW2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 18:28:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEFE20872;
        Tue, 15 Sep 2020 22:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600208880;
        bh=aRdCctwOYFZQgMeOAKeyW3Md2XxtUvgEA+WyhujPEGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ce7Eh628NF2JW+OzaOY9aeaAIK7ceon4wWGt1Et2oh+x5G49KxUa4S+7sInSwSW7v
         DNONK6ygSuDZuIOuPodnsA/j8BYVBUQ7zrps92gLsKXIh1cyQCvJeRBD24w9eR+f90
         18ADXPboHyaWiDH1KXA6DhZ6NS6S3fXD5BfRZRWo=
Date:   Tue, 15 Sep 2020 15:27:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200915152758.16a61a90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <33d4fe46-9f67-998f-8bda-fc74c32eb910@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
        <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
        <7e44037cedb946d4a72055dd0898ab1d@intel.com>
        <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
        <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4b5e3547f3854fd399b26a663405b1f8@intel.com>
        <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
        <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dfa16c8-8bb6-a429-6644-68fd94fc2830@intel.com>
        <20200915120025.0858e324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <33d4fe46-9f67-998f-8bda-fc74c32eb910@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 15:11:06 -0700 Shannon Nelson wrote:
> On 9/15/20 12:00 PM, Jakub Kicinski wrote:
> > On Tue, 15 Sep 2020 11:44:07 -0700 Jacob Keller wrote: =20
> >> Exactly how I saw it.
> >>
> >> Basically, the timeout should take effect as long as the (component,
> >> msg) pair stays the same.
> >>
> >> So if you send percentage reports with the same message and component,
> >> then the timeout stays in effect. Once you start a new message, then t=
he
> >> timeout would be reset. =20
> > I don't think I agree with that. As I said that'd make the timeout not
> > match the reality of what happens in the driver. =20
>=20
> I have an asynchronous FW interaction where the driver sends one FW=20
> command to start the fw-install and sends several more FW commands to=20
> check on the status until either it gets a done or error status or too=20
> many seconds have elapsed.=C2=A0 How would you suggest this gets modeled?

It's still one command. The fact that the driver periodically checks if
its finished is an implementation detail. Drivers which periodically
check if "done bit" in some register got cleared or not also don't send
a notification every time they've done so.

> In the model you are suggesting, the driver can only do a single=20
> status_notify with a timeout before the initial async FW command, then=20
> no other status_notify messages until the driver gets the done/error=20
> status, or the time has elapsed, regardless of how long that might=20
> take.=C2=A0 The user will only see the timeout ticking, but no activity f=
rom=20
> the driver.=C2=A0 This allows the user to see what the deadline is, but=20
> doesn't reassure them that the process is still moving.

The timer should be a sufficient indication to the user not to worry,
yet. The worrying starts once the timer expires, then something is up.

> I'm suggesting that the driver might send some intermediate=20
> status_notify messages in order to assure the user that things are not=20
> stalled out.=C2=A0 Driving a spinner would be nice, but we don't have tha=
t=20
> concept in this interface, so poking the done/total values could be used=
=20
> for that.=C2=A0 In order to not reset the timeout on each of these=20
> intermediate updates, we pass the same timeout value.

What useful status_notify messages can a driver send mid-command?
Timeout tells the user "for this much time you may not see any real
status updates".

> At this point I'm going to try a patchset that implements the basics=20
> that we already have agreed upon, and this detail can get worked out=20
> later, as I believe it doesn't change the internal implementation.


