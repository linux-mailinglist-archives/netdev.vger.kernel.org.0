Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDBE2C9490
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgLABTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbgLABTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 20:19:41 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DA7C0613CF;
        Mon, 30 Nov 2020 17:19:00 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id u19so528057lfr.7;
        Mon, 30 Nov 2020 17:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5P33nYxooHrLpCe1LR8Yn5hFMaTVV0o/RiUqPVL5R0=;
        b=WnS1px+lhfMEQooID75MX8+MutuPlKdvehiunY+YCQtAMbP1Nl67XWhG9mOR9qRXrg
         N0o491yx80ptB2Gpj+YDW/JhVnW2WAe9hvesb1Lly7W4RUZD4bZPnbt5VrLuP/9Sw6AE
         +2eJnVwRkuZPM0Zhh6C5NrAIDc9bGUX0nTvhwSdHj0jOKVF/ggsqTJTUR3CHwvlbPeu+
         vKxzi68v9rFNkZl5/uiEujV3Z/z5iOaTgInc3u6lR8yw+npwR3BBJmG1wlkiZ2+7qiv8
         +kXedn+AC1tqYfjVh/llZRUQWDmX8bPXkXaa41y87TAReio97jgIRGaRDBGNuDFLunjx
         BTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5P33nYxooHrLpCe1LR8Yn5hFMaTVV0o/RiUqPVL5R0=;
        b=Sq9GzOnjFslfIiNMi+8eKHxdGCrMKMrGoL+gSAl44ssL39hH4eSQFUwN7fxPGMPZWc
         387xNT7KccF03HZ71wVYG0RrRt4qAMJVoEgAaxj9W545UMpceBWIJW2FOivt27oVNr+z
         80pvhVweT7wW5/b4ilKVKrEZeiGfAykxIQJuF94183QdE9Hpng7enwwLuFu+OBJG3sjJ
         9/F3cjnWgPJbp/gJvK3p1JqKKVqQjL13RUFLvAsNN5tnIOabQ6QJ4k6NEJfnYWS7irfj
         akNbqOZz3Z8kVojIPhLn7Lc4eICJbMNFuXS4F3WWF+dsSGsAi34+apuiONz4n+MwVfvh
         r3cA==
X-Gm-Message-State: AOAM533NAZP1DSeHSUklRPqSPOD7d68bx4+sdZvlvX2b6YkKm8VHJT0c
        SNPDwZufQg82PhOYi5MaDbhpUv0NSosTa3HRluk=
X-Google-Smtp-Source: ABdhPJxX2gpzgGFZnFqgbr/NBPTUy5/diUraSACDOD28JrtMJYTDsXi/AZ8VuAzZjrLlrZZEcQaTR/BdGtrk2hR//6s=
X-Received: by 2002:a05:6512:3384:: with SMTP id h4mr131481lfg.554.1606785538467;
 Mon, 30 Nov 2020 17:18:58 -0800 (PST)
MIME-Version: 1.0
References: <20201121024616.1588175-1-andrii@kernel.org> <20201121024616.1588175-2-andrii@kernel.org>
 <20201129015628.4jxmeesxfynowpcn@ast-mbp> <CAEf4BzZN5RZ4qfMRKz0MGgEvX19TpzbmeMyTvf3misxvHuRGOg@mail.gmail.com>
In-Reply-To: <CAEf4BzZN5RZ4qfMRKz0MGgEvX19TpzbmeMyTvf3misxvHuRGOg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Nov 2020 17:18:46 -0800
Message-ID: <CAADnVQKaXPs6mrcHYUrA1V4sTqd9C6yzfQuZ03grgYEj91_EVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] bpf: remove hard-coded btf_vmlinux
 assumption from BPF verifier
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 3:04 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> No more holes, but the same overall size. Does that work?

Thanks. That's a good idea.
