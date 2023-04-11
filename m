Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB77B6DCE70
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 02:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjDKAWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 20:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDKAWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 20:22:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7026AB
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 17:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681172518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bDcDagWkuCrxuo8uQDXbQfDAPiEdPaMc5CJpIoULtJY=;
        b=XO9n1I1dNpZ7huuhmymM12VJVwzLzd86tExokMIyp+48TVjeGsKM9oczvsr6WaNPluA87D
        2U7ie+R58qHyNcAvi3sUKkSD7kZnt9YIliG6hIfP+DV381tYw8xd4jA44Y8khk/K5a4J1f
        rRjSM+TMHZEgC5cfA2TPKH8CZP2srQw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-0rOLItsCMYqQDi2ARzIm4Q-1; Mon, 10 Apr 2023 20:21:54 -0400
X-MC-Unique: 0rOLItsCMYqQDi2ARzIm4Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C0A43C02198;
        Tue, 11 Apr 2023 00:21:54 +0000 (UTC)
Received: from localhost (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CEA3492B00;
        Tue, 11 Apr 2023 00:21:53 +0000 (UTC)
Date:   Mon, 10 Apr 2023 17:21:51 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [RFC PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Message-ID: <ZDSoH193jm2jOZKA@localhost>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
 <82eb95ac-2dca-7a7a-116a-2771c4551bab@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82eb95ac-2dca-7a7a-116a-2771c4551bab@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:29:25PM +0100, Hannes Reinecke wrote:
> On 2/8/23 18:40, Lee Duncan wrote:
> > From: Lee Duncan <lduncan@suse.com>
> > 
> > This lets iscsi_tcp operate in multiple namespaces.  It uses current
> > during session creation to find the net namespace, but it might be
> > better to manage to pass it along from the iscsi netlink socket.
> > 
> And indeed, I'd rather use the namespace from the iscsi netlink socket.
> If you use the namespace from session creation you'd better hope that
> this function is not called from a workqueue ...

The cleanest way I see to do this is to split the transport
session_create function between bound and unbound, instead of checking
for a NULL ep.  That should cleanly serperate out the host-per-session
behavior of iscsi_tcp, so we can pass in the namespace without changing
the other drivers.

This is what that looks like on top of the existing patches, but we can
merge it in and rearrange if desired.

- Chris

---

Distinguish between bound and unbound session creation with different
transport functions, instead of just checking for a NULL endpoint.

This let's the transport code pass the network namespace into the
unbound session creation of iscsi_tcp, without changing the offloading
drivers which all expect an bound endpoint.

iSER has compatibility checks to work without a bound endpoint, so
expose both transport functions there.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 41 +++++++++++++++++-------
 drivers/scsi/iscsi_tcp.c                 | 16 ++++-----
 drivers/scsi/iscsi_tcp.h                 |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 17 +++++++---
 include/scsi/scsi_transport_iscsi.h      |  3 ++
 5 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6865f62eb831..ca8de612d585 100644
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
@@ -694,6 +684,32 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	return NULL;
 }
 
+/**
+ * iscsi_iser_session_create() - create an iscsi-iser session
+ * @ep:             iscsi end-point handle
+ * @cmds_max:       maximum commands in this session
+ * @qdepth:         session command queue depth
+ * @initial_cmdsn:  initiator command sequnce number
+ *
+ * Allocates and adds a scsi host, expose DIF supprot if
+ * exists, and sets up an iscsi session.
+ */
+static struct iscsi_cls_session *
+iscsi_iser_session_create(struct iscsi_endpoint *ep,
+			  uint16_t cmds_max, uint16_t qdepth,
+			  uint32_t initial_cmdsn) {
+	return __iscsi_iser_session_create(ep, cmds_max, qdepth,
+					   initial_cmdsn, NULL);
+}
+
+static struct iscsi_cls_session *
+iscsi_iser_unbound_session_create(struct net *net,
+				  uint16_t cmds_max, uint16_t qdepth,
+				  uint32_t initial_cmdsn) {
+	return __iscsi_iser_session_create(NULL, cmds_max, qdepth,
+					   initial_cmdsn, net);
+}
+
 static int iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf, int buflen)
 {
@@ -983,6 +999,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.caps                   = CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_TEXT_NEGO,
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
+	.create_unbound_session = iscsi_iser_unbound_session_create,
 	.destroy_session        = iscsi_iser_session_destroy,
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 171685011ad9..b78239f25073 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -922,7 +922,7 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 }
 
 static struct iscsi_cls_session *
-iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
+iscsi_sw_tcp_session_create(struct net *net, uint16_t cmds_max,
 			    uint16_t qdepth, uint32_t initial_cmdsn)
 {
 	struct iscsi_cls_session *cls_session;
@@ -931,11 +931,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
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
@@ -952,6 +947,9 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto free_host;
 	shost->can_queue = rc;
 
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->net_ns = net;
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -968,7 +966,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto remove_session;
 
 	/* We are now fully setup so expose the session to sysfs. */
-	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 	return cls_session;
 
@@ -1074,7 +1071,8 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 
 static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
 {
-	return current->nsproxy->net_ns;
+	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
+	return tcp_sw_host->net_ns;
 }
 
 static struct scsi_host_template iscsi_sw_tcp_sht = {
@@ -1104,7 +1102,7 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
 				  | CAP_DATADGST,
 	/* session management */
-	.create_session		= iscsi_sw_tcp_session_create,
+	.create_unbound_session	= iscsi_sw_tcp_session_create,
 	.destroy_session	= iscsi_sw_tcp_session_destroy,
 	/* connection management */
 	.create_conn		= iscsi_sw_tcp_conn_create,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 68e14a344904..f0020cb22f59 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -53,6 +53,7 @@ struct iscsi_sw_tcp_conn {
 
 struct iscsi_sw_tcp_host {
 	struct iscsi_session	*session;
+	struct net *net_ns;
 };
 
 struct iscsi_sw_tcp_hdrbuf {
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8fafa8f0e0df..4d346e79468e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3144,14 +3144,21 @@ static int
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
+		session = transport->create_unbound_session(net, cmds_max,
+							    queue_depth,
+							    initial_cmdsn);
+	}
+
 	if (!session)
 		return -ENOMEM;
 
@@ -4145,7 +4152,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					      portid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
-					      ev->u.c_session.queue_depth);
+					      ev->u.c_session.queue_depth, net);
 		break;
 	/* MARK */
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
@@ -4160,7 +4167,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					portid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
-					ev->u.c_bound_session.queue_depth);
+					ev->u.c_bound_session.queue_depth, net);
 		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 0c3fd690ecf8..4d8a3d770bed 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -79,6 +79,9 @@ struct iscsi_transport {
 	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
 					uint16_t cmds_max, uint16_t qdepth,
 					uint32_t sn);
+	struct iscsi_cls_session *(*create_unbound_session) (struct net *net,
+					uint16_t cmds_max, uint16_t qdepth,
+					uint32_t sn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-- 
2.39.2

