Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6202D83F8
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 03:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437183AbgLLCZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 21:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbgLLCZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 21:25:41 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A9FC0613CF;
        Fri, 11 Dec 2020 18:25:00 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id a8so16274755lfb.3;
        Fri, 11 Dec 2020 18:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HWf4Aun5/5+fUgeacGwpoakgROwaQ/uueT5h+8RHttQ=;
        b=X0Zpx4VrodtIOkCzMd2DOHZnnYOKKIZkGBQCml6C9e+7Y2HxVCtPBGMp2ULohXpQ8H
         74AIRrGMkvCMYFfqhIO9RLbwcCZPcukhmfZOSJs79xkI+EoEMsqZXJ7GdtZiiMqFmKHd
         2iqK2zwlwIeC4uJYaKg655yS/MIB1AiTzj/UkNeVsy9DO4S3/J/OADPd7i3W58ePW2aQ
         vQqZe3cW0KqUA9rFSZsZBWUXvtqo2rm6DVEvmJTiim3bIWNGiNrLMwfOVXqLiOeRI0nf
         pZ5z382bOvOna83BKte8ZOZW0S/in9ZeLE5WVbuA561GPKoLJbJ1RgsxLaENRFK8yrd6
         qhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWf4Aun5/5+fUgeacGwpoakgROwaQ/uueT5h+8RHttQ=;
        b=YKDDYTSj7yO04xVPZFAnBXb7vfcihlXPYqlGEj06xU5GggCluD6cntR81cEeffQc6Q
         cyM8L6MiA0UKX2BLcM1q18vWbq7/gLfRQ6wPEj2cmqP3sU0QaHZYw4Hh6I08xIEXxEqG
         s7cBhFWXa91hB5XU0qdlaAUB7CtT80/wWVZxH4Fxqw4DCzOPhO2H9ZkX2h5VzGOVKkft
         u2MM8IFx1WMa1I4WnTMdKi4jmJwHypb/7CI21hQ+CE6FO4kQlfq2I1Kt69cLakNd1Tq2
         jNKFJMzU2ajbhTyg8Vk6OT6VLocNI+lmpEfm7k4ACgsNud1ulJF4u1mqwqFXxG0hd4OJ
         xmBQ==
X-Gm-Message-State: AOAM531TT+xTYMVBfFgpOka2w+tyBmX2DynPBIt8nnwOHZXyxEBeUAwe
        XMpFseNdXzbSHV/6g4iPYyQtH6oCI5BKf7XHwfnPnaLtVmU=
X-Google-Smtp-Source: ABdhPJw6KoP2KQaGBDHCtn50YATsUCUkXzH8ugQiXdfcMlnnX+uWdJBXjb7nvdFfZ0j2r1taw1OdWprhxRUr2nNZH2E=
X-Received: by 2002:ac2:5b1e:: with SMTP id v30mr6300853lfn.540.1607739899032;
 Fri, 11 Dec 2020 18:24:59 -0800 (PST)
MIME-Version: 1.0
References: <20201211081903.17857-1-glin@suse.com> <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
 <a9a00c89-3716-2296-d0d9-bba944e2cd82@iogearbox.net>
In-Reply-To: <a9a00c89-3716-2296-d0d9-bba944e2cd82@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Dec 2020 18:24:47 -0800
Message-ID: <CAADnVQKr9XYS3ijsiFiEH3sUAx-HjqkzybSZ379SLkyiXBkNhQ@mail.gmail.com>
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Gary Lin <glin@suse.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 1:13 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> +                       }
> >>   emit_jmp:
> >>                          if (is_imm8(jmp_offset)) {
> >> +                               if (jmp_padding)
> >> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);

Could you describe all possible numbers of bytes in padding?
Is it 0, 2, 4 ?
Would be good to add warn_on_once to make sure the number
of nops is expected.

> >>   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >>   {
> >>          struct bpf_binary_header *header = NULL;
> >> @@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >>          struct jit_context ctx = {};
> >>          bool tmp_blinded = false;
> >>          bool extra_pass = false;
> >> +       bool padding = prog->padded;
> >
> > can this ever be true on assignment? I.e., can the program be jitted twice?
>
> Yes, progs can be passed into the JIT twice, see also jit_subprogs(). In one of
> the earlier patches it would still potentially change the image size a second
> time which would break subprogs aka bpf2bpf calls.

Right. I think memorized padded flag shouldn't be in sticky bits
of the prog structure.
It's only needed between the last pass and extra pass for bpf2bpf calls.
I think it would be cleaner to keep it in struct x64_jit_data *jit_data.

As others have said the selftests are must have.
Especially for bpf2bpf calls where one subprog is padded.

Thanks!
