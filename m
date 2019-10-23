Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5278CE1173
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 07:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbfJWFBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 01:01:08 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46241 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729233AbfJWFBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 01:01:07 -0400
Received: by mail-lj1-f195.google.com with SMTP id d1so19522320ljl.13;
        Tue, 22 Oct 2019 22:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2tnm9Xe2oAYdqYx4CXMm7IuB7Ve5nmakS91SVTR22As=;
        b=WuRyHeJd3+J6FbWAtsD86Qnc0dz8ONmSXCc5LFyIpAStHZDsVcS6ID6mu5AdpXDEvz
         NIjzoLxHpka4ybvVNLGF/Lw3g9c27IUpVuwWnoY9EpQUGERX4cAqd1h/4YTorom/Z7S+
         +FbanCdzGS0u7oEODwpzoxhBMpwFmzPeQ4e4CDUscD2snyCjpwQAfnKacxkIButXmE65
         IUhukdGU4kvWRk0YBlMxVve/243QvDqHxV1W8CoRqiy51o8ykmPFB5Q6Ku02FSP1pQT+
         K5RdEfBrlON5E4cYvG6krN2jOr5s6Wh2byqpdlbf7Ce8N5kpcW5ZHCSN7Hx18GxVA0Wg
         FjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2tnm9Xe2oAYdqYx4CXMm7IuB7Ve5nmakS91SVTR22As=;
        b=Qfk7SMXWO0rBIgKgpGqwk/hdJwH5zr7Co7wQ72823XklArX1NO/khiweBp2zBc1bhL
         ZGo47WyiKzZDfbbh46KvpM5QXY7YIVb/EKJox21I5kLq0s3WkL+73kYAYw/0O9wjj1b4
         MCL2DiBBYlaoYEsgVYmhSdBU0Rdos+kQwBbWi9xn32452szm2Kr7y8Ti0ah5wfFtnkHj
         jl6zpsaSqucMiU/mAp4G9Y6/CcBSd10wd6MVFN6mlK8TImjmNSDYTUcbUwQOhq4zBqqQ
         YLcbtiKw1Sk1xOYmZWTKb/hp4ckvTQHiQJaxtWyyin1E8v0tJMFkdk88nT1+I1SL5oZi
         I17w==
X-Gm-Message-State: APjAAAXK3OA/wueBadGamTFRKwFQiC1Mrc+zvrUbA2EENsq5k2yzZ0Vz
        q9LZpaVk6ElBFUuc1Wl8YH3Ppz//YoxLruLDVvo=
X-Google-Smtp-Source: APXvYqznCRa2WLuSXsQPfv0xrP80FGABGIrFL1YiD3rwDnVdeoUbld7LI+Oo/7nIqeE4YclDRKHH59lm8UBGbPs7GDs=
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr4418670ljj.136.1571806865370;
 Tue, 22 Oct 2019 22:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <875f2906a7c1a0691f2d567b4d8e4ea2739b1e88.1571779205.git.daniel@iogearbox.net>
In-Reply-To: <875f2906a7c1a0691f2d567b4d8e4ea2739b1e88.1571779205.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Oct 2019 22:00:54 -0700
Message-ID: <CAADnVQKYv1YAv_jwQLHQYKdEcJCioKG0AfWRnGmwO=jqL9+jdw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix use after free in bpf_get_prog_name
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 2:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> There is one more problematic case I noticed while recently fixing BPF kallsyms
> handling in cd7455f1013e ("bpf: Fix use after free in subprog's jited symbol
> removal") and that is bpf_get_prog_name().
>
> If BTF has been attached to the prog, then we may be able to fetch the function
> signature type id in kallsyms through prog->aux->func_info[prog->aux->func_idx].type_id.
> However, while the BTF object itself is torn down via RCU callback, the prog's
> aux->func_info is immediately freed via kvfree(prog->aux->func_info) once the
> prog's refcount either hit zero or when subprograms were already exposed via
> kallsyms and we hit the error path added in 5482e9a93c83 ("bpf: Fix memleak in
> aux->func_info and aux->btf").
>
> This violates RCU as well since kallsyms could be walked in parallel where we
> could access aux->func_info. Hence, defer kvfree() to after RCU grace period.
> Looking at ba64e7d85252 ("bpf: btf: support proper non-jit func info") there
> is no reason/dependency where we couldn't defer the kvfree(aux->func_info) into
> the RCU callback.
>
> Fixes: 5482e9a93c83 ("bpf: Fix memleak in aux->func_info and aux->btf")
> Fixes: ba64e7d85252 ("bpf: btf: support proper non-jit func info")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks!
