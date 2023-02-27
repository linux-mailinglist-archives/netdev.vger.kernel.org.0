Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7992F6A42C6
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjB0NeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjB0NeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:34:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D257DB2
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 05:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677504799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f/FzhhKEtTgugR/y3mXLSjzn0vLNSjQZIOnSkH/KjvI=;
        b=KtcYob3g5i2B913o+ga5Tb9sKHJy1j9nlU6mYYDjNYmMpmT3bfjn8lNoIZeWnOdsAM1/oQ
        ++rLo4BwS4mJgnUzf18mlR+a9GCM6LufUNaMv+fahM8dQTMpKP2/YjM15HIXPGpcmZdQnm
        mlFRzbTAseLZT3sz/jBhdpNxezvVeIE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-u9lD_M9dMFKyjm8TSpz0hw-1; Mon, 27 Feb 2023 08:33:17 -0500
X-MC-Unique: u9lD_M9dMFKyjm8TSpz0hw-1
Received: by mail-wr1-f71.google.com with SMTP id 15-20020a056000156f00b002ca79db6d42so617978wrz.18
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 05:33:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/FzhhKEtTgugR/y3mXLSjzn0vLNSjQZIOnSkH/KjvI=;
        b=d8hq8e3zhFwz2NAh99DtvqMRBFPOnNZ5806Gc9DsSY4I1dYYwiBRO3x5wi+JSMQ423
         3pfv2a1kwOFYeEYu/u37UGVmssGu21g2mXqKtsMX4sdqvImlfI0KSBAdq92zPcb+ZV0v
         O/ZVKION53u7gMB/PYmc6VazQgup4uqtvHWbRsxS1JCupyqzdRoi+FvVnqIzr8ac8q5q
         XHZ2dG6ROKVyLeyRrG4kuPsZnxOBQXoVFgnFh3Cu/K4oR0O9aD4W9d6hmWo6nlTTwLzj
         s3M5rwx1fi6v1+WM7dofIMQTs70idQLH9btXFAtqJnDot7RBt2AoJ1fQSCnjqzfM03tT
         FCjA==
X-Gm-Message-State: AO0yUKXIKfuuYCzn2dJMUMspFZNr0g4SsEJbW9yoEUgyniz5AOPKIc1e
        aMO7P1pnnrvveu6TMUUCGqWi8n5TTXY6sEQOdg5PCYGYnJ4grBcVDihhJo2jSoxH9Qpej0c1dP3
        UUaWwpGy2WCq4HRgP
X-Received: by 2002:a5d:4a01:0:b0:2c5:530d:4045 with SMTP id m1-20020a5d4a01000000b002c5530d4045mr22440805wrq.20.1677504796252;
        Mon, 27 Feb 2023 05:33:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/Yz/Rv4CK4NnI11VoX+Rldy1Xt3bEfcajvfM5UFjwwMM3KQIUevlYVIj9yyeSBZmQssT/Hiw==
X-Received: by 2002:a5d:4a01:0:b0:2c5:530d:4045 with SMTP id m1-20020a5d4a01000000b002c5530d4045mr22440777wrq.20.1677504795917;
        Mon, 27 Feb 2023 05:33:15 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id p1-20020a056000018100b002c54fb024b2sm7198843wrx.61.2023.02.27.05.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 05:33:14 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:33:12 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kang Chen <void0red@gmail.com>
Cc:     shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt76: add a check of vzalloc in
 mt7615_coredump_work
Message-ID: <Y/yxGMvBbMGiehC6@lore-desk>
References: <20230227115717.3360755-1-void0red@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ifWNKEdM2/arQ3c2"
Content-Disposition: inline
In-Reply-To: <20230227115717.3360755-1-void0red@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ifWNKEdM2/arQ3c2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> vzalloc may fails, dump might be null and will cause
> illegal address access later.

can you please add a Fixes tag?

Regards,
Lorenzo

>=20
> Signed-off-by: Kang Chen <void0red@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7615/mac.c
> index a95602473..73d84c301 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> @@ -2367,6 +2367,9 @@ void mt7615_coredump_work(struct work_struct *work)
>  	}
> =20
>  	dump =3D vzalloc(MT76_CONNAC_COREDUMP_SZ);
> +	if (!dump)
> +		return;
> +
>  	data =3D dump;
> =20
>  	while (true) {
> --=20
> 2.34.1
>=20

--ifWNKEdM2/arQ3c2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/yxGAAKCRA6cBh0uS2t
rLjcAP0QtrGC6pC4wqyPa3TdGMOKu6ih0Dlbdf4hC0hL6+BYTAEAxEIcRy+wsaR6
kT/4qA1YwxG1EmeDzGEy+PPTPp/NZAA=
=x8oL
-----END PGP SIGNATURE-----

--ifWNKEdM2/arQ3c2--

