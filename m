Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B90CDB72
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 07:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfJGF3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 01:29:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39427 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJGF3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 01:29:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id 72so8278242lfh.6;
        Sun, 06 Oct 2019 22:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hsJCVSfcXBoUu15ev7k1KyZ2vjOC4PYGSN4RwoF4JJQ=;
        b=sTvAlYtu7z9WysFVrr4E4cWCA2gdJa5au0OEV0LigtT5j7LzyirfHEAhUloR6Zto9e
         4gAag93r1V5k6yGI1BY8Pyr0UgzjtnApQTh4TjnuNwbefDjRyOOrV3EmHZxg63BrXB8F
         U2q9nv7pvjm08pM6JVyot+/0CiSC8OVhbzqLtiCf6o9Cxp1XiYfmTcaZqBqjPCJBZU8b
         UV0EUk3sTdlyuPwBJU56DoOjImXTnrXpYL6i2bh0iXe3Ub3ZDBaCoOybVe+qejkOJF2Z
         IW89isc1Zylmjyj2BAA5ZmQwDCE/Link3joZ89rU1pBrbutn9gUdsfLLg8EShxK/1AsO
         AFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hsJCVSfcXBoUu15ev7k1KyZ2vjOC4PYGSN4RwoF4JJQ=;
        b=Hj2xFY6CkhsQRm6r473b31FHxwIsV/iZ9FyJ/BEQC+EFxi1IoAL99CJRTaOByvNIqn
         Fofnr3SuOvcRciR655OfIqEuN01qIO98fDz1r609mfC8+vuPzZmGXMYUprqAayWvMgUd
         KvqiHBsGB8ghuu03T4aZ029dXEGMqrn3KQ9uUTVujdc0AoQsUF2X8MXkwq4k4hP7M0PY
         LVxPR+TW5D4n4huXXq2sjklQp0Nv2BFoYOXaq+KXpJakAHpoGHQpzkZSaxcAVJ7X9EMF
         PjykeEh02zRLdULbxAn3/nQBChNvvLUBvIywATK3w1Z41IU4NU+oNieOPiW0z2/TmlKN
         MmRg==
X-Gm-Message-State: APjAAAVclHwR5p4Q+W1+EDy5GZlXhbJc8qxL6k43hZorl8ywCkjPsHY3
        y2/VweDa1Wew1mVHRsJX7TE8u4LrNiLNGnSnpJ5iUmUu
X-Google-Smtp-Source: APXvYqxp4PDQpxQK61cbKRyTigJaZ6+JB7RM+t6rRBd8dMisDKza6M15i+olsUCTs+OwewbMiyVxPCOewc4K6FEQc+k=
X-Received: by 2002:a19:2c1:: with SMTP id 184mr11829227lfc.100.1570426150660;
 Sun, 06 Oct 2019 22:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191007033037.2687437-1-andriin@fb.com>
In-Reply-To: <20191007033037.2687437-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 6 Oct 2019 22:28:58 -0700
Message-ID: <CAADnVQJwA-DbzncKJ_mjxvfk6PLu0HWuqkiOTWg0nVKyV6oRXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix dependency ordering for
 attach_probe test
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 8:31 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Current Makefile dependency chain is not strict enough and allows
> test_attach_probe.o to be built before test_progs's
> prog_test/attach_probe.o is built, which leads to assembler compainig
> about missing included binary.
>
> This patch is a minimal fix to fix this issue by enforcing that
> test_attach_probe.o (BPF object file) is built before
> prog_tests/attach_probe.c is attempted to be compiled.
>
> Fixes: 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

It doesn't help.
Before and after I still see:
$ cd selftests/bpf/
$ make
...
/tmp/cco8plDk.s: Assembler messages:
/tmp/cco8plDk.s:8: Error: file not found: test_attach_probe.o
