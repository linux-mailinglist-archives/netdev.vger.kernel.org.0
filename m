Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540C6558BB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfFYU0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:26:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38765 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYU0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:26:33 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so5883ioa.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3dXZ1ZldviFyFOVz1FcLJwKSvcaZ1rjNgYTX6/8h5IQ=;
        b=X6YyqVl8grKfhWkl+F5Utw8TrTHiNiBboyq2VqpLQiszWuDZHm0EGVYkSi7KNFcbHh
         sJ0bmiq9v4oDJn5lkdHCvyfBuOK6citsYJGGWMD21WP0IhuQOJ9vDctIGuA29imxU5Ok
         1PvG9vtlWtIiLkZiFjfvNUmDTQCYgZg1qc82Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3dXZ1ZldviFyFOVz1FcLJwKSvcaZ1rjNgYTX6/8h5IQ=;
        b=RPx9n7v1HoPlH/+nSPw8y7QoR8HpbqNtuUYZnuC+ots6THwaEvwP/wLPdV/AokkMDg
         BoH4QlhJ04i7j9tyzKfWm1/Mh823t0ml09ZNB4mEvaMinJ2OKQZjyhIZxHXQ7DcZK0+E
         dwmqy/vTGKkU0JJsXmwuWrN9v+8KFzCCWL/HHBBOb47qbXPr5wn91hnW55ok/G1m75of
         BMbCWUXdX/nVQiqbVTrhYpZ6AoW26inhX8ae0bcKyMvo8IZ1pQd0Mu/+5689Fp0PlijM
         oKX9G8cqSW/Om+T/7CS+yCFlgvpWpEVtFYy0xBNeEJSPYKCDsTLevlZ3yefQyYAzFKIe
         if/Q==
X-Gm-Message-State: APjAAAVnhJkerPMSoxwAKEue49jkLIwzJogOxrRjhkHWPAdMY0nukQRW
        kLZXiDPSFNpH60xHzfLmok1hhtL0fke/Zswu5RVK6A==
X-Google-Smtp-Source: APXvYqw+CW2Mln6le7x4W9V5GIvhL/JhV1LrVv2fcHmykNwbbgpsGnOoW4T9YtXdSwCVPv4OQhW1kAmI1VONvnZYHGU=
X-Received: by 2002:a5e:940b:: with SMTP id q11mr577045ioj.251.1561494392480;
 Tue, 25 Jun 2019 13:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190621225938.27030-1-lukenels@cs.washington.edu> <87h88f9bm3.fsf@netronome.com>
In-Reply-To: <87h88f9bm3.fsf@netronome.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Tue, 25 Jun 2019 13:26:21 -0700
Message-ID: <CADasFoCrWPg3=kchWzJX5vDeymV9wiL7GnPxWDg4rQETyF5TeA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] RV32G eBPF JIT
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 9:45 AM Jiong Wang <jiong.wang@netronome.com> wrote=
:
>
> Looks to me 32-bit optimization is not enabled.
>
> If you define bpf_jit_needs_zext to return true
>
>   bool bpf_jit_needs_zext(void)
>   {
>         return true;
>   }
>
> Then you don't need to zero high 32-bit when writing 32-bit sub-register
> and you just need to implement the explicit zero extension insn which is =
a
> special variant of BPF_MOV. This can save quite a few instructions. RV64
> and arches like arm has implemented this, please search
> "aux->verifier_zext".
>
> And there is a doc for this optimization:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/Doc=
umentation/bpf/bpf_design_QA.rst#n168

Thanks for the pointer. I'll add this optimization before sending out
an updated version of the patch.

=E2=80=93 Luke
