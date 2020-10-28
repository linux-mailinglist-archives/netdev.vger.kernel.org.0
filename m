Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6708929DF03
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403815AbgJ2A5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731607AbgJ1WRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7738F22284;
        Wed, 28 Oct 2020 00:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603846039;
        bh=mjVdZbW5m/TD5xCBuPH+ihZcGUWgMeIFOpcHdX0fbbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SKBkhZwDpjZaNff26d1HIdpgB/uWT8FqNqUvJUE/poa+FFlt+/WXsyX151Ehf8ReV
         v8lg8uco8sb124R0t1crKq7BahQuJBChydcPYEO2kRJiQjg3N4gT+t7oJR5CfZQ3B0
         lpi4x02t9BWC1ezoo15Rvv8xAdBjZ0gq5k6crj3o=
Date:   Tue, 27 Oct 2020 17:47:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hui Su <sh_def@163.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/atm: use list_is_singular() in br2684_setfilt()
Message-ID: <20201027174718.51889f52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026165700.GA8218@rlk>
References: <20201026165700.GA8218@rlk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 00:57:00 +0800 Hui Su wrote:
> list_is_singular() can tell whether a list has just one entry.
> So we use list_is_singular=EF=BC=88) here.
>=20
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  net/atm/br2684.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/atm/br2684.c b/net/atm/br2684.c
> index 3e17a5ecaa94..398f7e086cf4 100644
> --- a/net/atm/br2684.c
> +++ b/net/atm/br2684.c
> @@ -372,8 +372,7 @@ static int br2684_setfilt(struct atm_vcc *atmvcc, voi=
d __user * arg)
>  		struct br2684_dev *brdev;
>  		read_lock(&devs_lock);
>  		brdev =3D BRPRIV(br2684_find_dev(&fs.ifspec));
> -		if (brdev =3D=3D NULL || list_empty(&brdev->brvccs) ||
> -		    brdev->brvccs.next !=3D brdev->brvccs.prev)	/* >1 VCC */
> +		if (brdev =3D=3D NULL || !list_is_singular(&brdev->brvccs))	/* >1 VCC =
*/

You can drop the /* >1 VCC */ comment now, the code is clear enough

>  			brvcc =3D NULL;
>  		else
>  			brvcc =3D list_entry_brvcc(brdev->brvccs.next);

