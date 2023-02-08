Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E8968F605
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjBHRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBHRrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:47:11 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A353E5B;
        Wed,  8 Feb 2023 09:46:13 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4CBA21FF2F;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 0D1182C145;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 2C8B2CA18A; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Lee Duncan <lduncan@gmail.com>
Subject: [RFC PATCH 3/9] iscsi: sysfs filtering by network namespace
Date:   Wed,  8 Feb 2023 09:40:51 -0800
Message-Id: <1ce0ef45c40b6873f2889bbcdc1a74d7fc04e370.1675876734.git.lduncan@suse.com>
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

This makes the iscsi_host, iscsi_session, iscsi_connection, iscsi_iface,
and iscsi_endpoint transport class devices only visible in sysfs under a
matching network namespace.  The network namespace for all of these
objects is tracked in the iscsi_cls_host structure.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 124 ++++++++++++++++++++++++----
 include/scsi/scsi_transport_iscsi.h |   1 +
 2 files changed, 110 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 86bafdb862a5..2e2b291bce41 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -181,9 +181,31 @@ static void iscsi_endpoint_release(struct device *dev)
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
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
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
@@ -308,10 +330,26 @@ static void iscsi_iface_release(struct device *dev)
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
@@ -1565,6 +1603,7 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 
 	memset(ihost, 0, sizeof(*ihost));
 	mutex_init(&ihost->mutex);
+	ihost->netns = &init_net;
 
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
@@ -1582,23 +1621,78 @@ static int iscsi_remove_host(struct transport_container *tc,
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
+
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
 
-static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
-			       "iscsi_session",
-			       NULL,
-			       NULL,
-			       NULL);
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
index 268ccaac1c05..af0c5a15f316 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -298,6 +298,7 @@ struct iscsi_cls_host {
 	struct request_queue *bsg_q;
 	uint32_t port_speed;
 	uint32_t port_state;
+	struct net *netns;
 };
 
 #define iscsi_job_to_shost(_job) \
-- 
2.39.1

