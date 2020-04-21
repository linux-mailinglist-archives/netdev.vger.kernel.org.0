Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9A1B2E43
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgDURYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDURYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:24:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09206206D5;
        Tue, 21 Apr 2020 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587489887;
        bh=NEaU3wlWaF94587vJCFRYxrgWXRJ/+ldje72bjI+Ncc=;
        h=From:To:Cc:Subject:Date:From;
        b=o1af6yHxXyIS/LANDhMJOC7BTVgVIiRbQO8QG4D6loDNLATs4kv6P8FSAN8Oi+GSj
         YAfyeYSHjIuFFPAP0vX03XgK0tzqni2sHJvcDKB8Kl6cI9RgYTNoR675V51uVuGO7F
         cA6SqdQozAsYDpRUVwUce+rNomeKg4FGa/XNbybI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH rdma-next] RDMA: Allow ib_client's to fail when add() is called
Date:   Tue, 21 Apr 2020 20:24:40 +0300
Message-Id: <20200421172440.387069-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

When a client is added it isn't allowed to fail, but all the client's have
various failure paths within their add routines.

This creates the very fringe condition where the client was added, failed
during add and didn't set the client_data. The core code will then still
call other client_data centric ops like remove(), rename(), get_nl_info(),
and get_net_dev_by_params() with NULL client_data - which is confusing and
unexpected.

If the add() callback fails, then do not call any more client ops for the
device, even remove.

Remove all the now redundant checks for NULL client_data in ops callbacks.

Update all the add() callbacks to return error codes
appropriately. EOPNOTSUPP is used for cases where the ULP does not support
the ib_device - eg because it only works with IB.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c                  | 24 ++++++++++--------
 drivers/infiniband/core/cma.c                 | 23 +++++++++--------
 drivers/infiniband/core/device.c              | 16 ++++++++++--
 drivers/infiniband/core/mad.c                 | 17 ++++++++++---
 drivers/infiniband/core/multicast.c           | 12 ++++-----
 drivers/infiniband/core/sa_query.c            | 22 ++++++++--------
 drivers/infiniband/core/user_mad.c            | 22 ++++++++--------
 drivers/infiniband/core/uverbs_main.c         | 24 +++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_main.c     | 15 ++++-------
 .../infiniband/ulp/opa_vnic/opa_vnic_vema.c   | 12 ++++-----
 drivers/infiniband/ulp/srp/ib_srp.c           | 21 ++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.c         | 25 ++++++++-----------
 include/rdma/ib_verbs.h                       |  2 +-
 net/rds/ib.c                                  | 21 ++++++++++------
 net/smc/smc_ib.c                              | 10 +++-----
 15 files changed, 142 insertions(+), 124 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4794113ecd59..68e1a9bba027 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -81,7 +81,7 @@ const char *__attribute_const__ ibcm_reject_msg(int reason)
 EXPORT_SYMBOL(ibcm_reject_msg);
 
 struct cm_id_private;
-static void cm_add_one(struct ib_device *device);
+static int cm_add_one(struct ib_device *device);
 static void cm_remove_one(struct ib_device *device, void *client_data);
 static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 				   struct ib_cm_sidr_rep_param *param);
@@ -4382,7 +4382,7 @@ static void cm_remove_port_fs(struct cm_port *port)
 
 }
 
-static void cm_add_one(struct ib_device *ib_device)
+static int cm_add_one(struct ib_device *ib_device)
 {
 	struct cm_device *cm_dev;
 	struct cm_port *port;
@@ -4401,7 +4401,7 @@ static void cm_add_one(struct ib_device *ib_device)
 	cm_dev = kzalloc(struct_size(cm_dev, port, ib_device->phys_port_cnt),
 			 GFP_KERNEL);
 	if (!cm_dev)
-		return;
+		return -ENOMEM;
 
 	cm_dev->ib_device = ib_device;
 	cm_dev->ack_delay = ib_device->attrs.local_ca_ack_delay;
@@ -4413,8 +4413,10 @@ static void cm_add_one(struct ib_device *ib_device)
 			continue;
 
 		port = kzalloc(sizeof *port, GFP_KERNEL);
-		if (!port)
+		if (!port) {
+			ret = -ENOMEM;
 			goto error1;
+		}
 
 		cm_dev->port[i-1] = port;
 		port->cm_dev = cm_dev;
@@ -4435,8 +4437,10 @@ static void cm_add_one(struct ib_device *ib_device)
 							cm_recv_handler,
 							port,
 							0);
