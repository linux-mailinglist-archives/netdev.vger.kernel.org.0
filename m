Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838B465B807
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjABXFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbjABXFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:05:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D270B845
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:05:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD426114F
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43DEC433EF;
        Mon,  2 Jan 2023 23:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672700716;
        bh=49W6eld39qCeSTs49hMw4BBpGRnJ43AEndgvuk11DP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XSyFnn5V3A7r21SGPp5mn+L/j3Ag6FK0pffRirkK9S7vPgWXqKEdHPflxq2xE4Cag
         cUr3DCun1x2BoEnyufNO4ck83JW1kvI3IjxWQ91FToFZJHxcLWl5X1NyAUAE/3nLrm
         YkA6F5btSYCrd9l1wd/pQrwRXeN8uRYtB82Xs1qWgEWCUk1XJSb1DexOmHserykuyL
         uCWoYh/4Qm6nVYL5MEgpkSWwflE7ht2k7uSig6tBxMG0eSuh+IEwKCMZYDoAbLplWI
         XLn33Clx65LY2Y+F0i2VPi0HnQ7Al2AlUD7xDpO9jUC8xVhhwNGLLljV95Iv1Aw0Qw
         dvALIgPLImAuQ==
Date:   Mon, 2 Jan 2023 15:05:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <20230102150514.6321d2ae@kernel.org>
In-Reply-To: <Y7Li+GMB6BU+D/6W@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-5-kuba@kernel.org>
        <Y7Li+GMB6BU+D/6W@nanopsycho>
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

On Mon, 2 Jan 2023 14:58:16 +0100 Jiri Pirko wrote:
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
> 
> This would be probably very valuable to add as a comment inside the code
> for the future reader mind sake.

Where, tho?

I'm strongly against the pointlessly fine-grained locking going forward
so hopefully there won't be any more per-subobject locks added anyway.

> >+bool devl_is_alive(struct devlink *devlink)  
> 
> Why "alive"? To be consistent with the existing terminology, how about
> to name it devl_is_registered()?

I dislike the similarity to device_is_registered() which has very
different semantics. I prefer alive.

> Also, "devl_" implicates that it should be called with devlink instance
> lock held, so probably devlink_is_registered() would be better.

I'm guessing you realized this isn't correct later on.

> >+{
> >+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> >+}
> >+EXPORT_SYMBOL_GPL(devl_is_alive);
> >+
> >+/**
> >+ * devlink_try_get() - try to obtain a reference on a devlink instance
> >+ * @devlink: instance to reference
> >+ *
> >+ * Obtain a reference on a devlink instance. A reference on a devlink instance
> >+ * only implies that it's safe to take the instance lock. It does not imply
> >+ * that the instance is registered, use devl_is_alive() after taking
> >+ * the instance lock to check registration status.
> >+ */  
> 
> This comment is not related to the patch, should be added in a separate
> one.

The point of adding this comment is to say that one has to use
devl_is_alive() after accessing an instance by reference.
It is very much in the right patch.
