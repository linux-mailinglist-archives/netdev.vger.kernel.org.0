Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6922DB629
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgLOV4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:56:40 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:46850 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgLOV40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:56:26 -0500
Date:   Tue, 15 Dec 2020 21:54:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1608069298;
        bh=P09pz3DapQY7UGh6lp2+oBfUikb6wNcNgqvn7FpsiBA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=cotduSHcGDd1aNLx+2m+SbFxISIpk52VdgAbdEwkf9cHvKHcC9m4h6f72FCZ5jbuw
         j33e4PxDhF1fjPvUVdberftbVN9P63MnlUbv+mBscdzWWK0Qiyt4qcRRzCEGi36fiQ
         +y3HlhjSi/6DJEi5Jcj0in2Ne8iRm+bDGIDc3V6k=
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
From:   Lars Everbrand <lars.everbrand@protonmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Reply-To: Lars Everbrand <lars.everbrand@protonmail.com>
Subject: Re: [PATCH net-next] bonding: correct rr balancing during link failure
Message-ID: <X9kwqvgoAmrjAaXY@black-debian>
In-Reply-To: <15308.1607463969@famine>
References: <X8f/WKR6/j9k+vMz@black-debian> <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <15308.1607463969@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 01:46:09PM -0800, Jay Vosburgh wrote:
>=20
> Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> >On Wed, 02 Dec 2020 20:55:57 +0000 Lars Everbrand wrote:
> =09Are these bandwidth numbers from observation of the actual
> behavior?  I'm not sure the real system would behave this way; my
> suspicion is that it would increase the likelihood of drops on the
> overused slave, not that the overall capacity would be limited.
I tested this with with 2 VMs and 5 bridges with bandwidth limitiation
via 'virsh domiftune' to bring the speed down to something similar to=20
100Mbit/s.

iperf results:

with patch:
---
working       iperf
interfaces    speed [mbit/s]
5             442
4             363
3             278
2             199
1             107

without patch:
---
working       iperf
interfaces    speed [mbit/s]
5             444
4             226
3             155
2             129
1             107

The speed at 5x100 is not going as high as I expected but the
sub-optimal speed is still visible.

Note that the degradation tested is with downing interfaces sequentially
which is the worst-case for this problem.

> >Looking at the code in question it feels a little like we're breaking
> >abstractions if we bump the counter directly in get_slave_by_id.
>=20
> =09Agreed; I think a better way to fix this is to enable the slave
> array for balance-rr mode, and then use the array to find the right
> slave.  This way, we then avoid the problematic "skip unable to tx"
> logic for free.
>=20
> >For one thing when the function is called for IGMP packets the counter
> >should not be incremented at all. But also if packets_per_slave is not
> >1 we'd still be hitting the same leg multiple times (packets_per_slave
> >/ 2). So it seems like we should round the counter up somehow?
> >
> >For IGMP maybe we don't have to call bond_get_slave_by_id() at all,
> >IMHO, just find first leg that can TX. Then we can restructure
> >bond_get_slave_by_id() appropriately for the non-IGMP case.
>=20
> =09For IGMP, the theory is to confine that traffic to a single
> device.  Normally, this will be curr_active_slave, which is updated even
> in balance-rr mode as interfaces are added to or removed from the bond.
> The call to bond_get_slave_by_id should be a fallback in case
> curr_active_slave is empty, and should be the exception, and may not be
> possible at all.
>=20
> =09But either way, the IGMP path shouldn't mess with rr_tx_counter,
> it should be out of band of the normal TX packet counting, so to speak.
>=20
> =09-J
>=20
> >> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bon=
d_main.c
> >> index e0880a3840d7..e02d9c6d40ee 100644
> >> --- a/drivers/net/bonding/bond_main.c
> >> +++ b/drivers/net/bonding/bond_main.c
> >> @@ -4107,6 +4107,7 @@ static struct slave *bond_get_slave_by_id(struct=
 bonding *bond,
> >>  =09=09if (--i < 0) {
> >>  =09=09=09if (bond_slave_can_tx(slave))
> >>  =09=09=09=09return slave;
> >> +=09=09=09bond->rr_tx_counter++;
> >>  =09=09}
> >>  =09}
> >>
> >> @@ -4117,6 +4118,7 @@ static struct slave *bond_get_slave_by_id(struct=
 bonding *bond,
> >>  =09=09=09break;
> >>  =09=09if (bond_slave_can_tx(slave))
> >>  =09=09=09return slave;
> >> +=09=09bond->rr_tx_counter++;
> >>  =09}
> >>  =09/* no slave that can tx has been found */
> >>  =09return NULL;
> >
>=20
> ---
> =09-Jay Vosburgh, jay.vosburgh@canonical.com

