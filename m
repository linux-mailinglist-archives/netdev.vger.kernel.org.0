Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31A03EEDB1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbhHQNst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhHQNss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7392A60F5E;
        Tue, 17 Aug 2021 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629208095;
        bh=SHTg9E1mrOP3yAXEk8dqosQtzI+z9tfOAniEWmkI2/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kLp+selN5w/DDZV/h9xheg2IwFbVKfhnBLzjBitkvwBNkrx4dIoyjdcibsee9e1eb
         we6c3qdG3gS+l/dyn4EwscqMMiqrOsgG0jqOH7j3C83FfBrwMoayXPLwkWjOab+4j6
         wLAZ6coo9oD67+oDtSG1CmLlmtJ3jRJeJL+yuK2/AgGRovcRDR0Z96fiah1ex/cgUp
         EHwdKKZtGIgaid1tRmRifCdo8vTjluZmHm/Ic4dzfpNxLzqkIWeEcfChMXGDgWGA0K
         DHJWMafMRO/kvO+vYHSKCxI4IVb0MXgg3D9fJ+itz4wstDaX/ZxnMT0eSgK2rN6hIs
         8ovGVxPPn2ngA==
Date:   Tue, 17 Aug 2021 06:48:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net-next 1/1] ptp_ocp: use bits.h macros for all
 masks
Message-ID: <20210817064814.13c57002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817122454.50616-1-andriy.shevchenko@linux.intel.com>
References: <20210817122454.50616-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 15:24:54 +0300 Andy Shevchenko wrote:
> Currently we are using BIT(), but GENMASK(). Make use of the latter one
> as well (far less error-prone, far more concise).
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/ptp/ptp_ocp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index caf9b37c5eb1..922f92637db8 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright (c) 2020 Facebook */
> =20
> +#include <linux/bits.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -84,10 +85,10 @@ struct tod_reg {
>  #define TOD_CTRL_DISABLE_FMT_A	BIT(17)
>  #define TOD_CTRL_DISABLE_FMT_B	BIT(16)
>  #define TOD_CTRL_ENABLE		BIT(0)
> -#define TOD_CTRL_GNSS_MASK	((1U << 4) - 1)
> +#define TOD_CTRL_GNSS_MASK	GENMASK(3, 0)
>  #define TOD_CTRL_GNSS_SHIFT	24
> =20
> -#define TOD_STATUS_UTC_MASK	0xff
> +#define TOD_STATUS_UTC_MASK	GENMASK(7, 0)
>  #define TOD_STATUS_UTC_VALID	BIT(8)
>  #define TOD_STATUS_LEAP_VALID	BIT(16)

GENMASK is unsigned long:

drivers/ptp/ptp_ocp.c: In function =E2=80=98ptp_ocp_tod_info=E2=80=99:
drivers/ptp/ptp_ocp.c:648:27: warning: format =E2=80=98%d=E2=80=99 expects =
argument of type =E2=80=98int=E2=80=99, but argument 3 has type =E2=80=98lo=
ng unsigned int=E2=80=99 [-Wformat=3D]
  648 |  dev_info(&bp->pdev->dev, "utc_offset: %d  valid:%d  leap_valid:%d\=
n",
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~
include/linux/dev_printk.h:19:22: note: in definition of macro =E2=80=98dev=
_fmt=E2=80=99
   19 | #define dev_fmt(fmt) fmt
      |                      ^~~
drivers/ptp/ptp_ocp.c:648:2: note: in expansion of macro =E2=80=98dev_info=
=E2=80=99
  648 |  dev_info(&bp->pdev->dev, "utc_offset: %d  valid:%d  leap_valid:%d\=
n",
      |  ^~~~~~~~
drivers/ptp/ptp_ocp.c:648:41: note: format string is defined here
  648 |  dev_info(&bp->pdev->dev, "utc_offset: %d  valid:%d  leap_valid:%d\=
n",
      |                                        ~^
      |                                         |
      |                                         int
      |                                        %ld
