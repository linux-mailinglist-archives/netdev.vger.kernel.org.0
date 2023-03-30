Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8F6CFB1A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjC3GBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjC3GBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6475F5B8E;
        Wed, 29 Mar 2023 23:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF3161ED4;
        Thu, 30 Mar 2023 06:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C247C433EF;
        Thu, 30 Mar 2023 06:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680156069;
        bh=qI0qsnXqQKDOWulB+WAd4HD4/HMrD9/ycIJ/oMxn0oY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBG+RraMJnoaJWwhflk/lEn1nnjxorrS4ILTHNm5k7sN7GcM4uvwQB2NhBuiN9CO6
         KkpJI0eVOSpavtgNjSqbyg3YjCRFUotud59NNMsfWoNaCe8uHXBKzAi5jCwz9+ebXs
         zZX2pR1sN6zvf/hVSnT/pO0Zjac3PWr7xxG3dlsw=
Date:   Thu, 30 Mar 2023 08:01:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove unneeded mISDN_class_release()
Message-ID: <ZCUlo1jcPeU4K_AI@kroah.com>
References: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
 <ZCST8vuQDEo9GhsS@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCST8vuQDEo9GhsS@corigine.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:39:30PM +0200, Simon Horman wrote:
> On Wed, Mar 29, 2023 at 08:01:27AM +0200, Greg Kroah-Hartman wrote:
> > The mISDN_class_release() is not needed at all, as the class structure
> > is static, and it does not actually do anything either, so it is safe to
> > remove as struct class does not require a release callback.
> > 
> > Cc: Karsten Keil <isdn@linux-pingi.de>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > Note: I would like to take this through the driver-core tree as I have
> > later struct class cleanups that depend on this change being made to the
> > tree if that's ok with the maintainer of this file.
> > 
> >  drivers/isdn/mISDN/core.c | 6 ------
> >  1 file changed, 6 deletions(-)
> 
> I assume this will hit the following in drivers/base/class.c:class_release():
> 
>         if (class->class_release)
>                 class->class_release(class);
>         else
> 		pr_debug("class '%s' does not have a release() function, "
> 		"be careful\n", class->name);
> 
> So I also assume that you are being careful :)

Yes, I am :)

I need to remove that debug line soon as I'm moving all struct class
instances to be static and in read-only memory, which would mean that no
release function is needed at all for them.  Give me a few hundred more
commits to get there...

thanks for the review!

greg k-h
