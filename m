Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2474E1D93
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 20:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343596AbiCTTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiCTTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 15:19:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CA3197F82;
        Sun, 20 Mar 2022 12:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 431B9B80ED5;
        Sun, 20 Mar 2022 19:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8561C340E9;
        Sun, 20 Mar 2022 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647803864;
        bh=oi++sqHpy970rjHx2MPyghrhRFpFFwJWgU0dgktEACc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JTXSncTLdnPfqhbQqZV3b28t0zimaPbeWNZka5JU0+HIIiLIwJys0qOxL5JFGePn+
         6DXh1wqFQ/GhmfTbudeLx5Nb8NrsaCo0ouPXojWqJhIFPe+wNrTS90LFzacqvbD0ww
         hgPG0PWq/oteizEh0gh+bTQIxJmZTgzM5Jf5kp1WDKjgzC4MR5n6qAKiUPbN0B3BRA
         EMekDsdU9k4wUHPxAOvkQnCXHDa8rwyjBY/PXh41x/Es0h2zG7gKyBlv/SJIg5JK5O
         ZsbNAgTVAwg082X1BK7jcgHbpWiDJhDpu/pK/Ib5IRAPR2Xb1l7ykg0FX8N9OOz69u
         C1VLq0+v93ezw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Edmond Gagnon <egagnon@squareup.com>
Cc:     Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
References: <20220318195804.4169686-1-egagnon@squareup.com>
        <20220318195804.4169686-3-egagnon@squareup.com>
Date:   Sun, 20 Mar 2022 21:17:40 +0200
In-Reply-To: <20220318195804.4169686-3-egagnon@squareup.com> (Edmond Gagnon's
        message of "Fri, 18 Mar 2022 14:58:03 -0500")
Message-ID: <87lex4o2ln.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edmond Gagnon <egagnon@squareup.com> writes:

> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
> rate:
>
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 5200
>         RX: 4141 bytes (32 packets)
>         TX: 2082 bytes (15 packets)
>         signal: -77 dBm
>         rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>         tx bitrate: 6.0 MBit/s
>
>         bss flags:      short-slot-time
>         dtim period:    1
>         beacon int:     100
>
> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
> firmware message and reports it via ieee80211_tx_rate_update:
>
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:98:21 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 2412
>         RX: 440785 bytes (573 packets)
>         TX: 60526 bytes (571 packets)
>         signal: -64 dBm
>         rx bitrate: 72.2 MBit/s MCS 7 short GI
>         tx bitrate: 52.0 MBit/s MCS 5
>
>         bss flags:      short-preamble short-slot-time
>         dtim period:    1
>         beacon int:     100
>
> Tested on MSM8939 with WCN3680B running CNSS-PR-2-0-1-2-c1-00083 with
> 5.17, and verified by sniffing frames over the air with Wireshark to
> ensure the MCS indices match.
>
> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
> Reviewed-by: Benjamin Li <benl@squareup.com>

[...]

> +	// HT?
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_HT40))
> +		tx_rate->flags |= IEEE80211_TX_RC_MCS;
> +
> +	// VHT?
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_VHT20 | HAL_TX_RATE_VHT40 | HAL_TX_RATE_VHT80))
> +		tx_rate->flags |= IEEE80211_TX_RC_VHT_MCS;
> +
> +	// SGI / LGI?
> +	if (stats->tx_rate_flags & HAL_TX_RATE_SGI)
> +		tx_rate->flags |= IEEE80211_TX_RC_SHORT_GI;
> +
> +	// 40MHz?
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT40 | HAL_TX_RATE_VHT40))
> +		tx_rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
> +
> +	// 80MHz?
> +	if (stats->tx_rate_flags & HAL_TX_RATE_VHT80)
> +		tx_rate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;

No C++ comments, please. And IMHO the comments are not really providing
any extra value anyway.

https://www.kernel.org/doc/html/latest/process/coding-style.html

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
