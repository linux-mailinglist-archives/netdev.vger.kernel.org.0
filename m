Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6424028DC67
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgJNJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgJNJJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:09:37 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39FFC051106;
        Tue, 13 Oct 2020 23:41:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c5so1614138qtw.3;
        Tue, 13 Oct 2020 23:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYVpb77m81OGf8esxe67DpKeQQwwty0E+qYw8pndICs=;
        b=gvwvpNlTL3VrOueBdyU/G8UQbGwlGUi6tQ7MrIIfHkbf70jG3r6LUtToDGUZ+9m39/
         KfjtQcVRhcGMXxWti/NGll0qTZ1Q8CAi/Es21qFuucypc2RaJ0CuhlaFAeaZJumRVtOO
         a1krOnxX3f/6+7qhVJJduGx0pNHO/tN18sq1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYVpb77m81OGf8esxe67DpKeQQwwty0E+qYw8pndICs=;
        b=ZrLnk0cRB3YmrykXrgdcFifQqCziVz6CHd4nRy2k2b4hwBvknAKQbB051KdB5SJVvP
         0fq1k91mXLC1JybiKj6+3u7mP1u3MDONE4j5oUrhmgUDyuFcMJjLovnp14tfRefg2R69
         xq9ifZ5f3A3vpzpjWqFzRdetC2O3LxTEJ1zxJPGOexowwCgdSVmCGmAFYQneLYukL3Ey
         Kv5hD+N9Ipqxdi4KCehE3+K9y1erHJIRNb+J9eysK5XKNaNQ/TxQwAcC/nFCkdj8qDCb
         n76WMN1bVDbiifdYHD91gy/YrY+xl9q5oE9T1tv4RNG5sGg0rrbOxvvk+fBXLM+30TsK
         DFtA==
X-Gm-Message-State: AOAM530S7yGGqe91LasMhNofmjWuGyntZwWqimK35wqial16G1lA8zW8
        8zdo1xZh4Gf/PPoQPiTHmU0VHtFKJ6nKOcZ3AaA=
X-Google-Smtp-Source: ABdhPJzad1ODvABFwHM1RxsMIzpF0CMNZppbarTgOXe/6nXpCz8ZZmDpmc9ZYxiNOFy8SZ/ngRLiC4c8WchQTZillxk=
X-Received: by 2002:ac8:3674:: with SMTP id n49mr3349956qtb.385.1602657693846;
 Tue, 13 Oct 2020 23:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com> <20201014060632.16085-2-dylan_hung@aspeedtech.com>
In-Reply-To: <20201014060632.16085-2-dylan_hung@aspeedtech.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 14 Oct 2020 06:41:21 +0000
Message-ID: <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 at 06:07, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> The new HW arbitration feature on Aspeed ast2600 will cause MAC TX to
> hang when handling scatter-gather DMA.  Disable the problematic feature
> by setting MAC register 0x58 bit28 and bit27.

Hi Dylan,

What are the symptoms of this issue? We are seeing this on our systems:

[29376.090637] WARNING: CPU: 0 PID: 9 at net/sched/sch_generic.c:442
dev_watchdog+0x2f0/0x2f4
[29376.099898] NETDEV WATCHDOG: eth0 (ftgmac100): transmit queue 0 timed out

> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>

This fixes support for the ast2600, so we can put:

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")

Reviewed-by: Joel Stanley <joel@jms.id.au>

> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
>  drivers/net/ethernet/faraday/ftgmac100.h | 8 ++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 87236206366f..00024dd41147 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1817,6 +1817,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
>                 priv->rxdes0_edorr_mask = BIT(30);
>                 priv->txdes0_edotr_mask = BIT(30);
>                 priv->is_aspeed = true;
> +               /* Disable ast2600 problematic HW arbitration */
> +               if (of_device_is_compatible(np, "aspeed,ast2600-mac")) {
> +                       iowrite32(FTGMAC100_TM_DEFAULT,
> +                                 priv->base + FTGMAC100_OFFSET_TM);
> +               }
>         } else {
>                 priv->rxdes0_edorr_mask = BIT(15);
>                 priv->txdes0_edotr_mask = BIT(15);
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.h b/drivers/net/ethernet/faraday/ftgmac100.h
> index e5876a3fda91..63b3e02fab16 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.h
> +++ b/drivers/net/ethernet/faraday/ftgmac100.h
> @@ -169,6 +169,14 @@
>  #define FTGMAC100_MACCR_FAST_MODE      (1 << 19)
>  #define FTGMAC100_MACCR_SW_RST         (1 << 31)
>
> +/*
> + * test mode control register
> + */
> +#define FTGMAC100_TM_RQ_TX_VALID_DIS (1 << 28)
> +#define FTGMAC100_TM_RQ_RR_IDLE_PREV (1 << 27)
> +#define FTGMAC100_TM_DEFAULT                                                   \
> +       (FTGMAC100_TM_RQ_TX_VALID_DIS | FTGMAC100_TM_RQ_RR_IDLE_PREV)

Will aspeed issue an updated datasheet with this register documented?


> +
>  /*
>   * PHY control register
>   */
> --
> 2.17.1
>
