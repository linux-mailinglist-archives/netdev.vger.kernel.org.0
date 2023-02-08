Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2BD68F5E8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjBHRpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbjBHRpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:45:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF951EBD4;
        Wed,  8 Feb 2023 09:44:06 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 929601FFDC;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 29F142C142;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 45DB9CA190; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 6/9] iscsi: check net namespace for all iscsi lookup
Date:   Wed,  8 Feb 2023 09:40:54 -0800
Message-Id: <cd46fe01cb5710469ffc4a5282c601382360be7d.1675876735.git.lduncan@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1675876731.git.lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

All internal lookups of iSCSI transport objects need to be filtered by
net namespace.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
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
index d38c909b462f..348bafb55e51 100644
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
index ac63e93e07c6..e889c5585c87 100644
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
index 94edf8e1fb0c..b492b57dbb2a 100644
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
index 4baf1dbb8e92..fc3406e6f82c 100644
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
index acebf9c92c04..390b89bdec8f 100644
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
index 996a9abfa1f5..008adde4dc51 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -301,12 +301,16 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
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
+               ep = NULL;
 	if (!ep)
 		goto unlock;
 
@@ -1654,13 +1658,14 @@ static DECLARE_TRANSPORT_CLASS_NS(iscsi_host_class,
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
@@ -1721,14 +1726,19 @@ static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
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
@@ -1740,14 +1750,19 @@ static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
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
@@ -2971,7 +2986,7 @@ iscsi_if_get_stats(struct net *net, struct iscsi_transport *transport, struct nl
 	if (!priv)
 		return -EINVAL;
 
-	conn = iscsi_conn_lookup(ev->u.get_stats.sid, ev->u.get_stats.cid);
+	conn = iscsi_conn_lookup(net, ev->u.get_stats.sid, ev->u.get_stats.cid);
 	if (!conn)
 		return -EEXIST;
 
@@ -3113,12 +3128,13 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
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
@@ -3140,11 +3156,12 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
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
 
@@ -3158,7 +3175,8 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 }
 
 static int
-iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_set_param(struct net *net, struct iscsi_transport *transport,
+		   struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
@@ -3168,8 +3186,8 @@ iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (ev->u.set_param.len > PAGE_SIZE)
 		return -EINVAL;
 
-	session = iscsi_session_lookup(ev->u.set_param.sid);
-	conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
+	session = iscsi_session_lookup(net, ev->u.set_param.sid);
+	conn = iscsi_conn_lookup(net, ev->u.set_param.sid, ev->u.set_param.cid);
 	if (!conn || !session)
 		return -EINVAL;
 
@@ -3192,7 +3210,21 @@ iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
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
@@ -3204,7 +3236,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
-		shost = scsi_host_lookup(ev->u.ep_connect_through_host.host_no);
+		shost = iscsi_host_lookup(net,
+					ev->u.ep_connect_through_host.host_no);
 		if (!shost) {
 			printk(KERN_ERR "ep connect failed. Could not find "
 			       "host no %u\n",
@@ -3229,7 +3262,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
+static int iscsi_if_ep_disconnect(struct net *net,
+				  struct iscsi_transport *transport,
 				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
@@ -3238,7 +3272,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	if (!transport->ep_disconnect)
 		return -EINVAL;
 
-	ep = iscsi_lookup_endpoint(ep_handle);
+	ep = iscsi_lookup_endpoint(net, ep_handle);
 	if (!ep)
 		return -EINVAL;
 
@@ -3261,7 +3295,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_if_transport_ep(struct iscsi_transport *transport,
+iscsi_if_transport_ep(struct net *net, struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
@@ -3270,13 +3304,13 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
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
 
@@ -3285,7 +3319,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
-		rc = iscsi_if_ep_disconnect(transport,
+		rc = iscsi_if_ep_disconnect(net, transport,
 					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
@@ -3293,7 +3327,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_tgt_dscvr(struct iscsi_transport *transport,
+iscsi_tgt_dscvr(struct net *net, struct iscsi_transport *transport,
 		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3303,7 +3337,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 	if (!transport->tgt_dscvr)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.tgt_dscvr.host_no);
+	shost = iscsi_host_lookup(net, ev->u.tgt_dscvr.host_no);
 	if (!shost) {
 		printk(KERN_ERR "target discovery could not find host no %u\n",
 		       ev->u.tgt_dscvr.host_no);
@@ -3319,7 +3353,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_host_param(struct iscsi_transport *transport,
+iscsi_set_host_param(struct net *net, struct iscsi_transport *transport,
 		     struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
@@ -3332,7 +3366,7 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 	if (ev->u.set_host_param.len > PAGE_SIZE)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.set_host_param.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_host_param.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_host_param could not find host no %u\n",
 		       ev->u.set_host_param.host_no);
@@ -3346,7 +3380,8 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_set_path(struct net *net, struct iscsi_transport *transport,
+	       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_path *params;
@@ -3355,7 +3390,7 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->set_path)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set path could not find host no %u\n",
 		       ev->u.set_path.host_no);
@@ -3388,7 +3423,7 @@ static int iscsi_session_has_conns(int sid)
 }
 
 static int
-iscsi_set_iface_params(struct iscsi_transport *transport,
+iscsi_set_iface_params(struct net *net, struct iscsi_transport *transport,
 		       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3398,7 +3433,7 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 	if (!transport->set_iface_param)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_iface_params.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_iface_params.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_iface_params could not find host no %u\n",
 		       ev->u.set_iface_params.host_no);
@@ -3411,7 +3446,8 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_send_ping(struct net *net, struct iscsi_transport *transport,
+		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct sockaddr *dst_addr;
@@ -3420,7 +3456,7 @@ iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->send_ping)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.iscsi_ping.host_no);
+	shost = iscsi_host_lookup(net, ev->u.iscsi_ping.host_no);
 	if (!shost) {
 		printk(KERN_ERR "iscsi_ping could not find host no %u\n",
 		       ev->u.iscsi_ping.host_no);
@@ -3462,7 +3498,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	chap_buf_size = (ev->u.get_chap.num_entries * sizeof(*chap_rec));
 	len = nlmsg_total_size(sizeof(*ev) + chap_buf_size);
 
-	shost = scsi_host_lookup(ev->u.get_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_chap.host_no);
@@ -3507,7 +3543,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_set_chap(struct iscsi_transport *transport,
+static int iscsi_set_chap(struct net *net, struct iscsi_transport *transport,
 			  struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3517,7 +3553,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	if (!transport->set_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_path.host_no);
@@ -3529,7 +3565,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_delete_chap(struct iscsi_transport *transport,
+static int iscsi_delete_chap(struct net *net, struct iscsi_transport *transport,
 			     struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3538,7 +3574,7 @@ static int iscsi_delete_chap(struct iscsi_transport *transport,
 	if (!transport->delete_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.delete_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.delete_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s could not find host no %u\n",
 		       __func__, ev->u.delete_chap.host_no);
@@ -3574,7 +3610,8 @@ char *iscsi_get_discovery_parent_name(int parent_type)
 }
 EXPORT_SYMBOL_GPL(iscsi_get_discovery_parent_name);
 
-static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
+static int iscsi_set_flashnode_param(struct net *net,
+				     struct iscsi_transport *transport,
 				     struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3590,7 +3627,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		goto exit_set_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.set_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
@@ -3627,7 +3664,8 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_new_flashnode(struct iscsi_transport *transport,
+static int iscsi_new_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3640,7 +3678,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		goto exit_new_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.new_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.new_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
@@ -3662,7 +3700,8 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_del_flashnode(struct iscsi_transport *transport,
+static int iscsi_del_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3675,7 +3714,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		goto exit_del_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.del_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.del_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
@@ -3702,7 +3741,8 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_login_flashnode(struct iscsi_transport *transport,
+static int iscsi_login_flashnode(struct net *net,
+				 struct iscsi_transport *transport,
 				 struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3717,7 +3757,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		goto exit_login_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.login_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.login_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
@@ -3754,7 +3794,8 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode(struct net *net,
+				  struct iscsi_transport *transport,
 				  struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3769,7 +3810,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		goto exit_logout_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3807,7 +3848,8 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode_sid(struct net *net,
+				      struct iscsi_transport *transport,
 				      struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3819,7 +3861,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto exit_logout_sid;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode_sid.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode_sid.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3827,7 +3869,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
+	session = iscsi_session_lookup(net, ev->u.logout_flashnode_sid.sid);
 	if (!session) {
 		pr_err("%s could not find session id %u\n",
 		       __func__, ev->u.logout_flashnode_sid.sid);
@@ -3868,7 +3910,7 @@ iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
 	host_stats_size = sizeof(struct iscsi_offload_host_stats);
 	len = nlmsg_total_size(sizeof(*ev) + host_stats_size);
 
-	shost = scsi_host_lookup(ev->u.get_host_stats.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_host_stats.host_no);
 	if (!shost) {
 		pr_err("%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_host_stats.host_no);
@@ -3915,7 +3957,8 @@ iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_if_transport_conn(struct iscsi_transport *transport,
+static int iscsi_if_transport_conn(struct net *net,
+				   struct iscsi_transport *transport,
 				   struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
@@ -3927,11 +3970,11 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
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
@@ -3948,14 +3991,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
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
 
@@ -3974,7 +4017,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		session = iscsi_session_lookup(net, ev->u.b_conn.sid);
 		if (!session) {
 			err = -EINVAL;
 			break;
@@ -3989,7 +4032,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
 
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		ep = iscsi_lookup_endpoint(net, ev->u.b_conn.transport_eph);
 		if (ep) {
 			ep->conn = conn;
 			conn->ep = ep;
@@ -4066,8 +4109,10 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
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
@@ -4081,7 +4126,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
 		else if (iscsi_session_has_conns(ev->u.d_session.sid))
@@ -4090,7 +4135,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 			transport->destroy_session(session);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION_ASYNC:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
 		else if (iscsi_session_has_conns(ev->u.d_session.sid))
@@ -4107,14 +4152,14 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
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
@@ -4122,7 +4167,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 	case ISCSI_UEVENT_START_CONN:
 	case ISCSI_UEVENT_BIND_CONN:
 	case ISCSI_UEVENT_SEND_PDU:
-		err = iscsi_if_transport_conn(transport, nlh);
+		err = iscsi_if_transport_conn(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(net, transport, nlh);
@@ -4131,53 +4176,54 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
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
index f8885d0c37d8..9ac1bc133693 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -291,6 +291,8 @@ struct iscsi_cls_session {
 #define iscsi_endpoint_to_shost(_ep) \
 	dev_to_shost(_ep->dev.parent)
 
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
2.39.1

