Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADE6D70AF
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbjDDX34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDDX3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:29:55 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AD1171A;
        Tue,  4 Apr 2023 16:29:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eh3so136728303edb.11;
        Tue, 04 Apr 2023 16:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680650993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lyNm5fRe9Qqf1NA929EHONgNw/nkK0iIgK/vHWE7UNk=;
        b=hr7G0Y0TLoHW+82443tb1U4UmTX1f1J/QBUNLR4xLR0sQUkAek+0PMQTAfMLdfsCbP
         8Rb/qS5R9VYknRXFqDeCZqqo/2U7MDQIaDnDdpY8Nuv7cUdCXM7GDwdTWyHMSqm62gah
         6YHBMfyR5MSwR3a0bbZOti+SG7VNNZ5nW5229rEMek+r35cP9ufCdbq8kQ0D8pLOd9+g
         yoyCYJ9Q2txkIPLAb6F6opoWfkcgCb6uSrMMzEAXoFQyc9EhvujUKtNK8kZY5rGPYSuA
         HPiZ6SGC0BjnO4SNFcgx+gQFT4DxFXrXVYkUCXsuHF9Nf8gCMZb8H7yvrVvGYsGRsU4k
         yYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680650993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lyNm5fRe9Qqf1NA929EHONgNw/nkK0iIgK/vHWE7UNk=;
        b=OKp9/mmiyxDWBIPqaIWt0/IauWLZ1gTkS3aQLl+dgRypASmMetoUnlk+OcsFgI4p0b
         iPlVuXCcHh/v4tGPqRzn6rS7b//sagfjR2BO2aI/e4Y+qKfdB0bO0hOe5WckvcRGUCEu
         sCiwHq828METzTXSfrs0/kw8VdmxkFfTdwkIlRXI7CTeQju84u3SoaY89MVSW+EhRHm3
         /lZeY71IzHsj+12wrGvDMm5kj4oGKuAu79mp5/ceM8WgqnOM+59ZSBvxiTa7Bv2s0uM9
         dT9RfZ42gdeKkvIx5oMA8Y8+zlAE3/wPLlhGX34X+LEm1OXDq9ITRubsuuE92HhtK7CK
         iYxQ==
X-Gm-Message-State: AAQBX9dx+JxBTNUiHI2/mIpF3LMuCSNAYHsYa7XZBpq1Z/JyWnplvHid
        GeQgDIVylkrXcP3p53InmuUWB8mZdvUu1L4XFm2IUiDg
X-Google-Smtp-Source: AKy350Zysgg1QayCEws6Upa/1W3EAm4WWjRLW3O2LcNREc1vC903Bdk4aC8Z6UFK4BnCPGBSF+1XApOfAtuCsEeNXbc=
X-Received: by 2002:a17:906:25d9:b0:931:fb3c:f88d with SMTP id
 n25-20020a17090625d900b00931fb3cf88dmr627000ejb.5.1680650993177; Tue, 04 Apr
 2023 16:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com> <20230404045029.82870-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20230404045029.82870-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Apr 2023 16:29:41 -0700
Message-ID: <CAEf4BzY8nbE70EqKXn4A9p8b_oCW1UaaifOu6xAyqbN-usLYYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/8] bpf: Invoke btf_struct_access() callback
 only for writes.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 9:50=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Remove duplicated if (atype =3D=3D BPF_READ) btf_struct_access() from
> btf_struct_access() callback and invoke it only for writes.

It would be nice to elaborate a bit why this is ok. As far as I can
tell, it's because custom btf_struct_access() callbacks are only
checking and overriding write accesses, delegating reads to generic
btf_struct_access(). Is that right? If so, can you please note it down
in the commit message?

Further, given btf_struct_access *callbacks* are now write-only, while
we still keep generic btf_struct_access for reads, should we
distinguish callback's write-only nature by renaming it to something
like "btf_struct_write_access"?

>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c          | 2 +-
>  net/bpf/bpf_dummy_struct_ops.c | 2 +-
>  net/core/filter.c              | 6 ------
>  net/ipv4/bpf_tcp_ca.c          | 3 ---
>  4 files changed, 2 insertions(+), 11 deletions(-)
>

[...]
