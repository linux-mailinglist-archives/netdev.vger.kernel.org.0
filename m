Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58708D8449
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbfJOXOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:14:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34250 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfJOXOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:14:35 -0400
Received: by mail-lf1-f68.google.com with SMTP id r22so15832012lfm.1;
        Tue, 15 Oct 2019 16:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNbYu3/4YIpMssRL+g280kmE2CZxZyUO5nIOwnsjYWw=;
        b=PwtnllJSJrx/VZH9bAPCGfjMbAcxTHxR47lAw0O25l6U+LoQq4fqAODJ+Exl+n/7h3
         XYpRjlO78mvSkWzcRvtN32ADrmoCLkrNhQi5jYp8bmc6p0R5xW5+4Nllu9jpB9a5ZeM0
         ktzldN0vFKFwp8p0OToiQhOqpf6CkDA051b0iFe8I+ndnLPfSi9u1sLtD4WS1xeHkfCS
         eFgbgSO3ka/Z1laNOI/zJ54cy1mmuWp1QSc2UZQMO5UnZzZSaGpY8Ni5l6V6NH1TB+u/
         kiCuPvN9Uc7iLxPgGZozSCRhiOUFfPNTEjv2y4f1/jRpyIvYH4daKpXJhCdG2N69qr52
         otog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNbYu3/4YIpMssRL+g280kmE2CZxZyUO5nIOwnsjYWw=;
        b=WPxl1yttSxJ3FbJzybbbxCl/avfOJFaxQQEtVXBG2yKdkmiu4a3GpHOSkveutTNP7Q
         7GtT1Ygl+JJUnrKrRiSTSQdxvidR3ja+p5R2h/jLMpRK0gMzDO8kBv3YxlTsGn+Zk6lZ
         rYaz/pOsBFqpYUd/f3rTGVbGbLAY87hHVnof+3tgUv7ok+Z5UuGSpE8RHgdTZopquhXY
         AFmrNGw+Fs5M9C0jcOEwOYbJBEksvWeYdJOsL1INireZXE+ZG2DHktmC8Z1pdNzsrCNU
         SJPIO4ryEbNNbFasqc1LW9DCIl+zR4SlWIT+mFUTezQ5p5SE2LAMF5cqPwOyft+U2R2X
         kPTg==
X-Gm-Message-State: APjAAAUr0EaE1WM2NKSH+PldWCpXTPpt2ECtDhExwtkb22ybqg/zkIyd
        8REStrX8hxOTblnOCopBFxxxDJtPGF1GrSt9l+E=
X-Google-Smtp-Source: APXvYqy4blYbWbBQqGYRZzS2yCTW4Zfov22xeyFQ6W8TMnPTMFBkgtYsKUtEgABregV2/SaEjEfnRl/P5vRSp5ztMZQ=
X-Received: by 2002:a19:4f06:: with SMTP id d6mr23497796lfb.15.1571181273128;
 Tue, 15 Oct 2019 16:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191015182849.3922287-1-andriin@fb.com>
In-Reply-To: <20191015182849.3922287-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 16:14:21 -0700
Message-ID: <CAADnVQ+m_TAbo27QSEk1MeUsprtUE9HLzF0QwSFGxVfNrjRd0w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/5] Add CO-RE support for field existence relos
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

On Tue, Oct 15, 2019 at 2:26 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set generalizes libbpf's CO-RE relocation support. In addition to
> existing field's byte offset relocation, libbpf now supports field existence
> relocations, which are emitted by Clang when using
> __builtin_preserve_field_info(<field>, BPF_FIELD_EXISTS). A convenience
> bpf_core_field_exists() macro is added to bpf_core_read.h BPF-side header,
> along the bpf_field_info_kind enum containing currently supported types of
> field information libbpf supports. This list will grow as libbpf gains support
> for other relo kinds.
>
> This patch set upgrades the format of .BTF.ext's relocation record to match
> latest Clang's format (12 -> 16 bytes). This is not a breaking change, as the
> previous format hasn't been released yet as part of official Clang version
> release.
>
> v1->v2:
> - unify bpf_field_info_kind enum and naming changes (Alexei);
> - added bpf_core_field_exists() to bpf_core_read.h.

I'm not excited about duplicated enum definition for libbpf internal
and bpf prog purpose, but it's a lesser evil.
If we do new .h now to be shared between bpf progs and libbpf
it could be too early in release cycle. Both libbpf and llvm side
may still change. So let's make a note to clean it up later when
we're sure on numbers and whether numbers will indeed be
the same in .btf.ext and in what bpf prog passes to llvm.
Applied to bpf-next. Thanks
