Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF70670FDA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjARBVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjARBUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:20:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C803EC62;
        Tue, 17 Jan 2023 17:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BAA6CE192F;
        Wed, 18 Jan 2023 01:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EDEC433D2;
        Wed, 18 Jan 2023 01:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674004662;
        bh=FGOiyRzcJoEHKdMm+kbK+YBbd8BVEKp07glKSiqMg5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QbeEAIQw7uP/CRIUHrwWm1uUqA0LznQ6bZkZCm/JvVzO+chR72Aco1aIqOwMEMO6A
         nBojp92S1Dz6EWGVhbEqXnr2gR1nDDCg1BvKgFHpWbYSepjNRH/Y/8jrAVBM+iwkX5
         HJdlwLQF+HWFHnVGGr0vEm2GmGJw5zhl0oOL6KxGZo1YkpRav1MK6etkZ44IQEhchi
         ys/UxjqQtx//40gat0FDCYAyyq+pPU/BaAhpVXg2/scFUUHc+hUK6WNuwBEXmm5NCW
         cvWuhnpp8XPzu/obuWLLL3faKEfzlFEgRT48oZuIESimcnHSBlKaDsX86cFMQE22Of
         l8V+vvA4V+WDQ==
Date:   Tue, 17 Jan 2023 17:17:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/6] net: mdio: Rework scanning of bus ready
 for quirks
Message-ID: <20230117171740.3a9e6f8d@kernel.org>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-2-5aa29738a023@walle.cc>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
        <20230116-net-next-remove-probe-capabilities-v1-2-5aa29738a023@walle.cc>
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

On Mon, 16 Jan 2023 13:55:14 +0100 Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Some C22 PHYs do bad things when there are C45 transactions on the
> bus. In order to handle this, the bus needs to be scanned first for
> C22 at all addresses, and then C45 scanned for all addresses.
> 
> The Marvell pxa168 driver scans a specific address on the bus to find
> its PHY. This is a C22 only device, so update it to use the c22
> helper.

clang says:

drivers/net/phy/mdio_bus.c:708:11: warning: variable 'i' is uninitialized when used here [-Wuninitialized]
        while (--i >= 0) {
                 ^
drivers/net/phy/mdio_bus.c:620:7: note: initialize the variable 'i' to silence this warning
        int i, err;
             ^
              = 0
