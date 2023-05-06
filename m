Return-Path: <netdev+bounces-724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A87D16F9513
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D3AB281217
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101FD111A3;
	Sat,  6 May 2023 23:30:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08111119E
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CB583DE
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nFLQhY8cGBbhLyL9wzlg+W7GJKGhIUDBw4rUEMsWWk=;
	b=TEOwGhmlvLsL3u9DdDwbO0+vUTzjtuPf7eNeU5W4p3DkW3DFFhJ9yXpnde7KrFj+IjLNZk
	mIqC9Zl/83hU7klRI42BNk2AtOoGoMrNZWYXghqvB+zXQcMefve2873XQuuTjReUi7Z1RY
	0CW/G41vQxPkJFWPyi7B14BL1tG9wks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-_mcz57dfNRq351PtYZus3A-1; Sat, 06 May 2023 19:29:57 -0400
X-MC-Unique: _mcz57dfNRq351PtYZus3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD301185A79C;
	Sat,  6 May 2023 23:29:56 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43A99440BC;
	Sat,  6 May 2023 23:29:56 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 05/11] iscsi: check net namespace for all iscsi lookup
Date: Sat,  6 May 2023 16:29:24 -0700
Message-Id: <20230506232930.195451-6-cleech@redhat.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lee Duncan <lduncan@suse.com>

All internal lookups of iSCSI transport objects need to be filtered by
net namespace.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   5 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   4 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   4 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   4 +-
 drivers/scsi/qedi/qedi_iscsi.c           |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c            |   8 +-
 drivers/scsi/scsi_transport_iscsi.c      | 202 ++++++++++++++---------
 include/scsi/scsi_transport_iscsi.h      |   5 +-
 8 files changed, 149 insertions(+), 87 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index e1085b5fdbb3..67b93581034c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -456,15 +456,18 @@ static int iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
+	struct net *net;
 	int error;
 
 	error = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (error)
 		return error;
 
+
 	/* the transport ep handle comes from user space so it must be
 	 * verified against the global ib connections list */
