Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2CC3DA2DF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhG2MLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhG2MLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 08:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39BCB60EFF;
        Thu, 29 Jul 2021 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627560691;
        bh=sMoRtbrebUOK25Jsr9b7sT+iIpdf0tk5y/lFky3HY4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcfXCgxC46SPDPYMwT97SWt7ipMWIxx2vV372Tt03zEPt9IJ/Tq3/he3MgMqPqqJt
         GbUmQyKfnMosnS1OkUldnoLu4dUTNuaJVZ9j1EirrD3BGjaE8PN6Vceuboy/itU++f
         /7ITVeh2XH15/z1A0XKiBLsGZEj4+BUxy3CXZAmW8nx10b96TwjSR8rzw9+g8c1JUs
         c/2ybyioHhq4Q4J+sQLbgUHXRxwXovAQ5PG6Z8Bzwg0lfb3MJ3mV48A1LUfpF2r5Yz
         6n5vbTgd0MGWXZ4BduCf87EY9id9Q6r9H6IPFmqJcwFINucN/UVgWq/mhjiFBs0hS0
         tZZOtOhj1Wxdg==
Date:   Thu, 29 Jul 2021 15:11:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Break parameter notification
 sequence to be before/after unload/load driver
Message-ID: <YQKa8DqBS/UPVLaq@unreal>
References: <cover.1627545799.git.leonro@nvidia.com>
 <6d59d527ccbec04615ef0b4a237ea4e27f10cd8d.1627545799.git.leonro@nvidia.com>
 <YQKPkmYfKdM9zE5f@nanopsycho>
 <YQKSmwzppN4KNQiX@unreal>
 <YQKXjTZ0W04L7xqG@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQKXjTZ0W04L7xqG@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:57:01PM +0200, Jiri Pirko wrote:
> Thu, Jul 29, 2021 at 01:35:55PM CEST, leon@kernel.org wrote:
> >On Thu, Jul 29, 2021 at 01:22:58PM +0200, Jiri Pirko wrote:
> >> Thu, Jul 29, 2021 at 10:15:25AM CEST, leon@kernel.org wrote:
> >> >From: Leon Romanovsky <leonro@nvidia.com>
> >
> ><...>
> >
> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> >index b596a971b473..54e2a0375539 100644
> >> >--- a/net/core/devlink.c
> >> >+++ b/net/core/devlink.c
> >> >@@ -3801,8 +3801,9 @@ static void devlink_param_notify(struct devlink *devlink,
> >> > 				 struct devlink_param_item *param_item,
> >> > 				 enum devlink_command cmd);
> >> > 
> >> >-static void devlink_reload_netns_change(struct devlink *devlink,
> >> >-					struct net *dest_net)
> >> >+static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
> >> 
> >> Please name it differently. This function notifies not only the params,
> >> but the devlink instance itself as well.
> >
> >I'm open for suggestion. What did you have in mind?
> 
> devlink_ns_change_notify?

NP, will change 

> 
> >
> >> 
> >> 
> >> >+				  struct net *curr_net,
> >> >+				  enum devlink_command cmd)
> >> > {
> >> > 	struct devlink_param_item *param_item;
> >> > 
> >> >@@ -3812,17 +3813,17 @@ static void devlink_reload_netns_change(struct devlink *devlink,
> >> > 	 * reload process so the notifications are generated separatelly.
> >> > 	 */
> >> > 
> >> >-	list_for_each_entry(param_item, &devlink->param_list, list)
> >> >-		devlink_param_notify(devlink, 0, param_item,
> >> >-				     DEVLINK_CMD_PARAM_DEL);
> >> >-	devlink_notify(devlink, DEVLINK_CMD_DEL);
> >> >+	if (!dest_net || net_eq(dest_net, curr_net))
> >> >+		return;
> >> > 
> >> >-	__devlink_net_set(devlink, dest_net);
> >> >+	if (cmd == DEVLINK_CMD_PARAM_NEW)
> >> >+		devlink_notify(devlink, DEVLINK_CMD_NEW);
> >> 
> >> This is quite odd. According to PARAMS cmd you decife devlink CMD.
> >> 
> >> Just have bool arg which would help you select both
> >> DEVLINK_CMD_PARAM_NEW/DEL and DEVLINK_CMD_NEW/DEL
> >
> >The patch is quite misleading, but the final result looks neat:
> >
> >   3847 static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
> >   3848                                   struct net *curr_net,
> >   3849                                   enum devlink_command cmd)
> >   3850 {
> >   3851         struct devlink_param_item *param_item;
> >   3852 
> >   3853         /* Userspace needs to be notified about devlink objects
> >   3854          * removed from original and entering new network namespace.
> >   3855          * The rest of the devlink objects are re-created during
> >   3856          * reload process so the notifications are generated separatelly.
> >   3857          */
> >   3858 
> >   3859         if (!dest_net || net_eq(dest_net, curr_net))
> >   3860                 return;
> >   3861 
> >   3862         if (cmd == DEVLINK_CMD_PARAM_NEW)
> >   3863                 devlink_notify(devlink, DEVLINK_CMD_NEW);
> 
> Nothing misleading here. This is exactly what I'm pointing out...

Do you ask for this change?

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 077310c26a8b..ee7204787b29 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3846,7 +3846,7 @@ static void devlink_param_notify(struct devlink *devlink,
 
 static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
                                  struct net *curr_net,
-                                 enum devlink_command cmd)
+                                 enum devlink_command cmd, bool new)
 {
        struct devlink_param_item *param_item;
 
@@ -3859,13 +3859,13 @@ static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
        if (!dest_net || net_eq(dest_net, curr_net))
                return;
 
-       if (cmd == DEVLINK_CMD_PARAM_NEW)
+       if (new)
                devlink_notify(devlink, DEVLINK_CMD_NEW);
 
        list_for_each_entry(param_item, &devlink->param_list, list)
                devlink_param_notify(devlink, 0, param_item, cmd);
 
-       if (cmd == DEVLINK_CMD_PARAM_DEL)
+       if (!new)
                devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
@@ -3957,7 +3957,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 
        curr_net = devlink_net(devlink);
        devlink_params_notify(devlink, dest_net, curr_net,
-                             DEVLINK_CMD_PARAM_DEL);
+                             DEVLINK_CMD_PARAM_DEL, false);
        err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
        if (err)
                return err;
@@ -3971,7 +3971,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
                return err;
 
        devlink_params_notify(devlink, dest_net, curr_net,
-                             DEVLINK_CMD_PARAM_NEW);
+                             DEVLINK_CMD_PARAM_NEW, true);
        WARN_ON(!(*actions_performed & BIT(action)));
        /* Catch driver on updating the remote action within devlink reload */
        WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,


> 
> 
> 
> >   3864 
> >   3865         list_for_each_entry(param_item, &devlink->param_list, list)
> >   3866                 devlink_param_notify(devlink, 0, param_item, cmd);
> >   3867 
> >   3868         if (cmd == DEVLINK_CMD_PARAM_DEL)
> >   3869                 devlink_notify(devlink, DEVLINK_CMD_DEL);
> >   3870 }
> >
> >
> >So as you can see in line 3866, we anyway will need to provide "cmd", so
> >do you suggest to add extra two bool variables to the function signature
> >to avoid "cmd == DEVLINK_CMD_PARAM_NEW" and "cmd == DEVLINK_CMD_PARAM_DEL" ifs?
> >
> >Thanks
