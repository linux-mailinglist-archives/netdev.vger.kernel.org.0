Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB862C0EDD
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389406AbgKWPan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732376AbgKWPam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:30:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEE6C0613CF;
        Mon, 23 Nov 2020 07:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T88ZKe8uJpDP//bi76VDlnD7LL64Y2dRzRy+wHD8H90=; b=plWgy2SlcYPlSIKSeWedFsvLB
        uBM9mEnXVfwhEDyeVpueyEAqdIcYkJN9T0Hc0BkRt79x+dwcP8ARa07cawFAL3WO6u5pOufBonMsa
        jQ1PFnIEpIsxKmlKFALmzbZiBebfDx73Fj2px0j5p3Ry9Gf/3DyVus511uIm+jaGRJS+XvUvsM0K1
        RDRsChKHicICrViWxAOg0OPIETgzaPDD8hO+6pV2NlYEN/dUyXSSfqjqhCZVieKJkaTbKRZUQ9J/U
        i/Qh1q5TUSoG7JW/4FNEHVgJCYqKIMF4Wzf5LtpvRLCsD3YH6R4n5SmjH+oqlLlh8Bioo7YURaccN
        4J7sOlpoA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35112)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khDnT-00069u-Mm; Mon, 23 Nov 2020 15:30:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khDnQ-0006QK-1B; Mon, 23 Nov 2020 15:30:28 +0000
Date:   Mon, 23 Nov 2020 15:30:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch
Subject: Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports only
Message-ID: <20201123153027.GF1605@shell.armlinux.org.uk>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123151049.GV1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 03:10:49PM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> On Mon, Nov 23, 2020 at 04:52:40PM +0200, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> > 
> > Tx/Rx FIFO is a HW resource limited by total size, but shared
> > by all ports of same CP110 and impacting port-performance.
> > Do not divide the FIFO for ports which are not enabled in DTS,
> > so active ports could have more FIFO.
> > 
> > The active port mapping should be done in probe before FIFO-init.
> 
> It would be nice to know what the effect is from this - is it a
> small or large boost in performance?
> 
> What is the effect when the ports on a CP110 are configured for
> 10G, 1G, and 2.5G in that order, as is the case on the Macchiatobin
> board?

(dropped Antoine, his email is bouncing.)

I've rechecked, and on Macchiatobin, it certainly is:
Port 0 = 10G SFP/88x3310
Port 1 = 1G dedicated ethernet
Port 2 = 1G/2.5G SFP slot

and we do run the SFP slot at 2.5G speeds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
