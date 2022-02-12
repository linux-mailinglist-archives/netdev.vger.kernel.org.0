Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED044B3422
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiBLJ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 04:58:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiBLJ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 04:58:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BA124BE2;
        Sat, 12 Feb 2022 01:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=igbgibAHPAWbmEsOdSj/NeCBqcGOcsUXmWWMdBzi9LE=; b=LbMp1Kw5SaT236NypKQ9v+1DkG
        Frb0rgXN+qToHBpB9KqbBxagU+CBAqSEoPciqZSQ3BcH2tmyOivz7MLVbBv09BnrJQu/qn0eI1p7u
        z3WQpfjhLLY9AWB71ZPc+M10CQSkXl7pL1JQEgcC6QDFJazhhQslVc5ukWUd3arqJV1sImfpyx96J
        P2sn7Aj19coNN8a4kSP3UGG0NoXc4wVAkooy8bbWqhp9DDZzpSN4Mzv5EvTFIzTcN0niPuli4W6QU
        jBRqrCkE5E3kAjmxKKCuQpqFl77SDFsjYvw55aYA2uvIaLN8+GkHYXSKmlGKxGYCGoDnIlJOOJnIu
        5j6Ie1/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57210)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nIpAQ-00083F-9h; Sat, 12 Feb 2022 09:58:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nIpAO-0004Rn-8J; Sat, 12 Feb 2022 09:58:08 +0000
Date:   Sat, 12 Feb 2022 09:58:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvpp2: Check for null pcs in mvpp2_acpi_start()
Message-ID: <YgeEsF/cr8pfeUR4@shell.armlinux.org.uk>
References: <20220211234235.3180025-1-jeremy.linton@arm.com>
 <Ygb2E1DGYVBO+mNP@shell.armlinux.org.uk>
 <0e5f1807-22f1-ec5b-0b18-8bc02ad99760@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e5f1807-22f1-ec5b-0b18-8bc02ad99760@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 06:18:22PM -0600, Jeremy Linton wrote:
> Hi,
> 
> On 2/11/22 17:49, Russell King (Oracle) wrote:
> > On Fri, Feb 11, 2022 at 05:42:35PM -0600, Jeremy Linton wrote:
> > > Booting a MACCHIATObin with 5.17 the system OOPs with
> > > a null pointer deref when the network is started. This
> > > is caused by the pcs->ops structure being null on this
> > > particular platform/firmware.
> > 
> > pcs->ops should never be NULL. I'm surprised this fix results in any
> > kind of working networking.
> > 
> > Instead, the initialilsation of port->pcs_*.ops needs to be moved out
> > of the if (!mvpp2_use_acpi_compat_mode(..)) block. Please try this:
> 
> That appears to fix it as well, shall I re-post this with your fix, or will
> you?

I see you re-posted it anyway - that's fine. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
