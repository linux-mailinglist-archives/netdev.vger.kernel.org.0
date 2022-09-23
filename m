Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8435E71FE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiIWCk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiIWCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4D0814E1;
        Thu, 22 Sep 2022 19:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A4562312;
        Fri, 23 Sep 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CAEC433D6;
        Fri, 23 Sep 2022 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900811;
        bh=hgq+etZgS87xH2btz4n6jRvDNnpE64NXArdWf7MXyWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XtwC/a9MRb7JQ+wackPWqjdh8FAmAxXUoZpv8BK0SFWWzF6OWlWalvHK5rGtr1WyO
         +OBiJbghM7JCIazeGlnwOps0QNNUvSZamTboCDJPIj17KCSWL7WMDxwcabUWJ0pBdf
         UY7fPs+H2LxOD+ZoDpvuiW+rNA/nvBeOGW7Or1arP2dMrKE5XegQPUaCnMJqfEor3L
         vzps27NKU4/4oJCA5fHjMirZFYKlIDe+KWqqVih1ocd2zohZcyjeyoIQKFLGhlwYdd
         23FDRjD8fbjjSLxnLAVKJVHVrYVVVIU01hslIZIoGHTVMFtkt+IFJ2j9Y/z2KGBF9w
         d0+XUpFkOzilw==
Date:   Thu, 22 Sep 2022 19:40:09 -0700
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
Message-ID: <20220922194009.276371fc@kernel.org>
In-Reply-To: <20220922193906.7ab18960@kernel.org>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
        <20220922040102.1554459-9-colin.foster@in-advantage.com>
        <20220922193906.7ab18960@kernel.org>
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

On Thu, 22 Sep 2022 19:39:06 -0700 Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 21:00:56 -0700 Colin Foster wrote:
> > During development, it was believed that a wrapper for ocelot_regmap_init()
> > would be sufficient for the felix driver to work in non-mmio scenarios.
> > This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
> > add interface for custom regmaps")
> > 
> > As the external ocelot DSA driver grew closer to an acceptable state, it
> > was realized that most of the parameters that were passed in from struct
> > resource *res were useless and ignored. This is due to the fact that the
> > external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).
> > 
> > Instead of simply ignoring those parameters, refactor the API to only
> > require the name as an argument. MMIO scenarios this will reconstruct the
> > struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
> > scenarios need only call dev_get_regmap(dev, name).

Ah, and the modpost:

ERROR: modpost: drivers/net/dsa/ocelot/mscc_seville: 'felix_init_regmap' exported twice. Previous export was in drivers/net/dsa/ocelot/mscc_felix.ko
