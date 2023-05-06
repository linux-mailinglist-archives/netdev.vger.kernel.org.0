Return-Path: <netdev+bounces-721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B02B6F9509
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1686A1C21B89
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511641097D;
	Sat,  6 May 2023 23:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8C110964
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07A259F1
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOHSraviY9mZliuyISn1d0pP58ToTj0Cf77c0+s6vA8=;
	b=cnui0yUsMoKAv+dtbOZZ06hByG0etN3cLfldLiJ3ruKTUTtoWeN6csX9VoAlKzBvm+/eGn
	+Lf+kq3JOv2UALT5PAK6/lF40NXTVDfJS1KMmdCYuWhEbqm666EvY0CFjI7qlJV7JGY5fh
	+gueWIqBUFVuArnTU79f7E/tMfrB0XY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-FTF0SyUxO3OMLl5eyfJ9lg-1; Sat, 06 May 2023 19:29:55 -0400
X-MC-Unique: FTF0SyUxO3OMLl5eyfJ9lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632D4811E7C;
	Sat,  6 May 2023 23:29:55 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0C5F35443;
	Sat,  6 May 2023 23:29:54 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 03/11] iscsi: sysfs filtering by network namespace
Date: Sat,  6 May 2023 16:29:22 -0700
Message-Id: <20230506232930.195451-4-cleech@redhat.com>
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

This makes the iscsi_host, iscsi_session, iscsi_connection, iscsi_iface,
and iscsi_endpoint transport class devices only visible in sysfs under a
matching network namespace.  The network namespace for all of these
objects is tracked in the iscsi_cls_host structure.

Signed-off-by: Lee Duncan <lduncan@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 127 ++++++++++++++++++++++++----
 include/scsi/scsi_transport_iscsi.h |   1 +
 2 files changed, 113 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2f9348178450..814aef6da4a3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -181,9 +181,34 @@ static void iscsi_endpoint_release(struct device *dev)
 	kfree(ep);
 }
 
+static struct net *iscsi_host_net(struct iscsi_cls_host *ihost)
+{
+	return ihost->netns;
+}
+
+static struct net *iscsi_endpoint_net(struct iscsi_endpoint *ep)
+{
+	struct Scsi_Host *shost = iscsi_endpoint_to_shost(ep);
+	struct iscsi_cls_host *ihost;
+
+	if (!shost)
+		return &init_net;
+	ihost = shost->shost_data;
+	return iscsi_host_net(ihost);
+}
+
+static const void *iscsi_endpoint_namespace(const struct device *dev)
+{
+	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+
+	return iscsi_endpoint_net(ep);
+}
+
 static struct class iscsi_endpoint_class = {
 	.name = "iscsi_endpoint",
 	.dev_release = iscsi_endpoint_release,
+	.ns_type = &net_ns_type_operations,
+	.namespace = iscsi_endpoint_namespace,
 };
 
 static ssize_t
@@ -309,10 +334,26 @@ static void iscsi_iface_release(struct device *dev)
 	put_device(parent);
 }
 
+static struct net *iscsi_iface_net(struct iscsi_iface *iface)
+{
+	struct Scsi_Host *shost = iscsi_iface_to_shost(iface);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	return iscsi_host_net(ihost);
+}
+
+static const void *iscsi_iface_namespace(const struct device *dev)
+{
+	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
+
+	return iscsi_iface_net(iface);
+}
 
 static struct class iscsi_iface_class = {
 	.name = "iscsi_iface",
 	.dev_release = iscsi_iface_release,
+	.ns_type = &net_ns_type_operations,
+	.namespace = iscsi_iface_namespace,
 };
 
 #define ISCSI_IFACE_ATTR(_prefix, _name, _mode, _show, _store)	\
@@ -1566,6 +1607,7 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 
 	memset(ihost, 0, sizeof(*ihost));
 	mutex_init(&ihost->mutex);
+	ihost->netns = &init_net;
 
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
@@ -1583,23 +1625,78 @@ static int iscsi_remove_host(struct transport_container *tc,
 	return 0;
 }
 
-static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
-			       "iscsi_host",
-			       iscsi_setup_host,
-			       iscsi_remove_host,
-			       NULL);
+#define DECLARE_TRANSPORT_CLASS_NS(cls, nm, su, rm, cfg, ns, nslookup)	\
+struct transport_class cls = {						\
+	.class = {							\
+		.name = nm,						\
+		.ns_type = ns,						\
+		.namespace = nslookup,					\
+	},								\
+	.setup = su,							\
+	.remove = rm,							\
+	.configure = cfg,						\
+}
 
-static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
-			       "iscsi_session",
-			       NULL,
-			       NULL,
-			       NULL);
+static const void *iscsi_host_namespace(const struct device *dev)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(dev);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	return iscsi_host_net(ihost);
+}
+
+static DECLARE_TRANSPORT_CLASS_NS(iscsi_host_class,
+				  "iscsi_host",
+				  iscsi_setup_host,
+				  iscsi_remove_host,
+				  NULL,
+				  &net_ns_type_operations,
+				  iscsi_host_namespace);
+
+static struct net *iscsi_sess_net(struct iscsi_cls_session *cls_session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	return iscsi_host_net(ihost);
+}
+
+static const void *iscsi_sess_namespace(const struct device *dev)
+{
+	struct iscsi_cls_session *cls_session = transport_class_to_session(dev);
+
+	return iscsi_sess_net(cls_session);
+}
+
+static DECLARE_TRANSPORT_CLASS_NS(iscsi_session_class,
+				  "iscsi_session",
+				  NULL,
+				  NULL,
+				  NULL,
+				  &net_ns_type_operations,
+				  iscsi_sess_namespace);
+
+static struct net *iscsi_conn_net(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_cls_session *cls_session = iscsi_conn_to_session(cls_conn);
+
+	return iscsi_sess_net(cls_session);
+}
+
+static const void *iscsi_conn_namespace(const struct device *dev)
+{
+	struct iscsi_cls_conn *cls_conn = transport_class_to_conn(dev);
+
+	return iscsi_conn_net(cls_conn);
+}
 
-static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
-			       "iscsi_connection",
-			       NULL,
-			       NULL,
-			       NULL);
+static DECLARE_TRANSPORT_CLASS_NS(iscsi_connection_class,
+				  "iscsi_connection",
+				  NULL,
+				  NULL,
+				  NULL,
+				  &net_ns_type_operations,
+				  iscsi_conn_namespace);
 
 struct iscsi_net {
 	struct sock *nls;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8ade6a03f85a..d795e65a1f75 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -299,6 +299,7 @@ struct iscsi_cls_host {
 	struct request_queue *bsg_q;
 	uint32_t port_speed;
 	uint32_t port_state;
+	struct net *netns;
 };
 
 #define iscsi_job_to_shost(_job) \
-- 
2.39.2


