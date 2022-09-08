Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF05A5B191A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiIHJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiIHJoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCC14008;
        Thu,  8 Sep 2022 02:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B1A61C30;
        Thu,  8 Sep 2022 09:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F410DC433D7;
        Thu,  8 Sep 2022 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662630274;
        bh=I3kuzLPKhDYkB44Kbq3Ba0qHby0mCUZxIRVbEQXEPyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hB6x9UYDzP88wUBio5ktCkyq2xTk8jx/SoHt1nTnq9DkjLrlmtjZjNjDl1SRSfjZY
         cZhY80i34wCcNXFp/b/ApMeVRH3Qx0hOLkKKj0j9/1A4JtVylswYI55Zz8SLXWDyVK
         BBMrJU4nxKoCieqifcvTXQ0JwDHC/Y1IT+sFghMLAld6ZIboFioVe0vvjo/sgKSqoy
         MTXf75DznbzCkQKbNdZbKYxj2cJ+gzpfbSnjCBEJdfpFxKRuqsaKrjzvXnpx/rBb8C
         9wxmaUe/9P1BwYFYVqeIJGXhQ9b53LtP+32BR9PWvzl0CLTRJFAa/C5ooAaVSFKgiA
         WbAn5uFHHEusw==
Date:   Thu, 8 Sep 2022 10:44:25 +0100
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, katie.morris@in-advantage.com
Subject: Re: [RESEND PATCH v16 mfd 8/8] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <Yxm5eXg5taqn4TEW@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-9-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Sep 2022, Colin Foster wrote:

> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
> 
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> 
> v16
>     * Includes fixups:
>     *  ocelot-core.c add includes device.h, export.h, iopoll.h, ioport,h
>     *  ocelot-spi.c add includes device.h, err.h, errno.h, export.h, 
>        mod_devicetable.h, types.h
>     *  Move kconfig.h from ocelot-spi.c to ocelot.h
>     *  Remove unnecessary byteorder.h
>     * Utilize resource_size() function
> 
> v15
>     * Add missed include bits.h
>     * Clean _SIZE macros to make them all the same width (e.g. 0x004)
>     * Remove unnecessary ret = ...; return ret; calls
>     * Utilize spi_message_init_with_transfers() instead of
>       spi_message_add_tail() calls in the bus_read routine
>     * Utilize HZ_PER_MHZ from units.h instead of a magic number
>     * Remove unnecessary err < 0 checks
>     * Fix typos in comments
> 
> v14
>     * Add Reviewed tag
>     * Copyright ranges are now "2021-2022"
>     * 100-char width applied instead of 80
>     * Remove invalid dev_err_probe return
>     * Remove "spi" and "dev" elements from ocelot_ddata struct.
>     Since "dev" is available throughout, determine "ddata" and "spi" from
>     there instead of keeping separate references.
>     * Add header guard in drivers/mfd/ocelot.h
>     * Document ocelot_ddata struct
> 
> ---
>  MAINTAINERS               |   1 +
>  drivers/mfd/Kconfig       |  21 +++
>  drivers/mfd/Makefile      |   3 +
>  drivers/mfd/ocelot-core.c | 161 ++++++++++++++++++++
>  drivers/mfd/ocelot-spi.c  | 299 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/ocelot.h      |  49 +++++++
>  6 files changed, 534 insertions(+)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h

Applied, thanks.

-- 
Lee Jones [李琼斯]
