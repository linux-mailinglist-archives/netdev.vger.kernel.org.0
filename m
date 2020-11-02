Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15452A374C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgKBXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgKBXrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:47:46 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C4F2084C;
        Mon,  2 Nov 2020 23:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604360866;
        bh=3lG7TEvcZLN3Qy2OSGIfIcDgc105w4/I/dqIMpYA/UY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pu24TcetHmQzYQnuzJ55hmJekditvioDRepyqnZyAOibSbucurd9EYt4+f0J3Qkc2
         kDrQ0WT6yw7qtfmO0el3kYIaQhEuEe98RperHI7jJd3KCi0OuNdZVDlq+RFZm756Ha
         SY2onchOk3J1nfv+jEyCd2x25KWG1LhMimf9EtC8=
Date:   Mon, 2 Nov 2020 15:47:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH net-next 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
Message-ID: <20201102154745.39cd54ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031004958.1059797-7-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
        <20201031004958.1059797-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 01:49:57 +0100 Andrew Lunn wrote:
> drivers/net/ethernet/smsc/smc911x.c: In function =E2=80=98smc911x_hardwar=
e_send_pkt=E2=80=99:
> drivers/net/ethernet/smsc/smc911x.c:471:11: warning: cast from pointer to=
 integer of different size [-Wpointer-to-int-cast]
>   471 |  cmdA =3D (((u32)skb->data & 0x3) << 16) |
>=20
> When built on 64bit targets, the skb->data pointer cannot be cast to a
> u32 in a meaningful way. Use long instead.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/smsc/smc911x.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/s=
msc/smc911x.c
> index 4ec292563f38..f37832540364 100644
> --- a/drivers/net/ethernet/smsc/smc911x.c
> +++ b/drivers/net/ethernet/smsc/smc911x.c
> @@ -466,9 +466,9 @@ static void smc911x_hardware_send_pkt(struct net_devi=
ce *dev)
>  			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
>  			skb->len;
>  #else
> -	buf =3D (char*)((u32)skb->data & ~0x3);
> -	len =3D (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
> -	cmdA =3D (((u32)skb->data & 0x3) << 16) |
> +	buf =3D (char *)((long)skb->data & ~0x3);
> +	len =3D (skb->len + 3 + ((long)skb->data & 3)) & ~0x3;
> +	cmdA =3D (((long)skb->data & 0x3) << 16) |

Probably best if you swap the (long) for something unsigned here as
well.
