Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BDE59C7C4
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiHVTCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbiHVTCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:02:17 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8657DF24
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:00:27 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-33387bf0c4aso319556927b3.11
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OMmHWzfC0HPfJq/zRf/0eIAeGwP5VagnSWZzuzw01l0=;
        b=WbMmQsGFR70ViCqNBjWEy1+8tkc5ksMw9h3bI3PTL5AzUNKvfZdgHGn8pNcHsnocyK
         oz8PdU5FE6MwUVpL732RY18y4BgMhZOywzjhSpmThnXlQN1bsth17Pp5uwjOTAnkE3S4
         ZVAUC7kpzMqYm7xM46RNWfbC6wHU+QMoFFKhme4Mx/DN4CQfYOpmVf+3xMB8QFLZR/DZ
         7a5EbmAh2ycCh/3HnhqkY46Rfs4c4XBarb03iXcU2YmZv8VQs9QFMmASm0eRTF/geZZQ
         6KmmVG0CtwDKDhVCNpCp3MF3Fi2uBsLvnUiIUKcSa4eC0AflMKMev3WLAvbuWIYl+7iq
         U2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OMmHWzfC0HPfJq/zRf/0eIAeGwP5VagnSWZzuzw01l0=;
        b=SOFmg/Nk4pV2L+Oetjm9zrksEDHcDwTGGdXWivG5N0fAihcnJlH8gp3LxmP3Heqktx
         /Y/k9gvEwQvP3uBjHPq6DWXBf7j/PRrNLFFujuUerJF+xfwGXsCVa/ywBGMZcwMnMkfk
         YafkJ6Mt/uTXuSWUSM833phzuXduMCaxffdwrQOdx+oTfqUJdYMPobkPTd2lXTAFRhFh
         qoYwiK3GVVytBmt6xWnr1G8UxjYtP3jkzFfRzz45iJtCT6vsrgu50hxcdXv5u5klDZ80
         Xz55Tk8iCoekV8539tv6jiCO5yn/dgfKHRiscJpBH4E5OFK3KCtF8NXBMgrtMJnrouGs
         0LzA==
X-Gm-Message-State: ACgBeo14Br+urrL3iSkWRhDZ81uKw6sq1zocQAaxeEDykij9R6EQg2UC
        H24b6YsuENbYr24buBnkK285uQw4eRrBVMaEO0jFGg==
X-Google-Smtp-Source: AA6agR572PLahP332nC1oGUrYY7cT/AT+FkjUtrAih9IXQO0eFRIKSmC7nEXSAx2qeh5XKNOtPZ2LBGdpODNp8RYWqg=
X-Received: by 2002:a25:880f:0:b0:67c:2727:7e3c with SMTP id
 c15-20020a25880f000000b0067c27277e3cmr21312902ybl.36.1661194823160; Mon, 22
 Aug 2022 12:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220818182653.38940-1-kuniyu@amazon.com> <20220818182653.38940-6-kuniyu@amazon.com>
In-Reply-To: <20220818182653.38940-6-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Aug 2022 12:00:11 -0700
Message-ID: <CANn89i+amoiCtNuGO6e1dx=9vfdfQSe09MZ7iRKQ+sdo6K=uzA@mail.gmail.com>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in ___ratelimit().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Thu, Aug 18, 2022 at 11:29 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While reading rs->interval and rs->burst, they can be changed
> concurrently.  Thus, we need to add READ_ONCE() to their readers.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  lib/ratelimit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/lib/ratelimit.c b/lib/ratelimit.c
> index e01a93f46f83..b59a1d3d0cc3 100644
> --- a/lib/ratelimit.c
> +++ b/lib/ratelimit.c
> @@ -26,10 +26,12 @@
>   */
>  int ___ratelimit(struct ratelimit_state *rs, const char *func)
>  {
> +       int interval = READ_ONCE(rs->interval);
> +       int burst = READ_ONCE(rs->burst);

I thought rs->interval and rs->burst were constants...

Can you point to the part where they are changed ?

Ideally such a patch should also add corresponding WRITE_ONCE(), and
comments to pair them,
 this would really help reviewing it.


>         unsigned long flags;
>         int ret;
>
> -       if (!rs->interval)
> +       if (!interval)
>                 return 1;
>
>         /*
> @@ -44,7 +46,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
>         if (!rs->begin)
>                 rs->begin = jiffies;
>
> -       if (time_is_before_jiffies(rs->begin + rs->interval)) {
> +       if (time_is_before_jiffies(rs->begin + interval)) {
>                 if (rs->missed) {
>                         if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
>                                 printk_deferred(KERN_WARNING
> @@ -56,7 +58,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
>                 rs->begin   = jiffies;
>                 rs->printed = 0;
>         }
> -       if (rs->burst && rs->burst > rs->printed) {
> +       if (burst && burst > rs->printed) {
>                 rs->printed++;
>                 ret = 1;
>         } else {
> --
> 2.30.2
>
