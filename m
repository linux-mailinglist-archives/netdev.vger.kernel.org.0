Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C294249C3E4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 07:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiAZG44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 01:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiAZG44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 01:56:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12C6C061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:56:55 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx6so36689944ejb.0
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=t8hOeIp91qIAihHomDZFOV5h+fopZv1icntSUvmh1gI=;
        b=RGFGBymCwu0l/NBsyeMfQgzgJQNYpLDTxR/7RkPIekobVCqJdvE0sDmSmm5qUmRC6T
         0l75RtvvQOAENZKibU9bi3Fr/9T6ureFFHP9Xw7DD6QMmDwZ3umzuFdUImEdpQYq23C6
         sqGXK5Pk/gNVPdgC3XPhVTtQqj3j5m1UtCUP7Njl3a9Ww6AOC4S3hNTa2DkVygh1vZLy
         huMM2VWk/wmzpI5CrmpV67pSziASp2mJBfRKPsrIQgmd96FHYfHtRNWtU5ehuNN6ou3H
         Y/n10d9a5I7BSfYBfQjd5Vo2b8UdKiiww5V4tMg9BPXnq4dHegsC5UJy/8itpLvKt2al
         v+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=t8hOeIp91qIAihHomDZFOV5h+fopZv1icntSUvmh1gI=;
        b=UKR65At+AoD+qDg4A9R7KQp9S8AbiceqkZEJH7s/kZB3rkl6RLZY0Tyq8pmWFYRF+3
         JvYoR8pkBnakqencww9rmm//7EZ5ns4iGq13aZKDZd71pncVC3XuQpwdqpSM4XzcbykY
         cAdeD4T2jHpZKarv3ejYU7ikFQMufbQ+AsmuJsAirF0WdvFKn384nzkdIKU0WkEW+v/y
         cNTqm79m2+vz4EUNGb1KmUk7AQbYZSQK+prM1awQhm1kLGmdE96mUgUa76hINJSntGcO
         ekH9HeZM3dJUPwvYVGUmseQza6nvsSKCaqRuy0GyrxQa2TS7WOU4e8TcKKgL/4lev49m
         2Vhg==
X-Gm-Message-State: AOAM532YGzvAwh7Zd0bugAWLLEmWg7t7UJshFiTNqc8aVcmawxfY4Fwp
        EavQL9ZJjyhhbKVIG35ANqD2s8LS7apD0V5FOUB/Mw==
X-Received: by 2002:a17:906:4347:: with SMTP id z7mt16228580ejm.671.1643180214351;
 Tue, 25 Jan 2022 22:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20220113060235.546107-1-jaeman@google.com>
In-Reply-To: <20220113060235.546107-1-jaeman@google.com>
From:   JaeMan Park <jaeman@google.com>
Date:   Wed, 26 Jan 2022 15:56:43 +0900
Message-ID: <CA+9Zrq-=of09w0BhpwMeYGYK7dTJ=9evHO3KKr5MTLzV+eER3w@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alistair Delva <adelva@google.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Gentle ping on this patch.

On Thu, Jan 13, 2022 at 3:03 PM JaeMan Park <jaeman@google.com> wrote:
>
> In mac80211_hwsim, the probe_req frame is created and sent while
> scanning. It is sent with ieee80211_tx_info which is not initialized.
> Uninitialized ieee80211_tx_info can cause problems when using
> mac80211_hwsim with wmediumd. wmediumd checks the tx_rates field of
> ieee80211_tx_info and doesn't relay probe_req frame to other clients
> even if it is a broadcasting message.
>
> Call ieee80211_tx_prepare_skb() to initialize ieee80211_tx_info for
> the probe_req that is created by hw_scan_work in mac80211_hwsim.
>
> Signed-off-by: JaeMan Park <jaeman@google.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 0307a6677907..95f1e4899231 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2336,6 +2336,13 @@ static void hw_scan_work(struct work_struct *work)
>                         if (req->ie_len)
>                                 skb_put_data(probe, req->ie, req->ie_len);
>
> +                       if (!ieee80211_tx_prepare_skb(hwsim->hw,
> +                                                     hwsim->hw_scan_vif,
> +                                                     probe,
> +                                                     hwsim->tmp_chan->band,
> +                                                     NULL))
> +                               continue;
> +
>                         local_bh_disable();
>                         mac80211_hwsim_tx_frame(hwsim->hw, probe,
>                                                 hwsim->tmp_chan);
> --
> 2.34.1.703.g22d0c6ccf7-goog
>

Thanks,
JaeMan
