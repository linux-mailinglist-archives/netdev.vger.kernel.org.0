Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B190465B7B3
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 23:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjABWsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 17:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjABWsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 17:48:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CF9FE5
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 14:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430B6B80DEB
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 22:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7113C433D2;
        Mon,  2 Jan 2023 22:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672699694;
        bh=9wCRWCQzyDAsQ5VS6pCBfQAyX9QvJY1pzFVTnWZIMpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nz2RzJQGUOIsQ8/w2V+Qjktv+vji0zmvHt4+h2dj059XujUc4Lxi4Pq+8xD4RqH1p
         ZjQUpnHPA/OeyHKgXrL4gSwi4pRt4Tgra777Pp2waa8aDtIB9AhLNaWUbuaV01fk8S
         6q9Fm5quG6m7IaPRIwjAvR1+19yMfOiCtXa34BuarWG+XM3PrUCnhO2mDSyK/qBHY8
         /VjvDt49fa29TbrWPJQUDYiNJQn7L4tY5khOysQKt7+bOp5QKuwjRm7KbdD9k/GXCs
         jiJi8JOiOrz0T/pZI5eMZfI5GecKLERehjVRz0+E04HU0EcoB461yrgn2FfkFNSfi0
         zc4CBc/xTksqA==
Date:   Mon, 2 Jan 2023 14:48:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 01/10] devlink: bump the instance index directly
 when iterating
Message-ID: <20230102144813.1363cb38@kernel.org>
In-Reply-To: <Y7LbF0+aRjT6AkZ+@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-2-kuba@kernel.org>
        <Y7LbF0+aRjT6AkZ+@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Jan 2023 14:24:39 +0100 Jiri Pirko wrote:
> Sat, Dec 17, 2022 at 02:19:44AM CET, kuba@kernel.org wrote:
> >We use a clever find_first() / find_after() scheme currently,
> >which works nicely as xarray will write the "current" index
> >into the variable we pass.
> >
> >We can't do the same thing during the "dump walk" because
> >there we must not increment the index until we're sure
> >that the instance has been fully dumped.  
> 
> To be honest, this "we something" desctiption style makes things quite
> hard to understand. Could you please rephrase it to actually talk
> about the entities in code?

Could you be more specific? I'm probably misunderstanding but it sounds
to me like you're asking me to describe what I'm doing rather than
the background and motivation.

> >diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> >index 1d7ab11f2f7e..ef0369449592 100644
> >--- a/net/devlink/devl_internal.h
> >+++ b/net/devlink/devl_internal.h
> >@@ -82,18 +82,9 @@ extern struct genl_family devlink_nl_family;
> >  * in loop body in order to release the reference.
> >  */
> > #define devlinks_xa_for_each_registered_get(net, index, devlink)	\
> >-	for (index = 0,							\
> >-	     devlink = devlinks_xa_find_get_first(net, &index);	\
> >-	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
> >-
> >-struct devlink *
> >-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
> >-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
> >-					  unsigned long, xa_mark_t));
> >-struct devlink *
> >-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
> >-struct devlink *
> >-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
> >+	for (index = 0; (devlink = devlinks_xa_find_get(net, &index)); index++)  
> 
> You don't need ()' in the 2nd for arg.

Pretty sure I was getting a compiler warning for assignment in 
a condition....
