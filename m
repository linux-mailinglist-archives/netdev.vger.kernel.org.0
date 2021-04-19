Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47A9364A0B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 20:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhDSSrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 14:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDSSrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 14:47:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C47C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 11:46:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so20912930pjb.4
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 11:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2W3hW7XBSqb1wQiQ6WkVM9ufHMDcjOV6117CGoziVAM=;
        b=nwtr1CsYnhis3KOPuO378o7cC0FMtZHUyIY85iemQD/bdsIZInooElnGamuOoRKqHm
         bgL97zizk3j0xFWmHVgIQFwEScRLrKMIHtIapkd/Cf9L//4e8M8JiYwwMWjhCO9am25Q
         1VYpqQTGbTAuivkPcXVNsFzqW7H3ul63bd2+Trq8jsmAPzkhBJxzko+0f9TlKOv2tbLF
         gr9DZucSc95D5CJ+CR4YfayN6ZB5slsc2A8bGQDyhkxIJsnthkDUxyc4p52wk5xdtoft
         FrIpJlMn9RAvp0L8w+x5w/rtKSB0XjIStXw0Yccb3lRS/xrPKLdnRM1zXi/vQhfsArdP
         s/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2W3hW7XBSqb1wQiQ6WkVM9ufHMDcjOV6117CGoziVAM=;
        b=lYR948zu9RZ1ozub5HjWM8MYOBcwQhmnIiblHhK1Xa4LX3pQ5pj8t7SwXk8EM6wEfA
         RmXxfkLJmKTEkusUvN878kQPa9Vn8nq4Tdy50W7dHP3PwPgCrMxJg7HHgFATe4DJiB/9
         l1mb08QOPjgoE7STlzDQLhsb+4I/b7njO5gzsC9xbJ0DfHNQ5ahqQ6XL3p+M9djLLJhu
         n5okjbBd1c52cXz0/A+16nJ16YBk5evSpjnchtC6qSqChHSrhozSspwTni/O56FgX+2r
         VdtB+iTCpAfMnjzOgMR3vddVvyiruNsuxUfYzXSi0DqJ6lQfHRcPBiLSPTEAO4n0wxGV
         rLiA==
X-Gm-Message-State: AOAM5339yWLTs1xXJ3YjcaufIRLm1Q3pIWI5CLkHifAVUbZ9u0BrTegi
        6qXCuZgy98dzRTmB1n3kp5v7RodaBkuLgdyvPwE=
X-Google-Smtp-Source: ABdhPJzSK3E0waCZR9Lv029GJjib7T2bq2BYX5L5od0fjXBZf8JPqisgvMXMF/YZOGTYMoq26WPXmp3Q16HowNGh3LI=
X-Received: by 2002:a17:90a:f2ca:: with SMTP id gt10mr507273pjb.231.1618858011365;
 Mon, 19 Apr 2021 11:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618844973.git.dcaratti@redhat.com> <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
In-Reply-To: <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 19 Apr 2021 11:46:40 -0700
Message-ID: <CAM_iQpW3SPXJWeLf3Ck4QHZxetDuYcQJDFChUje3-4By8oGfnA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: sch_frag: fix stack OOB read while
 fragmenting IPv4 packets
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 8:24 AM Davide Caratti <dcaratti@redhat.com> wrote:
> diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> index e1e77d3fb6c0..8c06381391d6 100644
> --- a/net/sched/sch_frag.c
> +++ b/net/sched/sch_frag.c
> @@ -90,16 +90,16 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
>         }
>
>         if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> -               struct dst_entry sch_frag_dst;
> +               struct rtable sch_frag_rt = { 0 };

Is setting these fields 0 sufficient here? Because normally a struct table
is initialized by rt_dst_alloc() which sets several of them to non-zero,
notably, rt->rt_type and rt->rt_uncached.

Similar for the IPv6 part, which is initialized by rt6_info_init().

Thanks.
