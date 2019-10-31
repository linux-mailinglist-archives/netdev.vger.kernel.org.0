Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9AEB842
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfJaUIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:08:40 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45203 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfJaUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:08:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id q70so8318410qke.12;
        Thu, 31 Oct 2019 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIHGBGkRByUbNKcTS1HJ2y+rze5TgM36p6Hcwx2lbUA=;
        b=hkgEr9BtZlF9VVTtz/g/BL60TiKecrtoA5JBegmEcOWPYJOVTzb61uxB8pwYnZfarl
         fB6ES77NdnzW9jDnk4Onvj41WV6nI47vnfDpssIaJGnvl/vtcgLzspoM+QiWf8S/S6pR
         WX16GJWGEW5x6LwzbNvBHoyIBgN8JJCde+eIa4nWleasXQ/qUUncGDFnTrMdxDZr/jpx
         Ar532N7SzcIgUpFgP4kh1jnAJhGwH10sAbow6TUWjRfXKxQxTVrsFg7DeS90INElAXyg
         r8NfluuVgU3KYfS6tdsZ3Mat+nzbFeboUNzdC6lgYVv8cV0LgvsfQ/ANGQLgAZuYV5SB
         Ov1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIHGBGkRByUbNKcTS1HJ2y+rze5TgM36p6Hcwx2lbUA=;
        b=tYxTZDDWz6qQtCHB+g3v7/cLyovYBuBgcfLqYIwauZBUS5gEOpKsKxPW/9f7kgeh35
         iflqm8dPylaELfabkBy1+46YXfX58zwpGq/E3vlPGIHfDOLU3BDHVBiCecCPiiK8vGDY
         3WzdfqiyI2x2SDOKzOj7hGKQ6nd6XhwaOYCGeek1ZQefeFnsxB+zxo+JgGjzGOJ1DSva
         t7SbCCzeq6J+BmZHbNlXDg652OclGyYo8MrvT8CbYfaSyrI/eHlG7JOLeZ5LoNMaT3OA
         IVPwpaJzXH05YgIjFofs/BfyVMUxcs7+qhobpwPUPH1FNYUP8QwQYHqwQEUVJUSd44aF
         1DTA==
X-Gm-Message-State: APjAAAVAfY61KIRXmkUp5AG0KXUCgll6NBlgnkz8zcjJm2Z86RMtq68i
        HMofkhSM61zdb7fcZifKAf8Ql5bmilsQhAyfz7E=
X-Google-Smtp-Source: APXvYqzEBpOrHvI2T8D00kh7ZiL5/T7glgvayI0nzwhpAiJMzMHt96RhTLWCPaUTEvlldFnBicfsV0H7HNoRAZoUxcE=
X-Received: by 2002:a37:a7c4:: with SMTP id q187mr651732qke.437.1572552519570;
 Thu, 31 Oct 2019 13:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572483054.git.daniel@iogearbox.net> <a303d785af09e90779b3e587c4903f5ed415f376.1572483054.git.daniel@iogearbox.net>
In-Reply-To: <a303d785af09e90779b3e587c4903f5ed415f376.1572483054.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 13:08:28 -0700
Message-ID: <CAEf4BzYwJhAcLkOX1uc8_hypr_SoT5A7WnRx-wz8TACWrD9moA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] bpf: Switch BPF probe insns to bpf_probe_read_kernel
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 6:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Commit 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
> explicitly states that the pointer to BTF object is a pointer to a kernel
> object or NULL. Therefore we should also switch to using the strict kernel
> probe helper which is restricted to kernel addresses only when architectures
> have non-overlapping address spaces.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/core.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>

[...]
