Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD05315ED
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfEaUMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:12:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36926 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfEaUMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M3fxFXBiR01DfNnCBF3ez0YQUgixhDzyxwfRRR1oUYM=; b=X5/8RbOa4c96PedX22ChyWKVL
        EKyJ8BPC+S+NofAkStCtGmExoz9UQp+ALvwkq1logRKBRcL8lboBHqWG+UWnHkxZaL2QPxu42Akse
        +kd6eKSD8/DcrYtbhhmMc98xH23DHqyAo/bHcLVi5IbYb7ypg7ed7vHjrPIjDtVRMEcN4iulyGQQh
        0JFe9S8U9TS4MO80VRwziTdw34ycaymzYltd97j2/sUGyn6TeI1hK6NdM8Wj/LlCXPy0q4XwIrUih
        ksRs9xLUoh/geG8TtGbUys3ZbtWKy9NTE59q5AwPegwdXdHa5dckZAKz1Cs6l9M170J9+mrzwUqDJ
        60ZkDqC/w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38428)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWntK-0002ss-0O; Fri, 31 May 2019 21:12:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWntJ-0006cd-CF; Fri, 31 May 2019 21:12:41 +0100
Date:   Fri, 31 May 2019 21:12:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: Stop SFP polling during shutdown
Message-ID: <20190531201241.k7aqz3axhkpdro5e@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-2-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330285-30246-2-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 01:18:02PM -0600, Robert Hancock wrote:
> SFP device polling can cause problems during the shutdown process if the
> parent devices of the network controller have been shut down already.
> This problem was seen on the iMX6 platform with PCIe devices, where
> accessing the device after the bus is shut down causes a hang.
> 
> Stop all delayed work in the SFP driver during the shutdown process to
> avoid this problem.

What about interrupts?

> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/sfp.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 554acc8..6b6c83d 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1928,9 +1928,18 @@ static int sfp_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static void sfp_shutdown(struct platform_device *pdev)
> +{
> +	struct sfp *sfp = platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&sfp->poll);
> +	cancel_delayed_work_sync(&sfp->timeout);
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
