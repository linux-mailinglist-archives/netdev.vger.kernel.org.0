Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52605E6808
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiIVQFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiIVQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:05:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B9FD62E8;
        Thu, 22 Sep 2022 09:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pTxK7m5xFyeBH1/UifIeeV8u91XqECdD+VOzVFBx9Yw=; b=GkwkPLFOMjRKNYnHlUFhuCIRYs
        A0kaM4MHMGKYx05zCoQr3hbXwEADEKmsHqB8IkgkzcWSB7AUin5U26Edy4d1kPH/2S2bmc1T56OYv
        p4WAOeelsgcI/4PPe5wNBScbHTAqKnOvnGlJa1fDE6SrDZeohGE0s4RO+u3AvEGZSGD2bXl7u1oHI
        Gur6ZJi/8DuAC9vnz6pwGMo1JlWiJ1r5aF4blTOedPzTKslsaHXAA1MA/t6KOnXYsEy1pbWxlQQxl
        nQa1GsgzfHZqptB/L48MVdkEmiae8AHZ0igKQM2gBXC08Ieb8+bug6++5TEIcahJtkqmoQ44gBPGZ
        nlScRIOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34444)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1obOht-0004YD-2Y; Thu, 22 Sep 2022 17:05:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1obOhq-00010r-Sr; Thu, 22 Sep 2022 17:05:42 +0100
Date:   Thu, 22 Sep 2022 17:05:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable <stable@kernel.org>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix problem with previous
 memory leak fix
Message-ID: <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk>
References: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 01:44:44PM +0200, Greg Kroah-Hartman wrote:
> In commit fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> debugfs_lookup()"), if the module is unloaded, the directory will still
> be present if the module is loaded again and creating the directory will
> fail, causing the creation of additional child debugfs entries for the
> individual devices to fail.
> 
> As this module never cleaned up the root directory it created, even when
> loaded, and unloading/loading a module is not a normal operation, none
> of would normally happen.
> 
> To clean all of this up, use a tiny reference counted structure to hold
> the root debugfs directory for the driver, and then clean it up when the
> last user of it is removed from the system.  This should resolve the
> previously reported problems, and the original memory leak that
> fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> debugfs_lookup()") was attempting to fix.

For the record... I have a better fix for this, but I haven't been able
to get it into a state suitable for submission yet.

http://www.home.armlinux.org.uk/~rmk/misc/mvpp2-debugfs.diff

Not yet against the net tree. Might have time tomorrow to do that, not
sure at the moment. Medical stuff is getting in the way. :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
