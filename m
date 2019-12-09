Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921621177FC
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLIVI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:08:57 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:43681 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfLIVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:08:57 -0500
Received: by mail-il1-f195.google.com with SMTP id u16so14059503ilg.10
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 13:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AQw42i4zrOEiE7l1gfYBQQxkZjKK0Mv7al/wpBYPpL4=;
        b=GgghZlxE2UW0nZzjkBKGxpSYQGQqwLAtELejS5BlXB6fEFYQg+GEozmoauAoFPHA/3
         cR5ciYpYnPiDfffi5ofOYvxHIDkLLUNT86+jiqb74REnNP3riayaCXpF30VuZo9z18Wf
         iCH43boNR9Kglx6KaZE6Bz8bnb91nvZ4kRIZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AQw42i4zrOEiE7l1gfYBQQxkZjKK0Mv7al/wpBYPpL4=;
        b=WR2SjUPltpzPORV8mMTAtHX3E5aBNTZeWLSI/vN5P3FpLzp7XGRRmDDILyZt7sOeaV
         NjthJceZaaMNwIWar+kRmUkhSkzsfv6jBqkdArOxYgba4NxTznDpdfd8Bsg4diw5VczF
         yLX89LzWLSiumF8Gr24hzxGVn0avW1Gi/MyjUnoVdEuyjAXmXlhVKbuznUC0FwLh+EWL
         a1bVU/tJW04kApc+ELgL1odECvM+GJSHAy2gIXsEifTyphlctfASH741StJPcq4UWI9N
         9oWlLFpRU8azQGIfH58Vm+zTERKgYJdIlXWAbwLoXTL9fuQYkNiQrop3v1OQZm7Kel2k
         m6Lg==
X-Gm-Message-State: APjAAAU+R2GItoy6GE4Ze/4Zl0o0xV3o+D5n4IPRaIVyfbbivbfUS9ml
        mn4aUbEXePSo5h75O4VMpYJNcbGmMb5K5z/QQ6n7qA==
X-Google-Smtp-Source: APXvYqzild6VW6epyzUHodkZ6hBxH6+Vozoi6KWDPVVvdVY34P7P9ox4LxSF+V93EAmpDQA5MLv18ES3t6MGaxB5vQ4=
X-Received: by 2002:a92:86c5:: with SMTP id l66mr29155216ilh.280.1575925736421;
 Mon, 09 Dec 2019 13:08:56 -0800 (PST)
MIME-Version: 1.0
References: <20191209173136.29615-1-bjorn.topel@gmail.com> <20191209173136.29615-3-bjorn.topel@gmail.com>
In-Reply-To: <20191209173136.29615-3-bjorn.topel@gmail.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Mon, 9 Dec 2019 13:08:34 -0800
Message-ID: <CADasFoDOyJA0nDVCyA6EY78dHSSxxV+EXS=xUyLDW4_VhJvBkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] riscv, bpf: add support for far branching
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 9:32 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> This commit adds branch relaxation to the BPF JIT, and with that
> support for far (offset greater than 12b) branching.
>
> The branch relaxation requires more than two passes to converge. For
> most programs it is three passes, but for larger programs it can be
> more.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

We have been developing a formal verification tool for BPF JIT
compilers, which we have used in the past to find bugs in the RV64
and x32 BPF JITs:

https://unsat.cs.washington.edu/projects/serval/

Recently I added support for verifying the JIT for branch and jump
instructions, and thought it a good opportunity to verify these
patches that add support for far jumps and branching.

I ported these patches to our tool and ran verification, which
didn't find any bugs according to our specification of BPF and
RISC-V.

The tool and code are publicly available, and you can read a more
detailed writeup of the results here:

https://github.com/uw-unsat/bpf-jit-verif/tree/far-jump-review

Currently the tool works on a manually translated version of the
JIT from C to Rosette, but we are experimenting with ways of making
this process more automated.


Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
Cc: Xi Wang <xi.wang@gmail.com>
