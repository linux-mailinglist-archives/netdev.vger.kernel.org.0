Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF953C65BA
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 23:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhGLVzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:55:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46240 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhGLVzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 17:55:50 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EC63C1C0B77; Mon, 12 Jul 2021 23:52:59 +0200 (CEST)
Date:   Mon, 12 Jul 2021 23:52:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 016/137] net: Treat __napi_schedule_irqoff()
 as __napi_schedule() on PREEMPT_RT
Message-ID: <20210712215258.GB8934@amd>
References: <20210706112203.2062605-1-sashal@kernel.org>
 <20210706112203.2062605-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20210706112203.2062605-16-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> which can be used where it is known that interrupts are disabled,
> e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> callbacks.
>=20
> On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> threaded interrupt handlers and spinlocks are not disabling interrupts
> and the NAPI hrtimer callback is forced into softirq context which runs
> with interrupts enabled as well.
>=20
> Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
> game so make __napi_schedule_irqoff() invoke __napi_schedule() for
> PREEMPT_RT kernels.
>=20
> The callers of ____napi_schedule() in the networking core have been
> audited and are correct on PREEMPT_RT kernels as well.

I see this is queued to kernels as old as 4.4... Is it good idea?
PREEMPT_RT is not usable there without extra patches, so it does not
really fix anything user visible....

Best regards,
								Pavel
							=09
> index 0c9ce36afc8c..2fdf30eefc59 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6433,11 +6433,18 @@ EXPORT_SYMBOL(napi_schedule_prep);
>   * __napi_schedule_irqoff - schedule for receive
>   * @n: entry to schedule
>   *
> - * Variant of __napi_schedule() assuming hard irqs are masked
> + * Variant of __napi_schedule() assuming hard irqs are masked.
> + *
> + * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
> + * because the interrupt disabled assumption might not be true
> + * due to force-threaded interrupts and spinlock substitution.
>   */
>  void __napi_schedule_irqoff(struct napi_struct *n)
>  {
> -	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	else
> +		__napi_schedule(n);
>  }
>  EXPORT_SYMBOL(__napi_schedule_irqoff);
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDsuboACgkQMOfwapXb+vLvvACffTukjrW71y6YKE1ySo+48aN2
bFIAn1ntM7CS2o6IrhJD/6GFlrQPmDb+
=5f+k
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
