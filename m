Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0BF1BE08F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgD2ORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726836AbgD2ORs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:17:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509D9C03C1AD;
        Wed, 29 Apr 2020 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gy20xOpcARjPE/WRcsIp2GKWb0LL9aFImxYlWNFOUEc=; b=HkoAt8vH0GBzy0bZZ5RF/d4Em
        vUijMxI/1wth5CHT46lActRXcXYzn4o7f8gNZ4vHFTkNpcBw5UTR7+AbIWOrxl89sfvGNsIYAGM/A
        1fBIiUMeygZbsjakO9er37YLCiMLd1J3G7FPtFxU6DqX7/IBTA4q9PHRrDx0DarhsnTWeRY8qzKtH
        2CIKbxH3Whuetu9WblsOw6brOc8eBn1jQHTXuabT54Sv90D9wTxz9YPxJyzQ1EiZoutbgCx4Es/bV
        3ms48XhWlQkoXK7RYvOAlHwzLisoYnp/eTQGVX3bnKyzF7nbqJbHP0v2wp4ETboJ/58BnbPkExMdq
        PbEStFMmQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:33810)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jTnWs-000843-6k; Wed, 29 Apr 2020 15:17:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jTnWo-00019D-01; Wed, 29 Apr 2020 15:17:34 +0100
Date:   Wed, 29 Apr 2020 15:17:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: remove duplicate assignment of
 struct members
Message-ID: <20200429141733.GG1551@shell.armlinux.org.uk>
References: <20200429141001.8361-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429141001.8361-1-yanaijie@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:10:01PM +0800, Jason Yan wrote:
> These struct members named 'phylink_validate' was assigned twice:
> 
> static const struct mv88e6xxx_ops mv88e6190_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6190x_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390x_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6191_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6290_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> Remove all the first one and leave the second one which are been used in
> fact. Be aware that for 'mv88e6190x_ops' the assignment functions is
> different while the others are all the same. This fixes the following
> coccicheck warning:
> 
> drivers/net/dsa/mv88e6xxx/chip.c:3911:48-49: phylink_validate: first
> occurrence line 3965, second occurrence line 3967
> drivers/net/dsa/mv88e6xxx/chip.c:3970:49-50: phylink_validate: first
> occurrence line 4024, second occurrence line 4026
> drivers/net/dsa/mv88e6xxx/chip.c:4029:48-49: phylink_validate: first
> occurrence line 4082, second occurrence line 4085
> drivers/net/dsa/mv88e6xxx/chip.c:4184:48-49: phylink_validate: first
> occurrence line 4238, second occurrence line 4242

This looks like a mistake while rebasing / updating the code which
resulted in commit 4262c38dc42e ("net: dsa: mv88e6xxx: Add SERDES stats
counters to all 6390 family members").

In light of what the commit which introduced this did, this patch looks
correct to me.

Fixes: 4262c38dc42e ("net: dsa: mv88e6xxx: Add SERDES stats counters to all 6390 family members")
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index dd8a5666a584..2b4a723c8306 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3962,7 +3962,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
>  	.serdes_get_stats = mv88e6390_serdes_get_stats,
>  	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
>  	.serdes_get_regs = mv88e6390_serdes_get_regs,
> -	.phylink_validate = mv88e6390_phylink_validate,
>  	.gpio_ops = &mv88e6352_gpio_ops,
>  	.phylink_validate = mv88e6390_phylink_validate,
>  };
> @@ -4021,7 +4020,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
>  	.serdes_get_stats = mv88e6390_serdes_get_stats,
>  	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
>  	.serdes_get_regs = mv88e6390_serdes_get_regs,
> -	.phylink_validate = mv88e6390_phylink_validate,
>  	.gpio_ops = &mv88e6352_gpio_ops,
>  	.phylink_validate = mv88e6390x_phylink_validate,
>  };
> @@ -4079,7 +4077,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
>  	.serdes_get_stats = mv88e6390_serdes_get_stats,
>  	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
>  	.serdes_get_regs = mv88e6390_serdes_get_regs,
> -	.phylink_validate = mv88e6390_phylink_validate,
>  	.avb_ops = &mv88e6390_avb_ops,
>  	.ptp_ops = &mv88e6352_ptp_ops,
>  	.phylink_validate = mv88e6390_phylink_validate,
> @@ -4235,7 +4232,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
>  	.serdes_get_stats = mv88e6390_serdes_get_stats,
>  	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
>  	.serdes_get_regs = mv88e6390_serdes_get_regs,
> -	.phylink_validate = mv88e6390_phylink_validate,
>  	.gpio_ops = &mv88e6352_gpio_ops,
>  	.avb_ops = &mv88e6390_avb_ops,
>  	.ptp_ops = &mv88e6352_ptp_ops,
> -- 
> 2.21.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
