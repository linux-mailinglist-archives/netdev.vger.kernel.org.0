Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED79A28571C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgJGDfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJGDfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 23:35:32 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68EFC061755;
        Tue,  6 Oct 2020 20:35:31 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x20so766157ybs.8;
        Tue, 06 Oct 2020 20:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6u/TeL8kvktgTUaqhTVZcjeJjUOD4qYO3AJjfCAQd58=;
        b=kcKXow77f6JcyBvEiqXvKSPCN6tSJLvZx0yJ0cht4oD2eWDcx0yWp3/sUAa/xkG02H
         paX9WNs6+GaNp5FO7DGgAJpNoU1AjqDvkRaoBMfL15VFYuLAl5aTdlGPMeyyx+B0bTLI
         X9TAVpYUcZrwYc1nc2SJnOiOju8JYpJKlTQV7Ogm6BJmu/u4uLv5CdnYs/Dj8gLOmJK1
         Va+sR3/pmdXjHqhqiLr3TMq+sAZattdcRBrjdxqCamRxAq/y2MCAQ4asFUUzIkv+dWpU
         Y7v74q0dMIfTLHrjGPE4p23jLlLIiidEzKA6+g9HOH4nZmZb1dNnl7MyhSa3AjrGEd5W
         LG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6u/TeL8kvktgTUaqhTVZcjeJjUOD4qYO3AJjfCAQd58=;
        b=rYyTVmN00AWF2Rv64068cKN5wzhEhjUm1+0kWsDrwSBfhgYvzgJ851s7ZjUt1XUHn7
         7rP+IvqsBKkkRKjl/nfTr6FQNZaD+jmOxEE1XMTYIlH9g86cChnqW/b/KAxsp5Db0on0
         6uFaX7PdhkDIKgAM1ElE3B8xv0hW4EzDcZ7+zcz6OoBHkkmyXN1Fio5vg1f0rIdxxcHu
         L8maq61tl1eftuW3AHqdBVB7x2neaadFJ8wCp9Mwl1ZClFw76vd2Eke5UvjUR28KoKMP
         fgvoBO5y79mZ2PaD/OoYGwuZg3VN2FrFuDuo0bePjwRCBTqQWf4pmDZwX2kW31K+GpPG
         dYcA==
X-Gm-Message-State: AOAM533Zn98g1osRMDrhIU4J4FoM23nmawhPyfG3cQO+iKRmN2LMoyE5
        mx8O5bZxWS3R70eaKs+u7dTa+zUSEQJNx1cKlRQ/KBsk3xnSgw==
X-Google-Smtp-Source: ABdhPJyIz7mxZbjYHHZHIojdPu0Tr1RSeS1r+D7FxTzD4GY3x+YDkFUgmknIf/0s5kQfBpmjFj202uhsgpkGvmu+ss0=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr1655186ybe.459.1602041731070;
 Tue, 06 Oct 2020 20:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com> <20201006200955.12350-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20201006200955.12350-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 20:35:20 -0700
Message-ID: <CAEf4BzZ-jWrWQPvd7CNOwxhi9s7d6QJq4P+ZoKGa0Pr-0yQ_Vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Track spill/fill of bounded scalars.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 1:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Yonghong Song <yhs@fb.com>
>
> Under register pressure the llvm may spill registers with bounds into the stack.
> The verifier has to track them through spill/fill otherwise many kinds of bound
> errors will be seen. The spill/fill of induction variables was already
> happening. This patch extends this logic from tracking spill/fill of a constant
> into any bounded register. There is no need to track spill/fill of unbounded,
> since no new information will be retrieved from the stack during register fill.
>
> Though extra stack difference could cause state pruning to be less effective, no
> adverse affects were seen from this patch on selftests and on cilium programs.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/verifier.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>

[...]
