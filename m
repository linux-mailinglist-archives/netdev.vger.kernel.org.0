Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDEA3E1611
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbhHENvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhHENvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60D4661156;
        Thu,  5 Aug 2021 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628171497;
        bh=eIjO8q3dhBFOBiTJiXZLDxR693f1XsUtcz1lB0NBadg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=euCaLvEL1JhYPrWQAXHI9RKCbFe+XEs+yvYcp3K31Dk/QfcDZ6QjmwzKpOdxTLXjj
         lgPrLBw80OY6Mky90gvJ9RFKWy7MPcUUCofCSva/sqZnwY3f8RBm7seSw4OCjWXTQA
         0jyolV+GGmbWzh1SFvuiIo6FgnPQdTHOc9QcWQ7mo4JjoXm5C8kMer5aZdCiy3yAUB
         K3U+Fe346FWSBn5TwvZpwiMkTpb76W6+Vml3Dv0ZpGG5d3aqRo0wJOn5gXaDH94EgE
         a4alq8+UH2rq4LH7g6H1w+DlplsQKun0r0XpB3VIbKVKDOce3OZ1lDY1Zk/oC4Wkga
         2FTnSYL4Dc9YQ==
Date:   Thu, 5 Aug 2021 16:51:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding
 or deleting ports
Message-ID: <YQvs4wRIIEDG6Dcu@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
 <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 06:15:47AM -0700, Jakub Kicinski wrote:
> On Thu,  5 Aug 2021 14:05:41 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In order to remove complexity in devlink core related to
> > devlink_reload_enable/disable, let's rewrite new_port/del_port
> > logic to rely on internal to netdevsim lock.
> > 
> > We should protect only reload_down flow because it destroys nsim_dev,
> > which is needed for nsim_dev_port_add/nsim_dev_port_del to hold
> > port_list_lock.
> 
> I don't understand why we only have to protect reload_down.

I assumed that if we succeeded to pass reload_down and we are in
reload_up stage, everything was already bailed out.

> 
> What protects us from adding a port right after down? That'd hit a
> destroyed mutex, up wipes the port list etc...

You will have very similar crash to already existing one:
* parallel call to del_device and add_port will hit same issue.

The idea is not make netdevsim universally correct, but to ensure that
it doesn't crash immediately.

> 
> > +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> > +	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
> > +		return -EOPNOTSUPP;
> 
> Why not -EBUSY?

This is what devlink_reload_disable() returns, so I kept same error.
It is not important at all.

What about the following change on top of this patch?

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index a29ec264119d..62d033a1a557 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -196,6 +196,11 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
 		return -EBUSY;
 
+	if (nsim_bus_dev->in_reload) {
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		return -EBUSY;
+	}
+
 	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
@@ -221,6 +226,11 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
 		return -EBUSY;
 
+	if (nsim_bus_dev->in_reload) {
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		return -EBUSY;
+	}
+
 	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ff5714209b86..53068e184c90 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -878,6 +878,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EOPNOTSUPP;
 	}
+	nsim_bus_dev->in_reload = true;
 
 	nsim_dev_reload_destroy(nsim_dev);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
@@ -889,17 +890,26 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_bus_dev *nsim_bus_dev;
+	int ret;
+
+	nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
+	nsim_bus_dev->in_reload = false;
 
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
 		 * value to true. Fail right away.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EINVAL;
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-	return nsim_dev_reload_create(nsim_dev, extack);
+	ret = nsim_dev_reload_create(nsim_dev, extack);
+	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+	return ret;
 }
 
 static int nsim_dev_info_get(struct devlink *devlink,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 1c20bcbd9d91..793c86dc5a9c 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -362,6 +362,7 @@ struct nsim_bus_dev {
 	struct nsim_vf_config *vfconfigs;
 	/* Lock for devlink->reload_enabled in netdevsim module */
 	struct mutex nsim_bus_reload_lock;
+	bool in_reload;
 	bool init;
 };
 


Thanks
