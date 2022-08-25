Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67745A11AF
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbiHYNPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240415AbiHYNPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:15:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB1EA50F1;
        Thu, 25 Aug 2022 06:15:49 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r141so15917703iod.4;
        Thu, 25 Aug 2022 06:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=+YOQ57iPUGa9ulqrxvV1JvzCGXMUqxwl0gn05L69nn4=;
        b=E9bghTZ8kghJKn2LnSZaEcdqg1K6cXG+IuGzOkX+IcqgKP13sFhuES3Dtga0uGN3Xh
         RX+nyUvF9WU263dz+QUz3JUXcghxtgNBe+gIQDe9KlgxoT7zi8b7sYN6KNY8ko8cLON7
         k3aQ2jtQ4D7a6RkZ0FfQOHWjzCrQC8QN1hO7K0FiEVVAPwIg698Rco8EaIMPFEqzTl4T
         9fn/iRak0httsfXqX0s5THruFjlhbvdyebOwPUG2n7JK/zQZ/5uFKdfXykhnqd3SCa7C
         5tqNIwqi0QLiXoAsHVjThOdA2IwQoXL2In9a/nfQH6c0CQGV2BtsOTPvax4iPuEIHKfv
         t+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=+YOQ57iPUGa9ulqrxvV1JvzCGXMUqxwl0gn05L69nn4=;
        b=G4mTif5LcI5AEntPL3azdxRW4aashIaS6AqnxJsYQ5ZZx4LRRTdp6VjI+8dAreve7m
         SF1fd+bpJ+ig5QG7g5fWC5UufxX6auyFtQyVYZAucWBALkEUHsvfst/VinLHVmBm6B/K
         ZPJcNzZyB4PI9ANyOaL7Rxihoj8yHAX4Qwp3j+R2FKTN6Ai4KouKKaSHS4nIt6QFJmQb
         tWL2idulvyKtCXQpqc07QI43gn7sbjrQ1FmyIehhKalVkO/7/5xXqSKD0fq8pC8k4VkP
         by+e4qk26SIu4Tck9zafaY3XcPkMuHkUR6EKt7QrPRYi2je6wAtnJd85GjkzHAbqHmPC
         WfTA==
X-Gm-Message-State: ACgBeo1wzyjFUJr9vcBVTmae0r7xuC6miuiERmFgLAKEZ/g+iYji0N2H
        WLxNaBupjQ/3SvQNdxzk8AyqV+SUyE4iWDdUdjE=
X-Google-Smtp-Source: AA6agR5wEOIk+YXHWUefJitIsnVcb7Q52nRurvr6V3qFiXWWjDCQQyJ4UxdQkhb2bxZwapAAQsbK2VfTb3ogZ2s7ngQ=
X-Received: by 2002:a05:6638:2382:b0:347:7dae:b276 with SMTP id
 q2-20020a056638238200b003477daeb276mr1738025jat.124.1661433348558; Thu, 25
 Aug 2022 06:15:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220818165906.64450-1-toke@redhat.com> <3201a036-f5f8-5abe-adb3-ba70eaf21e44@iogearbox.net>
In-Reply-To: <3201a036-f5f8-5abe-adb3-ba70eaf21e44@iogearbox.net>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 25 Aug 2022 15:15:11 +0200
Message-ID: <CAP01T74steDfP6O8QOshoto3e3RnHhKtAeTbnrPBZS3YJXjvbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] A couple of small refactorings of BPF
 program call sites
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 at 00:42, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/18/22 6:59 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Stanislav suggested[0] that these small refactorings could be split out=
 from the
> > XDP queueing RFC series and merged separately. The first change is a sm=
all
> > repacking of struct softnet_data, the others change the BPF call sites =
to
> > support full 64-bit values as arguments to bpf_redirect_map() and as th=
e return
> > value of a BPF program, relying on the fact that BPF registers are alwa=
ys 64-bit
> > wide to maintain backwards compatibility.
> >
> > Please see the individual patches for details.
> >
> > [0] https://lore.kernel.org/r/CAKH8qBtdnku7StcQ-SamadvAF=3D=3DDRuLLZO94=
yOR1WJ9Bg=3DuX1w@mail.gmail.com
> >
> > Kumar Kartikeya Dwivedi (1):
> >    bpf: Use 64-bit return value for bpf_prog_run
> >
> > Toke H=C3=B8iland-J=C3=B8rgensen (2):
> >    dev: Move received_rps counter next to RPS members in softnet data
> >    bpf: Expand map key argument of bpf_redirect_map to u64
>
> Looks like this series throws NULL pointer derefs in the CI. I just reran=
 it and
> same result whereas various other bpf-next targeted patches CI seems gree=
n and w/o
> below panic ... perhaps an issue in last patch; please investigate.

Was it only occurring with LLVM before, or with GCC too?

>
> https://github.com/kernel-patches/bpf/runs/7982907380?check_suite_focus=
=3Dtrue
>

I've been trying to reproduce this for a day with no luck. First I did
it with GCC, then I noticed that the CI is only red for LLVM, so I
also tried with LLVM 16.

I'll keep trying, but just wanted to update the thread. Also, would
there be a way to look at logs of the past runs (that you saw and then
triggered this failing run again)? Maybe their splat has some
difference which might provide more clues.
