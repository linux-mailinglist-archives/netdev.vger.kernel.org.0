Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C955E425F6A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbhJGVrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238388AbhJGVrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 17:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722B7610A5;
        Thu,  7 Oct 2021 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633643123;
        bh=IiXHmllhgtLcTaMie75VixyGzoE0d1kvxpaKw5zKFvA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WCB8AYJLx1LVHJ2nWbIDHGRaEYbWIQwMXnOviOB0CKo2GdvkrgYXW6g2cFAK1iegB
         SR9RlUePa7Xoru6rPClskquRoQh9aEkV6cvTVGlII/VqZDA4LHR8St0Ir3hUWnYaTK
         3zyRX1WSgewkcTVbQZa2Vk0QYlbPkCdGNa90f8QgpeSOFQH0QqQmFIamEAexpWLkYk
         ug/Kq5uTUNSbOLTSzK0R61VziIXAB9PuTLMn+0ado5v1xMmKKsbBjkoPISjKeFOWWn
         mRMCjk7Xbmfgry5Zv0cBGumgvbwm+pzuabbXhI1MM1V7nkqFgGwdjLcA9oiGggoe2M
         kMsNLEGjpUtVw==
Received: by mail-lf1-f43.google.com with SMTP id x27so30551187lfa.9;
        Thu, 07 Oct 2021 14:45:23 -0700 (PDT)
X-Gm-Message-State: AOAM531BBFyg3XuKCN9TWlv0wN0Bv4P26eVBPBxIqCxo7iJXcgrSXJqu
        ms7R2ZgXsaMyaRM64oBcJlLYpjIMpZWTI1Z22j8=
X-Google-Smtp-Source: ABdhPJwypEi4urk4BUf4ZvQInSz8CerJAcOnVYNylWrbHu/lZxyzaqcFhFFUUcCdwSDp4GwmUOQt0ER+ETELNUY7j3U=
X-Received: by 2002:a2e:b545:: with SMTP id a5mr7026950ljn.48.1633643121756;
 Thu, 07 Oct 2021 14:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-3-memxor@gmail.com>
In-Reply-To: <20211006002853.308945-3-memxor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 14:45:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6nCQK71aeyR1YthvMWGNgH--RwbLnA0_rhi071juTsYg@mail.gmail.com>
Message-ID: <CAPhsuW6nCQK71aeyR1YthvMWGNgH--RwbLnA0_rhi071juTsYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/6] libbpf: Add typeless and weak ksym
 support to gen_loader
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> This patch adds typeless and weak ksym support to BTF_KIND_VAR
> relocation code in gen_loader. For typeless ksym, we use the newly added
> bpf_kallsyms_lookup_name helper.
>
> For weak ksym, we simply skip error check, and fix up the srg_reg for
> the insn, as keeping it as BPF_PSEUDO_BTF_ID for weak ksym with its
> insn[0].imm and insn[1].imm set as 0 will cause a failure.  This is
> consistent with how libbpf relocates these two cases of BTF_KIND_VAR.
>
> We also modify cleanup_relos to check for typeless ksyms in fd closing
> loop, since those have no fd associated with the ksym. For this we can
> reuse the unused 'off' member of ksym_desc.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[...]

Everything above (trimmed) makes sense to me.

> +/* Expects:
> + * BPF_REG_8 - pointer to instruction
> + */
> +static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> +{

But I don't quite follow why we need these changes to emit_relo_ksym_btf.
Maybe we should have these changes in a separate patch and add some
more explanations?

Thanks,
Song

[...]
