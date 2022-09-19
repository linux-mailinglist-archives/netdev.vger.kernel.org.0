Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD5F5BD36F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiISRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiISRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:14:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BAE64F3;
        Mon, 19 Sep 2022 10:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F160CB81EDA;
        Mon, 19 Sep 2022 17:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F62DC433D7;
        Mon, 19 Sep 2022 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663607695;
        bh=qR1pUIp0+X38P59+eh0IdZBlLkL3ISJbPk0aQb93FSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lM4lKurbpX+U+QY2+LEwRUwqORyBnT0oK/SwdU4Y3Hfl25JAj6L+qz1qPiav924Un
         n4qRTqYyZSKqsSZ9gkW8Atdq2RBf26Ef7BLNM6OWjSwx8vIrTrn1uXSGhPva3wuJbn
         wmYuhdXCMKWePvgxzfiC9wHBOcTYT5IRP+u2L9a4zCsIPfrz175h5n82VzIPFVfyrJ
         ZutPFWYx0spw6WoDRwnGf2ALz36Y6rcCaXTEC/Smf4AttHClNzzzsvg6Bx8hTFsdIE
         nyge9Sz9U+zkUICmooYVFal78EEkF87vODY5U1FUw3dVi+sa8mcneSnQVAZs3qNXd5
         /QA9sCraskSWg==
Date:   Mon, 19 Sep 2022 10:14:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get
 regmap from a resource
Message-ID: <20220919101453.43f0a4d5@kernel.org>
In-Reply-To: <YxoEbfq6YKx/4Vko@colin-ia-desktop>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
        <20220905162132.2943088-2-colin.foster@in-advantage.com>
        <Yxm4oMq8dpsFg61b@google.com>
        <20220908142256.7aad25k553sqfgbm@skbuf>
        <YxoEbfq6YKx/4Vko@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Sep 2022 08:04:13 -0700 Colin Foster wrote:
> My plan was to start sending RFCs on the internal copper phys and get
> some feedback there. I assume there'll be a couple rounds and I don't
> expect to hit this next release (if I'm being honest).
> 
> So I'll turn this question around to the net people: would a round or
> two of RFCs that don't cleanly apply to net-next be acceptable? Then I
> could submit a patch right after the next merge window? I've been
> dragging these patches around for quite some time, I can do it for
> another month :-)

FWIW RFC patches which don't apply cleanly seem perfectly fine to me.
Perhaps note the base in the cover letter for those who may want to 
test them.

We can pull Lee's branch (thanks!) if it turns out the code is ready
long before the MW.
