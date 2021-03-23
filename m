Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE943452B2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCVXBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhCVXBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D81DE61984;
        Mon, 22 Mar 2021 23:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616454072;
        bh=ivkFU65tQWWxYSjMXeE8LovTtaG55iHK7enP6dub3L8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FPnzCrR/bXV/Ds86oqBbL0o8uo3hlY/sbypj3jnFlVvEv2ufX3ME/4OAeFZ4VRVb4
         P12kEVVLYZ6RzusJ2Dhyh/7jzPDbnUtaT1QAMEUWHB1Sr6ayxNIqhZ+xUQoPPatcnd
         t4kNZ3Co/WnMhhR8Qbzjbz74RBpwmKQPDfvfSxg1eT477J+2YwDsqE3KI4IuX3Tnvh
         WS+kKeXJj1VopBdpkdDEeJiPJCRQgT0nUDiAvsyW5fehZZ+OyUADiQHicGyQMALzhJ
         2mV+R4CP4ss6VnFdIlx8YWlt5m2lwgVguHntOLRT6wuzyOkJk9QRFfJ37yYbDcbVGI
         udH2PV3kuGGtw==
Date:   Tue, 23 Mar 2021 00:01:07 +0000
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 1/2] dt-bindings: ethernet-controller: create a
 type for PHY interface modes
Message-ID: <20210323000107.3483ce6b@thinkpad>
In-Reply-To: <YFkH6AKEAaPbhy9f@lunn.ch>
References: <20210322195001.28036-1-kabel@kernel.org>
        <YFkH6AKEAaPbhy9f@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 22:11:04 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Mar 22, 2021 at 08:49:58PM +0100, Marek Beh=C3=BAn wrote:
> > In order to be able to define a property describing an array of PHY
> > interface modes, we need to change the current scalar
> > `phy-connection-type`, which lists the possible PHY interface modes, to
> > an array of length 1 (otherwise we would need to define the same list at
> > two different places). =20
>=20
> Hi Marek
>=20
> Please could you include a 0/2 patch which explains the big
> picture. It is not clear to me why you need these properties.  What is
> the problem you are trying to solve? That should be in the patch
> series cover note.
>=20
> 	 Andrew

Hi Andrew,

sorry, I did not add a cover letter because the second patch commit
message basically explains the purpose, but now I realize that a cover
letter could mention a specific example.

I will include a cover letter in v2.

Meanwhile I can explain the purpose here:

Some PHYs support interface modes that must not necessarily be wired
on a board. A good example is Marvell 88x3310 PHY, which supports
several modes via one SerDes lane (10gbase-r, usxgmii, 5gbase-r,
2500base-x, sgmii), but also via 2 or 4 SerDes lanes (rxaui and xaui).

So a board utilizing this PHY can have different constraints:
- the board wiring can have a frequnecy constraint (for example the
  connection can go via a connector that does not support frequencies
  greater than 6 GHz, so for 10g link multiple lanse - xaui or rxaui -
  must be used)

- the board may simply not wire all SerDes lanes

- the MAC does not have to support all these modes

For the first two points it is impossible for the code to know this
without it being specified in device tree. The last one can be solved in
code, and Russell King has experimental patches in his repo for this
(both MAC and PHY driver fill up a supported_interfaces bitmask).

But why can't we just depend on the phy-mode property defined in ethernet
controller's OF node?
Becuase this PHY can change its interface mode to the MAC depending on
the negotiated speed on the copper side. This PHY has several possible
configurations
- communicate with the MAC in USXGMII. This is simplest one since the
  interface mode does not change even if copper speed changes
- 10gbase-r/5gbase-r/2500base-x/sgmii depending on the copper speed
-      xaui/5gbase-r/2500base-x/sgmii depending on the copper speed
-     rxaui/5gbase-r/2500base-x/sgmii depending on the copper speed
- 10gbase-r with rate matching
-      xaui with rate matching
-     rxaui with rate matching

One of these configurations is selected by strapping pins, and can be
read by the marvell10g driver. The driver can then change phy-mode on
the MAC side.

One problem is that the mode selected by the strapping pins may not
be ideal. There are some erratas published for this PHY, which say that
rate-matching is broken in some conditions (speed <=3D 1000), for example.
Also the rate-matching mode is not optimal if the MAC supports the
lower-speed modes, because of overhead of sending pause-frames.

So in order to select the best possible configuration, we need to know
which PHY interface modes are supported on the board.

The most generic solution is to specify a property which either lists
unsupported PHY modes or supported PHY modes (if missing, assume all
modes are supported).

Marek
