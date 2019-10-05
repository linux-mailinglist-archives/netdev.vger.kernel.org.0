Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9536ACC859
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfJEGKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:10:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45117 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfJEGKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 02:10:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so9402349wrm.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 23:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UojzIFn5wrMDpW0bHqBSiGeYjSO+FjA9Oj0+nsEVp0A=;
        b=0a7M5/RVv+b4vSWBkyDf7pfGMu6kXUa2AKH87PdNogjkCTC9aOmuTbToL5r5e2GUKA
         uEVO8YLm38csOKfGG6FhNCGFv+aiQlNdXO9cuYAbJlWlGxLNDzI1+3SSbgUfseFLYQA5
         +ahmfiLbWi1tahuVoljryaTrDteywZjN0SL+JA6UEQlSQ/UpXJE03IcmQU4M/dK7YZil
         XW96a+A74iIYP7XfK/1qihNZiZR2aR07g9S1YJ955WcEsUmYeBjz8X7JRn8rzNFWTS0k
         mcCq0ApBgsfHu6AIUy1CCg9Wy0d4kKUPWlModL5V3ubGl7pxclXdcrxaxD1pYZ7FxO9Y
         pX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UojzIFn5wrMDpW0bHqBSiGeYjSO+FjA9Oj0+nsEVp0A=;
        b=BMtx/PtUoZ5QjGGlZbr54myHR/Cs6MiCS+ciasffmCTUekKaNt7ZgCgeTyJ23pLMIZ
         FQ1K0ZZoHNBcZQcVwi0RUQKmrhFY8Q8pbIFSG/9qTFc/YaXeB1MTdYjMBSj9VYQ+pcxx
         RJs6ngG+HJehs/IoXHO/bUowCCJXcMO4n2uRbMh+xBwXvmiEP4Q4xySUa8LFZaO7uSoE
         UiwbGb1ji8HJa0sbZWdZrOeMNC0LBkvl8Q0f6pDZciifgre/xq6oc88nmqhEMEOg9gV6
         VWFGthTlYxShEJgy+GzafGGdlBX6g07GxVR7k+5n7Ot+JTCHlvTnvQKW9cMqaeJ5c2Rw
         ckPA==
X-Gm-Message-State: APjAAAVE13ZPv/Ucp7vFvjfnEa09e4Npj9CNWas4zog9tfmTWanD/q5/
        S+IuUj7u/zykJugsUYCnl2/5/25EPkQ=
X-Google-Smtp-Source: APXvYqx3e5VrpbBMuuKKzknwqKDNMY0MbPhVGyiJ6oxVSfm58NP0kslceVKffAh76QQjqV98GwNA4w==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr13461077wrr.370.1570255836427;
        Fri, 04 Oct 2019 23:10:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b186sm18238150wmd.16.2019.10.04.23.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 23:10:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, petrm@mellanox.com,
        tariqt@mellanox.com, saeedm@mellanox.com, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: [patch net-next 2/3] netdevsim: create devlink and netdev instances in namespace
Date:   Sat,  5 Oct 2019 08:10:32 +0200
Message-Id: <20191005061033.24235-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005061033.24235-1-jiri@resnulli.us>
References: <20191005061033.24235-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When user does create new netdevsim instance using sysfs bus file,
create the devlink instance and related netdev instance in the namespace
of the caller.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/bus.c       | 1 +
 drivers/net/netdevsim/dev.c       | 1 +
 drivers/net/netdevsim/netdevsim.h | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 1a0ff3d7747b..6aeed0c600f8 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -283,6 +283,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.bus = &nsim_bus;
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
+	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 3f3c7cc21077..fbc4cdcfe551 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -726,6 +726,7 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
 	if (!devlink)
 		return ERR_PTR(-ENOMEM);
+	devlink_net_set(devlink, nsim_bus_dev->initial_net);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 198ca31cec94..8168a5475fe7 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -220,6 +220,9 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
+	struct net *initial_net; /* Purpose of this is to carry net pointer
+				  * during the probe time only.
+				  */
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
 };
-- 
2.21.0

