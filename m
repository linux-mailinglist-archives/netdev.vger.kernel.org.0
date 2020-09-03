Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A742825BDBA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgICIsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgICIsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 04:48:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C159C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 01:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Cvx3GXtX9GzzK8hZ4XuKngul/H6EswEh8fIchT8sLd4=; b=yp0FNPsuFwYdRxxx14XIAEDfx
        X24xMhhGO6cE7/8wBaTsil6C+OdyKaCEWUMO71DkkeOUvpxwFxT8weHo3bOOTN+XS06wqCKAnIdap
        Yf0UQSAD2KcnmdR1Qt8xI5QzlDmip7bUkAYt5KuHc+OMy+e2/rTSHxqRVRtaDSqOTt/Eb7YbVps/s
        Bo9ljvHyGilyZzh0FDFxFs8Rm90vBV4dtp3s+VUprhVRfC4EARyo05S6AAZRl++bxzzhRKjprPU7A
        uk1SH3j6nAgwaAEWnsTtMqNY/sLbD9Cvt8PQTkuiwtSlyAn5KUL8n1ncoHK1LR+7o/FpOTGSk04EF
        sb8Gahqzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60554)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kDkur-00061g-Og; Thu, 03 Sep 2020 09:48:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kDkun-0000f6-0B; Thu, 03 Sep 2020 09:48:17 +0100
Date:   Thu, 3 Sep 2020 09:48:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] net: mvpp2: ptp: add interrupt handling
Message-ID: <20200903084816.GO1551@shell.armlinux.org.uk>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
 <E1kDVMg-0000k9-6g@rmk-PC.armlinux.org.uk>
 <20200903013940.GA3090178@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903013940.GA3090178@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 03:39:40AM +0200, Andrew Lunn wrote:
> > +static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
> > +{
> > +	void __iomem *ptp_q;
> > +	u32 r0, r1, r2;
> > +
> > +	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
> > +	if (nq)
> > +		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
> > +
> > +	while (1) {
> > +		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
> > +		if (!r0)
> > +			break;
> > +
> > +		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
> > +		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
> > +	}
> > +}
> 
> Hi Russell
> 
> That is a rather odd interrupt handler, basically throwing everything
> away. Maybe add a comment about what is going on?

We end up doing something with it in the following patch. I could
squash 6 and 7 together, which would avoid this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
