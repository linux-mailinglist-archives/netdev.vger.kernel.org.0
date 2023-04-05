Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E736D82FD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbjDEQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjDEQGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:06:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151659CD;
        Wed,  5 Apr 2023 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sazrJU4w8BvwcUrOpjX/vjDRrO2IbyUUqQvpLwhaH7k=; b=1A/fF0lXMxmJYKpvJL/EEpXji3
        7MnzCQeJXXZyH4TdJYoaLcfPHniiMY6hAej8r5IcFsnddrNlnuI1k7KbuXsOzhdejLx/5O4H2cJsP
        k+4WKpKM6UPPg9a2A2LU9Ajt+q+H3LUSKpajZ5GOU6fvtpqKcrSZ+PvSlp9Hwj45wB58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk5eI-009XMT-0P; Wed, 05 Apr 2023 18:06:14 +0200
Date:   Wed, 5 Apr 2023 18:06:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
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
Message-ID: <a5a4e735-7b24-4933-b431-f36305689a79@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
 <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
 <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The current fwnode_mdio.c don't provide the proper helper functions yet.
> Instead the parsing is spread between fwnode_mdiobus_register_phy() and
> fwnode_mdiobus_phy_device_register(). Of course these can be extracted
> and exported but I don't see the benefit. IMHO it just cause jumping
> around files and since fwnode is a proper firmware abstraction we could
> use is directly wihin core/lib files.

No, assuming fwnode is the proper firmware abstraction is wrong. You
need to be very careful any time you convert of_ to fwnode_ and look
at the history of every property. Look at the number of deprecated OF
properties in Documentation/devicetree/bindings. They should never be
moved to fwnode_ because then you are moving deprecated properties to
ACPI, which never had them in the first place! You cannot assume DT
and ACPI are the same thing, have the same binding. And the same is
true, in theory, in the opposite direction. We don't want the DT
properties polluted with ACPI only properties. Not that anybody takes
ACPI seriously in networking.

> I know and I thought about adding the firmware parsing helpers first but
> than I went this way. I can split this of course to make the patch
> smaller.

Please do. Also, i read your commit message thinking it was a straight
copy of the code, and hence i did not need to review the code. But in
fact it is new code. So i need to take a close look at it.

But what i think is most important for this patchset is the
justification for not fixing the current API. Why is it broken beyond
repair?

     Andrew
