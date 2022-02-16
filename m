Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB84B81A0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiBPHcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:32:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiBPHcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:32:35 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777BF12E16A;
        Tue, 15 Feb 2022 23:32:21 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id DD8062013FE;
        Wed, 16 Feb 2022 07:15:43 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id D322A807CC; Wed, 16 Feb 2022 08:15:25 +0100 (CET)
Date:   Wed, 16 Feb 2022 08:15:25 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     miaoqing@codeaurora.org, rsalvaterra@gmail.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2] ath9k: use hw_random API instead of directly dumping
 into random.c
Message-ID: <YgykjbhgdqeYyiY5@owl.dominikbrodowski.net>
References: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
 <20220216000230.22625-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216000230.22625-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, Feb 16, 2022 at 01:02:30AM +0100 schrieb Jason A. Donenfeld:
> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
> 
> This compiles, but I have no hardware or other ability to determine
> whether it works. I'll leave further development up to the ath9k
> and hw_random maintainers.
> 
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> v2 operates on whole words when possible.
> 
>  drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
>  drivers/net/wireless/ath/ath9k/rng.c   | 72 +++++++++++---------------
>  2 files changed, 30 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index ef6f5ea06c1f..142f472903dc 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -1072,7 +1072,7 @@ struct ath_softc {
>  
>  #ifdef CONFIG_ATH9K_HWRNG
>  	u32 rng_last;
> -	struct task_struct *rng_task;
> +	struct hwrng rng_ops;
>  #endif
>  };
>  
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
> index aae2bd3cac69..a0a58f8e08d3 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -22,11 +22,6 @@
>  #include "hw.h"
>  #include "ar9003_phy.h"
>  
> -#define ATH9K_RNG_BUF_SIZE	320
> -#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
> -
> -static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
> -
>  static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
>  {
>  	int i, j;
> @@ -72,61 +67,52 @@ static u32 ath9k_rng_delay_get(u32 fail_stats)
>  	return delay;
>  }
>  
> -static int ath9k_rng_kthread(void *data)
> +static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>  {
> -	int bytes_read;
> -	struct ath_softc *sc = data;
> -	u32 *rng_buf;
> -	u32 delay, fail_stats = 0;
> -
> -	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
> -	if (!rng_buf)
> -		goto out;
> -
> -	while (!kthread_should_stop()) {
> -		bytes_read = ath9k_rng_data_read(sc, rng_buf,
> -						 ATH9K_RNG_BUF_SIZE);
> -		if (unlikely(!bytes_read)) {
> -			delay = ath9k_rng_delay_get(++fail_stats);
> -			wait_event_interruptible_timeout(rng_queue,
> -							 kthread_should_stop(),
> -							 msecs_to_jiffies(delay));
> -			continue;
> -		}
> -
> -		fail_stats = 0;
> -
> -		/* sleep until entropy bits under write_wakeup_threshold */
> -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> -					   ATH9K_RNG_ENTROPY(bytes_read));
> +	struct ath_softc *sc = container_of(rng, struct ath_softc, rng_ops);
> +	int bytes_read = 0;
> +	u32 fail_stats = 0, word;
> +
> +retry:
> +	if (max & ~3UL)
> +		bytes_read = ath9k_rng_data_read(sc, buf, max >> 2);
> +	if ((max & 3UL) && ath9k_rng_data_read(sc, &word, 1)) {
> +		memcpy(buf + bytes_read, &word, max & 3);
> +		bytes_read += max & 3;
> +		memzero_explicit(&word, sizeof(word));
> +	}
> +	if (max && unlikely(!bytes_read) && wait) {
> +		msleep(ath9k_rng_delay_get(++fail_stats));
> +		goto retry;
>  	}

Potentially, this waits forever, if wait is set and no data is returned.
Instead, it should return to the main kthread loop every once in a while.

Thanks,
	Dominik
