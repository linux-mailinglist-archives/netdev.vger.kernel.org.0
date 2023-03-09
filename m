Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD566B28E3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCIPbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjCIPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:31:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094CF16B1;
        Thu,  9 Mar 2023 07:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FXHmm4YyFhrIg8ITBaU/1RtAqRIi4e/d/ru7jqAAjyo=; b=fxmsG0C7nOCCa+6VIiKC0u0dbd
        iiGMMPMk1VIzFzSbX4HvjCrUudVGhFG8x/5H1GKcVKTjkdyitah4DGoE9CBOqf17z3sNkpz+BdGn2
        0jiY6tWSlf0+Id4+CuFU4K7n2g4mnyp2dTRIveOSuwwHLfdZAIru4+inV/Xk8HktK8NlKxL411FAi
        WBs8jEHIXQQkt052Ewfqiqn/lvHlmmDo7DGappQ0/NNlIlkG+GR+JfbYaLDmh95ZH0QGB4HwtP868
        C4PYPuuYGdHj8Ok0VeD/1EhAWzAEozg8cFNYq7EdddPX8S69ueA+AV+jmyVoGoC62IzGJTe31FQsQ
        fCrj6TIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43268)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1paIEb-0004va-GQ; Thu, 09 Mar 2023 15:31:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1paIEY-0003lf-J6; Thu, 09 Mar 2023 15:31:10 +0000
Date:   Thu, 9 Mar 2023 15:31:10 +0000
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
Message-ID: <ZAn7vkjj0bYdZnhz@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-7-lukma@denx.de>
 <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
 <20230309154350.0bdc54c8@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309154350.0bdc54c8@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:43:50PM +0100, Lukasz Majewski wrote:
> Hi Russell,
> 
> Please correct my understanding - I do see two approaches here:
> 
> A. In patch 1 I do set the max_frame_size values (deduced). Then I add
> validation function (patch 2). This function shows "BUG:...." only when
> we do have a mismatch. In patch 3 I do correct the max_frame_size
> values (according to validation function) and remove the validation
> function. This is how it is done in v5 and is going to be done in v6.

I don't see much point in adding the validation, then correcting the
values that were added in patch 1 that were identified by patch 2 in
patch 3 - because that means patch 1's deduction was incorrect in
some way.

If there is any correction to be done, then it should be:

patch 1 - add the max_frame_size values
patch 2 - add validation (which should not produce any errors)
patch 3 - convert to use max_frame_size, and remove validation, stating
  that the validation had no errors
patch 4 (if necessary) - corrections to max_frame_size values if they
  are actually incorrect (in other words, they were buggy before patch
  1.)
patch 5 onwards - the rest of the series.

> B. Having showed the v5 in public, the validation function is known.
> Then I do prepare v6 with only patch 1 having correct values (from the
> outset) and provide in the commit message the code for validation
> function. Then patch 2 and 3 (validation function and the corrected
> values of max_frame_size) can be omitted in v6.
> 
> For me it would be better to choose approach B.

I would suggest that is acceptable for the final round of patches, but
I'm wary about saying "yes" to it because... what if something changes
in that table between the time you've validated it, and when it
eventually gets accepted. Keeping the validation code means that during
the review of the series, and subsequent updates onto net-next (which
should of course include re-running the validation code) we can be
more certain that nothing has changed that would impact it.

What I worry about is if something changes, the patch adding the
values mis-patches (e.g. due to other changes - much of the context
for each hunk is quite similar) then we will have quite a problem to
sort it out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
