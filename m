Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E2D5709D8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiGKSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:22:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8068532470;
        Mon, 11 Jul 2022 11:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24329614DB;
        Mon, 11 Jul 2022 18:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9625C34115;
        Mon, 11 Jul 2022 18:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657563739;
        bh=CvQRlE/ufLqF5vMtPD31qdoYcNYjoAvuZ3UjFo4NIrA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kuHdm9IZqSaGlxtM3jWp0VqxJgW8mxBvW8RhxQQI/wqhqG9zQDcc6uqKwJac3DRy2
         nHx36rn5b7/rEniXgAKi7kp7ZvmUCyPlFDeEwNFyrcVTz8ubG5iVxoKMFvmdmAaK32
         GyrYtRuVPnk92U9vGUG4rhdC6V9TSwDCBkf4HPYaLqQOjoKP/hHeFDkXHyNViBd4BM
         1WymX3Imn3xMxzrhiEb5Spf6V8ivZ1jbQQXW054QUA0/RRyU8msJcqlrkL288sxJdD
         K6UyHJhlCet0ylR73YPmkOX9v2Od9C8Dd5wgYUEXSuF/4UQGooHihol4p1D9zcoNqy
         QgaDSVAlEmH7g==
Date:   Mon, 11 Jul 2022 11:22:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 2/9] net: mdio: mscc-miim: add ability to
 be used in a non-mmio configuration
Message-ID: <20220711112209.4902720b@kernel.org>
In-Reply-To: <20220705204743.3224692-3-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
        <20220705204743.3224692-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jul 2022 13:47:36 -0700 Colin Foster wrote:
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
> 
> Add support for these non-memory-mapped configurations.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Since the patch may go via MFD:

Acked-by: Jakub Kicinski <kuba@kernel.org>
