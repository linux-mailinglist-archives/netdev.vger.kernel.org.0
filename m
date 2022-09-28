Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409535ED260
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiI1BBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiI1BBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:01:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A300E7C1B6;
        Tue, 27 Sep 2022 18:01:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4865AB81E77;
        Wed, 28 Sep 2022 01:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39189C433C1;
        Wed, 28 Sep 2022 01:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664326859;
        bh=xf1KWcWWS/gh3cdjZ1hQdsIxEkddHB6FWg7h2R0XIyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ooGTwwJBeQ/H2anhobyE2MPRwc5h0zHcLfIty52xhbxEmlK/YNjS4jwmXVn8AUqNv
         kl3dImqZ2P78pGe5w5eGVlmsIf0QjphI/g6v5VoKrUG3yX2I245yctSl6/IpcKUqHO
         BATpPx+MERbQrou4UMiiIyAte7HWJksdXd2+82y8xfmWv+iKaxU+3vr4MKs1RksUZH
         vPnLU+wO/6ZpcdrW7oG5eBD4EGDoHw9gC62PFktvfhsjVLVtTKROdAjH/LRLVlrzuM
         wyKNYciPASh2GeYYfssY+nd2Vgtxh+t0RPrmMf72xERNxUWUILXVMzjZ2zpOmZSHxF
         JbidGACtGbRuA==
Date:   Tue, 27 Sep 2022 18:00:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v7 2/7] net: add framework to support Ethernet
 PSE and PDs devices
Message-ID: <20220927180056.5e8e410c@kernel.org>
In-Reply-To: <20220926112500.990705-3-o.rempel@pengutronix.de>
References: <20220926112500.990705-1-o.rempel@pengutronix.de>
        <20220926112500.990705-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 13:24:55 +0200 Oleksij Rempel wrote:
> +static inline int pse_controller_register(struct pse_controller_dev *pcdev)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void pse_controller_unregister(struct pse_controller_dev *pcdev)
> +{
> +}
> +
> +static inline int devm_pse_controller_register(struct device *dev,
> +						 struct pse_controller_dev *pcdev)
> +{
> +	return -ENOTSUPP;
> +}

Presumably only PSE controller drivers would try to register themselves.
Such drivers should depend on the right config, and therefore we don't
need static inline stubs for the register/unregister API.

> +static inline struct pse_control *pse_control_get(struct device *dev)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +
> +static inline struct pse_control *devm_pse_control_get( struct device *dev)

nit: extra space after (

> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}

These two I don't see any calls to outside drivers/net/pse-pd/pse_core.c
so they should go from the API until we get an in-tree caller.

> +static inline struct pse_control *of_pse_control_get(struct device_node *node)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}

This one should prolly return -ENOENT as noted on patch 4.

If you could sed -i 's/ENOTSUPP/EOPNOTSUPP/' on the patches that'd be
great, I don't think those errno can leak to user space but why risk
it...
