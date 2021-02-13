Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C9F31ADAD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBMTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMTH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:07:56 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20E2C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:07:16 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g20so1562044plo.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sf+i8UilWHuNdXhKLt5nECVc3QzpqeLib8z+MQ40yGo=;
        b=r5BghT7cju+thWZldWKo6FNlFXNaOZtlkHSzCmYehubf6MwUdltII6JXfaKwSokYUN
         pGWpTXL6bCcyBApYjfARy/xt59PK+M+JMwJ1OwL2e3tpXBbuw/Csy4i7uxy6pj+0mkaO
         gvqzK9tHoZ2HnkaUa/nlB1fjmZRXiZ/mpT5Dmdxtd/Lpxd1HCFaWxDQEoZ+/lIx48yNH
         ckk1o79N+5h+0Kbhg6ScXbyweRt4fqPNbp4Wt7H0vSsWdNaDig5te35usI2t2GlhUp4t
         Kgnu9tLYNkm6szotUg80qUfN9Qt//2cU0YGdQ5Wpsdqz60D/D/pdNM+a/27+qBMNLB72
         P1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sf+i8UilWHuNdXhKLt5nECVc3QzpqeLib8z+MQ40yGo=;
        b=JNrkJCZJn2le20F8bxEhwPObE2L5fZF3kwBZOtA+oU+jX+USqDSjHg8wSBc5S7QXMt
         LxA8N7x+eWpK2OHeDm/cisci2vvt5WUL0KRYJQy5yyuxn225T9tWJLDb8XQKfflHuLal
         UwkWw/11RBSvwlHt43e0tpPdJR8yZxxHgG4VFCqwt/1C/tD7qVSycyK5KCKxI1Mxpgn3
         d2IfgNSK2ZD0QYZO01C432CFJCHfqkU4QNk8++90PxKxF+wZapVMIpUFhK2NkV/Z/Sgh
         f6V5OUh/lxtMk1AFkaaWwx36cvxhoFuDnPoQLzzZyxGdHxCmvzWyXa69wNqyW5/VmVA2
         BCWA==
X-Gm-Message-State: AOAM530f441hneepcME9SUPydzQA2o/5JBaCNTaM8FUVkOTZ1JP6Qb5y
        2nsmFZycFI5Q65QSTgfiFta7l1rx7U8iOvVhGy8=
X-Google-Smtp-Source: ABdhPJza5tLVc5WgS+7OqIenW9D5Im1vP9h8QqL+LLQaZJP1p5hzVRNZeKbf4p52lyni8C9ZXrJLws7874DGT4mmXl0=
X-Received: by 2002:a17:902:c282:b029:e3:45a0:a8a6 with SMTP id
 i2-20020a170902c282b02900e345a0a8a6mr1350911pld.10.1613243236220; Sat, 13 Feb
 2021 11:07:16 -0800 (PST)
MIME-Version: 1.0
References: <20210213175102.28227-1-ap420073@gmail.com>
In-Reply-To: <20210213175102.28227-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Feb 2021 11:07:04 -0800
Message-ID: <CAM_iQpXLMk+4VuHr8WyLE1fxNV5hsN7JvA2PoDOmnZ4beJOH7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/7] mld: convert from timer to delayed work
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 9:51 AM Taehee Yoo <ap420073@gmail.com> wrote:
> -static void mld_dad_start_timer(struct inet6_dev *idev, unsigned long delay)
> +static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
>  {
>         unsigned long tv = prandom_u32() % delay;
>
> -       if (!mod_timer(&idev->mc_dad_timer, jiffies+tv+2))
> +       if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, msecs_to_jiffies(tv + 2)))

IIUC, before this patch 'delay' is in jiffies, after this patch it is in msecs?

[...]

> -static void mld_dad_timer_expire(struct timer_list *t)
> +static void mld_dad_work(struct work_struct *work)
>  {
> -       struct inet6_dev *idev = from_timer(idev, t, mc_dad_timer);
> +       struct inet6_dev *idev = container_of(to_delayed_work(work),
> +                                             struct inet6_dev,
> +                                             mc_dad_work);
>
> +       rtnl_lock();

Any reason why we need RTNL after converting the timer to
delayed work?

Thanks.
