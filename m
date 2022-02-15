Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E638C4B7B6A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244887AbiBOXwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:52:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbiBOXwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:52:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C777B887BA;
        Tue, 15 Feb 2022 15:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75BABB81D4F;
        Tue, 15 Feb 2022 23:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1541C340F0;
        Tue, 15 Feb 2022 23:52:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BRfZKOGi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644969138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMm9EAolxAtPMXh1X1nKAXKitpaKoxPDLSCUjxHh4ks=;
        b=BRfZKOGi1a2g1iAFygTGRfQSBpQItd4ogiJv2CsIHInjzDvjY1hkTOyr/rknIKu4ucizQV
        Rc5KH/CEOeLhOCtpcaLxU2rEicJ7G1oUN2sd48JJ2Ywiq6y0ZdHF+13zTe8/j5Qv8OJQx5
        2p58pO4Ue2jxJS9jzl86tivW5ZcDubQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a124aa7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 15 Feb 2022 23:52:18 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id l125so987501ybl.4;
        Tue, 15 Feb 2022 15:52:16 -0800 (PST)
X-Gm-Message-State: AOAM532tWilof7TOfYIKyW6mggPsSqlsZAakWIkMPtT4Hw4KLXAOlghH
        1pJjYmW7z8zWCUq5+x0/vDVsZ0LjqHlOKl3a6eE=
X-Google-Smtp-Source: ABdhPJyZNoC98Q81CRhjYyC9iywczoAHqV6JDC3RmYMvG7wWiGpeJ+1knd618Ptg+zK7xD23lTHpW08gYGl69nXWKQw=
X-Received: by 2002:a81:7d04:0:b0:2d0:d0e2:126f with SMTP id
 y4-20020a817d04000000b002d0d0e2126fmr126329ywc.485.1644969136220; Tue, 15 Feb
 2022 15:52:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:88a:b0:15e:9450:8ed4 with HTTP; Tue, 15 Feb 2022
 15:52:15 -0800 (PST)
In-Reply-To: <87o8374sx3.fsf@toke.dk>
References: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
 <20220215162812.195716-1-Jason@zx2c4.com> <87o8374sx3.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 16 Feb 2022 00:52:15 +0100
X-Gmail-Original-Message-ID: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
Message-ID: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: use hw_random API instead of directly dumping into random.c
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     miaoqing@codeaurora.org, rsalvaterra@gmail.com,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
>> Hardware random number generators are supposed to use the hw_random
>> framework. This commit turns ath9k's kthread-based design into a proper
>> hw_random driver.
>>
>> This compiles, but I have no hardware or other ability to determine
>> whether it works. I'll leave further development up to the ath9k
>> and hw_random maintainers.
>>
>> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> Cc: Kalle Valo <kvalo@kernel.org>
>> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
>>  drivers/net/wireless/ath/ath9k/rng.c   | 62 +++++++++-----------------
>>  2 files changed, 23 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h
>> b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index ef6f5ea06c1f..142f472903dc 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -1072,7 +1072,7 @@ struct ath_softc {
>>
>>  #ifdef CONFIG_ATH9K_HWRNG
>>  	u32 rng_last;
>> -	struct task_struct *rng_task;
>> +	struct hwrng rng_ops;
>>  #endif
>>  };
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rng.c
>> b/drivers/net/wireless/ath/ath9k/rng.c
>> index aae2bd3cac69..369b222908ba 100644
>> --- a/drivers/net/wireless/ath/ath9k/rng.c
>> +++ b/drivers/net/wireless/ath/ath9k/rng.c
>> @@ -22,9 +22,6 @@
>>  #include "hw.h"
>>  #include "ar9003_phy.h"
>>
>> -#define ATH9K_RNG_BUF_SIZE	320
>> -#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
>
> So this comment says "quality: 10/32" but below you're setting "quality"
> as 320. No idea what the units are supposed to be, but is this right?

I think the unit is supposed to be how many entropic bits there are
out of 1024 bits? These types of estimates are always BS, so keeping
it on the lower end as before seemed right. Herbert can jump in here
if he has a better idea; that's his jig.

>
>>  static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
>>
>>  static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32
>> buf_size)
>
> This function takes buf as a *u32, and interprets buf_size as a number
> of u32s...

Oh my... Nice catch. I'll send a v2 shortly. I wonder how this managed
to work for Rui.

>
>> @@ -72,61 +69,46 @@ static u32 ath9k_rng_delay_get(u32 fail_stats)
>>  	return delay;
>>  }
>>
>> -static int ath9k_rng_kthread(void *data)
>> +static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, boo=
l
>> wait)
>>  {
>> +	struct ath_softc *sc =3D container_of(rng, struct ath_softc, rng_ops);
>>  	int bytes_read;
>> -	struct ath_softc *sc =3D data;
>> -	u32 *rng_buf;
>> -	u32 delay, fail_stats =3D 0;
>> -
>> -	rng_buf =3D kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL)=
;
>> -	if (!rng_buf)
>> -		goto out;
>> -
>> -	while (!kthread_should_stop()) {
>> -		bytes_read =3D ath9k_rng_data_read(sc, rng_buf,
>> -						 ATH9K_RNG_BUF_SIZE);
>> -		if (unlikely(!bytes_read)) {
>> -			delay =3D ath9k_rng_delay_get(++fail_stats);
>> -			wait_event_interruptible_timeout(rng_queue,
>> -							 kthread_should_stop(),
>> -							 msecs_to_jiffies(delay));
>> -			continue;
>> -		}
>> -
>> -		fail_stats =3D 0;
>> -
>> -		/* sleep until entropy bits under write_wakeup_threshold */
>> -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
>> -					   ATH9K_RNG_ENTROPY(bytes_read));
>> -	}
>> +	u32 fail_stats =3D 0;
>>
>> -	kfree(rng_buf);
>> -out:
>> -	sc->rng_task =3D NULL;
>> +retry:
>> +	bytes_read =3D ath9k_rng_data_read(sc, buf, max);
>
> ... but AFAICT here you're calling it with a buffer size from hw_random
> that's in bytes?

V2 on its way. Rui - you may need to re-test...

Jason
