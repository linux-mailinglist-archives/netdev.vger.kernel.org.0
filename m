Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4842A3766
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgKCABH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgKCABH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:01:07 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB2E9208B6;
        Tue,  3 Nov 2020 00:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604361667;
        bh=kdVaFK4cdhfpO7oqgh7FueC6wxxVUjW+lPKrZwsyJRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NISqcaka6svs0NVtF5CoG8KF57CaOmrFH2s2ALzHD3vvVqsI5e9WapuyO8C9QbILB
         QLlLC+m6hbNFhzsLH06yK/nrc59JPVjYwmWlsDEAmtCipTFGRPI7SoMgQ/qbLsWFmL
         k3Gf9gurVgVvHHBbFZIcgfjmBWPhjHt/j6AQov7A=
Date:   Mon, 2 Nov 2020 16:01:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation
 with W=1
Message-ID: <20201102160106.29edcc11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031174028.1080476-1-andrew@lunn.ch>
References: <20201031174028.1080476-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 18:40:28 +0100 Andrew Lunn wrote:
> In function =E2=80=98strncpy=E2=80=99,
>     inlined from =E2=80=98sky2_name=E2=80=99 at drivers/net/ethernet/marv=
ell/sky2.c:4903:3,
>     inlined from =E2=80=98sky2_probe=E2=80=99 at drivers/net/ethernet/mar=
vell/sky2.c:5049:2:
> ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=E2=
=80=99 specified bound 16 equals destination size [-Wstringop-truncation]
>=20
> None of the device names are 16 characters long, so it was never an
> issue, but reduce the length of the buffer size by one to avoid the
> warning.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/marvell/sky2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/m=
arvell/sky2.c
> index 25981a7a43b5..35b0ec5afe13 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *buf, =
int sz)
>  	};
> =20
>  	if (chipid >=3D CHIP_ID_YUKON_XL && chipid <=3D CHIP_ID_YUKON_OP_2)
> -		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
> +		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz - 1);

Hm. This irks the eye a little. AFAIK the idiomatic code would be:

	strncpy(buf, name..., sz - 1);
	buf[sz - 1] =3D '\0';

Perhaps it's easier to convert to strscpy()/strscpy_pad()?

>  	else
>  		snprintf(buf, sz, "(chip %#x)", chipid);
>  	return buf;

