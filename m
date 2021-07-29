Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8543DA2D3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhG2MGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhG2MGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 08:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7647060E76;
        Thu, 29 Jul 2021 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627560400;
        bh=vlWIaFERZhUTYIzo4LuIPX3bA+LZfCt3DKt3CEiMiSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NaE/vjSgmMbnpmb8T4vb1q6znKLGK3x9P++ku0UV/ZSfzWV2mf4F8Rr6WpVLeKEXw
         iX8NrFsIGPCGMhS5CrpaD8axtEkKEEeKWimvkNLisX6n9zUECoKJQiXXn75Mse68fv
         Qm0/GAb3l8c5uyxyngd8GEDz2Ep2AM1iMfWFvMSw0uWUtilX8Yxq5SEsFE4qByz6Jq
         EGvpcy+kawUUmicsy2+SD74LvfgDt6uegSHTopXL8sI7fczip7QKSxUM91z0tFJe+u
         WFZfm5Nv/W/8G+N1a4CEbpEFrVvS6XPtZ7HZqOOXn1ZH7WQaahPudoP5yVl8N+e4US
         c5xijvtlgbdJA==
Date:   Thu, 29 Jul 2021 15:06:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next 2/2] devlink: Allocate devlink directly in
 requested net namespace
Message-ID: <YQKZzBaqSC02jCPU@unreal>
References: <cover.1627545799.git.leonro@nvidia.com>
 <ca29973a59c9c128ab960e3cbff8dfa95280b6b0.1627545799.git.leonro@nvidia.com>
 <YQKXMT4tbzCnkYlA@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQKXMT4tbzCnkYlA@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:55:29PM +0200, Jiri Pirko wrote:
> Thu, Jul 29, 2021 at 10:15:26AM CEST, leon@kernel.org wrote:
> >From: Leon Romanovsky <leonro@nvidia.com>
> >
> >There is no need in extra call indirection and check from impossible
> >flow where someone tries to set namespace without prior call
> >to devlink_alloc().
> >
> >Instead of this extra logic and additional EXPORT_SYMBOL, use specialized
> >devlink allocation function that receives net namespace as an argument.
> >
> >Such specialized API allows clear view when devlink initialized in wrong
> >net namespace and/or kernel users don't try to change devlink namespace
> >under the hood.
> >
> >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >---
> > drivers/net/netdevsim/dev.c |  4 ++--
> > include/net/devlink.h       | 14 ++++++++++++--
> > net/core/devlink.c          | 26 ++++++++------------------
> > 3 files changed, 22 insertions(+), 22 deletions(-)
> >
> >diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> >index 6348307bfa84..d538a39d4225 100644
> >--- a/drivers/net/netdevsim/dev.c
> >+++ b/drivers/net/netdevsim/dev.c
> >@@ -1431,10 +1431,10 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
> > 	struct devlink *devlink;
> > 	int err;
> > 
> >-	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
> >+	devlink = devlink_alloc_ns(&nsim_dev_devlink_ops, sizeof(*nsim_dev),
> >+				   nsim_bus_dev->initial_net);
> > 	if (!devlink)
> > 		return -ENOMEM;
> >-	devlink_net_set(devlink, nsim_bus_dev->initial_net);
> > 	nsim_dev = devlink_priv(devlink);
> > 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
> > 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index e48a62320407..b4691c40320f 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -1540,8 +1540,18 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
> > struct ib_device;
> > 
> > struct net *devlink_net(const struct devlink *devlink);
> >-void devlink_net_set(struct devlink *devlink, struct net *net);
> >-struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
> >+/* This RAW call is intended for software devices that can
> 
> Not sure what "RAW call" is, perhaps you can just avoid this here.

I wanted to emphasize the message that we shouldn't see this call in
regular drivers and it is very specific to SW drivers.

I'll drop "RAW".

> 
> Otherwise, this patch looks fine to me:
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks

> 
> [...]
