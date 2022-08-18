Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95692597ECF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbiHRGxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243362AbiHRGxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:53:37 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351EB2C668
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:53:36 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id a9so929603lfm.12
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0cqJMz/YmosmgebN4ExGphHB08hzwgY/qUgwwQnnku8=;
        b=P0q5kudDZ7e4q7AV0yS3k1cPKXKz5FDQA8Z1Q+dswik9CeVWOU3H730xfhoA0/Zvu6
         eElmNaJ90d556cTP/7m5EuJ0iOGFdoLvfpNFv9oINYpiErtANOkfZiv1iu7WwW3mVBlk
         epxeQyDpHzcQvyjDMuxYzQifk0uyjZXsulq01f2iEm8Ky/GQlGQTzdZJAgqwaUocmzpi
         DO0an5kbjHmWjV7p90HLfip2Gs3QJ5ZZNT3chEHW8jFDxfNGQz+ba5SShqaHuv9Y1gPx
         +OxzlZdWl/nEScA4aQXX6esZtbnUwdMYcG3Zsi6aVK57qOU42xRia0ihTW34zUUnziJu
         X6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0cqJMz/YmosmgebN4ExGphHB08hzwgY/qUgwwQnnku8=;
        b=vvtA4t6SASn1C6mppAF3DGPWW/RUc0VALPHrn/cnLbbfrRDTwO9WilcR4cxsQlv16g
         88RIP8mMtM+CPUWHsCDtf7eG6Qw1v1rNK0pWpBgIqpUrnRiz67e0iWO1VGZAcxItNfbt
         9fUs8uiDSKL/9qFszOaMezUbZXDx1MTFf811EqOFc3dwBHt0IfTokwosN+DqkQevMiq8
         0NlbzudcOet+ZJH1PeAy2232eNNzDKLSMrQfbKv536d8EJZv62CfdBTytG/Vm2NqH8sH
         7db9U9/nILpJgqdEja8B515vOwWp7oVzRbbhu+Ou4GaZDa5//cO189Ucbd3BbkfBextL
         MPlw==
X-Gm-Message-State: ACgBeo3wDnD9KGU4g/4291xp+EVAp6XydQPa/ei1q7dLxyW84NaJYe8B
        MGsNoAoxfMa3g6rM/NFpUKWm2ldzEdLaiwGRxKC+cAJRmzHvoA==
X-Google-Smtp-Source: AA6agR7LY6fiW/oClHetTzElQlppmWiUYrQxfSKE58i/tB6sftq5tPndbwxyX4ADCDrSen3W/VyJN6zaP7QzBy1ACNM=
X-Received: by 2002:a05:6512:250b:b0:48b:2c5:fe1e with SMTP id
 be11-20020a056512250b00b0048b02c5fe1emr571217lfb.598.1660805614381; Wed, 17
 Aug 2022 23:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220818035227.81567-1-kuniyu@amazon.com> <20220818035227.81567-17-kuniyu@amazon.com>
In-Reply-To: <20220818035227.81567-17-kuniyu@amazon.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 18 Aug 2022 08:53:23 +0200
Message-ID: <CACT4Y+YJZyfrea7VxHt3varEE0jqJn-d9jaNeE-NXSAXOfi8Ew@mail.gmail.com>
Subject: Re: [PATCH v2 net 16/17] net: Fix a data-race around netdev_unregister_timeout_secs.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Marco Elver <elver@google.com>
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

On Thu, 18 Aug 2022 at 05:57, Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While reading netdev_unregister_timeout_secs, it can be changed
> concurrently.  Thus, we need to add READ_ONCE() to its reader.
>
> Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> CC: Dmitry Vyukov <dvyukov@google.com>

Thanks, Kuniyuki.
RIght, since it is a sysctl it can be changed concurrently.

Acked-by: Dmitry Vyukov <dvyukov@google.com>


> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8221322d86db..56c8b0921c9f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10284,7 +10284,7 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
>                                 return dev;
>
>                 if (time_after(jiffies, warning_time +
> -                              netdev_unregister_timeout_secs * HZ)) {
> +                              READ_ONCE(netdev_unregister_timeout_secs) * HZ)) {
>                         list_for_each_entry(dev, list, todo_list) {
>                                 pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
>                                          dev->name, netdev_refcnt_read(dev));
> --
> 2.30.2
>
