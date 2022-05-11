Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3441152344E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243776AbiEKNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbiEKNeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:34:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFD214D7B5;
        Wed, 11 May 2022 06:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3855B823E6;
        Wed, 11 May 2022 13:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48793C34113;
        Wed, 11 May 2022 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652276073;
        bh=4NUdmq88v8DAbB7Vn40eqVC9dvLwvBx3ZTm5NvdS1lI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ptGl5zmLXOimnEN9XDeoridZtaiSiUjU68mS4DhfkCvTZXuARKEiJkBwbQUqCKcYA
         AaahO4sMKdvIZWm3i37K7F/HaJq2p/1OrOSTjHdY/NbUFU4HlHvlTcRh8vxUU6ngcP
         8QU5QFZELewgz4HMDUz44o5dLRzFin8IPdO//NONc1JmJRsNVQjflbU2gjShXvek0/
         gRtn8HdsXDLFv40Gbv2Vy4rxYbJophPrbQdYhsoX1AfmJkfaElmNjHNcfDhsYUmDT1
         e+0owWzk++VeOydD9U6fQdpjYi5fZNyaIFc2nmf33T9Iv9URQnXNoipqMm/xvXGxpF
         ZsXmklYGN0qKw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     netdev@vger.kernel.org, dianders@chromium.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3] ath10k: improve BDF search fallback strategy
References: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
Date:   Wed, 11 May 2022 16:34:26 +0300
In-Reply-To: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
        (Abhishek Kumar's message of "Mon, 9 May 2022 02:26:36 +0000")
Message-ID: <878rr86vml.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> Board data files wrapped inside board-2.bin files are
> identified based on a combination of bus architecture,
> chip-id, board-id or variants. Here is one such example
> of a BDF entry in board-2.bin file:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> It is possible for few platforms none of the combinations
> of bus,qmi-board,chip-id or variants match, e.g. if
> board-id is not programmed and thus reads board-id=0xff,
> there won't be any matching BDF to be found. In such
> situations, the wlan will fail to enumerate.
>
> Currently, to search for BDF, there are two fallback
> boardnames creates to search for BDFs in case the full BDF
> is not found. It is still possible that even the fallback
> boardnames do not match.
>
> As an improvement, search for BDF with full BDF combination
> and perform the fallback searches by stripping down the last
> elements until a BDF entry is found or none is found for all
> possible BDF combinations.e.g.
> Search for initial BDF first then followed by reduced BDF
> names as follows:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> bus=snoc,qmi-board-id=67,qmi-chip-id=320
> bus=snoc,qmi-board-id=67
> bus=snoc
> <No BDF found>
>
> Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
> Changes in v3:
> - As discussed, instead of adding support for default BDF in DT, added
> a method to drop the last elements from full BDF until a BDF is found.
> - Previous patch was "ath10k: search for default BDF name provided in DT"
>
>  drivers/net/wireless/ath/ath10k/core.c | 65 +++++++++++++-------------
>  1 file changed, 32 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 688177453b07..ebb0d2a02c28 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1426,15 +1426,31 @@ static int ath10k_core_search_bd(struct ath10k *ar,
>  	return ret;
>  }
>  
> +static bool ath10k_create_reduced_boardname(struct ath10k *ar, char *boardname)


"static int" as you use error values. Strange that the compiler doesn't
warn about that.

> +{
> +	/* Find last BDF element */
> +	char *last_field = strrchr(boardname, ',');
> +
> +	if (last_field) {
> +		/* Drop the last BDF element */
> +		last_field[0] = '\0';
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "boardname =%s\n", boardname);
> +		return 0;
> +	}
> +	return -ENODATA;

I would invert the check:

	if (!last_field)
        	return -ENODATA;

	/* Drop the last BDF element */
	last_field[0] = '\0';
	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot reduced boardname %s\n",
		   boardname);

	return 0;

Also I changed the style used in the debug message.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#debug_messages

>  	data += magic_len;
>  	len -= magic_len;
>  
> -	/* attempt to find boardname in the IE list */
> -	ret = ath10k_core_search_bd(ar, boardname, data, len);
> +	memcpy(temp_boardname, boardname, board_len);
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boardname :%s\n", boardname);

"boot boardname %s\n"

>  
> -	/* if we didn't find it and have a fallback name, try that */
> -	if (ret == -ENOENT && fallback_boardname1)
> -		ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
> +retry_search:
> +	/* attempt to find boardname in the IE list */
> +	ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
>  
> -	if (ret == -ENOENT && fallback_boardname2)
> -		ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
> +	/* If the full BDF entry was not found then drop the last element and
> +	 * recheck until a BDF is found or until all options are exhausted.
> +	 */
> +	if (ret == -ENOENT)
> +		if (!ath10k_create_reduced_boardname(ar, temp_boardname))
> +			goto retry_search;
>  
>  	if (ret == -ENOENT) {
>  		ath10k_err(ar,
>  			   "failed to fetch board data for %s from %s/%s\n",
> -			   boardname, ar->hw_params.fw.dir, filename);
> +			   temp_boardname, ar->hw_params.fw.dir, filename);
>  		ret = -ENODATA;
>  	}

This is hard to read, what about the loop below? Though I'm sure I
missed some corner case but I hope you get the idea. It's always good to
have a limit for the loops to avoid looping forever.

	for (i = 0; i < 20; i++) {
		/* attempt to find boardname in the IE list */
		ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
		if (ret != -ENOENT)
			/* found it or something was wrong */
			break;

		/* If the full BDF entry was not found then drop the last element and
		 * recheck until a BDF is found or until all options are exhausted.
		 */
		ret = ath10k_create_reduced_boardname(ar, temp_boardname);
		if (ret) {
			ath10k_err(ar,
				   "failed to fetch board data for %s from %s/%s\n",
				   temp_boardname, ar->hw_params.fw.dir, filename);
			ret = -ENODATA;
			break;
		}
	};

	if (ret)
		goto err;

        return 0;

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
