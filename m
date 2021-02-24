Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C78324559
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhBXUia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbhBXUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:38:29 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B7C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:37:48 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n195so3147743ybg.9
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y9XGk7/ZoBQO+Ly+LdCW6O0PUmKEvy1HIXDj0pDr5Eg=;
        b=JjnJshEckk7Fqcna3azdNPHmLRucAtAbM7k1s08Rrgl7GWlXouVo7Mpmd0zR8w561M
         IPtsGDO3QfjEbH302WQwHgralc1zbdTOs59NExt77jMHGWobuqBpXHQgOQKKRIibuKd5
         gDfCqi4yUds2Z+syVf+z466OOKHT6kW3hna0ZbopAyqQEvgqrwL/h4swGGf6+LSsz9ha
         6CGvUrNokODBklcEGb7UgJ5IL0zYw4onYWcBTQcB8Eg/OoR2oTTFzUwrQXV99krKXjZf
         SyUOCV+7+hCgEt+1mB0m1VlwDopOhNbHdNMTZO2T31ytmfCRDfL/3Sfdr2hTregr4F3t
         mapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y9XGk7/ZoBQO+Ly+LdCW6O0PUmKEvy1HIXDj0pDr5Eg=;
        b=r5vnOSNQqNupScpVclSIC28cJMZMbd5QQov5sy5iadBGr2yb7z/MLu5fgR12G7wP/w
         fjCJzLHMDHMM7IPEtZZlSeOcj1p9R7CzRsR53BCREaEBXZv8+jcp2d3mOBxAjVA3bVdQ
         DE6xobQy1zTUI5x4uCz8V+7szKwZ3UARFNzbSG+79FUzv1lehm3cMl+3YT5LxtkSZDdw
         0gTGArTK4R9tmZ+MYqq4usTVqxE/8ZEKoJjovc+/uvgVRQiZEbo7iHuVe+a/92SGKY3u
         3McO+yX1LVAcfpEOlKEvgM9/6iHEtWg7ckqdzaO8eeEDIje3eNiiHqbjgdlLUdnWbgGW
         /7vw==
X-Gm-Message-State: AOAM5333/YAG+ZbLFBEiSAdfeRApowjZ9dehcaoH9BzX1bS7J5sQP3/U
        Hyv4RKuRAKtj0aORtQ/LHqx3wINWpv36yJBtciWhYQ==
X-Google-Smtp-Source: ABdhPJyP2CYyAMghh0YGHK2A6pt9+MAcyGQNaiCXuiyF3+prfn+FnowmlciaPGYISLXSkXyr51D6i1r512c9m+coQ3E=
X-Received: by 2002:a25:2307:: with SMTP id j7mr27327728ybj.518.1614199067812;
 Wed, 24 Feb 2021 12:37:47 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 24 Feb 2021 21:37:36 +0100
Message-ID: <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 23 Feb 2021 15:41:30 -0800 Wei Wang wrote:
> > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > determine if the kthread owns this napi and could call napi->poll() on
> > it. However, if socket busy poll is enabled, it is possible that the
> > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > on the same napi.
> > This patch tries to fix this race by adding a new bit
> > NAPI_STATE_SCHED_BUSY_POLL in napi->state. This bit gets set in
> > napi_busy_loop() togther with NAPI_STATE_SCHED, and gets cleared in
> > napi_complete_done() together with NAPI_STATE_SCHED. This helps
> > distinguish the ownership of the napi between kthread and the busy poll
> > thread, and prevents the kthread from polling on the napi when this napi
> > is still owned by the busy poll thread.
> >
> > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.come>
>
> AFAIU sched bit controls the ownership of the poll_list

I disagree. BUSY POLL never inserted the napi into a list,
because the user thread was polling one napi.

Same for the kthread.

wake_up_process() should be good enough.

. Can we please
> add a poll_list for the thread and make sure the thread polls based on
> the list?

A list ? That would require a spinlock or something ?


> IMO that's far clearer than defining a forest of ownership state bits.

Adding a bit seems simpler than adding a list.

>
> I think with just the right (wrong?) timing this patch will still not
> protect against disabling the NAPI.

Maybe, but this patch is solving one issue that was easy to trigger.

disabling the NAPI is handled already.
