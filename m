Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DCA10DD5
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfEAUTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:19:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51461 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEAUTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s6BGr5cr9wEgPZpkidr/u2k/JjLoCrVQkciMEVrY8/8=; b=xwzbMKbNvvOvT14C63QHLOQOjC
        +NcK+cVLxkLdlhw7HwV8S9XVr10v/J5oY6sOSrZkREFDSuVCckB0ihvgDW8486nzBRPm5Bsqgkpn7
        s5l2VJEOADYnuvDt69nJ+o4Oiya/HudMiS13MVO1vBmoR4Qp243EqGjIA5mnsShWAD5k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvhH-00085b-Mb; Wed, 01 May 2019 22:19:19 +0200
Date:   Wed, 1 May 2019 22:19:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: Re: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Message-ID: <20190501201919.GC19809@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501193126.19196-2-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 07:32:10PM +0000, Rasmus Villemoes wrote:
> The 88e6250 (as well as 6220, 6071, 6070, 6020) do not support
> multi-chip (indirect) addressing. However, one can still have two of
> them on the same mdio bus, since the device only uses 16 of the 32
> possible addresses, either addresses 0x00-0x0F or 0x10-0x1F depending
> on the ADDR4 pin at reset [since ADDR4 is internally pulled high, the
> latter is the default].
> 
> In order to prepare for supporting the 88e6250 and friends, introduce
> mv88e6xxx_info::dual_chip to allow having a non-zero sw_addr while
> still using direct addressing.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 10 +++++++---
>  drivers/net/dsa/mv88e6xxx/chip.h |  5 +++++
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index c078c791f481..f66daa77774b 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -62,6 +62,10 @@ static void assert_reg_lock(struct mv88e6xxx_chip *chip)
>   * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
>   * multiple devices to share the SMI interface. In this mode it responds to only
>   * 2 registers, used to indirectly access the internal SMI devices.
> + *
> + * Some chips use a different scheme: Only the ADDR4 pin is used for
> + * configuration, and the device responds to 16 of the 32 SMI
> + * addresses, allowing two to coexist on the same SMI interface.
>   */
>  
>  static int mv88e6xxx_smi_read(struct mv88e6xxx_chip *chip,
> @@ -87,7 +91,7 @@ static int mv88e6xxx_smi_single_chip_read(struct mv88e6xxx_chip *chip,
>  {
>  	int ret;
>  
> -	ret = mdiobus_read_nested(chip->bus, addr, reg);
> +	ret = mdiobus_read_nested(chip->bus, addr + chip->sw_addr, reg);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -101,7 +105,7 @@ static int mv88e6xxx_smi_single_chip_write(struct mv88e6xxx_chip *chip,
>  {
>  	int ret;
>  
> -	ret = mdiobus_write_nested(chip->bus, addr, reg, val);
> +	ret = mdiobus_write_nested(chip->bus, addr + chip->sw_addr, reg, val);
>  	if (ret < 0)
>  		return ret;

Hi Rasmus

This works, but i think i prefer adding mv88e6xxx_smi_dual_chip_write,
mv88e6xxx_smi_dual_chip_read, and create a
mv88e6xxx_smi_single_chip_ops.

>  
> @@ -4548,7 +4552,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
>  static int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
>  			      struct mii_bus *bus, int sw_addr)
>  {
> -	if (sw_addr == 0)
> +	if (sw_addr == 0 || chip->info->dual_chip)
>  		chip->smi_ops = &mv88e6xxx_smi_single_chip_ops;
>  	else if (chip->info->multi_chip)
>  		chip->smi_ops = &mv88e6xxx_smi_multi_chip_ops;

And then select the dual chip ops here. That seems be to more in
keeping with the current code.

Thanks
	Andrew
