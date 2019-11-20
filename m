Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A348A10430D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfKTSLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:11:43 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42104 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfKTSLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:11:43 -0500
Received: by mail-qk1-f196.google.com with SMTP id i3so608664qkk.9;
        Wed, 20 Nov 2019 10:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+XvTVMTSQY9b5j6Id3kKL6RqroXeFfK7ontB53SIHM=;
        b=g3B6oHNGClhKyYqK+Cn88lzRRm+W0IFS9uQlxcQ2qHeI2JJClhIBWTwtxxUYWTCPor
         xxG+0o8ERn/MM/pvGkPcnzCxg7ic9NwIKJYaloEdmAyyMWD5m82Gyyw7xgDNvNhhgiaZ
         NO2r3aXYW4g7VC7XpEohqf58xEu3/Ih0IfYYoZRS0rTy5GASV3x+QFgh7aNz0JrndJ8q
         KGKrJ9bF11AMjNNRguc9mXtXrEkv9L8l8W46Kwh7C6HFuxD/gEKTpseZY2DVvZUitStz
         jud49/Ky1npU1K9Xli9x+J2M7j0Yk7VF1iLZwNqkFhkEkyg3eb8ozGznqpaG2M8ElihZ
         9+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+XvTVMTSQY9b5j6Id3kKL6RqroXeFfK7ontB53SIHM=;
        b=Z1VU+wnXmIVsgxvziahQKLSFSPb8JQ9+TsFNL9SpLK0AC+5lxGFHbFLNa244GwUmmP
         bFXc+rssPy4XJDF1evxx3Ulx5eWTsAe3o5BPMiXevGq2mtn3Duq8yXoJEEBWw22N0V0A
         0xrgZy3d7BBgMB6xxN7XuvS0WYU2QmGWZzr6LsrcmeILzlFLUX+l+KrWdVVX2tcW1VkP
         utf5d0aWgxN4BJc3ATix9mWrKKkl1F/iuXOFTDwRJXJKvc03lMWq3blinL6FZxzD+VTy
         eUwxPkhAwgslYyZ0Ln9dGVzQo3yfZdr6b3slYRbycy39xkbBmcNm8W7nZSXmEl+5xWxe
         pZfw==
X-Gm-Message-State: APjAAAVnmfZ0bAJ/UzesjEmfNR2QFpjxl+li7BH8AlgDd0QeSEaMago1
        0hMQ+xaWIF+V1u700fNMUo3No3L5werV7pWMFhU=
X-Google-Smtp-Source: APXvYqwrSkg8KfjdnHIMtCbhC1lwVZfn6VhS1L45ne3GokTs8sal6L7sXzOki6WJAmwwLvAoqA7K/zIjBaPvase+2mo=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr3662310qkj.39.1574273500583;
 Wed, 20 Nov 2019 10:11:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574126683.git.daniel@iogearbox.net> <ad08df844b3b111e371d30191b2789facfd120ed.1574126683.git.daniel@iogearbox.net>
In-Reply-To: <ad08df844b3b111e371d30191b2789facfd120ed.1574126683.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 10:11:29 -0800
Message-ID: <CAEf4BzZPhtXnbpPU2-fKmanfNQxOas33EkrjNgcaVnmZFvaZqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/8] bpf, x86: generalize and extend
 bpf_arch_text_poke for direct jumps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 5:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add BPF_MOD_{NOP_TO_JUMP,JUMP_TO_JUMP,JUMP_TO_NOP} patching for x86
> JIT in order to be able to patch direct jumps or nop them out. We need
> this facility in order to patch tail call jumps and in later work also
> BPF static keys.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/net/bpf_jit_comp.c | 64 ++++++++++++++++++++++++++-----------
>  include/linux/bpf.h         |  6 ++++
>  2 files changed, 52 insertions(+), 18 deletions(-)
>

[...]
