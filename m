Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB1B489EC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfFQRUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:20:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43768 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQRUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:20:34 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so6636797qka.10;
        Mon, 17 Jun 2019 10:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Z2qjN5wmbtE0ucKvAUBVvznhINqgB6iUVU0bODLwEQ=;
        b=LBC5tBgarI5AIGQtZJw6Yi7bxq4yu0XDFnHYzoBj6dV7D+FXjZwxb4OduooDs+wxFj
         uiT50G7hQSNScmcAqREuSdEK2EJpZrP3rjbB6iX+8XxlsP0IrFCPmSmt2gsRus4UziNe
         xQW/vOpamD0rCrHYbwWORcOWtW6dMcTfPHzz2J3dmohaVE36tPBuLStQNt6Qgp+FiSnk
         1il+FCoyFJtFJdMdU26RFXS73FWkUzdAUTsLghLKL5OGNfTAt1KJdeqCLuMM4AK+7gaE
         eCGm9mrfzLqGiBPGWfMdhdfy7P5KdnujB/0PY2Je+2hsih0N4U03q9xWeyZmRUz0zpLR
         MJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Z2qjN5wmbtE0ucKvAUBVvznhINqgB6iUVU0bODLwEQ=;
        b=gldIgWUXp1kcy8NgNf4prVVp5wGWcmY41gRgQaFGa5GiZSi8IiWfJhYW0bDrLk3xgO
         Fn53eyKotX2nSNM9HLd7Yk5IQh1/i7wS4qme7aWklsM0KMiBI9CRBzCMH5nAZ8wEii6j
         SRW00F/K8sa82jqOS+fL/5//Wwo1tnG56zEYWuiz7I8CKb3YHvUd9me/YyDQug57BCsO
         XsSwdDlw3J+WWMe+B84A+h3FVeC3RfhEwzD2oYwWrveRYduJkLKm/uBTnV0bmq3pOhNY
         a6tyEj9br6DewiPxqf1tABMyC3IOAsdC6XacKwfqvXPiTSJT8G78ozu05dRNhRQ7OGyG
         kL0w==
X-Gm-Message-State: APjAAAUcrHpI2tXC/9zdcHBOUPg2zfX0A15ZVDGKCaS7K2cM2q0sSUzl
        uTehU65d7q9FWDqGxbpSNkWc53RO17OBZ5aT/zo=
X-Google-Smtp-Source: APXvYqwoDWpJgVzN5PKPtAO1xLi44jvMZMwrHB+c2e2gSdJXeimaO+fMIZTkn2TpLn0T3zaU4hpJp3Ya2HyVa6VxQQY=
X-Received: by 2002:a37:b3c2:: with SMTP id c185mr90402781qkf.44.1560792033416;
 Mon, 17 Jun 2019 10:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190615191225.2409862-1-ast@kernel.org> <20190615191225.2409862-10-ast@kernel.org>
In-Reply-To: <20190615191225.2409862-10-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 10:20:22 -0700
Message-ID: <CAEf4Bza=fyhgT-zP7G6iCm7UMOvjzUrMh0j=VsOXGj-u-BGGjQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 9/9] bpf: precise scalar_value tracking
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 12:13 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce precision tracking logic that
> helps cilium programs the most:
>                   old clang  old clang    new clang  new clang
>                           with all patches         with all patches
> bpf_lb-DLB_L3.o      1838     2283         1923       1863
> bpf_lb-DLB_L4.o      3218     2657         3077       2468
> bpf_lb-DUNKNOWN.o    1064     545          1062       544
> bpf_lxc-DDROP_ALL.o  26935    23045        166729     22629
> bpf_lxc-DUNKNOWN.o   34439    35240        174607     28805
> bpf_netdev.o         9721     8753         8407       6801
> bpf_overlay.o        6184     7901         5420       4754
> bpf_lxc_jit.o        39389    50925        39389      50925
>

<snip>

>
> It doesn't support bpf2bpf calls yet and enabled for root only.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Looks good!

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf_verifier.h |  18 ++
>  kernel/bpf/verifier.c        | 491 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 498 insertions(+), 11 deletions(-)
>

<snip>
