Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922B54847A6
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiADSTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbiADSTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:19:37 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DD4C061761;
        Tue,  4 Jan 2022 10:19:37 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 196so32917231pfw.10;
        Tue, 04 Jan 2022 10:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b2EhUOxCKs6rziROIdG8qDACzBoihdnlepJ1sGGPMQA=;
        b=fyapymGWVpZnIAXD/KNEFEz/3tp3LTW8/oCD8mCOCmq7dfoMsFNc2xwxnpBWpQaCnX
         QS2gqNcQWl6rx5173FHiwxfyAY5/98ePwffZ0YvrM6zSgLkYwY70nqo3dMz0RvCOz+z5
         A1MY5IjCp2Y4xceDMo0fyW2OlEpRn81I3MrToYsbNGxBwJ1/f9vTczywxDKrqnRCc1Up
         AvYCf2a8Zx7HZMC6P0HLuMGxdmOVhdOeoTuxs2cCfqjo6JqtW2R/wOSbUVyTyTZmTKxd
         TAMkhB2lS0NbgkZfez1LeGXh9aoGEFqmdv5dWFIT/xhNAEk+KcH/ks0sFyEN2fNYW0GR
         ukZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b2EhUOxCKs6rziROIdG8qDACzBoihdnlepJ1sGGPMQA=;
        b=y6NyoR/Q4qVCfD1ezeKyqt/Kzt8lmDHSi5OzrvkBiiMAhtNR0QiYhTS8Ng+uRpBRXq
         jIsPWNU8fl332NDQKy1j7DJfI1AsQp3N9IsZfoLnm5elLqdoZR8YlNfIQWw6vpSa15MT
         fqGRrSYlVc0FJQRG+poq70KeU8TVAudgJJaXyZge4IPEQx5Zqwonayxoe4MzR39fZpyj
         aludx23Zjv68X6kPiaNIe22luysBJ4xb5vqM/0MI5lyD+0Wzdk5Mi8JvEVPDtqQMbj10
         U6W0dxkcuincmU/ka8GKgVLu9nS63o82bEil1O03DKtmzAXVqwtFmX2Pp9zdl2jHPvs/
         vxiQ==
X-Gm-Message-State: AOAM533Fm77Cbh6dzOzSV2MjMjkhS6nlrJKVlci4nck0kpw0r9f2OzuJ
        faqbAzUY8+o+UJwfI1n9aMu1qIiM6U7uqJdtEcM=
X-Google-Smtp-Source: ABdhPJwX+C/gsltMItc5oiL/7sX3GTDabrztWuLq8W0P8CeVVU9MV8Pwhy8mmpNLPfPr+8kIeH5F4Aq2DcCzmPGTDBI=
X-Received: by 2002:aa7:8c59:0:b0:4bc:9dd2:6c12 with SMTP id
 e25-20020aa78c59000000b004bc9dd26c12mr12468407pfd.59.1641320376688; Tue, 04
 Jan 2022 10:19:36 -0800 (PST)
MIME-Version: 1.0
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
 <20210715005417.78572-9-alexei.starovoitov@gmail.com> <20220104171557.GB1559@oracle.com>
In-Reply-To: <20220104171557.GB1559@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Jan 2022 10:19:25 -0800
Message-ID: <CAADnVQ+MAWVmXoDYx6XOaqbnit2kSE9wx5ejEAW0ZTjrcsF=9A@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 08/11] bpf: Implement verifier support for
 validation of async callbacks.
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 9:16 AM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> I ran into a problem due to this patch.  Specifically, the test in the
> __check_func_call() function is flaweed because it can actually mis-interpret
> a regular BPF-to-BPF pseudo-call as a callback call.
>
> Consider the conditional in the code:
>
>         if (insn->code == (BPF_JMP | BPF_CALL) &&
>             insn->imm == BPF_FUNC_timer_set_callback) {
>
> The BPF_FUNC_timer_set_callback has value 170.  This means that if you have
> a BPF program that contains a pseudo-call with an instruction delta of 170,
> this conditional will be found to be true by the verifier, and it will
> interpret the pseudo-call as a callback.  This leads to a mess with the
> verification of the program because it makes the wrong assumptions about the
> nature of this call.
>
> As far as I can see, the solution is simple.  Include an explicit check to
> ensure that src_reg is not a pseudo-call.  I.e. make the conditional:
>
>         if (insn->code == (BPF_JMP | BPF_CALL) &&
>             insn->src_reg != BPF_PSEUDO_CALL &&
>             insn->imm == BPF_FUNC_timer_set_callback) {
>
> It is of course a pretty rare case that this would go wrong, but since my
> code makes extensive use of BPF-to-BPF pseudo-calls, it was only a matter of
> time before I would run into a call with instruction delta 170.

Great catch. All makes sense.
Could you please submit an official patch ?
Checking for insn->src_reg == 0 is probably better,
since src_reg can be BPF_PSEUDO_KFUNC_CALL as well
though __check_func_call is not called for it.
