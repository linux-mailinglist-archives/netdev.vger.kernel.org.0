Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0FB294CE3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 14:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442501AbgJUMkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 08:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394405AbgJUMkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 08:40:22 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AEEF2242F;
        Wed, 21 Oct 2020 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603284021;
        bh=D2u3+25VPgAQHY5Nn343gmMQCCel5dPS87ZHZwoyNjM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SulhYNa9FDK7tCPx33fBxxU+9Yxu+f5QO9QlRPrywEn983DgQfusZOtcpYTDYgJtl
         0jc9q7B7J7DkpABX85e7jROgeSzwaPxWLHB12B0gNmJLxAJCLZ35PWuBDL+WAGWqOK
         LX9z2XZfy4yU4K1vKtZXacaRvI8yXZxvYo7JhGZQ=
Received: by mail-qk1-f174.google.com with SMTP id 188so2106396qkk.12;
        Wed, 21 Oct 2020 05:40:21 -0700 (PDT)
X-Gm-Message-State: AOAM53068OFj3P5j1hpIYInsaU2EowYBR4PYKe3uHHBfrTMaI17I3tzv
        e+9J1II58X0PQEQr+pAqp9XOVVLlwYc5rWgSex8=
X-Google-Smtp-Source: ABdhPJxaYfqMELfS/UA0bXc2jA/eaagXcZCcnNsgAaV8d9zfQVqdARFwKphCh/C0TXvS9gdaX5eGQgOxG4PgPN+L8lc=
X-Received: by 2002:a37:2dc6:: with SMTP id t189mr2894076qkh.394.1603284020397;
 Wed, 21 Oct 2020 05:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201020220639.130696-1-joel@jms.id.au>
In-Reply-To: <20201020220639.130696-1-joel@jms.id.au>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Oct 2020 14:40:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
Message-ID: <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
To:     Joel Stanley <joel@jms.id.au>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 12:39 PM Joel Stanley <joel@jms.id.au> wrote:

>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 331d4bdd4a67..15cdfeb135b0 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -653,6 +653,11 @@ static bool ftgmac100_tx_complete_packet(struct ftgmac100 *priv)
>         ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
>         txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
>
> +       /* Ensure the descriptor config is visible before setting the tx
> +        * pointer.
> +        */
> +       smp_wmb();
> +
>         priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv, pointer);
>
>         return true;
> @@ -806,6 +811,11 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
>         dma_wmb();
>         first->txdes0 = cpu_to_le32(f_ctl_stat);
>
> +       /* Ensure the descriptor config is visible before setting the tx
> +        * pointer.
> +        */
> +       smp_wmb();
> +

Shouldn't these be paired with smp_rmb() on the reader side?

      Arnd
