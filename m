Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54FF4B8059
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 06:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344626AbiBPFig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 00:38:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBPFif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 00:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A7B8236;
        Tue, 15 Feb 2022 21:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F829619FC;
        Wed, 16 Feb 2022 05:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5EEC340E8;
        Wed, 16 Feb 2022 05:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644989902;
        bh=P7No01mWTKTK8n7XDrHDJxfmk9w1GcNv6CSOAUyAhM8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cJ7R+z9PZat/2UJpKAXS/9gITtDX2by/uEFgAoBc8g/SB1OnjJ1uNI1qHGadq8LRX
         N0u/xHxg1x+aG2v+u2LtlSFP+FMEidRMdgjtPYcOwjDMKr6xOz9aKxBqc/eJZsc2HS
         b1nYfY/JZhz1+TZMTJczVQVvjTSEysQiwXlnqVRmQbR6qNwC29RKXYq0FBGi+M369I
         q8nkO6ZfQahcclabOmzoWFL9upUirIkNjhpmNZQWQ83nlsL6P2Qs77oWpBOK4IcWtR
         Cjx0UNmbZcBwasm1dsIBd8Kxhwm9WDuOVURK9kq0I7jFrsbm3UGRFrvhHZOx36NaNR
         7TSEzEZfU/ouQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     miaoqing@codeaurora.org, rsalvaterra@gmail.com,
        Toke =?utf-8?Q?H?= =?utf-8?Q?=C3=B8iland-J=C3=B8rgensen?= 
        <toke@toke.dk>, "Sepehrdad\, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2] ath9k: use hw_random API instead of directly dumping into random.c
References: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
        <20220216000230.22625-1-Jason@zx2c4.com>
Date:   Wed, 16 Feb 2022 07:38:17 +0200
In-Reply-To: <20220216000230.22625-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Wed, 16 Feb 2022 01:02:30 +0100")
Message-ID: <87mtir9xrq.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

[...]

> +retry:
> +	if (max & ~3UL)
> +		bytes_read =3D ath9k_rng_data_read(sc, buf, max >> 2);
> +	if ((max & 3UL) && ath9k_rng_data_read(sc, &word, 1)) {
> +		memcpy(buf + bytes_read, &word, max & 3);
> +		bytes_read +=3D max & 3;
> +		memzero_explicit(&word, sizeof(word));
> +	}
> +	if (max && unlikely(!bytes_read) && wait) {
> +		msleep(ath9k_rng_delay_get(++fail_stats));
> +		goto retry;
>  	}

Wouldn't a while loop be cleaner? With a some kind limit for the number
of loops, to avoid a neverending loop.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
