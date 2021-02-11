Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2BB318B53
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBKM76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbhBKM5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:57:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61063C061756;
        Thu, 11 Feb 2021 04:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P/fbYJLfIiMUlzLH/CM3SF7lHDzXC2EAX4Nohl28cUU=; b=gESxwmAXcXpBCH9mYag7eU0Fy
        31Wx62ZhmqfD/7kLgefAaPVhC9BMcUlJzieQoTCzoVURLeCbuuOcbAfO17grnbSfmLSaNJzi7RHN7
        gEucuWxan/R0AgfG/bs5fpdZ8deoFn5VeQYvdINO1hnxkx81Ei6vtfcH01ahemeIY6CO0Zpec3day
        X9UeudPCSNgaOFoMMuaCJIt+pfidBvkHs/9NxStlsy8It1HsDSAEw+w340rn3wTW8ZCRiDf5OaxTz
        wFgf+06aKGk3E7C4qZsBOeqqFJTtw25wAJxNf5Q/ZjcNepTOTPM0ly72TMVwxXhLce/Xi2XfKEXMK
        wcn0Cd0xA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42034)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lABVv-0006As-IM; Thu, 11 Feb 2021 12:56:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lABVu-00066i-Kb; Thu, 11 Feb 2021 12:56:06 +0000
Date:   Thu, 11 Feb 2021 12:56:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 13/15] net: mvpp2: add PPv23 RX FIFO flow
 control
Message-ID: <20210211125606.GH1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-14-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-14-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:49:00PM +0200, stefanc@marvell.com wrote:
> +/* Configure Rx FIFO Flow control thresholds */
> +void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en)
> +{
> +	int val;

	u32 ?

> +
> +	val = mvpp2_read(priv, MVPP2_RX_FC_REG(port));
> +
> +	if (en)
> +		val |= MVPP2_RX_FC_EN;
> +	else
> +		val &= ~MVPP2_RX_FC_EN;
> +
> +	mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);

	if (en)
		val = MVPP2_RX_FC_EN;
	else
		val = 0;

	mvpp2_modify(priv + MVPP2_RX_FC_REG(port), MVPP2_RX_FC_EN, val);

?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
