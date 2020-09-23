Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F842275BFF
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWPhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:37:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWPhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 11:37:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kL6pL-00FtiO-Ej; Wed, 23 Sep 2020 17:37:03 +0200
Date:   Wed, 23 Sep 2020 17:37:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000e: Power cycle phy on PM resume
Message-ID: <20200923153703.GC3764123@lunn.ch>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200923121748.GE3770354@lunn.ch>
 <F6075687-7BC4-4348-86A8-29D83B7E5AAC@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F6075687-7BC4-4348-86A8-29D83B7E5AAC@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:44:10PM +0800, Kai-Heng Feng wrote:
> Hi Andrew,
> 
> > On Sep 23, 2020, at 20:17, Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > On Wed, Sep 23, 2020 at 03:47:51PM +0800, Kai-Heng Feng wrote:
> >> We are seeing the following error after S3 resume:
> >> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> >> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
> >> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> >> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
> >> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> >> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
> >> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
> >> ...
> >> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
> >> 
> >> Since we don't know what platform firmware may do to the phy, so let's
> >> power cycle the phy upon system resume to resolve the issue.
> >> 
> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >> ---
> >> drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
> >> 1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> >> index 664e8ccc88d2..c2a87a408102 100644
> >> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> >> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> >> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
> >> 	    !e1000e_check_me(hw->adapter->pdev->device))
> >> 		e1000e_s0ix_exit_flow(adapter);
> >> 
> >> +	e1000_power_down_phy(adapter);
> >> +
> > 
> > static void e1000_power_down_phy(struct e1000_adapter *adapter)
> > {
> > 	struct e1000_hw *hw = &adapter->hw;
> > 
> > 	/* Power down the PHY so no link is implied when interface is down *
> > 	 * The PHY cannot be powered down if any of the following is true *
> > 	 * (a) WoL is enabled
> > 	 * (b) AMT is active
> > 	 * (c) SoL/IDER session is active
> > 	 */
> > 	if (!adapter->wol && hw->mac_type >= e1000_82540 &&
> > 	   hw->media_type == e1000_media_type_copper) {
> 
> Looks like the the function comes from e1000, drivers/net/ethernet/intel/e1000/e1000_main.c.
> However, this patch is for e1000e, so the function with same name is different.

Ah! Sorry. Missed that. Also it is not nice there are two functions in
the kernel with the same name.

> > Could it be coming out of S3 because it just received a WoL?
> 
> No, the issue can be reproduced by pressing keyboard or rtcwake.
 
Not relevant now, since i was looking at the wrong function. But i was
meaning the call is a NOP in the case WoL caused the wake up. So if
the issues can also happen after WoL, your fix is not going to fix it.

> > It seems unlikely that it is the MII_CR_POWER_DOWN which is helping,
> > since that is an MDIO write itself. Do you actually know how this call
> > to e1000_power_down_phy() fixes the issues?
> 

> I don't know from hardware's perspective, but I think the comment on
> e1000_power_down_phy_copper() can give us some insight:

And there is only one function called e1000_power_down_phy_copper()
:-)

> 
> /**
>  * e1000_power_down_phy_copper - Restore copper link in case of PHY power down
>  * @hw: pointer to the HW structure
>  *
>  * In the case of a PHY power down to save power, or to turn off link during a
>  * driver unload, or wake on lan is not enabled, restore the link to previous
>  * settings.                       
>  **/
> void e1000_power_down_phy_copper(struct e1000_hw *hw)
> {
>         u16 mii_reg = 0;
> 
>         /* The PHY will retain its settings across a power down/up cycle */
>         e1e_rphy(hw, MII_BMCR, &mii_reg);
>         mii_reg |= BMCR_PDOWN;
>         e1e_wphy(hw, MII_BMCR, mii_reg);
>         usleep_range(1000, 2000);
> }

I don't really see how this explains this:

> >> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> >> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/e1000e/phy.c#L181

So first off, the comments are all cut/paste from
e1000e_read_phy_reg_mdic(). It would be nice to s/read/write/g in that
function.

So it sets up the transaction and starts it. MDIO is a serial bus with
no acknowledgements. You clock out around 64 bits, and hope the PHY
receives it. The time it takes to send those 64 bits is fixed by the
bus speed, typically 2.5MHz.

So the driver polls waiting for the hardware to say the bits have been
sent. And this is timing out. How long that takes has nothing to do
with the PHY, or what state it is in. Powering down the PHY has no
effect on the MDIO bus master, and how long it takes to shift those
bits out. Which is why i don't think this patch is correct. This is
probably an MDIO bus issue, not a PHY issue.

Try dumping the value of MDIC in the good/bad case before the
transaction starts.

	 Andrew
