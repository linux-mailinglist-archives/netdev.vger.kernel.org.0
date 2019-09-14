Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3FB2A2D
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfINGq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35460 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfINGqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id y21so619276wmi.0
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=p74A1iJNHejDXW0X7wZiPFNNNFHhBPeMQa/bxtFH9Nsvem7i9NoZYW8NPEKlxXpm0c
         Cii6Tt1VSGRncjj+41mT1COBnzFF4rNQzuYa29vkLGPn/tO+8MtqItyrHLbc6yKEZaLa
         SUwAxJ+vd88uAxQOd0tuCXRcTsgcK/drnJk0tdLGq7Bz21ojYZHP14sUXhrpC2UbZuki
         +nZ2DSDxFKaut6qq9GJZb1hd7T1cr7pLvm80W54WF8twW5c1+qXrQU0dPqV+U906VU2s
         wdjSfSKV22ZPg8sPyQHe5I8/Nh9dmYrKPoivhxrFWAqjxgCyfR4S/wCfuZh5ovHCKnut
         EeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=X7A1UxWU/3eZgH8NnvJyQRv4l6K1MnqipsDVzQJkpiQelzzJJG9fT9TDDErewofXVT
         WbQCk+DsjeLG/2iV5ozMmc92Mz8IWhiVJvzM61KmNaaVz97dCwUjVpWxW078ILBPXf6A
         GIPpP+sI/EWNPk0clip/Tromq/6YFisMweCZDd1pAvqk9ECnwS7qnrZrZHn6BJWEnRWH
         elMPDnI06y4QHgrayR9Mpa4INFrpaohkqECGG+dZG62bS0aLPPqHGgsWOfmL0v2jV+uX
         WURFLLV7MmkXZaXNOiKGwvMYxYr5XbfMOB9S64WQaWh+GTCj9jDhJMqqQdiQZ2T6CqgT
         dTMQ==
X-Gm-Message-State: APjAAAVOMc0B97YVN7Ci7tQBxK2PDwr62O0Spr68JlYReCtGdTe29buq
        NXD9ltNNo3d62e6esOYA4pSs/5SQNl0=
X-Google-Smtp-Source: APXvYqxis3VuCB0mun5ttXjgDflDmzIQ+N52Fnagii5dVOVZNIBCPF+aF4OYVWJM1sdevcGYWd0IWQ==
X-Received: by 2002:a1c:9a4a:: with SMTP id c71mr5723489wme.99.1568443581989;
        Fri, 13 Sep 2019 23:46:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h125sm9999263wmf.31.2019.09.13.23.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 12/15] netdevsim: register port netdevices into net of device
Date:   Sat, 14 Sep 2019 08:46:05 +0200
Message-Id: <20190914064608.26799-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Register newly created port netdevice into net namespace
that the parent device belongs to.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/netdev.c    | 1 +
 drivers/net/netdevsim/netdevsim.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 0740940f41b1..2908e0a0d6e1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -290,6 +290,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	dev_net_set(dev, nsim_dev_net(nsim_dev));
 	ns = netdev_priv(dev);
 	ns->netdev = dev;
 	ns->nsim_dev = nsim_dev;
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 702d951fe160..198ca31cec94 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -164,6 +164,11 @@ struct nsim_dev {
 	struct devlink_region *dummy_region;
 };
 
+static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
+{
+	return devlink_net(priv_to_devlink(nsim_dev));
+}
+
 int nsim_dev_init(void);
 void nsim_dev_exit(void);
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
-- 
2.21.0

