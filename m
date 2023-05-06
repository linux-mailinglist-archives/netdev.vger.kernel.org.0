Return-Path: <netdev+bounces-723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D26BB6F9512
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F29D61C21998
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEDE11195;
	Sat,  6 May 2023 23:30:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2B411189
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D89A86BF
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1cVNseZS6i/Rnc9e2Ivy422uws3w9zosipOwCiaRjY=;
	b=hD6bWUw6BH+ioil2QsphG9XtOrH9GVpEqLQvRelHXaUuw8ytQsUnQ+doIF6wckzLBe8nyQ
	H+B/7iufJjoKnD/1jr7mMVohWfUCngbtgn3QT9Nc5BKdYz/LcIo+VWqYjyGWAUeCabdgW4
	eBThWB0fQxj7V0MznL5djyio8GhehS8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-j-USAqdmNsWrKDRjIGrhJg-1; Sat, 06 May 2023 19:29:58 -0400
X-MC-Unique: j-USAqdmNsWrKDRjIGrhJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9430C29ABA00;
	Sat,  6 May 2023 23:29:57 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB9D35443;
	Sat,  6 May 2023 23:29:56 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 06/11] iscsi: set netns for tcp and iser hosts
Date: Sat,  6 May 2023 16:29:25 -0700
Message-Id: <20230506232930.195451-7-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This lets iscsi_tcp and ib_iser operate in multiple namespaces.

The logic to store the network namespace during virtual host creation
(due to the way transport-class object setup callbacks function) is in
libiscsi, and shared between iscsi_tcp and ib_iser.

There are a few changes to do so:

* Distinguish between bound and unbound session creation with different
  transport functions, instead of just checking for a NULL endpoint.

This let's the transport code pass the network namespace into the
unbound session creation of iscsi_tcp, without changing the offloading
drivers which all expect an bound endpoint.

iSER has compatibility checks to work without a bound endpoint, so
expose both transport functions there.

* Split endpoint creation into host-bound and with a specified
  namespace, for iSER's use of endpoint objects + virtual
  host-per-session.

This is much like was done with sessions for iscsi_tcp.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 56 ++++++++++++++------
 drivers/scsi/iscsi_tcp.c                 | 15 +++---
 drivers/scsi/libiscsi.c                  | 16 ++++++
 drivers/scsi/scsi_transport_iscsi.c      | 66 ++++++++++++++++++------
 include/scsi/libiscsi.h                  |  4 ++
 include/scsi/scsi_transport_iscsi.h      | 12 +++++
 6 files changed, 130 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 67b93581034c..077bf9eea19f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -593,20 +593,10 @@ static inline unsigned int iser_dif_prot_caps(int prot_caps)
 	return ret;
 }
 
-/**
- * iscsi_iser_session_create() - create an iscsi-iser session
- * @ep:             iscsi end-point handle
- * @cmds_max:       maximum commands in this session
- * @qdepth:         session command queue depth
- * @initial_cmdsn:  initiator command sequnce number
- *
- * Allocates and adds a scsi host, expose DIF supprot if
- * exists, and sets up an iscsi session.
- */
 static struct iscsi_cls_session *
