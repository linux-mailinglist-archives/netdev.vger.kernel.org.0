Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EDD5B9675
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIOIfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiIOIf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:35:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5A62B24F;
        Thu, 15 Sep 2022 01:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47558B81E64;
        Thu, 15 Sep 2022 08:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7890AC433C1;
        Thu, 15 Sep 2022 08:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663230926;
        bh=Ot/IEjx60+Ugq7shRIji6JO7/KL6tCs4ZKC7guXQRt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgxd2rrPMa9Ixwb8B6TmfT6+a8bvfq7DXh2qh2q0nOdD5SiAZE7WxVmRz8lt/mhdE
         wnK8C2jYiwfyWYgT+VQdbXA/ag/lVLk3/hIrUzBS+nHEhERppM0/O4fbyCjEn6kwKd
         QBWNBrdYv1VCO3gISmHYLFwVlfwLxfZU/FoNW3Lk=
Date:   Thu, 15 Sep 2022 10:35:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH 5.19 005/192] net: mvpp2: debugfs: fix memory leak when
 using debugfs_lookup()
Message-ID: <YyLj580gubQY5Ddu@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220913140410.277221532@linuxfoundation.org>
 <YyC0eveBK8UzeIdI@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyC0eveBK8UzeIdI@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 05:48:58PM +0100, Russell King (Oracle) wrote:
> On Tue, Sep 13, 2022 at 04:01:51PM +0200, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > commit fe2c9c61f668cde28dac2b188028c5299cedcc1e upstream.
> > 
> > When calling debugfs_lookup() the result must have dput() called on it,
> > otherwise the memory will leak over time.  Fix this up to be much
> > simpler logic and only create the root debugfs directory once when the
> > driver is first accessed.  That resolves the memory leak and makes
> > things more obvious as to what the intent is.
> > 
> > Cc: Marcin Wojtas <mw@semihalf.com>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org
> > Cc: stable <stable@kernel.org>
> > Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> > @@ -700,10 +700,10 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *p
> >  
> >  void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
> >  {
> > -	struct dentry *mvpp2_dir, *mvpp2_root;
> > +	static struct dentry *mvpp2_root;
> > +	struct dentry *mvpp2_dir;
> >  	int ret, i;
> >  
> > -	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
> >  	if (!mvpp2_root)
> >  		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
> 
> This looks broken to me.
> 
> What happens if this is built as a module, and the module is loaded,
> binds (and creates the directory), then is removed, and then re-
> inserted?  Nothing removes the old directory, so doesn't
> debugfs_create_dir() fail, resulting in subsequent failure to add
> any subsequent debugfs entries?
> 
> I don't think this patch should be backported to stable trees until
> this point is addressed.

I'll drop this for now and get back to the fixup next week.

thanks,

greg k-h
