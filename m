Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8243E129AD0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLWUWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:22:16 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:47060 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfLWUWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:22:16 -0500
Received: by mail-yb1-f194.google.com with SMTP id v15so7467265ybp.13
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDFlJ6P+g4b+jDzmVB/qZT12KJOS0KnTkxJi96umux0=;
        b=FASapm/qED3x966fkw6KoS20zulEb/B9kOs4j2zlw2cTJ05uCPy/YYCr/dci9ve7Mq
         u49xOrH4aM3QY9Yj7T1IF/f6NKFV7dsIqAGnOMzLwtxlYWaVK3XIh/1BbVcBqGHXRtQa
         42i/LDSd+xIahE+Lb72pm2GS8UwwZVtn8l+bG/ZlxGAbF9L4UY1J7+EiiKQ+Ur9f/9QI
         WrFz57Z2rJ6CUI2bRpwcVjhS6muSPT2oeGBCdPQTZXG5uF2YyEcUr2AumVsDSDAGzYxL
         zynIvQpCzyRJC2eiRaKl9jzZR8yfiI2HhvLcihe8TegNwXpQNQjFAasUrtmZCnBRkeip
         xy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDFlJ6P+g4b+jDzmVB/qZT12KJOS0KnTkxJi96umux0=;
        b=svGtjZ2E50oFy1cda9R3OJqH7e9x0AOw4AEjl1robDf/JVmTXRS6J3b7Lp/fq3twLt
         egs2klgnws7P8WqUQh1Yd/lewDR1zI2ER0aYVWkm0M7s3ipnihMVgBzUcnvJI5+63n3t
         TKA04fQrLDf2K5uP/Qx3WZC1zrMUYa4Uns2hQOqgNChNOFkA278kEx0F567hZbSrSN5F
         GgpFP0OtwChUoplCJ6N90EPjyMyuZytSMeOefkeA/wo4mU4s4p5EGRHBmXD1zAqwd+OW
         d8fmL9vu8NPDEVvSKvXhNJGDjH7YVkKm9WEI+GxSiq0hA5D1ChMth/VcfHWUndQYIG7L
         zW1g==
X-Gm-Message-State: APjAAAWheZI0xroB59B3jckx/0+nYR+2du0y2CVYhuD9pKrDRtBD8iAs
        N6g+3sm6WgWsf343ZHSR9kr5TwUW7O/3uxm6TxoFLg==
X-Google-Smtp-Source: APXvYqxsO/r1I6RHW4uvlgDZdL70Ef4yBQZpgMnu8yVenwdzL6Oh6FCB4kixBCzOXv02zxzVvbLm6pMtTgaArtdhyjQ=
X-Received: by 2002:a25:7ec7:: with SMTP id z190mr5062868ybc.364.1577132534672;
 Mon, 23 Dec 2019 12:22:14 -0800 (PST)
MIME-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com> <20191223202005.104713-6-edumazet@google.com>
In-Reply-To: <20191223202005.104713-6-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Dec 2019 12:22:03 -0800
Message-ID: <CANn89i+AS+YE1w9E9LxKsGtqgXW7uKjZv==MYFx9UwPSe-EM1g@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] tcp_cubic: make Hystart aware of pacing
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20 PM Eric Dumazet <edumazet@google.com> wrote:
>
> For years we disabled Hystart ACK train detection at Google
> because it was fooled by TCP pacing.
>
> ACK train detection uses a simple heuristic, detecting if
> we receive ACK past half the RTT, to exit slow start before
> hitting the bottleneck and experience massive drops.
>
>
...

> +                       threshold = ca->delay_min;
> +                       /* Hystart ack train triggers if we get ack past
> +                        * ca->delay_min/2.
> +                        * Pacing might have delayed packets up to RTT/2
> +                        * during slow start.
> +                        */
> +                       if ((sk->sk_pacing_status == SK_PACING_NONE) || (netdev_max_backlog & 1))
> +                               threshold >>= 1;

This is silly, last minute debug feature that I forgot to remove

Will send a V2 without it.
