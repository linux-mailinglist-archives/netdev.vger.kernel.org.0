Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6241E59E
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351017AbhJAAw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbhJAAwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 20:52:25 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A81C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 17:50:42 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id b82so17063425ybg.1
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 17:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sSIYRPAj7smXy74/Y3XxYl8pLf22IW2BYxYMs+e3VNw=;
        b=kBJg8M+npzMu6yiOqcpjIcYP+6PrUKMtS3EdalgEuWITg1tpAnYVBHuM7reqxnU9kp
         OO0Pg/A/c/H9JEpI9wu3HYB4koKwMoeJkt2P7TYXunBbt2N4dc05hueh4y1THuZsMdIe
         02VUC9BN2ik6UX6u805O9oS4ZtfpJOpDTyDtJPM5exl7bxXjejpndVDY1CwOMBojYXao
         qMYaS5yvl4tAv7nXHBjvjdahQNWAlmku8v17eANzCDIEp36FMtpQui29NljYg7CpIBsb
         CTm/q0HNkBdepgxVOGePxon/Kwz9r4lgEfPFdDq6NBpKBe3KwEyX/819/po1wIo8SqtJ
         bPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sSIYRPAj7smXy74/Y3XxYl8pLf22IW2BYxYMs+e3VNw=;
        b=P0KxY1DD/DbiT/CNddSwdnVfDFdykYYtmZFKOTfeA2h6foypISRJM8ZMcHDJ++nxup
         EdXO+ZgvybAzmhU0cbrxtwbTqDOV21USybKEUyu0OOGXkSeA51ppjbNCwWtPtkIsTXhP
         XhhV4bAidPKZzgKZO/u/hPbat6rH7RTwXbNNKTeAT9rcOh5KF/FY7epqmEP55ZX5DTIx
         hP/GbWIeIAvHwwYE7xeP8W6vbAgTlpwiYUOU3Eu86PZaT2F87tdF6VSm0t73UGQtLQ2u
         KKYRnRvmgXuK1c0MWESqFDZz7JgrZgVqJAmHvHpaTmzXiRleFhTT6WgRb50GkadfEp4o
         LC9Q==
X-Gm-Message-State: AOAM531QMR4cQBpYsx39J/nVLrEiu9h/P6Kf4XrMm2Ke5t3vzAgxl0OD
        eIc0evW/23Ieh920s4aY37FASZWPJfsecfJm+SGIuQ==
X-Google-Smtp-Source: ABdhPJzrpPqcLZPjHFPe3uUGRRpTAWix+QMRG4qKGieAzwb+PtPr3AJWdtegHCsFQrZKzjk+QaHbtbVrzoWcqAVUCA8=
X-Received: by 2002:a25:d258:: with SMTP id j85mr2893616ybg.398.1633049440986;
 Thu, 30 Sep 2021 17:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210930194031.3181989-1-eric.dumazet@gmail.com> <20210930171052.30660edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210930171052.30660edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Sep 2021 17:50:29 -0700
Message-ID: <CANn89iL32eW5fR+eTpz5iybFubZDAbxZrZLK635U7070fxHDyA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid one cache line miss to ring doorbell
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 5:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Sep 2021 12:40:31 -0700 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > This patch caches doorbell address directly in struct mlx4_en_tx_ring.
> >
> > This removes the need to bring in cpu caches whole struct mlx4_uar
> > in fast path.
> >
> > Note that mlx4_uar is not guaranteed to be on a local node,
> > because mlx4_bf_alloc() uses a single free list (priv->bf_list)
> > regardless of its node parameter.
> >
> > This kind of change does matter in presence of light/moderate traffic.
> > In high stress, this read-only line would be kept hot in caches.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Tariq Toukan <tariqt@nvidia.com>
>
> >       /* Following part should be mostly read */
> > +     void                    *doorbell_address;
>
> We'll need to make sparse happy before applying:
>
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32: warning: incorrect type in assignment (different address spaces)
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32:    expected void *doorbell_address
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32:    got void [noderef] __iomem *
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56:    expected void [noderef] __iomem *
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56:    got void *doorbell_address

Yes indeed, I'll send a V2 right away, thanks !