-iscsi_iser_session_create(struct iscsi_endpoint *ep,
+__iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			  uint16_t cmds_max, uint16_t qdepth,
-			  uint32_t initial_cmdsn)
+			  uint32_t initial_cmdsn, struct net *net)
 {
 	struct iscsi_cls_session *cls_session;
 	struct Scsi_Host *shost;
@@ -656,6 +646,8 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		if (!(ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
 			shost->virt_boundary_mask = SZ_4K - 1;
 
+		iscsi_host_set_netns(shost, ep->netns);
+
 		if (iscsi_host_add(shost, ib_dev->dev.parent)) {
 			mutex_unlock(&iser_conn->state_mutex);
 			goto free_host;
@@ -663,6 +655,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		mutex_unlock(&iser_conn->state_mutex);
 	} else {
 		shost->can_queue = min_t(u16, cmds_max, ISER_DEF_XMIT_CMDS_MAX);
+		iscsi_host_set_netns(shost, net);
 		if (iscsi_host_add(shost, NULL))
 			goto free_host;
 	}
@@ -694,6 +687,34 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	return NULL;
 }
 
+/**
+ * iscsi_iser_session_create() - create an iscsi-iser session
+ * @ep:             iscsi end-point handle
+ * @cmds_max:       maximum commands in this session
+ * @qdepth:         session command queue depth
+ * @initial_cmdsn:  initiator command sequnce number
+ *
+ * Allocates and adds a scsi host, expose DIF support if
+ * exists, and sets up an iscsi session.
+ */
+static struct iscsi_cls_session *
+iscsi_iser_session_create(struct iscsi_endpoint *ep,
+			  uint16_t cmds_max, uint16_t qdepth,
+			  uint32_t initial_cmdsn)
+{
+	return __iscsi_iser_session_create(ep, cmds_max, qdepth,
+					   initial_cmdsn, NULL);
+}
+
+static struct iscsi_cls_session *
+iscsi_iser_session_create_net(struct net *net,
+			      uint16_t cmds_max, uint16_t qdepth,
+			      uint32_t initial_cmdsn)
+{
+	return __iscsi_iser_session_create(NULL, cmds_max, qdepth,
+					   initial_cmdsn, net);
+}
+
 static int iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf, int buflen)
 {
@@ -797,7 +818,7 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
  * Return: iscsi_endpoint created by iscsi layer or ERR_PTR(error)
  *         if fails.
  */
-static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
+static struct iscsi_endpoint *iscsi_iser_ep_connect(struct net *net,
 						    struct sockaddr *dst_addr,
 						    int non_blocking)
 {
@@ -805,7 +826,7 @@ static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
 
-	ep = iscsi_create_endpoint(shost, 0);
+	ep = iscsi_create_endpoint_net(net, 0);
 	if (!ep)
 		return ERR_PTR(-ENOMEM);
 
@@ -983,6 +1004,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.caps                   = CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_TEXT_NEGO,
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
+	.create_session_net	= iscsi_iser_session_create_net,
 	.destroy_session        = iscsi_iser_session_destroy,
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
@@ -1010,9 +1032,11 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 
-	.ep_connect             = iscsi_iser_ep_connect,
+	.ep_connect_net         = iscsi_iser_ep_connect,
 	.ep_poll                = iscsi_iser_ep_poll,
-	.ep_disconnect          = iscsi_iser_ep_disconnect
+	.ep_disconnect          = iscsi_iser_ep_disconnect,
+	/* net namespace */
+	.get_netns		= iscsi_host_get_netns,
 };
 
 static int __init iser_init(void)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9637d4bc2bc9..c401efac0149 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -921,7 +921,7 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 }
 
 static struct iscsi_cls_session *
-iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
+iscsi_sw_tcp_session_create(struct net *net, uint16_t cmds_max,
 			    uint16_t qdepth, uint32_t initial_cmdsn)
 {
 	struct iscsi_cls_session *cls_session;
@@ -930,11 +930,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct Scsi_Host *shost;
 	int rc;
 
-	if (ep) {
-		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
-		return NULL;
-	}
-
 	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht,
 				 sizeof(struct iscsi_sw_tcp_host), 1);
 	if (!shost)
@@ -951,6 +946,9 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto free_host;
 	shost->can_queue = rc;
 
+	tcp_sw_host = iscsi_host_priv(shost);
+	iscsi_host_set_netns(shost, net);
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -967,7 +965,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto remove_session;
 
 	/* We are now fully setup so expose the session to sysfs. */
-	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 	return cls_session;
 
@@ -1098,7 +1095,7 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
 				  | CAP_DATADGST,
 	/* session management */
-	.create_session		= iscsi_sw_tcp_session_create,
+	.create_session_net	= iscsi_sw_tcp_session_create,
 	.destroy_session	= iscsi_sw_tcp_session_destroy,
 	/* connection management */
 	.create_conn		= iscsi_sw_tcp_conn_create,
@@ -1126,6 +1123,8 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.alloc_pdu		= iscsi_sw_tcp_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	/* net namespace */
+	.get_netns		= iscsi_host_get_netns,
 };
 
 static int __init iscsi_sw_tcp_init(void)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0fda8905eabd..9d06beefbdf8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3929,6 +3929,22 @@ int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 }
 EXPORT_SYMBOL_GPL(iscsi_host_set_param);
 
