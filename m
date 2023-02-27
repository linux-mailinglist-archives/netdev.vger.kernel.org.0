Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DEB6A4C04
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjB0UJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjB0UJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:09:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84DD33B
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ewu8QX7fVwAVN9WbRyQYyrP39kYMgqtzZU51aHdCV4g=; b=erXUIv5gBVThZ+PsOABvyptnJh
        pR0YTd/G6yNilNuoQXslZabJpt7bhUuMxk1Ol0rVhMD10khECwEb2JVmPAJ9+5b7R08Pd2X4E2okt
        KgK0LzPlk47+6LvUVi8nbbfAqZHZ03ABxuhW8rUwcrWkJiQMgxalC+tZqBmAOVBhzaMLM9XhXqX7R
        5WUscU9mnclyXwU9tKPWnC2D3LdPbtUnk77xZLzFA9pqv8EhDqoHoX9/nWblY2KJUPyuDAAubAMY8
        sTFLj7agYw2rTazL6GTYmuSgmf3TA+Ni1MkAvK23Af4bajr1ThXymTIYQAyt651PUMJS1xNiuuCYo
        4vMOSAOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33154)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pWjo4-0003dC-2T; Mon, 27 Feb 2023 20:09:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pWjo2-0001wc-0c; Mon, 27 Feb 2023 20:09:06 +0000
Date:   Mon, 27 Feb 2023 20:09:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 11:45:58AM -0800, Richard Cochran wrote:
> On Mon, Feb 27, 2023 at 03:20:05PM +0000, Russell King (Oracle) wrote:
> 
> > Attempting to fix this problem was basically rejected by the PTP
> > maintainer, and thus we're at a deadlock over the issue, and Marvell
> > PHY PTP support can never be merged into mainline.
> 
> FWIW, here was my attempt to solve the issue by making the PHY/MAC
> layer selectable at run time, while preserving PHY as the default.
> 
> https://lore.kernel.org/netdev/20220103232555.19791-1-richardcochran@gmail.com/

Hi Richard,

Looking at that link, I'm only seeing that message, with none of
the patches nor the discussion. Digging back in my mailbox, I
find that the patches weren't threaded to the cover message, which
makes it quite difficult to go back and review the discussion.

Patch 1 (no comments)
https://lore.kernel.org/netdev/20220103232555.19791-2-richardcochran@gmail.com
Patch 2 (one comment from me suggesting moving a variable)
https://lore.kernel.org/netdev/20220103232555.19791-3-richardcochran@gmail.com
Patch 3 (lots of comments)
https://lore.kernel.org/netdev/20220103232555.19791-4-richardcochran@gmail.com
Patch 4 (no comments)
https://lore.kernel.org/netdev/20220103232555.19791-5-richardcochran@gmail.com

Looking back briefly at the discussion on patch 3, was the reason
this approach died due to the request to have something more flexible,
supporting multiple hardware timestamps per packet?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
