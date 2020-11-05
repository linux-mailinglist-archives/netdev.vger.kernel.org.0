Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAFF2A89FB
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbgKEWho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEWhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:37:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A1420782;
        Thu,  5 Nov 2020 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604615863;
        bh=w3F/rSZcivfcnuUxOo4OMBFkw8TVLRJz2c2fdB0ueOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FmLwpwK5/iEzuAVU4uK/BOGTyPw9/ZzQ1rZTLuSo5/xwcHN5SgmYGPFTH/FI7EWHE
         BcXwfXt2gcRlxgf4PNTKS2jwg4cDQzGdUwn5EdQxxgCrGf8wSe4QDFR2lJzqP6pUbb
         XjcTjcaCSjduu3kutUGVvtYfF+Mb5a6umUWll9ME=
Date:   Thu, 5 Nov 2020 14:37:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH net-next v2 1/7] drivers: net: smc91x: Fix set but
 unused W=1 warning
Message-ID: <20201105143742.047959ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104154858.1247725-2-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
        <20201104154858.1247725-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 16:48:52 +0100 Andrew Lunn wrote:
> drivers/net/ethernet/smsc/smc91x.c:706:51: warning: variable =E2=80=98pkt=
_len=E2=80=99 set but not used [-Wunused-but-set-variable]
>   706 |  unsigned int saved_packet, packet_no, tx_status, pkt_len;
>=20
> Add a new macro for getting fields out of the header, which only gets
> the status, not the length which in this case is not needed.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Sorry I missed something on v1

> +#define SMC_GET_PKT_HDR_STATUS(lp, status)				\
> +	do {								\
> +		if (SMC_32BIT(lp)) {					\
> +			unsigned int __val =3D SMC_inl(ioaddr, DATA_REG(lp)); \
> +			(status) =3D __val & 0xffff;			\
> +		} else {						\
> +			(status) =3D SMC_inw(ioaddr, DATA_REG(lp));	\
> +		}							\
> +	} while (0)

This is the original/full macro:

#define SMC_GET_PKT_HDR(lp, status, length)				\
	do {								\
		if (SMC_32BIT(lp)) {				\
			unsigned int __val =3D SMC_inl(ioaddr, DATA_REG(lp)); \
			(status) =3D __val & 0xffff;			\
			(length) =3D __val >> 16;				\
		} else {						\
			(status) =3D SMC_inw(ioaddr, DATA_REG(lp));	\
			(length) =3D SMC_inw(ioaddr, DATA_REG(lp));	\
		}							\
	} while (0)

Note that it reads the same address twice in the else branch.

I'm 90% sure we can't remove the read here either so best treat it
like the ones in patch 3, right?
