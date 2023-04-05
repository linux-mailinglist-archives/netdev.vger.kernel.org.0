Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6C36D81C1
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbjDEP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjDEP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:27:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD01E5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 08:27:34 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk52Q-0007Rq-Lu; Wed, 05 Apr 2023 17:27:06 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk52Q-0001IW-3w; Wed, 05 Apr 2023 17:27:06 +0200
Date:   Wed, 5 Apr 2023 17:27:06 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: Re: [PATCH 05/12] net: phy: add phy_id_broken support
Message-ID: <20230405152706.qr2rsuxr2y3usbru@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-5-7e5329f08002@pengutronix.de>
 <6461467c-8f9d-41b6-b060-08190126e81f@lunn.ch>
 <956792db-c6a4-f16f-e7e4-b9d08c12f986@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <956792db-c6a4-f16f-e7e4-b9d08c12f986@gmail.com>
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

On 23-04-05, Florian Fainelli wrote:
> On 4/5/2023 5:27 AM, Andrew Lunn wrote:
> > On Wed, Apr 05, 2023 at 11:26:56AM +0200, Marco Felsch wrote:
> > > Some phy's don't report the correct phy-id, e.g. the TJA1102 dual-port
> > > report 0 for the 2nd port. To fix this a driver needs to supply the
> > > phyid instead and tell the phy framework to not try to readout the
> > > phyid. The latter case is done via the new 'phy_id_broken' flag which
> > > tells the phy framework to skip phyid readout for the corresponding phy.
> > 
> > In general, we try to avoid work around for broken hardware in the
> > core. Please try to solve this within nxp-tja11xx.c.
> 
> Agreed, and one way to solve working around broken PHY identification
> registers is to provide them through the compatible string via
> "ethernet-phyAAAA.BBBB". This forces the PHY library not to read from those
> registers yet instantiate the PHY device and force it to bind to a certain
> phy_driver.

The nxp-tja11xx.c is a bit special in case of two-port devices since the
2nd port registers a 2nd phy device which is correct but don't have a
dedicated compatible and so on. My 2nd idea here was to check if phy_id
is !0 and in this case just use it. I went this way to make it a bit
more explicit.

Regards,
  Marco


> -- 
> Florian
> 
