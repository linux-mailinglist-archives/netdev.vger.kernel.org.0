Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C975E71F4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiIWCjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiIWCjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:39:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B6D1176C0;
        Thu, 22 Sep 2022 19:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E200B829B1;
        Fri, 23 Sep 2022 02:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65602C433C1;
        Fri, 23 Sep 2022 02:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900748;
        bh=PNdU7fNduRcQhJm7dcaxtTTE0/w4p67D22t7Qk/4oIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RlDbgsfq9WocF3wv6oF3qp73BIG8bHWeNk8PDwpZzFyg5h74slf5WDAh2IkvqquF5
         a0TXN3X0phG6rRZfZH7GWE7xvyxgalMrUQq7zjEnC30AjuEXlINniM98vU6pI2IGyt
         T1gcseg2K/OHlYESk1uWMWnczVAtoN7s2hUBKLAeGC12Xmlr75PPLDPgK7kdzyTl9N
         9gWaWA1+L6huRq62WFeYgFYWeiu4ITFeoml+vzRfq4iSJy4ozqIK5hyquXHhWg7EO1
         xvxfqPS/Vzs4pJK36zMnONOW8KQjS87Z7ZXNKW6KmEzDpKdZ/8gaiTtyiQ5rSEThO/
         av9VMydDhIwQA==
Date:   Thu, 22 Sep 2022 19:39:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net-next 08/14] net: dsa: felix: update init_regmap
 to be string-based
Message-ID: <20220922193906.7ab18960@kernel.org>
In-Reply-To: <20220922040102.1554459-9-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
        <20220922040102.1554459-9-colin.foster@in-advantage.com>
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

On Wed, 21 Sep 2022 21:00:56 -0700 Colin Foster wrote:
> During development, it was believed that a wrapper for ocelot_regmap_init()
> would be sufficient for the felix driver to work in non-mmio scenarios.
> This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
> add interface for custom regmaps")
> 
> As the external ocelot DSA driver grew closer to an acceptable state, it
> was realized that most of the parameters that were passed in from struct
> resource *res were useless and ignored. This is due to the fact that the
> external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).
> 
> Instead of simply ignoring those parameters, refactor the API to only
> require the name as an argument. MMIO scenarios this will reconstruct the
> struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
> scenarios need only call dev_get_regmap(dev, name).
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

drivers/net/dsa/ocelot/felix.c:1328:14: warning: variable 'match' is used uninitialized whenever 'for' loop exits because its condition is false [-Wsometimes-uninitialized]
        for (i = 0; i < TARGET_MAX; i++) {
                    ^~~~~~~~~~~~~~
drivers/net/dsa/ocelot/felix.c:1338:7: note: uninitialized use occurs here
        if (!match) {
             ^~~~~
drivers/net/dsa/ocelot/felix.c:1328:14: note: remove the condition if it is always true
        for (i = 0; i < TARGET_MAX; i++) {
                    ^~~~~~~~~~~~~~
drivers/net/dsa/ocelot/felix.c:1324:30: note: initialize the variable 'match' to silence this warning
        const struct resource *match;
                                    ^
                                     = NULL
