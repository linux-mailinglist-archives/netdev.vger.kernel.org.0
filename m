Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867B83D5F10
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhGZPQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236659AbhGZPMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 11:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2567E6056C;
        Mon, 26 Jul 2021 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627314746;
        bh=vSyBHE9E4dJbHwvbLbDjiFMygZzZJE4Q1Qc0fD+7fiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qYb1/a/xxKzrRRNPxST2RgPHrq6JkQFm93ZlJHdjN/mOfOqneDRk9wbo/3bw/5qHK
         mZYv5ECAq+LLL/4iw0+Wf+Yxcb1ePEzpZA2P/VFF+dCAeSExbilgx0NMAdnUMzGTOu
         EoEHTHnHNgT+9oj+mrzhXdv3X8i4KEuPpjAfepSLsgw4R5k1gdl8+YZ7K5x/b59n8A
         J1wjsvpUS1SbBSPQKswGvb5i/0x1F9XHDRo4NMRDB+F4x7DqtX/vjfxpEgxFWewIit
         Zfnv5PAPHCNYfWOnriH9WqqOOgNvUVDOxOjrO1veVRQdRnnGyhxFqHbOmd/eIL8134
         x7/r0tnGEn1ug==
Date:   Mon, 26 Jul 2021 17:52:23 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: mvpp2 switch from gmac to xlg requires ifdown/ifup
Message-ID: <20210726175223.3122f544@thinkpad>
In-Reply-To: <20210723080538.GB22278@shell.armlinux.org.uk>
References: <20210723035202.09a299d6@thinkpad>
        <20210723080538.GB22278@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 09:05:38 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Fri, Jul 23, 2021 at 03:52:02AM +0200, Marek Beh=C3=BAn wrote:
> > Hello Russell (and possibly others),
> >=20
> > I discovered that with mvpp2 when switching from gmac (sgmii or
> > 2500base-x mode) to xlg (10gbase-r mode) due to phylink requesting this
> > change, the link won't come up unless I do
> >   ifconfig ethX down
> >   ifconfig ethX up
> >=20
> > Can be reproduced on MacchiatoBIN:
> > 1. connect the two 10g RJ-45 ports (88X3310 PHY) with one cable
> > 2. bring the interfaces up
> > 3. the PHYs should link in 10gbase-t, links on MACs will go up in
> >    10gbase-r
> > 4. use ethtool on one of the interfaces to advertise modes only up to
> >    2500base-t
> > 5. the PHYs will unlink and then link at 2.5gbase-t, links on MACs will
> >    go up in 2500base-x
> > 6. use ethtool on the same interface as in step 4 to advertise all
> >    supported modes
> >=20
> > 7. the PHYs will unlink and then link at 10gbase-t, BUT MACs won't link
> >    !!!
> > 8. execute
> >      ifconfig ethX down ; ifconfig ethX up
> >    on both interfaces. After this, the MACs will successfully link in
> >    10gbase-r with the PHYs
> >=20
> > It seems that the mvpp2 driver code needs to make additional stuff when
> > chaning mode from gmac to xlg. I haven't yet been able to find out
> > what, though.
> >=20
> > BTW I discovered this because I am working on adding support for
> > 5gbase-r mode to mvpp2, so that the PHY can support 5gbase-t on copper
> > side.
> > The ifdown/ifup cycle is required when switching from gmac to xlg, i.e.:
> > 	sgmii		to	5gbase-r
> > 	sgmii		to	10gbase-r
> > 	2500base-x	to	5gbase-r
> > 	2500base-x	to	10gbase-r
> > but also when switching from xlg to different xlg:
> > 	5gbase-r	to	10gbase-r
> > 	10gbase-r	to	5gbase-r
> >=20
> > Did someone notice this bug? I see that Russell made some changes in
> > the phylink pcs API that touched mvpp2 (the .mac_config method got
> > split into .mac_prepare, .mac_config and .mac_finish, and also some
> > other changes). I haven't tried yet if the switch from gmac to xlg
> > worked at some time in the past. But if it did, maybe these changes
> > could be the cause? =20
>=20
> What are the PHY leds doing when you encounter this bug?
>=20

Table summary:

			PHY0/eth0	PHY1/eth1
			green	yellow	green	yellow
after boot		ON	OFF	ON	OFF
eth0 up			ON	OFF	ON	OFF
eth1 up			blink	ON	blink	ON
eth0 adv -10g -5g	blink	OFF	blink	OFF
eth0 adv +5g *	 	OFF	OFF	OFF	OFF
eth0 down		ON	OFF	ON	OFF
eth0 up			blink**	OFF	blink** OFF
eth1 down		ON	OFF	ON	OFF
eth1 up			blink	OFF	blink	OFF

 (*  PHYs are linked now, but MACs are not)
 (** blinks only for a while after link, pings do not work,
     read my opinion below)
 (The last 5 lines basically the same happens if I set it to advertise
  10g instead of 5g, but in case of 10g the yellow LED is ON when the
  PHYs are linked.)

In words:

After boot, the green LED is ON on both PHYs.

Bringing both interfaces up changes nothing.

Plugging cable so that they link (at 10gbase-t) bring the yellow LEDs
ON, and the green LEDs OFF, but the green LEDs blinks on activity.
(For example when pinging eth0's ipv6 address via eth1.)

Disabling advertisement of 10gbase-t and 5gbase-t on eth0 makes the
PHYs link at 2.5gbase-t. Both LEDs are OFF, but green blinks on
activity.

Enabling advertisement of 5gbase-t makes the PHYs link, but the MACs
do not link with the PHYs, and there is no blinking on activity, and
pings do not work.

Taking one interface (eth0) down and up makes the PHYs link (we are
still at 5gbase-t), and the green LEDs blink for a few times because of
activity on both PHYs. But the pings do not work. I think this is
because the eth0's PHY sent some neighbour discovery packets, and the
eth1's PHY received them. But pings do not work because those packets
don't go from eth1's PHY to eth1's MAC.

Taking the second interface (eth1) down and up makes the PHYs again
link at 5gbase-t, and the green LEDs start blinking on activity. Pings
work.

Marek
