Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2CB2E2F02
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 20:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgLZT2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 14:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgLZT2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 14:28:12 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABABAC061757
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 11:27:32 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e2so3707130plt.12
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 11:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2TMl3fzs9k+afv29khceMblpkzC160nmj1p7zq/gTg8=;
        b=vQB9c6zAamWtaRIt6/c4QmkXn5WTqrWl6WBGgi+igV4muztacq2mMtN2CPL2XWC6A1
         6RxK4PSI0Fo53413erCymfj+hsskYmkXR+wB5d0e1YKZDtsU1GgEA7LVTrfF7ez0ikjK
         hhKHdyULrtD4T5fls+GONOpDl4PvktBt2VHS68HTbydDU6NXkv7VHgazR/guEj5uV23m
         2JDGwYwldED+3InMMVWFGzm7Fsnb6xgFWyqXszGUld4l4VC6IJo7jOIfP2SXn/WDOmJq
         kSPDvHo/7EugLwh3rnKsoXEh8KIEiYBXP36hS0W0gzCv2+QstqzYQqXCeALJk3WVRiPE
         r0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2TMl3fzs9k+afv29khceMblpkzC160nmj1p7zq/gTg8=;
        b=c8Wkxbo+67u46htUwa9GePjAPXtxZa34N3epyWy3IPhX2M6bwKiz+D9KKX6656flQl
         K3Fb/bPc+01lTQD9OUY2LGLxTlB+h+4qWDDN0Oj3eB2o1ISuBJLmXRJLzEc57xMpmuO9
         qH6UH4tHxGhBpyhOM6Y2QREevkvm++DjcDpjAbbfkjstyGFZPE2E40y67KVvqxliLaRZ
         tekKGjC3ENmWCHrE/79peBVMr1jCBuC1FtyiwbMOonpKQDW3MYl92xPItWc54oLMDEkh
         8b0QVchn8kKyan2lUlBzzxjxN1XETEhl3tURwIUoF5+0nRW+kn69VcX9+g3dXrMDXG/L
         Ti4Q==
X-Gm-Message-State: AOAM532fDCuZaUxoQgBLa7dC1bRU20wWUENS+uWk2k58x9lSSni7UbeM
        M3jMXSAtGy3wO/dVM6+Rs3r04OE4viH70EqOL8w=
X-Google-Smtp-Source: ABdhPJz+JT2Drmmq7aDDVvG4XhwkakxmRhZHVHHApddhNLYraCAp5F1xOgy3z1FawN4keYd25ta/bnqr/7ltuulsBnU=
X-Received: by 2002:a17:90a:6705:: with SMTP id n5mr13767483pjj.215.1609010851142;
 Sat, 26 Dec 2020 11:27:31 -0800 (PST)
MIME-Version: 1.0
References: <20201223165250.14505-1-ap420073@gmail.com>
In-Reply-To: <20201223165250.14505-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 26 Dec 2020 11:27:20 -0800
Message-ID: <CAM_iQpW_Mc4HzjtVt+AmfPYEJhafVmxwsW_ZVuLVvG0kRCAufg@mail.gmail.com>
Subject: Re: [PATCH net] mld: fix panic in mld_newpack()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 8:55 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> mld_newpack() doesn't allow to allocate high order page,
> just order-0 allocation is allowed.
> If headroom size is too large, a kernel panic could occur in skb_put().
...
> Allowing high order page allocation could fix this problem.
>
> Fixes: 72e09ad107e7 ("ipv6: avoid high order allocations")

So you just revert this commit which fixes another issue. ;)

How about changing timers to delayed works so that we can
make both sides happy? It is certainly much more work, but
looks worthy of it.

Thanks.