+void iscsi_host_set_netns(struct Scsi_Host *shost, struct net *netns)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	ihost->net_ns = netns;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_set_netns);
+
+struct net *iscsi_host_get_netns(struct Scsi_Host *shost)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	return ihost->net_ns;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_netns);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9db1db669c22..d8b05f3361c8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -191,6 +191,8 @@ static struct net *iscsi_endpoint_net(struct iscsi_endpoint *ep)
 	struct Scsi_Host *shost = iscsi_endpoint_to_shost(ep);
 	struct iscsi_cls_host *ihost;
 
+	if (ep->netns)
+		return ep->netns;
 	if (!shost)
 		return &init_net;
 	ihost = shost->shost_data;
@@ -229,7 +231,7 @@ static struct attribute_group iscsi_endpoint_group = {
 };
 
 struct iscsi_endpoint *
-iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
+__iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
 {
 	struct iscsi_endpoint *ep;
 	int err, id;
@@ -257,6 +259,8 @@ iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 	ep->dev.class = &iscsi_endpoint_class;
 	if (shost)
 		ep->dev.parent = &shost->shost_gendev;
+	if (net)
+		ep->netns = net;
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
@@ -284,8 +288,21 @@ iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 	kfree(ep);
 	return NULL;
 }
+
+struct iscsi_endpoint *
+iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
+{
+	return __iscsi_create_endpoint(shost, dd_size, NULL);
+}
 EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
+struct iscsi_endpoint *
+iscsi_create_endpoint_net(struct net *net, int dd_size)
+{
+	return __iscsi_create_endpoint(NULL, dd_size, net);
+}
+EXPORT_SYMBOL_GPL(iscsi_create_endpoint_net);
+
 void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 {
 	sysfs_remove_group(&ep->dev.kobj, &iscsi_endpoint_group);
@@ -1608,10 +1625,15 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
+	struct iscsi_transport *transport = priv->iscsi_transport;
 
 	memset(ihost, 0, sizeof(*ihost));
 	mutex_init(&ihost->mutex);
-	ihost->netns = &init_net;
+	if (transport->get_netns)
+		ihost->netns = transport->get_netns(shost);
+	else
+		ihost->netns = &init_net;
 
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
@@ -3106,14 +3128,21 @@ static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 			struct iscsi_uevent *ev, pid_t pid,
 			uint32_t initial_cmdsn,	uint16_t cmds_max,
-			uint16_t queue_depth)
+			uint16_t queue_depth, struct net *net)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
 	struct Scsi_Host *shost;
 
-	session = transport->create_session(ep, cmds_max, queue_depth,
-					    initial_cmdsn);
+	if (ep) {
+		session = transport->create_session(ep, cmds_max, queue_depth,
+						    initial_cmdsn);
+	} else {
+		session = transport->create_session_net(net, cmds_max,
+							queue_depth,
+							initial_cmdsn);
+	}
+
 	if (!session)
 		return -ENOMEM;
 
@@ -3231,10 +3260,10 @@ static int iscsi_if_ep_connect(struct net *net,
 	struct Scsi_Host *shost = NULL;
 	int non_blocking, err = 0;
 
-	if (!transport->ep_connect)
-		return -EINVAL;
-
 	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
+		if (!transport->ep_connect)
+			return -EINVAL;
+
 		shost = iscsi_host_lookup(net,
 					ev->u.ep_connect_through_host.host_no);
 		if (!shost) {
@@ -3244,11 +3273,17 @@ static int iscsi_if_ep_connect(struct net *net,
 			return -ENODEV;
 		}
 		non_blocking = ev->u.ep_connect_through_host.non_blocking;
-	} else
+		dst_addr = (struct sockaddr *)((char *)ev + sizeof(*ev));
+		ep = transport->ep_connect(shost, dst_addr, non_blocking);
+	} else {
+		if (!transport->ep_connect_net)
+			return -EINVAL;
+
 		non_blocking = ev->u.ep_connect.non_blocking;
+		dst_addr = (struct sockaddr *)((char *)ev + sizeof(*ev));
+		ep = transport->ep_connect_net(net, dst_addr, non_blocking);
+	}
 
