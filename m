Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF092757C8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 14:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgIWMSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 08:18:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWMR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 08:17:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kL3iW-00FsW6-JS; Wed, 23 Sep 2020 14:17:48 +0200
Date:   Wed, 23 Sep 2020 14:17:48 +0200
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
Message-ID: <20200923121748.GE3770354@lunn.ch>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923074751.10527-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:47:51PM +0800, Kai-Heng Feng wrote:
> We are seeing the following error after S3 resume:
> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
> ...
> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
> 
> Since we don't know what platform firmware may do to the phy, so let's
> power cycle the phy upon system resume to resolve the issue.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 664e8ccc88d2..c2a87a408102 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>  	    !e1000e_check_me(hw->adapter->pdev->device))
>  		e1000e_s0ix_exit_flow(adapter);
>  
> +	e1000_power_down_phy(adapter);
> +

static void e1000_power_down_phy(struct e1000_adapter *adapter)
{
	struct e1000_hw *hw = &adapter->hw;

	/* Power down the PHY so no link is implied when interface is down *
	 * The PHY cannot be powered down if any of the following is true *
	 * (a) WoL is enabled
	 * (b) AMT is active
	 * (c) SoL/IDER session is active
	 */
	if (!adapter->wol && hw->mac_type >= e1000_82540 &&
	   hw->media_type == e1000_media_type_copper) {

Could it be coming out of S3 because it just received a WoL?

It seems unlikely that it is the MII_CR_POWER_DOWN which is helping,
since that is an MDIO write itself. Do you actually know how this call
to e1000_power_down_phy() fixes the issues?

   Andrew
