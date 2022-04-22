Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDBF50BD8A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449848AbiDVQyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444743AbiDVQyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:54:00 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E1B5F276
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:51:06 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id w187so6145233ybe.2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHdEa0AM7c1klGjTytrkeORqkV+KNpxs2Yb9Rf4TjHQ=;
        b=BRuGoBRl9rTu7soddstswTTjKK41IP4rh4tGAMf+unqQ9LxfoQcOHi0tH5hpJct9TH
         I3JIBdEYQL6h5zdxYjgJ4Dp3EGSLfDBrb4FEQiKNeXJRHTnsgmN4ev8b29FaR3RWfaXO
         q1MzS8B8gRjl5zaiAENXOCve7LsrRqoNcD8D9a2cylNYjiWjIXNPfvje0VTCNEnn9uQe
         0XcmJW1IFP+mff9GJrLK4vEoHRQukcSkWQeuahmpuSFP8onx/sCaosy1+mTipqDzrL5b
         IOFsFhy2oVJ+qworGz/DB1gGQMPPDcDxmiL/RjNTq+M0PQyHeeF2IALgtJ3J7NyE1gJ2
         JmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHdEa0AM7c1klGjTytrkeORqkV+KNpxs2Yb9Rf4TjHQ=;
        b=Ky0CaOJ08CCoJBGn8/4Ai9Vqpt6fyhfSWiof192S0joyuCxVLOi0yBZJCR6OUabHeg
         /P/0MEiZ1UOzNo4keqYRKh8n5E+HgQLg9hgqxqBXweE5i7zhR2grl6SeSeGUkAP8zCbY
         qW9odXsg90bOLfbfjP6bc8sNnqaEIK7vO6OeVR1XDm2iCOA/pmoHRPJN1SreKPrij6Bk
         IFRAxoMYXRb5E/8kIrL8MYq+fc69ExUXwbjVnb7EI0Gim4lUTBnB9mLrx/BCRkUc5Mlt
         Q15utJNk4j43TXI6YM1bJxZ1+mW1cqMajNYJJcB18xnGkJpjT0UtUDVLljNVl4w5YGfI
         ju4g==
X-Gm-Message-State: AOAM530gyq8qI+rUktBugqttUzkpDXu7wRfryJPTqI2WF2fN3Bx4FptN
        rtgzD4ZHezoRfoMmdkY7XiGZ+FxHepju6i2HCnEiJg==
X-Google-Smtp-Source: ABdhPJxhX2XyONdRlnBhIncT3BAO/oTfG32YCtb15ee0Ga0VuN0Ym1C8VaQJNLDuBgA5Op8Tnl9cSCjhFUzmCAeptUE=
X-Received: by 2002:a25:7c05:0:b0:644:dec5:6d6e with SMTP id
 x5-20020a257c05000000b00644dec56d6emr5367140ybc.598.1650646265735; Fri, 22
 Apr 2022 09:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220421153920.3637792-1-eric.dumazet@gmail.com> <20220422094058.30f34bb4@kernel.org>
In-Reply-To: <20220422094058.30f34bb4@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 09:50:54 -0700
Message-ID: <CANn89iJ0FY9CMuD9DQFu9uiQvPpTr0nRwewWsTFpddXjZA0qqw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to per-cpu lists
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 9:41 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 21 Apr 2022 08:39:20 -0700 Eric Dumazet wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 84d78df60453955a8eaf05847f6e2145176a727a..2fe311447fae5e860eee95f6e8772926d4915e9f 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1080,6 +1080,7 @@ struct sk_buff {
> >               unsigned int    sender_cpu;
> >       };
> >  #endif
> > +     u16                     alloc_cpu;
> >  #ifdef CONFIG_NETWORK_SECMARK
> >       __u32           secmark;
> >  #endif
>
> nit: kdoc missing

Yep, I had this covered for v2 already, thanks.
