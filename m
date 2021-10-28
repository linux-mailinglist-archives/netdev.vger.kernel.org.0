Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345E43DC1A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJ1Hg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJ1Hg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:36:56 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F1C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 00:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1635406465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tAsS4XDto9sTBJsiNUMKvu7NHRyi2tTrhGT9WAGnoXI=;
        b=f1yKK8hLKlO/Vg9zhxJFoAztctGpYDNpQQtiHBZpfwAZd4ffdB/7VP+zhNwn8m6BxqNdxw
        qMwpZHEE1stWgOaINGHl8OaUkP2Xv7HGNvhdOpnVeC84KMvaRtC0IFC17me8ELCKJJ5mZM
        2EoIwb6TVai9aY8c7lZjdu7d1R8CmIA=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        Yajun Deng <yajun.deng@linux.dev>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: Re: [PATCH net-next] batman-adv: Fix the wrong definition
Date:   Thu, 28 Oct 2021 09:34:22 +0200
Message-ID: <3533360.G9yuKbSBSH@ripper>
In-Reply-To: <20211028072306.1351-1-yajun.deng@linux.dev>
References: <20211028072306.1351-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10544534.tba8fyArm4"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart10544534.tba8fyArm4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, Yajun Deng <yajun.deng@linux.dev>
Cc: b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: Re: [PATCH net-next] batman-adv: Fix the wrong definition
Date: Thu, 28 Oct 2021 09:34:22 +0200
Message-ID: <3533360.G9yuKbSBSH@ripper>
In-Reply-To: <20211028072306.1351-1-yajun.deng@linux.dev>
References: <20211028072306.1351-1-yajun.deng@linux.dev>

On Thursday, 28 October 2021 09:23:06 CEST Yajun Deng wrote:
> There are three variables that are required at most,
> no need to define four variables.

NAck. This is absolutely wrong - the last one is the "STOP" info. With your 
patch, it would sometimes (action != BATADV_UEV_DEL) not have the stop NULL.
See also the second parameter in this for loop on line
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/kobject_uevent.c?id=1fc596a56b334f4d593a2b49e5ff55af6aaa0816#n548

We can discuss that this can be written in a better way. See 
https://patchwork.open-mesh.org/project/b.a.t.m.a.n./patch/1403982781.9064.33.camel@joe-AO725/ 
(also the remark from Antonio).

> 
> Fixes: 0fa4c30d710d ("batman-adv: Make sysfs support optional")

Even this Fixes would be wrong. The code is there since commit
c6bda689c2c9 ("batman-adv: add wrapper function to throw uevent in 
userspace").

But even then, this would not fix anything but just be a cleanup.

> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/batman-adv/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
> index 3ddd66e4c29e..758035b3796d 100644
> --- a/net/batman-adv/main.c
> +++ b/net/batman-adv/main.c
> @@ -656,7 +656,7 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
>  {
>  	int ret = -ENOMEM;
>  	struct kobject *bat_kobj;
> -	char *uevent_env[4] = { NULL, NULL, NULL, NULL };
> +	char *uevent_env[3] = {};
>  
>  	bat_kobj = &bat_priv->soft_iface->dev.kobj;
>  
> 


--nextPart10544534.tba8fyArm4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmF6Un4ACgkQXYcKB8Em
e0ahbw//RXWo4gRnRdcHgfuizcVUg3BOZqncBdPYsv/yI9Hp0MltHcbTTNAfHKxE
PCc0FYbAZbSVhlgdlmDAGcsCVZIemGJXYMIJASgjynxYgPUTPyFqJp2Bv9uoUypy
32w1GgVomhs6c9PtP0IIa2c64MfdC8NAare2m8pUrfL2ejXIIADGo8VmM7uRZb9V
SARnQXdJhSa70x6VUALXGeU9L1bcL8eJ3fNrsZfkqnfQrOQ01bxFdw3uyLyY8rdp
kDd61bHs1aVhRNPehSg8sTn2+XadKwDSMXk0IKLwrNMuEizYZNW6Gn7cBkvrVqVa
+f4MsRzJEhTvztfaA9ipb9XQA+G6uP3n3czY4ZKI5UT9T3D3SN5UXrbu59lruHIV
P+ddqxIytNo+w3dhRDIKo1neyyHiWUP3vyGWS9GyjuEOBqr10VPwyTrHUrZ9kz+Z
qxsu1rT79oISAp3yf3Zdc+C8cZbkzVcET1esfdxYtP3GbOfxm4Rc69LydiTmiQ5u
Vis6ugd49RuWMJgDPemMUfqdZLZFkjB0dOQFNGfr9NOyXcnVs+6Uqjg0KgzS49PJ
yotiY9cCEgFv3HBNx5KHvsCpuUVWPvWSvuGS+qt6nZNRj/eBqn0SMCLnRSy2Jvkj
tsX0OedkS9RKbklgbnU8NQNL3jZTrmPK5KJWumSou+XEhupJwgA=
=UCNt
-----END PGP SIGNATURE-----

--nextPart10544534.tba8fyArm4--



