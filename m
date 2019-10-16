Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7E3D9A6F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394575AbfJPTt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:49:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40509 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfJPTt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:49:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so23931413qkb.7;
        Wed, 16 Oct 2019 12:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZ0SnN3T8hPOf1bT1GNkg1/0lDYAlxkqiGjN7zWKgMY=;
        b=Lr27k3L6karmArNq0cegl1t8UYoeLELEqtSK51qFTyfbr1SEjaynFfdoXdWlNcN7zi
         oWiMUmUhkz+wt5DMpRDifTVkpynRKUy3NURKdo/3BdJUoCgupSv/WyxS8k8Oa8ITGBjE
         bs2oL9BAIdwmCCNo3cIDMY2QEF0uNgxELe3chTy5eFvJOrzK1Hx5gsGMUuLGWVskFaLA
         Xxe5BInWHo4F4TPIFq/U4W8H2qmTlhsDcMVQnbR9Ci3qIBh1tYvlnr95kCu/dvkHAuW+
         fakB3l05t35DLCJHkHPxuMMl0FzCFKRXoserhET75p1w9mgRleCUacnIsGc01JPWj3+Y
         gaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZ0SnN3T8hPOf1bT1GNkg1/0lDYAlxkqiGjN7zWKgMY=;
        b=e4C+7ykFxy4uDJipoRAC1m/kT3KxOS81YtrKfP3R41HmTwHR3nFO4imXqjaZKQ+kSg
         HD4miGHGCtU+g0cU0xjn+Bz828zppSUij9kma2pfulc42GEXHo8nyxZB5fjp3sCPONlM
         v3a2xdwDBnNsxIzIQ7yY4MLdOsqQ7R/kkNtV07t259hoidtJTQ37ugYaqpoMQEAYfZEA
         N6CofdvTc4h553LtyixJC7GeNYpqMqXv7bJLhVCH0tclZKc46q/vtjS33XnC1MK3uby/
         cYDfXP1p2ut5o/mNqvRkWeSVeqMtLDSx+7v2ledJnCrVJ31arDqYmpL74/5B0bdDGfBq
         TtEQ==
X-Gm-Message-State: APjAAAUC82FdQCBz7PPfL40KRaiP5kDqHZcPlJauMKO6J+N4AJxW8NY8
        aDxwq0C/bBXAKbgCRdZRiqUHQUnI3v42PlXjWXvRGG3/7AA=
X-Google-Smtp-Source: APXvYqwcmSvNANMLZ+lOi0np7iQm5NATIJ6Aur4BnhqfXQ/GtAzw6IzhxGejJnb2MSIKRWFoysvibrQNr8XumdGI2Ts=
X-Received: by 2002:a37:a8c8:: with SMTP id r191mr42133713qke.92.1571255394588;
 Wed, 16 Oct 2019 12:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-6-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 12:49:43 -0700
Message-ID: <CAEf4BzZe8qQ-04uTHWBiYGVqCbRrJzt1C0Uw_AZARtqOTOEPUg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 05/11] libbpf: auto-detect btf_id of BTF-based raw_tracepoints
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 4:14 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> It's a responsiblity of bpf program author to annotate the program
> with SEC("tp_btf/name") where "name" is a valid raw tracepoint.
> The libbpf will try to find "name" in vmlinux BTF and error out
> in case vmlinux BTF is not available or "name" is not found.
> If "name" is indeed a valid raw tracepoint then in-kernel BTF
> will have "btf_trace_##name" typedef that points to function
> prototype of that raw tracepoint. BTF description captures
> exact argument the kernel C code is passing into raw tracepoint.
> The kernel verifier will check the types while loading bpf program.
>
> libbpf keeps BTF type id in expected_attach_type, but since
> kernel ignores this attribute for tracing programs copy it
> into attach_btf_id attribute before loading.
>
> Later the kernel will use prog->attach_btf_id to select raw tracepoint
> during bpf_raw_tracepoint_open syscall command.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Great, this is much cleaner approach!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c    |  3 +++
>  tools/lib/bpf/libbpf.c | 38 ++++++++++++++++++++++++++++++++------
>  2 files changed, 35 insertions(+), 6 deletions(-)
>
[...]
