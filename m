Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1D64743F
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFPK3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 06:29:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33716 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfFPK3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 06:29:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id h10so6546735ljg.0
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 03:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Me4XqG/m9sHfXXVEccb17VwdYwCFLO+trDo9KyCTW1Y=;
        b=Mj+eQsS7MDu61+1NUKDH1vAVTLwD55IzuU/Ok6nGLyPgc2jYALj4QUYjUl44/7Urod
         O/lKJOx/c96GmYVodsEeQyT09XPC3zY+UyHXxvzDGsxvm+C1TYDv3klWqlLDmHJgOW70
         Mllq7UzbSzIFS66HvA5Dyy/5WaYfBnoRYkhgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Me4XqG/m9sHfXXVEccb17VwdYwCFLO+trDo9KyCTW1Y=;
        b=qVKWtK32SbMeyWUROeBGWeBTh7s6RhhtSzHQ6HGuwuT5Pke/HTgsUh4rABXBCH9ynW
         3MuVG/2BdIvpxZzQoEewjhFOvaWRcJKUNdu2YLo0CZi6HtLoryeAmXxewN9QD3bid7J0
         sQ8WjoVu8zc3CRu69K7WN6EXIMjvClVDVU7fdUaxy45cnF44iqCOZCPAefanKmoC18Qn
         eaEtpySla8cBrAK+7/kqMlS/eccNowplqf1xyKZLmshMe6fqz2TzhP5c5RIRBVjpTUDz
         Wj+7T3oOVsZ5ToTT7QD8eMwHRjNO9uCmPYroqGfhFzoGYBGMim4ZWmvur8wEO1r83w+2
         NB5w==
X-Gm-Message-State: APjAAAUOSwdessS6VaKRvLsksnlSgfKdn5wCna8VienhG9LT7pH+sSXG
        Bbccfc3pu7CPttb14oq5ywB5NA9HpgKBg0FPHeTFoQ==
X-Google-Smtp-Source: APXvYqxO8O0hAikX/nV9jyVW6aUtHpiYRATrrhyKO60SL4jd3wF5Sc0joxCGcm+leHffWey6z5+hGcFWv4ELMQpFpYU=
X-Received: by 2002:a2e:2c14:: with SMTP id s20mr28744572ljs.54.1560680938585;
 Sun, 16 Jun 2019 03:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190614093728.622-1-afabre@cloudflare.com> <CAEf4BzZNO8Px2BRcs5WMxfrfRaekxF=_fz_p2A+eL94L0DrfQg@mail.gmail.com>
 <6aaa3a2f-5da5-525f-89a1-59dddc1cfa53@iogearbox.net> <CAADnVQK6=90Yu6jhEhE52ptS4vgbRVpyj2oZZsO6gcrScU9bsw@mail.gmail.com>
In-Reply-To: <CAADnVQK6=90Yu6jhEhE52ptS4vgbRVpyj2oZZsO6gcrScU9bsw@mail.gmail.com>
From:   Arthur Fabre <afabre@cloudflare.com>
Date:   Sun, 16 Jun 2019 11:28:46 +0100
Message-ID: <CAOn4ftsQGaVdB+BYx6s8e9GVSCBBVu-7YXU_B-n7YttXbt-gKA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sk_storage: Fix out of bounds memory access
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 10:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> It's certainly should be in bpf tree.
> It didn't apply directly, so I tweaked it a tiny bit,
> reduced verbosity of commit log and pushed to bpf tree.
> Thanks for the fix!

Thanks! I didn't realize this had already made it to the bpf tree.
