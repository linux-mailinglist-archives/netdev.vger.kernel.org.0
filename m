Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF936A983E
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCCNUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCCNUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:20:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED77EF774
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 05:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lAVCcSX6CMrGbnOU7w/HAlmYluax36A1FByRJGols38=; b=HuNjsObG7M85iS/hpalZbkykNE
        r5txFlIENYQr/HfCRXBx5N3a052CQERdYvCWZLmL1S51EWAq3EnARlmvw0kJhbnzga1XkoPY1TrkB
        z6hBv0nbJCzwy6Inseew6ndKBiyMPEOBlpdi8vyvxnpRW4Mdt4lOgC8Im0ifeg97yOjs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pY5Ke-006O2H-0g; Fri, 03 Mar 2023 14:20:20 +0100
Date:   Fri, 3 Mar 2023 14:20:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAH0FIrZL9Wf4gvp@lunn.ch>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303102005.442331-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm not sure we are making much progress here...

Lets divide an conquer. As far as i can see we have the following bits
of work to do:

1) Kernel internal plumbing to allow multiple time stampers for one
netdev. The PTP core probably needs to be the mux for all kAPI calls,
and any internal calling between components. This might mean changes
to all MAC drivers supporting PTP and time stampers. But i don't think
there is anything too controversial here, just plumbing work.

2) Some method to allow user space to control which time stamper is
used. Either an extension of the existing IOCTL interface, or maybe
ethtool. Depending on how ambitious we want to be, add a netlink API
to eventually replace the IOCTL interface?

3) Add a device tree binding to control which time stamper is
used. Probably a MAC property. Also probably not too controversial.

4) Some solution to the default choice if there is no DT property.

	Andrew
