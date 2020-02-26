Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDF1705DE
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgBZRTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:19:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51272 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBZRTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BHuN8/RcJyVH6YhBDGQ70vDkLUNzfw7i6PvQOyH6FeM=; b=PIQNKrIsYntEucYLZ0fx8bRme
        TXL1wf+32a7F4RFyrI5+8lNVhJnCktaGyJoMCPwQSR9fjmWTWyTTzvwD0At5lCSyfLe91iiPNKxlc
        AMJAY+wWiizJipms/ar61UC/sOrqne5tRF7wBtkbn0CcrAEc/iNXuRD/FQBN3exILAnJIFjAXsF7L
        qw7gWfpoEP+Jgsog66jI2t6oXBcIvuL3paZSaBd0LYD0edUFyqnM5wgncPNOMoz83C9fqH9+mPIzl
        p0UEOi7xdiTNW57uEnmUZXNHBd7aDBv7fysoktPzQv++I3z/GP6EO3E38czMutbf6h9YWzuXwZ8S1
        ya7CXCJgQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45582)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j70DZ-0000O3-M5; Wed, 26 Feb 2020 17:11:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j70DZ-00008G-68; Wed, 26 Feb 2020 17:11:29 +0000
Date:   Wed, 26 Feb 2020 17:11:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
Message-ID: <20200226171129.GC25745@shell.armlinux.org.uk>
References: <20200226170847.GB25745@shell.armlinux.org.uk>
 <E1j70CN-0004I4-G8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j70CN-0004I4-G8@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch - I'll send v3 with an updated version, as
I've found the same workaround is needed for DSA ports as well.

On Wed, Feb 26, 2020 at 05:10:15PM +0000, Russell King wrote:
> When setting VLANs on DSA switches, the VLAN is added to both the port
> concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
> ports are configured with the same VLAN ID, this triggers a warning on
> the CPU port.
> 
> Avoid this warning for CPU ports.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 4ec09cc8dcdc..629eb7bbbb23 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1795,7 +1795,7 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>  }
>  
>  static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
> -				    u16 vid, u8 member)
> +				    u16 vid, u8 member, bool warn)
>  {
>  	const u8 non_member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
>  	struct mv88e6xxx_vtu_entry vlan;
> @@ -1840,7 +1840,7 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
>  		err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
>  		if (err)
>  			return err;
> -	} else {
> +	} else if (warn) {
>  		dev_info(chip->dev, "p%d: already a member of VLAN %d\n",
>  			 port, vid);
>  	}
> @@ -1854,6 +1854,7 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
>  	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	bool warn;
>  	u8 member;
>  	u16 vid;
>  
> @@ -1867,10 +1868,15 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
>  	else
>  		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_TAGGED;
>  
> +	/* net/dsa/slave.c will call dsa_port_vlan_add() for the affected port
> +	 * and then the CPU port. Do not warn for duplicates for the CPU port.
> +	 */
> +	warn = !dsa_is_cpu_port(ds, port);
> +
>  	mv88e6xxx_reg_lock(chip);
>  
>  	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
> -		if (mv88e6xxx_port_vlan_join(chip, port, vid, member))
> +		if (mv88e6xxx_port_vlan_join(chip, port, vid, member, warn))
>  			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
>  				vid, untagged ? 'u' : 't');
>  
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
