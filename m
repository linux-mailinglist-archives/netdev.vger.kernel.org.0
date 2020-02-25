Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0E16B66D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgBYAND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBYAND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 19:13:03 -0500
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA347222C2;
        Tue, 25 Feb 2020 00:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582589583;
        bh=zS3nnv7YMTymj1g/4AOMDXFt7QziN7d1CuDttXTb8Mk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cqmBCG9ab7U5wkIMNgBwawurCEhIC8RHA2jdlzPSJj85VZFLaQ/pwRTZlXYBmN2Ww
         J0R7jKPCLNhCd3/n9abk/P/eOljDR1w4bG62IbMgHmkWV/FxQiZw9hmPGj5QNTrFji
         PSSXqHIOPeMrrr2YiRh74KNXjngMG8XFJSDwRvzc=
Received: by mail-lj1-f174.google.com with SMTP id n18so12085616ljo.7;
        Mon, 24 Feb 2020 16:13:02 -0800 (PST)
X-Gm-Message-State: APjAAAWx8E3P3S/QZvnF4SSEuRRGThN18AZC80CxdQm03glV1s/sc2nb
        p1Kqhx/0+NoywBBfxgbk0JW4fPt8bLUzfzEE3I4=
X-Google-Smtp-Source: APXvYqxPl5Tk5ZbOOJggAygcv95IuiXJ9t6vA0ziyGrM9SLJ3IuVdJA/gLQFJG/1VS+97OkyObZz9x0CXabYhniu3Qg=
X-Received: by 2002:a2e:804b:: with SMTP id p11mr31734179ljg.235.1582589580873;
 Mon, 24 Feb 2020 16:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20200221184650.21920-1-kafai@fb.com> <20200221184656.22723-1-kafai@fb.com>
In-Reply-To: <20200221184656.22723-1-kafai@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 16:12:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6wPdTGpY4-iicW+7T=+6M8ZFdQpdXV6Fx+fe7qy27Z2A@mail.gmail.com>
Message-ID: <CAPhsuW6wPdTGpY4-iicW+7T=+6M8ZFdQpdXV6Fx+fe7qy27Z2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] inet_diag: Refactor inet_sk_diag_fill(),
 dump(), and dump_one()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 10:47 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> In a latter patch, there is a need to update "cb->min_dump_alloc"
> in inet_sk_diag_fill() as it learns the diffierent bpf_sk_storages
> stored in a sk while dumping all sk(s) (e.g. tcp_hashinfo).
>
> The inet_sk_diag_fill() currently does not take the "cb" as an argument.
> One of the reason is inet_sk_diag_fill() is used by both dump_one()
> and dump() (which belong to the "struct inet_diag_handler".  The dump_one()
> interface does not pass the "cb" along.
>
> This patch is to make dump_one() pass a "cb".  The "cb" is created in
> inet_diag_cmd_exact().  The "nlh" and "in_skb" are stored in "cb" as
> the dump() interface does.  The total number of args in
> inet_sk_diag_fill() is also cut from 10 to 7 and
> that helps many callers to pass fewer args.
>
> In particular,
> "struct user_namespace *user_ns", "u32 pid", and "u32 seq"
> can be replaced by accessing "cb->nlh" and "cb->skb".
>
> A similar argument reduction is also made to
> inet_twsk_diag_fill() and inet_req_diag_fill().
>
> inet_csk_diag_dump() and inet_csk_diag_fill() are also removed.
> They are mostly equivalent to inet_sk_diag_fill().  Their repeated
> usages are very limited.  Thus, inet_sk_diag_fill() is directly used
> in those occasions.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
