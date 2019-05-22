Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B6A269AB
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfEVSNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:13:45 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:55661 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbfEVSNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:13:45 -0400
Received: by mail-it1-f196.google.com with SMTP id g24so4852235iti.5;
        Wed, 22 May 2019 11:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rz2dSbeGWBZXaCl2XQeKwFmbE5ofP96gu1WBM/jQ9QY=;
        b=QrHdb7Y0Zr/EXrSCRICqA94lEejhJalJLFRVG2+s8TO5eZC6zpTHfkWz3zl5xwVtVa
         myenCPSfFFrFWojRRDBhzg+e1nN7HBvJWhxoQonKCO9096WXSvPENxm26zhcfObQkGhd
         6TmYvOof7I5B0/CBB3I4ZNIv0+tZ4ylFdAesUPPtG7VcHSrO+NwY2ca7rQ06gcRgp+U5
         OvbEfJkFZ2bK7MYxKOaem1RfiwTxzj+ygVyCd3c1qFuS1cVss77jtE3fIyKCNnILjqCn
         PYsmzotO+4WOCQZ8bsoILXlAmq293uKI9U7SoW7JXBfD2wArSvomayx59xuF0AES0pqO
         2YIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rz2dSbeGWBZXaCl2XQeKwFmbE5ofP96gu1WBM/jQ9QY=;
        b=VP10UtGLRpt/JyUzFXubn4W6lqdpj5iVY8i1Bob3oqJrwCZyMl4LxfaB0IX3nrfNPE
         e7k7ATiX8Lpt04spJ2WzmIm3dQGCjL62qFnSOEtJgR/31wJOLt5Cf935jW85gjGnbHNP
         ZLEiET5LclOxTjSc68x9W65eVm2Fi8Si9s+hI5XeipSxq9iQe0BxNIQkOKtqRMM4V+Dl
         jdtstW6u2NchAr/SQkv1F3pH3GG4QzTk7/nG7Z/7RzkpZKcYXFih1I85t3biYZnvZkMh
         /5FQo4yShfpci3Fx+DwZGGJGZs3SshanT3ceAaKBgUl39fI/G031OWcNB8+p9XEdQZZ0
         O2EQ==
X-Gm-Message-State: APjAAAUUjIbQuiiye610VnPQtTxJH/u1rBmGQKe8J2fICrB04lbR9BK7
        0VOjFqcVEaSV8e3FybcqsNJtbR3rRsWKrMYB8A6NQ5A7
X-Google-Smtp-Source: APXvYqw1JnAWO9SKRvsecyCAejnKREejDxDcBfL/zZejo2BiSDSslFQ9/9orfVqPrKyDiilrllvRjj2+JOfBBKNgsiQ=
X-Received: by 2002:a05:6638:390:: with SMTP id y16mr3470538jap.18.1558548824441;
 Wed, 22 May 2019 11:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190522092323.17435-1-bjorn.topel@gmail.com>
In-Reply-To: <20190522092323.17435-1-bjorn.topel@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 22 May 2019 11:13:08 -0700
Message-ID: <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> Add three tests to test_verifier/basic_instr that make sure that the
> high 32-bits of the destination register is cleared after an ALU32
> and/or/xor.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

I think the patch intends for bpf-next, right? The patch itself looks
good to me.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  .../selftests/bpf/verifier/basic_instr.c      | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/basic_instr.c b/tools/t=
esting/selftests/bpf/verifier/basic_instr.c
> index ed91a7b9a456..4d844089938e 100644
> --- a/tools/testing/selftests/bpf/verifier/basic_instr.c
> +++ b/tools/testing/selftests/bpf/verifier/basic_instr.c
> @@ -132,3 +132,42 @@
>         .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
>         .result =3D ACCEPT,
>  },
> +{
> +       "and32 reg zero extend check",
> +       .insns =3D {
> +       BPF_MOV64_IMM(BPF_REG_0, -1),
> +       BPF_MOV64_IMM(BPF_REG_2, -2),
> +       BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
> +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> +       .result =3D ACCEPT,
> +       .retval =3D 0,
> +},
> +{
> +       "or32 reg zero extend check",
> +       .insns =3D {
> +       BPF_MOV64_IMM(BPF_REG_0, -1),
> +       BPF_MOV64_IMM(BPF_REG_2, -2),
> +       BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
> +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> +       .result =3D ACCEPT,
> +       .retval =3D 0,
> +},
> +{
> +       "xor32 reg zero extend check",
> +       .insns =3D {
> +       BPF_MOV64_IMM(BPF_REG_0, -1),
> +       BPF_MOV64_IMM(BPF_REG_2, 0),
> +       BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
> +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> +       .result =3D ACCEPT,
> +       .retval =3D 0,
> +},
> --
> 2.20.1
>
