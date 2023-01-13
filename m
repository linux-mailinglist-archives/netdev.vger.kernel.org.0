Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F246699F7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbjAMOVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbjAMOVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:21:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315C88CBC7;
        Fri, 13 Jan 2023 06:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qv8AtKYS75ekqwj3ZRxebZ6w8bPaLVDLxS8c8MDhAp0=; b=pwrL2StNP5h0ey/R1CZU3o54Ew
        ifCtZI0J4lXs77Vxy6EHQsK/qEAMsQHnBE2EMAbQCsuqJni6I0r4phSiMSdFz4pjHpE5ZDHZAuK62
        9iknIVbX0DL2UlsTIQw6LdGMJ98uRAclPlgLC0kCBwKLCP+Huq0AV146lQUZG/ZjIoF0ly2J8CxxT
        gz/2eASKsfOcU5CcNTYSefCzH7UBCLin/zOCX/2TBSJCvNEo+rGHaWyOX91+gX3tPchOm4ojwc2O8
        ZCE94cvpR+/xk2Jdx/IEZt62ZSx5bdwOGw6XdNvYW+fcClT6Ymj0pUMUqzjFcgdIOwDfy48jdX0rb
        zTAJvt9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36092)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pGKqj-0007vv-P4; Fri, 13 Jan 2023 14:16:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pGKqh-0003Dz-DA; Fri, 13 Jan 2023 14:16:03 +0000
Date:   Fri, 13 Jan 2023 14:16:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
References: <20230106101651.1137755-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106101651.1137755-1-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent. This value corresponds to the memory allocated
> in switch to store single frame.
> 
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value. On the other hand - mv88e6250 supports 2048 bytes.
> To be more interresting - devices supporting jumbo frames - use yet
> another value (10240 bytes)
> 
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.
> 
> This commit doesn't change the code functionality - it just provides
> the max frame size value explicitly - up till now it has been
> assigned depending on the callback provided by the IC driver
> (e.g. .set_max_frame_size, .port_set_jumbo_size).

I don't think this patch is correct.

One of the things that mv88e6xxx_setup_port() does when initialising
each port is:

        if (chip->info->ops->port_set_jumbo_size) {
                err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
                if (err)
                        return err;
        }

There is one implementation of this, which is mv88e6165_port_set_jumbo_size()
and that has the effect of setting port register 8 to the largest
size. So any chip that supports the port_set_jumbo_size() method will
be programmed on initialisation to support this larger size.

However, you seem to be listing e.g. the 88e6190 (if I'm interpreting
the horrid mv88e6xxx_table changes correctly) as having a maximum
frame size of 1522, but it implements this method, supports 10240, and
thus is programmed to support frames of that size rather than 1522.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
