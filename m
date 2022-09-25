Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531F85E914D
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 08:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIYG6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 02:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIYG6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 02:58:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB722D74D;
        Sat, 24 Sep 2022 23:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0UHncLBE2u8i6c0juIjafxqKnrIA8ZAVsYTNuqpN3hE=; b=vrc1l/BbA2MkODh06AF28r+Wrq
        ijXTir8340i9KJSZJW/e5tf3eNMU0L5hx0KXWDvqxVVPTqACPt1JztD9mpObzH25LJa7lAZRNwMAn
        jRXrp6mksci6Kln2fwe5hjTVxLpkBVtDmfkQYS5Kqigrr1paoNSswB4tPq1mxdsgImARNCFQTkQ9/
        VssLG2YWSYLVB+0e+umeym67yduR0Y9NzJOLFrW8yKX0h7fJjtNslOGYobHK/9fP8pW3KUxFBipZN
        +D/WtOdNBykHkVxtTMM2hkagZTxAk8PTRs1fkmsALrdiyLTvFKG8NSK89Uxm0fP5Aa5hAmmHqKQNn
        wzjC4VBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34478)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ocLax-0007nE-JX; Sun, 25 Sep 2022 07:58:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ocLav-0003yb-E4; Sun, 25 Sep 2022 07:58:29 +0100
Date:   Sun, 25 Sep 2022 07:58:29 +0100
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
Message-ID: <Yy/8FawjLnaE2Swj@shell.armlinux.org.uk>
References: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
 <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk>
 <CAPv3WKch2J4tteo68wOt_ETj_eYEKy8EC5sTwDvW6UZ-Gs_sCw@mail.gmail.com>
 <CAPv3WKcEa69vhrfE9h2XeuckDjvB=Y-HT7Y3fjV1W6gqYRmyjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKcEa69vhrfE9h2XeuckDjvB=Y-HT7Y3fjV1W6gqYRmyjw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 01:27:06AM +0200, Marcin Wojtas wrote:
> Hi Russell,
> 
> czw., 22 wrz 2022 o 19:08 Marcin Wojtas <mw@semihalf.com> napisał(a):
> >
> > Hi,
> >
> > Thank you both for the patches.
> >
> >
> > czw., 22 wrz 2022 o 18:05 Russell King (Oracle)
> > <linux@armlinux.org.uk> napisał(a):
> > >
> > > On Wed, Sep 21, 2022 at 01:44:44PM +0200, Greg Kroah-Hartman wrote:
> > > > In commit fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> > > > debugfs_lookup()"), if the module is unloaded, the directory will still
> > > > be present if the module is loaded again and creating the directory will
> > > > fail, causing the creation of additional child debugfs entries for the
> > > > individual devices to fail.
> > > >
> > > > As this module never cleaned up the root directory it created, even when
> > > > loaded, and unloading/loading a module is not a normal operation, none
> > > > of would normally happen.
> > > >
> > > > To clean all of this up, use a tiny reference counted structure to hold
> > > > the root debugfs directory for the driver, and then clean it up when the
> > > > last user of it is removed from the system.  This should resolve the
> > > > previously reported problems, and the original memory leak that
> > > > fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> > > > debugfs_lookup()") was attempting to fix.
> > >
> > > For the record... I have a better fix for this, but I haven't been able
> > > to get it into a state suitable for submission yet.
> > >
> > > http://www.home.armlinux.org.uk/~rmk/misc/mvpp2-debugfs.diff
> > >
> > > Not yet against the net tree. Might have time tomorrow to do that, not
> > > sure at the moment. Medical stuff is getting in the way. :(
> > >
> >
> > I'd lean towards this version - it is a bit more compact. I'll try to
> > test that tomorrow or during the weekend.
> >
> 
> I improved the patch compile and work (tested on my CN913x board).
> Feel free to submit (if you wish, I can do it too - please let me know
> your preference):
> https://github.com/semihalf-wojtas-marcin/Linux-Kernel/commit/0abb75115ffb2772f595bb3346573e27e650018b

I don't see what the compile fixes were in that - it looks like my patch
ported onto current -net. Obvious changes:

- moved mvpp2_dbgfs_exit() declaration from after mvpp2_dbgfs_cleanup()
  to before.
- moved definition of mvpp2_root to the top of the file (as no effect
  on the code.)

and the change to port it:

- dropped my mvpp2_dbgfs_init() hunk (because it's different in -net)
- removed static declaration of mvpp2_root in mvpp2_dbgfs_init()

I'm not seeing any other changes.

Note that Sasha has submitted a revert of Greg's original patch for
mainline, so my original patch should apply as-is if that revert
happens - and I don't see any compile issues with it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
