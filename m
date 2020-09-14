Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADD269408
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgINRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgINRsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:48:10 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE15CC06174A;
        Mon, 14 Sep 2020 10:48:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v54so591746qtj.7;
        Mon, 14 Sep 2020 10:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4QoP2H/4Foo2ltH87doo80dVxctNT7kAfNaEVcg1eg=;
        b=q3hAdXNeJLbn/VHK7vR/1FKykV4bz7/nMjPX3AkF/xTnsXDTVyXNCrUNIiBRg5UjIF
         6mi3jrdlT44H0YhebDQkAx5xgML5bxl44KNqTf2QJx8inu5R7oLfS6+koj0w9Llg70JV
         Xu3iU4Iwigw1d7Bh2gm1hUOHUTKfgrh61NiVI1Pf9yNJd8lf3z3tUDbKy8pGmnGhCEW3
         N/ICuCvIYNI85lVHKDiU1YYGNwKgjtE3+vnh9it/AkzYIkulFRlph9z5Up/+PmsC2IaU
         4Od8eer3spf7/+YRls0GqiQcIpVdHUDFv1VF8hfnGik+PbkfX0qHQIiqMq1q7Fw7Jb+D
         3CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o4QoP2H/4Foo2ltH87doo80dVxctNT7kAfNaEVcg1eg=;
        b=tYlL6FyXCyfIOPig8tnFL3Z3fBv94qt9KUJmNqFl2Gpwp27F5lwWj8T0jUqtyCWAyu
         n6Fhx0pC/lBsoIhGAsP8c8MYc+sDDrLtWE2m0BA7wmRi01ZcIY9n7nLypEnXento+QHT
         WikgEuA7SAYWziD3YElzFM/X30TtuZ6W52bGBhQ9SCnF+nsht3f8/HtbVt8pfw18Rer+
         Udxzdbze4pvN+61oU/gEIIfQBllnlBMURjh5MEhyvn8F+GFo9nJRzq/Z+AFRPuGS6b0S
         y0TaABGJ1MrLM3QlfmdMK15Mlt/tHhi+AdAQJPAkW0v4ZGplnsQBDx5WtO5+y6ud8OMj
         TCIw==
X-Gm-Message-State: AOAM533b7FfgpAOR4RHIehOszEqthdrwquPvFI6IAhJ+1FKrjzEI4SHP
        7g42ZTm5WWMzptGOjUaNEsojok6WAu/4EYlLcSM=
X-Google-Smtp-Source: ABdhPJxh5GxP7zV2ugpdarY0VBvR0YuuxK5UNa0Om8U0VAZIza95/YyEZLiyNz4xSf/jZPHvMlgr1GPl2L8rJ59+B/k=
X-Received: by 2002:ac8:b83:: with SMTP id h3mr14472830qti.113.1600105688936;
 Mon, 14 Sep 2020 10:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck> <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home> <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon> <20200914170205.GA20549@apalos.home>
In-Reply-To: <20200914170205.GA20549@apalos.home>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Mon, 14 Sep 2020 10:47:33 -0700
Message-ID: <CAKU6vyaxnzWVA=MPAuDwtu4UOTWS6s0cZOYQKVhQg5Mue7Wbww@mail.gmail.com>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 10:03 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
> Naresh from Linaro reported it during his tests on 5.8-rc1 as well [1].
> I've included both Jiri and him on the v2 as reporters.
>
> [1] https://lkml.org/lkml/2020/8/11/58

I'm curious what you think of Luke's earlier patch to this bug:

https://lore.kernel.org/bpf/CANoWswkaj1HysW3BxBMG9_nd48fm0MxM5egdtmHU6YsEc_GUtQ@mail.gmail.com/T/#m4335b4005da0d60059ba96920fcaaecf2637042a
