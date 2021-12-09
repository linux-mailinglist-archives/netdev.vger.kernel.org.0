Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CFC46E8E3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbhLINSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbhLINSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:18:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0B0C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 05:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7rc2LETThfTw6UpoMBQEPgeN7FitD8uA5UkWVs/Zubk=; b=K91ztcXOnsrD889e7JOdV9n8xS
        m2xAx3Zk41Vpkxb5j27pf6eaJplgxJrTO6UxIiHEXYJ4jBo34ybX7vldTXr5MwmNz0HWXQvTD002F
        vkET4YPYrSW3vIHnEMYu26HJRbJdiGBiDRQy+CEfIDmNty2QFzJqPsH4YexOBSRqOgtKs//EcY1hu
        H9GQhRvQ+Vg1WnxLW83nQpznvZaDKpkg1tTDJ7M9kW1CgLOwm3xwjO8hM672vVC5QB3FTK+57dsiN
        qGnNHpFbcof814+mKxfbuCRzNNDp5vKXl4QNqynwvQx6FU4uxZYHm9f9Cgc7fOFuYdLskaWnWuCa2
        p+wW3Qow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56196)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mvJGE-0008UR-PG; Thu, 09 Dec 2021 13:14:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mvJGB-0007F8-TU; Thu, 09 Dec 2021 13:14:56 +0000
Date:   Thu, 9 Dec 2021 13:14:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: phylink: add legacy_pre_march2020
 indicator
Message-ID: <YbIBT7/6b0evemPB@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
 <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series was incorrectly threaded to its cover letter; the patches
have now been re-sent with the correct message-ID for their cover
letter. Sadly, this mistake was not obvious until I looked at patchwork
to work out why they haven't been applied yet.

On Tue, Dec 07, 2021 at 03:53:37PM +0000, Russell King (Oracle) wrote:
> Add a boolean to phylink_config to indicate whether a driver has not
> been updated for the changes in commit 7cceb599d15d ("net: phylink:
> avoid mac_config calls"), and thus are reliant on the old behaviour.
> 
> We were currently keying the phylink behaviour on the presence of a
> PCS, but this is sub-optimal for modern drivers that may not have a
> PCS.
> 
> This commit merely introduces the new flag, but does not add any use,
> since we need all legacy drivers to set this flag before it can be
> used. Once these legacy drivers have been updated, we can remove this
> flag.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  include/linux/phylink.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 01224235df0f..d005b8e36048 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -84,6 +84,8 @@ enum phylink_op_type {
>   * struct phylink_config - PHYLINK configuration structure
>   * @dev: a pointer to a struct device associated with the MAC
>   * @type: operation type of PHYLINK instance
> + * @legacy_pre_march2020: driver has not been updated for March 2020 updates
> + *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
>   * @pcs_poll: MAC PCS cannot provide link change interrupt
>   * @poll_fixed_state: if true, starts link_poll,
>   *		      if MAC link is at %MLO_AN_FIXED mode.
> @@ -97,6 +99,7 @@ enum phylink_op_type {
>  struct phylink_config {
>  	struct device *dev;
>  	enum phylink_op_type type;
> +	bool legacy_pre_march2020;
>  	bool pcs_poll;
>  	bool poll_fixed_state;
>  	bool ovr_an_inband;
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
