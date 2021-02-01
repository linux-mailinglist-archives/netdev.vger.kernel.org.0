Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962A7309FF7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBABWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhBABVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Jan 2021 20:21:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F0964E2D
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612142459;
        bh=3B5tXgdUKMP/kU2hx0a2j+XEtprdSI4NTqN/tYMvOAQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SGW8/jrqCBICdzyH3qwyuJ21Blyali2BK6NksL70kbxDs+h6+09P8sp4BIvZFO9yl
         yf1utoJewpfcfNXLicNTmcYi72zLkULNiZzP6XOi3K3OXDZqkE+1On/PeyF/p0puap
         JFypejveDUDyHz3nUGKbhnBULvWnsXF78WSQmLOECjJuknpZlNjkmZJ/kCjnPgw7wx
         RCo+VwJ3sG9Eniwi+fuxMPci4U1q5qFi7HM8/huwbPiJ2/JJxa+hVCga10/RiQy5z7
         eHGnEplUArA8IlvmaCHeE1CLQd3vIsLcpQXlmkorgwg6tiN4X/xCi3HpcV4qsseFp6
         VoPq12coHLF6Q==
Received: by mail-lj1-f176.google.com with SMTP id f19so17527936ljn.5
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 17:20:58 -0800 (PST)
X-Gm-Message-State: AOAM53229QMqVBhveUafpdcmUj1/RrRl+MRB9yHFaNCDgiHaXDGhjqTX
        jG3awHW68f8yV1muSaJnMt3y6XZOiKxJZSmoAgqnVg==
X-Google-Smtp-Source: ABdhPJwIJIncC/Oq18m6ce+ZJFI2xIuUS/wzWzDt0DPN0xHeH3UpC5ru89ZhaMxplhSnBvlslmVSQe0TX8XBITTI5ek=
X-Received: by 2002:a2e:2c11:: with SMTP id s17mr8472300ljs.468.1612142456959;
 Sun, 31 Jan 2021 17:20:56 -0800 (PST)
MIME-Version: 1.0
References: <20210128001948.1637901-1-songliubraving@fb.com> <20210128001948.1637901-2-songliubraving@fb.com>
In-Reply-To: <20210128001948.1637901-2-songliubraving@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 1 Feb 2021 02:20:46 +0100
X-Gmail-Original-Message-ID: <CACYkzJ4Ha1r4oqPge7yJjORdBUPg=huHSjER58ka24OEw_4S0A@mail.gmail.com>
Message-ID: <CACYkzJ4Ha1r4oqPge7yJjORdBUPg=huHSjER58ka24OEw_4S0A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] bpf: enable task local storage for
 tracing programs
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 1:20 AM Song Liu <songliubraving@fb.com> wrote:
>
> To access per-task data, BPF programs usually creates a hash table with
> pid as the key. This is not ideal because:
>  1. The user need to estimate the proper size of the hash table, which may
>     be inaccurate;
>  2. Big hash tables are slow;
>  3. To clean up the data properly during task terminations, the user need
>     to write extra logic.
>
> Task local storage overcomes these issues and offers a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.
>
> Unlike LSM progreams, tracing programs can be called in IRQ contexts.

nit: typo *programs

> Helpers that accesses task local storage are updated to use

nit: Helpers that access..

> raw_spin_lock_irqsave() instead of raw_spin_lock_bh().
>
> Tracing programs can attach to functions on the task free path, e.g.
> exit_creds(). To avoid allocating task local storage after
> bpf_task_storage_free(). bpf_task_storage_get() is updated to not allocate
> new storage when the task is not refcounted (task->usage == 0).
>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: KP Singh <kpsingh@kernel.org>

Thanks for adding better commit descriptions :)

I think checking the usage before adding storage should work for the
task exit path (I could not think of cases where it would break).
Would also be nice to check with Martin and Hao about this.
