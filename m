Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B737530DD9
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiEWJdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiEWJdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:33:16 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9375E2CE2B;
        Mon, 23 May 2022 02:33:01 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1653298378; bh=r7ODPVj6x2gsa5QbwqlPiggXP448wOyeubePNwYD3vY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XI7u65Q5IrsMONypOC9KNGnQXTmv7ZuD5VquB2CveEYpinZd+ZbcimQPPjpF3drFS
         uEhgR27KEM344KWx28TaycZkw+vAki0aryIa8i3Kbi0gBaSIqBfkK6737c9/E7GZ//
         7upwYjRcs0qZV1jenoCJlmZu9nQMvhzIr3AY9HM3PHqROkbO0mP44Joq6kJNpCPM/p
         Laum3rnGicj957/fHYgKtX7ekMYMee96oGWwEa0OFGsNMj3g2ZkoVWyzFxWv8EreYc
         hC39/PTbCzRgsvdSPQWgeSThEOj76ViGbd8dd1J54BXfifU8F3TzC8awo6DkDdR8XZ
         CCg9uvGpfdgwg==
To:     Tom Rix <trix@redhat.com>, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: Re: [PATCH] ath9k: remove setting of 'is_ext' parameter
In-Reply-To: <20220521204725.2539952-1-trix@redhat.com>
References: <20220521204725.2539952-1-trix@redhat.com>
Date:   Mon, 23 May 2022 11:32:57 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qwkr3ue.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> writes:

> cppcheck reports
> [drivers/net/wireless/ath/ath9k/dfs.c:93]: (style) Assignment of function parameter has no effect outside the function.
>
> Both the is_ctl and the is_ext parameters are set in the if-else statement.
> But only is_ctl is used later, so setting is_ext is not needed and can be removed.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/dfs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> index acb9602aa464..47cdfb584eb0 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -89,8 +89,6 @@ static int ath9k_get_max_index_ht40(struct ath9k_dfs_fft_40 *fft,
>  			int mag_upper = fft_max_magnitude(fft->upper_bins);
>  			if (mag_upper > mag_lower)
>  				is_ctl = false;
> -			else
> -				is_ext = false;

Hmm, not so sure about this; while the assignment is technically
useless, I think it makes the intent of the code clearer (i.e.,
disambiguating between is_ctl or is_ext; upon exiting that block is_ctl
or is_ext will always be false(...

-Toke
