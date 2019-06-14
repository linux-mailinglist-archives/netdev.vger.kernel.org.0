Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98DE46419
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfFNQaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:30:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35018 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfFNQaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:30:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so3180485qto.2;
        Fri, 14 Jun 2019 09:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DntVKh71cAcXAwhen75qMYb73XCJSLzYU/pi4+Y/L+M=;
        b=ncoqZgo++4opCF87tFRfjU1/c3CkkZ2I5OmdY+R8RADoMuUPR9lcs2O8eATJjv83b3
         JtBwkYcndRkXcg2kvFta4zFQTYTQYEEf/U9nuH+ebO9dp+xWx9u9Ghh+ADQPb7Oxzli5
         EQWMOBJe4DR3Bs+/6erl31eAcEyvfX1ACF6ZAqcLxxCddJuylTUBBf0rCercZgwgtNDr
         mAl1oU9XVbN5qDqfeuLwLv00QkCvmwXenbSHVuhbfrK9yrL/j+lKzAR9qysRegykbAEV
         fQ+ngYxe7rXcwaMUx46kqxAKIE8KLFUO1O0lFV7TGJsh0L/dGNRu7+sqjEimdia5yDl8
         eyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DntVKh71cAcXAwhen75qMYb73XCJSLzYU/pi4+Y/L+M=;
        b=t3Qunzq9vH5B9e7IZRn7fuZm4VGLXxHxyR19CI8AZXEaEr+TDujxQp3hECz9cd4gfK
         oj9avghyAch4TEaLpp0dPHLmPlEj1Gyzij8tqrHNy2TrPS6dxrsgvXVQC0Rp/o3Wz8ur
         J8YS3ghvHt39z2wuAVAL/b1ZdXFRdetqwit6djSjCKLblpKdlbTF+Ne5Yax6lrY98+Tq
         CbCYOsxCsKhVecV7iIMWK+LMvPKyUhjeyHAXdPaQ2lAs7sE4law1oPNUfrJmXUUgDU1C
         SiBN6HcM4IKV4y4VJiRsyVgfcU2SkN0OV3ifTkedk6weHteiKZoZj7pyGa704oaYd85i
         KYfQ==
X-Gm-Message-State: APjAAAUZUw2PPAvj8dZjdNobVDoe1vbAS4VnICGRvrs9j53/9ITqgVui
        5He78pHJDJa2j6XE1PP2sxXRWQZgKdtWPX03dLUOFuIM
X-Google-Smtp-Source: APXvYqyEON3C+bZTib42wRlVDOtjNXvf0aEUfkMNG9Uok31ctr62mtwTtyY2m+FUj1nM9V21brevBT4bVY51kWG+wJM=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr61732976qtl.117.1560529808508;
 Fri, 14 Jun 2019 09:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190614072557.196239-1-ast@kernel.org> <20190614072557.196239-2-ast@kernel.org>
In-Reply-To: <20190614072557.196239-2-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 09:29:56 -0700
Message-ID: <CAEf4BzZ03j8DkBz0CN+-HbKcxWcHy+woHZKTjJDkq+SkFqD7RQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/9] bpf: track spill/fill of constants
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:26 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Compilers often spill induction variables into the stack,
> hence it is necessary for the verifier to track scalar values
> of the registers through stack slots.
>
> Also few bpf programs were incorrectly rejected in the past,
> since the verifier was not able to track such constants while
> they were used to compute offsets into packet headers.
>
> Tracking constants through the stack significantly decreases
> the chances of state pruning, since two different constants
> are considered to be different by state equivalency.
> End result that cilium tests suffer serious degradation in the number
> of states processed and corresponding verification time increase.
>
>                      before  after
> bpf_lb-DLB_L3.o      1838    6441
> bpf_lb-DLB_L4.o      3218    5908
> bpf_lb-DUNKNOWN.o    1064    1064
> bpf_lxc-DDROP_ALL.o  26935   93790
> bpf_lxc-DUNKNOWN.o   34439   123886
> bpf_netdev.o         9721    31413
> bpf_overlay.o        6184    18561
> bpf_lxc_jit.o        39389   359445
>
> After further debugging turned out that cillium progs are
> getting hurt by clang due to the same constant tracking issue.
> Newer clang generates better code by spilling less to the stack.
> Instead it keeps more constants in the registers which
> hurts state pruning since the verifier already tracks constants
> in the registers:
>                   old clang  new clang
>                          (no spill/fill tracking introduced by this patch)
> bpf_lb-DLB_L3.o      1838    1923
> bpf_lb-DLB_L4.o      3218    3077
> bpf_lb-DUNKNOWN.o    1064    1062
> bpf_lxc-DDROP_ALL.o  26935   166729
> bpf_lxc-DUNKNOWN.o   34439   174607
> bpf_netdev.o         9721    8407
> bpf_overlay.o        6184    5420
> bpf_lcx_jit.o        39389   39389
>
> The final table is depressing:
>                   old clang  old clang    new clang  new clang
>                            const spill/fill        const spill/fill
> bpf_lb-DLB_L3.o      1838    6441          1923      8128
> bpf_lb-DLB_L4.o      3218    5908          3077      6707
> bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
> bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
> bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
> bpf_netdev.o         9721    31413         8407      31904
> bpf_overlay.o        6184    18561         5420      23569
> bpf_lxc_jit.o        39389   359445        39389     359445
>
> Tracking constants in the registers hurts state pruning already.
> Adding tracking of constants through stack hurts pruning even more.
> The later patch address this general constant tracking issue
> with coarse/precise logic.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

This looks good as well, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  kernel/bpf/verifier.c | 90 +++++++++++++++++++++++++++++++------------
>  1 file changed, 65 insertions(+), 25 deletions(-)
>
