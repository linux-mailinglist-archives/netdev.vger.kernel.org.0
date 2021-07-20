Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAC63CFBF4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhGTNmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbhGTNhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:37:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC78C0613DF;
        Tue, 20 Jul 2021 07:16:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so2140897wms.5;
        Tue, 20 Jul 2021 07:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12XFI440hpt8MIfmH67VSP8xou9BVaMyvzziyP5iKtY=;
        b=n+swtzvdVgNM/UhMcNX2EYqYMOshNjxKjXOoVCN8xalEvWC6SJ6wFWNszkC5oGXqUL
         Sw4P565WqhNKoqlprMaV+bQb8gAmqis3M1L6CPHkBkY3VnOAPz7qzFzP0r8yff2xfI/L
         l3Z40IPbBSxzp8zjti7BViMeAso+aD1/bMLDMc43Cmj2ay2l0AuPEunNq70QMOlzi89R
         FqywX2zC/m7lJXSRdYiHhFho6FXB6FuoobMOaoTmdTUrdZYBQvnFn08a9Xx9xbUeJDwF
         5Z0AhQ5yoW5glTxhUpqXsdMV/9b/ba+unwcScVd+rmnwiJOAv5fynwZCVef1Ay+ybW25
         OUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=12XFI440hpt8MIfmH67VSP8xou9BVaMyvzziyP5iKtY=;
        b=oeZjuTEVhZNuAk6qdECnIhSQmMwloqxbMptveSEUjEShFXS0nZlG+KDCeecdW/D8FW
         gBYaGB94ynu9YSrOSsQ4xNS6dCLNfGO6Y3otPlY7IwX64QstVULNcfjIWBa5pdL7M4vp
         OGq/j6XbAHMReF6xrydP/dGlCG0qDjf6mWzrzvbIAdwlUYgSH6yqC7xCtEatNy6ny1Qh
         hJmDYyC2mZTBFpEb/Asq0UQCkKKGA9+pFSezmDVdE5dsfqVl87q/dCSN5TIDEhnF3KVt
         Z/8CSe4jXUlM6Wo0Wxcly+MiDxV1uBuSc6vSrOaFwyuM+mpwlfT/nH70f1M3ug3/e3pQ
         da5Q==
X-Gm-Message-State: AOAM532Z/fPcZw3BkGUMTHppTZq5njwAkZ5yGU5FdrsJYn4uM44lC6gm
        FN5mtfJXc6jmOIKHXmnK/L22kxWZIjv2stlN0H8=
X-Google-Smtp-Source: ABdhPJzvqjirACpItrU9wPRUgtWi6Jg6/CfxxG9UOoyUQfQ/TWpmWeIQnFY3Noqqns+a1+F6DUcszMSUIqka76YqCxU=
X-Received: by 2002:a1c:6354:: with SMTP id x81mr13474780wmb.12.1626790583280;
 Tue, 20 Jul 2021 07:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1626713549.git.lucien.xin@gmail.com> <b27420c3db63969d3faf00a2e866126dae3b870c.1626713549.git.lucien.xin@gmail.com>
 <20210720125036.29ed23ba@cakuba>
In-Reply-To: <20210720125036.29ed23ba@cakuba>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 20 Jul 2021 10:16:12 -0400
Message-ID: <CADvbK_fhN-kSbntKjmhD-_WJweAduUtHmucuFwLj_ZYYXbb6cA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] sctp: send pmtu probe only if packet loss in
 Search Complete state
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        =?UTF-8?B?VGltbyBWw7Zsa2Vy?= <timo.voelker@fh-muenster.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 6:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 19 Jul 2021 12:53:23 -0400, Xin Long wrote:
> > This patch is to introduce last_rtx_chunks into sctp_transport to detect
> > if there's any packet retransmission/loss happened by checking against
> > asoc's rtx_data_chunks in sctp_transport_pl_send().
> >
> > If there is, namely, transport->last_rtx_chunks != asoc->rtx_data_chunks,
> > the pmtu probe will be sent out. Otherwise, increment the pl.raise_count
> > and return when it's in Search Complete state.
> >
> > With this patch, if in Search Complete state, which is a long period, it
> > doesn't need to keep probing the current pmtu unless there's data packet
> > loss. This will save quite some traffic.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Can we get a Fixes tag, please?
Fixes: 0dac127c0557 ("sctp: do black hole detection in search complete state")

Should I repost?
