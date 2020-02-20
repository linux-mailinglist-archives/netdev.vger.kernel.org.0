Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7E7165CD8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBTLft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:35:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58762 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgBTLft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 06:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UwV1E9IpH6lihvWwJsEF1r0v9DXIq2lNrBTyIa7NBJs=; b=SLaYk7g0u9SmAf++2bbKkFucB
        Jf1SMVuuyMdAiYfi/5Eg5Ky03tpm80TQxqsRmnRTk4tiLWzCWZOka3n0MulN+JNBivxomYRF+HHJ5
        n7FO9sNNXXUW6Bv3hiWDBT7nVKdxRtXncHWK6quvoUn3475s5xnKdXLytwVWSi9Uh9JttyZqhdenp
        lR8/ftcfHOYc31NQGQZyishTclmj+07gtTlFj2ZH7SKcAGbx4UDDUQVg2oFcIeBXGbGXTQPX2qtiN
        kIc6HDssF1PrphQ/ejKKRbUqVOUohgW6WdAx4n8FLVEFDsHE3Cbt9JhykpUnotzvzIKb1kmfpZsFy
        37rJyxDXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54510)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4k7A-0002z2-TI; Thu, 20 Feb 2020 11:35:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4k76-0002O0-P5; Thu, 20 Feb 2020 11:35:28 +0000
Date:   Thu, 20 Feb 2020 11:35:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200220113528.GY25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
 <20200219034730.GE10541@lunn.ch>
 <20200219091900.GQ25745@shell.armlinux.org.uk>
 <20200219130707.GB245247@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219130707.GB245247@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 01:07:07PM -0500, Vivien Didelot wrote:
> Hi Russell,
> 
> Some switches like the Marvell 88E6060 don't have a VTU, so programming the
> default PVID would return -EOPNOTSUPP.

The 88e6060 has its own driver separate from mv88e6xxx.

> Switches supporting only global VLAN
> filtering cannot have a VLAN filtering aware bridge as well as a non VLAN
> filtering aware bridge spanning their ports at the same time. But all this
> shouldn't be a problem because drivers inform the stack whether they support
> ds->vlan_filtering per-port, globally or not. We should simply reject the
> operation when vlan_filtering is being enabled on unsupported hardware.
> 
> Linux bridge is the reference for the implementation of an Ethernet bridge,
> if it programs VLAN entries, supported DSA hardware must do so. I'm not a
> fan of having our own bridge logic in DSA, so the limitation implemented by
> 2ea7a679ca2a ("net: dsa: Don't add vlans when vlan filtering is disabled")
> needs to go in my opinion.

... which is basically what patch 3 is doing, but in a per-driver
manner.

The checks introduced in 2ea7a679ca2a ("net: dsa: Don't add vlans when
vlan filtering is disabled") were raised up a level by c5335d737ff3
("net: dsa: check bridge VLAN in slave operations") to their present
positions, which are then touched by my patch 3 to make the checks
conditional.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
