Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF3E1DD5DC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgEUSU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgEUSU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:20:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E75C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rGgZoAOWm2bMMgIpvqYE9sIiiA8ouE44sCrWqCqO7Ew=; b=MsyFOFsL4taIW9Hv2fKOR5qwR
        gHpVMzgFU6QhlzHiwGU82Wla0jfxf1eAmO2zPgd1S5/M6BTUE249c+Si82VIA+lnQZSbj9xYNCWoJ
        WIDmfpmHxzKvyydjW+EomKy0elT3oAUxCR52FVL7dSEJ1Ek+AVAoHmgW56ntiObZBPLHshi3cubNT
        OM50lmKE1bQ0lA3/qcwRMGJ9WOEYyzGbL3Td+aNMk1Krp4ui+epF0oFc7raDYfYTLF0HMV9exG4vX
        XuH1ynZUf5BBWUdrWW9uhsnKQlIl2WpNESUfa7GoTk4/r5MEv2Q6X1JZf4oqn/tdGxy8oJ6patC1N
        rwbNusj+w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60964)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jbpnk-00039q-BU; Thu, 21 May 2020 19:20:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jbpne-0000Rr-DU; Thu, 21 May 2020 19:20:10 +0100
Date:   Thu, 21 May 2020 19:20:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Cc:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200521182010.GV1551@shell.armlinux.org.uk>
References: <3268996.Ej3Lftc7GC@tool>
 <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk>
 <20200521155513.GE677363@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521155513.GE677363@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 05:55:13PM +0200, Andrew Lunn wrote:
> > I hope the patch adding pp->dev->phydev hasn't been merged as it's
> > almost certainly wrong.
> 
> Hi Russell
> 
> It was merged :-(
> 
> And it Oops when used with a switch.

Hmm, now that I have net-next updated, I think the original commit is
wrong but not as I thought.

The way this has been added, it means that if we have a PHY on a SFP,
we can end up changing the settings on the SFP PHY if there is one
present.  Do we want to support WoL on SFPs?

David, can you revert 5e3768a436bb70c9c3e27aaba6b73f8ef8f5dcf3 please?
It's a layering violation, and as Andrew has found, it causes kernel
oopses.

What we need instead is support in phylink for doing this, which isn't
going to be a couple of lines change to what was added to mvneta in
the referenced commit.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
