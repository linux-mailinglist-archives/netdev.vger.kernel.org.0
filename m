Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8667B4E2
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbjAYOjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbjAYOjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:39:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CE3C642;
        Wed, 25 Jan 2023 06:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8FF461520;
        Wed, 25 Jan 2023 14:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCBEC433D2;
        Wed, 25 Jan 2023 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674657505;
        bh=0pN6iUk0frIEY9jd5haQTHTxexp54lAmG4VMISAveTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bszh+lRbTRrhEPHElC/vn3g0DHY+0OEb5+8Y4cW1RAwFlJ+xv55Y2sf/joav/FerR
         GW+LYrzb/W6VwieJHov+E95G+R77WxMTqVVP2HU2ehwBsBP58XsSNlmEamrp025KSf
         mdsQVM+RfHqiuuyyUVYXFGngBgWHxz+FR/B7SgW0=
Date:   Wed, 25 Jan 2023 15:38:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 9/9] usb: host: ohci-exynos: Convert to
 devm_of_phy_optional_get()
Message-ID: <Y9E+3pSA6/aANQpu@kroah.com>
References: <cover.1674584626.git.geert+renesas@glider.be>
 <3adc5dd1149a17ea7daf4463549feab886c6b145.1674584626.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3adc5dd1149a17ea7daf4463549feab886c6b145.1674584626.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 07:37:28PM +0100, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> As devm_of_phy_optional_get() returns NULL if either the PHY cannot be
> found, or if support for the PHY framework is not enabled, it is no
> longer needed to check for -ENODEV or -ENOSYS.
> 
> This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> handle NULL parameters fine.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
