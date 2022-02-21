Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1384D4BE30C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377591AbiBUOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:22:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242622AbiBUOWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:22:13 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FF52BCC
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:21:50 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2d641c31776so139653337b3.12
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atDu8sN+TpYcKKA5NkWLVDauHjOKFwz/V5VsM1hWZYU=;
        b=Lr0KdNST2P/OkxckOLwNOS+cPP4Ny8pDf8ZY+Mj1UIt9oX+J0nUIlaDq+OX4hPiYYu
         RXpZVEXScjjumqChVstT8HGE4CV1lELKCkDn8siNSMbEW5uElbdEV2+YTkbvhpdwGAwc
         IEGf5a3DDzIbSp2T9VvSKCsSZomKbVGCpMtWx/aQMHtixfvDbdJg013igLD5p/kFdWir
         qHk8REqPrLotcX7NK4dYIAfiaVpxIlduZQjyNEuoY1QR5TNNdKKEAkbEBpJf5mYCAmyj
         LQn5XbZIjM/76wi2CoYyap3IDO1npWNo/8sa0znnLIArTuPN2dabfAL+2KB7X2ipNjHV
         zy5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atDu8sN+TpYcKKA5NkWLVDauHjOKFwz/V5VsM1hWZYU=;
        b=zcOVKYoLwBG6Fqa6Rl3ZDudj/jpK7xlW47VoHZj958ZDgRbdXt+Wj2H2/ozlpOTVYh
         XrfVG+Ka8b+A5GfxyMxjnMpiDr6MEoB/bw1FOhww0uF/iWKSaCswA2km+ESimxsyL9mN
         jPDXNcxQtZd4+sywrh+0s7QwMt16onbjNDjlMFZLeGrvJvAuI8iqqkiKN1rUYdP3JGXN
         NHvUvPtNf/Cv/He+G+74IS0ExYp8PiJnyjJtHgqHCA3+7dVVPqedhcA2ojMWgGZ94QqI
         UUXzNK72wM9ICaH1tHozZ/Q62U6B6IggA2AHeb44p0Uig6aSZOascMEFHBYM23Y2a9gW
         LHmw==
X-Gm-Message-State: AOAM532cpvB1eTqB1zY2n59Fgx/qAiBIMd7Evit/QPAoscGiMIIhp1O+
        7F2Xs2vJwuDemonMnXeZ9nbDtDZx5frSNPe88CxcXw==
X-Google-Smtp-Source: ABdhPJwjOQfyqFX3P/Rh+L3tJ1j1cFuZnxVgo9EWJ89ZtFq5cecHlacW0gN6moYJAqzz3awrJYiHqjyvDmaSe1LYb18=
X-Received: by 2002:a81:91d2:0:b0:2d6:af3d:c93 with SMTP id
 i201-20020a8191d2000000b002d6af3d0c93mr17153564ywg.467.1645453309168; Mon, 21
 Feb 2022 06:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20220220041155.607637-1-eric.dumazet@gmail.com> <294021ae1fae426d868195be77b053bd66f31772.camel@redhat.com>
In-Reply-To: <294021ae1fae426d868195be77b053bd66f31772.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 06:21:38 -0800
Message-ID: <CANn89iJoBqcBLD8GbJhNYN2cKZiSC=vn4L9RCsNs2Nd4HHhu_A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 12:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Sat, 2022-02-19 at 20:11 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Another thing making netns dismantles potentially very slow is located
> > in gro_cells_destroy(),
> > whenever cleanup_net() has to remove a device using gro_cells framework.
> >
> > RTNL is not held at this stage, so synchronize_net()
> > is calling synchronize_rcu():
> >
> > netdev_run_todo()
> >  ip_tunnel_dev_free()
> >   gro_cells_destroy()
> >    synchronize_net()
> >     synchronize_rcu() // Ouch.
> >
> > This patch uses call_rcu(), and gave me a 25x performance improvement
> > in my tests.
> >
> > cleanup_net() is no longer blocked ~10 ms per synchronize_rcu()
> > call.
> >
> > In the case we could not allocate the memory needed to queue the
> > deferred free, use synchronize_rcu_expedited()
> >
> > v2: made percpu_free_defer_callback() static
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> I'm sorry for the late feedback. I'm wondering if you considered
> placing the 'defer' pointer inside 'gro_cells' and allocating it at
> gro_cells_init() init time?

I did consider this, but I chose not to risk changing structure
layouts and adding regression in fast paths,
with extra cache line misses.
