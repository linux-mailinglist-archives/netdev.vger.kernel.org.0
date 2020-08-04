Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB7B23C131
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHDVI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHDVI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:08:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0581C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 14:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dq1rwaWlCRCt1IeElSsJ9wmOpfUMxwGGmwbSdrHyFkQ=; b=mS4AMwGOylz174forVeBt9bLB
        +6moKLDH4E0mzOnWjDJqSHfWlrnFuBf6KgpEqVhDQd+4MnO5eB4EPM/v/GRCvct+OdcNJ16OQ8C7F
        GrZeRl5ex7M6VPue7lO8qeW1u1frQ/qqROys4nJQHYflx6ADvWIzf46rwiMiwf2/D4e5rTm4AyfAr
        dW1h1Q1KWOzouxL8tMQebISa8zF6gPtSclI/ucQ65xbrz7UFSz3ukrqPGAF09F+vAqo/U4/IE9Rc9
        0cRbnNwMNmwhAGVNLmIFupaJ90eQpLKuXhw38K/ek4ag9H3Z9WG9JGI8s3Ehwzz8UOgDdF04UvThC
        KWNpadTTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48370)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k34AG-0002us-46; Tue, 04 Aug 2020 22:08:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k34AB-0004Qc-5U; Tue, 04 Aug 2020 22:07:59 +0100
Date:   Tue, 4 Aug 2020 22:07:59 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
Message-ID: <20200804210759.GU1551@shell.armlinux.org.uk>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de>
 <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt>
 <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
> 
> 
> On 31/07/2020 13:06, Kurt Kanzenbach wrote:
> > On Thu Jul 30 2020, Petr Machata wrote:
> > > Kurt Kanzenbach <kurt@linutronix.de> writes:
> > > 
> > > > @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
> > > >   }
> > > >   EXPORT_SYMBOL_GPL(ptp_classify_raw);
> > > > +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
> > > > +{
> > > > +	u8 *data = skb_mac_header(skb);
> > > > +	u8 *ptr = data;
> > > 
> > > One of the "data" and "ptr" variables is superfluous.
> > 
> > Yeah. Can be shortened to u8 *ptr = skb_mac_header(skb);
> 
> Actually usage of skb_mac_header(skb) breaks CPTS RX time-stamping on
> am571x platform PATCH 6.
> 
> The CPSW RX timestamp requested after full packet put in SKB, but
> before calling eth_type_trans().
> 
> So, skb->data pints on Eth header, but skb_mac_header() return garbage.
> 
> Below diff fixes it for me.

However, that's likely to break everyone else.

For example, anyone calling this from the mii_timestamper rxtstamp()
method, the skb will have been classified with the MAC header pushed
and restored, so skb->data points at the network header.

Your change means that ptp_parse_header() expects the MAC header to
also be pushed.

Is it possible to adjust CPTS?

Looking at:
drivers/net/ethernet/ti/cpsw.c... yes.
drivers/net/ethernet/ti/cpsw_new.c... yes.
drivers/net/ethernet/ti/netcp_core.c... unclear.

If not, maybe cpts should remain unconverted - I don't see any reason
to provide a generic function for one user.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
