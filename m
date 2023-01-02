Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B109E65B7B6
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 23:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjABW5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 17:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjABW47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 17:56:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DEBE1C
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 14:56:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79689B80DDC
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 22:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC78CC433EF;
        Mon,  2 Jan 2023 22:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672700216;
        bh=4ctDp2IHnXgjue8IqKv6LEG8rqiwlMm/ZoFoetkA50c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZZ/+8DkREJwlXJcMo4lPw7cevfX1URtavfmX3o4QIs5tFi1NjOkcZYpQODChxkAlm
         URyqmI1GLE0RNmmhLkyWl/JXic/iZ8TFCH/ksT1f79YVkK1Lls8l84DIG1TNV8RKq2
         z06m2nzw1vH07MKn+sT4le61UshSTP6w/KrC3Fmxwa9spsrYRKQ5s1t6PUL2JNCoMO
         3l5zIsYn9R33fWdne/kKRq4OEPKzUl3KX2NHtUaqhS6E0/lhbVisjr5SYGQ7r4XVTv
         NVFpHl2tJunOsRIe+6B3nwS29oPtfvVR2NoyvN0b5kyrdhZHV1cNtAAt8J/IF0TCEW
         AIx2CLOjrLz7w==
Date:   Mon, 2 Jan 2023 14:56:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC net-next 01/10] devlink: bump the instance index directly
 when iterating
Message-ID: <20230102145654.24aec331@kernel.org>
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
> >-struct devlink *
> >-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
> >-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
> >-					  unsigned long, xa_mark_t))
> >+struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
> > {
> >-	struct devlink *devlink;
> >+	struct devlink *devlink = NULL;
> > 
> > 	rcu_read_lock();
> > retry:
> >-	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
> >+	devlink = xa_find(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
> > 	if (!devlink)
> > 		goto unlock;
> > 
> >@@ -109,31 +106,21 @@ devlinks_xa_find_get(struct net *net, unsigned long *indexp,
> > 	 * This prevents live-lock of devlink_unregister() wait for completion.
> > 	 */
> > 	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
> >-		goto retry;
> >+		goto next;
> > 
> >-	/* For a possible retry, the xa_find_after() should be always used */
> >-	xa_find_fn = xa_find_after;  
> 
> Hmm. Any idea why xa_find_after()? implementation is different to
> xa_find()?

I'm guessing it's because for _after the code needs to take special
care of skipping multi-index entries. If an entry spans 0-3 xa_find(0)
can return the same entry as xa_find(1). But xa_find_after(1) must
return an entry under index 4 or higher.

Since our use of the Xarray is very trivial with no range indexes,
it should not matter.

Let me CC Matthew, just in case. The question boils down to whether:

	for (index = 0; (entry = xa_find(net, &index));	index++)  

is a legal way of iterating over an Xarray without range indexes.

> > 	if (!devlink_try_get(devlink))
> >-		goto retry;
> >+		goto next;
> > 	if (!net_eq(devlink_net(devlink), net)) {
> > 		devlink_put(devlink);
> >-		goto retry;
> >+		goto next;
> > 	}
> > unlock:
> > 	rcu_read_unlock();
> > 	return devlink;
> >-}
> >-
> >-struct devlink *
> >-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp)
> >-{
> >-	return devlinks_xa_find_get(net, indexp, xa_find);
> >-}
> > 
> >-struct devlink *
> >-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp)
> >-{
> >-	return devlinks_xa_find_get(net, indexp, xa_find_after);
> >+next:
> >+	(*indexp)++;
> >+	goto retry;
> > }
> > 
> > /**
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
