Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5351B3A68C5
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhFNOQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhFNOQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:16:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1DDC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 07:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B2TZHk381oHEqI2pFW8AwGFr0g6/WiFU6NInsUgaBQc=; b=RLj5BwTkGTo5tdB81YUdfjjf9
        1Kw4K6uFQQl494Bkoh64oB/2AYalOVHHheBjaClYU1x7FuaCVNNhNRPHzgthwZSHLZll5W4zGf4pf
        encDtFAaYYXosPqSIpsAmLZr2ZjfK1V9OEOWY+tQT+MZKRA/C/J0O0BHo6hbPwdhVrnIw8VBIIEM3
        aSN3qUgLsITERb3Qza86Ef1F0spB0hk4Snzbvai+WAq+TRexNHvnGzAZkMSwqioGrf15s2+J2RtEP
        jR1QTf+1HHhvqUpb8uxeZ9w1jlOXD0O2b57peEPiFEZbrHiNi4UwKE7YFi+f/091rpket2D8/xYlh
        m65xzfsfg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45008)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsnLr-0004NG-Rk; Mon, 14 Jun 2021 15:14:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsnLp-0004Bm-Ob; Mon, 14 Jun 2021 15:14:05 +0100
Date:   Mon, 14 Jun 2021 15:14:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v3 net-next 2/4] net: phy: nxp-c45-tja11xx: express
 timestamp wraparound interval in terms of TS_SEC_MASK
Message-ID: <20210614141405.GV22278@shell.armlinux.org.uk>
References: <20210614134441.497008-1-olteanv@gmail.com>
 <20210614134441.497008-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614134441.497008-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 04:44:39PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> nxp_c45_reconstruct_ts() takes a partial hardware timestamp in @hwts,
> with 2 bits of the 'seconds' portion, and a full PTP time in @ts.
> 
> It patches in the lower bits of @hwts into @ts, and to ensure that the
> reconstructed timestamp is correct, it checks whether the lower 2 bits
> of @hwts are not in fact higher than the lower 2 bits of @ts. This is
> not logically possible because, according to the calling convention, @ts
> was collected later in time than @hwts, but due to two's complement
> arithmetic it can actually happen, because the current PTP time might
> have wrapped around between when @hwts was collected and when @ts was,
> yielding the lower 2 bits of @ts smaller than those of @hwts.
> 
> To correct for that situation which is expected to happen under normal
> conditions, the driver subtracts exactly one wraparound interval from
> the reconstructed timestamp, since the upper bits of that need to
> correspond to what the upper bits of @hwts were, not to what the upper
> bits of @ts were.
> 
> Readers might be confused because the driver denotes the amount of bits
> that the partial hardware timestamp has to offer as TS_SEC_MASK
> (timestamp mask for seconds). But it subtracts a seemingly unrelated
> BIT(2), which is in fact more subtle: if the hardware timestamp provides
> 2 bits of partial 'seconds' timestamp, then the wraparound interval is
> 2^2 == BIT(2).
> 
> But nonetheless, it is better to express the wraparound interval in
> terms of a definition we already have, so replace BIT(2) with
> 1 + GENMASK(1, 0) which produces the same result but is clearer.
> 
> Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
