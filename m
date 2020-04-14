Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971751A898D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503992AbgDNS3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503988AbgDNS3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:29:52 -0400
X-Greylist: delayed 7146 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 11:29:51 PDT
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ACFC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qT7pq56eGRVJyi38PZK7i3UNqcN9dLDa3yh7cY9BxYI=; b=vp/gdevqsipZ7cr0lo2UKXAIl
        puqj32rZlg0ZQLasuzFZ2i28ZZECqFp6RSf9zEM/nySVs1yvkhvHp+pp1JixcgNHuMn01eZVfyvqj
        7sMB1vTlLrzFLkjwKR4iQatn5Dfq7MpQ4y7uCuHCL4TZO0dQcWcebbr8Ka4AUlA/rXmG+aYh4mV2Y
        gSJKIy5dW/Pm+HK6Xok3cVKnBfrEKl2X6uP3ML/fRtqEFOYESzPnhDxIxaqeQWJrzTBAtelngs7g2
        4lIE0qWk5muLvPN2eUgPQC9XrHh5yBn2Kl8YylVJze6ZwDJTtNpiHzyBnjZhAraokXRAd1RDw0xtJ
        guJR5bxQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50056)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jOQJY-0001PP-Ho; Tue, 14 Apr 2020 19:29:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jOQJT-0008Kq-Og; Tue, 14 Apr 2020 19:29:35 +0100
Date:   Tue, 14 Apr 2020 19:29:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] Fix 88x3310 leaving power save mode
Message-ID: <20200414182935.GY25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series fixes a problem with the 88x3310 PHY on Macchiatobin
coming out of powersave mode noticed by Matteo Croce.  It seems
that certain PHY firmwares do not properly exit powersave mode,
resulting in a fibre link not coming up.

The solution appears to be to soft-reset the PHY after clearing
the powersave bit.

We add support for reporting the PHY firmware version to the kernel
log, and use it to trigger this new behaviour if we have v0.3.x.x
or more recent firmware on the PHY.  This, however, is a guess as
the firmware revision documentation does not mention this issue,
and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
later does not.

 drivers/net/phy/marvell10g.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
