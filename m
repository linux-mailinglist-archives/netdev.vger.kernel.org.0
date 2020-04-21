Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FAD1B3050
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDUT0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgDUT0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:26:50 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACB0C0610D5;
        Tue, 21 Apr 2020 12:26:49 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id k8so3525772ejv.3;
        Tue, 21 Apr 2020 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idTKxWpEYXSpWMVyn2696fqjJ0Ry7jBlA9LPzj52ir0=;
        b=FSrGDRnziT2sbgdhl+Ig8+exvCHWQV4xq20QWOQWHknyMnYuhzK19fDo+s3GWbBlvH
         ePPjKY3vfs21mKR1ShEnjLfwyPd4PQlI7tqynuAXnRNhGABVpS9in2rWv3B4u4nCS/d7
         CDQncWQC/B5aGHPHmNf7DrwVSC2dg4QuJydV6uUf45pwNzjizDffAJaXlpUnWyq4AUnG
         p2TxW/7s55su2urUvTwWo4j9oCcxUHFCYPquKp0kPkuUkAvGqG6qbC8LbJsvZVnbdB4m
         lU300xJheMMkNe1lTxfALNCmbgAQkeJ48llYhi+FY0at/8RRfmNJRarkni3JL4kHlAd7
         iUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idTKxWpEYXSpWMVyn2696fqjJ0Ry7jBlA9LPzj52ir0=;
        b=X/c0R/R4uP2EMroOYXNvDw+zzEckGd/ErG0V+PoWfWsRJI2eBK88x4Z9STnD15z0CV
         wuU/nlJSsHpJvhl0qJEsP3Nd5E6/ytpRfHVXShjY0hRFyY9cMQr2l+U40GsKNsmzjEBW
         9Mf6IDnRthG0FSZUSIYNMoXY1JSWSOzmC2MnL3DOWVRczsYJJ42yF6/9VCMnNb15AMvF
         40knkWKQ59laNdEjDXBzc606QWi9SDhVLy3Fuh8mkOTnRBA3sF4BVPiw75Aj4b0AzAQ8
         9HHJ1yWzYX+YCSs0GuzXxsfBdViZAjPrr07N+cLQ9w9km4XogqSl7bj20hXlcB+Oc+d9
         pjIQ==
X-Gm-Message-State: AGi0PubruIhgEQTNqV8qcdj7RcEZXihnWgu9NxtPZ5PucRLn93qlUw8t
        OPg/B/WluLbu4dgzAI4VI/qfwynt5YHTYyqHdy0=
X-Google-Smtp-Source: APiQypKbVFuc0+4pupCD+KUCBYs2OqlbXKOSdEObVGiR4iem9xbPhga7MoJS0F3OqoOUgWjD05yzDfNKHMWuH9SuZ48=
X-Received: by 2002:a17:906:54cd:: with SMTP id c13mr21911261ejp.307.1587497208543;
 Tue, 21 Apr 2020 12:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200421171552.28393-1-luke.r.nels@gmail.com> <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
In-Reply-To: <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Tue, 21 Apr 2020 12:26:12 -0700
Message-ID: <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Luke Nelson <luke.r.nels@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 10:39 AM H. Peter Anvin <hpa@zytor.com> wrote:
> x32 is not x86-32.  In Linux we generally call the latter "i386".

Agreed.  Most of the previous patches to this file use "x32" and this
one just wanted to be consistent.

> C7 /0 imm32 is a valid instruction on i386. However, it is also
> inefficient when the destination is a register, because B8+r imm32 is
> equivalent, and when the value is zero, XOR is indeed more efficient.
>
> The real error is using EMIT3() instead of EMIT2_off32(), but XOR is
> more efficient. However, let's make the bug statement *correct*, or it
> is going to confuse the Hades out of people in the future.

I don't see how the bug statement is incorrect, which merely points
out that "C7 C0 0" is an invalid instruction, regardless of whether
the JIT intended to emit C7 /0 imm32, B8+r imm32, 31 /r, 33 /r, or any
other equivalent form.
