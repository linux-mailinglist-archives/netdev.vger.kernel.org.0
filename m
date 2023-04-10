Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C76B6DCB63
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDJTMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJTL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:11:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0957E1718
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681153876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ingp0g90/6/pJ2ejREIp3ERyxmWHuGCQrWwdDlHfBW0=;
        b=QD6nevNCKxQOhyJACEljfBoM8dt09tOLZrgAwWxeigfPvBbyKWqqdPGbwUwEZtKxdytCyB
        yfqZsuY2i3BOOljF/TDt8y/qkRvvC00pkRGQc2kfBNptTMjR/B88hS3ZBByaA4l+B0sX2T
        KDkIxrEYV6EwkbE0go/kHZOAwD+TRWI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-4hfpA3S2N629Bubp-1eNOA-1; Mon, 10 Apr 2023 15:11:12 -0400
X-MC-Unique: 4hfpA3S2N629Bubp-1eNOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC9F7101A54F;
        Mon, 10 Apr 2023 19:11:11 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B28E40C83AC;
        Mon, 10 Apr 2023 19:11:11 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: [PATCH 10/11] iscsi: make session and connection lists per-net
Date:   Mon, 10 Apr 2023 12:10:32 -0700
Message-Id: <20230410191033.1069293-2-cleech@redhat.com>
In-Reply-To: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the comparisions on list lookups, and it will make it easier
to shut down session on net namespace exit in the next patch.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 104 ++++++++++++++++------------
 1 file changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9a176ea0d866..3a068d8eca2d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1734,17 +1734,16 @@ static DECLARE_TRANSPORT_CLASS_NS(iscsi_connection_class,
 
 struct iscsi_net {
 	struct sock *nls;
+	spinlock_t sesslock;
+	struct list_head sesslist;
+	spinlock_t connlock;
+	struct list_head connlist;
+	struct list_head connlist_err;
 };
 
 static int iscsi_net_id __read_mostly;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-static LIST_HEAD(sesslist);
-static DEFINE_SPINLOCK(sesslock);
-static LIST_HEAD(connlist);
-static LIST_HEAD(connlist_err);
-static DEFINE_SPINLOCK(connlock);
-
 static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
 {
 	struct iscsi_cls_session *sess = iscsi_dev_to_session(conn->dev.parent);
@@ -1759,19 +1758,18 @@ static struct iscsi_cls_session *iscsi_session_lookup(struct net *net,
 {
 	unsigned long flags;
 	struct iscsi_cls_session *sess;
-	struct net *ns;
+	struct iscsi_net *isn;
 
-	spin_lock_irqsave(&sesslock, flags);
-	list_for_each_entry(sess, &sesslist, sess_list) {
+	isn = net_generic(net, iscsi_net_id);
+
+	spin_lock_irqsave(&isn->sesslock, flags);
+	list_for_each_entry(sess, &isn->sesslist, sess_list) {
 		if (sess->sid == sid) {
-			ns = iscsi_sess_net(sess);
-			if (ns != net)
-				continue;
-			spin_unlock_irqrestore(&sesslock, flags);
+			spin_unlock_irqrestore(&isn->sesslock, flags);
 			return sess;
 		}
 	}
-	spin_unlock_irqrestore(&sesslock, flags);
+	spin_unlock_irqrestore(&isn->sesslock, flags);
 	return NULL;
 }
 
@@ -1783,19 +1781,18 @@ static struct iscsi_cls_conn *iscsi_conn_lookup(struct net *net, uint32_t sid,
 {
 	unsigned long flags;
 	struct iscsi_cls_conn *conn;
-	struct net *ns;
+	struct iscsi_net *isn;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_for_each_entry(conn, &connlist, conn_list) {
+	isn = net_generic(net, iscsi_net_id);
+
+	spin_lock_irqsave(&isn->connlock, flags);
+	list_for_each_entry(conn, &isn->connlist, conn_list) {
 		if ((conn->cid == cid) && (iscsi_conn_get_sid(conn) == sid)) {
-			ns = iscsi_conn_net(conn);
-			if (ns != net)
-				continue;
-			spin_unlock_irqrestore(&connlock, flags);
+			spin_unlock_irqrestore(&isn->connlock, flags);
 			return conn;
 		}
 	}
-	spin_unlock_irqrestore(&connlock, flags);
+	spin_unlock_irqrestore(&isn->connlock, flags);
 	return NULL;
 }
 
@@ -2207,6 +2204,9 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct net *net = iscsi_host_net(ihost);
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 	unsigned long flags;
 	int id = 0;
 	int err;
@@ -2250,9 +2250,9 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		goto release_dev;
 	}
 
-	spin_lock_irqsave(&sesslock, flags);
-	list_add(&session->sess_list, &sesslist);
-	spin_unlock_irqrestore(&sesslock, flags);
+	spin_lock_irqsave(&isn->sesslock, flags);
+	list_add(&session->sess_list, &isn->sesslist);
+	spin_unlock_irqrestore(&isn->sesslock, flags);
 
 	iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed session adding\n");
@@ -2322,15 +2322,17 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 
 void iscsi_remove_session(struct iscsi_cls_session *session)
 {
+	struct net *net = iscsi_sess_net(session);
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 	unsigned long flags;
 	int err;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Removing session\n");
 
-	spin_lock_irqsave(&sesslock, flags);
+	spin_lock_irqsave(&isn->sesslock, flags);
 	if (!list_empty(&session->sess_list))
 		list_del(&session->sess_list);
-	spin_unlock_irqrestore(&sesslock, flags);
+	spin_unlock_irqrestore(&isn->sesslock, flags);
 
 	if (!cancel_work_sync(&session->block_work))
 		cancel_delayed_work_sync(&session->recovery_work);
@@ -2541,20 +2543,22 @@ static int iscsi_iter_force_destroy_conn_fn(struct device *dev, void *data)
 void iscsi_force_destroy_session(struct iscsi_cls_session *session)
 {
 	struct iscsi_transport *transport = session->transport;
+	struct net *net = iscsi_sess_net(session);
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 	unsigned long flags;
 
 	WARN_ON_ONCE(system_state == SYSTEM_RUNNING);
 
-	spin_lock_irqsave(&sesslock, flags);
+	spin_lock_irqsave(&isn->sesslock, flags);
 	if (list_empty(&session->sess_list)) {
-		spin_unlock_irqrestore(&sesslock, flags);
+		spin_unlock_irqrestore(&isn->sesslock, flags);
 		/*
 		 * Conn/ep is already freed. Session is being torn down via
 		 * async path. For shutdown we don't care about it so return.
 		 */
 		return;
 	}
-	spin_unlock_irqrestore(&sesslock, flags);
+	spin_unlock_irqrestore(&isn->sesslock, flags);
 
 	device_for_each_child(&session->dev, NULL,
 			      iscsi_iter_force_destroy_conn_fn);
@@ -2625,6 +2629,8 @@ int iscsi_add_conn(struct iscsi_cls_conn *conn)
 	int err;
 	unsigned long flags;
 	struct iscsi_cls_session *session = iscsi_dev_to_session(conn->dev.parent);
+	struct net *net = iscsi_sess_net(session);
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 
 	err = device_add(&conn->dev);
 	if (err) {
@@ -2640,9 +2646,9 @@ int iscsi_add_conn(struct iscsi_cls_conn *conn)
 		return err;
 	}
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list, &connlist);
-	spin_unlock_irqrestore(&connlock, flags);
+	spin_lock_irqsave(&isn->connlock, flags);
+	list_add(&conn->conn_list, &isn->connlist);
+	spin_unlock_irqrestore(&isn->connlock, flags);
 
 	return 0;
 }
@@ -2657,11 +2663,14 @@ EXPORT_SYMBOL_GPL(iscsi_add_conn);
  */
 void iscsi_remove_conn(struct iscsi_cls_conn *conn)
 {
+	struct net *net = iscsi_conn_net(conn);
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
+
 	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
+	spin_lock_irqsave(&isn->connlock, flags);
 	list_del(&conn->conn_list);
-	spin_unlock_irqrestore(&connlock, flags);
+	spin_unlock_irqrestore(&isn->connlock, flags);
 
 	transport_unregister_device(&conn->dev);
 	device_del(&conn->dev);
@@ -3432,20 +3441,21 @@ iscsi_set_path(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_session_has_conns(int sid)
+static int iscsi_session_has_conns(struct net *net, int sid)
 {
+	struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 	struct iscsi_cls_conn *conn;
 	unsigned long flags;
 	int found = 0;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_for_each_entry(conn, &connlist, conn_list) {
+	spin_lock_irqsave(&isn->connlock, flags);
+	list_for_each_entry(conn, &isn->connlist, conn_list) {
 		if (iscsi_conn_get_sid(conn) == sid) {
 			found = 1;
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&connlock, flags);
+	spin_unlock_irqrestore(&isn->connlock, flags);
 
 	return found;
 }
@@ -4157,7 +4167,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
-		else if (iscsi_session_has_conns(ev->u.d_session.sid))
+		else if (iscsi_session_has_conns(net, ev->u.d_session.sid))
 			err = -EBUSY;
 		else
 			transport->destroy_session(session);
@@ -4166,15 +4176,16 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (!session)
 			err = -EINVAL;
-		else if (iscsi_session_has_conns(ev->u.d_session.sid))
+		else if (iscsi_session_has_conns(net, ev->u.d_session.sid))
 			err = -EBUSY;
 		else {
+			struct iscsi_net *isn = net_generic(net, iscsi_net_id);
 			unsigned long flags;
 
 			/* Prevent this session from being found again */
-			spin_lock_irqsave(&sesslock, flags);
+			spin_lock_irqsave(&isn->sesslock, flags);
 			list_del_init(&session->sess_list);
-			spin_unlock_irqrestore(&sesslock, flags);
+			spin_unlock_irqrestore(&isn->sesslock, flags);
 
 			queue_work(system_unbound_wq, &session->destroy_work);
 		}
@@ -5176,6 +5187,13 @@ static int __net_init iscsi_net_init(struct net *net)
 	if (!nls)
 		return -ENOMEM;
 	isn = net_generic(net, iscsi_net_id);
+
+	INIT_LIST_HEAD(&isn->sesslist);
+	spin_lock_init(&isn->sesslock);
+	INIT_LIST_HEAD(&isn->connlist);
+	INIT_LIST_HEAD(&isn->connlist_err);
+	spin_lock_init(&isn->connlock);
+
 	isn->nls = nls;
 	return 0;
 }
-- 
2.39.2

