Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DF534D92A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhC2Ulk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhC2Ul0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:41:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386A9C061574;
        Mon, 29 Mar 2021 13:41:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id kt15so21450671ejb.12;
        Mon, 29 Mar 2021 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOY00wZMw7iQ/C8A6RUq3HCwcrBzQhlsaRdSeoRLwXs=;
        b=oWb6o1aHOSF0DXx/yX1KkO7igNt5jO2+W5TfD710HCbj6l6risPCncqXOwLHFW7VO8
         n2WqBzfjhpbiAq9xr5ewQLs6CPp7Q8JD5j46qyEd0ryBtEmnUxAZ4pz+1sCID0ewC8ux
         c+kDA6hixWaNdB3u91M8vSO/Rm6ab7D5cg6vvwEqrFt6JQRCTqRZ9lKp+iyrXKg1lOzD
         EUimB0/jrdsRXR3RobVvOwNQtAEB3wOBlRKbEWGe1h4MUnTVdVYcpmrl64UXSU/F4xU7
         2UQ47VDwAE3NgXqOvtbgiNZ6wJdOIC5qg0CPJ/OAWvtEQ51hikQWiK0OlgG0pn+IzHNH
         OpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOY00wZMw7iQ/C8A6RUq3HCwcrBzQhlsaRdSeoRLwXs=;
        b=cwrst70ex3yiyLbL6fuAQy2BkTaVKrv9ZBh3pBpIhrW3TLNravKg5huzSvIGNCMSyw
         At+iHLVM9uVPnbWvAGVvoZLhINpZebTjd2PpRmQQXgSzJiunR9yTs/6drqMwjnFUwZp1
         xllOChxDF690hL361oKPNpjwz7mHgtG5CJR79KPIe7SoFFq4lCh/6eoFYaKy/WHQ/YqR
         J1wIixpU3eFPSSdb61ghpz0Li9pBXdGLNyfpCKnaj3zX+OLoWmHjN+jMmQzpUlylXEWJ
         440/LS3amD7FIraAPNwcpuf/dD1GTr7ccarlCgIExp5MSjv8Xe39Ud13UlHy9ByjQt24
         2M8w==
X-Gm-Message-State: AOAM531VE8hLMYVGqoqvDC1yDXgkZT6Fu0jw8igG+K1iIGBQCki30aYE
        +PhivCD5KGcf/e69T33WJHeqfAOuUVOniCRmQB4=
X-Google-Smtp-Source: ABdhPJxcjn88m4H97qxfK72HhcS5ov53I7up+0loT8VWTFlglQcHijm0szjlpAvoCk9P+6FVl226+HzoXj3NFKnjmh8=
X-Received: by 2002:a17:906:73cd:: with SMTP id n13mr29275638ejl.535.1617050484980;
 Mon, 29 Mar 2021 13:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210330022144.150edc6e@xhacker> <20210330022454.3d0feda2@xhacker>
In-Reply-To: <20210330022454.3d0feda2@xhacker>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Mon, 29 Mar 2021 13:41:13 -0700
Message-ID: <CAB-e3NQ11Gnoa716nnZ2tTgjb02_eZOf1gWn3YMmueEAp92c1g@mail.gmail.com>
Subject: Re: [PATCH 6/9] riscv: bpf: Move bpf_jit_alloc_exec() and
 bpf_jit_free_exec() to core
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We will drop the executable permissions of the code pages from the
> mapping at allocation time soon. Move bpf_jit_alloc_exec() and
> bpf_jit_free_exec() to bpf_jit_core.c so that they can be shared by
> both RV64I and RV32I.

Looks good to me.

Acked-by: Luke Nelson <luke.r.nels@gmail.com>
