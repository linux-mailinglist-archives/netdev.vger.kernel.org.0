Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE723B32A2
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhFXPg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFXPg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:36:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80684C061574;
        Thu, 24 Jun 2021 08:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=77vhiGE0W9ZQnyqXdZKxBbTQvre+752PKaRIyl0obU8=; b=d9xkfsMKphY4uq/WU2nfEB3rv
        Bc4P3wKOhXQ4v2PeS6ArqyTgsPe8tbX8mXenlSVszoT6VEmiDdhtL20x9oK5gyCQEmBkra293lmX9
        t74RBGb95nr+321qg8L1PltYO+pShT6DYJP0me0fj3DBhaURNOnpwAug79IZxsA5+yYLKrc6ZdW8X
        daH99xmiCXl5XoYXAus8zR2KExZhoUDxqxbGvn1X1XmLJG6s2O6o68qPyflStlLUMbfYGTBqqHe2r
        WT5sqAGXrUPlRID6gIH8/Y7OWip31gjZR7NF9AaUvprJpeb34nrjaOAMRxX5bqUZhspdO+j0LuXdv
        nIUdstqUQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45312)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lwRN8-0007tY-MW; Thu, 24 Jun 2021 16:34:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lwRN6-0005nj-UI; Thu, 24 Jun 2021 16:34:28 +0100
Date:   Thu, 24 Jun 2021 16:34:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Behun <marek.behun@nic.cz>,
        weifeng.voon@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com
Subject: Re: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210624153428.GR22278@shell.armlinux.org.uk>
References: <20210623130929.805559-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623130929.805559-1-pei.lee.ling@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 09:09:29PM +0800, Ling Pei Lee wrote:
> @@ -106,6 +107,17 @@ enum {
>  	MV_V2_TEMP_CTRL_DISABLE	= 0xc000,
>  	MV_V2_TEMP		= 0xf08c,
>  	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
> +	MV_V2_MAGIC_PKT_WORD0	= 0xf06b,
> +	MV_V2_MAGIC_PKT_WORD1	= 0xf06c,
> +	MV_V2_MAGIC_PKT_WORD2	= 0xf06d,
> +	/* Wake on LAN registers */
> +	MV_V2_WOL_CTRL		= 0xf06e,
> +	MV_V2_WOL_STS		= 0xf06f,
> +	MV_V2_WOL_CLEAR_STS	= BIT(15),
> +	MV_V2_WOL_MAGIC_PKT_EN	= BIT(0),
> +	MV_V2_PORT_INTR_STS	= 0xf040,
> +	MV_V2_PORT_INTR_MASK	= 0xf043,
> +	MV_V2_WOL_INTR_EN	= BIT(8),

Please put these new register definitions in address order. This list is
first sorted by MMD and then by address. So these should be before the
definition of MV_V2_TEMP_CTRL.

As I suspected, the 88x3310 shares this same register layout for the WOL
and at least bit 8 of the interrupt status and enable registers.

Thanks, and thanks for reminding me to look at this today!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
