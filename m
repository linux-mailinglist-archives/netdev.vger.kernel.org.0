Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F17265E94
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 13:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgIKLMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 07:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 07:12:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAB8C061573;
        Fri, 11 Sep 2020 04:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ezJ1BgslRUnjJEWuhVuP3BQAlkdnjIJCQAO6atDyaiI=; b=G9EACaFQiQzZdErsfxmzjK0eX
        STphpNyBaCBub4VFmoFa+wXHGY7r/1nF9u9b8ZTkP5Dm7qQPSLKc3R8A0v9xYyF/JdbZaZjK2RloD
        ks1Qr3rjq/YdhzcjvmXF8zm0uRuKIpu0ut5QbaD89HyrzoEH1VC99wOQvJHeeJkK1UlvnAJ+aXd60
        PQP4a34JmoImGxlxTWS+uqPoW29pmuGq7JR8y278pPJjtx5R45cILYyVGKLiZagYv8jks4SN2Sruf
        rMY+2GTtETfcXsX9fRnLa91H5xnTJOU/ktrDuDXTceU9EUiuO6ROCq/jt+281DesV0yS/zAzYAQ8J
        D+qM89W0Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33010)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kGgyI-0007Hz-0o; Fri, 11 Sep 2020 12:12:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kGgyE-0008Aq-HL; Fri, 11 Sep 2020 12:11:58 +0100
Date:   Fri, 11 Sep 2020 12:11:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
Message-ID: <20200911111158.GF1551@shell.armlinux.org.uk>
References: <20200910174826.511423-1-natechancellor@gmail.com>
 <20200910.152811.210183159970625640.davem@davemloft.net>
 <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 05:31:42PM -0700, Nathan Chancellor wrote:
> On Thu, Sep 10, 2020 at 03:28:11PM -0700, David Miller wrote:
> > From: Nathan Chancellor <natechancellor@gmail.com>
> > Date: Thu, 10 Sep 2020 10:48:27 -0700
> > 
> > > Clang warns (trimmed for brevity):
> > > 
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3073:7: warning:
> > > variable 'link' is used uninitialized whenever 'if' condition is false
> > > [-Wsometimes-uninitialized]
> > >                 if (val & MVPP22_XLG_STATUS_LINK_UP)
> > >                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3075:31: note:
> > > uninitialized use occurs here
> > >                 mvpp2_isr_handle_link(port, link);
> > >                                             ^~~~
> > > ...
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3090:8: warning:
> > > variable 'link' is used uninitialized whenever 'if' condition is false
> > > [-Wsometimes-uninitialized]
> > >                         if (val & MVPP2_GMAC_STATUS0_LINK_UP)
> > >                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3092:32: note:
> > > uninitialized use occurs here
> > >                         mvpp2_isr_handle_link(port, link);
> > >                                                     ^~~~
> > > 
> > > Initialize link to false like it was before the refactoring that
> > > happened around link status so that a valid valid is always passed into
> > > mvpp2_isr_handle_link.
> > > 
> > > Fixes: 36cfd3a6e52b ("net: mvpp2: restructure "link status" interrupt handling")
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1151
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > 
> > This got fixed via another change, a much mode simply one in fact,
> > changing the existing assignments to be unconditional and of the
> > form "link = (bits & MASK);"
> 
> Ah great, that is indeed cleaner, thank you for letting me know!

Hmm, I'm not sure why gcc didn't find that. Strangely, the 0-day bot
seems to have only picked up on it with clang, not gcc.

Thanks for fixing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
