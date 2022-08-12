Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48CE59129E
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiHLPHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbiHLPHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:07:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C99E108;
        Fri, 12 Aug 2022 08:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xzSg/Fv7XIYa+eii793J7h10cH14qRv6I6X16wq6o/A=; b=m96WkSoEn8YO680RlSdd01tMRD
        0ZSpKeTpAU2JYJu4t+zfFuZzhbJmGrQae1qltJIPgMbCew5PWGcrRDKRd1+VbxZM0jRPjuzH95q9c
        hC6eJsO32HQR+PnZntJKOOrMMyXFlrFgl19GzvU+bKw/fBKnF6wPVxc1J6PHF2g1h4YkpDWJqdrFs
        58ymPMAnwrE1nk1SrFOmvL5EPAxpScT/o75icBt8Ua5NtRmCNzXTZu85BCh0MCgdJ1astQjeHS5ZJ
        SJXm8UqzbsQ+x6MW5Vees1pkOiAGEO4HCJClwRCzJWNj4L9IKkPm6xvi/hux7pYpZLo0ZqJh9eeUH
        tkOcNw5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oMWGI-0000NB-6p; Fri, 12 Aug 2022 16:07:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oMWGH-00010Y-Cb; Fri, 12 Aug 2022 16:07:45 +0100
Date:   Fri, 12 Aug 2022 16:07:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stefan Mahr <dac922@gmx.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: reset fault retry counter on successful
 reinitialisation
Message-ID: <YvZswfC/JhkWmyBj@shell.armlinux.org.uk>
References: <20220812130438.140434-1-dac922@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812130438.140434-1-dac922@gmx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 03:04:38PM +0200, Stefan Mahr wrote:
> This patch resets the fault retry counter to the default value, if the
> module reinitialisation was successful. Otherwise without resetting
> the counter, five (N_FAULT/N_FAULT_INIT) single TX_FAULT events will
> deactivate the module persistently.

This is intentional - if a module keeps asserting its TX_FAULT status,
then there is something wrong with it, and for an optical module it
means that the laser is overloading (producing more output than it
should.) That is a safety issue.

So, if the module keeps indicating that its laser is misbehaving the
only right thing to do is to shut it down permanently, and have
someone investigate.

What issue are you seeing that needs a different behaviour?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
