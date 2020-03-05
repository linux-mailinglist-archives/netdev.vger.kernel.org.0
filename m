Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABBD17B25D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCEXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:46:09 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47830 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgCEXqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 18:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R+lH94AUgy5+cLda3KYku9uMfTJxGkhCAJmYZ6hoYvQ=; b=RlAaTAWMI3g9MrcUHppzGXN56
        WXFipykUy0IOG3u0RZn5JSogB3fuN/SeukGqyfDOvVR8xplSgYJPE/e5b74MVdvqSMt+OGpu4VHGU
        ooQCD9NktLgeq2FWsFm/JZB3nTdIaYvQWSCycoHrM/SjGz/BoGXQYe172SdcoxB0DRXusVtrL9jJU
        J5KOh8JyCvA6E6a7cHeqai6SnjcQkSthxqBqVJIe8IiqiZ/7KT4zy+1pLg2ihwNcGEGtV0Txjl8aZ
        +bQh/M1S9ocPzV1E33n6ta0g5cDxo5USv+1fIp04vKEl77HJm7lV49ufMFM/t56sVNcX8nECAiujI
        z4M7H/FcA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49170)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jA0Bk-0001EA-0Z; Thu, 05 Mar 2020 23:46:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jA0Bh-0008Ju-Es; Thu, 05 Mar 2020 23:45:57 +0000
Date:   Thu, 5 Mar 2020 23:45:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200305234557.GE25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305225407.GD25183@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 11:54:07PM +0100, Andrew Lunn wrote:
> On Thu, Mar 05, 2020 at 12:41:39PM +0000, Russell King - ARM Linux admin wrote:
> > Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> > does not automatically update the switch MACs with the link parameters.
> > Currently, the DSA code implements a work-around for this.
> > 
> > This series improves the Serdes integration, making use of the recent
> > phylink changes to support split MAC/PCS setups.  One noticable
> > improvement for userspace is that ethtool can now report the link
> > partner's advertisement.
> 
> Hi Russel
> 
> I started testing this patchset today. But ran into issues with ZII
> scu4-aib and ZII devel c. I think the CPU port is running at the wrong
> speed, but i'm not sure yet. Nor do i know if it is this patchset, or
> something earlier.

It could be this patch set; remember the integration of phylink into
DSA for CPU and inter-switch ports is already broken, particularly
for links that do not specify any fixed-link properties.

For ZII platforms, the fixed link parameters are specified, so this
should not be the case.

You should see a call to .mac_config() followed by a call to
.mac_link_up(), so you should be seeing:

mv88e6085 0.1:00: Link is Up - 100Mbps/Full - flow control off

somewhere in the kernel messages.

For the DSA ports, there's no fixed-link parameters, so the above
integration broke those by trying to set speed=0 duplex=0 on the
DSA ports - so don't expect the other bridges to work irrespective
of whether this series is applied or not.

FYI, the port status and control register for the CPU port on the
ZII rev C should be:

0 = 0xd04
1 = 0x203d

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
