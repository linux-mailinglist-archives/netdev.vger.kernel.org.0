Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FC928AB5F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgJLBVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgJLBVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 21:21:21 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCAFC0613CE;
        Sun, 11 Oct 2020 18:21:20 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a7so15570612lfk.9;
        Sun, 11 Oct 2020 18:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2TCBI/PBpDL1NHcOhIQ+uhvSm8Uq53rPu6VzsFICHZo=;
        b=Uj+Fniap6lqy6beyyGRanUdT9p4CR923o/wKlh++OTF+hqYPBtfLpEEJP5vRvAQM6L
         +aK3Qz83hOm6QPZ0VVdYpWFc9sFOIuSsd6cI0YJVOl1U1CdPxIsz9+2r4rKU404DZcFH
         NaFA4FyiYCIIzzG/an8/TvglN66Q/pC+IUZUKfW8IP0sgQiDKnHNLMQs1fbOab/tavXq
         rh2EazE9gIkp7OLyyPYDmpgEk5sqBIwfmmFGNGEUA6N+a7Y3JiL+N72NecHVMBWNfuPb
         4XNvuFqcSUIS7zTzvKIwaalLunuQsRzqhV+ZWweNzLf1Hp4Pqni4A/EDE12KcjgNdNx1
         7OCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2TCBI/PBpDL1NHcOhIQ+uhvSm8Uq53rPu6VzsFICHZo=;
        b=oRsFLIIAjqcXQgzE693Wdtk7qPPmNcOn4luL3Q1zW1btl9c26KpP0FLqAbbOk1pUUj
         tKxf73SYEXs1G3PZK3OrsaTjQ3TrX9yujTOh5oSSfg8rRwB2mdEzLSZVA9m9Yr4RaMfR
         N6wQq9mo/0I1Mu+bcuIj72Uv7wXTyNERA45j8Rpo7HCLv3aoelAhoDVEA27qHv7CdyuV
         1ECmBVibNXmLXbx7lrjp1GxAOP6oRVMqEirbhEO1mOeOzdlxJc0737u74swEbK4nakCt
         OaNXtlwkzky6bn/qyAzvRx2rsFyxuHTQG2ECnydqyu784JL5kPeHru0Wk7vri2LfWmqR
         41Bw==
X-Gm-Message-State: AOAM530cJLlOSPBcKFXP3hbWTqiQvvjB6NEX/pLvLqNzgCFrEKSPg7xl
        aX2rsysSHrtpjzAeKX/+xePCn/KXacO71k+c1ak=
X-Google-Smtp-Source: ABdhPJxcXimExNSbt/riOewy0F5UEGHJXvbGST95O4fPZNKOp7oethJ0Y0C6M4iKwdRSKqBGRdFQ+b1U/PvdcQDA/U0=
X-Received: by 2002:ac2:58d2:: with SMTP id u18mr5895982lfo.390.1602465678557;
 Sun, 11 Oct 2020 18:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201010084417.5400-1-tian.xianting@h3c.com>
In-Reply-To: <20201010084417.5400-1-tian.xianting@h3c.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 11 Oct 2020 18:21:07 -0700
Message-ID: <CAADnVQJUL7BynGMD_nGu8y=D1yv6TybOxeSh03TrkD7kS0aOrA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Avoid allocing memory on memoryless numa node
To:     Xianting Tian <tian.xianting@h3c.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 1:55 AM Xianting Tian <tian.xianting@h3c.com> wrote:
>
> In architecture like powerpc, we can have cpus without any local memory
> attached to it. In such cases the node does not have real memory.
>
> Use local_memory_node(), which is guaranteed to have memory.
> local_memory_node is a noop in other architectures that does not support
> memoryless nodes.
...
>         /* Have map->numa_node, but choose node of redirect target CPU */
> -       numa = cpu_to_node(cpu);
> +       numa = local_memory_node(cpu_to_node(cpu));

There are so many calls to cpu_to_node() throughout the kernel.
Are you going to convert all of them one patch at a time to the above sequence?
Why not do this CONFIG_HAVE_MEMORYLESS_NODES
in cpu_to_node() instead?
and save the churn.
