Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E952563E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358284AbiELUJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 16:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346127AbiELUJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 16:09:37 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4732725D8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:09:36 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef5380669cso69373867b3.9
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+RvotmzlXXJLUjxfnHqDPaXa716Ci6O256j8ra0+f68=;
        b=g0GsQlOvnxr8GQ9ath+D+MdVdAHaXyLhTt/CfZs6l7Ar6F5uYBhvWa/XylZxrFWxcQ
         1zhc0mGLTwT/0Gn4apeojjEtse3mcuj2qV12KNPqhgeW8H4kvbEaeAEmZYV+3CBBvbbD
         0a0AxJRm/bKaYOrnj19ALFto28G04rrbhQHNnrDGJJAAHE4ublazO9V9zqlX6PYJqXBk
         V5sixDdKEnFlkmi5J3oOHMhQauKmGdn5wIgz2y4L1g1cH7P0rdoOKpiN0dH2W5UDJx5K
         PVnQKhYAKKkZDtE9JtOKWryEJqgiXLqnChGzmoY4VI1E5YBSF4P5bNDO3EZ8kLu2sv0o
         iWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+RvotmzlXXJLUjxfnHqDPaXa716Ci6O256j8ra0+f68=;
        b=PjHcEi3Zy5fwjsV/3gPeG+vhJEogkcsmBJpHE4eHr09Z4TTUWJbwkRAJsimeuRzOey
         lQWQoa6f/4Sr0BvJAwhgAczkZ0OP7X1qVUELvWcn4493CZyXM78S4owJ3KuFpElMHVgZ
         cD/MBSA42kta/K4qE51jOb9neT31C8HD2m13tpiWQLAvUiGeWMs2ugz+I3lkSmoEO7gp
         2Lsq1lEjgfKUTjcrsdJ2N7kGDHFye4cdheGLgSxUlc5Wc82gdU3OEQbfciRRi6owt0y9
         98yYWqYvNB0Aeo6Q//E1q212SHVu/feZQlFqx98UMXO1sqSUPT07UBVO5QpDSBlF16bE
         41Tg==
X-Gm-Message-State: AOAM531Vx/AOybE+0v9E2erwkZ79oc2Pw6y7D+w+CJgirMvnOCmaXmfa
        arsCuykEmuvk9sLHPBEx8pP2/YrEBHPqKoFi167hOg==
X-Google-Smtp-Source: ABdhPJzHB6TV7hqi8N1J/X4kzAG33AMHh2DD3/6XgC/AEnve02kflDN19GN7MbWeOj6f4a1Ls/b+/1usqV+zqa2J4CM=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr1872082ywb.255.1652386175023; Thu, 12
 May 2022 13:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <93323bba-476e-f821-045c-9fe942143da9@gmail.com> <CANn89iKjt1wpGk1dqqnYYx3r9UzEc3rwNtvBQ1O2dVToY_7rBQ@mail.gmail.com>
In-Reply-To: <CANn89iKjt1wpGk1dqqnYYx3r9UzEc3rwNtvBQ1O2dVToY_7rBQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 13:09:23 -0700
Message-ID: <CANn89i+aLWGcBe=n2iRR4chvkpfBO_V7c1P9mqA3fBS59CzjUg@mail.gmail.com>
Subject: Re: BUG: TCP timewait sockets survive across namespace creation in net-next
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 11:13 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, May 12, 2022 at 11:01 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >
> > Hello,
> >
> > It appears that in recent net-next versions it is possible for sockets
> > in the timewait state to survive across namespace add/del. Timewait
> > sockets are inserted into a global hash and only the sock_net value is
> > compared when they are enumerated from interfaces like /proc/net/tcp and
> > inet_diag. Old TW sockets are not cleared after namespace delete and
> > namespaces are allocated from a slab and thus their pointers get reused
> > a lot, when that happens timewait sockets from an old namespace will
> > show up in the new one.
> >
> > This can be reproduced by establishing a TCP connection over a veth pair
> > between two namespaces, closing and then recreating those namespaces.
> > Old timewait sockets will be visible and it happens quite reliably,
> > often on the first iteration. I can try to provide a script for this.
> >
> > I can't point to specific bugs outside of tests that explicitly
> > enumerate timewait sockets but letting sk_net be a dangling pointer
> > seems very dangerous. It also violates the idea of network namespaces
> > being independent and isolated.
> >
> > This does not happen in 5.17, I bisected this behavior to commit
> > 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
> >
>
> Thanks for the report.
>
> I guess we will need to store the (struct net)->net_cookie to
> disambiguate the case
> where a new 'struct net' is reusing the same storage than an old one.

Oh well, too many changes would be needed.
I will send a revert, thanks.
