Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE85857B612
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiGTMDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiGTMD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:03:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7F6B241;
        Wed, 20 Jul 2022 05:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=J3/vuSP1OlDuYrNtN1lLQQWblQlaDiWCzOeGFLX0ypI=; b=cTjTHhF78t/zn8py10GLSbfuWR
        144irXTiNu7ei0FVaxaau0q40T0tfMEJpP4cHIHKrIhqfkrPEDtkU/uHV60ALOMgf4KK1mXlCD2en
        RsXb666NZAEXGGZeMhI8XVtrzPqyKts5fN0V+folWJmLEeoBuG0eR+W8n2Oowmre1MR8D2tP4X0BS
        9TbWFz040uY72yGeJWvssJN1k9hZrrM1ODSEMlzTR0mHqgJjrLqHJbCS1IarJWy9kZXZMDdupfdEl
        Bjw9lramxcIHV88Z0m0mPE1OZ4zzDTyg7mLWnJKeUKRbM/g2nXsvzBAeesXNOuDlJ0SbVpGoYspGI
        smEcuL2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33464)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oE8QH-00043P-6e; Wed, 20 Jul 2022 13:03:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oE8QE-0003t7-V8; Wed, 20 Jul 2022 13:03:22 +0100
Date:   Wed, 20 Jul 2022 13:03:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/11] net: phy: Add support for rate adaptation
Message-ID: <YtfvChkHE6CGyt4x@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 07:49:50PM -0400, Sean Anderson wrote:
> Second, to reduce packet loss it may be desirable to throttle packet
> throughput. In past discussions [2-4], this behavior has been
> controversial.

It isn't controversial at all. It's something we need to support, but
the point I've been making is that if we're adding rate adaption, then
we need to do a better job when designing the infrastructure to cater
for all currently known forms of rate adaption amongst the knowledge
pool that we have, not just one. That's why I brought up the IPG-based
method used by 88x3310.

Phylink development is extremely difficult, and takes months or years
for changes to get into mainline when updates to drivers are required -
this is why I have a massive queue of changes all the time.

> It is the opinion of several developers that it is the
> responsibility of the system integrator or end user to set the link
> settings appropriately for rate adaptation. In particular, it was argued
> that it is difficult to determine whether a particular phy has rate
> adaptation enabled, and it is simpler to keep such determinations out of
> the kernel.

I don't think I've ever said that...

> Another criticism is that packet loss may happen anyway, such
> as if a faster link is used with a switch or repeater that does not support
> pause frames.

That isn't what I've said. Packet loss may happen if (a) pause frames
can not be sent by a PHY in rate adaption mode and (b) if the MAC can't
pace its transmission for the media/line speed. This is a fundamental
fact where a PHY will only have so much buffering capability, that if
the MAC sends packets at a faster rate than the PHY can get them out, it
runs out of buffer space. That isn't a criticism, it's a statement of
fact.

> I believe that our current approach is limiting, especially when
> considering that rate adaptation (in two forms) has made it into IEEE
> standards. In general, When we have appropriate information we should set
> sensible defaults. To consider use a contrasting example, we enable pause
> frames by default for switches which autonegotiate for them. When it's the
> phy itself generating these frames, we don't even have to autonegotiate to
> know that we should enable pause frames.

I'm not sure I understand what you're saying, because it doesn't match
what I've seen.

"we enable pause frames by default for swithes which autonegotiate for
them" - what are you talking about there? The "user" ports on the
switch, or the DSA/CPU ports? It has been argued that pause frames
should not be enabled for the CPU port, particularly when the CPU port
runs at a slower speed than the switch - which happens e.g. on the VF610
platforms.

Most CPU ports to switches I'm aware of are specified either using a
fixed link in firmware or default to a fixed link both without pause
frames. Maybe this is just a quirk of the mv88e6xxx setup.

"when it's the phy itself generating these frames, we don't even have to
autonegotiate to know that we should enable pause frames." I'm not sure
that's got any relevance. When a PHY is in rate adapting mode, there are
two separate things that are going on. There's the media side link
negotiation and parameters, and then there's the requirements of the
host-side link. The parameters of the host-side link do not need to be
negotiated with the link partner, but they do potentially affect what
link modes we can negotiate with our link partner (for example, if the
PHY can't handle HD on the media side with the MAC operating FD). In any
case, if the PHY requires the MAC to receive pause frames for its rate
adaption to work, then this doesn't affect the media side
autonegotiation at all. Hence, I don't understand this comment.

> Note that
> even when we determine (e.g.) the pause settings based on whether rate
> adaptation is enabled, they can still be overridden by userspace (using
> ethtool). It might be prudent to allow disabling of rate adaptation
> generally in ethtool as well.

This is no longer true as this patch set overrides whatever receive
pause state has been negotiated or requested by userspace so that rate
adaption can still work.

The future work here is to work out whether we should disable rate
adaption if userspace requests receive pause frames to be disabled, or
whether switching to another form of controlling rate adaption would be
appropriate and/or possible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
