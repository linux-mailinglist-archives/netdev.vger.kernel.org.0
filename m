Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DBED47CE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfJKSoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:44:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44826 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbfJKSoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:44:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id u40so15226114qth.11;
        Fri, 11 Oct 2019 11:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p1zwy379Xd1ZsxRCXrcmpfIKrkDCKyoO59F3xxY8wdA=;
        b=HfCl9Ot7V6LI+HV1kxq3gBkNCgHvscMD2K1VAxoIknEGTvtHw5l1w4v/RsjE3ovx0O
         aWyW4AuSkXGO7ekeidtUZHnUODjZ31SOWCfiqHzvlvULNRxnvoPqqcu6T2tBpmReHZcJ
         Qcncj7wQ/NXhbRBxNSsF73Rj8VKuiQbS10m62qD9F4sW09BufYvYjDRfJjzg3viDdeH+
         au8YkTBZmDW5Gv5ol9kklCTeC00vbi2qRapvkJANGVkbsMXv+/YIXAiMeayyuPneu0Hn
         PIz5jH0iKR0Y/E/qJjqamMree127cPNKL+G0A2jsHCXLHpJ28h0vRUzVVD4y5J9n4yRo
         LwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p1zwy379Xd1ZsxRCXrcmpfIKrkDCKyoO59F3xxY8wdA=;
        b=ttelcTUn4wHnimpz4cH8VORT7sL1NuaAyKsZZ7MDG6ktkDs5xHoHWME0xkh697eLE0
         /7bvlhnzthw86R01bTz+8yElEf20YXqFa20LDBt9fa1LmVd2VobglJkKWwTRLMeElmm6
         37o07olC8WJTilzNmbT3fbk6hAWq0TyPt/Mj6eNGdv33KRfX6iueZ5iU+ArvO82Zom2S
         CYEItFMxm+eh9LaH7ptIovdzD5CcmVR43p+/ea+3buwSHqPun7cJmXk3qCyYa8F0wsBi
         ShcnloSKz1QnGWtBIP7REnolom059ZQy49snVFHv5Tevc4e0R9EMDUOf4l7x/1zRixeW
         eNKw==
X-Gm-Message-State: APjAAAXANDFRa2gn2pkF7D12dBPKoLX9ZImKW/SX+b/9SBMS2HBawY7I
        eLqtk3WJ0jPSKDeoja+D5DPUH6v7K3IcTIdBUis=
X-Google-Smtp-Source: APXvYqzBbvUjSNYropU6h5fTcU0CRzvVttwRkNs3gnhDltbOCKV94T/is71ljA+UUZ0SgtigqvMYTqLBH+HqIcE5ewk=
X-Received: by 2002:ac8:1242:: with SMTP id g2mr18242268qtj.141.1570819468920;
 Fri, 11 Oct 2019 11:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-8-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-8-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 11:44:17 -0700
Message-ID: <CAEf4BzbKK_4F5QVXXfkqvL4WABcnMV79XQKPTt=6HF18JBkiWQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 07/12] bpf: attach raw_tp program with BTF via
 type name
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

On Wed, Oct 9, 2019 at 9:16 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> BTF type id specified at program load time has all
> necessary information to attach that program to raw tracepoint.
> Use kernel type name to find raw tracepoint.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/syscall.c | 67 +++++++++++++++++++++++++++++---------------
>  1 file changed, 44 insertions(+), 23 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b56c482c9760..03f36e73d84a 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1816,17 +1816,49 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>         struct bpf_raw_tracepoint *raw_tp;
>         struct bpf_raw_event_map *btp;
>         struct bpf_prog *prog;
> -       char tp_name[128];
> +       const char *tp_name;
> +       char buf[128];
>         int tp_fd, err;

Shouldn't there be CHECK_ATTR(BPF_RAW_TRACEPOINT_OPEN) somewhere here?

Other than this pre-existing issue, everything else looks reasonable.

[...]
