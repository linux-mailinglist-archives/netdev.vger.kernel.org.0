Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BB44B3C44
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 17:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiBMQWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 11:22:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiBMQWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 11:22:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8AC5A0B8;
        Sun, 13 Feb 2022 08:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4YsJZ4gtzV4ZFiKdZ3rVxaf1qsqpFia1yffSaxKOPR4=; b=A1ah05IWZ4M0r3HGz6UVV0H+rK
        AkET0r1x6xzfXFsx0hl/06ps1l4VmgpBniZAq1rRD69nvafCQCZcatEl0Y0hE5fRnbFivI1R93v17
        XsEZ39UzsBkW21LH9oo/oKHnrux+lvVQDViohxV8fR21NfLSr7cQhE/yXabRafZoHavrLBCWgpR/o
        w+3GibPL9jKveNdbb7FzV+/vPr17Tvf/tjX0QuqW6Iv3GuLtIjz0UGXkWTlVbhBf/MgkxGT4wKsEk
        CdEMyR9hHFVLstMGFWNvFMWv+qevCb+nWePR2dew7s67jWIBp6KW0VqhGaSy12WPfOJVqUyGE1LFS
        FDx+IoeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nJHdI-0000WQ-F6; Sun, 13 Feb 2022 16:21:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nJHdG-0005hw-5f; Sun, 13 Feb 2022 16:21:50 +0000
Date:   Sun, 13 Feb 2022 16:21:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fix validation of built-in
 PHYs on 6095/6097
Message-ID: <YgkwHqjMq5DtoMd1@shell.armlinux.org.uk>
References: <20220213003702.2440875-1-tobias@waldekranz.com>
 <YgkAfy3fQ1hq7nlf@shell.armlinux.org.uk>
 <87tud2aijg.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tud2aijg.fsf@waldekranz.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 04:32:51PM +0100, Tobias Waldekranz wrote:
> On Sun, Feb 13, 2022 at 12:58, "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > I'm wondering what the point of checking the cmode here is - if the port
> > is internal, won't this switch always have cmode == PHY?
> 
> For all intents and purposes: I think so. It is just that the functional
> spec. also lists cmode == 4 == disabled (PHYDetect == 0) for the
> internal ports. So I figured that there might be some way of strapping
> ports as disabled that I had never come across.

I don't think there is a way to pinstrap the internal ports. As far as
I can see, the only way would be for software to program PHY Detect to
zero.

If we wanted a port to be disabled, then describing it in firmware as
being enabled would be a bug. If it isn't described in firmware, the
DSA code won't even consider looking at the port.

> Do you think we should drop it?

I think so.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
