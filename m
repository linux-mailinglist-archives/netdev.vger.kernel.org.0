Return-Path: <netdev+bounces-726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B943C6F9515
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F08761C21AE1
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4160A111AA;
	Sat,  6 May 2023 23:30:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C9711189
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1A09020
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+nHcWBThg87r9MWxGBVMEs5l/DzTXNHp2qWU+92EFI=;
	b=IVcdErXw3yih1jKV72QqSz5nkvWiGl4zrg2EIe0F75KDzsuzV/hdbLteg8l2XPbqeBCryA
	Ecd9CEjP5FpLe9+lqWa7DTeAUXHjjjGGqYz2UPBvW0fTGDNBHGRGsfB3dqs67kxDVwcXH3
	2w4OXTTkM7C6uZ/MaILh1kJofFQ/vfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-kFcNSu0DPOi7v81CHisY-A-1; Sat, 06 May 2023 19:29:58 -0400
X-MC-Unique: kFcNSu0DPOi7v81CHisY-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CDDE101A55C;
	Sat,  6 May 2023 23:29:58 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8A7535443;
	Sat,  6 May 2023 23:29:57 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 07/11] iscsi: convert flashnode devices from bus to class
Date: Sat,  6 May 2023 16:29:26 -0700
Message-Id: <20230506232930.195451-8-cleech@redhat.com>
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

The flashnode session and connection devices should be filtered by net
namespace along with the iscsi_host, but we can't do that with a bus
device.  As these don't use any of the bus matching functionality, they
make more sense as a class device anyway.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
 drivers/scsi/scsi_transport_iscsi.c | 36 ++++++++++++-----------------
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 55fe6aca93d0..bc06020565e4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7185,7 +7185,7 @@ static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev, void *data)
 {
 	struct iscsi_bus_flash_session *fnode_sess;
 
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d8b05f3361c8..2fae14aa291e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1081,6 +1081,12 @@ static const struct device_type iscsi_flashnode_sess_dev_type = {
 	.release = iscsi_flashnode_sess_release,
 };
 
+bool iscsi_is_flashnode_session_dev(struct device *dev)
+{
+	return dev->type == &iscsi_flashnode_sess_dev_type;
+}
+EXPORT_SYMBOL_GPL(iscsi_is_flashnode_session_dev);
+
 /* flash node connection attrs show */
 #define iscsi_flashnode_conn_attr_show(type, name, param)		\
 static ssize_t								\
@@ -1267,20 +1273,8 @@ static const struct device_type iscsi_flashnode_conn_dev_type = {
 	.release = iscsi_flashnode_conn_release,
 };
 
-static struct bus_type iscsi_flashnode_bus;
-
-int iscsi_flashnode_bus_match(struct device *dev,
-				     struct device_driver *drv)
-{
-	if (dev->bus == &iscsi_flashnode_bus)
-		return 1;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iscsi_flashnode_bus_match);
-
-static struct bus_type iscsi_flashnode_bus = {
+static struct class iscsi_flashnode_bus = {
 	.name = "iscsi_flashnode",
-	.match = &iscsi_flashnode_bus_match,
 };
 
 /**
@@ -1311,7 +1305,7 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 	fnode_sess->transport = transport;
 	fnode_sess->target_id = index;
 	fnode_sess->dev.type = &iscsi_flashnode_sess_dev_type;
-	fnode_sess->dev.bus = &iscsi_flashnode_bus;
+	fnode_sess->dev.class = &iscsi_flashnode_bus;
 	fnode_sess->dev.parent = &shost->shost_gendev;
 	dev_set_name(&fnode_sess->dev, "flashnode_sess-%u:%u",
 		     shost->host_no, index);
@@ -1359,7 +1353,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	fnode_conn->transport = transport;
 	fnode_conn->dev.type = &iscsi_flashnode_conn_dev_type;
-	fnode_conn->dev.bus = &iscsi_flashnode_bus;
+	fnode_conn->dev.class = &iscsi_flashnode_bus;
 	fnode_conn->dev.parent = &fnode_sess->dev;
 	dev_set_name(&fnode_conn->dev, "flashnode_conn-%u:%u:0",
 		     shost->host_no, fnode_sess->target_id);
@@ -1392,7 +1386,7 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  */
 static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
-	return dev->bus == &iscsi_flashnode_bus;
+	return dev->type == &iscsi_flashnode_conn_dev_type;
 }
 
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
@@ -1406,7 +1400,7 @@ static int flashnode_match_index(struct device *dev, void *data)
 	struct iscsi_bus_flash_session *fnode_sess = NULL;
 	int ret = 0;
 
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		goto exit_match_index;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
@@ -1512,7 +1506,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_flashnode_sess);
 
 static int iscsi_iter_destroy_flashnode_fn(struct device *dev, void *data)
 {
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		return 0;
 
 	iscsi_destroy_flashnode_sess(iscsi_dev_to_flash_session(dev));
@@ -5235,7 +5229,7 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	err = bus_register(&iscsi_flashnode_bus);
+	err = class_register(&iscsi_flashnode_bus);
 	if (err)
 		goto unregister_session_class;
 
@@ -5258,7 +5252,7 @@ static __init int iscsi_transport_init(void)
 unregister_pernet_subsys:
 	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -5278,7 +5272,7 @@ static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
 	unregister_pernet_subsys(&iscsi_net_ops);
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 83bcdd2bcde4..f9d003753f11 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -524,6 +524,8 @@ iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 extern struct device *
 iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
 
+extern bool iscsi_is_flashnode_session_dev(struct device *dev);
+
 extern char *
 iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
 extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
-- 
2.39.2


