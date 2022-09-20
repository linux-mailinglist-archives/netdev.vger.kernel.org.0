Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58CF5BEBC8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiITRVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiITRVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:21:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977C5F222
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3XY+u3b4MPH9JO7En2lknWTUywBDhYDbxNuLTb0DyC4=; b=aMJaYwuoUyxnS0GED0kkkefM0Q
        A8RB4qwltgbD+wA2gTyX8gepplXtKzjjD66+Uscg/gmwpmFQyDL4+G9wEls/6LBmYhl9gQ/C6Jzee
        q0yog0gkQoI09qDz6F56JPvkPZVXQnbOeNhayUF71Im/ODPK8quh3DFlMSDVnv3kSxxMCN5sCGqFd
        N9O0+2Eindso4dgueZDKRoqZJWkkJRTNMPffkEn7oJGUXNM2OCTluWSMPMU7D+3mvrZfaI+347J37
        IXz1jZpLSPs1BzLivQQgwRbq7nep8epISznVDlRRCPXcUnQRHqyQGi4JjiYCihOiO8UMVkr9C/1Pv
        y5L8tl/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34418)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oagwL-0002HZ-Rk; Tue, 20 Sep 2022 18:21:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oagwI-0007U0-Kh; Tue, 20 Sep 2022 18:21:42 +0100
Date:   Tue, 20 Sep 2022 18:21:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Baruch Siach <baruch@tkos.co.il>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH v2] net: sfp: workaround GPIO input signals bounce
Message-ID: <Yyn2ppzcRtLwiArd@shell.armlinux.org.uk>
References: <931ac53e9d6421f71f776190b2039abaa69f7d43.1663133795.git.baruch@tkos.co.il>
 <20220920081911.619ffeef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920081911.619ffeef@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 08:19:11AM -0700, Jakub Kicinski wrote:
> On Wed, 14 Sep 2022 08:36:35 +0300 Baruch Siach wrote:
> > From: Baruch Siach <baruch.siach@siklu.com>
> > 
> > Add a trivial debounce to avoid miss of state changes when there is no
> > proper hardware debounce on the input signals. Otherwise a GPIO might
> > randomly indicate high level when the signal is actually going down,
> > and vice versa.
> > 
> > This fixes observed miss of link up event when LOS signal goes down on
> > Armada 8040 based system with an optical SFP module.
> > 
> > Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> > ---
> > v2:
> >   Skip delay in the polling case (RMK)
> 
> Is this acceptable now, Russell?

I don't think so. The decision to poll is not just sfp->need_poll,
we also do it when need_poll is false, but we need to use the soft
state as well:

        if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
            !sfp->need_poll)
                mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);

I think, if we're going to use this "simple" debounce, we need to
add a flag to sfp_gpio_get_state() that indicates whether it's been
called from an interrupt.

However, even that isn't ideal, because if we poll, we get no
debouncing.

The unfortunate thing is, on the Macchiatobin (which I suspect is
the platform that Baruch is addressing here) there are no pull-up
resistors on the lines as required by the SFP MSA, so they tend to
float around when not being actively driven. Debouncing will help
to avoid some of the problems stemming from that, but ultimately
some will still get through. The only true real is a hardware one
which isn't going to happen.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
