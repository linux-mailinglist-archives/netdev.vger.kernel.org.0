Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753E31D64C9
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgEPX7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726730AbgEPX7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 19:59:35 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BF1C05BD09
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 16:59:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id l19so6042355lje.10
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDEHZY/PsMR8qXioVOkwgQjNCpyRlOPlYpF92vL83Bo=;
        b=P54OzxSpbB00QNa1Vl9WFApqmqJ/4B0rUpbBMDMmPsI/C8A9uvrD4Ks0sH03/n/Ea8
         TthdS9fKbtNSBKevVXQXJ0hQwN1Cr21r0DS9ympS50RYBG6qN73K0ac9Z2luaU+W0UJb
         Ib5zltG1UqMylh0kpknA01DYSc+lcNyz7Vo8L7ukwpSfgXHUT/ABT/xtEvzvHa6ZPO7f
         hVftgDHyQS+Qwumq/NzRXEypHe6LQAniqULJKgLzOb5VrJTE7ftIzqSwCXiVzZWL99Zg
         ckBhnhbDgCDabIapMZtrwe2jd11elo2NxMB1KnXMCzE2KXPlETdMkQs44AO7W4+LaHzv
         y5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDEHZY/PsMR8qXioVOkwgQjNCpyRlOPlYpF92vL83Bo=;
        b=BLvB8Cm3OFNMkTUn+MkdFv4EXV58ocKwQvipHuzYYZwv2tNdUigBXLTHd0c6WxLpdm
         OZeiE6tBxdDl8nEnbgn5ALJ5u176h0n3lSikqCVq9qHyIeXR6cTDcxkk7ZfvAgyFGvW8
         zV0pDwzNvg1q0YzOjyceycZV/5VMjraTFvoBxOCpa1YgcaHXbXHBdW0/iDFNwkgh038I
         FRKPZ9gxcpYJNRv7CNF2/ohzCCGnSkkrJMFmm9IE/1jtg3qB38XTtNHf7Tfjog8wJ3IR
         gKaGgYA21blo76DRxITUih9fyThILES65reZ0454ziultdXUAwrJEESwq4Qt2N4YJ/Kj
         TCAw==
X-Gm-Message-State: AOAM531HwrW/oDTP+Nbm696hSWMEdj57U6oyaCLUxQmRu+NKnB0YsA+V
        kqMOdhyPAek7NvZrVbPH50VRrX9l7/lH/s6zy6tm2A==
X-Google-Smtp-Source: ABdhPJw0ZfYrSkQBOU7HtlJ+qMtghoYxNb4Yi76ISuBNl6ETii85WUeEH5eTH7QX7VYFW8gzbaKKijv4ok8EvnEZF+c=
X-Received: by 2002:a2e:9d5:: with SMTP id 204mr5185058ljj.168.1589673572976;
 Sat, 16 May 2020 16:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200516021736.226222-1-shakeelb@google.com> <20200516.134018.1760282800329273820.davem@davemloft.net>
 <CALvZod7euq10j6k9Z_dej4BvGXDjqbND05oM-u6tQrLjosX31A@mail.gmail.com> <20200516.163927.1112911965183377217.davem@davemloft.net>
In-Reply-To: <20200516.163927.1112911965183377217.davem@davemloft.net>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sat, 16 May 2020 16:59:21 -0700
Message-ID: <CALvZod4cqCNHVLVMsoHKtQxWdY3YUqJBuqwFwE8MLeVh-jbdUw@mail.gmail.com>
Subject: Re: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 4:39 PM David Miller <davem@davemloft.net> wrote:
>
> From: Shakeel Butt <shakeelb@google.com>
> Date: Sat, 16 May 2020 15:35:46 -0700
>
> > So, my argument is if non-zero order vzalloc has failed (allocations
> > internal to vzalloc, including virtual mapping allocation and page
> > table allocations, are order 0 and use GFP_KERNEL i.e. triggering
> > reclaim and oom-killer) then the next non-zero order page allocation
> > has very low chance of succeeding.
>
> Also not true.
>
> Page table allocation strategies and limits vary by architecture, they
> may even need virtual mappings themselves.  So they can fail in situations
> where a non-zero GFP_KERNEL page allocator allocation would succeed.

Thanks for the explanation. Do you think calling vzalloc only for
non-zero order here has any value?