-		if (IS_ERR(port->mad_agent))
+		if (IS_ERR(port->mad_agent)) {
+			ret = PTR_ERR(port->mad_agent);
 			goto error2;
+		}
 
 		ret = ib_modify_port(ib_device, i, 0, &port_modify);
 		if (ret)
@@ -4445,15 +4449,17 @@ static void cm_add_one(struct ib_device *ib_device)
 		count++;
 	}
 
-	if (!count)
+	if (!count) {
+		ret = -EOPNOTSUPP;
 		goto free;
+	}
 
 	ib_set_client_data(ib_device, &cm_client, cm_dev);
 
 	write_lock_irqsave(&cm.device_lock, flags);
 	list_add_tail(&cm_dev->list, &cm.device_list);
 	write_unlock_irqrestore(&cm.device_lock, flags);
-	return;
+	return 0;
 
 error3:
 	ib_unregister_mad_agent(port->mad_agent);
@@ -4475,6 +4481,7 @@ static void cm_add_one(struct ib_device *ib_device)
 	}
 free:
 	kfree(cm_dev);
+	return ret;
 }
 
 static void cm_remove_one(struct ib_device *ib_device, void *client_data)
@@ -4489,9 +4496,6 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 	unsigned long flags;
 	int i;
 
-	if (!cm_dev)
-		return;
-
 	write_lock_irqsave(&cm.device_lock, flags);
 	list_del(&cm_dev->list);
 	write_unlock_irqrestore(&cm.device_lock, flags);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e74c2ba82e7b..432eec472164 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -153,7 +153,7 @@ struct rdma_cm_id *rdma_res_to_id(struct rdma_restrack_entry *res)
 }
 EXPORT_SYMBOL(rdma_res_to_id);
 
