Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627E45E9151
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 09:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIYHGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 03:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiIYHGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 03:06:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A81232A86;
        Sun, 25 Sep 2022 00:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ef7w/BGAlSfKgDUpwXPM3rpXmxvDq2RT3Ue6ctgkM3w=; b=ww1tsjnv1WXGFAL76NLRkAi9hx
        YU71fpBOE1q5jOamKxvgFYtSPuOheXmv/ZqVFoxBtwzTf9lKhI+Er/SGHvA3UMXVZFnI8qWwMfU7Q
        +3KW7iszY/NzTG8FUHNxq3cm4vZHHrrhLAoQDE+sirTzIKTEgjFZOtJTywxGehzbjo57VywKGbtlz
        pz30UvoN2YAWj0Kc7fIKe7S/wLFepdjashXG2AhALKkBxui16dTIW779Wh/j4GuAh0N34CLnCrJa2
        +SdV+x9Qo6nw+qF9S7yvpI9kZemEpzVEI4qntsIqck/AS7d6dX7iwIoVTvAvvXBgxpAj9Yv1J2yMq
        SY4ABjlA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34480)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ocLiB-0007nm-6Q; Sun, 25 Sep 2022 08:05:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ocLiA-0003zQ-24; Sun, 25 Sep 2022 08:05:58 +0100
Date:   Sun, 25 Sep 2022 08:05:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable <stable@kernel.org>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix problem with previous
 memory leak fix
Message-ID: <Yy/91grVshObYNNR@shell.armlinux.org.uk>
References: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
 <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk>
 <CAPv3WKch2J4tteo68wOt_ETj_eYEKy8EC5sTwDvW6UZ-Gs_sCw@mail.gmail.com>
 <CAPv3WKcEa69vhrfE9h2XeuckDjvB=Y-HT7Y3fjV1W6gqYRmyjw@mail.gmail.com>
 <Yy/8FawjLnaE2Swj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yy/8FawjLnaE2Swj@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 07:58:29AM +0100, Russell King (Oracle) wrote:
> On Sun, Sep 25, 2022 at 01:27:06AM +0200, Marcin Wojtas wrote:
> > Hi Russell,
> > 
> > I improved the patch compile and work (tested on my CN913x board).
> > Feel free to submit (if you wish, I can do it too - please let me know
> > your preference):
> > https://github.com/semihalf-wojtas-marcin/Linux-Kernel/commit/0abb75115ffb2772f595bb3346573e27e650018b
> 
> I don't see what the compile fixes were in that - it looks like my patch
> ported onto current -net. Obvious changes:
> 
> - moved mvpp2_dbgfs_exit() declaration from after mvpp2_dbgfs_cleanup()
>   to before.
> - moved definition of mvpp2_root to the top of the file (as no effect
>   on the code.)
> 
> and the change to port it:
> 
> - dropped my mvpp2_dbgfs_init() hunk (because it's different in -net)
> - removed static declaration of mvpp2_root in mvpp2_dbgfs_init()
> 
> I'm not seeing any other changes.
> 
> Note that Sasha has submitted a revert of Greg's original patch for
> mainline, so my original patch should apply as-is if that revert
> happens - and I don't see any compile issues with it.

On that - it seems the Stable kernel maintainers can't cope with being
told not to apply a patch - we've had a big long discussion about it
on IRC over the past few days.

Sasha states that the mainline process is broken - and as long as Greg's
original patch is in place, stable will repeatedly attempt to backport
it no matter whether a proper fix is being worked on, whether
maintainers are busy, and so on and so forth. The only way to stop
stable backporting patches is to revert them in mainline - as I asked to
happen in this case on the 13th.  So it's all our fault for not
reverting the patch. It's got nothing to do with stable maintainers
unable to keep track of which patches they shouldn't be picking up.

I maintain that the stable kernel process is totally broken due to
this - it makes no allowance for whether maintainers can sort the
problem out in a timely manner.

Quite honestly, I now regard the stable kernel process as being
utterly broken. In my mind, it's not a stable kernel. It's an unstable
kernel with randomly applied patches that may or may not be appropriate.
Certainly, stable-kernel-rules.rst is a total and utter joke - they
aren't rules at all, the stable kernel maintainers don't have any rules
about patches they backport.

Anyway, I guess we're going to have to wait for Sasha's revert to be
merged into -net first, which will make backporting our true and proper
memory-leak fix a lot easier.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
