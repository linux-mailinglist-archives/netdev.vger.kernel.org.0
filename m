Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECAD2A374D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgKBXsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:48:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgKBXsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:48:32 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4272207C4;
        Mon,  2 Nov 2020 23:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604360912;
        bh=5l6myunltbOARndJqQtVp1cXUurIwbXPlYVvxqRb75Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aRetV/vdXh06rPL9LTo7mNiyvCasWcxbiAQAJ9rvYQd0y4nW00fu4m7JzQXrOxk43
         KIwFTaG8tgPpkUYi8qsbOt1dDW81VUMeQaMMTmnAlNCKx6z95PVzK9h4/c/HMA/zmq
         JvKG6G9ORSwa23HpGciVsaVAT0WCTCDK9we+P8g4=
Date:   Mon, 2 Nov 2020 15:48:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH net-next 4/7] drivers: net: smc911x: Fix set but unused
 status because of DBG macro
Message-ID: <20201102154831.7a1b7140@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031004958.1059797-5-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
        <20201031004958.1059797-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 01:49:55 +0100 Andrew Lunn wrote:
> drivers/net/ethernet/smsc/smc911x.c: In function =E2=80=98smc911x_timeout=
=E2=80=99:
> drivers/net/ethernet/smsc/smc911x.c:1251:6: warning: variable =E2=80=98st=
atus=E2=80=99 set but not used [-Wunused-but-set-variable]
>  1251 |  int status, mask;
>=20
> The status is read in order to print it via the DBG macro. However,
> due to the way DBG is disabled, the compiler never sees it being used.
>=20
> Change the DBG macro to actually make use of the passed parameters,
> and the leave the optimiser to remove the unwanted code inside the if
> (0).
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/smsc/smc911x.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/s=
msc/smc911x.c
> index 8f748a0c057e..33d0398c182e 100644
> --- a/drivers/net/ethernet/smsc/smc911x.c
> +++ b/drivers/net/ethernet/smsc/smc911x.c
> @@ -102,7 +102,11 @@ MODULE_ALIAS("platform:smc911x");
> =20
>  #define PRINTK(dev, args...)   netdev_info(dev, args)
>  #else
> -#define DBG(n, dev, args...)   do { } while (0)
> +#define DBG(n, dev, args...)			 \
> +	do {					 \
> +		if (0)				 \
> +			netdev_dbg(dev, args);	 \
> +	} while (0)

nit: since you have to respin - while (0) { } would do here.
