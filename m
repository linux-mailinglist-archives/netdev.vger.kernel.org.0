Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABA721C1DE
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 05:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGKDZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 23:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgGKDZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 23:25:33 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF66BC08C5DD;
        Fri, 10 Jul 2020 20:25:32 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id m26so4248591lfo.13;
        Fri, 10 Jul 2020 20:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qMSo4idQH+SPolfM98YFV7hZJ7GyfP1j4WcHly2pXs4=;
        b=kFppbPfk+savvEEL0Loyoeq/o5y44V6OUOniX62nrHyX0cM4sjGVvwDLsNaJ0xiSkQ
         hwJqPo0TolwPpTVTMPbxe1wkl8oJJX99iQbL9ePTIdmJG5alXjHwEURzx2eDvDb6qrHT
         ZGxo4jRfRGggqg4NHG4kxDyDd8/YDMpbZVt5GFFNbvFm+8tM2J6fX8Cg23YMsH4O6JA2
         8FwkS3sCSsiIkuZjMWooI6AFHsFMyF4daMnVUgxRRa0Rf9vXeZdrD9a1FwG707a93XZK
         UbRHVyAHGx8z7MBXGfqqwqUX5quBApSE5/Y5ec8gqaW3ApeMjgMEiHQyaRnBerPKGDnW
         B3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMSo4idQH+SPolfM98YFV7hZJ7GyfP1j4WcHly2pXs4=;
        b=fUNjoPJ5LOwpzEKLRawDFpoVfaQ8mVNp6TeldxVZdny9Iv5xinvGq1GlbGSbVGMvio
         jXvO3AYBQWZYnOHnxmlwGCIBW2GxUlTGdwJJHaB8Z7zu6+/m/ItdnWFKmlx8A3KRUzOm
         oDN2nSNVfNOhbGdhZ11HqjfCy/R40v5GI2f5nDxCPaRnZRis46WN4G2IttgNWvr/M2cc
         gs78/QgHz1zZEOHNkimoYXszrvdf2uaqGZhsoYtnOqSKD54Uzn5UmKPezZZ1PEV6xxMW
         jsCYsb8OlJGjYgEH3C481PqvjHQQo9sXExRes8fiEG9MJrSSLRKILkNWFPiylpU+fnv7
         vUUQ==
X-Gm-Message-State: AOAM530cDbYQKgJcd+z6meujGV7Lh5UfJL1i8/ub9qvgS8o5BoDRBgj6
        Jr5JcESuG882UaHrD+/SWwKWTShOOv9rohVAFV4=
X-Google-Smtp-Source: ABdhPJx59uupfoWI7HifdlqkGoPMj0WN4ZOO3ig2kf4z7rMgwChaH4h/hLf0ccw8eBMXP5AiHrpw1i/r/HZKD9W0Vqo=
X-Received: by 2002:a19:8497:: with SMTP id g145mr45076237lfd.73.1594437931323;
 Fri, 10 Jul 2020 20:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com> <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
 <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
In-Reply-To: <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jul 2020 20:25:20 -0700
Message-ID: <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 8:20 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Of course you are right.
> pop+nop+push is incorrect.
>
> How about the following instead:
> - during JIT:
> emit_jump(to_skip_below)  <- poke->tailcall_bypass
> pop_callee_regs
> emit_jump(to_tailcall_target) <- poke->tailcall_target
>
> - Transition from one target to another:
> text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> if (new_jmp != NULL)
>   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> else
>   text_poke(poke->tailcall_bypass, MOD nop into jmp);

One more correction. I meant:

if (new_jmp != NULL) {
  text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
  text_poke(poke->tailcall_bypass, MOD jmp into nop);
} else {
  text_poke(poke->tailcall_bypass, MOD nop into jmp);
}
