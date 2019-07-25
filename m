Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F4F74C81
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391544AbfGYLIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:08:35 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33229 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390100AbfGYLIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:08:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so36102036qkc.0
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 04:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XecB3q5bTWcgiLdVMLn24BDmyGnREE0oLhQteRaLk4w=;
        b=L0lgaZOaQkoTzmZtPLYPElFb0r8sj0JciD73bOnlfc1zXT77AanLWx9NfMUm8hFjkk
         tTs+7KUNeToH9I+dQmGwfokRaqEtPefA3vct6R1G3jRAVYcebe9PyFDCT0vLVPSWdGMb
         ajW8AEJM1P9Eac/8iyL6hTmVArJP0/ldF+RGuVA8sBAVYx6dV9nkm8v7OHqe/ho+/h+H
         9yV/TTNh4hCZgHBgHSzOulDlb0NBt+t7+z/UOXw9Bs1pnx+5HeMzhvQg0G9e4mwLM/Gw
         UupdIM18Wb6b0V3g6p3qg/zh0eGCi/TLI6KlOUbmy25jrtP1KAw5UiZF5AqyQCqrtLxD
         CHgw==
X-Gm-Message-State: APjAAAUdx1SMwy+ZKpcWvz1sE3gTI627NyH4D1iVBYQWPmmASFjBu8SD
        ezHKIgHq0lw3qcUwYXRtUCI+8VUj91gmvigHLcsdlOOXjP0=
X-Google-Smtp-Source: APXvYqw/JjY4uvbEpRv/1F3DRxWbQUQq8Q+ie/rcF1FLgpiP9J2QpHKjgDwdN7ezi11ZTVQn/xPxBpx50U+WtXbF52Y=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr57411997qkc.394.1564052914338;
 Thu, 25 Jul 2019 04:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190724113615.11961-1-willy@infradead.org>
In-Reply-To: <20190724113615.11961-1-willy@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 25 Jul 2019 13:08:18 +0200
Message-ID: <CAK8P3a1Ae3r=dOa-LSWxUEWH5qY4c8HfnGuT0y5BEL51tUCDOQ@mail.gmail.com>
Subject: Re: [PATCH] Build fixes for skb_frag_size conversion
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:37 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> I missed a few places.  One is in some ifdeffed code which will probably
> never be re-enabled; the others are in drivers which can't currently be
> compiled on x86.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
> index cc12c78f73f1..46a6fcf1414d 100644
> --- a/drivers/staging/octeon/ethernet-tx.c
> +++ b/drivers/staging/octeon/ethernet-tx.c
> @@ -284,7 +284,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
>
>                         hw_buffer.s.addr =
>                                 XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
> -                       hw_buffer.s.size = fs->size;
> +                       hw_buffer.s.size = skb_drag_size(fs);
>                         CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
>                 }
>                 hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));

Kernelci noticed a build failure from a typo here:
https://kernelci.org/build/id/5d3943f859b514103f688918/logs/

       Arnd
