Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5254A88E2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352392AbiBCQok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352386AbiBCQoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:44:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FDEC061714;
        Thu,  3 Feb 2022 08:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jThIhFNBrb3xj2YQLkczkGqkTy9wIvQP7gVhgnzkrew=; b=zGqOR7+LqSrG510WGhf1Ch1m+Q
        zInXDUP+4zUsUrFPitgFSW+BwbHex8XmIlJT7thj0wp4BGrUyfHA+/mkPSu8CAYR2a8B7LsJpIVbA
        N5gpuO+O7H3tPq8CUi8kGBhgqdRTkcgxmXICWE+dL+up2T1R+KeuuXYuzT7Gp4Cuf1mw3+s6E46yj
        lg6bKHZlj4VFjSRnTYgs2sGXT/CoQbquXe3QK9Wwygp0lxg2M8kzhI/PcsZALiYg8Eqq511/Xxd+m
        yInasAcEDOvhjUF3etd1bOFnYK37Zl3SlsnaKMYrH5FZyOWqqY69AUQdLoYSsrGcGv+5TW1HIoyo+
        JgXhnVbQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57016)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFfDf-0002s5-AV; Thu, 03 Feb 2022 16:44:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFfDc-00049q-6H; Thu, 03 Feb 2022 16:44:24 +0000
Date:   Thu, 3 Feb 2022 16:44:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sebastien.laveze@oss.nxp.com, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: ensure PTP time register reads are
 consistent
Message-ID: <YfwGaD06/3W1UFQ+@shell.armlinux.org.uk>
References: <20220203160025.750632-1-yannick.vignon@oss.nxp.com>
 <YfwCnV2TV8fznZ33@shell.armlinux.org.uk>
 <13dc6f72-8ef4-6990-1c67-2b92c6894e87@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13dc6f72-8ef4-6990-1c67-2b92c6894e87@oss.nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 05:38:10PM +0100, Yannick Vignon wrote:
> On 2/3/2022 5:28 PM, Russell King (Oracle) wrote:
> > On Thu, Feb 03, 2022 at 05:00:25PM +0100, Yannick Vignon wrote:
> > > From: Yannick Vignon <yannick.vignon@nxp.com>
> > > 
> > > Even if protected from preemption and interrupts, a small time window
> > > remains when the 2 register reads could return inconsistent values,
> > > each time the "seconds" register changes. This could lead to an about
> > > 1-second error in the reported time.
> > 
> > Have you checked whether the hardware protects against this (i.o.w. the
> > hardware latches the PTP_STSR value when PTP_STNSR is read, or vice
> > versa? Several PTP devices I've looked at do this to allow consistent
> > reading.
> > 
> 
> It doesn't. I was able to observe inconsistent values doing reads in either
> order, and we had already observed the issue with that same IP on another
> device (Cortex-M based, not running Linux). It's not easy to reproduce, the
> time window is small, but it's there.

Okay, thanks.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
