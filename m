Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26D24B7B3E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbiBOXb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:31:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiBOXby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:31:54 -0500
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 15:31:41 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8559B65433;
        Tue, 15 Feb 2022 15:31:40 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1644967321; bh=oxkQ8fDff2RyUMjp4s/XquWC9mjWFRhyAC3CN7OibR0=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=BHhGm1ivKzDXxW39urxXsDcW9o58WBEd2ZtYXSLxYBzqTWqWg/o0qAcjzaBsESXCA
         ORStYpUObPZCcUZQnn9becjxPhyYz50ZfF0IpmjyxxV0a3iq61jj8bSUMIMwKrIrfK
         Zfe3GXZuihe4NZTcFvf1bplfqLMhebGQDqWpovo5X4Dx0MoL0KL4UbEkn4x2hcv0PG
         BIB0Hy644SZUin9TgUF8p0HLDYki6ts+APQJ0diYsbAr9CPvoCM6TAyjdx182OtatO
         htMO9mBpeiT8zNtYe8lHHSBE7bvn7GSWXMtt5hDdgLQRI83NuLPhviSslMfvGGGYKj
         jzyWMuD+cGIkw==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, miaoqing@codeaurora.org,
        Jason Cooper <jason@lakedaemon.net>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ath9k: use hw_random API instead of directly dumping
 into random.c
In-Reply-To: <20220215162812.195716-1-Jason@zx2c4.com>
References: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
 <20220215162812.195716-1-Jason@zx2c4.com>
Date:   Wed, 16 Feb 2022 00:22:00 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o8374sx3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
>
> This compiles, but I have no hardware or other ability to determine
> whether it works. I'll leave further development up to the ath9k
> and hw_random maintainers.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
>  drivers/net/wireless/ath/ath9k/rng.c   | 62 +++++++++-----------------
>  2 files changed, 23 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
> index ef6f5ea06c1f..142f472903dc 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -1072,7 +1072,7 @@ struct ath_softc {
>=20=20
>  #ifdef CONFIG_ATH9K_HWRNG
>  	u32 rng_last;
> -	struct task_struct *rng_task;
> +	struct hwrng rng_ops;
>  #endif
>  };
>=20=20
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/=
ath/ath9k/rng.c
> index aae2bd3cac69..369b222908ba 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -22,9 +22,6 @@
>  #include "hw.h"
>  #include "ar9003_phy.h"
>=20=20
> -#define ATH9K_RNG_BUF_SIZE	320
> -#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */

So this comment says "quality: 10/32" but below you're setting "quality"
as 320. No idea what the units are supposed to be, but is this right?

>  static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
>=20=20
>  static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_s=
ize)

This function takes buf as a *u32, and interprets buf_size as a number
of u32s...

> @@ -72,61 +69,46 @@ static u32 ath9k_rng_delay_get(u32 fail_stats)
>  	return delay;
>  }
>=20=20
> -static int ath9k_rng_kthread(void *data)
> +static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool=
 wait)
>  {
> +	struct ath_softc *sc =3D container_of(rng, struct ath_softc, rng_ops);
>  	int bytes_read;
> -	struct ath_softc *sc =3D data;
> -	u32 *rng_buf;
> -	u32 delay, fail_stats =3D 0;
> -
> -	rng_buf =3D kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
> -	if (!rng_buf)
> -		goto out;
> -
> -	while (!kthread_should_stop()) {
> -		bytes_read =3D ath9k_rng_data_read(sc, rng_buf,
> -						 ATH9K_RNG_BUF_SIZE);
> -		if (unlikely(!bytes_read)) {
> -			delay =3D ath9k_rng_delay_get(++fail_stats);
> -			wait_event_interruptible_timeout(rng_queue,
> -							 kthread_should_stop(),
> -							 msecs_to_jiffies(delay));
> -			continue;
> -		}
> -
> -		fail_stats =3D 0;
> -
> -		/* sleep until entropy bits under write_wakeup_threshold */
> -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> -					   ATH9K_RNG_ENTROPY(bytes_read));
> -	}
> +	u32 fail_stats =3D 0;
>=20=20
> -	kfree(rng_buf);
> -out:
> -	sc->rng_task =3D NULL;
> +retry:
> +	bytes_read =3D ath9k_rng_data_read(sc, buf, max);

... but AFAICT here you're calling it with a buffer size from hw_random
that's in bytes?

-Toke
