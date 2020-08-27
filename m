Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756272548FE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgH0PSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgH0Lfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:35:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481CBC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:35:45 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e17so158573ils.10
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nk3XMsscwoEZw1pfmEYAb8eP1m4cERKtDNn3BOQ6wZo=;
        b=U/C0BJIItk4cpBQIKKHprsucVwFzLLWgqyxYVTuviqiRvJjFV00mPKgYgU/U7w4t9Q
         Y40T9K2BvdJWBQDj0tw6ewwLwDyW1ggK0A40/SxM6ZC0MKMxWAcf8PU1zP7NJ0DL7mwD
         mabdMS5DBW7DARO/TJRFwzlgPVu8S0VESQgV96hED2alyqd76GfOWzrgDjc3gWEb5N5f
         ZXoX2eU3bk3e00NNtglqOZOkh7D0oiLs7icsqPvxkUgCc0SrWpmEME3fJ2zGpsL7xeGb
         Os6qqgp8yE/vPgMSIJW3N5qhxl98XatED8SwbtCvliPqsXhjaCEIi87d3MLFeclXamQ9
         +NzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nk3XMsscwoEZw1pfmEYAb8eP1m4cERKtDNn3BOQ6wZo=;
        b=GDgkfWujauNsOtAySNR4KcyuenaHtd9N0lic54kePIFvtEazWEbdmdlwCgz5HAFh4k
         ClANb3u7LAan0wbqtdy/dixFBHaeW/7D6y0O/nDKgKNKIgV820mFeHheQ8lwLHa+nP7C
         4Nc+/8j3I3EhmO0yO6g7x7SqYVf8Hj72K9+Ym6clUSiE9MSDYJ2fokr4zbePKOMn31Wx
         +MEAvXaLinDcUmpt5RuBVcG6YHvGi5DChEtXlvOJkvr9rf+0wjkxDngcPveTBndzPuYe
         AschOiY2RuZzE73b8Tcv5A1qNtXf62SzywdgYOwUNoOk2zObYSFL6Yo32+zX05n+ZPWn
         gLDw==
X-Gm-Message-State: AOAM531ad1yRGcgsWcZ2bKMSggATxXk2FqeiU5OR9Aid86Txv0DvSn3p
        7mc2JxGu/jQjoKFE9XHVybly9lTsmay+GN8vcQCy5w==
X-Google-Smtp-Source: ABdhPJwxSXQ2/aSL9AbPqwXrgVZPAyH+csHxjYXsclhJT00Mv6s7Ff00Pw0g3zQXn7UCx/ACkT8asEAMiK59f/Wo/HY=
X-Received: by 2002:a92:bb0e:: with SMTP id w14mr15038915ili.68.1598528144077;
 Thu, 27 Aug 2020 04:35:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200827112922.48889-1-linmiaohe@huawei.com>
In-Reply-To: <20200827112922.48889-1-linmiaohe@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Aug 2020 04:35:32 -0700
Message-ID: <CANn89iK3CKrXPj5fNYys26zd8P67jz8GZEF2WjLD6Xw05SimcA@mail.gmail.com>
Subject: Re: [PATCH] net: Set trailer iff skb1 is the last one
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>, martin.varghese@nokia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 4:31 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> Set trailer iff skb1 is the skbuff where the tailbits space begins.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/core/skbuff.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 0b24aed04060..18ed56316e56 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4488,8 +4488,9 @@ int skb_cow_data(struct sk_buff *skb, int tailbits, struct sk_buff **trailer)
>                         skb1 = skb2;
>                 }
>                 elt++;
> -               *trailer = skb1;
>                 skb_p = &skb1->next;
> +               if (!*skb_p)
> +                       *trailer = skb1;
>

Why is adding a conditional test going to help ?

cpu will have hard time predicting this one, I doubt this kind of
change is a win.
