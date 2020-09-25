Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659EC279253
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgIYUig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgIYUif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:38:35 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91051C0613E3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 12:22:27 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z13so4069800iom.8
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 12:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+kALFykLu8zvTdOpO/UTtYd/UaYMq/ScljyGEcNrbU=;
        b=axuM5WDolCZR2+dKP+bs+LRg96uFMB5pjall6lNGGooT1nmGKEKojuE81gOeWE6Inv
         HU9o3ux5tIQU4w1cgx41UQnMJ0jwejY7MUl+FoI0I1FAzlFseRT3dfz3tBtC9Iyzkjmw
         PaI0rCJmLrJlfAKERSdp+X2o8l91wmG7Pgp5/7BXMagVYDeol3P7x2AchACOMZxG1sdz
         OkWUu5Six4amLiWPscEe12wVTs4VxlT5rCkp2cpxpGrv4CCjjmvdpvHl2vN2wNMDYnEZ
         EgRZXvPqZy3+enoX/JGpZfX1aOCozGY0KgK9LJmMt6PFk91qqrFOS6zyWZ6kqjFf33bT
         Ipqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+kALFykLu8zvTdOpO/UTtYd/UaYMq/ScljyGEcNrbU=;
        b=VZ2M3p01Bgr8tttQvUjeUaYPQ1Hlsx829sROt9v75JjET9h0z5AkxfL30fs6D1GDov
         lMVzXYnxpE5EY0KqkPXcpQ2Cncz3pw/ivZoBeFlgRW6Stiv0K6ffy75kXxK0Vh5vw5PX
         m9gwMM0QWAb8s65cr5ulv8V5TTLSLR6GeDGxclxRGGcHXjcoMz+IRt6SbJ2I9l9W1Bjg
         d5bosW2yUiQV5ND4HsMyypcGQwo/LOtj+ygJl/GFnMAQb/m65YTW5dN8DlXFVPMHrCC+
         oom2n53DG8QIB6Q0zq20Vk3t4YOLmtJ4xiCrGZ5h9gMOx/LRZg5Q1QvWuYmlHxFehxH9
         5VZg==
X-Gm-Message-State: AOAM532Vd2KnYG4csyA6JXJmBjehqL98VuotSSJ2j5o+xLDQTYfQcYiN
        x28bCfe7iwOZpAZahoQaGlcGSHUPypIFGU7VcRc=
X-Google-Smtp-Source: ABdhPJxRueJGpRVJvkgSvJhDw+aOR2qmh3ZTcDptcAYWkRXo+YE9tvhrKUte2u8Hijn1Vsx0nr5HgOHn6bOr/cXdU0I=
X-Received: by 2002:a02:b199:: with SMTP id t25mr482431jah.124.1601061746783;
 Fri, 25 Sep 2020 12:22:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
 <20200923035624.7307-2-xiyou.wangcong@gmail.com> <877dsh98wq.fsf@buslov.dev>
In-Reply-To: <877dsh98wq.fsf@buslov.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 25 Sep 2020 12:22:15 -0700
Message-ID: <CAM_iQpXy4GuHidnLAL+euBaNaJGju6KFXBZ67WS_Pws58sD6+g@mail.gmail.com>
Subject: Re: [Patch net 1/2] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 8:24 AM Vlad Buslov <vlad@buslov.dev> wrote:
> > +     if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> > +         !rcu_access_pointer(a->goto_chain)) {
> > +             tcf_action_destroy_1(a, bind);
> > +             NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> > +             return ERR_PTR(-EINVAL);
> > +     }
>
> I don't think calling tcf_action_destoy_1() is enough here. Since you
> moved this block before assigning cookie and releasing the module, you
> also need to release them manually in addition to destroying the action
> instance.
>

tcf_action_destoy_1() eventually calls free_tcf() which frees cookie and
tcf_action_destroy() which releases module refcnt.

What am I missing here?

Thanks.