-static void cma_add_one(struct ib_device *device);
+static int cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client cma_client = {
@@ -4661,29 +4661,34 @@ static struct notifier_block cma_nb = {
 	.notifier_call = cma_netdev_callback
 };
 
-static void cma_add_one(struct ib_device *device)
+static int cma_add_one(struct ib_device *device)
 {
 	struct cma_device *cma_dev;
 	struct rdma_id_private *id_priv;
 	unsigned int i;
 	unsigned long supported_gids = 0;
+	int ret;
 
 	cma_dev = kmalloc(sizeof *cma_dev, GFP_KERNEL);
 	if (!cma_dev)
-		return;
+		return -ENOMEM;
 
 	cma_dev->device = device;
 	cma_dev->default_gid_type = kcalloc(device->phys_port_cnt,
 					    sizeof(*cma_dev->default_gid_type),
 					    GFP_KERNEL);
-	if (!cma_dev->default_gid_type)
+	if (!cma_dev->default_gid_type) {
+		ret = -ENOMEM;
 		goto free_cma_dev;
+	}
 
 	cma_dev->default_roce_tos = kcalloc(device->phys_port_cnt,
 					    sizeof(*cma_dev->default_roce_tos),
 					    GFP_KERNEL);
-	if (!cma_dev->default_roce_tos)
+	if (!cma_dev->default_roce_tos) {
+		ret = -ENOMEM;
 		goto free_gid_type;
+	}
 
 	rdma_for_each_port (device, i) {
 		supported_gids = roce_gid_type_mask_support(device, i);
@@ -4709,15 +4714,14 @@ static void cma_add_one(struct ib_device *device)
 	mutex_unlock(&lock);
 
 	trace_cm_add_one(device);
-	return;
+	return 0;
 
 free_gid_type:
 	kfree(cma_dev->default_gid_type);
 
 free_cma_dev:
 	kfree(cma_dev);
-
-	return;
+	return ret;
 }
 
 static int cma_remove_id_dev(struct rdma_id_private *id_priv)
@@ -4779,9 +4783,6 @@ static void cma_remove_one(struct ib_device *device, void *client_data)
 
 	trace_cm_remove_one(device);
 
-	if (!cma_dev)
-		return;
-
 	mutex_lock(&lock);
 	list_del(&cma_dev->list);
 	mutex_unlock(&lock);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d0b3d35ad3e4..d9f565a779df 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -677,8 +677,20 @@ static int add_client_context(struct ib_device *device,
 	if (ret)
 		goto out;
 	downgrade_write(&device->client_data_rwsem);
-	if (client->add)
-		client->add(device);
+	if (client->add) {
+		if (client->add(device)) {
+			/*
+			 * If a client fails to add then the error code is
+			 * ignored, but we won't call any more ops on this
+			 * client.
+			 */
+			xa_erase(&device->client_data, client->client_id);
+			up_read(&device->client_data_rwsem);
+			ib_device_put(device);
+			ib_client_put(client);
+			return 0;
+		}
+	}
 
 	/* Readers shall not see a client until add has been completed */
 	xa_set_mark(&device->client_data, client->client_id,
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index c54db13fa9b0..2d6406cf59f3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3304,9 +3304,11 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	return 0;
 }
 
-static void ib_mad_init_device(struct ib_device *device)
+static int ib_mad_init_device(struct ib_device *device)
 {
 	int start, i;
+	unsigned int count = 0;
+	int ret;
 
 	start = rdma_start_port(device);
 
@@ -3314,17 +3316,23 @@ static void ib_mad_init_device(struct ib_device *device)
 		if (!rdma_cap_ib_mad(device, i))
 			continue;
 
-		if (ib_mad_port_open(device, i)) {
+		ret = ib_mad_port_open(device, i);
+		if (ret) {
 			dev_err(&device->dev, "Couldn't open port %d\n", i);
 			goto error;
 		}
-		if (ib_agent_port_open(device, i)) {
+		ret = ib_agent_port_open(device, i);
+		if (ret) {
 			dev_err(&device->dev,
 				"Couldn't open port %d for agents\n", i);
 			goto error_agent;
 		}
+		count++;
 	}
-	return;
+	if (!count)
+		return -EOPNOTSUPP;
+
+	return 0;
 
 error_agent:
 	if (ib_mad_port_close(device, i))
@@ -3341,6 +3349,7 @@ static void ib_mad_init_device(struct ib_device *device)
 		if (ib_mad_port_close(device, i))
 			dev_err(&device->dev, "Couldn't close port %d\n", i);
 	}
+	return ret;
 }
 
 static void ib_mad_remove_device(struct ib_device *device, void *client_data)
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 9c2d8b7f1af9..740f03ecc05d 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -42,7 +42,7 @@
 #include <rdma/ib_cache.h>
 #include "sa.h"
 
-static void mcast_add_one(struct ib_device *device);
+static int mcast_add_one(struct ib_device *device);
 static void mcast_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client mcast_client = {
@@ -815,7 +815,7 @@ static void mcast_event_handler(struct ib_event_handler *handler,
 	}
 }
 
-static void mcast_add_one(struct ib_device *device)
+static int mcast_add_one(struct ib_device *device)
 {
 	struct mcast_device *dev;
 	struct mcast_port *port;
@@ -825,7 +825,7 @@ static void mcast_add_one(struct ib_device *device)
 	dev = kmalloc(struct_size(dev, port, device->phys_port_cnt),
 		      GFP_KERNEL);
 	if (!dev)
-		return;
+		return -ENOMEM;
 
 	dev->start_port = rdma_start_port(device);
 	dev->end_port = rdma_end_port(device);
@@ -845,7 +845,7 @@ static void mcast_add_one(struct ib_device *device)
 
 	if (!count) {
 		kfree(dev);
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	dev->device = device;
@@ -853,6 +853,7 @@ static void mcast_add_one(struct ib_device *device)
 
 	INIT_IB_EVENT_HANDLER(&dev->event_handler, device, mcast_event_handler);
 	ib_register_event_handler(&dev->event_handler);
+	return 0;
 }
 
 static void mcast_remove_one(struct ib_device *device, void *client_data)
@@ -861,9 +862,6 @@ static void mcast_remove_one(struct ib_device *device, void *client_data)
 	struct mcast_port *port;
 	int i;
 
-	if (!dev)
-		return;
-
 	ib_unregister_event_handler(&dev->event_handler);
 	flush_workqueue(mcast_wq);
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 2dd326f2beed..5c878646ff62 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -174,7 +174,7 @@ static const struct nla_policy ib_nl_policy[LS_NLA_TYPE_MAX] = {
 };
 
 
-static void ib_sa_add_one(struct ib_device *device);
+static int ib_sa_add_one(struct ib_device *device);
 static void ib_sa_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client sa_client = {
@@ -2322,18 +2322,19 @@ static void ib_sa_event(struct ib_event_handler *handler,
 	}
 }
 
-static void ib_sa_add_one(struct ib_device *device)
+static int ib_sa_add_one(struct ib_device *device)
 {
 	struct ib_sa_device *sa_dev;
 	int s, e, i;
 	int count = 0;
+	int ret;
 
 	s = rdma_start_port(device);
 	e = rdma_end_port(device);
 
 	sa_dev = kzalloc(struct_size(sa_dev, port, e - s + 1), GFP_KERNEL);
 	if (!sa_dev)
-		return;
+		return -ENOMEM;
 
 	sa_dev->start_port = s;
 	sa_dev->end_port   = e;
@@ -2353,8 +2354,10 @@ static void ib_sa_add_one(struct ib_device *device)
 			ib_register_mad_agent(device, i + s, IB_QPT_GSI,
 					      NULL, 0, send_handler,
 					      recv_handler, sa_dev, 0);
-		if (IS_ERR(sa_dev->port[i].agent))
+		if (IS_ERR(sa_dev->port[i].agent)) {
+			ret = PTR_ERR(sa_dev->port[i].agent);
 			goto err;
+		}
 
 		INIT_WORK(&sa_dev->port[i].update_task, update_sm_ah);
 		INIT_DELAYED_WORK(&sa_dev->port[i].ib_cpi_work,
@@ -2363,8 +2366,10 @@ static void ib_sa_add_one(struct ib_device *device)
 		count++;
 	}
 
-	if (!count)
+	if (!count) {
+		ret = -EOPNOTSUPP;
 		goto free;
+	}
 
 	ib_set_client_data(device, &sa_client, sa_dev);
 
@@ -2383,7 +2388,7 @@ static void ib_sa_add_one(struct ib_device *device)
 			update_sm_ah(&sa_dev->port[i].update_task);
 	}
 
-	return;
+	return 0;
 
 err:
 	while (--i >= 0) {
@@ -2392,7 +2397,7 @@ static void ib_sa_add_one(struct ib_device *device)
 	}
 free:
 	kfree(sa_dev);
-	return;
+	return ret;
 }
 
 static void ib_sa_remove_one(struct ib_device *device, void *client_data)
@@ -2400,9 +2405,6 @@ static void ib_sa_remove_one(struct ib_device *device, void *client_data)
 	struct ib_sa_device *sa_dev = client_data;
 	int i;
 
-	if (!sa_dev)
-		return;
-
 	ib_unregister_event_handler(&sa_dev->event_handler);
 	flush_workqueue(ib_wq);
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index da229eab5903..b0d0b522cc76 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -142,7 +142,7 @@ static dev_t dynamic_issm_dev;
 
 static DEFINE_IDA(umad_ida);
 
-static void ib_umad_add_one(struct ib_device *device);
+static int ib_umad_add_one(struct ib_device *device);
 static void ib_umad_remove_one(struct ib_device *device, void *client_data);
 
 static void ib_umad_dev_free(struct kref *kref)
@@ -1352,37 +1352,41 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 	put_device(&port->dev);
 }
 
-static void ib_umad_add_one(struct ib_device *device)
+static int ib_umad_add_one(struct ib_device *device)
 {
 	struct ib_umad_device *umad_dev;
 	int s, e, i;
 	int count = 0;
+	int ret;
 
 	s = rdma_start_port(device);
 	e = rdma_end_port(device);
 
 	umad_dev = kzalloc(struct_size(umad_dev, ports, e - s + 1), GFP_KERNEL);
 	if (!umad_dev)
-		return;
+		return -ENOMEM;
 
 	kref_init(&umad_dev->kref);
 	for (i = s; i <= e; ++i) {
 		if (!rdma_cap_ib_mad(device, i))
 			continue;
 
-		if (ib_umad_init_port(device, i, umad_dev,
-				      &umad_dev->ports[i - s]))
+		ret = ib_umad_init_port(device, i, umad_dev,
+					&umad_dev->ports[i - s]);
+		if (ret)
 			goto err;
 
 		count++;
 	}
 
-	if (!count)
+	if (!count) {
+		ret = -EOPNOTSUPP;
 		goto free;
+	}
 
 	ib_set_client_data(device, &umad_client, umad_dev);
 
-	return;
+	return 0;
 
 err:
 	while (--i >= s) {
@@ -1394,6 +1398,7 @@ static void ib_umad_add_one(struct ib_device *device)
 free:
 	/* balances kref_init */
 	ib_umad_dev_put(umad_dev);
+	return ret;
 }
 
 static void ib_umad_remove_one(struct ib_device *device, void *client_data)
@@ -1401,9 +1406,6 @@ static void ib_umad_remove_one(struct ib_device *device, void *client_data)
 	struct ib_umad_device *umad_dev = client_data;
 	unsigned int i;
 
-	if (!umad_dev)
-		return;
-
 	rdma_for_each_port (device, i) {
 		if (rdma_cap_ib_mad(device, i))
 			ib_umad_kill_port(
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8710a3427146..d52eb870533b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -75,7 +75,7 @@ static dev_t dynamic_uverbs_dev;
 static struct class *uverbs_class;
 
 static DEFINE_IDA(uverbs_ida);
-static void ib_uverbs_add_one(struct ib_device *device);
+static int ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device, void *client_data);
 
 /*
@@ -1091,7 +1091,7 @@ static int ib_uverbs_create_uapi(struct ib_device *device,
 	return 0;
 }
 
-static void ib_uverbs_add_one(struct ib_device *device)
+static int ib_uverbs_add_one(struct ib_device *device)
 {
 	int devnum;
 	dev_t base;
@@ -1099,16 +1099,16 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	int ret;
 
 	if (!device->ops.alloc_ucontext)
-		return;
+		return -EOPNOTSUPP;
 
 	uverbs_dev = kzalloc(sizeof(*uverbs_dev), GFP_KERNEL);
 	if (!uverbs_dev)
-		return;
+		return -ENOMEM;
 
 	ret = init_srcu_struct(&uverbs_dev->disassociate_srcu);
 	if (ret) {
 		kfree(uverbs_dev);
-		return;
+		return -ENOMEM;
 	}
 
 	device_initialize(&uverbs_dev->dev);
@@ -1128,15 +1128,18 @@ static void ib_uverbs_add_one(struct ib_device *device)
 
 	devnum = ida_alloc_max(&uverbs_ida, IB_UVERBS_MAX_DEVICES - 1,
 			       GFP_KERNEL);
-	if (devnum < 0)
+	if (devnum < 0) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	uverbs_dev->devnum = devnum;
 	if (devnum >= IB_UVERBS_NUM_FIXED_MINOR)
 		base = dynamic_uverbs_dev + devnum - IB_UVERBS_NUM_FIXED_MINOR;
 	else
 		base = IB_UVERBS_BASE_DEV + devnum;
 
-	if (ib_uverbs_create_uapi(device, uverbs_dev))
+	ret = ib_uverbs_create_uapi(device, uverbs_dev);
+	if (ret)
 		goto err_uapi;
 
 	uverbs_dev->dev.devt = base;
@@ -1151,7 +1154,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		goto err_uapi;
 
 	ib_set_client_data(device, &uverbs_client, uverbs_dev);
-	return;
+	return 0;
 
 err_uapi:
 	ida_free(&uverbs_ida, devnum);
@@ -1160,7 +1163,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		ib_uverbs_comp_dev(uverbs_dev);
 	wait_for_completion(&uverbs_dev->comp);
 	put_device(&uverbs_dev->dev);
-	return;
+	return ret;
 }
 
 static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
@@ -1203,9 +1206,6 @@ static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
 	struct ib_uverbs_device *uverbs_dev = client_data;
 	int wait_clients = 1;
 
-	if (!uverbs_dev)
-		return;
-
 	cdev_device_del(&uverbs_dev->cdev, &uverbs_dev->dev);
 	ida_free(&uverbs_ida, uverbs_dev->devnum);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 81b8227214f1..d4c6a97ce4c0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -86,7 +86,7 @@ struct workqueue_struct *ipoib_workqueue;
 
 struct ib_sa_client ipoib_sa_client;
 
-static void ipoib_add_one(struct ib_device *device);
+static int ipoib_add_one(struct ib_device *device);
 static void ipoib_remove_one(struct ib_device *device, void *client_data);
 static void ipoib_neigh_reclaim(struct rcu_head *rp);
 static struct net_device *ipoib_get_net_dev_by_params(
@@ -479,9 +479,6 @@ static struct net_device *ipoib_get_net_dev_by_params(
 	if (ret)
 		return NULL;
 
-	if (!dev_list)
-		return NULL;
-
 	/* See if we can find a unique device matching the L2 parameters */
 	matches = __ipoib_get_net_dev_by_params(dev_list, port, pkey_index,
 						gid, NULL, &net_dev);
@@ -2514,7 +2511,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	return ERR_PTR(-ENOMEM);
 }
 
-static void ipoib_add_one(struct ib_device *device)
+static int ipoib_add_one(struct ib_device *device)
 {
 	struct list_head *dev_list;
 	struct net_device *dev;
@@ -2524,7 +2521,7 @@ static void ipoib_add_one(struct ib_device *device)
 
 	dev_list = kmalloc(sizeof(*dev_list), GFP_KERNEL);
 	if (!dev_list)
-		return;
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(dev_list);
 
@@ -2541,10 +2538,11 @@ static void ipoib_add_one(struct ib_device *device)
 
 	if (!count) {
 		kfree(dev_list);
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	ib_set_client_data(device, &ipoib_client, dev_list);
+	return 0;
 }
 
 static void ipoib_remove_one(struct ib_device *device, void *client_data)
@@ -2552,9 +2550,6 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 	struct ipoib_dev_priv *priv, *tmp, *cpriv, *tcpriv;
 	struct list_head *dev_list = client_data;
 
-	if (!dev_list)
-		return;
-
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		LIST_HEAD(head);
 		ipoib_parent_unregister_pre(priv->dev);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 6e8d650c17c7..874a8eb7638c 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -113,7 +113,7 @@ struct opa_vnic_vema_port {
 	struct mutex                    lock;
 };
 
-static void opa_vnic_vema_add_one(struct ib_device *device);
+static int opa_vnic_vema_add_one(struct ib_device *device);
 static void opa_vnic_vema_rem_one(struct ib_device *device,
 				  void *client_data);
 
@@ -989,18 +989,18 @@ static void opa_vnic_ctrl_config_dev(struct opa_vnic_ctrl_port *cport, bool en)
  *
  * Allocate the vnic control port and initialize it.
  */
-static void opa_vnic_vema_add_one(struct ib_device *device)
+static int opa_vnic_vema_add_one(struct ib_device *device)
 {
 	struct opa_vnic_ctrl_port *cport;
 	int rc, size = sizeof(*cport);
 
 	if (!rdma_cap_opa_vnic(device))
-		return;
+		return -EOPNOTSUPP;
 
 	size += device->phys_port_cnt * sizeof(struct opa_vnic_vema_port);
 	cport = kzalloc(size, GFP_KERNEL);
 	if (!cport)
-		return;
+		return -ENOMEM;
 
 	cport->num_ports = device->phys_port_cnt;
 	cport->ibdev = device;
@@ -1012,6 +1012,7 @@ static void opa_vnic_vema_add_one(struct ib_device *device)
 
 	ib_set_client_data(device, &opa_vnic_client, cport);
 	opa_vnic_ctrl_config_dev(cport, true);
+	return 0;
 }
 
 /**
@@ -1026,9 +1027,6 @@ static void opa_vnic_vema_rem_one(struct ib_device *device,
 {
 	struct opa_vnic_ctrl_port *cport = client_data;
 
-	if (!cport)
-		return;
-
 	c_info("removing VNIC client\n");
 	opa_vnic_ctrl_config_dev(cport, false);
 	vema_unregister(cport);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cd1181c39ed2..00b4f88b113e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -146,7 +146,7 @@ module_param(ch_count, uint, 0444);
 MODULE_PARM_DESC(ch_count,
 		 "Number of RDMA channels to use for communication with an SRP target. Using more than one channel improves performance if the HCA supports multiple completion vectors. The default value is the minimum of four times the number of online CPU sockets and the number of completion vectors supported by the HCA.");
 
-static void srp_add_one(struct ib_device *device);
+static int srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device, void *client_data);
 static void srp_rename_dev(struct ib_device *device, void *client_data);
 static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -4132,7 +4132,7 @@ static void srp_rename_dev(struct ib_device *device, void *client_data)
 	}
 }
 
-static void srp_add_one(struct ib_device *device)
+static int srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct ib_device_attr *attr = &device->attrs;
@@ -4144,7 +4144,7 @@ static void srp_add_one(struct ib_device *device)
 
 	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
 	if (!srp_dev)
-		return;
+		return -ENOMEM;
 
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
@@ -4197,8 +4197,12 @@ static void srp_add_one(struct ib_device *device)
 
 	srp_dev->dev = device;
 	srp_dev->pd  = ib_alloc_pd(device, flags);
-	if (IS_ERR(srp_dev->pd))
-		goto free_dev;
+	if (IS_ERR(srp_dev->pd)) {
+		int ret = PTR_ERR(srp_dev->pd);
+
+		kfree(srp_dev);
+		return ret;
+	}
 
 	if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
 		srp_dev->global_rkey = srp_dev->pd->unsafe_global_rkey;
@@ -4212,10 +4216,7 @@ static void srp_add_one(struct ib_device *device)
 	}
 
 	ib_set_client_data(device, &srp_client, srp_dev);
-	return;
-
-free_dev:
-	kfree(srp_dev);
+	return 0;
 }
 
 static void srp_remove_one(struct ib_device *device, void *client_data)
@@ -4225,8 +4226,6 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 	struct srp_target_port *target;
 
 	srp_dev = client_data;
-	if (!srp_dev)
-		return;
 
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9d02d8088f1c..7ed38d1cb997 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3101,7 +3101,7 @@ static int srpt_use_srq(struct srpt_device *sdev, bool use_srq)
  * srpt_add_one - InfiniBand device addition callback function
  * @device: Describes a HCA.
  */
-static void srpt_add_one(struct ib_device *device)
+static int srpt_add_one(struct ib_device *device)
 {
 	struct srpt_device *sdev;
 	struct srpt_port *sport;
@@ -3112,14 +3112,16 @@ static void srpt_add_one(struct ib_device *device)
 	sdev = kzalloc(struct_size(sdev, port, device->phys_port_cnt),
 		       GFP_KERNEL);
 	if (!sdev)
-		goto err;
+		return -ENOMEM;
 
 	sdev->device = device;
 	mutex_init(&sdev->sdev_mutex);
 
 	sdev->pd = ib_alloc_pd(device, 0);
-	if (IS_ERR(sdev->pd))
+	if (IS_ERR(sdev->pd)) {
+		ret = PTR_ERR(sdev->pd);
 		goto free_dev;
+	}
 
 	sdev->lkey = sdev->pd->local_dma_lkey;
 
@@ -3135,6 +3137,7 @@ static void srpt_add_one(struct ib_device *device)
 	if (IS_ERR(sdev->cm_id)) {
 		pr_info("ib_create_cm_id() failed: %ld\n",
 			PTR_ERR(sdev->cm_id));
+		ret = PTR_ERR(sdev->cm_id);
 		sdev->cm_id = NULL;
 		if (!rdma_cm_id)
 			goto err_ring;
@@ -3179,7 +3182,8 @@ static void srpt_add_one(struct ib_device *device)
 		mutex_init(&sport->port_gid_id.mutex);
 		INIT_LIST_HEAD(&sport->port_gid_id.tpg_list);
 
-		if (srpt_refresh_port(sport)) {
+		ret = srpt_refresh_port(sport);
+		if (ret) {
 			pr_err("MAD registration failed for %s-%d.\n",
 			       dev_name(&sdev->device->dev), i);
 			goto err_event;
@@ -3190,10 +3194,9 @@ static void srpt_add_one(struct ib_device *device)
 	list_add_tail(&sdev->list, &srpt_dev_list);
 	spin_unlock(&srpt_dev_lock);
 
-out:
 	ib_set_client_data(device, &srpt_client, sdev);
 	pr_debug("added %s.\n", dev_name(&device->dev));
-	return;
+	return 0;
 
 err_event:
 	ib_unregister_event_handler(&sdev->event_handler);
@@ -3205,10 +3208,8 @@ static void srpt_add_one(struct ib_device *device)
 	ib_dealloc_pd(sdev->pd);
 free_dev:
 	kfree(sdev);
-err:
-	sdev = NULL;
 	pr_info("%s(%s) failed.\n", __func__, dev_name(&device->dev));
-	goto out;
+	return ret;
 }
 
 /**
@@ -3221,12 +3222,6 @@ static void srpt_remove_one(struct ib_device *device, void *client_data)
 	struct srpt_device *sdev = client_data;
 	int i;
 
-	if (!sdev) {
-		pr_info("%s(%s): nothing to do.\n", __func__,
-			dev_name(&device->dev));
-		return;
-	}
-
 	srpt_unregister_mad_agent(sdev);
 
 	ib_unregister_event_handler(&sdev->event_handler);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 81872264d3d2..941196da5eb3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2717,7 +2717,7 @@ struct ib_device {
 struct ib_client_nl_info;
 struct ib_client {
 	const char *name;
-	void (*add)   (struct ib_device *);
+	int (*add)(struct ib_device *ibdev);
 	void (*remove)(struct ib_device *, void *client_data);
 	void (*rename)(struct ib_device *dev, void *client_data);
 	int (*get_nl_info)(struct ib_device *ibdev, void *client_data,
diff --git a/net/rds/ib.c b/net/rds/ib.c
index a792d8a3872a..90212ed3edf1 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -127,19 +127,20 @@ void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
 		queue_work(rds_wq, &rds_ibdev->free_work);
 }
 
-static void rds_ib_add_one(struct ib_device *device)
+static int rds_ib_add_one(struct ib_device *device)
 {
 	struct rds_ib_device *rds_ibdev;
 	bool has_fr, has_fmr;
+	int ret;
 
 	/* Only handle IB (no iWARP) devices */
 	if (device->node_type != RDMA_NODE_IB_CA)
-		return;
+		return -EOPNOTSUPP;
 
 	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
 				 ibdev_to_node(device));
 	if (!rds_ibdev)
-		return;
+		return -ENOMEM;
 
 	spin_lock_init(&rds_ibdev->spinlock);
 	refcount_set(&rds_ibdev->refcount, 1);
@@ -182,12 +183,14 @@ static void rds_ib_add_one(struct ib_device *device)
 	if (!rds_ibdev->vector_load) {
 		pr_err("RDS/IB: %s failed to allocate vector memory\n",
 			__func__);
+		ret = -ENOMEM;
 		goto put_dev;
 	}
 
 	rds_ibdev->dev = device;
 	rds_ibdev->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(rds_ibdev->pd)) {
+		ret = PTR_ERR(rds_ibdev->pd);
 		rds_ibdev->pd = NULL;
 		goto put_dev;
 	}
@@ -195,12 +198,15 @@ static void rds_ib_add_one(struct ib_device *device)
 						   device->dma_device,
 						   sizeof(struct rds_header),
 						   L1_CACHE_BYTES, 0);
-	if (!rds_ibdev->rid_hdrs_pool)
+	if (!rds_ibdev->rid_hdrs_pool) {
+		ret = -ENOMEM;
 		goto put_dev;
+	}
 
 	rds_ibdev->mr_1m_pool =
 		rds_ib_create_mr_pool(rds_ibdev, RDS_IB_MR_1M_POOL);
 	if (IS_ERR(rds_ibdev->mr_1m_pool)) {
+		ret = PTR_ERR(rds_ibdev->mr_1m_pool);
 		rds_ibdev->mr_1m_pool = NULL;
 		goto put_dev;
 	}
@@ -208,6 +214,7 @@ static void rds_ib_add_one(struct ib_device *device)
 	rds_ibdev->mr_8k_pool =
 		rds_ib_create_mr_pool(rds_ibdev, RDS_IB_MR_8K_POOL);
 	if (IS_ERR(rds_ibdev->mr_8k_pool)) {
+		ret = PTR_ERR(rds_ibdev->mr_8k_pool);
 		rds_ibdev->mr_8k_pool = NULL;
 		goto put_dev;
 	}
@@ -227,12 +234,13 @@ static void rds_ib_add_one(struct ib_device *device)
 	refcount_inc(&rds_ibdev->refcount);
 
 	ib_set_client_data(device, &rds_ib_client, rds_ibdev);
-	refcount_inc(&rds_ibdev->refcount);
 
 	rds_ib_nodev_connect();
+	return 0;
 
 put_dev:
 	rds_ib_dev_put(rds_ibdev);
+	return ret;
 }
 
 /*
@@ -274,9 +282,6 @@ static void rds_ib_remove_one(struct ib_device *device, void *client_data)
 {
 	struct rds_ib_device *rds_ibdev = client_data;
 
-	if (!rds_ibdev)
-		return;
-
 	rds_ib_dev_shutdown(rds_ibdev);
 
 	/* stop connection attempts from getting a reference to this device. */
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index e7e7c3c6e94a..2fad5f3fe093 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -547,18 +547,18 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 static struct ib_client smc_ib_client;
 
 /* callback function for ib_register_client() */
-static void smc_ib_add_dev(struct ib_device *ibdev)
+static int smc_ib_add_dev(struct ib_device *ibdev)
 {
 	struct smc_ib_device *smcibdev;
 	u8 port_cnt;
 	int i;
 
 	if (ibdev->node_type != RDMA_NODE_IB_CA)
-		return;
+		return -EOPNOTSUPP;
 
 	smcibdev = kzalloc(sizeof(*smcibdev), GFP_KERNEL);
 	if (!smcibdev)
-		return;
+		return -ENOMEM;
 
 	smcibdev->ibdev = ibdev;
 	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
@@ -583,6 +583,7 @@ static void smc_ib_add_dev(struct ib_device *ibdev)
 				       smcibdev->pnetid[i]);
 	}
 	schedule_work(&smcibdev->port_event_work);
+	return 0;
 }
 
 /* callback function for ib_unregister_client() */
@@ -590,9 +591,6 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 {
 	struct smc_ib_device *smcibdev = client_data;
 
-	if (!smcibdev || smcibdev->ibdev != ibdev)
-		return;
-	ib_set_client_data(ibdev, &smc_ib_client, NULL);
 	spin_lock(&smc_ib_devices.lock);
 	list_del_init(&smcibdev->list); /* remove from smc_ib_devices */
 	spin_unlock(&smc_ib_devices.lock);
-- 
2.25.2

