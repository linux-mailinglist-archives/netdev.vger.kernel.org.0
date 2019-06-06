Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC48537BE3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfFFSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:09:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48548 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:09:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AkX3CEqPFRgomhPRZWSRrO22yiRHG8peVJ6FTdgosnM=; b=DoKsvheHAfPORnies6fN/zMuF
        ZjFHQoHxLfPpFifktg7hcDMUFoCL2061abTR8q2V7mIZdRC2lruSahbyhXI5Ao9t2Xx/CdTHtLUje
        Ajja6aFt8omQ8LfALlTilO/TRr/WsvGbdW5F3SDNSK30sUUdPg4MB8ZqjWkHd0eUVpD5gH4zQ4xJp
        y+s/c1z5PJaQ0Kx3qmFcEz76btL8Fg+XyyDUuNDUtmENYajQ27EDkUSuT6CZRI9ZxvaRTIezkSL4z
        WDx/XjIyj8DbPUXD/P/t+clDS/BkcN1mUGUR8ShfkLNFmOQpOCT4TFe+HflyTqk1M+vgT+UHewqL8
        ZF8oE06Qw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56240)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYwp4-0007br-EZ; Thu, 06 Jun 2019 19:09:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYwp3-0003TB-2G; Thu, 06 Jun 2019 19:09:09 +0100
Date:   Thu, 6 Jun 2019 19:09:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: sfp: Stop SFP polling and interrupt
 handling during shutdown
Message-ID: <20190606180908.ctoxi7c4i2uothzn@shell.armlinux.org.uk>
References: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 12:06:17PM -0600, Robert Hancock wrote:
> SFP device polling can cause problems during the shutdown process if the
> parent devices of the network controller have been shut down already.
> This problem was seen on the iMX6 platform with PCIe devices, where
> accessing the device after the bus is shut down causes a hang.
> 
> Stop all delayed work in the SFP driver during the shutdown process, and
> set a flag which causes any further state checks or state machine events
> (possibly triggered by previous GPIO IRQs) to be skipped.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
> 
> This is an updated version of a previous patch "net: sfp: Stop SFP polling
> during shutdown" with the addition of stopping handling of GPIO-triggered
> interrupts as well, as pointed out by Russell King.
> 
>  drivers/net/phy/sfp.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 554acc8..5fdf573 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -191,6 +191,7 @@ struct sfp {
>  	struct delayed_work poll;
>  	struct delayed_work timeout;
>  	struct mutex sm_mutex;
> +	bool shutdown;
>  	unsigned char sm_mod_state;
>  	unsigned char sm_dev_state;
>  	unsigned short sm_state;
> @@ -1466,6 +1467,11 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
>  static void sfp_sm_event(struct sfp *sfp, unsigned int event)
>  {
>  	mutex_lock(&sfp->sm_mutex);
> +	if (unlikely(sfp->shutdown)) {
> +		/* Do not handle any more state machine events. */
> +		mutex_unlock(&sfp->sm_mutex);
> +		return;
> +	}
>  
>  	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
>  		mod_state_to_str(sfp->sm_mod_state),
> @@ -1704,6 +1710,13 @@ static void sfp_check_state(struct sfp *sfp)
>  {
>  	unsigned int state, i, changed;
>  
> +	mutex_lock(&sfp->sm_mutex);
> +	if (unlikely(sfp->shutdown)) {
> +		/* No more state checks */
> +		mutex_unlock(&sfp->sm_mutex);
> +		return;
> +	}
> +

I don't think you need to add the mutex locking - just check for
sfp->shutdown and be done with it...

> +static void sfp_shutdown(struct platform_device *pdev)
> +{
> +	struct sfp *sfp = platform_get_drvdata(pdev);
> +
> +	mutex_lock(&sfp->sm_mutex);
> +	sfp->shutdown = true;
> +	mutex_unlock(&sfp->sm_mutex);
> +
> +	cancel_delayed_work_sync(&sfp->poll);
> +	cancel_delayed_work_sync(&sfp->timeout);

Since the work cancellation will ensure that the works are not running
at the point they return, and should they then run again, they'll hit
the sfp->shutdown condition.

> +}
> +
>  static struct platform_driver sfp_driver = {
>  	.probe = sfp_probe,
>  	.remove = sfp_remove,
> +	.shutdown = sfp_shutdown,
>  	.driver = {
>  		.name = "sfp",
>  		.of_match_table = sfp_of_match,
> -- 
> 1.8.3.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
