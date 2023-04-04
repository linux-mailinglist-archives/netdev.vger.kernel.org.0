Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8746D65C1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjDDOvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjDDOvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:51:36 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E687830DC;
        Tue,  4 Apr 2023 07:51:34 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id jl13so23564285qvb.10;
        Tue, 04 Apr 2023 07:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680619894; x=1683211894;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PO4FxWz5e6BRzjqOPAYTsOa8G6RNoNuj13xneo3NBFU=;
        b=aFj07uk//Zp86rAearcFvH4FiCk34+BcvHPEKkfaieaL1DTBsHjsPBLDuJqNdzXf+n
         /1bXdtUqVvRG5bhgf96zVQEz6WJ294U/PrPJCFw1SRH3aPXEfN76LCNiYSQfYxCDoZDV
         PyIfhRwQ5d4h5eJwKfhyMIfPw3N4Qb6q11PT2HpKVt+6wiZCBobSNw8fOkYIlvESRcbU
         Ye+tsqaH1SB4KFuCG1jHgnT6yst9S1d8Jqe8fYwqtPsuodBEhv6tWB5w0OJK9ZlpUF4/
         IBypCg+PNre+yMc1avdHI0bLK1in35qdZ99DnBMx8NSmZXH8yHFvUB+zJpUlvvdQfJKA
         F3Ng==
X-Gm-Message-State: AAQBX9efp4dDfJGBlsx5gjaUV6nIYcZvs/NoWFXMU2j3QZUNxAMvglbo
        2a7JfW4uDhlEWUjvG+vm+CM=
X-Google-Smtp-Source: AKy350bRA+qQ5wcXS/uYL+BmqkXPPLiVFVSyEly8g44nWGEgpJmbpM6yXvZ2eJHSk4jFc3wM1ACTCQ==
X-Received: by 2002:a05:6214:caa:b0:5e1:d616:7b74 with SMTP id s10-20020a0562140caa00b005e1d6167b74mr28346784qvs.7.1680619893788;
        Tue, 04 Apr 2023 07:51:33 -0700 (PDT)
Received: from maniforge ([24.1.27.177])
        by smtp.gmail.com with ESMTPSA id mm23-20020a0562145e9700b005dd8b9345bfsm3459266qvb.87.2023.04.04.07.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:51:33 -0700 (PDT)
Date:   Tue, 4 Apr 2023 09:51:31 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230404145131.GB3896@maniforge>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:50:21PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The patch set is addressing a fallout from
> commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
> It was too aggressive with PTR_UNTRUSTED marks.
> Patches 1-6 are cleanup and adding verifier smartness to address real
> use cases in bpf programs that broke with too aggressive PTR_UNTRUSTED.
> The partial revert is done in patch 7 anyway.
> 
> Alexei Starovoitov (8):
>   bpf: Invoke btf_struct_access() callback only for writes.
>   bpf: Remove unused arguments from btf_struct_access().
>   bpf: Refactor btf_nested_type_is_trusted().
>   bpf: Teach verifier that certain helpers accept NULL pointer.
>   bpf: Refactor NULL-ness check in check_reg_type().
>   bpf: Allowlist few fields similar to __rcu tag.
>   bpf: Undo strict enforcement for walking untagged fields.
>   selftests/bpf: Add tracing tests for walking skb and req.

For whole series:

Acked-by: David Vernet <void@manifault.com>

I left one comment on 4/8 in [0], but it's not a blocker and everything
else LGTM.

[0]: https://lore.kernel.org/all/20230404144652.GA3896@maniforge/
