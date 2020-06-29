Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B880320E393
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390590AbgF2VP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbgF2SzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:16 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59626255C8;
        Mon, 29 Jun 2020 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593452193;
        bh=bWJRO7VROarsbzIEdYe3ZaRVSdYkd4d5+Dp5iklbJlw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tg9YTjAG507INbPsKm6jB6kqMt8V3M1ljicQAwq+y0dhluhX9uL2Rox8md0ICLzW7
         dbby3Qn8OeUDvzy6CApyAcLrEL7QXIMZ5aT0g0OBz8Oo5SgSU9Xd5hDQSpKRTMwti+
         t9wV7Zk154mmLAy+BXIFY2m2fJtrqSKkc8rRH/rk=
Date:   Mon, 29 Jun 2020 18:36:31 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200629173630.GH5499@sirena.org.uk>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2020 at 12:02:25AM -0700, Jeff Kirsher wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>=20
> A client in the SOF (Sound Open Firmware) context is a
> device that needs to communicate with the DSP via IPC

As please send patches to the maintainers for the code you would like to
change.  :(

> +config SND_SOC_SOF_CLIENT
> +	tristate
> +	select VIRTUAL_BUS
> +	help
> +	  This option is not user-selectable but automagically handled by
> +	  'select' statements at a higher level

VIRTUAL_BUS is both user visible and selected here (not that the select
will do much since this option is not user visible) - which is it?

> +config SND_SOC_SOF_CLIENT_SUPPORT
> +	bool "SOF enable clients"
> +	depends on SND_SOC_SOF
> +	help
> +	  This adds support for client support with Sound Open Firmware.
> +	  The SOF driver adds the capability to separate out the debug
> +	  functionality for IPC tests, probes etc. into separate client
> +	  devices. This option would also allow adding client devices
> +	  based on DSP FW capabilities and ACPI/OF device information.
> +	  Say Y if you want to enable clients with SOF.
> +	  If unsure select "N".

I'm not sure that's going to mean much to users, nor can I see why you'd
ever have a SOF system without this enabled?

> +	/*
> +	 * Register virtbus device for the client.
> +	 * The error path in virtbus_register_device() calls put_device(),
> +	 * which will free cdev in the release callback.
> +	 */
> +	ret =3D virtbus_register_device(vdev);
> +	if (ret < 0)
> +		return ret;

> +	/* make sure the probe is complete before updating client list */
> +	timeout =3D msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
> +	time =3D wait_for_completion_timeout(&cdev->probe_complete, timeout);
> +	if (!time) {
> +		dev_err(sdev->dev, "error: probe of virtbus dev %s timed out\n",
> +			name);
> +		virtbus_unregister_device(vdev);
> +		return -ETIMEDOUT;
> +	}

This seems wrong - what happens if the driver isn't loaded yet for
example?  Why does the device registration care what's going on with
driver binding at all?

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl76Jp0ACgkQJNaLcl1U
h9BmNgf7BKyEqiTNUiS2NIoh+r+M/U2mS8LUeDVAeUCxV6Yo7cU6bPfrLi842ngq
s4HP6OEnyKukfQTfh2uLGoFpkCS7Oc6B9Ns3BMKaIM3jf7/KbmxdshEYom/D+FOw
Njdr0GphPU7GNgamCpQXZxhZ+KCpQz5qUX2mYAJwlM+pknBncu7IsjrIa81mxP/S
XRoM5zhcoyiN77W5+fjKhYZuOQd2tTky8SOVfmXFefsGJOjptkAtX+lF0pCqMmJb
1oYB/+k3dm3GSqH+68rY5ktrPEkimNYENEnefYDOw60rH+eZebvwXALg3hPPrpH0
ZlESvTILFc4HUSjR/eNoK0nRGGrJQA==
=+klT
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
