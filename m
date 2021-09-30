Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0E541D29F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 07:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347559AbhI3FOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 01:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbhI3FOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 01:14:40 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BA9C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 22:12:58 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s64so7418568yba.11
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 22:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w3i3layfATvZ7ed3gEebInrowXC6puRzdP74r3UJlCE=;
        b=LumMryO27J0dCOFnJ3T+8HCW88TeMT8Y1l0WU20C8yVNKtoRvaeIXp4fdwmc8lplxs
         ExFKuEDi+rs2PUxpgEOBZAcY2o3XmOh5BehWRmZyrPx7RClpM/ESZ0bM+tQ57yY9WFTz
         KF16oNAdoj0ic/IMggNS46RpCGp1JaokqdVTELE7yDSGTWYgJ3z6vzvq6EGaxdbUMerU
         e8ig4odr04FamkFPI3kRjmVwTplhWEOA1Pj6IrahdMAP5k3NOrm7p4oJzdoXOiFhP46K
         uGSQpdF33BAhe9BfpLxiHykZE5NzETxRzB9tgqFn8poIg1O8agnZ9HUMDoFiIQ315ZqC
         ny6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3i3layfATvZ7ed3gEebInrowXC6puRzdP74r3UJlCE=;
        b=w95ZOLsbAn0rN0TRt+x/oTJ/JtSbDmi77gyFcm4wzkQIir0iw1StEO7c7yN5vvmdRq
         1giZegKUt0Bham3mE6HWdJ5Pz+4ysUn5LvUIYRFIICSFwycTeGKyK/6ThBk5Br6geXrP
         SuLlDXLc/oI8zp/Y2E/7AC4m+CZpjkmhTybd59khy0gVcbbWY8ESzg5znhfeyCMkFMIw
         OfNya9AdDmdFa7ndL+rKScdsxoUOwuClfG4thc+NppFvU9N2GZeri3/Vv7LcOfMCMWjP
         O6+YgMx3RFFPecXYJmuZIbJRiGuHXisPRzRs5YbJocFMFXNKLB//SIaZouy/7eJniE1x
         2JDw==
X-Gm-Message-State: AOAM533+21fB2vXI7hlHCTj8BAI+S3yMrCBPv81TijAiYalYqo4+w4P7
        JOPBqrx/gyI6Gi9nM4XVUxLRxpLISs3tcPzVWXU=
X-Google-Smtp-Source: ABdhPJyMzzzd3O2C5PBDcLmMBH3tMgz4AI79XTDSgMyzrhZaXg9hVZYkVTDmxRE7d4JFxOui4kfPfEC9pOfo+W3t+uE=
X-Received: by 2002:a25:ccd1:: with SMTP id l200mr4475558ybf.140.1632978777580;
 Wed, 29 Sep 2021 22:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210929150849.1051782-1-vladbu@nvidia.com>
In-Reply-To: <20210929150849.1051782-1-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 29 Sep 2021 22:12:46 -0700
Message-ID: <CAM_iQpWAn+-NKapaBfCHs9MfatzSLsAWv9RvjiCvn85fbxeezw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: flower: protect fl_walk() with rcu
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 8:09 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Patch that refactored fl_walk() to use idr_for_each_entry_continue_ul()
> also removed rcu protection of individual filters which causes following
> use-after-free when filter is deleted concurrently. Fix fl_walk() to obtain
> rcu read lock while iterating and taking the filter reference and temporary
> release the lock while calling arg->fn() callback that can sleep.
>
...
> Fixes: d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()")

I don't dig the history, but I think this bug is introduced by your commit
which makes cls_flower lockless. If we still had RTNL lock here, we
would not have this bug, right?

> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Other than the Fixes tag,

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
