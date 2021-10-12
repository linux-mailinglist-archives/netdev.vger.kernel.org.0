Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F242F42A6CD
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhJLOKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:10:51 -0400
Received: from mail-oo1-f41.google.com ([209.85.161.41]:34411 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbhJLOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:10:50 -0400
Received: by mail-oo1-f41.google.com with SMTP id n15-20020a4ad12f000000b002b6e3e5fd5dso2718097oor.1;
        Tue, 12 Oct 2021 07:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RMaXnYUhymrRYD9WfHd3vRjeCksk/ibqC+WFGIs70ao=;
        b=kX4osvzTNu5h6I7Oz8ly/McOWwsbv6r49QTPjGd24ttFxIVTeT8hS7SzZPpAlo5UdG
         1vdnvd2lzJ5p7Qrx5cjyWrZlAUQUAnKyDz4aoZ2haQh0+dQ/513vDZXdthDufXgqp1Zw
         8XamnN8lBdUfBtzvHcBbWVkqcfu/gOXXLkeCVvBn9bSLWBmIt9Ueue/hTFMpc3P1H7B0
         MJiFduqha2alNmaCfhVUpTEtro65E/x1H5IB7u4wdDJs88/pfcJrzDWcLDu7Juyb94cP
         m41UmrQa6X0e3lM6nFzx/q/rJHVRMhS9ct2aHqyjaeYdKx5lKR7vNFkNSUeJ9dN79/K2
         2Agw==
X-Gm-Message-State: AOAM533t4Nt0vgVnHwCeMLgwpzOQfJpmsFelE+vpj6u+gqwS+9P5k5+r
        B0a5R3ISKqmbrKUgMyFi6bW0JH1Eag==
X-Google-Smtp-Source: ABdhPJzTJvvGTrmKrIm34n8gw9Ui7MkZ61v7NTftC8k97j3d2O33sg9Q7kkFkw07M9HEOZAz1PN20w==
X-Received: by 2002:a4a:2a51:: with SMTP id x17mr23507999oox.21.1634047723952;
        Tue, 12 Oct 2021 07:08:43 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e11sm2330094oii.0.2021.10.12.07.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 07:08:43 -0700 (PDT)
Received: (nullmailer pid 2731186 invoked by uid 1000);
        Tue, 12 Oct 2021 14:08:42 -0000
Date:   Tue, 12 Oct 2021 09:08:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RESEND v2 1/4] dt-bindings: bluetooth: broadcom: Fix clocks
 check
Message-ID: <YWWW6inuh8OIM4Bl@robh.at.kernel.org>
References: <20210924072756.869731-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924072756.869731-1-maxime@cerno.tech>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 09:27:53AM +0200, Maxime Ripard wrote:
> The original binding was mentioning that valid values for the clocks and
> clock-names property were one or two clocks from extclk, txco and lpo,
> with extclk being deprecated in favor of txco.
> 
> However, the current binding lists a valid array as extclk, txco and
> lpo, with either one or two items.
> 
> While this looks similar, it actually enforces that all the device trees
> use either ["extclk"], or ["extclk", "txco"]. That doesn't make much
> sense, since the two clocks are said to be equivalent, with one
> superseeding the other.
> 
> lpo is also not a valid clock anymore, and would be as the third clock
> of the list, while we could have only this clock in the previous binding
> (and in DTs).
> 
> Let's rework the clock clause to allow to have either:
> 
>  - extclk, and mark it a deprecated
>  - txco alone
>  - lpo alone
>  - txco, lpo
> 
> While ["extclk", "lpo"] wouldn't be valid, it wasn't found in any device
> tree so it's not an issue in practice.
> 
> Similarly, ["lpo", "txco"] is still considered invalid, but it's
> generally considered as a best practice to fix the order of clocks.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> ---
>  .../bindings/net/broadcom-bluetooth.yaml        | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)

I've applied this and the rest of the series.

Rob
