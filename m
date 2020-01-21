Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E985F14442D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 19:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAUSVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 13:21:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42003 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 13:21:48 -0500
Received: by mail-qk1-f195.google.com with SMTP id q15so2972607qke.9;
        Tue, 21 Jan 2020 10:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+Ksy6FqtilDP89VPoRirgmTtipRFZvmUK03Hx3+9yo=;
        b=pV+1APQ7bXhHWfTOYIADvijDPut4HWJHeEnKszMAKGFtjWc9xVAgA7gHGotx5qcXu2
         P48k+smW94Hpnqg2Bf1yhNv1mQlevbTi4VDA0IzCdD63HulNxl70FgB5sFwmlalF887p
         OtcH7zVYvyj4UedSLGCDEajYrkI+Vi62hUN1Sn6L5TFkvrFgJy9lmNFuEv3+gS+rFtca
         jRVU0lBfOl4EAtlM9z+/loIRy8/BIS1h6pRN3pnKYJJ35s+paikgGMPsG0mgwijbHPiH
         XxnVEzFxlyudg64pdQulRvbhEOOV0lTPV7jDVyCYPJIKfpU3ZR23aMsMtNk/+6LQlhcF
         dYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+Ksy6FqtilDP89VPoRirgmTtipRFZvmUK03Hx3+9yo=;
        b=HAs03Mndq2jXCsKEJEX6cYXwYUL+29nyBcroSz4/6DSiOne8eEb/9+cCUlPk5/VYRl
         z3CCmwF3vJG8ednDTUxEB5C733q6ua4Ne2HIg2+L2WPGESHQcjh4vN6tnJoNLgpexVMt
         OJI+1uuI5w4taeKATHurMlg7Utxj+4Y2vNki49tmjxJ3Pp5efQPW9P6rzIZIh/tsK6AK
         UMU4a553yXd9MmjVrXdwViw9qFEjzXJQp/6zfr8nRf5PLllWgYb0b3yT3Jx/sFdhrXLM
         A9LzvPI3Bt5PL1U5CVDUg9v0OHjfIeDDq+gEfcoPqxRFWkhuzL+8HG0MLIHG+6yB38sT
         u2ow==
X-Gm-Message-State: APjAAAXAzAR7Lm73KMNnneD0dFrsUup9kZZ2folN3RwDY8rzXwX7Qwyj
        tb9qErT1L1hwBB9AzruS9Rz3XSWK5HAhGuzkqNQ=
X-Google-Smtp-Source: APXvYqzcQ8wp4WbSClzSg5yedEb1GmGrhY0rdffv7vQUd9k8rosw6f9WY/8fULlicKxoFobN9x63iB8yqwzjxmi2WQQ=
X-Received: by 2002:a37:e408:: with SMTP id y8mr5823388qkf.39.1579630906653;
 Tue, 21 Jan 2020 10:21:46 -0800 (PST)
MIME-Version: 1.0
References: <20200121005348.2769920-1-ast@kernel.org>
In-Reply-To: <20200121005348.2769920-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jan 2020 10:21:35 -0800
Message-ID: <CAEf4BzZPB0mNuH6MdYyV2uRmyON7MxGx8bM=WqdKyedRbmL1Uw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic re-linking
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

On Mon, Jan 20, 2020 at 4:54 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> The last few month BPF community has been discussing an approach to call
> chaining, since exiting bpt_tail_call() mechanism used in production XDP
> programs has plenty of downsides. The outcome of these discussion was a
> conclusion to implement dynamic re-linking of BPF programs. Where rootlet XDP
> program attached to a netdevice can programmatically define a policy of
> execution of other XDP programs. Such rootlet would be compiled as normal XDP
> program and provide a number of placeholder global functions which later can be
> replaced with future XDP programs. BPF trampoline, function by function
> verification were building blocks towards that goal. The patch 1 is a final
> building block. It introduces dynamic program extensions. A number of
> improvements like more flexible function by function verification and better
> libbpf api will be implemented in future patches.
>
> v1->v2:
> - addressed Andrii's comments
> - rebase
>
> Alexei Starovoitov (3):
>   bpf: Introduce dynamic program extensions
>   libbpf: Add support for program extensions
>   selftests/bpf: Add tests for program extensions
>
>  include/linux/bpf.h                           |  10 +-
>  include/linux/bpf_types.h                     |   2 +
>  include/linux/btf.h                           |   5 +
>  include/uapi/linux/bpf.h                      |   1 +
>  kernel/bpf/btf.c                              | 152 +++++++++++++++++-
>  kernel/bpf/syscall.c                          |  15 +-
>  kernel/bpf/trampoline.c                       |  41 ++++-
>  kernel/bpf/verifier.c                         |  85 +++++++---
>  tools/include/uapi/linux/bpf.h                |   1 +
>  tools/lib/bpf/bpf.c                           |   3 +-
>  tools/lib/bpf/libbpf.c                        |  13 +-
>  tools/lib/bpf/libbpf.h                        |   2 +
>  tools/lib/bpf/libbpf.map                      |   2 +
>  tools/lib/bpf/libbpf_probes.c                 |   1 +
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  20 ++-
>  .../selftests/bpf/progs/fexit_bpf2bpf.c       |  57 +++++++
>  .../selftests/bpf/progs/test_pkt_access.c     |   8 +-
>  17 files changed, 384 insertions(+), 34 deletions(-)
>
> --
> 2.23.0
>

LGTM.

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
