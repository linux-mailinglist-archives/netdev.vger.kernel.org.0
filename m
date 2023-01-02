Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8265665B81E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjABXQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjABXQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:16:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB3F63E3
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9473BB80E12
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0223EC433D2;
        Mon,  2 Jan 2023 23:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672701392;
        bh=bPmud8RNFV1f4wV1fIt8os5R6B6+z2XQ2c4jEOW027o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oKuUNgA5lf9GkqNpKvdCj6twnrRFzQ5npE94v1Ou2eaSAjM5AjyP365Y+o9GEfj2D
         p2zsGQZ7JKj3RheKWPSLIrVVT6D6Cjk2/o2IWoeIuevW3TkzHVWSiSUr1dC2bzfAOG
         5SsL6/H6j7qJq1PKzvweii1KtJWL1PZVMIYEzXf9aU8RkYB/lApL6AWcwR2CnXScin
         nfEofcR5WvF/6LhNSUts5qBQTEvqK08IBHaSPK50eMSP5GUQ2IhkELX+m7Of9inX6s
         lUROCV4jaw4B7yVES5D9XjxR/ivUC8onYlNye/4wuSho4jvok+0iCwGZ5e4KSjZGnr
         CpJbX7Zg1ixEA==
Date:   Mon, 2 Jan 2023 15:16:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <20230102151630.4aeaef00@kernel.org>
In-Reply-To: <Y7Lw1GSGml1E8SXw@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-5-kuba@kernel.org>
        <Y7Lw1GSGml1E8SXw@nanopsycho>
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

On Mon, 2 Jan 2023 15:57:24 +0100 Jiri Pirko wrote:
> Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:
> >Always check under the instance lock whether the devlink instance
> >is still / already registered.
> >
> >This is a no-op for the most part, as the unregistration path currently
> >waits for all references. On the init path, however, we may temporarily
> >open up a race with netdev code, if netdevs are registered before the
> >devlink instance. This is temporary, the next change fixes it, and this
> >commit has been split out for the ease of review.
> >
> >Note that in case of iterating over sub-objects which have their
> >own lock (regions and line cards) we assume an implicit dependency
> >between those objects existing and devlink unregistration.

> >diff --git a/net/devlink/basic.c b/net/devlink/basic.c
> >index 5f33d74eef83..6b18e70a39fd 100644
> >--- a/net/devlink/basic.c
> >+++ b/net/devlink/basic.c
> >@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
> > 		int idx = 0;
> > 
> > 		mutex_lock(&devlink->linecards_lock);
> >+		if (!devl_is_alive(devlink))
> >+			goto next_devlink;  
> 
> Thinking about this a bit more, things would be cleaner if reporters and
> linecards are converted to rely on instance lock as well. I don't see a
> good reason for a separate lock in both cases, really.

We had discussion before, I'm pretty sure.
IIRC you said that mlx4's locking prevents us from using the instance
lock for regions.

> Also, we could introduce devlinks_xa_for_each_registered_get_lock()
> iterator that would lock the instance as well right away to avoid
> this devl_is_alive() dance on multiple places when you iterate devlinks.

That's what I started with, but the ability to factor our the
unlock/put on error paths made the callback approach much cleaner.
And after using the callback for all the dumps there's only a couple
places which would use devlinks_xa_for_each_registered_get_lock().

> >@@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
> > 		return;
> > 
> > 	devl_lock(devlink);  
> 
> How about to have a helper, something like devl_lock_alive() (or
> devl_lock_registered() with the naming scheme I suggest in the other
> thread)? Then you can do:
> 
> 	if (!devl_lock_alive(devlink))
> 		return;
> 	__devlink_compat_running_version(devlink, buf, len);
> 	devl_unlock(devlink);

I guess aesthetic preference.

If I had the cycles I'd make devlink_try_get() return a wrapped type

struct devlink_ref {
	struct devlink *devlink;
};

which one would have to pass to devl_lock_from_ref() or some such:

struct devlink *devl_lock_from_ref(struct devlink_ref dref)
{
	if (!dref.devlink)
		return NULL;
	devl_lock(dref.devlink);
	if (devl_lock_alive(dref.devlink))
		return dref.devlink;
	devl_unlock(dref.devlink);
	return NULL;
}

But the number of calls to devl_is_alive() is quite small after all
the cleanup, so I don't think the extra helpers are justified at this
point. "Normal coders" should not be exposed to any of the lifetime
details, not when coding the drivers, not when adding typical devlink
features/subobjects.
