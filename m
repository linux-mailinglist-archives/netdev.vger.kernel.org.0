Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0A5B78E8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIMR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiIMRz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:55:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9646FA25;
        Tue, 13 Sep 2022 09:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5bwtqtp6PJfttZvCLxCl1n6K+88dKkhKG6FejOezXrM=; b=JZRCVyn8It0XZ6n9xg+mNMZ0PJ
        sO11Lg+9TW1Yz0MnDrjvBYNmcYzFyaR9khLCw2uxiP/XkWVP8MFKsjDOxHYBxZbQTeyXuiChBpjim
        qT67E5ilPvyYWqV49KMHsvfwuphgb6zYhxbONUHl0HJpuW0ElEmqSBCFOSIWg8G18ARcyab/GqITL
        mDi2zVCJjY7nphWLa0cI3yx6zt7ObdKaZK7cxxFo7JCAHaaO2l+zyPbnmZU3WQX2W2Kv+16pKzsbm
        YGf6ezr97eC+ZSmCgM+YhsbI7dTp2NAngLheZqr91wJJQ+OpztYRf8VMTuLKg5xkrZA78MDmY9neY
        D2wJLDgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34298)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oY9CT-0003Jh-HK; Tue, 13 Sep 2022 17:55:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oY9CS-0000pS-Et; Tue, 13 Sep 2022 17:55:52 +0100
Date:   Tue, 13 Sep 2022 17:55:52 +0100
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
Message-ID: <YyC2GGbzEuCuZzMk@shell.armlinux.org.uk>
References: <20220902134111.280657-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902134111.280657-1-gregkh@linuxfoundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 03:41:11PM +0200, Greg Kroah-Hartman wrote:
> When calling debugfs_lookup() the result must have dput() called on it,
> otherwise the memory will leak over time.  Fix this up to be much
> simpler logic and only create the root debugfs directory once when the
> driver is first accessed.  That resolves the memory leak and makes
> things more obvious as to what the intent is.

To clarify a bit more on the original patch rather than one of the
backported stable patches of this.

This patch introduces a bug, whereby if the driver is a module, and
is inserted, binds to a device, then is removed and re-inserted,
mvpp2_root will be NULL on the first call to mvpp2_dbgfs_init(),
so we will attempt to call debugfs_create_dir(). However, the
directory was already previously created, so this will fail, and
mvpp2_root will be the EEXIST error pointer.

Since we never clean up this directory, the original code does NOT
result in a memory leak - since the increase in refcount caused by
debugfs_lookup() has absolutely no effect - because we never remove
this directory once it's been created.

If the driver /did/ remove the directory when the module is removed,
then yes, maybe there's an argument for this fix. However, as things
currently stand, this is in no way a fix, but actually introduces a
debugfs regression.

Please can the change be reverted in mainline and all stable trees.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
