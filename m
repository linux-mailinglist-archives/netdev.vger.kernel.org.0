Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C0A3CB097
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 03:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhGPB41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 21:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhGPB40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 21:56:26 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812F3C06175F;
        Thu, 15 Jul 2021 18:53:31 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 201so7200897qkj.13;
        Thu, 15 Jul 2021 18:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mMrbupWLKKWlb/M4SwIM91oQjnK50FvbCUCAAQW90Tg=;
        b=VVtYUbVggc0rbEKT1lwJRvNjcp1JHWfL81HJEtnaAM0RvIwKpDDAXs0RdAtizw1l4N
         JRBPMEPAVGR9CL5mnTIxAvkWRFNm714XK71mriGkfRRPoCXPGegR2mFAxG9mu+os6wbE
         cPZp4R+qHWmFQHglMLqttXKM0/QLO/TmCvyHKM2lqc6wF/DxJdl+9mGf0EUGW9gVqqWY
         L6LiFa2TR+0CY+JMtME7OxxWP1H4TbXxIchccFYJRSrv6xWAu4EOFlF8NoiIQ0vtAUqR
         yYkValtNo7OwDjVh4cwHswRbI8BHlux6krgbislt3nZ8plcia+ir/gJNQFZX1MLghB9O
         /aOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mMrbupWLKKWlb/M4SwIM91oQjnK50FvbCUCAAQW90Tg=;
        b=ZjPuktKr/ujKbjRBDQAbQt5ZR4CE7QedI+Bh7IQmMBi+5hLStKmZ3YDOMpuG0TgY1l
         fMALpC5mKFUpZtBeW0Rth4ArTI6n42t30zn1W/sYGwGQ3/e0G3ZGh4U6dkKCtdvVBB/T
         Giffh5pC4jOiH78N5XBNgiCNhz4scWnutL5uGKtlu4wm0pTzL4o6uL1wwr1iZd+kTT61
         WGlSKb5LXGfV/YvwACWl76ZR6Lhoi0Z6vjZ05m2q4VTFpb+p6+Re1FUz2GiNKtzCzMiL
         pzsRW1PCcptomqbkDQ9NMPKbLA8D0cHkYs39L6/FNAjjDaWrzX2oeNoaHCQXNUX2F0Iz
         B6mg==
X-Gm-Message-State: AOAM531E2sx5pCLWHOjBTxuDpjh7LvPqqNE5Vimk1NrE54trw1mQmato
        21AUMVvBJIX3fqdx7/m52JpFRETNwQ==
X-Google-Smtp-Source: ABdhPJwOaBRT0TJ50rnq4AFiMsSv9QU4brrXERaxECxhZhCtB9NJPJIT8jRx+tXV38VbPeturzlcIw==
X-Received: by 2002:a05:620a:19a6:: with SMTP id bm38mr7230728qkb.241.1626400410591;
        Thu, 15 Jul 2021 18:53:30 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id q206sm3357781qka.19.2021.07.15.18.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 18:53:30 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next] netdevsim: Add multi-queue support
Date:   Thu, 15 Jul 2021 18:52:45 -0700
Message-Id: <20210716015246.7729-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently netdevsim only supports a single queue per port, which is
insufficient for testing multi-queue TC schedulers e.g. sch_mq.  Extend
the current sysfs interface so that users can create ports with multiple
queues:

$ echo "[ID] [PORT_COUNT] [NUM_QUEUES]" > /sys/bus/netdevsim/new_device

As an example, echoing "2 4 8" creates 4 ports, with 8 queues per port.
Note, this is compatible with the current interface, with default number
of queues set to 1.  For example, echoing "2 4" creates 4 ports with 1
queue per port; echoing "2" simply creates 1 port with 1 queue.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 drivers/net/netdevsim/bus.c       | 17 ++++++++++-------
 drivers/net/netdevsim/netdev.c    |  6 ++++--
 drivers/net/netdevsim/netdevsim.h |  1 +
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ccec29970d5b..ff01e5bdc72e 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -262,29 +262,31 @@ static struct device_type nsim_bus_dev_type = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count);
+nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queues);
 
 static ssize_t
 new_device_store(struct bus_type *bus, const char *buf, size_t count)
 {
+	unsigned int id, port_count, num_queues;
 	struct nsim_bus_dev *nsim_bus_dev;
-	unsigned int port_count;
-	unsigned int id;
 	int err;
 
-	err = sscanf(buf, "%u %u", &id, &port_count);
+	err = sscanf(buf, "%u %u %u", &id, &port_count, &num_queues);
 	switch (err) {
 	case 1:
 		port_count = 1;
 		fallthrough;
 	case 2:
+		num_queues = 1;
+		fallthrough;
+	case 3:
 		if (id > INT_MAX) {
 			pr_err("Value of \"id\" is too big.\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
+		pr_err("Format for adding new device is \"id port_count num_queues\" (uint uint unit).\n");
 		return -EINVAL;
 	}
 
@@ -295,7 +297,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		goto err;
 	}
 
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count, num_queues);
 	if (IS_ERR(nsim_bus_dev)) {
 		err = PTR_ERR(nsim_bus_dev);
 		goto err;
@@ -397,7 +399,7 @@ static struct bus_type nsim_bus = {
 #define NSIM_BUS_DEV_MAX_VFS 4
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count)
+nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queues)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
 	int err;
@@ -413,6 +415,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.bus = &nsim_bus;
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
+	nsim_bus_dev->num_queues = num_queues;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
 	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index c3aeb15843e2..50572e0f1f52 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -347,7 +347,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	struct netdevsim *ns;
 	int err;
 
-	dev = alloc_netdev(sizeof(*ns), "eth%d", NET_NAME_UNKNOWN, nsim_setup);
+	dev = alloc_netdev_mq(sizeof(*ns), "eth%d", NET_NAME_UNKNOWN, nsim_setup,
+			      nsim_dev->nsim_bus_dev->num_queues);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -392,7 +393,8 @@ void nsim_destroy(struct netdevsim *ns)
 static int nsim_validate(struct nlattr *tb[], struct nlattr *data[],
 			 struct netlink_ext_ack *extack)
 {
-	NL_SET_ERR_MSG_MOD(extack, "Please use: echo \"[ID] [PORT_COUNT]\" > /sys/bus/netdevsim/new_device");
+	NL_SET_ERR_MSG_MOD(extack,
+			   "Please use: echo \"[ID] [PORT_COUNT] [NUM_QUEUES]\" > /sys/bus/netdevsim/new_device");
 	return -EOPNOTSUPP;
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index ae462957dcee..1c20bcbd9d91 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -352,6 +352,7 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
+	unsigned int num_queues; /* Number of queues for each port on this bus */
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
-- 
2.20.1

