Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6B2548E2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgH0PPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgH0Lia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:38:30 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B315C06123A
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:37:20 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m23so5413328iol.8
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcg4TIxpS2XrDTWj8mS51Tf2vGitjPKgU895pVtnQkw=;
        b=SgvKEzvYUaEchSKyXnlDf9/rSQtJ8+7m+0GJkn97LKTQl5LEu9FPK9m43svxpmEfgt
         iH/oN1s764d2JTNj/xWEXaVNL2GB4vqgkruQ1yKEpPqo0ll0EXg+VvWLG5Tl53EbjGJw
         +OGgWYITwpB0yMLuSqdCB89dDAVwtP1BY+5CjKOb93e42M+8JUnLQcusWy6fNs59V4aj
         fd7LomJjV6nuXESt9E5JoDX4+oTnHpvJgRWMGzbDO0efG3Xp49x3kgCDbQ4mLt/wG/gf
         OWHDOiNvcZ2LxXvkoqrEFfIUTur/0rz60hcbbp+NYII6e87FUy2OcA34+YMh5WAjVxKN
         N/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcg4TIxpS2XrDTWj8mS51Tf2vGitjPKgU895pVtnQkw=;
        b=eTlRHqQsWnnX9YmnmvAU+yuca77wIMM/+uCE87YZnIb4OGcaP7Y3y3EC6NEuEzA2Nq
         OjVAHQsGVILSzb4Zc7yfYtZ7qEmohLQB3fMnOoGbUD0gzPWr8Rbwgi0Rpk5Acd2bTTwk
         1H90RCiIzENvKbuAt1TkNgHsAESYiDk1c5G2Qe3kzKd3XbRqzkF0/R6AwaWqTknhGDTm
         yXQjCE/VrZS9hOeUqCNAw4bdBhFDbkp7UiE8Es8lDbPFa9WslTNTZ7JJ2NOh6r8sK4WQ
         zIunew2BSWYGNK8ZOCBd2HfC8TGkEutUREJpIsY3rFXo/Fff+/4IpwR4Zl5y6YGm+YDc
         kJRw==
X-Gm-Message-State: AOAM532E5oZyEBw/2Div31ofROWCUfScqyAuI0TLsrjG5gBB4Oa6ldBa
        yuUqBW7zQjuDGVUu+Vw8Tw5W3RolzXQKSLollOFftw==
X-Google-Smtp-Source: ABdhPJw1N6sVjHVtii/hCb0grxGUljPwAXeuCDgAlkjVrpPoJ2ImTSGfKfLHTqtDw39I1tiyLzx6dfrl5d7CtzSMMnU=
X-Received: by 2002:a6b:7846:: with SMTP id h6mr16736497iop.145.1598528239275;
 Thu, 27 Aug 2020 04:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200827112342.44526-1-linmiaohe@huawei.com>
In-Reply-To: <20200827112342.44526-1-linmiaohe@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Aug 2020 04:37:08 -0700
Message-ID: <CANn89iJ7orDEWxdBJVYqhk+1WF2ZuRpzN_XOaPoGRrn2hWjGNQ@mail.gmail.com>
Subject: Re: [PATCH] net: exit immediately when off = 0 in skb_headers_offset_update()
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

On Thu, Aug 27, 2020 at 4:25 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> In the case of off = 0, skb_headers_offset_update() do nothing indeed.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/core/skbuff.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 18ed56316e56..f67f0da20a5b 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1459,6 +1459,8 @@ EXPORT_SYMBOL(skb_clone);
>
>  void skb_headers_offset_update(struct sk_buff *skb, int off)
>  {
> +       if (unlikely(off == 0))
> +               return;

If this is unlikely, I doubt adding a test is going to save anything.

This will instead add a conditional test for the 'likely' cases.