-	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-	ep = transport->ep_connect(shost, dst_addr, non_blocking);
 	if (IS_ERR(ep)) {
 		err = PTR_ERR(ep);
 		goto release_host;
@@ -4028,7 +4063,8 @@ static int iscsi_if_transport_conn(struct net *net,
 		if (!ev->r.retcode)
 			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
 
-		if (ev->r.retcode || !transport->ep_connect)
+		if (ev->r.retcode || (!transport->ep_connect &&
+				      !transport->ep_connect_net))
 			break;
 
 		ep = iscsi_lookup_endpoint(net, ev->u.b_conn.transport_eph);
@@ -4106,7 +4142,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					      portid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
-					      ev->u.c_session.queue_depth);
+					      ev->u.c_session.queue_depth, net);
 		break;
 	/* MARK */
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
@@ -4121,7 +4157,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					portid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
-					ev->u.c_bound_session.queue_depth);
+					ev->u.c_bound_session.queue_depth, net);
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
@@ -4388,7 +4424,7 @@ static ssize_t show_conn_ep_param_##param(struct device *dev,		\
 	 */								\
 	mutex_lock(&conn->ep_mutex);					\
 	ep = conn->ep;							\
-	if (!ep && t->ep_connect) {					\
+	if (!ep && (t->ep_connect || t->ep_connect_net)) {					\
 		mutex_unlock(&conn->ep_mutex);				\
 		return -ENOTCONN;					\
 	}								\
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7282555adfd5..e7d1e6bf3a6d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -383,6 +383,7 @@ struct iscsi_host {
 	int			state;
 
 	struct workqueue_struct	*workq;
+	struct net *net_ns;
 };
 
 /*
@@ -492,6 +493,9 @@ extern void iscsi_pool_free(struct iscsi_pool *);
 extern int iscsi_pool_init(struct iscsi_pool *, int, void ***, int);
 extern int iscsi_switch_str_param(char **, char *);
 
+extern void iscsi_host_set_netns(struct Scsi_Host *, struct net *);
+extern struct net *iscsi_host_get_netns(struct Scsi_Host *);
+
 /*
  * inline functions to deal with padding.
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 5e667c85a469..83bcdd2bcde4 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -35,6 +35,8 @@ struct iscsi_bus_flash_conn;
  * @name:		transport name
  * @caps:		iSCSI Data-Path capabilities
  * @create_session:	create new iSCSI session object
+ * @create_session_net: create new iSCSI session object without a bound host,
+ *			but with a specified net namespace
  * @destroy_session:	destroy existing iSCSI session object
  * @create_conn:	create new iSCSI connection
  * @bind_conn:		associate this connection with existing iSCSI session
@@ -79,6 +81,9 @@ struct iscsi_transport {
 	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
 					uint16_t cmds_max, uint16_t qdepth,
 					uint32_t sn);
+	struct iscsi_cls_session *(*create_session_net) (struct net *net,
+					uint16_t cmds_max, uint16_t qdepth,
+					uint32_t sn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
@@ -122,6 +127,9 @@ struct iscsi_transport {
 	struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
 					      struct sockaddr *dst_addr,
 					      int non_blocking);
+	struct iscsi_endpoint *(*ep_connect_net) (struct net *net,
+					      struct sockaddr *dst_addr,
+					      int non_blocking);
 	int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
 	void (*ep_disconnect) (struct iscsi_endpoint *ep);
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
@@ -156,6 +164,7 @@ struct iscsi_transport {
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
 	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
+	struct net *(*get_netns)(struct Scsi_Host *shost);
 };
 
 /*
@@ -315,6 +324,7 @@ struct iscsi_endpoint {
 	struct device dev;
 	int id;
 	struct iscsi_cls_conn *conn;
+	struct net *netns;		/* used if there's no parent shost */
 };
 
 struct iscsi_iface {
@@ -471,6 +481,8 @@ extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
 extern struct iscsi_endpoint *iscsi_create_endpoint(struct Scsi_Host *shost,
 						    int dd_size);
+extern struct iscsi_endpoint *iscsi_create_endpoint_net(struct net *net,
+						    int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net,
 						    u64 handle);
-- 
2.39.2


