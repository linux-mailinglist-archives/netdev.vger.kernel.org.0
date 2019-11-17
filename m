Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3CBFF844
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfKQHMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:12:17 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33712 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfKQHMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:12:17 -0500
Received: by mail-qk1-f195.google.com with SMTP id 71so11754333qkl.0;
        Sat, 16 Nov 2019 23:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iLXpGetQwa/Hk9xyKIHJmBZjiHT8LdP1v+KHfrz/uWU=;
        b=EkigySVBdyktgT1E6aLKqiAcR5hShNu8TSN+LNBVG18mXCAGmXK34Ui5bhHhVKmoHF
         hPqzVicwFdIqRi0qhGPUpAh0Z1TuFe4vHGhjafFJZ+N1t0ArQWjnXBOEdFteXZE5q7dR
         Umvy4yFXYB6Sw/7HK+M32p1lsYIj1632QC9zEA2NRGN5fR+Q8zAF8sHTrXfXDFAw4/i0
         nAbshvhdyygvNN2UAHaQNFgHEnlhZhAIwUpDhV3X3fM6zLjcHZGaH9rYQApSSIB220IP
         sAPnGPIu9BL/gq+XzLnZ5PeZnw9xnVbGOaMVsGxRd4miAVUnAeQ2DjgGzl+AgQgGFJth
         6hhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iLXpGetQwa/Hk9xyKIHJmBZjiHT8LdP1v+KHfrz/uWU=;
        b=fYCLkFWBJ2TjhyDEvNqnyxRF0j1j17q6MZwH4XiIQuUtqWkcZGbowq1ixPZyxy2xwU
         tJ8Ml+jTQ4vogigJ0mvSGH88vr/FVdxtMxtKW69AuuDUIJ1UihLIlhL3QzWPDpvaeJTm
         r/MoudNC06NMRSwpw6a+qdZY3zr4Loav+CJGY97GPAklS6njDWiYp0M6x8dSOv6zhIJW
         q+auTR9xBn/sYmTwPXFB8yYkoS8WcadDLtA5A8QQAkn9AX5pk9vG6YWTvwklmsXy/VP5
         fJ1fVqKmjoi0p/6OXRMMMya4L74FILhcH8EdZzs03X7LXN+f32/H/0BS8HmavX/ZaWhl
         YwMw==
X-Gm-Message-State: APjAAAVuxjJX4URPxUQr7uTdwQCZDrDprYINjvjasrwHS1FlJ4MKJiNS
        usXpn1aQXMBffN07yj01v/Po8lkjXwsqcHOhlCk=
X-Google-Smtp-Source: APXvYqwlpgbxUGmKJ0HAEnlJjpLtcvgOWFHaBfqCk8lQp2nAEcUoYwS0930x6rP3bQX2uk/+Og7JiVGeFzj5vbayXwg=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr7429291qke.449.1573974735770;
 Sat, 16 Nov 2019 23:12:15 -0800 (PST)
MIME-Version: 1.0
References: <20191117070807.251360-1-andriin@fb.com>
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 16 Nov 2019 23:12:04 -0800
Message-ID: <CAEf4BzYCNo5GeVGMhp3fhysQ=_axAf=23PtwaZs-yAyafmXC9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] Add libbpf-provided extern variables support
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 11:08 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> It's often important for BPF program to know kernel version or some speci=
fic
> config values (e.g., CONFIG_HZ to convert jiffies to seconds) and change =
or
> adjust program logic based on their values. As of today, any such need ha=
s to
> be resolved by recompiling BPF program for specific kernel and kernel
> configuration. In practice this is usually achieved by using BCC and its
> embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
> compile-time constructs allow to deal with kernel varieties.
>
> With CO-RE (Compile Once =E2=80=93 Run Everywhere) approach, this is not =
an option,
> unfortunately. All such logic variations have to be done as a normal
> C language constructs (i.e., if/else, variables, etc), not a preprocessor
> directives. This patch series add support for such advanced scenarios thr=
ough
> C extern variables. These extern variables will be recognized by libbpf a=
nd
> supplied through extra .extern internal map, similarly to global data. Th=
is
> .extern map is read-only, which allows BPF verifier to track its content
> precisely as constants. That gives an opportunity to have pre-compiled BP=
F
> program, which can potentially use BPF functionality (e.g., BPF helpers) =
or
> kernel features (types, fields, etc), that are available only on a subset=
 of
> targeted kernels, while effectively eleminating (through verifier's dead =
code
> detection) such unsupported functionality for other kernels (typically, o=
lder
> versions). Patch #5 contains all the details. Patch #5 explicitly tests
> a scenario of using unsupported BPF helper, to validate the approach.
>
> As part of this patch set, libbpf also allows usage of initialized global
> (non-static) variables, which provides better Clang semantics, which is c=
loser
> and better aligned witht kernel vs userspace BPF map contents sharing.
>
> Outline of the patch set:
> - patches #1-#3 do some preliminary refactorings of libbpf relocation log=
ic
>   and some more clean ups;
> - patch #4 allows non-static variables and converts few tests to use them=
;
> - patch #5 adds support for externs to libbpf;
> - patch #6 adds tests for externs.

Forgot to mention, this patch set is based off of patch set adding
mmap()-support for BPF maps, because I use that functionality for
selftests. In the worst case scenario, I can switch tests to
old-fashioned bpf_map_update_elem()/bpf_map_lookup_elem() interface.

[...]
