Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D727438002
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhJVVtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhJVVtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 17:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47D0C60E08;
        Fri, 22 Oct 2021 21:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634939241;
        bh=jKQD9VrChSbttdxAsCT8T3diMOySRl3L2zNOOdg9drU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LVuJDnjT3z5p/EA5eySTLq2VWCo2Yaia4mcqtfx89mcE6GdhbLKUi0YaLLqJfOnMY
         xuYzqrgd99Aixcq5oaGB05fYBmnmy2c0zyF+G9qFs7CSh3DUpZWK+z1a93AElhwapq
         s7oWU1qkjaFqIUP//sbkmAl7F1xgtZR8NBotZtvbSFpphDurz8W04p0Oh1SNtlrqjc
         YJ2NdzQJtRcxa6UAJ2t9q+79nqX7jQyGH87am+8D9SGwSPkVFN8S2ouO9dyqjsAYxv
         UMxVFrpj/bA64gvDoNwIkAXXjmdNGfmtAf8jJCZh4udwgcXM1XaXSgIszGFtLgSFBa
         oCTbjafAr+6EQ==
Date:   Fri, 22 Oct 2021 14:47:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: qed_dev: fix redundant check of rc
 and against -EINVAL
Message-ID: <20211022144720.7d1d9eb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e7289c4e6a57f9a98a8f3fac1d5c7c181cbe8319.1634847661.git.sakiwit@gmail.com>
References: <cover.1634847661.git.sakiwit@gmail.com>
        <e7289c4e6a57f9a98a8f3fac1d5c7c181cbe8319.1634847661.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 21:37:41 -0600 J=CE=B5an Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
>=20
> We should first check rc alone and then check it against -EINVAL to
> avoid repeating the same operation multiple times.
>=20
> We should also remove the check of !rc in this expression since it is
> always true:
>=20
> 	(!rc && !resc_lock_params.b_granted)
>=20
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>

The code seems to be written like this on purpose. You're adding
indentation levels, and making the structure less readable IMO.

If you want to avoid checking rc / !rc multiple times you can just
code it as:

	if (rc =3D=3D -EINVAL)
		...
	else if (rc)
		...
	else if (!granted)
		...
	else
		...

I'm not sure I see the point of the re-factoring.

> (1) Fix missing else branch. I'm very sorry.
> (2) Add text for !rc removal in the changelog.
> (3) Put two lines of qed_mcp_resc_unlock() call into one.
>     Thank you, Mr. Horman!
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 31 +++++++++++++----------
>  1 file changed, 17 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethe=
rnet/qlogic/qed/qed_dev.c
> index 18f3bf7c4dfe..4ae9867b2535 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -3987,26 +3987,29 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwf=
n, struct qed_ptt *p_ptt)
>  				       QED_RESC_LOCK_RESC_ALLOC, false);
> =20
>  	rc =3D qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
> -	if (rc && rc !=3D -EINVAL) {
> -		return rc;
> -	} else if (rc =3D=3D -EINVAL) {
> +	if (rc) {
> +		if (rc !=3D -EINVAL)
> +			return rc;
>  		DP_INFO(p_hwfn,
>  			"Skip the max values setting of the soft resources since the resource=
 lock is not supported by the MFW\n");
> -	} else if (!rc && !resc_lock_params.b_granted) {
> -		DP_NOTICE(p_hwfn,
> -			  "Failed to acquire the resource lock for the resource allocation co=
mmands\n");
> -		return -EBUSY;
>  	} else {
> -		rc =3D qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
> -		if (rc && rc !=3D -EINVAL) {
> +		if (!resc_lock_params.b_granted) {
>  			DP_NOTICE(p_hwfn,
> -				  "Failed to set the max values of the soft resources\n");
> -			goto unlock_and_exit;
> -		} else if (rc =3D=3D -EINVAL) {
> +				  "Failed to acquire the resource lock for the resource allocation c=
ommands\n");
> +			return -EBUSY;
> +		}
> +
> +		rc =3D qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
> +		if (rc) {
> +			if (rc !=3D -EINVAL) {
> +				DP_NOTICE(p_hwfn,
> +					  "Failed to set the max values of the soft resources\n");
> +				goto unlock_and_exit;
> +			}
> +
>  			DP_INFO(p_hwfn,
>  				"Skip the max values setting of the soft resources since it is not s=
upported by the MFW\n");
> -			rc =3D qed_mcp_resc_unlock(p_hwfn, p_ptt,
> -						 &resc_unlock_params);
> +			rc =3D qed_mcp_resc_unlock(p_hwfn, p_ptt, &resc_unlock_params);
>  			if (rc)
>  				DP_INFO(p_hwfn,
>  					"Failed to release the resource lock for the resource allocation co=
mmands\n");

