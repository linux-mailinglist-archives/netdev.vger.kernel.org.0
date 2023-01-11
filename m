Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA0D665B01
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjAKMFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjAKME4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:04:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F1695A5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4AC7B81BAC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC705C433D2;
        Wed, 11 Jan 2023 12:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673438686;
        bh=C96ha8iUIT6U7b0IJ5SUlUqe3UrAU6hGl/9JBqpIwuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gp/rBZwnKBsZzt7DVk/sY1dsYbemHfRQQOb34OUj9lkbM/t5fFTrQicpWWHr8gwG3
         RUTkXO/BS8chwB+Bv2d4AJlkSo1DmtZgMV/QprQpCwbcq9RDAv3ETuNsmAnKbQqlHm
         rQQ8xYlO1jpXScqsAVHg6F0ed32xIIbxmp7IJxdrp6UsTP4t19p1wtG15cGZi7FR8i
         KCqp4TAj4+x2G9lgQQoA/My+2lFmSn83r0M4dnphtKZbkOaIr2T4PSH+mtcCUA1rVC
         UBjUjh51Q2iIgGliJr0Wy0TEp1VswlCkRh64pEkXtMhm7lqSdMfMUMf7CSEBPCxXVG
         g/TFmjY2h+T2w==
Date:   Wed, 11 Jan 2023 14:04:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        michael.chan@broadcom.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, tariqt@nvidia.com, saeedm@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 01/11] devlink: remove devlink features
Message-ID: <Y76l2egGm//4Qe5i@unreal>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <20230109183120.649825-2-jiri@resnulli.us>
 <20230109165500.3bebda0a@kernel.org>
 <Y70PyuHXJZ3gD8dG@nanopsycho>
 <20230110125915.62d428fb@kernel.org>
 <Y75nBEpxIWrDj9mF@unreal>
 <Y75x+1+z4VzBx/ip@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y75x+1+z4VzBx/ip@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 09:23:23AM +0100, Jiri Pirko wrote:
> Wed, Jan 11, 2023 at 08:36:36AM CET, leon@kernel.org wrote:
> >On Tue, Jan 10, 2023 at 12:59:15PM -0800, Jakub Kicinski wrote:
> >> On Tue, 10 Jan 2023 08:12:10 +0100 Jiri Pirko wrote:
> >> >> Right, but this is not 100% equivalent because we generate the
> >> >> notifications _before_ we try to reload_down:
> >> >>
> >> >>	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
> >> >>	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
> >> >>	if (err)
> >> >>		return err;
> >> >>
> >> >> IDK why, I haven't investigated.  
> >> > 
> >> > Right, but that is done even in other cases where down can't be done. I
> >> > I think there's a bug here, down DEL notification is sent before calling
> >> > down which can potentially fail. I think the notification call should be
> >> > moved after reload_down() call. Then the bahaviour would stay the same
> >> > for the features case and will get fixed for the reload_down() reject
> >> > cases. What do you think?
> >> 
> >> I was gonna say that it sounds reasonable, and that maybe we should 
> >> be in fact using devlink_notify_register() instead of the custom
> >> instance-and-params-only devlink_ns_change_notify().
> >> 
> >> But then I looked at who added this counter-intuitive code
> >> and found out it's for a reason - see 05a7f4a8dff19.
> >> 
> >> So you gotta check if mlx5 still has this problem...
> >
> >I don't see anything in the tree what will prevent the issue
> >which I wrote in 05a7f4a8dff19.
> 
> Okay. I will remove this patch from the set and address this in a
> separate patchset. Thanks!

BTW, I tried your v3 series and it caused to tests which changes
switchdev mode to stuck.

I'll try v4 now.

Thanks

> 
> >
> >Thanks
