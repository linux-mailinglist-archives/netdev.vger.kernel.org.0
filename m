Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FD6379BC3
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 02:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEKA50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 20:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhEKA5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 20:57:17 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FABC06175F;
        Mon, 10 May 2021 17:56:12 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id z9so26080070lfu.8;
        Mon, 10 May 2021 17:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUvbryr7Y2ML5a9VE+4dTq/MFRJJThnvdOPPtAJFbMk=;
        b=sdwoHml8mhniVw9lt0dIuKpnuA6LRQZvnd4uBiQUCcz0No03A7CBfqbfax/3/JByRH
         FTO9bQ/XHGJ8liRZVpTXjl7o1+CaxPLNK5MckT+Kg8WJhJIP+R7i9xAvZnxWyVzW8zk6
         ZjacMW+PItYMhropMoGpquSv59zrD839FGjb4DBdl31wMyGpEcc/QW6NMLL29kJqCtjS
         6RZ9+GMfaEI/SLFk8oB6rChPrXGIx5ONgaXUkmwZ7AL96hwakCm/cXuUHkmTHN5qJNqd
         oV5pbh97NKa4ejK+N+w/yegLgMZkRfvbOgBaei9/LFS6v8nKo9zG6UhMnqjZTSce+Rqm
         ewYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUvbryr7Y2ML5a9VE+4dTq/MFRJJThnvdOPPtAJFbMk=;
        b=t+pn0TRiTtdyGGlDXKuTC8jYpauDb+hLF5TpG/bz/wropCM6bz4l57zU3wb512mitA
         IjzsTd8KvgznEcN5Xq2XmjIWLpICFrptf7CG3QD5Tvb+QQSB7eHwzQ1k2poJliUpC9V2
         9Hx+4SHFSkAiLdqDUV9HV8dVWXMdc/MDL2q5RTErbUMr0sICl+ibswBH/H+CoiN++4D+
         RgixvDAa46gQWeAeXBBYwrpi5nJGlnPCI9Jho5JovR0VK+jt+Xj0pOAWKO3HzjifX2RR
         UG+UnV5R2rQU4ZfqrhhWRrOAph+6FiiTO+gHFS9BBwj/ApmSBDhvPEeI+NvGMOMbL4Wc
         DZgg==
X-Gm-Message-State: AOAM530vAiL4OGMldt3CzgL9SoE9hiPZlDKPpNhODBxmp8P6lfNuXKne
        s7MA23HnK14BgF7QkaP4BvwdjsDxrbbbyxatRqnVAMju
X-Google-Smtp-Source: ABdhPJy9U30lrl8HN8sf5fKuRFZsltmISApTIT/TsdgvAe+zI4SJOCkDtSuBCLdF37Vnmrvi4GA/7220UhYgCO1sqXw=
X-Received: by 2002:a05:6512:31a:: with SMTP id t26mr19520484lfp.75.1620694570734;
 Mon, 10 May 2021 17:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210429134656.122225-1-lmb@cloudflare.com>
In-Reply-To: <20210429134656.122225-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 May 2021 17:55:59 -0700
Message-ID: <CAADnVQJXbyB2LR=P9yzTR_OLQjOoCNh7QirQ5st8g7KJKAa6YQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Reduce kmalloc / kfree churn in the verifier
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 6:47 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> github.com/cilium/ebpf runs integration tests with libbpf in a vm on CI.
> I recently did some work to increase the code coverage from that, and
> started experiencing OOM-kills in the VM. That led me down a rabbit
> hole looking at verifier memory allocation patterns. I didn't figure out
> what triggered the OOM-kills but refactored some often called memory
> allocation code.
>
> The key insight is that often times we don't need to do a full kfree /
> kmalloc, but can instead just reallocate. The first patch adds two helpers
> which do just that for the use cases in the verifier, which are sufficiently
> different that they can't use stock krealloc_array and friends.
>
> The series makes bpf_verif_scale about 10% faster in my VM set up, which
> is especially noticeable when running with KASAN enabled.

The series looks great. Applied to bpf-next.
