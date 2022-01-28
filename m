Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94C549F58D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243366AbiA1IrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243347AbiA1IrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:47:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0055CC06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:47:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nDMuC-0005Wn-Kn; Fri, 28 Jan 2022 09:46:52 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 38F9925934;
        Fri, 28 Jan 2022 08:46:51 +0000 (UTC)
Date:   Fri, 28 Jan 2022 09:46:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Message-ID: <20220128084603.jvrvapqf5dt57yiq@pengutronix.de>
/From:  Marc Kleine-Budde <mkl@pengutronix.de>
References: <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
 <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
 <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ietkikogqwqnu463"
Content-Disposition: inline
In-Reply-To: <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ietkikogqwqnu463
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.01.2022 09:32:40, Oliver Hartkopp wrote:
>=20
>=20
> On 28.01.22 09:07, Marc Kleine-Budde wrote:
> > On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
> > > I've seen the frame processing sometimes freezes for one second when
> > > stressing the isotp_rcv() from multiple sources. This finally freezes
> > > the entire softirq which is either not good and not needed as we only
> > > need to fix this race for stress tests - and not for real world usage
> > > that does not create this case.
> >=20
> > Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?

> In kernel config? I enabled almost everything with LOCKing ;-)
>=20
>=20
> CONFIG_LOCKDEP_SUPPORT=3Dy
>=20
> CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=3Dy
>=20
> CONFIG_ASN1=3Dy
> CONFIG_UNINLINE_SPIN_UNLOCK=3Dy
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=3Dy
> CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
> CONFIG_RWSEM_SPIN_ON_OWNER=3Dy
> CONFIG_LOCK_SPIN_ON_OWNER=3Dy
> CONFIG_ARCH_USE_QUEUED_SPINLOCKS=3Dy
> CONFIG_QUEUED_SPINLOCKS=3Dy
> CONFIG_ARCH_USE_QUEUED_RWLOCKS=3Dy
> CONFIG_QUEUED_RWLOCKS=3Dy
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=3Dy
> CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=3Dy
> CONFIG_ARCH_HAS_SYSCALL_WRAPPER=3Dy
> CONFIG_FREEZER=3Dy
>=20
> CONFIG_HWSPINLOCK=3Dy
>=20
> CONFIG_I8253_LOCK=3Dy
>=20
> #
> # Debug Oops, Lockups and Hangs
> #
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=3D0
> CONFIG_PANIC_TIMEOUT=3D0
> CONFIG_LOCKUP_DETECTOR=3Dy
> CONFIG_SOFTLOCKUP_DETECTOR=3Dy
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=3D0
> CONFIG_HARDLOCKUP_DETECTOR_PERF=3Dy
> CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=3Dy
> CONFIG_HARDLOCKUP_DETECTOR=3Dy
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=3D0
> CONFIG_DETECT_HUNG_TASK=3Dy
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=3D120 <--- the isotp timeout is 1000 ms =
what
> I can observe here with v1 patch
>=20
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
> # CONFIG_WQ_WATCHDOG is not set
> # CONFIG_TEST_LOCKUP is not set
> # end of Debug Oops, Lockups and Hangs
>=20
> Only this debugging stuff is not really enabled:
>=20
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
> # CONFIG_PROVE_LOCKING is not set
CONFIG_PROVE_LOCKING=3Dy

Marc

> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_RWSEMS is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_WW_MUTEX_SELFTEST is not set
> # CONFIG_SCF_TORTURE_TEST is not set
> # CONFIG_CSD_LOCK_WAIT_DEBUG is not set
> # end of Lock Debugging (spinlocks, mutexes, etc...)
>=20
> Would this help to be enabled for this test (of the v1 patch?
>=20
> Best regards,
> Oliver
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ietkikogqwqnu463
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHzrXUACgkQqclaivrt
76lhiwf/Sf3BTE/OLrbN+FrqZYpMlDwxI76aKnZ2lhZ3fw7ZKMii93hEkMDD06v+
FdrlyOSGL5xSDHgq1oZ1qMJ6nWrj9V8bzyR8XAAWKVX8JvBAJQAK5FMV/Qi9xOD/
xrNChkcYYDHvu8DSpOl4nXmjtcfBy8qKuzUJCuEY27+DRM4eDgiwz79Zhk6yQYXO
iD1JqqmDaQpsO9MEA6T03tSZUyTiH38lVrGZ6AhR2wku2Qj0W/bAp3iY60CvUc6S
ggWK4uDhEg3qOSNMBx+Eviw7WyxuXUjqb+c3GH+2REPjPjaqRc/FYV7hFEkyDI6x
Nt752v1DpyhZ0OAqKYQOtgyGIuJx2w==
=99pL
-----END PGP SIGNATURE-----

--ietkikogqwqnu463--
