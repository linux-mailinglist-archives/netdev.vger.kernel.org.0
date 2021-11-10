Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AECA44C25A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhKJNuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhKJNuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01539C061764;
        Wed, 10 Nov 2021 05:47:23 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636552041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MciXaiM/IuTmIk/zMIlZFbpG5qOYdi18BE9VZB246g=;
        b=QdH2wN/OUfJa1D4UUw9Z158yvc9J6KaiHGOpk0xV/c0tqp7CrqRK9r8STCXWwofz9sGvGM
        5zG/+sxajESDEe/WEMSfNV+cVysXCwXZv4BVfd4GYZsEHHLmaufib+Tg10nzB1o2ksabIC
        9+p6Xw/KmvvEn4zGHvQ35pAgdcDu7XIPEpjf4FL7T9roN+GStDZaJOpjpJQ+SEuTgrHG+j
        uqMnQFcLnQtSBO5v+FKeMoW/3j6aW3eOjbXEs0ABZylnGhFt38O0EACE9vjDhbUgckx8mf
        UPDHWShhreB0mNFiB/lyUawGu9BC/d+1MNnazJgF0y5g6fdFlgGpBFq7rFuYow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636552041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MciXaiM/IuTmIk/zMIlZFbpG5qOYdi18BE9VZB246g=;
        b=r8RlS/AQgTnYBJ8q5P3IWsoiij24JoTCzTmVCbkZ9VsEFMn/04rNTxuegKnAY5pnMA2cgA
        vB8Aszd6wQxvuxAA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
In-Reply-To: <20211110130545.ga7ajracz2vvzotg@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf> <87ee7o8otj.fsf@kurt>
 <20211110130545.ga7ajracz2vvzotg@skbuf>
Date:   Wed, 10 Nov 2021 14:47:19 +0100
Message-ID: <8735o486mw.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Nov 10 2021, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Wed, Nov 10, 2021 at 08:14:32AM +0100, Kurt Kanzenbach wrote:
>> Hi Vladimir,
>>=20
>> On Tue Nov 09 2021, Vladimir Oltean wrote:
>> >> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_bu=
ff *skb)
>> >> +{
>> >> +	struct b53_device *dev =3D ds->priv;
>> >> +	struct b53_port_hwtstamp *ps =3D &dev->ports[port].port_hwtstamp;
>> >> +	struct sk_buff *clone;
>> >> +	unsigned int type;
>> >> +
>> >> +	type =3D ptp_classify_raw(skb);
>> >> +
>> >> +	if (type !=3D PTP_CLASS_V2_L2)
>> >> +		return;
>> >> +
>> >> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
>> >> +		return;
>> >> +
>> >> +	clone =3D skb_clone_sk(skb);
>> >> +	if (!clone)
>> >> +		return;
>> >> +
>> >> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state))=
 {
>> >
>> > Is it ok if you simply don't timestamp a second skb which may be sent
>> > while the first one is in flight, I wonder? What PTP profiles have you
>> > tested with? At just one PTP packet at a time, the switch isn't giving
>> > you a lot.
>>=20
>> PTP only generates a couple of messages per second which need to be
>> timestamped. Therefore, this behavior shouldn't be a problem.
>>=20
>> hellcreek (and mv88e6xxx) do the same thing, simply because the device
>> can only hold only one Tx timestamp. If we'd allow more than one PTP
>> packet in flight, there will be correlation problems. I've tested with
>> default and gPTP profile without any problems. What PTP profiles do have
>> in mind?
>
> First of all, let's separate "more than one packet in flight" at the
> hardware/driver level vs user space level. Even if there is any hardware
> requirement to not request TX timestamping for the 2nd frame until the
> 1st has been acked, that shouldn't necessarily have an implication upon
> what user space sees. After all, we don't tell user space anything about
> the realities of the hardware it's running on.

Fair enough.

>
> So it is true that ptp4l is single threaded and always polls
> synchronously for the reception of a TX timestamp on the error queue
> before proceeding to do anything else. But writing a kernel driver to
> the specification of a single user space program is questionable.
> Especially with the SOF_TIMESTAMPING_OPT_ID flag of the SO_TIMESTAMPING
> socket option, it is quite possible to write a different PTP stack that
> handles TX timestamps differently. It sends event messages on their
> respective timer expiry (sync, peer delay request, whatever), and
> processes TX timestamps as they come, asynchronously instead of blocking.
> That other PTP stack would not work reliably with this driver (or with
> mv88e6xxx, or with hellcreek).

Yeah, a PTP stack which e.g. runs delay measurements independently from
the other tasks (sync, announce, ...) may run into trouble with such as
an implementation. I'm wondering how would you solve that problem for
hardware such as hellcreek? If a packet for timestamping is "in-flight"
the Tx path for a concurrent frame would have to be delayed. That might
be a surprise to the user as well.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGLzWcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwphxXD/9AAZtvg6YJic2fjwwmSNV2WUUBMVmO
ztwGA8AvA5luVfVRNBZFWViU1+2F81GfyqZa3311B7lMVWoMcT02ZTsSOiRKVXpM
Xx8ut3iXN/2D+mfklMYHU5K8qLd/fqk2n7PLJkXN5B0YCV9+l5KRVbIKMnzwbemX
x3Pkm1D0Nk3+/I81TW22/NmejIde9DJQ+YasgsaxAkWVe1j2ZMGstYkowDUjjjq+
IGQqzpXxsmK4rLCe0d9wNElbaykiPNA93o+B2uN3nOhwuRo5odhY0QwJ06OjrZto
C4IyID15l2B8EyLVw7ap4U0jwTmR3HugM/fzWZMgbNiPeiYJsNgxxFN5txu3z+qx
fzQ0AB11w49qYcIRZCG4G8oC8vWJTHWP1/O02c5yKf5fQjztMynhnHOFtWkIYJUw
N9gwO9KYVtDS7axyDxwTCkDNc/ncST9nXiajqxxtrcBQHJc24nsqV/YBDN9xMikI
OThlrPhnh986mXaK7SFfmnyw4172wHc8zcKm/WDgVCcRAB+8MQVa/dCKSKg2tFjP
rlrhMs9Veo9wkmF17yqSMNgUUHgfcl6nmkIRWk0fKmVfSKzBfWlHHVcOocuyOMvG
JV9n3yJGpQSRYNbsBQQroEiYiD0h9ZEtJMDPPph4suAF+zbbBHNeyFBJGWTXVqlv
nadUgwMvQI2XFQ==
=Uu/4
-----END PGP SIGNATURE-----
--=-=-=--
