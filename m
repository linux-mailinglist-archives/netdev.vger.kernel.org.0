Return-Path: <netdev+bounces-5814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D10712E22
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA552818BB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CF5168A1;
	Fri, 26 May 2023 20:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAA62A9DC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 20:30:27 +0000 (UTC)
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E8BE7;
	Fri, 26 May 2023 13:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1685133022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nrJocbC9yujvo/q/Zvs4to1pf3VWKChUTxeNN8aTAa0=;
	b=I/LSxf9eXH1Ikzq1flOLF5C80S7pH/0I/Jm0EFS5cz2h5bm7XpXIbRPK2L0iu7XbaFTqTq
	eNci93A+CRVdDUe6klTXO/tCMUkmTXTEk34RO8c3ohoKfnzOqMwP+DzxhjOBweZcZAYypG
	B8AS5+F3I3PkNhHN5zgPby7OKPsQst0=
From: Sven Eckelmann <sven@narfation.org>
To: Marek Lindner <mareklindner@neomailbox.ch>,
 Vladislav Efanov <VEfanov@ispras.ru>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
 Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, b.a.t.m.a.n@lists.open-mesh.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH] batman-adv: Broken sync while rescheduling delayed work
Date: Fri, 26 May 2023 22:30:16 +0200
Message-ID: <7526514.EvYhyI6sBW@sven-l14>
In-Reply-To: <20230526161632.1460753-1-VEfanov@ispras.ru>
References: <20230526161632.1460753-1-VEfanov@ispras.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3740035.kQq0lBPeGt";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--nextPart3740035.kQq0lBPeGt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Date: Fri, 26 May 2023 22:30:16 +0200
Message-ID: <7526514.EvYhyI6sBW@sven-l14>
In-Reply-To: <20230526161632.1460753-1-VEfanov@ispras.ru>
References: <20230526161632.1460753-1-VEfanov@ispras.ru>
MIME-Version: 1.0

On Friday, 26 May 2023 18:16:32 CEST Vladislav Efanov wrote:
> Syzkaller got a lot of crashes like:
> KASAN: use-after-free Write in *_timers*
> 
> All of these crashes point to the same memory area:
> 
> The buggy address belongs to the object at ffff88801f870000
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 5320 bytes inside of
>  8192-byte region [ffff88801f870000, ffff88801f872000)
> 
> This area belongs to :
>         batadv_priv->batadv_priv_dat->delayed_work->timer_list
> 
> The reason for these issues is the lack of synchronization. Delayed
> work (batadv_dat_purge) schedules new timer/work while the device
> is being deleted. As the result new timer/delayed work is set after
> cancel_delayed_work_sync() was called. So after the device is freed
> the timer list contains pointer to already freed memory.
> 
> Found by Linux Verification Center (linuxtesting.org) with syzkaller.
> 
> Fixes: 2f1dfbe18507 ("batman-adv: Distributed ARP Table - implement local storage")
> Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
> ---


Acked-by: Sven Eckelmann <sven@narfation.org>

Thanks,
	Sven
--nextPart3740035.kQq0lBPeGt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmRxFtgACgkQXYcKB8Em
e0ZD0RAAp8e/HTANDtMQF/tKm+CEosGlP+Hp8Aqdd8nNfTXXC2DJAouO/TO2ycmq
G0N393ff6vuTkebzzuM8QqOQxFVMGCH/VDGZEkOAr+Qyq8V6Vq50uCJUyi1TkCEk
lhM/wvBXJbadpikiJdkYdfJFBMUcNqRnMsmvDU3ASPw8g4/ZlTfRDKPn56UUUjb1
juIiGBWFTQ0tzcEh5p9YgrArb/jI7YkZR4BNfheFEoPZqZRkP5CaonXE436uQIjz
raVe+QnxlGHVFUGpIyebNEB5/ZtWN1gsOXetqLcjFgjkwh9Qvow8tjNv13VqbTd5
rUHp8HoTwrq3UGNW3xUzRWuxJtQBOwKrNmebw2CN179C4qEZjipY14XnfGngZLyE
27QcB6s4wWz1UMjIiZ8OnN7gAzDmHKde1LqdQQp9WaAfLwFKCEeNMECg1QhQExaD
vsfUr5aNuaLNk9KV/l+sus4hOCzeGCgmlUsrw9rWR3yk5PEjpUeg0IkJmZr7nFkx
ykj5yPFHvgFi6q0VV7ppV4iXEoPTP7s4uZqCeHn8MQ1jVNZio/l7YhwZBYN3pfbK
5nv2jKXsK079UHV9qzmhQH31jZEh//jwcupyMF+k63RpQM8sfENKb25EkUJN5ebQ
gNnzdr1ElKsPD8TUQ1B9SVI0QKNpTGMXWsiNjX/BMVblnUvcxKE=
=sHaT
-----END PGP SIGNATURE-----

--nextPart3740035.kQq0lBPeGt--




