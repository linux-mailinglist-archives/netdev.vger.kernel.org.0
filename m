Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AE0574744
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiGNIiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237483AbiGNIiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:38:18 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC8B3FA3F
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:38:00 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31c8a1e9e33so9925337b3.5
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OijWc6/zN7+oJw44OKbMxP70Rr2Fy33fyFndj1YTp2w=;
        b=eAVrmrs4YJUffyfHBU4akJYJp//HiI6yxd7W+aBm4OkaBxQbZPO3Y4GdKPe//6MSrP
         iM/l9jAkioiiNkThmgO2ubJ7kZZR09wFG4F9b5wS0UA/b3Ljam02GqAnlFK5JNDyXMed
         /7XHPP9QjlNyfCpuSXVV8j9RHaed78VG5nNev1JJK+nZk4WXoRVdENKz6anLwI9DJ0p6
         ZipbvZfMt9zERy8ljTtY6vZJF9qVp1QzgHTmVjD8rFHRrCihsZMdAj5Nry0gGWTKaCG5
         ntoDQeYKA+ihPIdZXaXafgoB0xTpMs6h6rnOje8FzIAr7TvqCacuO4nMIl9oaGf7ZwgJ
         /DdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OijWc6/zN7+oJw44OKbMxP70Rr2Fy33fyFndj1YTp2w=;
        b=pdjFXXI1/DQTiVxXGSxQM5Vj2pDu/BXi8Ac3BIFshol+tjDzv631Fjt2mej4jSqLof
         VJI0SMFzZQhATmilj5JG5gr3VOV6FyPvRAcKx2IQ865/QilqGwvGnWuWTQlUKjDCWAQj
         9K2JiS/Wf/YShnB4oB+DxWUdPdbnlELDYyauzK4Y/wudBBSPlrytuUN/xzHP/5k4VHI5
         Xqk9sUNaoRdmWHDZLkqiUyaJ8RLAY10iBmnOW3w5PQ4sQ/ndsJ/c5pzADUmUdHOPp3Ud
         Hu3zKLhtMyTE25ViBS/n99nIBzjJAw/pxPZ8CAk9ghPJOPIMm7q7Idun+XW+r3Yph+RW
         T7Qw==
X-Gm-Message-State: AJIora+KisLT9Agk1tVGN210RAakIs6SE52S/XTn0Agh+umtNVpkfH1V
        n4eE23NM4YuLmeiqTVXMxGOH35Y9opift6xZJ81hcw==
X-Google-Smtp-Source: AGRyM1sd2jEWh+VjyUEuIyeyBE2cFo3QVD7rPln4nwnP0s0LxVlNjBhuQ3ZR1urywd+ATP3o33bc2OHkkuxdZsDvU5A=
X-Received: by 2002:a0d:dbc3:0:b0:31d:f1e:7e8e with SMTP id
 d186-20020a0ddbc3000000b0031d0f1e7e8emr8530544ywe.180.1657787879527; Thu, 14
 Jul 2022 01:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220704084354.3556326-1-jeongik@google.com>
In-Reply-To: <20220704084354.3556326-1-jeongik@google.com>
From:   Jeongik Cha <jeongik@google.com>
Date:   Thu, 14 Jul 2022 17:37:48 +0900
Message-ID: <CAE7E4g=BGzup31AD5zAuZpoR2gMswJhuo67B7cV8=wHOY=Y+qA@mail.gmail.com>
Subject: Re: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending packet
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     adelva@google.com, kernel-team@android.com, jaeman@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 5:44 PM Jeongik Cha <jeongik@google.com> wrote:
>
> A pending packet uses a cookie as an unique key, but it can be duplicated
> because it didn't use atomic operators.
>
> And also, a pending packet can be null in hwsim_tx_info_frame_received_nl
> due to race condition with mac80211_hwsim_stop.
>
> For this,
>  * Use an atomic type and operator for a cookie
>  * Add a lock around the loop for pending packets
>
> Signed-off-by: Jeongik Cha <jeongik@google.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index c5bb97b381cf..ea006248ffcd 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -687,7 +687,7 @@ struct mac80211_hwsim_data {
>         bool ps_poll_pending;
>         struct dentry *debugfs;
>
> -       uintptr_t pending_cookie;
> +       atomic64_t pending_cookie;
>         struct sk_buff_head pending;    /* packets pending */
>         /*
>          * Only radios in the same group can communicate together (the
> @@ -1358,7 +1358,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
>         int i;
>         struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
>         struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
> -       uintptr_t cookie;
> +       u64 cookie;
>
>         if (data->ps != PS_DISABLED)
>                 hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> @@ -1427,8 +1427,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
>                 goto nla_put_failure;
>
>         /* We create a cookie to identify this skb */
> -       data->pending_cookie++;
> -       cookie = data->pending_cookie;
> +       cookie = (u64)atomic64_inc_return(&data->pending_cookie);
>         info->rate_driver_data[0] = (void *)cookie;
>         if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
>                 goto nla_put_failure;
> @@ -4178,6 +4177,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
>         const u8 *src;
>         unsigned int hwsim_flags;
>         int i;
> +       unsigned long flags;
>         bool found = false;
>
>         if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
> @@ -4205,18 +4205,20 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
>         }
>
>         /* look for the skb matching the cookie passed back from user */
> +       spin_lock_irqsave(&data2->pending.lock, flags);
>         skb_queue_walk_safe(&data2->pending, skb, tmp) {
>                 u64 skb_cookie;
>
>                 txi = IEEE80211_SKB_CB(skb);
> -               skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
> +               skb_cookie = (u64)txi->rate_driver_data[0];
>
>                 if (skb_cookie == ret_skb_cookie) {
> -                       skb_unlink(skb, &data2->pending);
> +                       __skb_unlink(skb, &data2->pending);
>                         found = true;
>                         break;
>                 }
>         }
> +       spin_unlock_irqrestore(&data2->pending.lock, flags);
>
>         /* not found */
>         if (!found)
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>

Hello Johannes!

It fixes kernel panics during a long test which uses mac80211_hwsim
driver. So I think it would be beneficial if we could merge this into
LTS branches. Could you share your opinion?

Thanks
Jeongik
