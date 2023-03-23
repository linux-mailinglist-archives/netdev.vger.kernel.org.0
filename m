Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCFA6C6B23
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjCWOfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjCWOfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:35:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE732724
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xtxRv0Dnb3MRJoC8tkq10ukDwGiDkZG2jUl9EGYlKWk=; b=vxCqHv3m6d1lfrocHtuCly5zCr
        Kq1EMEoebYFptMU/YKu992Z0g00T5I8kG120m46LSI0EUO4IwreB7TOZK0HN4+/vbsubThvjrQ/sZ
        vpFuIXv3WqkcF6ESigitpQC3N3reRBnkmJImXp0I/SKJTLAEadrjabuU0Q+P7won+soN8+PuKQQhY
        Tctdv1moMh52XoJEZ2DIGGh76pQA1kBd14DGXZfJf/eb3VoIM7FfsIGZIUf/rzBx8X6tNzdsjcwar
        5vl416D5txxNvmGKeu+3Iv6rh3/F0QgHqcucbK4rnXtU4cei05NvxWNXBuFx6aFWcrQOd90u2hBq4
        MZ4zB3Yg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33072)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfM2O-0005H3-Ux; Thu, 23 Mar 2023 14:35:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfM2N-0001S7-UR; Thu, 23 Mar 2023 14:35:31 +0000
Date:   Thu, 23 Mar 2023 14:35:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Buzarra, Arturo" <Arturo.Buzarra@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <ZBxjs4arSTq4cDgf@shell.armlinux.org.uk>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
 <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
 <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
 <156b7aee-b61a-40b9-ac51-59bcaef0c129@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156b7aee-b61a-40b9-ac51-59bcaef0c129@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 03:19:21PM +0100, Andrew Lunn wrote:
> > Gigabit PHY has its own Crystal, however the 10/100 PHY uses a clock
> > from the CPU and it is the root cause of the issue because when
> > Linux asks the PHY capabilities the clock is not ready yet.
> 
> O.K, now we are getting closer.
> 
> Which clock is it exactly? Both for the MAC and the PHY?

Just a passing observation but... considering stmmac needs the clock
from the PHY in order to do even basic things, it doesn't surprise me
that there's a PHY out there that doesn't work without a clock provided
from the "other side" to also do the most basic things such as read the
IDs!

Hardware folk always find wonderful ways to break stuff and then need
software to fix it... :/

That all said, if the clock that's being discussed is the MDC signal
(MDIO interface clock) then /really/ (and obviously) that's a matter
for the MDIO driver to ensure that clock is available to run before
registering itself.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
