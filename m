Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D116B5B8E8C
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiINSGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiINSGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:06:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CFBF14;
        Wed, 14 Sep 2022 11:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vtbQ/fNabv0KrEQaayiXWaRsKz9Ke9g5h9z5GEtHYt8=; b=B4an7rSdC7KfE0p1Yy2e5mm6cw
        Zx5bYl+nwEjM/09111UDWT1oWDb+sr/ZqJ5X6HS5+FWJlHjHjA6XFz6piOtU/Ug6CEWQrIY1wHhYm
        jRP7NttEU/191254syVQwKNUo2VWdwe5a3CihNcY4rFtdmI0Vrh17fqf9PZueoE0soENRLz7nBTwu
        2R9RCljOROh8ueqV100ojCjHJCivX/N9/CQbZvhfxtfXFEK6yTGJ9lnpVgKaF1mYeufG9tKWlu15D
        jWp9h7grqoy3UQO+CJ71UfrsQ7OSZHktFLqqNNKY+DfoYu6phwshLITu2n78eDelrvEqimRjdd0AJ
        jlIIt/WA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34338)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYWmQ-0004i0-11; Wed, 14 Sep 2022 19:06:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYWmO-0001qn-F2; Wed, 14 Sep 2022 19:06:32 +0100
Date:   Wed, 14 Sep 2022 19:06:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mw@semihalf.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix memory leak when using
 debugfs_lookup()
Message-ID: <YyIYKGNX/r2LrngQ@shell.armlinux.org.uk>
References: <20220902134111.280657-1-gregkh@linuxfoundation.org>
 <YyC2GGbzEuCuZzMk@shell.armlinux.org.uk>
 <YyIXXJmEmKEBtvYy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyIXXJmEmKEBtvYy@kroah.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 08:03:08PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 13, 2022 at 05:55:52PM +0100, Russell King (Oracle) wrote:
> > On Fri, Sep 02, 2022 at 03:41:11PM +0200, Greg Kroah-Hartman wrote:
> > > When calling debugfs_lookup() the result must have dput() called on it,
> > > otherwise the memory will leak over time.  Fix this up to be much
> > > simpler logic and only create the root debugfs directory once when the
> > > driver is first accessed.  That resolves the memory leak and makes
> > > things more obvious as to what the intent is.
> > 
> > To clarify a bit more on the original patch rather than one of the
> > backported stable patches of this.
> > 
> > This patch introduces a bug, whereby if the driver is a module, and
> > is inserted, binds to a device, then is removed and re-inserted,
> > mvpp2_root will be NULL on the first call to mvpp2_dbgfs_init(),
> > so we will attempt to call debugfs_create_dir(). However, the
> > directory was already previously created, so this will fail, and
> > mvpp2_root will be the EEXIST error pointer.
> > 
> > Since we never clean up this directory, the original code does NOT
> > result in a memory leak - since the increase in refcount caused by
> > debugfs_lookup() has absolutely no effect - because we never remove
> > this directory once it's been created.
> > 
> > If the driver /did/ remove the directory when the module is removed,
> > then yes, maybe there's an argument for this fix. However, as things
> > currently stand, this is in no way a fix, but actually introduces a
> > debugfs regression.
> > 
> > Please can the change be reverted in mainline and all stable trees.
> 
> I never considered the 'rmmod the driver and then load it again' as a
> valid thing to worry about.  And I doubt that many others would either :)
> 
> Given that the current code does NOT clean up when it is removed, I
> assumed that no one cared abou this, but yes, it is crazy but the
> current code does work, but it leaks a dentry.  I'll send a follow-on
> patch to do this "correctly" when I return from the Plumbers conference
> next week.
> 
> But for now, this patch is correct, and does not leak memory anymore
> like the code without this change currently does, so I think it should
> stay.

Please can you explain which memory isn't leaked as a result of the
patch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
