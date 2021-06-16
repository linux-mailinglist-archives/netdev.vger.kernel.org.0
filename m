Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4303A3A971E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhFPKW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbhFPKW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:22:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33133C06175F;
        Wed, 16 Jun 2021 03:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3S/UaOiglV8sU2MJUjiJaJvpv8j/sHW/Cezjvx2y14Y=; b=wCqpiOo4dyL3V2cCWohqHRtIM
        iUybzBSVZvMe3eAPpHMfGBpVOs1LcAROZ8pt1aFybpM3jg1F1juGz8riiD4VUCCYWiDSC3HYz2ZFY
        UOjaNx43AB0zY/5LEbXBTA2nBijob7xipuUHmH9eOsMekCwNc5z3katj8Bwo3Ydi8frBP3RP3J3UC
        Y+6DDM8UxqA3K2mPIaekt3aEtsX8o1b9JcoE8aUOFjfb0u7gjNchBICJzxwq/tro3bsd91va6bgR2
        HrWgghzrC8o6d9EYSP3STKmMJPnDraHNe8S59PqmCJyKHD8TztCkIbOuvNuIDgRgOnitVOLEIujqC
        VfTcm2m1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45058)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ltSf3-00072V-Vr; Wed, 16 Jun 2021 11:20:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ltSf0-0005wF-Ns; Wed, 16 Jun 2021 11:20:38 +0100
Date:   Wed, 16 Jun 2021 11:20:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: Re: [PATCH net 1/2] net: fec_ptp: add clock rate zero check
Message-ID: <20210616102038.GB22278@shell.armlinux.org.uk>
References: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
 <20210616091426.13694-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616091426.13694-2-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 05:14:25PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Add clock rate zero check to fix coverity issue of "divide by 0".
> 
> Fixes: commit 85bd1798b24a ("net: fec: fix spin_lock dead lock")
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 1753807cbf97..7326a0612823 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -604,6 +604,10 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
>  	fep->ptp_caps.enable = fec_ptp_enable;
>  
>  	fep->cycle_speed = clk_get_rate(fep->clk_ptp);
> +	if (!fep->cycle_speed) {
> +		fep->cycle_speed = NSEC_PER_SEC;
> +		dev_err(&fep->pdev->dev, "clk_ptp clock rate is zero\n");

If this is supposed to be an error message, it doesn't convey that
something is really wrong to the user. Maybe something like this would
be more meaningful to the user:

	"PTP clock rate should not be zero, using 1GHz instead. PTP
	clock may be unreliable.\n"

It may be appropriate not to publish PTP support for the interface if
we don't have a valid clock rate, which is probably the safer approach
and would probably make the problem more noticable to the end user so
it gets fixed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
