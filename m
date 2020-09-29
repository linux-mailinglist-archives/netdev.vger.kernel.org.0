Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF9027D9D4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgI2VRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:17:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgI2VRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:17:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6820BAC79;
        Tue, 29 Sep 2020 21:17:15 +0000 (UTC)
Date:   Tue, 29 Sep 2020 23:17:11 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200929231711.30f92b31@ezekiel.suse.cz>
In-Reply-To: <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
        <20200925105455.50d4d1cc@ezekiel.suse.cz>
        <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
        <20200925115241.3709caf6@ezekiel.suse.cz>
        <20200925145608.66a89e73@ezekiel.suse.cz>
        <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
        <20200929210737.7f4a6da7@ezekiel.suse.cz>
        <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lsnmf7j5/1eRqp37MmFcZxy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lsnmf7j5/1eRqp37MmFcZxy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 29 Sep 2020 22:08:56 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
>=20
> On 9/29/20 9:07 PM, Petr Tesarik wrote:
> > Hi Heiner (and now also Hans)!
> >=20
> > @Hans: I'm adding you to this conversation, because you're the author
> > of commit b1e3454d39f99, which seems to break the r8169 driver on a
> > laptop of mine. =20
>=20
> Erm, no, as you bi-sected yourself already commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
>=20
> Broke your laptop, commit b1e3454d39f99 ("clk: x86: add "ether_clk" alias
> for Bay Trail / Cherry Trail") is about 18 months older.

Well, I'm no expert on power management, nor clock drivers or network
drivers. I'm an end user, so I had to accept Hans' claim that the
pointer should be NULL...

>[...]
> > That's because this kernel is built with CONFIG_PMC_ATOM=3Dy, and looki=
ng
> > at the platform initialization code, the "ether_clk" alias is created
> > unconditionally. Hans already added. =20
>=20
> Petr, unconditionally is not really correct here, just as claiming
> above that my commit broke things was not really correct either.

I'm sorry if you feel offended. By "unconditionally" I mean that this
clock cannot be disabled by the user (e.g. with a kernel command line
option).

>[...]
> So with that all clarified lets try to see if we can figure out
> *why* this is actually happening.
>=20
> Petr, can you describe your hardware in some more detail,
> in the bits quoted when you first Cc-ed me there is not that
> much detail. What is the vendor and model of your laptop?

Seeing that Heiner has already agreed to revert his patch, I'm not sure
this is still relevant, but here I go.

This is an ASUS X453MA notebook with a dual Intel(R) Celeron(R) CPU
N2840  @ 2.16GHz, so it's totally expected that my system uses the
Intel Atom Processor E3800 Series drivers.

> Looking closer at commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
> I notice that the functions which now enable/disable the clock:
> rtl_pll_power_up() and rtl_pll_power_down()
>=20
> Only run when the interface is up during suspend/resume.
> Petr, I guess the laptop is not connected to ethernet when you
> hibernate it?

The laptop is always connected to an active 1000G Ethernet switch port.

However, there seem to be two bugs related to the Realtek driver: one
causes a hard hang on driver load (that's the one we're handling here),
the other is related to incorrect Rx queue initialization after resume.
They may or may not be related.

> That means that on resume the clock will not be re-enabled.
>=20
> This is a subtle but important change and I believe that
> this is what is breaking things. I guess that the PLL which
> rtl_pll_power_up() / rtl_pll_power_down() controls is only
> used for ethernet-timing.  But the external clock controlled
> through pt->clk is a replacement for using an external
> crystal with the r8169 chip. So with it disabled, the entire
> chip does not have a clock and is essentially dead.
> It can then e.g. not respond to any pci-e reads/writes done
> to it.

...which would nicely explain the hang, indeed.

Thanks,
Petr T

> So I believe that the proper fix for this is to revert
> commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
>=20
> As that caused the whole chip's clock to be left off after
> a suspend/resume while the interface is down.
>=20
> Also some remarks about this while I'm being a bit grumpy about
> all this anyways (sorry):
>=20
> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
> to pll power functions") commit's message does not seem to really
> explain why this change was made...
>=20
> 2. If a git blame would have been done to find the commit adding
> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional
> ether_clk clock") then you could have known that the clk in question
> is an external clock for the entire chip, the commit message pretty
> clearly states this (although "the entire" part is implied only) :
>=20
> "On some boards a platform clock is used as clock for the r8169 chip,
> this commit adds support for getting and enabling this clock (assuming
> it has an "ether_clk" alias set on it).
>=20
> This is related to commit d31fd43c0f9a ("clk: x86: Do not gate clocks
> enabled by the firmware") which is a previous attempt to fix this for
> some x86 boards, but this causes all Cherry Trail SoC using boards to
> not reach there lowest power states when suspending.
>=20
> This commit (together with an atom-pmc-clk driver commit adding the
> alias) fixes things properly by making the r8169 get the clock and
> enable it when it needs it."
>=20
> Regards,
>=20
> Hans
>=20


--Sig_/lsnmf7j5/1eRqp37MmFcZxy
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9zpFcACgkQqlA7ya4P
R6euCwf+J0ahelX7olJIKMHg6rQ3Ne1UJNp/5VrXLNSy8qe5cimOlTuk47HaAHg8
3Fg6gv0K2XlsVPew/t3Hu9699B6Bw48JDIiZmsZzsCSpGV5/k3v8exv8bFbIb9KM
JWYE73HI0nXzuKYgDa7cLviBJno1JRw9KkQAivLzGeRCYydnKReRRQy6cCnyowWC
2UWeP5Lnz8PrtST76FqGt8CwqN+JeZ3g5orLVgG2perwkfszSSgLwAlW1VH1+4En
/XtRGjT85P4L8aqL3FIbJItAgDWHzOreSyo5hRAImXpm54sn9Pw+07cPDRw5nbGB
4BMtMWlRvz9+6wjTVrXPBKCM1FIoqg==
=vokJ
-----END PGP SIGNATURE-----

--Sig_/lsnmf7j5/1eRqp37MmFcZxy--
