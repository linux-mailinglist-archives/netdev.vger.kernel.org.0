Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62573D4244
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhGWU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:58:15 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:46812 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhGWU6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:58:14 -0400
Received: by mail-il1-f182.google.com with SMTP id r5so2770141ilc.13;
        Fri, 23 Jul 2021 14:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qLC1a0942Ze1tivGSf8NMdJuQgNlX4CCAdHKNqxYvFw=;
        b=d9r2wBxYmwV9OKm0YYV3G+m8BmrLid2DSa4FflCKZfaItnV3suZlBf7YdxDxWtRVOh
         78Kg45DgrPbVF3CNWrJ9hYZvsSCOpLSzEbwidAJwsdhWQ6+MwEnKuvz16I780Oihk2HT
         8cL3zu1/vb48UPJMAnL5K7Zho08QDu0eK95fGVAJSXJe+z7Q2Z68N9B06gYZQ3ezWUnA
         npdLMVU6AtcjDPxKQlGsDjZ9aAYx50mVy+JFWapdlE1MSn49T9f2+ea3xU4MXk+jMjYo
         TuJ7wBgOoRwyzG8ru35OON3vLIb8KJ1aGVfyEgTMWWott3aH3l7XozIjPF9W3mhSbouu
         0JKg==
X-Gm-Message-State: AOAM532HB8r1+uc+16YygT0AfLA21sPp63ywT/AqGNWTrzrFMVlmbvRA
        I1Aatv5xlFFZrG4ygtn/UQ==
X-Google-Smtp-Source: ABdhPJzZQVJYy6rBmD8rhTRjqsu5y/388MRTnNj0Dek62WfDxQEci31NVIVSjh3spz/Rszg7/lvxJA==
X-Received: by 2002:a92:de0a:: with SMTP id x10mr4799658ilm.215.1627076326664;
        Fri, 23 Jul 2021 14:38:46 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id h6sm18168876iop.40.2021.07.23.14.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:38:46 -0700 (PDT)
Received: (nullmailer pid 2634577 invoked by uid 1000);
        Fri, 23 Jul 2021 21:38:43 -0000
Date:   Fri, 23 Jul 2021 15:38:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Frank Rowand <frowand.list@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 07/54] dt-bindings: bluetooth: broadcom: Fix clocks check
Message-ID: <20210723213843.GA2634543@robh.at.kernel.org>
References: <20210721140424.725744-1-maxime@cerno.tech>
 <20210721140424.725744-8-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721140424.725744-8-maxime@cerno.tech>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 16:03:37 +0200, Maxime Ripard wrote:
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
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> ---
>  .../bindings/net/broadcom-bluetooth.yaml        | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
