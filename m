Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3B74367AA
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJUQ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhJUQ1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:27:55 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F361C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:25:39 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g6so638835ybb.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tM39+P2Cv7rft3KkBQIGxKInrKySMFoc1DgpNAvd0yk=;
        b=j53kZN8tvjCX5nHBtwm5lW/z4mr6o65qeawS6ZUZ8dpXBR+uh6Uv1hDr4C2XoZf0LH
         Zx0M/5pWizwg+yByVB6G47hz1yLykLQPW4begCGT1yVI7P0viteIlRo56xD/Gq2D5I55
         N/tvrcdj+51Crq9EwB+HttDXpKOvj1MtbTr/z/QIWiuFjbaEGbmAcwEEZlgwChZYBmoc
         iNAeRGGcdGyKyPJ/ChFNCn3SOwf+gJAHFwkSORCG+8hvnqM0v8ClaeCeIyW2fdYHDr4o
         MSNNTQLlxqxQP8/fNPaFarXA9LSGQB+TENUO28vWXjOmFQI4AlK3qLrIkvKoWLHmujom
         8sRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tM39+P2Cv7rft3KkBQIGxKInrKySMFoc1DgpNAvd0yk=;
        b=3PmpB2P5yfxvMdlUI/DWzwk5FOzUk18etwQIpSiZbUPpMPYMfFeUSjAI4NNMp7e7RO
         8asdzB4dOQ0LX5QpSsH4KtC21I8161VR2kqVRBFfU6k+14CNJ1c0xNryzq5hvbifISKd
         iIDO7XrRTOrLouDdV7M2VxIQZeJqtFuvsQfKElGyHWS7X3N3pMV8UjmPAJXFTBaC510q
         TkNJbM9/pludlwwYw2pg4i8AeDGv4UJ+EkqPLg/NoPa6K3mitNS+hev19M9t7v/s4Npn
         ZDsyCzxeQRrfAnA+aKy3XR7Y4oQFoCXx84sz0hRVzH/zLGPY5RpWJYGG7CF42CyXEL4A
         c3qw==
X-Gm-Message-State: AOAM532e5qn2YjfC3Wdy81EnDI95sCxheBVmx0P42fmDU8BZUInocXmC
        nJYLGXZ0Q5aucY7QaNRyEstwBZRRkjUeq0h9141Z+w==
X-Google-Smtp-Source: ABdhPJwne2A0HSemgbBj9KAzCJUKyKocJ5z67A1PxHLc7cPXWxlNms1KuXM0x9erPhfkuKW/2FqxV6GbDlOPHsDYyzU=
X-Received: by 2002:a25:c696:: with SMTP id k144mr6672042ybf.296.1634833538209;
 Thu, 21 Oct 2021 09:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211021162253.333616-1-eric.dumazet@gmail.com> <20211021162253.333616-5-eric.dumazet@gmail.com>
In-Reply-To: <20211021162253.333616-5-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Oct 2021 09:25:27 -0700
Message-ID: <CANn89i+v3hOaHKvQp4W8UexMwXWfT6KoVAwWGykEFyrVHbgRKg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: remove one pair of atomic operations
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 9:23 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> __QDISC_STATE_RUNNING is only set/cleared from contexts owning qdisc lock.
>
> Thus we can use less expensive bit operations, as we were doing
> before commit f9eb8aea2a1e ("net_sched: transform qdisc running bit into a seqcount")
>
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---


Please disregard, I have accidentally resent this patch while sending
another unrelated patch series.
