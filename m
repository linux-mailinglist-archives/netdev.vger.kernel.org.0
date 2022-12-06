Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A025643A84
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiLFBIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFBIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:08:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E03865E7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4684614E7
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B9CC433D6;
        Tue,  6 Dec 2022 01:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670288908;
        bh=NTIm2G5XZ9RtSalhgkhAixCCUeCfvMLl+Y+qTbkXSuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GKiL0NFGfyZaEvFkO39GY7sabIkJfCBibowwFDYUQ3iaEy+T0sJ0fysfOI81HJkMi
         xQbI0tdjI8HPxTPoaimXI8OYryaGpA5wOKMT6BjsbxyWntWvAmKYzgNSjzPt+Jnidn
         0+7LnQ7rxa9gA0E7cbVClVQHgi7CvFSG3wgCu52UHyoE+XzhuQHPhggCyKstzXHBEK
         XMMZIwgcrqrpcr0HzYfANQ9v0wHaM+YvTABgdBgkXBYhmMhMZNdho8g6DKytc9LLS5
         EjodKQtcLYOV+pXXHARrSBhT1AfQ4nEB6nKlvax/axS7e6vIT4mUsR9VfFpe9VFdva
         Oj2u4em5wNy3w==
Date:   Mon, 5 Dec 2022 17:08:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: Re: [patch net-next 0/8] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <20221205170826.17c78e90@kernel.org>
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
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

On Mon,  5 Dec 2022 16:22:49 +0100 Jiri Pirko wrote:
> Currently, the devlink_register() is called as the last thing during
> driver init phase. For devlink objects, this is fine as the
> notifications of objects creations are withheld to be send only after
> devlink instance is registered. Until devlink is registered it is not
> visible to userspace.
> 
> But if a  netdev is registered before, user gets a notification with
> a link to devlink, which is not visible to the user yet.
> This is the event order user sees:
>  * new netdev event over RT netlink
>  * new devlink event over devlink netlink
>  * new devlink_port event over devlink netlink
> 
> Also, this is not consistent with devlink port split or devlink reload
> flows, where user gets notifications in following order:
>  * new devlink event over devlink netlink
> and then during port split or reload operation:
>  * new devlink_port event over devlink netlink
>  * new netdev event over RT netlink
> 
> In this case, devlink port and related netdev are registered on already
> registered devlink instance.
> 
> Purpose of this patchset is to fix the drivers init flow so devlink port
> gets registered only after devlink instance is registered.

I didn't reply because I don't have much to add beyond what 
I've already said too many times. I prefer to move to my
initial full refcounting / full locking design. I haven't posted 
any patches because I figured it's too low priority and too risky
to be doing right before the merge window.

I agree that reordering is a good idea but not as a fix, and hopefully
without conditional locking in the drivers:

+		if (!reload)
+			devl_lock(devlink);
+		err = mlxsw_driver->ports_init(mlxsw_core);
+		if (!reload)
+			devl_unlock(devlink);