-	ep = iscsi_lookup_endpoint(transport_eph);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_eph);
 	if (!ep) {
 		iser_err("can't bind eph %llx\n",
 			 (unsigned long long)transport_eph);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index c893d193f5ef..10329ed6a9a8 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -183,8 +183,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
 	int rc = 0;
+	struct net *net;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 169a790950dd..01225ecdc47c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1411,9 +1411,11 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	struct bnx2i_hba *hba = iscsi_host_priv(shost);
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct iscsi_endpoint *ep;
+	struct net *net;
 	int ret_code;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 	/*
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 3620f4f04771..4d910068bab3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2676,9 +2676,11 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	struct iscsi_endpoint *ep;
 	struct cxgbi_endpoint *cep;
 	struct cxgbi_sock *csk;
+	struct net *net;
 	int err;
 
-	ep = iscsi_lookup_endpoint(transport_eph);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_eph);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08e2ebf6a06a..d3e3deba3cae 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -389,8 +389,10 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
 	int rc = 0;
+	struct net *net;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b8e452009cf4..55fe6aca93d0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3217,6 +3217,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	struct ddb_entry *ddb_entry;
 	struct scsi_qla_host *ha;
 	struct iscsi_session *sess;
+	struct net *net;
 
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
@@ -3225,11 +3226,12 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: sid = %d, cid = %d\n", __func__,
 			  cls_session->sid, cls_conn->cid));
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+		return -EINVAL;
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0249c6d889c4..9db1db669c22 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -305,12 +305,16 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
  *
  * Caller must do a iscsi_put_endpoint.
  */
-struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
+struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net, u64 handle)
 {
 	struct iscsi_endpoint *ep;
+	struct net *ns;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
 	ep = idr_find(&iscsi_ep_idr, handle);
+	ns = iscsi_endpoint_net(ep);
+	if (ns != net)
+		ep = NULL;
 	if (!ep)
 		goto unlock;
 
@@ -1653,13 +1657,14 @@ static DECLARE_TRANSPORT_CLASS_NS(iscsi_host_class,
 				  &net_ns_type_operations,
 				  iscsi_host_namespace);
 
-static struct net *iscsi_sess_net(struct iscsi_cls_session *cls_session)
+struct net *iscsi_sess_net(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	return iscsi_host_net(ihost);
 }
+EXPORT_SYMBOL_GPL(iscsi_sess_net);
 
 static const void *iscsi_sess_namespace(const struct device *dev)
 {
@@ -1720,14 +1725,19 @@ static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
 /*
  * Returns the matching session to a given sid
  */
-static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
+static struct iscsi_cls_session *iscsi_session_lookup(struct net *net,
+						      uint32_t sid)
 {
 	unsigned long flags;
 	struct iscsi_cls_session *sess;
+	struct net *ns;
 
 	spin_lock_irqsave(&sesslock, flags);
 	list_for_each_entry(sess, &sesslist, sess_list) {
 		if (sess->sid == sid) {
+			ns = iscsi_sess_net(sess);
+			if (ns != net)
+				continue;
 			spin_unlock_irqrestore(&sesslock, flags);
 			return sess;
 		}
@@ -1739,14 +1749,19 @@ static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
 /*
  * Returns the matching connection to a given sid / cid tuple
  */
-static struct iscsi_cls_conn *iscsi_conn_lookup(uint32_t sid, uint32_t cid)
+static struct iscsi_cls_conn *iscsi_conn_lookup(struct net *net, uint32_t sid,
+						uint32_t cid)
 {
 	unsigned long flags;
 	struct iscsi_cls_conn *conn;
+	struct net *ns;
 
 	spin_lock_irqsave(&connlock, flags);
 	list_for_each_entry(conn, &connlist, conn_list) {
 		if ((conn->cid == cid) && (iscsi_conn_get_sid(conn) == sid)) {
+			ns = iscsi_conn_net(conn);
+			if (ns != net)
+				continue;
 			spin_unlock_irqrestore(&connlock, flags);
 			return conn;
 		}
@@ -2970,7 +2985,7 @@ iscsi_if_get_stats(struct net *net, struct iscsi_transport *transport, struct nl
 	if (!priv)
 		return -EINVAL;
 
-	conn = iscsi_conn_lookup(ev->u.get_stats.sid, ev->u.get_stats.cid);
+	conn = iscsi_conn_lookup(net, ev->u.get_stats.sid, ev->u.get_stats.cid);
 	if (!conn)
 		return -EEXIST;
 
@@ -3112,12 +3127,13 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 }
 
 static int
-iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_create_conn(struct net *net, struct iscsi_transport *transport,
+		     struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
 
-	session = iscsi_session_lookup(ev->u.c_conn.sid);
+	session = iscsi_session_lookup(net, ev->u.c_conn.sid);
 	if (!session) {
 		printk(KERN_ERR "iscsi: invalid session %d.\n",
 		       ev->u.c_conn.sid);
@@ -3139,11 +3155,12 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
-iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_destroy_conn(struct net *net, struct iscsi_transport *transport,
+		      struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
 
-	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
+	conn = iscsi_conn_lookup(net, ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 
@@ -3157,7 +3174,8 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 }
 
 static int
-iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_set_param(struct net *net, struct iscsi_transport *transport,
+		   struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
@@ -3167,8 +3185,8 @@ iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (ev->u.set_param.len > PAGE_SIZE)
 		return -EINVAL;
 
-	session = iscsi_session_lookup(ev->u.set_param.sid);
-	conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
+	session = iscsi_session_lookup(net, ev->u.set_param.sid);
+	conn = iscsi_conn_lookup(net, ev->u.set_param.sid, ev->u.set_param.cid);
 	if (!conn || !session)
 		return -EINVAL;
 
@@ -3191,7 +3209,21 @@ iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	return err;
 }
 
-static int iscsi_if_ep_connect(struct iscsi_transport *transport,
+static struct Scsi_Host *iscsi_host_lookup(struct net *net,
+					   unsigned short hostnum)
+{
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_lookup(hostnum);
+	if (shost && iscsi_host_net(shost->shost_data) != net) {
+		scsi_host_put(shost);
+		shost = NULL;
+	}
+	return shost;
+}
+
+static int iscsi_if_ep_connect(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
@@ -3203,7 +3235,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
-		shost = scsi_host_lookup(ev->u.ep_connect_through_host.host_no);
+		shost = iscsi_host_lookup(net,
+					ev->u.ep_connect_through_host.host_no);
 		if (!shost) {
 			printk(KERN_ERR "ep connect failed. Could not find "
 			       "host no %u\n",
@@ -3228,7 +3261,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
+static int iscsi_if_ep_disconnect(struct net *net,
+				  struct iscsi_transport *transport,
 				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
@@ -3237,7 +3271,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	if (!transport->ep_disconnect)
 		return -EINVAL;
 
-	ep = iscsi_lookup_endpoint(ep_handle);
+	ep = iscsi_lookup_endpoint(net, ep_handle);
 	if (!ep)
 		return -EINVAL;
 
@@ -3260,7 +3294,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_if_transport_ep(struct iscsi_transport *transport,
+iscsi_if_transport_ep(struct net *net, struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
@@ -3269,13 +3303,13 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 	switch (msg_type) {
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
-		rc = iscsi_if_ep_connect(transport, ev, msg_type);
+		rc = iscsi_if_ep_connect(net, transport, ev, msg_type);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 		if (!transport->ep_poll)
 			return -EINVAL;
 
-		ep = iscsi_lookup_endpoint(ev->u.ep_poll.ep_handle);
+		ep = iscsi_lookup_endpoint(net, ev->u.ep_poll.ep_handle);
 		if (!ep)
 			return -EINVAL;
 
@@ -3284,7 +3318,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
-		rc = iscsi_if_ep_disconnect(transport,
+		rc = iscsi_if_ep_disconnect(net, transport,
 					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
@@ -3292,7 +3326,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_tgt_dscvr(struct iscsi_transport *transport,
+iscsi_tgt_dscvr(struct net *net, struct iscsi_transport *transport,
 		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3302,7 +3336,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 	if (!transport->tgt_dscvr)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.tgt_dscvr.host_no);
+	shost = iscsi_host_lookup(net, ev->u.tgt_dscvr.host_no);
 	if (!shost) {
 		printk(KERN_ERR "target discovery could not find host no %u\n",
 		       ev->u.tgt_dscvr.host_no);
@@ -3318,7 +3352,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_host_param(struct iscsi_transport *transport,
+iscsi_set_host_param(struct net *net, struct iscsi_transport *transport,
 		     struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
@@ -3331,7 +3365,7 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 	if (ev->u.set_host_param.len > PAGE_SIZE)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.set_host_param.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_host_param.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_host_param could not find host no %u\n",
 		       ev->u.set_host_param.host_no);
@@ -3345,7 +3379,8 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_set_path(struct net *net, struct iscsi_transport *transport,
+	       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_path *params;
@@ -3354,7 +3389,7 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->set_path)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set path could not find host no %u\n",
 		       ev->u.set_path.host_no);
@@ -3387,7 +3422,7 @@ static int iscsi_session_has_conns(int sid)
 }
 
 static int
-iscsi_set_iface_params(struct iscsi_transport *transport,
+iscsi_set_iface_params(struct net *net, struct iscsi_transport *transport,
 		       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3397,7 +3432,7 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 	if (!transport->set_iface_param)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_iface_params.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_iface_params.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_iface_params could not find host no %u\n",
 		       ev->u.set_iface_params.host_no);
@@ -3410,7 +3445,8 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_send_ping(struct net *net, struct iscsi_transport *transport,
+		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct sockaddr *dst_addr;
@@ -3419,7 +3455,7 @@ iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->send_ping)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.iscsi_ping.host_no);
+	shost = iscsi_host_lookup(net, ev->u.iscsi_ping.host_no);
 	if (!shost) {
 		printk(KERN_ERR "iscsi_ping could not find host no %u\n",
 		       ev->u.iscsi_ping.host_no);
@@ -3461,7 +3497,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	chap_buf_size = (ev->u.get_chap.num_entries * sizeof(*chap_rec));
 	len = nlmsg_total_size(sizeof(*ev) + chap_buf_size);
 
-	shost = scsi_host_lookup(ev->u.get_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_chap.host_no);
@@ -3506,7 +3542,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_set_chap(struct iscsi_transport *transport,
+static int iscsi_set_chap(struct net *net, struct iscsi_transport *transport,
 			  struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3516,7 +3552,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	if (!transport->set_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_path.host_no);
@@ -3528,7 +3564,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_delete_chap(struct iscsi_transport *transport,
+static int iscsi_delete_chap(struct net *net, struct iscsi_transport *transport,
 			     struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3537,7 +3573,7 @@ static int iscsi_delete_chap(struct iscsi_transport *transport,
 	if (!transport->delete_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.delete_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.delete_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s could not find host no %u\n",
 		       __func__, ev->u.delete_chap.host_no);
@@ -3573,7 +3609,8 @@ char *iscsi_get_discovery_parent_name(int parent_type)
 }
 EXPORT_SYMBOL_GPL(iscsi_get_discovery_parent_name);
 
-static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
+static int iscsi_set_flashnode_param(struct net *net,
+				     struct iscsi_transport *transport,
 				     struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3589,7 +3626,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		goto exit_set_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.set_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
@@ -3626,7 +3663,8 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_new_flashnode(struct iscsi_transport *transport,
+static int iscsi_new_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3639,7 +3677,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		goto exit_new_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.new_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.new_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
@@ -3661,7 +3699,8 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_del_flashnode(struct iscsi_transport *transport,
+static int iscsi_del_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3674,7 +3713,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		goto exit_del_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.del_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.del_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
@@ -3701,7 +3740,8 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_login_flashnode(struct iscsi_transport *transport,
+static int iscsi_login_flashnode(struct net *net,
+				 struct iscsi_transport *transport,
 				 struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3716,7 +3756,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		goto exit_login_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.login_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.login_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
@@ -3753,7 +3793,8 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode(struct net *net,
+				  struct iscsi_transport *transport,
 				  struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3768,7 +3809,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		goto exit_logout_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3806,7 +3847,8 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode_sid(struct net *net,
+				      struct iscsi_transport *transport,
 				      struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3818,7 +3860,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto exit_logout_sid;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode_sid.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode_sid.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3826,7 +3868,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
+	session = iscsi_session_lookup(net, ev->u.logout_flashnode_sid.sid);
 	if (!session) {
 		pr_err("%s could not find session id %u\n",
 		       __func__, ev->u.logout_flashnode_sid.sid);
@@ -3867,7 +3909,7 @@ iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
 	host_stats_size = sizeof(struct iscsi_offload_host_stats);
 	len = nlmsg_total_size(sizeof(*ev) + host_stats_size);
 
-	shost = scsi_host_lookup(ev->u.get_host_stats.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_host_stats.host_no);
 	if (!shost) {
 		pr_err("%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_host_stats.host_no);
@@ -3914,7 +3956,8 @@ iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_if_transport_conn(struct iscsi_transport *transport,
+static int iscsi_if_transport_conn(struct net *net,
+				   struct iscsi_transport *transport,
 				   struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
@@ -3926,11 +3969,11 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_CONN:
-		return iscsi_if_create_conn(transport, ev);
+		return iscsi_if_create_conn(net, transport, ev);
 	case ISCSI_UEVENT_DESTROY_CONN:
-		return iscsi_if_destroy_conn(transport, ev);
+		return iscsi_if_destroy_conn(net, transport, ev);
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.sid,
+		conn = iscsi_conn_lookup(net, ev->u.stop_conn.sid,
 					 ev->u.stop_conn.cid);
 		if (!conn)
 			return -EINVAL;
@@ -3947,14 +3990,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	 */
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.sid,
+		conn = iscsi_conn_lookup(net, ev->u.start_conn.sid,
 					 ev->u.start_conn.cid);
 		break;
 	case ISCSI_UEVENT_BIND_CONN:
-		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
+		conn = iscsi_conn_lookup(net, ev->u.b_conn.sid, ev->u.b_conn.cid);
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
-		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
+		conn = iscsi_conn_lookup(net, ev->u.send_pdu.sid, ev->u.send_pdu.cid);
 		break;
 	}
 
@@ -3973,7 +4016,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		session = iscsi_session_lookup(net, ev->u.b_conn.sid);
 		if (!session) {
 			err = -EINVAL;
 			break;
@@ -3988,7 +4031,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
 
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		ep = iscsi_lookup_endpoint(net, ev->u.b_conn.transport_eph);
 		if (ep) {
 			ep->conn = conn;
 			conn->ep = ep;
@@ -4065,8 +4108,10 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
 		break;
+	/* MARK */
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
-		ep = iscsi_lookup_endpoint(ev->u.c_bound_session.ep_handle);
+		ep = iscsi_lookup_endpoint(net,
+					   ev->u.c_bound_session.ep_handle);
 		if (!ep) {
 			err = -EINVAL;
 			break;
@@ -4080,7 +4125,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
 		else if (iscsi_session_has_conns(ev->u.d_session.sid))
@@ -4089,7 +4134,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 			transport->destroy_session(session);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION_ASYNC:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
 		else if (iscsi_session_has_conns(ev->u.d_session.sid))
@@ -4106,14 +4151,14 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (session)
 			queue_work(session->workq, &session->unbind_work);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		err = iscsi_if_set_param(transport, ev);
+		err = iscsi_if_set_param(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
 	case ISCSI_UEVENT_DESTROY_CONN:
@@ -4121,7 +4166,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 	case ISCSI_UEVENT_START_CONN:
 	case ISCSI_UEVENT_BIND_CONN:
 	case ISCSI_UEVENT_SEND_PDU:
-		err = iscsi_if_transport_conn(transport, nlh);
+		err = iscsi_if_transport_conn(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(net, transport, nlh);
@@ -4130,53 +4175,54 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
-		err = iscsi_if_transport_ep(transport, ev, nlh->nlmsg_type);
+		err = iscsi_if_transport_ep(net, transport, ev,
+					    nlh->nlmsg_type);
 		break;
 	case ISCSI_UEVENT_TGT_DSCVR:
-		err = iscsi_tgt_dscvr(transport, ev);
+		err = iscsi_tgt_dscvr(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_HOST_PARAM:
-		err = iscsi_set_host_param(transport, ev);
+		err = iscsi_set_host_param(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_PATH_UPDATE:
-		err = iscsi_set_path(transport, ev);
+		err = iscsi_set_path(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_IFACE_PARAMS:
-		err = iscsi_set_iface_params(transport, ev,
+		err = iscsi_set_iface_params(net, transport, ev,
 					     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_PING:
-		err = iscsi_send_ping(transport, ev);
+		err = iscsi_send_ping(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_GET_CHAP:
 		err = iscsi_get_chap(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_DELETE_CHAP:
-		err = iscsi_delete_chap(transport, ev);
+		err = iscsi_delete_chap(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_FLASHNODE_PARAMS:
-		err = iscsi_set_flashnode_param(transport, ev,
+		err = iscsi_set_flashnode_param(net, transport, ev,
 						nlmsg_attrlen(nlh,
 							      sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_NEW_FLASHNODE:
-		err = iscsi_new_flashnode(transport, ev,
+		err = iscsi_new_flashnode(net, transport, ev,
 					  nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_DEL_FLASHNODE:
-		err = iscsi_del_flashnode(transport, ev);
+		err = iscsi_del_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGIN_FLASHNODE:
-		err = iscsi_login_flashnode(transport, ev);
+		err = iscsi_login_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGOUT_FLASHNODE:
-		err = iscsi_logout_flashnode(transport, ev);
+		err = iscsi_logout_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGOUT_FLASHNODE_SID:
-		err = iscsi_logout_flashnode_sid(transport, ev);
+		err = iscsi_logout_flashnode_sid(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_CHAP:
-		err = iscsi_set_chap(transport, ev,
+		err = iscsi_set_chap(net, transport, ev,
 				     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_GET_HOST_STATS:
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d795e65a1f75..5e667c85a469 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -291,6 +291,8 @@ struct iscsi_cls_session {
 #define iscsi_endpoint_to_shost(_ep) \
 	dev_to_shost(&_ep->dev)
 
+extern struct net *iscsi_sess_net(struct iscsi_cls_session *session);
+
 #define starget_to_session(_stgt) \
 	iscsi_dev_to_session(_stgt->dev.parent)
 
@@ -470,7 +472,8 @@ extern void iscsi_block_session(struct iscsi_cls_session *session);
 extern struct iscsi_endpoint *iscsi_create_endpoint(struct Scsi_Host *shost,
 						    int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
-extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net,
+						    u64 handle);
 extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
-- 
2.39.2


