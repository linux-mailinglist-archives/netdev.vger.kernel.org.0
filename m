Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A6123398
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfLQRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:32:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46494 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:32:45 -0500
Received: by mail-lj1-f193.google.com with SMTP id z17so11843030ljk.13;
        Tue, 17 Dec 2019 09:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ze3skVZXxBnWUUu7RFt9K+xqnJgjXRZWWn4ms9QMDHQ=;
        b=EstTxkMmQ1DNI4bMHQDm3I2stJ+E+SkOiCM2WB+0SjtiQ4mO1tjZp0gXD3O33d+rIu
         91/d5wMUDdmJB6A9f6jtmeY0J+b92NfoKq19DW1jLbMfWt7BtFGJct7cYHi0oIHHO6Ou
         2AmBbTI8YjIxM0rhBFx7H69vRaIftXqC9wdTw5MiJDvUEX6s/dyOb6+il/wZbgmvBAJV
         cCT9X/m25E8JHTlTZi4O8hwUf+GinwM58fgA/K3lSnTpuEdZRS/BzBRsJTmiPnpwQEmh
         Dbf8C+wCF0+TJEhgVPMqGJ88i0Pb8nQ7aoxBZbRVmv4OuTip4hn79sWaJrCfq2qdR9H2
         l4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ze3skVZXxBnWUUu7RFt9K+xqnJgjXRZWWn4ms9QMDHQ=;
        b=Sxt6outEnkJckUxXD5tIodQbqmXWsPcbfIk8V4m22+qfWPZmsIYNLiy+CQ3OOgFrAx
         PPYDWOkiGt0qJcJKqdgIa62mE4aUNlF9mv1sbZ9De1FcR5Q1QvPtbqbNSOI2g4cbsMcv
         bbT2WdTuC+OuxHZbqL9uYNtOBF79y/S/+SnTNWr4rYAPG3QUEEamBWVl6reMydwu5wnv
         QEkRS8OBapKL4x948DyF+1lsPkGHCCiN+N+GD10UvkNmHOBD0qbT0YJY6UhWl2A8iEAO
         2G+deeJS6LBrZLWQFxoyVwgm2B8gVe7+xP6ba2fEsE/BhA7MWeB2aWYkrPHbg1A4zLwk
         BIsg==
X-Gm-Message-State: APjAAAVvn5QJntKSmHLdPk3TuAz4SQLTnJqaCooIiDiUNqhYdhLd5BXm
        k/p9iExJueA6PXmmI46GAj8TpEUl7ELseSRgnhM=
X-Google-Smtp-Source: APXvYqyf8X/sHf16Gok79XYgtk/ehznsEejm5eQeEegMi3JNmHVTBTRxjMx70WZkmIBKnDnmFrTE3S6E3wovnXJCtgA=
X-Received: by 2002:a2e:999a:: with SMTP id w26mr4138744lji.142.1576603963427;
 Tue, 17 Dec 2019 09:32:43 -0800 (PST)
MIME-Version: 1.0
References: <1471c69eca3022218666f909bc927a92388fd09e.1576580332.git.daniel@iogearbox.net>
In-Reply-To: <1471c69eca3022218666f909bc927a92388fd09e.1576580332.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Dec 2019 09:32:31 -0800
Message-ID: <CAADnVQKw7MvRet6zn0pn8jmm1f6VrF10Vk52BssWLai3EjX7LQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix cgroup local storage prog tracking
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 4:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Recently noticed that we're tracking programs related to local storage maps
> through their prog pointer. This is a wrong assumption since the prog pointer
> can still change throughout the verification process, for example, whenever
> bpf_patch_insn_single() is called.
>
> Therefore, the prog pointer that was assigned via bpf_cgroup_storage_assign()
> is not guaranteed to be the same as we pass in bpf_cgroup_storage_release()
> and the map would therefore remain in busy state forever. Fix this by using
> the prog's aux pointer which is stable throughout verification and beyond.
>
> Fixes: de9cbbaadba5 ("bpf: introduce cgroup storage maps")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
