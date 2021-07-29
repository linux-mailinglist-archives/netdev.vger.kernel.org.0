Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1823DA6A2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhG2OjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236309AbhG2OjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 10:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 860F660F5C;
        Thu, 29 Jul 2021 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627569539;
        bh=aGLXIjHVkYWFzsChURMHFN9lIddAwd4xYj9dovWUc5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cw08f9z3c4pTROEqOYseH+vjOkSa5LYHWL1eaw5E6XZcPpTN5ciYRJ0exiM/FR3r1
         JQ9sU64enqIWE46Zuo+eIJvIxnUd5yiqJezUlBrG4oq/2F6i8IqhTP6C4CFOyjsabm
         0SBSr8vKOf67y8EMAINwO8fhE4MNBS8APZYN2c6vlQF4TNUdUjfYVMYYjkkHRYLfO8
         go0OWN6u3+xCIpECfK8vPZQDxE5nsta5Ea6d3SKyH/S5GXGPIGZn8HBwEb/mYofwlJ
         dPL0lOpskjqAhkpM+Gw8/8MjguGIh3V5bXuGYiYysmBVOYZZYsh+8MoMsgKikyApJV
         eAnnXAtdOJWdQ==
Date:   Thu, 29 Jul 2021 17:38:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next v1 1/2] devlink: Break parameter notification
 sequence to be before/after unload/load driver
Message-ID: <YQK9fxkb0FIYkzbx@unreal>
References: <cover.1627564383.git.leonro@nvidia.com>
 <a9a61cdee79cbfefa4e4e2cc973fe27a10b7ee4f.1627564383.git.leonro@nvidia.com>
 <YQK8VkXweZmWTggC@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQK8VkXweZmWTggC@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 04:33:58PM +0200, Jiri Pirko wrote:
> Thu, Jul 29, 2021 at 03:17:49PM CEST, leon@kernel.org wrote:
> >From: Leon Romanovsky <leonro@nvidia.com>

<...>

> >+static void devlink_ns_change_notify(struct devlink *devlink,
> >+				     struct net *dest_net, struct net *curr_net,
> >+				     enum devlink_command cmd, bool new)
> 
> Drop the cmd and determine the DEVLINK_CMD_PARAM_NEW/DEL by "new" arg as
> well. I thought I wrote that clearly in my previous review, but
> apparently not, sorry about that.
> 
> 
> 
> > {
> > 	struct devlink_param_item *param_item;
> > 
> >@@ -3812,17 +3813,17 @@ static void devlink_reload_netns_change(struct devlink *devlink,
> > 	 * reload process so the notifications are generated separatelly.
> > 	 */
> > 
> >-	list_for_each_entry(param_item, &devlink->param_list, list)
> >-		devlink_param_notify(devlink, 0, param_item,
> >-				     DEVLINK_CMD_PARAM_DEL);
> >-	devlink_notify(devlink, DEVLINK_CMD_DEL);
> >+	if (!dest_net || net_eq(dest_net, curr_net))
> >+		return;
> > 
> >-	__devlink_net_set(devlink, dest_net);
> >+	if (new)
> >+		devlink_notify(devlink, DEVLINK_CMD_NEW);
> > 
> >-	devlink_notify(devlink, DEVLINK_CMD_NEW);
> > 	list_for_each_entry(param_item, &devlink->param_list, list)
> >-		devlink_param_notify(devlink, 0, param_item,
> >-				     DEVLINK_CMD_PARAM_NEW);
> >+		devlink_param_notify(devlink, 0, param_item, cmd);
> 
> Like this:
> 		devlink_param_notify(devlink, 0, param_item, new ?
> 				     DEVLINK_CMD_PARAM_NEW ?
> 				     DEVLINK_CMD_PARAM_DEL);

IMHO it is not nice, but will change.

Thanks
