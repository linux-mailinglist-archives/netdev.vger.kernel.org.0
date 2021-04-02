Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370B35316A
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 01:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhDBXOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 19:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhDBXOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 19:14:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C3C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 16:14:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x126so4391436pfc.13
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 16:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZsyZk9IvHIAqMpcJYJIP4nUdkNXMybJEOoxIwNLPT2E=;
        b=EGjuPpB9N3vZrSA7imHaZrEhnS0oFx8tm4YGAAPxYclw2Y29FbW9rZ4Lp8MZadGlj9
         MNFl3eIUowUOzlMLgT2YTvLvpcN80TPXLkiVIEAM/89oCC/S8+5BEb4qyFqQBxU6bkBE
         nO2yxVxaWHZxeT/ux0ZTx8TEngsPkP1gmSizx73W4m4SGvu9FcXBENiKAXfM8wWMCDVG
         H2iL8vtLkNhhgenRAWNb9HN2KNQ84OV8kqC2RVu//eYHBeBSgeMYDYl40n8VOz7w6AxY
         3grrMrcykfF0QztNKAnD0jnKQQ43v44rqHrTchABgpDohQHtMcu6K3JhBiKezlKAYCsQ
         fOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZsyZk9IvHIAqMpcJYJIP4nUdkNXMybJEOoxIwNLPT2E=;
        b=NKijLPEjnd0LolHALQqZZ/b4dmKHLyf9Jvmh5g8+rMIp1v9VDehZ7ZJQ5EMWqiRTif
         DCTlkvyyv9zdLqh7P6dBjHGs+O77OosB9vIcZS20jao4JwcYLxmuaqLScpOik+rME842
         xNtSIkf4Ks3+JASIgVi0ygaJG7+4MCrrjyl3tIshYRKxI+OOQSJVlSpSSKZ/GOG/5BIe
         KyZvhnXqjKidpyf3UyYDJ6xU51cV1Bvj08d33h+HeMzG7Y3u9jcNfXHE2rNphc9GrWBI
         wKITT6doOBuTthYptDw3Xd5cLb0wbNXNJk/10DG+/6mjfsNIaFiwO7Ks8pz3cp0Y09tj
         ZFHw==
X-Gm-Message-State: AOAM530cUs0pxzUqh/buYtmdecEKB+rAW0V1yWPMPiqN3H3QT62V5rM9
        1GWt5bagxT0zYdIY1giFgqAqfx6W/X5MgX16mrg=
X-Google-Smtp-Source: ABdhPJy/28k3Z9K/0sjrXbC7Aa55cp/voWsi2z+CUaDoGfDen64GFRrOz+nBcgSAn7AZXI6G8FvEKJfGOxaToEz2GqU=
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr13694129pgu.18.1617405257456;
 Fri, 02 Apr 2021 16:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210331164012.28653-1-vladbu@nvidia.com> <20210331164012.28653-3-vladbu@nvidia.com>
In-Reply-To: <20210331164012.28653-3-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 16:14:06 -0700
Message-ID: <CAM_iQpXRfHQ=Hzhon=ggjPJGjfS1CCkM6iV8oJ3iHZiTpnJFmw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/4] net: sched: fix err handler in tcf_action_init()
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 9:41 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> With recent changes that separated action module load from action
> initialization tcf_action_init() function error handling code was modified
> to manually release the loaded modules if loading/initialization of any
> further action in same batch failed. For the case when all modules
> successfully loaded and some of the actions were initialized before one of
> them failed in init handler. In this case for all previous actions the
> module will be released twice by the error handler: First time by the loop
> that manually calls module_put() for all ops, and second time by the action
> destroy code that puts the module after destroying the action.

This is really strange. Isn't tc_action_load_ops() paired with module_put()
under 'err_mod'? And the one in tcf_action_destroy() paired with
tcf_action_init_1()? Is it the one below which causes the imbalance?

1038         /* module count goes up only when brand new policy is created
1039          * if it exists and is only bound to in a_o->init() then
1040          * ACT_P_CREATED is not returned (a zero is).
1041          */
1042         if (err != ACT_P_CREATED)
1043                 module_put(a_o->owner);
1044

Thanks.
