Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC34645354F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhKPPMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbhKPPLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:11:20 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B61BC061210
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:06:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y196so17243766wmc.3
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ZnBj7pdbWOVwxqOXuxVUXekOZFznjtoRaPmNynJxCg=;
        b=gbxA56KSuU9yemWI/IFGQuNdmUm/tbL6NS2/2FEO23KJHINqXry9jJt5VQ4v407H/R
         evYksuhtgOtHFwBOg5527a1YidMmxQ9jqgHIO2kJMmvmtRPpo57pa6qjFME8IoVkYZ3V
         xY8QHMIJahiN8BPEOUFbfoSjww3qVT1LLrMqUccOCemWxuYsoYPyFfhunnyVRGz6pfqH
         z02pxOzaKh9IuepY9yoDmVF2tF7AOtiNWFo2cNuFrDAmkhQHbV4afK0ztQUrIxuJNx5H
         kG6omSx584rBqEaHJ5g9b0fBjUOQyy21E7vVNtJTktRE+WScX4Fb3JwOJ1vxwy2RvkP1
         vuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ZnBj7pdbWOVwxqOXuxVUXekOZFznjtoRaPmNynJxCg=;
        b=OCvfGe+VuEmpukElgY77ojmFJ3sMwxwUdTlsuLXbqqM9db4tfDo1hHK9zlLDhmMOXi
         uQYBQNRsEdV8ZSlwzoGs2LMqvSDqeSEQdcOzEeJ0VaStCN97l0J53EWulYrJCvwjvYkO
         qWo8EUp4UxXppjptv6GPqWNLMhokmZTTEl3pRSoWobn8pz3pkCrb0E8/yS6nhZL8BZPl
         S+ZPf8HlvhndPr4DBwnfxkpLONhWDhRNUzJ1p/V0J4mLzJEBbzcb9AGO9bGenWmvH4ck
         30sSMaN8x59kv8mBnQvUaA/x4BbhK2njPcQddHJjaZRPhTlqL91RXq4xGCcPfAQ9+9Zl
         afOQ==
X-Gm-Message-State: AOAM533TUuRWUO5u882MaK+Bxw3YLl/AHYqple0ap3h5x9GBpj96WoBp
        Lgq630lP0oKdhJf0PmwA3j3jyNd8CPgpoQRc4vNhPA==
X-Google-Smtp-Source: ABdhPJxA+XV2bnUJXyF7I0ob5fEGQ9flmpDopcuPkTRxBBtuYceN3cmrdWILmtMsBdIqqWFuUNSXo+ljYaNl+wCsN3c=
X-Received: by 2002:a05:600c:2297:: with SMTP id 23mr67951746wmf.73.1637075198213;
 Tue, 16 Nov 2021 07:06:38 -0800 (PST)
MIME-Version: 1.0
References: <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
 <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com>
 <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com> <20211116.133219.63511987274053306.davem@davemloft.net>
In-Reply-To: <20211116.133219.63511987274053306.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 07:06:26 -0800
Message-ID: <CANn89iK6g9SBU0OvzrT0LRyQBY3P0t+p3AnOsYOF5yjicCs3Hw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
To:     David Miller <davem@davemloft.net>
Cc:     pabeni@redhat.com, soheil@google.com, eric.dumazet@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, ncardwell@google.com,
        arjunroy@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 5:32 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 15 Nov 2021 18:06:29 -0800
>
> > On Mon, Nov 15, 2021 at 1:47 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Apparently the series is now complete on patchwork
> > https://patchwork.kernel.org/project/netdevbpf/list/?series=580363
> >
> > Let me know if I need to resend (with few typos fixed)
>
> No need to resend, all applied, thanks Eric!

Thanks David !
