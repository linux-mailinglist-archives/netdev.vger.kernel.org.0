Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1046D7FCC
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbjDEOnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbjDEOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:43:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD649E0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:42:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4L8-0000GF-Oh; Wed, 05 Apr 2023 16:42:22 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4L4-0007Dh-7f; Wed, 05 Apr 2023 16:42:18 +0200
Date:   Wed, 5 Apr 2023 16:42:18 +0200
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
Subject: Re: [PATCH 00/12] Rework PHY reset handling
Message-ID: <20230405144218.kl7dqtms4x534jvi@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <03ed8642-e521-f079-05b8-de9ffa97237a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ed8642-e521-f079-05b8-de9ffa97237a@gmail.com>
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

Hi Florian,

On 23-04-05, Florian Fainelli wrote:
> Hi Marco,
> 
> On 4/5/2023 2:26 AM, Marco Felsch wrote:
> > The current phy reset handling is broken in a way that it needs
> > pre-running firmware to setup the phy initially. Since the very first
> > step is to readout the PHYID1/2 registers before doing anything else.
> > 
> > The whole dection logic will fall apart if the pre-running firmware
> > don't setup the phy accordingly or the kernel boot resets GPIOs states
> > or disables clocks. In such cases the PHYID1/2 read access will fail and
> > so the whole detection will fail.
> 
> PHY reset is a bit too broad and should need some clarifications between:
> 
> - external reset to the PHY whereby a hardware pin on the PHY IC may be used
> 
> - internal reset to the PHY whereby we call into the PHY driver soft_reset
> function to have the PHY software reset itself
> 
> You are changing the way the former happens, not the latter, at least not
> changing the latter intentionally if at all.

Yes.

> This is important because your cover letter will be in the merge commit in
> the networking tree.

Ah okay, I didn't know that. I will adapt the cover letter accordingly.

> Will do a more thorough review on a patch by patch basis. Thanks.

Thanks a lot, looking forward to it.

Regards,
  Marco
