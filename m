Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9244717CA
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhLLCQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhLLCQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:16:17 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2481C061714;
        Sat, 11 Dec 2021 18:16:17 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso10637304pjb.0;
        Sat, 11 Dec 2021 18:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODm5tTBiKjrGbG+xckr2d0+8GcplwxAyRg/WZM+r+ZU=;
        b=fx/cYQjNTogkQkklLJydR4YdBt6fJXbRKvaeOoIOFI7DBXmRSoXo0ojIGmfZMOZhNr
         dMcuspsbvAJNb9rzHf1GX3K6IeTIcMC0c5Ymmz1w8LubF7dk50Ur8q+uUrA6KRi+iKp2
         khoaI/56VO2lV9pSIdiqQpkeMSJqH/CnS33OQ4Pdjp6CamzXMJn5WI8X29TU2ZV9QU3g
         q0Rp3c0onPer0gpCnAh2JC5At7NuCfw44RArqd4m/rM6MU6iKPVLYsefDsyQUkNa9gl/
         PpeMQ6zdz/DRWduDt0zCfTDFxG56jCFAVH+oB3kTpoTTyZb3ymiN9ChoJG970B9/SETd
         Hicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODm5tTBiKjrGbG+xckr2d0+8GcplwxAyRg/WZM+r+ZU=;
        b=TDE+5tVKYJdpj2wIjvb7k6EbagpF2VWtx5iDbUd3Okk7vworJq805iF896U+HSu9MS
         B4sh1ww2paLfs38t59Ea+dqtKPe95exRlDYZlh1DbEALCo6Bn5EsQZnkUxHzgMbq0Hpj
         +RF07+P0t/JvI7gq9xzWA8FTY/XkTVjrX9l9o6v0+vp+aTym2YxpFWaPKUfi5x/xQ/og
         r4aaxMsji5vD0TD57rU66TaydgpnFd4Mpvd6lxNd0Mo9QhEISCGhzT8/+c6WInZdamwS
         ZwnGjvZ9X5VWvmmf4fsr8eqxIwgt/WHB3DaGbLq0cLStBZBy1LUIUBnBFpeOAlxCRvpy
         7dsQ==
X-Gm-Message-State: AOAM5313fXdBTQqvoaND1yxEgfC4ah/aGKOwPduh6Y6Snszpad/XCakt
        kcYyu3oAxLnieO6AOK81mpIWSbMQynycxBYbYR0=
X-Google-Smtp-Source: ABdhPJxxdL1mGuaBvfT4Vll0Ypm45+kpnKpBj99qjYdQuu116CxUfv0X/VSqia83k0TsstchZ5IoKRVNzzHPr4Xi0dE=
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr34447607pjb.62.1639275377221;
 Sat, 11 Dec 2021 18:16:17 -0800 (PST)
MIME-Version: 1.0
References: <1639030882-92383-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1639030882-92383-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Dec 2021 18:16:06 -0800
Message-ID: <CAADnVQKnN6bariMqkXCzHCGcb-ZT6MSJqXq1QjpRbwS8vdy=eQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: use kmemdup() to replace kmalloc + memcpy
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 10:22 PM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Eliminate the follow coccicheck warning:
>
> ./kernel/bpf/btf.c:6537:13-20: WARNING opportunity for kmemdup.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Applied. Thanks
