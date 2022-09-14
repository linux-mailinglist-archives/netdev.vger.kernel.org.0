Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3B5B8E81
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiINSCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiINSCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B09F85FC5;
        Wed, 14 Sep 2022 11:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F798B81263;
        Wed, 14 Sep 2022 18:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A323AC433C1;
        Wed, 14 Sep 2022 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663178564;
        bh=DFrj65FfhHvaGVV8MOsLEULW7fyDhsFLLDg8lIAW9Yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdbzzXcdA1LfDCQ3uEOQzDAqFKHpCSJioMRbi5O1uJCY+jOl36WeskkZVPrxuJjQ7
         nX5bPnEmDUCyOHa3ZbnWIoPSGxITtORllMgFDSDuuhjC9OL0tD3l5UvwPM4bpmjI38
         CzCASrPRC3sp7mDkj4h6MZD/DQQGIhDNHFmathRg=
Date:   Wed, 14 Sep 2022 20:03:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     mw@semihalf.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix memory leak when using
 debugfs_lookup()
Message-ID: <YyIXXJmEmKEBtvYy@kroah.com>
References: <20220902134111.280657-1-gregkh@linuxfoundation.org>
 <YyC2GGbzEuCuZzMk@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyC2GGbzEuCuZzMk@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 05:55:52PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 02, 2022 at 03:41:11PM +0200, Greg Kroah-Hartman wrote:
> > When calling debugfs_lookup() the result must have dput() called on it,
> > otherwise the memory will leak over time.  Fix this up to be much
> > simpler logic and only create the root debugfs directory once when the
> > driver is first accessed.  That resolves the memory leak and makes
> > things more obvious as to what the intent is.
> 
> To clarify a bit more on the original patch rather than one of the
> backported stable patches of this.
> 
> This patch introduces a bug, whereby if the driver is a module, and
> is inserted, binds to a device, then is removed and re-inserted,
> mvpp2_root will be NULL on the first call to mvpp2_dbgfs_init(),
> so we will attempt to call debugfs_create_dir(). However, the
> directory was already previously created, so this will fail, and
> mvpp2_root will be the EEXIST error pointer.
> 
> Since we never clean up this directory, the original code does NOT
> result in a memory leak - since the increase in refcount caused by
> debugfs_lookup() has absolutely no effect - because we never remove
> this directory once it's been created.
> 
> If the driver /did/ remove the directory when the module is removed,
> then yes, maybe there's an argument for this fix. However, as things
> currently stand, this is in no way a fix, but actually introduces a
> debugfs regression.
> 
> Please can the change be reverted in mainline and all stable trees.

I never considered the 'rmmod the driver and then load it again' as a
valid thing to worry about.  And I doubt that many others would either :)

Given that the current code does NOT clean up when it is removed, I
assumed that no one cared abou this, but yes, it is crazy but the
current code does work, but it leaks a dentry.  I'll send a follow-on
patch to do this "correctly" when I return from the Plumbers conference
next week.

But for now, this patch is correct, and does not leak memory anymore
like the code without this change currently does, so I think it should
stay.

thanks,

greg k-h
