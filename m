Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FBA1625C9
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 12:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRLwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 06:52:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52564 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgBRLwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 06:52:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=txI52EWHvPhWcZ58wEj/owqsgIaOqbLSArH+2U9raNc=; b=H752sjr6pZpQOEo8X/0Q5vprC
        I53EeKh/IIzCHHJzvELjg+LAmoclSlCyGyJgP4a5lJJsw2TvufMk84mKH2QwQosskLmpTwlEw+296
        +bLnG0GtcrIzSWPEVhQuyk2+dl4OVIazaeEPhgiJXDp+nsYzDs2uDB5bIPx2ZfH3vTto/YIHdPcQp
        CIBUyNzqtpdAfKe1QeJ5UtEpHOpCyUhG2tZiIwRKRkiOJkCrN3gZXxD5QJR5CvkXP6Ilj6FecOW7g
        r1eA0g6DsEivrP5uNwpnUpPeKuCySfQkRyXsbb3+5I+4rkRGWbyGjRI7LmQR/FAkm1YKFMod1X1hK
        3thM0EfcQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49476)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j41Py-0006yr-PC; Tue, 18 Feb 2020 11:51:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j41Px-0000PU-TS; Tue, 18 Feb 2020 11:51:57 +0000
Date:   Tue, 18 Feb 2020 11:51:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
Message-ID: <20200218115157.GG25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:46:14AM +0000, Russell King wrote:
> When setting VLANs on DSA switches, the VLAN is added to both the port
> concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
> ports are configured with the same VLAN ID, this triggers a warning on
> the CPU port.
> 
> Avoid this warning for CPU ports.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Note that there is still something not right.  On the ZII dev rev B,
setting up a bridge across all the switch ports, I get:

[   29.526408] device lan0 entered promiscuous mode
[   29.812389] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   29.837032] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   29.855132] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   29.870246] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   30.201951] device lan1 entered promiscuous mode
[   30.217172] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.226663] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.235366] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.243355] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   30.251970] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.262759] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.271104] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.278437] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   30.444394] device lan2 entered promiscuous mode
[   30.459404] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.468032] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.476725] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.484390] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   30.493135] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.503920] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.512208] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.519546] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   30.685926] device lan3 entered promiscuous mode
[   30.697173] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.710499] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.719215] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.727069] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   30.735674] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.746472] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.755567] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.762909] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   30.931879] device lan4 entered promiscuous mode
[   30.942491] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.955862] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   30.965332] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   30.973110] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   30.981817] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   30.992666] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.001044] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.008382] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   31.180919] device lan5 entered promiscuous mode
[   31.191329] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.205077] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.213782] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.222598] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   31.231304] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.243705] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.254125] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.262043] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   31.449715] device lan6 entered promiscuous mode
[   31.459350] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.468345] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.477056] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.488690] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   31.497379] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.508209] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.516494] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.523956] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   31.670892] device lan7 entered promiscuous mode
[   31.680315] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.689037] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.698480] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.709288] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   31.718807] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.729622] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.737996] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.745465] mv88e6085 0.4:00: p9: already a member of VLAN 1
...
[   31.890353] device lan8 entered promiscuous mode
[   31.899985] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.909517] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.918255] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.928986] mv88e6085 0.4:00: p9: already a member of VLAN 1
[   31.937703] mv88e6085 0.1:00: p5: already a member of VLAN 1
[   31.948657] mv88e6085 0.2:00: p5: already a member of VLAN 1
[   31.957027] mv88e6085 0.2:00: p6: already a member of VLAN 1
[   31.964368] mv88e6085 0.4:00: p9: already a member of VLAN 1

So there's still something not right.  The setup is not non-standard,
it's just a bridge across all the lan ports.

My guess is this patch needs to be extended to DSA ports as well as
CPU ports?

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
