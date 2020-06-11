Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E301F60C2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 06:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgFKEOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 00:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgFKEOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 00:14:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6556AC08C5C1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 21:14:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p20so4788095iop.11
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 21:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zj9VxvbB8VWLp0Wz/IIXNIsMLGe5YSuqFWnlLPBGBws=;
        b=Z5Uhoj0R9XITPHQ1W7iAgXXIjRvM8PpsBvQ947ob/c6P8E+ka4nQmxw8cmtns+bVlM
         Lu/Lrwy+91iRul+w6EMKQtdBKqoWLxt+rPHzVjwN4wUzrKS3JmlbcgTjXbtyxcwCga0i
         H28cLRZ+PeiB2fjiSkh942NKQi7BaM1zSxaNRmavorDUpBLelq1LzdAEUjvpC9Huyafb
         dExkld2Z5nHBMUcUOWMYOTAqgXhenD5ug9uDvu10ujDwrfhevn78mk61xJ3Jj4IajWIj
         gxZNa2mNSPJl1tSnXkMKZPmMoqlMujoUeIvWUEHpGvWz+BDHl7woWn0NLRtgiV7rRGqI
         2niA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zj9VxvbB8VWLp0Wz/IIXNIsMLGe5YSuqFWnlLPBGBws=;
        b=GnvbnEF89OkQ9bCmvSm3s/Aqxf8b/XglS9IqCwNJSpQ2Sl/E+Cyv0hGaRjt+9NQcFo
         WFOQpsXDsVzI32JiQkrx+7xMjGktowXYabnAGBcgj1WtTAuMiK50OtL6s8YRs2ypNcCN
         7VURBhXCA2CYZ1i/uCUweBQxXEwPZgFEKElOisrYmudGvpDDtpwznQHcs6XMQMQ7IlpQ
         L0whmwZuWLzsPA2IzQmkt7mr2SC3saxyZZTr7EMhcd9DIQnAdLDDtKkORFvG/6cI3oAT
         8LNner+MiCjezhVI9ZIcgo9n4HLUCBCSdtGxiRpAOswnkttnmzrjJqh4rTbRJB77iUh+
         YsPg==
X-Gm-Message-State: AOAM531ZrmMz1+rcTynjjP+cs+tIOfcnsw8IziFgc0tFosL87WdjhTos
        DnfD/wkZ7eKJIur5DT4uxdtUt40LzRQRxBUSkJJoLWnJ
X-Google-Smtp-Source: ABdhPJxIXw4IFKpz0hg5f8wQatXIWvUnsTrwJ0umIN1B58UZ8fuvFXZnzj/85iDNN5gJJhS/7/2tqT5A0Hgk4R8YRtQ=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr6434875iol.85.1591848862205;
 Wed, 10 Jun 2020 21:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200603044910.27259-1-xiyou.wangcong@gmail.com> <20200610142700.GA2174714@splinter>
In-Reply-To: <20200610142700.GA2174714@splinter>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 10 Jun 2020 21:14:10 -0700
Message-ID: <CAM_iQpVU14ky_L7PqhyB3_OSPpbY5ZKLn=GonLU88GcN5fEoHw@mail.gmail.com>
Subject: Re: [Patch net v2] genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 7:27 AM Ido Schimmel <idosch@idosch.org> wrote:
> > @@ -548,7 +591,7 @@ static int genl_lock_done(struct netlink_callback *cb)
> >               rc = ops->done(cb);
> >               genl_unlock();
> >       }
> > -     genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
> > +     genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);
>
> Cong,
>
> This seems to result in a memory leak because 'info->attrs' is never
> freed in the non-parallel case.
>
> Both the parallel and non-parallel code paths call genl_start() which
> allocates the array, but the latter calls genl_lock_done() as its done()
> callback which never frees it.

Good catch! Looks like I should just revert the above chunk. The
last parameter of genl_family_rcv_msg_attrs_free() is just confusing,
genl_lock_done() is clearly not parallel at all..

I will take a deeper look and send out a patch tomorrow.

Thanks!
