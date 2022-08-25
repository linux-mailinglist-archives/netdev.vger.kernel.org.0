Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067AF5A07D1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 06:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiHYEVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 00:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiHYEVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 00:21:10 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F6E2A73D;
        Wed, 24 Aug 2022 21:21:08 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 1351B2800095B;
        Thu, 25 Aug 2022 06:21:06 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 074654A8C2; Thu, 25 Aug 2022 06:21:06 +0200 (CEST)
Date:   Thu, 25 Aug 2022 06:21:06 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kernelci-results@groups.io,
        bot@kernelci.org, gtucker@collabora.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: stable-rc/linux-5.18.y bisection: baseline.login on panda
Message-ID: <20220825042106.GA16015@wunner.de>
References: <63068874.170a0220.2f9fc.b822@mx.google.com>
 <YwaqZ1+zm78vl4L1@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwaqZ1+zm78vl4L1@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 11:47:03PM +0100, Mark Brown wrote:
> On Wed, Aug 24, 2022 at 01:22:12PM -0700, KernelCI bot wrote:
> The KernelCI bisection bot identified 7eea9a60703ca ("usbnet: smsc95xx:
> Forward PHY interrupts to PHY driver to avoid polling") as causing a
> boot regression on Panda in v5.18.  The board stops detecting a link
> which breks NFS boot:
> 
> <6>[    4.953613] smsc95xx 2-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 02:03:01:8c:13:b0
> <6>[    5.032928] smsc95xx 2-1.1:1.0 eth0: hardware isn't capable of remote wakeup
> <6>[    5.044036] smsc95xx 2-1.1:1.0 eth0: Link is Down
> <6>[   25.053924] Waiting up to 100 more seconds for network.
> <6>[   45.074005] Waiting up to 80 more seconds for network.
> <6>[   65.093933] Waiting up to 60 more seconds for network.
> <6>[   85.123992] Waiting up to 40 more seconds for network.
> <6>[  105.143951] Waiting up to 20 more seconds for network.
> <5>[  125.084014] Sending DHCP requests ...... timed out!

Looks like v5.19 boots fine (with the offending commit), so only
v5.18-stable and v5.15-stable are affected:

https://storage.kernelci.org/stable-rc/linux-5.19.y/v5.19.3-366-g32f80a5b58e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html

The offending commit was a new feature introduced in v5.19,
it deliberately wasn't tagged for stable.  Aggressively
backporting such new features always carries a risk of
regressions.

Off the cuff I don't see that a prerequisite commit is missing
in stable kernels.  So just reverting the offending commit in
v5.18-stable and v5.15-stable (but not in v5.19-stable) might
be the simplest solution.

Thanks,

Lukas
