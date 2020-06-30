Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216B520F6F1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbgF3OQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgF3OQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 10:16:08 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8AD22072D;
        Tue, 30 Jun 2020 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593526567;
        bh=8k53/BoNXkzXn4m/rIfsN0pdXlVX6wTgTRKAHAP4dDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l6EXLMgweZ3EOC9BBkeDtlVppbrQ+3Hbz9Czewc6BUkFt9nnSmC9WSwm3ckV+RrTc
         V+BlmQzeQj2rtWi0KzQVcnSIg/4Edl39bUwxceZ0fAiROPTHt9j7AbbdzagOSih8UC
         fXn7u9aKT7VIdFf7SojkpPWLX9begFISkifh7UOI=
Date:   Tue, 30 Jun 2020 15:16:04 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200630141604.GJ5272@sirena.org.uk>
References: <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BEa57a89OpeoUzGD"
Content-Disposition: inline
In-Reply-To: <20200630113245.GG25301@ziepe.ca>
X-Cookie: Walk softly and carry a megawatt laser.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BEa57a89OpeoUzGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2020 at 08:32:45AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 30, 2020 at 11:31:41AM +0100, Mark Brown wrote:
> > On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:

> > > > What are we supposed to do with things like PCI attached FPGAs and =
ASICs
> > > > in that case?  They can have host visible devices with physical
> > > > resources like MMIO ranges and interrupts without those being split=
 up
> > > > neatly as PCI subfunctions - the original use case for MFD was such
> > > > ASICs, there's a few PCI drivers in there now.=20

> > > Greg has been pretty clear that MFD shouldn't have been used on top of
> > > PCI drivers.

> > The proposed bus lacks resource handling, an equivalent of
> > platform_get_resource() and friends for example, which would be needed
> > for use with physical devices.  Both that and the name suggest that it's
> > for virtual devices.

> Resource handling is only useful if the HW has a hard distinction
> between it's functional blocks. This scheme is intended for devices
> where that doesn't exist. The driver that attaches to the PCI device
> and creates the virtual devices is supposed to provide SW abstractions
> for the other drivers to sit on.

> I'm not sure why we are calling it virtual bus.

The abstraction that the PCI based MFDs (and FPGAs will be similar,
they're just dynamic MFDs to a good approximation) need is to pass
through MMIO regions, interrupts and so on which is exactly what the
platform bus offers.  The hardware is basically someone taking a bunch
of IPs and shoving them behind the MMIO/interrupt regions of a PCI
device.

> > The reason the MFDs use platform devices is that they end up having to
> > have all the features of platform devices - originally people were
> > making virtual buses for them but the code duplication is real so
> > everyone (including Greg) decided to just use what was there already.

> Maybe Greg will explain why he didn't like the earlier version of that
> stuff that used MFD

AFAICT Greg is mostly concerned about the MFDs that aren't memory
mapped, though some of them do use the resource API to pass interrupts
through.

--BEa57a89OpeoUzGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl77SSMACgkQJNaLcl1U
h9AGsQf/YwRWc++R3JTLbJIAO1diptlxzOjkcoVBbRynI0tEvfr93ORaWOdFn8xX
L5BNjAdaZWZXZYQNQCFDLy6Zl72+DRbpOpJD8E7CuClb7r+P3cz9EBA6pkBneSAo
6CHLBLOEzxRan6CfIcoGxcAzaWI+RakMgq6ZGvkhkduyVudgS+g1zajubT8vij4K
UhK2cW3ZotUrKc8Kr7DysDgUd8l5/p9tZH1OwIyC4j8Y2Z3AHQsi/4uOMyiKoZgN
z1PF/tllaixdbDz/V8NOk5qD7wvKMqvg88Zzfl1turrWMMrtBHl9l/o2L30Mv2iZ
LTk4XynmKQSpqpdBHl1+VqZx3rMzfQ==
=eAIK
-----END PGP SIGNATURE-----

--BEa57a89OpeoUzGD--
