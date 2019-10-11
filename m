Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7ED471F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfJKSCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:02:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40939 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfJKSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:02:23 -0400
Received: by mail-qk1-f193.google.com with SMTP id y144so9681384qkb.7;
        Fri, 11 Oct 2019 11:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uvH3zY9Ae8PjYb+2rs975M3jIPTWD9fTgVebSjhl8Gg=;
        b=vEJqWBNEmB843DiuzdKWPesv8Ml7DKLPjHslfLuFRBy1IEZhRo41prZpJTSIwpxkQg
         7H3rvA/Ps8X/xM/oaciRY4/Dxluyj8MQUZPHjlIWR6dCdzoBdkveGmXdYlCah9LN45FG
         FOUwB9vOGJuhyZKEij3SOlUTn3B1PHa23NRz4lrC7FUOgOOZFQFP1ux801AeQjTQdS75
         2XwrWbO+1MarMi+xSl2YalER+fxiLn1gYDvs6EznBYigfaH2AEV4j0qYK53xvG7FaOeR
         ehlG5tttriCRYJHjHegSMVQSaaGasosSN5ft9afcnaiZ4wIgy8BLkxkkqnZOJygsufzm
         S9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uvH3zY9Ae8PjYb+2rs975M3jIPTWD9fTgVebSjhl8Gg=;
        b=lpNRc+sy7jHP1qhZ7YCFqf7iN6w+G7ytt+YowhEIHJFxv72CvBPRGMyRu4n6ji+7WZ
         FotPal8FaYqHMVHMHK/jatg+6TWDTUXL0Ev3WNw5aL7Kx0CaH3s0oCKgOvLoGWfgavSl
         rxI1klxmbGFX0YVoqCN7Gr4VLEYdAotQ9SPGLjks6lbL2DDSSlkZybABxsMqbdXAlvox
         JrKnjyopIQTrpUg9sDdf5V03UsE7jnhSp20apb1NnsiBdricXh7So06B1v5r3ULOfyvi
         MQ7QqVwVp/ABnwVRACQp1/geK5kz+SpCBolTLwUC3bmaQydfsfzmRuFAx7kO+gE9X7GK
         DNPA==
X-Gm-Message-State: APjAAAWmGSUv+a0Vr5wX/bkQgNYhPwTsC/zg6O4/D8PseW5ZTn/DmXoe
        xIpqrvk7EFH8Ro3wYAqrPglkHo3Za00dxIeKSHY=
X-Google-Smtp-Source: APXvYqwxzWJeWi+LP9Xc3LgWNadrLwpMIaZZwzVIDpH+GTm7+bwF4MZ80e06PzjgfulCdPEfS7hGaDLK6s18M8E7Qxs=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr17426523qkc.36.1570816942674;
 Fri, 11 Oct 2019 11:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-6-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 11:02:11 -0700
Message-ID: <CAEf4BzbONBDhK6WEMYEoz1JEcXR1tzNXPTq45fvWdTPKEjdyVQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of raw_tracepoint
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

On Wed, Oct 9, 2019 at 9:17 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> For raw tracepoint program types libbpf will try to find
> btf_id of raw tracepoint in vmlinux's BTF.
> It's a responsiblity of bpf program author to annotate the program
> with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.
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
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c    |  3 +++
>  tools/lib/bpf/libbpf.c | 17 +++++++++++++++++
>  2 files changed, 20 insertions(+)
>

[...]
