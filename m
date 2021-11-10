Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C544C8F4
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhKJT1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhKJT1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:27:42 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D48BC061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 11:24:54 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u18so5843100wrg.5
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 11:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgxxmvGeWBqoVVWm+aT8y1AIFogI9R6xV+DgrB/wQzg=;
        b=iybUjt6NruXZ+ansxh33A5/V/Kjub9Ad/KI+A8G1/mu2HhjLxBemhQ/PqkuNtDN3Qo
         mWIeyHoxFSDcSgRYjZ1ST+cVXoQKdv0Pzqfm+a/6/HcfyjrRlQzTVrenX7pFKQR7bmR0
         bdcIg5ZGPsGgRxo/cRYuseMzYyUPXpBAuseJRLwyZrX1JR9qxC+o8WK19GM3Kvl6fg+L
         ix+6IsKFXrrJE18EnuwzRbZcc1Trt1KELfyTTHARMAFQWLAgwiURgi8Y3X2wHm9CCghO
         ZhpL9sZhrWfR5U2gb8cqLb9CiJgGEUhTbwFvzR6Z0hXr1eGR091KNwJgPkoyZFQtQafa
         +ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgxxmvGeWBqoVVWm+aT8y1AIFogI9R6xV+DgrB/wQzg=;
        b=rXL57MrXPvWQWSlwfdqHEL36z4796AesDZAma2XI1XqUfnaOA2vvlqC8W+72FT5Rl0
         Lw030T7RY7Qz30LA2ptZpF7asRxfWdUOKSOqCDezrnknwCHaCBgf5xaR42h8Q/vu+bYB
         1ECVAuyHaxY7ZEzm9q6ZRBk/zdX2uffrV1DQ/DJmTeqGMcuODBueOLK67sXCFna0UWL0
         NJy1c09idI36jrBzjk1B/sEs0ZiKOGELEBL+i82fvjX9ruCoD/5ScqZufFBpiANdjxSr
         /9piZfhkQLd0VVCDTSZLXadnUvq1IsSZaUy+notGQtKHOukT5j/8PU4QF/JrB8j9Q4DT
         WxDw==
X-Gm-Message-State: AOAM532kZnodMg1J5BvW0dmRyfGzedzsUrpkKBORwUqwDwaxGXlx5bLm
        SDDo7skGw2cSaPYzCtW/rDGs88/M44XUoU7xmVT1tA==
X-Google-Smtp-Source: ABdhPJyu7rmRJdHQ2mxXsdvx5G3j1bwvAoiFZVmhi+qE5EZUPDk/1xRxjliTsllaG3LdOf8V3w4b2AJtPUipHLS9ja0=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr1798212wry.279.1636572292501;
 Wed, 10 Nov 2021 11:24:52 -0800 (PST)
MIME-Version: 1.0
References: <20211110191126.1214-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211110191126.1214-1-alexandr.lobakin@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 10 Nov 2021 11:24:39 -0800
Message-ID: <CANn89i+ZH83K9V7-7D6egC5AF=hxBv8FL+rroEqOskB-+TLZCA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix premature exit from NAPI state polling in napi_disable()
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:11 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> Commit 719c57197010 ("net: make napi_disable() symmetric with
> enable") accidentally introduced a bug sometimes leading to a kernel
> BUG when bringing an iface up/down under heavy traffic load.
>
> Prior to this commit, napi_disable() was polling n->state until
> none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
> always flip them. Now there's a possibility to get away with the
> NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
> call with an unitialized variable, rather than straight to
> another round of the state check.
>
> Error path looks like:
>
> napi_disable():
> unsigned long val, new; /* new is uninitialized */
>
> do {
>         val = READ_ONCE(n->state); /* NAPIF_STATE_NPSVC and/or
>                                       NAPIF_STATE_SCHED is set */
>         if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) { /* true */
>                 usleep_range(20, 200);
>                 continue; /* go straight to the condition check */
>         }
>         new = val | <...>
> } while (cmpxchg(&n->state, val, new) != val); /* state == val, cmpxchg()
>                                                   writes garbage */
>
> napi_enable():
> do {
>         val = READ_ONCE(n->state);
>         BUG_ON(!test_bit(NAPI_STATE_SCHED, &val)); /* 50/50 boom */
> <...>
>
> while the typical BUG splat is like:
>
> [
> Fix this by replacing this 'continue' with a goto to the beginning
> of the loop body to restore the original behaviour.
> This could be written without a goto, but would look uglier and
> require one more indent level.
>
> Fixes: 719c57197010 ("net: make napi_disable() symmetric with enable")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  net/core/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index edeb811c454e..5e101c53b9de 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6929,10 +6929,11 @@ void napi_disable(struct napi_struct *n)
>         set_bit(NAPI_STATE_DISABLE, &n->state);
>
>         do {
> +retry:
>                 val = READ_ONCE(n->state);
>                 if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
>                         usleep_range(20, 200);
> -                       continue;
> +                       goto retry;
>                 }
>
>                 new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
> --
> 2.33.1
>

Good catch !

What about replacing the error prone do {...} while (cmpxchg(..)) by
something less confusing ?

This way, no need for a label.

diff --git a/net/core/dev.c b/net/core/dev.c
index 5e37d6809317fb3c54686188a908bfcb0bfccdab..9327141892cdaaf0282e082e0c6746abae0f12a7
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6264,7 +6264,7 @@ void napi_disable(struct napi_struct *n)
        might_sleep();
        set_bit(NAPI_STATE_DISABLE, &n->state);

-       do {
+       for (;;) {
                val = READ_ONCE(n->state);
                if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
                        usleep_range(20, 200);
@@ -6273,7 +6273,9 @@ void napi_disable(struct napi_struct *n)

                new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
                new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
-       } while (cmpxchg(&n->state, val, new) != val);
+               if (cmpxchg(&n->state, val, new) == val)
+                       break;
+       }

        hrtimer_cancel(&n->timer);
