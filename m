Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082A76DC5D0
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjDJKks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDJKks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:40:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FD519BC
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dmejku5XMyMe2fatDpytSyJcCN7ivGIlexUjrq2BQcA=; b=is35qZ+t9ahD/l0726ou1ACgQe
        +idtRyjl//Y6EEbs27FdnnG28OfiC2b59UoOVT8lkfieAveVTfRFyPTOApkaCvkq3yF97Sf7Mg63Q
        dhbHGe6fi84KJZmkXeJRqz0NyBsZ/sgugWwgavAnoLipDPa6UaaYCC7DwngRw39fQd60toWEx2ilZ
        eISFCiNp6cH9HlENi5TRyMEJwcyJC0DQ0qa4tuowBQzsCQFeRHnSdYIoPPAFCe+SRaqq1rU0Cob4M
        4IXdNQSDEd9vC/qscRNoI5axnAablfyl1r6NUI/qkNs4ZA8vJQyvfhi8nMEBbyAxEIg9dlqvgG0Ep
        JuWg8myQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42300)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1plox0-0004eg-CK; Mon, 10 Apr 2023 11:40:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ploww-00031c-CI; Mon, 10 Apr 2023 11:40:38 +0100
Date:   Mon, 10 Apr 2023 11:40:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Message-ID: <ZDPnpgYablOB5NRa@shell.armlinux.org.uk>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-6-jiawenwu@trustnetic.com>
 <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk>
 <00a701d96b7e$90edb890$b2c929b0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a701d96b7e$90edb890$b2c929b0$@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 03:32:12PM +0800, Jiawen Wu wrote:
> > > +				       struct phylink_link_state *state)
> > > +{
> > > +	int lpa, bmsr;
> > > +
> > > +	/* For C37 1000BASEX mode */
> > > +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > > +			      state->advertising)) {
> > > +		/* Reset link state */
> > > +		state->link = false;
> > > +
> > > +		/* Poll for link jitter */
> > > +		read_poll_timeout(pcs_read, lpa, lpa,
> > > +				  100, 50000, false, txgbe,
> > > +				  MDIO_MMD_VEND2, MII_LPA);
> > 
> > What jitter are you referring to? If the link is down (and thus this
> > register reads zero), why do we have to spin here for 50ms each time?
> > 
> 
> I found that when the last interrupt arrives, the link status is often
> still down, but it will become up after a while. It is about 30ms on my
> test.

It is normal for the first read of the BMSR to report that the link is
down after it has come up. This is so that software can see if the link
has failed since it last read the BMSR. Phylink knows this, and will
re-request the link state via the pcs_get_state() callback
appropriately.

Is it reporting that the link is down after the second read of the
link status after the interrupt?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
