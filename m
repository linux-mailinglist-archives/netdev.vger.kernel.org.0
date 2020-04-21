Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AFF1B1B59
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDUBtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgDUBtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 21:49:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9E5C061A0E;
        Mon, 20 Apr 2020 18:49:07 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q19so12225756ljp.9;
        Mon, 20 Apr 2020 18:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2od+tkM159HRcOwmxUHukLIGN2mZccnkjlsxXKj+3M=;
        b=Jp4ZB3SzgudcCBJnAIyIKCFnbfPVC5n8Ur0lvS0s2yekgb5Dv3f1ktZrW2ZBpaog1Z
         AG5bBnX6qi6UsHTXqvW4y7MECtQUI3tE9G5mCt/prRM4mibfBoP64Z+Lb7M4teQhj9BV
         bQevFt57chmlJA1nDUE2TXPryMJ48oe0yVhBv6bHYA1F9Wq/ehOBwKYjvMs8B819GV0J
         F+EAzvZkZvIP5VycWxaUYTn2Tu0sUIhEBHZxh4IVxQQEftEOyE3HKYx2YaCEQHszwQ7M
         cwUqeVTBwBdYbHrc89iMfxh3uxINIZYufE/uZRUiXKM6Xw0JC4ZtgE0sWu0zPFOrmECr
         7tiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2od+tkM159HRcOwmxUHukLIGN2mZccnkjlsxXKj+3M=;
        b=ZrSHec8LP3j+TrxeAjqpM7oQ+sxKhNajUoDccD30OoggYRRTcp73pC3+zvtYJ5VsdK
         dW/a5dVKIlGerPG3ou7TwdxTaYzGX1+uirYZ2CAX9sENoAgcjq+Khu3naIneU2cJwH4V
         r0tsrW2YtcA85lzRfj9zADlx0TM9D17Uvm7KO4dTuYYyiLorcLAu6bOseW3G7U5P1qJ3
         6Vka1kMMAeXeCLsKeAQQh99LdFzS+gaiawGPFpyE+Du4D9xy3PlnxCFWIhJynrWOkWaW
         /yOl1tgydeFRyClXF5dOBVJSVYZbrOtSc4Q37htQLqDYtfRC7VzatB0eYqFMMEd98SQf
         sQEQ==
X-Gm-Message-State: AGi0Pub/Zan+kDxgl38dfJImxH0LsU/ZsNwCOV8YhV7VezjBALEQ++GO
        TfkhTCGNhqkavbvSg9zl+Zo+oThSSuIKNRs3BTk=
X-Google-Smtp-Source: APiQypJVntxl0em9kojlMUJwKY+tbj4KjZSvt0b5fZ6xDZrB0kqkz4L9LmJj/4d0TSG22gyTh/9rqGal0BrCvsDxCk4=
X-Received: by 2002:a2e:b4c2:: with SMTP id r2mr7347202ljm.143.1587433746231;
 Mon, 20 Apr 2020 18:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200417000007.10734-1-jannh@google.com>
In-Reply-To: <20200417000007.10734-1-jannh@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Apr 2020 18:48:54 -0700
Message-ID: <CAADnVQ+0U5K_ySgHcM-o6mbq-mcntA4XrRJe9QVHc0fUj2f2Dg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: Forbid XADD on spilled pointers for
 unprivileged users
To:     Jann Horn <jannh@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 5:00 PM Jann Horn <jannh@google.com> wrote:
>
> When check_xadd() verifies an XADD operation on a pointer to a stack slot
> containing a spilled pointer, check_stack_read() verifies that the read,
> which is part of XADD, is valid. However, since the placeholder value -1 is
> passed as `value_regno`, check_stack_read() can only return a binary
> decision and can't return the type of the value that was read. The intent
> here is to verify whether the value read from the stack slot may be used as
> a SCALAR_VALUE; but since check_stack_read() doesn't check the type, and
> the type information is lost when check_stack_read() returns, this is not
> enforced, and a malicious user can abuse XADD to leak spilled kernel
> pointers.
>
> Fix it by letting check_stack_read() verify that the value is usable as a
> SCALAR_VALUE if no type information is passed to the caller.
>
> To be able to use __is_pointer_value() in check_stack_read(), move it up.
>
> Fix up the expected unprivileged error message for a BPF selftest that,
> until now, assumed that unprivileged users can use XADD on stack-spilled
> pointers. This also gives us a test for the behavior introduced in this
> patch for free.
>
> In theory, this could also be fixed by forbidding XADD on stack spills
> entirely, since XADD is a locked operation (for operations on memory with
> concurrency) and there can't be any concurrency on the BPF stack; but
> Alexei has said that he wants to keep XADD on stack slots working to avoid
> changes to the test suite [1].
>
> The following BPF program demonstrates how to leak a BPF map pointer as an
> unprivileged user using this bug:
>
>     // r7 = map_pointer
>     BPF_LD_MAP_FD(BPF_REG_7, small_map),
>     // r8 = launder(map_pointer)
>     BPF_STX_MEM(BPF_DW, BPF_REG_FP, BPF_REG_7, -8),
>     BPF_MOV64_IMM(BPF_REG_1, 0),
>     ((struct bpf_insn) {
>       .code  = BPF_STX | BPF_DW | BPF_XADD,
>       .dst_reg = BPF_REG_FP,
>       .src_reg = BPF_REG_1,
>       .off = -8
>     }),
>     BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_FP, -8),
>
>     // store r8 into map
>     BPF_MOV64_REG(BPF_REG_ARG1, BPF_REG_7),
>     BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
>     BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
>     BPF_ST_MEM(BPF_W, BPF_REG_ARG2, 0, 0),
>     BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>     BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>     BPF_EXIT_INSN(),
>     BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_8, 0),
>
>     BPF_MOV64_IMM(BPF_REG_0, 0),
>     BPF_EXIT_INSN()
>
> [1] https://lore.kernel.org/bpf/20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com/
>
> Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> Signed-off-by: Jann Horn <jannh@google.com>

Applied both. Thanks
