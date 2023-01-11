Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6EB6662CF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjAKSa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbjAKS2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:28:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9BF33D46;
        Wed, 11 Jan 2023 10:28:24 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 141so11163050pgc.0;
        Wed, 11 Jan 2023 10:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8rjvOq9k/F/pv9zTj8LqXw/+Mi7PQp9geFeWzmYvddk=;
        b=FeVvk402TAjY56JdUzGjDzoU4373hWMaJ094pEdCu3oCKpaH2Q7jIhMaOkx7KoBTB6
         27b8L0KHRC+P3y7kvNvv+/jZHMLk3Ss2omvFFs+L2gYtzj26dp6KCkcXlnGQ1EIR1FRA
         wcrQpHKdmBjlkyF+C+3v+l9h2bIA4uXl/NtjBUM2sTKUgDIQjGMak7gahl+qp80QKpty
         WVwri5g7DN6rkZxU6APSsLwZ5Vi6jj4B5kUg4PCDsQdE6IoVwZQnyFLvq46r5DgU/bMv
         kVYGsKOa4VgH4XeobBlXtZFL6tI2jCzNYk1wLwrqVKd+CAzgkhro6WhyeE8eQftwJex0
         XWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8rjvOq9k/F/pv9zTj8LqXw/+Mi7PQp9geFeWzmYvddk=;
        b=2qX5dxU0CyTzetdO9+sGw5R/yEsYZafJg7F4h42LO3BxaqRp41XdYf4B8As3UTkQt0
         ILMhXCDNcigKxzLLyzPSkKmKA9nQl6QtE0oGs40sYDr+rjr0GX6bl/Pt8RLDG4nXVBjy
         e7cnxJgPU8xc70ugIyd4D/9y7Ek3of4XkVLseBzPE4dKS2+OsWqhrlMQ4yGNP8qLOXQN
         ctY9dRTozUJfPdnAeIxXqILSzIaPgaHyzMEgLNNEgu+A/LHp9Lr+7Gg+20NugzUhZWuB
         f2iR2aaLgFbSP2iQrx43ClkU6CPvShxvmobSlasc7tUIVrSc7TcSkUhlOpUSUSM2eCbd
         M8OA==
X-Gm-Message-State: AFqh2krlQQ+Iyx4iLVA9wIqnlXXRbYTY3mvA0B4OzFQRqFhu/M/FUKnR
        1ks/aaLBVtQCZm5yb7xx/26u8V8H1ZR42BjVXZM=
X-Google-Smtp-Source: AMrXdXsupKyphg+l1fOb8zU8tlH21mgYWekT1TGxSqw9nNXfTa+63QlbOHLMDkDKdSYOEkFRkFpbagLx44WO597pGPQ=
X-Received: by 2002:a62:1853:0:b0:586:2b38:4927 with SMTP id
 80-20020a621853000000b005862b384927mr1624860pfy.53.1673461704120; Wed, 11 Jan
 2023 10:28:24 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UePq+Gg5mpvD7ag=ern9JN5JyAFv5RPc05Zn9jSh4W+0g@mail.gmail.com>
 <20230111175031.7049-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230111175031.7049-1-szymon.heidrich@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Jan 2023 10:28:12 -0800
Message-ID: <CAKgT0UeiFGyttyQg_yWHA5L6ZPy9W8__b6DFSQe0-CNnLEvY7w@mail.gmail.com>
Subject: Re: [PATCH v2] rndis_wlan: Prevent buffer overflow in rndis_query_oid
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     kvalo@kernel.org, jussi.kivilinna@iki.fi, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        greg@kroah.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 9:51 AM Szymon Heidrich
<szymon.heidrich@gmail.com> wrote:
>
> Since resplen and respoffs are signed integers sufficiently
> large values of unsigned int len and offset members of RNDIS
> response will result in negative values of prior variables.
> This may be utilized to bypass implemented security checks
> to either extract memory contents by manipulating offset or
> overflow the data buffer via memcpy by manipulating both
> offset and len.
>
> Additionally assure that sum of resplen and respoffs does not
> overflow so buffer boundaries are kept.
>
> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> ---
> V1 -> V2: Use size_t and min macro, fix netdev_dbg format
>
>  drivers/net/wireless/rndis_wlan.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index 82a7458e0..bf72e5fd3 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -696,8 +696,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
>                 struct rndis_query      *get;
>                 struct rndis_query_c    *get_c;
>         } u;
> -       int ret, buflen;
> -       int resplen, respoffs, copylen;
> +       int ret;
> +       size_t buflen, resplen, respoffs, copylen;
>
>         buflen = *len + sizeof(*u.get);
>         if (buflen < CONTROL_BUFFER_SIZE)
> @@ -732,22 +732,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
>
>                 if (respoffs > buflen) {
>                         /* Device returned data offset outside buffer, error. */
> -                       netdev_dbg(dev->net, "%s(%s): received invalid "
> -                               "data offset: %d > %d\n", __func__,
> -                               oid_to_string(oid), respoffs, buflen);
> +                       netdev_dbg(dev->net,
> +                                  "%s(%s): received invalid data offset: %zu > %zu\n",
> +                                  __func__, oid_to_string(oid), respoffs, buflen);
>
>                         ret = -EINVAL;
>                         goto exit_unlock;
>                 }
>
> -               if ((resplen + respoffs) > buflen) {
> -                       /* Device would have returned more data if buffer would
> -                        * have been big enough. Copy just the bits that we got.
> -                        */
> -                       copylen = buflen - respoffs;
> -               } else {
> -                       copylen = resplen;
> -               }
> +               copylen = min(resplen, buflen - respoffs);
>
>                 if (copylen > *len)
>                         copylen = *len;

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
