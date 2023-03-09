Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B9A6B2641
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCIOHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCIOGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:06:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52879F28A4;
        Thu,  9 Mar 2023 06:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=p4LnmBBm9xWxd/0OIEuDKqlIYCXfSPwHaLZhH3s8UOo=; b=F47G2uyR+Jrm+i/8eW+b5JtJP9
        ef7vZt+p0VTUWMgbngoSIyNGpjiXLA6xUUIhv/3AP+tuAnGNJdg+oWgaVXzG/JEQNowqtrgFxrJXX
        +OyoAqthc2VcO7owirtp05KDOUqDWB9eDyCAgBdvWA1SQPmBCSaSv4s+7vnrMUCTj7Sx0OTf6s5GT
        mtDHPTG64FJ1vbKQjRHBaMOSCzuiLACVZb+FScCsm9i6qTgzExU96ZoVsk4w3IWxYHmxnfTmPeyfU
        dTfeP1ak5/HdivIpefmnktH30tX9o+w+yz+XTWP+bNw8ux/O5gCqDYkWjCahfMKCsC41pwU/Ej3ev
        CcfDonEg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39770)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1paGtJ-0004jI-Av; Thu, 09 Mar 2023 14:05:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1paGtH-0003i8-7D; Thu, 09 Mar 2023 14:05:07 +0000
Date:   Thu, 9 Mar 2023 14:05:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-7-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125421.3900962-7-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:54:20PM +0100, Lukasz Majewski wrote:
> Running of the mv88e6xxx_validate_frame_size() function provided following
> results:
> 
> [    1.585565] BUG: Marvell 88E6020 has differing max_frame_size: 1632 != 2048
> [    1.592540] BUG: Marvell 88E6071 has differing max_frame_size: 1632 != 2048
> 		^------ Correct -> mv88e6250 family max frame size = 2048B
> 
> [    1.599507] BUG: Marvell 88E6085 has differing max_frame_size: 1632 != 1522
> [    1.606476] BUG: Marvell 88E6165 has differing max_frame_size: 1522 != 1632
> [    1.613445] BUG: Marvell 88E6190X has differing max_frame_size: 10240 != 1522
> [    1.620590] BUG: Marvell 88E6191X has differing max_frame_size: 10240 != 1522
> [    1.627730] BUG: Marvell 88E6193X has differing max_frame_size: 10240 != 1522
> 		^------ Needs to be fixed!!!
> 
> [    1.634871] BUG: Marvell 88E6220 has differing max_frame_size: 1632 != 2048
> [    1.641842] BUG: Marvell 88E6250 has differing max_frame_size: 1632 != 2048
> 		^------ Correct -> mv88e6250 family max frame size = 2048B

If I understand this correctly, in patch 4, you add a call to the 6250
family to call mv88e6185_g1_set_max_frame_size(), which sets a bit
called MV88E6185_G1_CTL1_MAX_FRAME_1632 if the frame size is larger
than 1518.

However, you're saying that 6250 has a frame size of 2048. That's fine,
but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632 rather misleading as a
definition. While the bit may increase the frame size, I think if we're
going to do this, then this definition ought to be renamed.

That said, I would like Andrew and Vladimir's thoughts on this too.

Finally, I would expect, if this series was done the way I suggested,
that patch 1 should set the max frame size according to how the
existing code works, which means patch 2, being the validation patch,
should be completely silent if patch 1 is correct - and that's the
entire point of validating. It's to make sure that patch 1 is
correct.

If it isn't correct, then patch 1 is wrong and should be updated.

Essentially, this patch should only exist if the values we are using
today are actually incorrect.

To put this another way, the conversion from our existing way of
determining the max mtu to using the .max_frame_size method should be
an entire no-op from the driver operation point of view. Then any
errors in those values should be fixed and explained in a separate
commit. Then the new support added.

At least that's how I see it. Andrew and Vladimir may disagree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
