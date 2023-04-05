Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207A16D81AF
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbjDEPXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbjDEPXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:23:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAF55B9D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 08:23:04 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4xx-00073O-O3; Wed, 05 Apr 2023 17:22:29 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4xt-00017e-Jm; Wed, 05 Apr 2023 17:22:25 +0200
Date:   Wed, 5 Apr 2023 17:22:25 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 06/12] net: phy: add phy_device_atomic_register helper
Message-ID: <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
 <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
User-Agent: NeoMutt/20180716
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-04-05, Andrew Lunn wrote:
> > To bundle the phy firmware parsing step within phx_device.c the commit
> > copies the required code from fwnode_mdio.c. After we converterd all
> > callers of fwnode_mdiobus_* to this new API we can remove the support
> > from fwnode_mdio.c.
> 
> Why bundle the code? Why not call it in fwnode_mdio.c?

The current fwnode_mdio.c don't provide the proper helper functions yet.
Instead the parsing is spread between fwnode_mdiobus_register_phy() and
fwnode_mdiobus_phy_device_register(). Of course these can be extracted
and exported but I don't see the benefit. IMHO it just cause jumping
around files and since fwnode is a proper firmware abstraction we could
use is directly wihin core/lib files.

> The bundling in this patch makes it harder to see the interesting part
> of this patch, how the reset is handled. That is what this whole
> patchset is about, so you want the review focus to be on that.

I know and I thought about adding the firmware parsing helpers first but
than I went this way. I can split this of course to make the patch
smaller.

Regards,
  Marco


> 
> 	 Andrew
> 
