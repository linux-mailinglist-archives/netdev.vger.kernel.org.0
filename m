Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99902674C9D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjATFhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjATFgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E978CE3AE;
        Thu, 19 Jan 2023 21:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7DCB82667;
        Thu, 19 Jan 2023 17:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF1DC433F1;
        Thu, 19 Jan 2023 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674148040;
        bh=p21pGzD22MpoWatcSjUEkm1IDstJhidS3Q/BmnFObP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VB0v90HPUpSjfT4dp4KDfWV1uLlPh58zX+dCdCUBE7r5uS8I/kVy0uQm4Rj/cjB0F
         2jaWmuy9HcXj6JlHF0/pXjIMwDKTbjkYG7OZ+JiZrbmCzp0bjeyVvJpryCjU+P6xnv
         d3mAt3WP0R3QtfXWQuTLTWJ4jmUZzk+gNpU6lE8fOAeyZv5y0BFKAJvyMAnzCOmqdY
         Xaifjh0J9LbdsYoXe+rhoUf/VhC2dEMfYZdqviCVeq2XXrnw0g6XxS3rMZ95ar7BPZ
         92a933OMWBfksIZY+rCEZXrW5NSJrMILond4EbEpNxBxiHSxgErwKqAoQC70VNMTHM
         HWLpW3oNDstgw==
Date:   Thu, 19 Jan 2023 09:07:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/7] phy: Add devm_of_phy_optional_get() helper
Message-ID: <20230119090717.3e220c30@kernel.org>
In-Reply-To: <Y8kmG+jB/s7stebA@matsya>
References: <cover.1674036164.git.geert+renesas@glider.be>
        <f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be>
        <20230118192809.2082b004@kernel.org>
        <Y8kmG+jB/s7stebA@matsya>
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

On Thu, 19 Jan 2023 16:44:35 +0530 Vinod Koul wrote:
> > For merging could you put this one on an immutable branch and then
> > everyone can pull + apply patches for callers from their section?  
> 
> Since this is phy, I can do that and everyone else can merge that in or
> all changes can go thru phy tree

Great! The microchip and ti drivers are relatively actively developed, 
I reckon it's worth going the branch way.
