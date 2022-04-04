Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E084F4F1AA4
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379103AbiDDVSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379925AbiDDSXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:23:22 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F21122B20;
        Mon,  4 Apr 2022 11:21:26 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649096484; bh=SLo9d96mThar86dgaQcYX5QHm8tQkuqDH+jBwfpMzbI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=aWF3yN5E1EG5YjRBbEsUeRcqbRiOYTHkZ9dONDIoQqc+LuZqSWTWvU+fcoWY3KdZ5
         vPUwr6sugS5CjsDG+nVkDYCp1XvAZa7AzTsmXJm8x6j1yBBOhQgg4jxTtB5AdNmeEW
         Nk/3U1T776AwYYHFrX9RDoDQEkqom7Neh12ITsXxpTOtr2ZI20eaAaeT4HFz6/mlrB
         uOtQWxEplrTgaSoy/oTqMP4E96Xudy+6X2byJ9uHq1kOt4lJwbNkVgm2iOrayYGZFq
         ytGzGC6JaGqHlpkOVmYLuju4kGDcS9JE1dhNPkwd9VXbolkDfex+G13UfrycHbUi0C
         Z0web2oOgDHGg==
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v1 2/2] mac80211: minstrel_ht: fill all requested rates
In-Reply-To: <20220402153014.31332-2-ps.report@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
 <20220402153014.31332-2-ps.report@gmx.net>
Date:   Mon, 04 Apr 2022 20:21:24 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fsmseml7.fsf@toke.dk>
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

+Felix

Peter Seiderer <ps.report@gmx.net> writes:

> Fill all requested rates (in case of ath9k 4 rate slots are
> available, so fill all 4 instead of only 3), improves throughput in
> noisy environment.

How did you test this? Could you quantify the gains in throughput you saw?

-Toke

> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 9c6ace858107..cd6a0f153688 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -1436,17 +1436,17 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>  	/* Start with max_tp_rate[0] */
>  	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
>  
> -	if (mp->hw->max_rates >= 3) {
> -		/* At least 3 tx rates supported, use max_tp_rate[1] next */
> -		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[1]);
> -	}
> +	/* Fill up remaining, keep one entry for max_probe_rate */
> +	for (; i < (mp->hw->max_rates - 1); i++)
> +		minstrel_ht_set_rate(mp, mi, rates, i, mi->max_tp_rate[i]);
>  
> -	if (mp->hw->max_rates >= 2) {
> +	if (i < mp->hw->max_rates)
>  		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
> -	}
> +
> +	if (i < IEEE80211_TX_RATE_TABLE_SIZE)
> +		rates->rate[i].idx = -1;
>  
>  	mi->sta->max_rc_amsdu_len = minstrel_ht_get_max_amsdu_len(mi);
> -	rates->rate[i].idx = -1;
>  	rate_control_set_rates(mp->hw, mi->sta, rates);
>  }
>  
> -- 
> 2.35.1
