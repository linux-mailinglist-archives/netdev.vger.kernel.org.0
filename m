Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36526292401
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgJSI5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgJSI5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:57:18 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E870C0613D0;
        Mon, 19 Oct 2020 01:57:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h12so5626729qtu.1;
        Mon, 19 Oct 2020 01:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wXjVJ2kLM9uL5zZqS31DB6qTzRp54/Wsz/d0bgYSzU=;
        b=TDyea6ULvpGU7a0Dhx1tL4D0rwfJbSJTi4VN7qeh/4elwEKNOUpmDVqizB19jpmbi5
         ik+Tv9QgHViUgEFekp/zfJOGt55BpkejTYlZIzmBM2jWyoDSQXPgmZgYIHY54csWtczN
         Hf40iCTF2f9opr6ioMeyyzHWYeFWWjCrMULiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wXjVJ2kLM9uL5zZqS31DB6qTzRp54/Wsz/d0bgYSzU=;
        b=AYyKyQux9AS/bR1ljH/CHjCLSGkHSCtTvsRrnSSFYFGbMu4nW7/UwyrnKkmq3q2bSC
         GcJfYa87qwkjJHBPSBh0LZ6VZEuqWO3RuXzIlmgi4lez3gHTiupl2v/hcdbRStPfGT2F
         Cg2M4qdzTcmIulsgso/p/wOWTtVGvOAYYa9oo/MbaMTL7CJW02MzC8//Z/P/dFzT3/Bi
         uL8GgMleMK9bBwsTJ2+h1xwDNPzTsX28UdaS97WSKD0qoXF4mL9OU2brhS+RPTdr0Z41
         5EDFmrjLRBQGIEleFo829briFLmVro6jPT8OvAyCYkIGmN7E1fIEwzSc/E3leKdlUClg
         Ay/A==
X-Gm-Message-State: AOAM531tuz1ddyVF5dmmVfL4VoHd8jKEeIJ4Lis9Y451d0imaKp33Vn7
        +B8DHpYpFBOC283LJgJ3RfyprgwWZ39kz4ONLK0=
X-Google-Smtp-Source: ABdhPJziaiqhweWLOlZxU+9528F62BwFkgOqsRM3uuTjs1fr/ZaPnhcOPrPNTkmmTVOf98mby6Bwx3/NXCsuhATsdZI=
X-Received: by 2002:ac8:5b82:: with SMTP id a2mr14060369qta.176.1603097835819;
 Mon, 19 Oct 2020 01:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
In-Reply-To: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 19 Oct 2020 08:57:03 +0000
Message-ID: <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
To:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

On Mon, 19 Oct 2020 at 07:39, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> The cpu accesses the register and the memory via different bus/path on
> aspeed soc.  So we can not guarantee that the tx-poll command

Just the 2600, or other versions too?

> (register access) is always behind the tx descriptor (memory).  In other
> words, the HW may start working even the data is not yet ready.  By

even if the

> adding a dummy read after the last data write, we can ensure the data
> are pushed to the memory, then guarantee the processing sequence
>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 00024dd41147..9a99a87f29f3 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -804,7 +804,8 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
>          * before setting the OWN bit on the first descriptor.
>          */
>         dma_wmb();
> -       first->txdes0 = cpu_to_le32(f_ctl_stat);
> +       WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
> +       READ_ONCE(first->txdes0);

I understand what you're trying to do here, but I'm not sure that this
is the correct way to go about it.

It does cause the compiler to produce a store and then a load.

>
>         /* Update next TX pointer */
>         priv->tx_pointer = pointer;
> --
> 2.17.1
>
