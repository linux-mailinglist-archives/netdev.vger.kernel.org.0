Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D41646E8E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLHLaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHLaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:30:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81579391FD
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:30:05 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3C8B4208B7;
        Thu,  8 Dec 2022 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670499004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5WTUvY0lOswKhro+OFkZg6JbAWgR7VPHmSCSLDfK4Ns=;
        b=tULzB00wImCEjHZBIILCV/BhQsPk2DbMtIB7zOT4pjfljomQHT7jGIw5ri0FOz/pX1zjIS
        pvDIzT4Z1hXmfOKQtazoiLvjf3o0QPmoMezypw+Iyv6O+OVwH2b66KRmVdHbVA+rFJpNiq
        Kf1ukQMp9bEhBV9rws9OGQ66kqbttlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670499004;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5WTUvY0lOswKhro+OFkZg6JbAWgR7VPHmSCSLDfK4Ns=;
        b=gYcwMpIooud/rLduGEOysu80mjQ4RZKOI9WEjp6NLAhFm9fkwfnv9LWRoextCyshxsg99c
        l/lcSwwp86vD3eBQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 115282C142;
        Thu,  8 Dec 2022 11:30:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D1A2A6045E; Thu,  8 Dec 2022 12:30:03 +0100 (CET)
Date:   Thu, 8 Dec 2022 12:30:03 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 12/13] ethtool: fix leak of memory after
 realloc
Message-ID: <20221208113003.yhvw6veiaznxqqh5@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-13-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i63737ajm2vumr45"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-13-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--i63737ajm2vumr45
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:21PM -0800, Jesse Brandeburg wrote:
> cppcheck finds:
> netlink/msgbuff.c:63:2: error: Memory leak: nbuff [memleak]
>  return 0;
>  ^

This reported error is misleading, the commit message should make it
clear that the leak it addresses is not of nbuff but of the original
msgbuff->buff (on failure).

> This is a pretty common problem with realloc() and just requires handling
> the return code correctly which makes us refactor to reuse the structure
> free/reinit code that already exists in msgbuf_done().
>=20
> This fixes the code flow by doing the right thing if realloc() succeeds a=
nd
> if it fails then being sure to free the original memory and replicate the
> steps the original code took.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  netlink/msgbuff.c | 39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
>=20
> diff --git a/netlink/msgbuff.c b/netlink/msgbuff.c
> index 216f5b946236..a599cab06014 100644
> --- a/netlink/msgbuff.c
> +++ b/netlink/msgbuff.c
[...]
> @@ -43,19 +57,16 @@ int msgbuff_realloc(struct nl_msg_buff *msgbuff, unsi=
gned int new_size)
>  	if (new_size > MAX_MSG_SIZE)
>  		return -EMSGSIZE;
>  	nbuff =3D realloc(msgbuff->buff, new_size);
> -	if (!nbuff) {
> -		msgbuff->buff =3D NULL;
> -		msgbuff->size =3D 0;
> -		msgbuff->left =3D 0;
> -		return -ENOMEM;
> -	}
> -	if (nbuff !=3D msgbuff->buff) {
> +	if (nbuff) {
>  		if (new_size > old_size)
>  			memset(nbuff + old_size, '\0', new_size - old_size);
>  		msgbuff->nlhdr =3D (struct nlmsghdr *)(nbuff + nlhdr_off);
>  		msgbuff->genlhdr =3D (struct genlmsghdr *)(nbuff + genlhdr_off);
>  		msgbuff->payload =3D nbuff + payload_off;
>  		msgbuff->buff =3D nbuff;
> +	} else {
> +		msgbuff_done(msgbuff);
> +		return -ENOMEM;
>  	}
>  	msgbuff->size =3D new_size;
>  	msgbuff->left +=3D (new_size - old_size);

If nbuff is null (reallocation failed), we bail out anyway so there is
no point putting part of the followin code inside an if and leaving the
rest outside. Also, while it makes sense to zero the new part of the
buffer even if the buffer is not moved, there is no reason to
reinitialize all the pointers. How about this:

	if (!nbuff) {
		msgbuff_done(msgbuff);
		return -ENOMEM;
	}
	if (new_size > old_size)
		memset(nbuff + old_size, '\0', new_size - old_size);
	if (nbuff !=3D msgbuff->buff) {
		msgbuff->nlhdr =3D (struct nlmsghdr *)(nbuff + nlhdr_off);
		msgbuff->genlhdr =3D (struct genlmsghdr *)(nbuff + genlhdr_off);
		msgbuff->payload =3D nbuff + payload_off;
		msgbuff->buff =3D nbuff;
	}
	msgbuff->size =3D new_size;
	msgbuff->left +=3D (new_size - old_size);

Or we could forget about the "if (nbuff !=3D msgbuff->buff)" test and
assign the four pointers to values they already have in case the block
stays in place. The code would look a bit tidier and the difference
would be negligible.

And looking at the code again, the "new_size > old_size" check can be
omitted too as we already have

	if (new_size <=3D old_size)
		return 0;

before the realloc() call. This is a relic from a development version
where realloc() was also used to shrink the buffer if new requested size
was smaller than current.


Michal

--i63737ajm2vumr45
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORyrcACgkQ538sG/LR
dpWvzwgAtqlid5q/Bepl5Q/KvbvuZA/0SwujakexCnaMXKamafShAPlBmGQDS+sA
3h6QtItQRDzAqzqaE1ehCBV3hA2fIGCURtclzIgnRmDbvF4uio+GMUCbS8LENWfF
QaJZy2IRYPmIPuL5H34HkzH/rT6jCy/NJgwxEJIhlkpB69zF/mZSY1fMSq/zY4fe
sT4OuZ4bmrOHUlzY7ZR98Axh6KZA096y0NCU4xPf+dtRA7sOXp7GsOlD+57lV1l6
/g4c5OkdyFTQjisCjE0Lw1Ee2WF2gKkD6MgID0qHWpvseXnY3Md9tLju5w7NkjML
AlEuykIoysFccIMKm8Qtc71rqBloBA==
=Q+sY
-----END PGP SIGNATURE-----

--i63737ajm2vumr45--
