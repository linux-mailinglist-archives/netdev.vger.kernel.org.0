Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F9168F5D9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjBHRoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBHRnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:43:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ACB518ED;
        Wed,  8 Feb 2023 09:42:14 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 65D811FF10;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 29C222C141;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 4DD64CA192; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 7/9] iscsi: convert flashnode devices from bus to class
Date:   Wed,  8 Feb 2023 09:40:55 -0800
Message-Id: <e4f5405384b984cff51acfc6d36f49f0dd924a3e.1675876735.git.lduncan@suse.com>
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

The flashnode session and connection devices should be filtered by net
namespace along with the iscsi_host, but we can't do that with a bus
device.  As these don't use any of the bus matching functionality, they
make more sense as a class device anyway.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
 drivers/scsi/scsi_transport_iscsi.c | 36 ++++++++++++-----------------
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 390b89bdec8f..18e382b6be18 100644
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
index 008adde4dc51..c065763b1fc6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1060,6 +1060,12 @@ static const struct device_type iscsi_flashnode_sess_dev_type = {
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
@@ -1246,20 +1252,8 @@ static const struct device_type iscsi_flashnode_conn_dev_type = {
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
@@ -1290,7 +1284,7 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 	fnode_sess->transport = transport;
 	fnode_sess->target_id = index;
 	fnode_sess->dev.type = &iscsi_flashnode_sess_dev_type;
-	fnode_sess->dev.bus = &iscsi_flashnode_bus;
+	fnode_sess->dev.class = &iscsi_flashnode_bus;
 	fnode_sess->dev.parent = &shost->shost_gendev;
 	dev_set_name(&fnode_sess->dev, "flashnode_sess-%u:%u",
 		     shost->host_no, index);
@@ -1338,7 +1332,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	fnode_conn->transport = transport;
 	fnode_conn->dev.type = &iscsi_flashnode_conn_dev_type;
-	fnode_conn->dev.bus = &iscsi_flashnode_bus;
+	fnode_conn->dev.class = &iscsi_flashnode_bus;
 	fnode_conn->dev.parent = &fnode_sess->dev;
 	dev_set_name(&fnode_conn->dev, "flashnode_conn-%u:%u:0",
 		     shost->host_no, fnode_sess->target_id);
@@ -1371,7 +1365,7 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  */
 static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
-	return dev->bus == &iscsi_flashnode_bus;
+	return dev->type == &iscsi_flashnode_conn_dev_type;
 }
 
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
@@ -1385,7 +1379,7 @@ static int flashnode_match_index(struct device *dev, void *data)
 	struct iscsi_bus_flash_session *fnode_sess = NULL;
 	int ret = 0;
 
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		goto exit_match_index;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
@@ -1491,7 +1485,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_flashnode_sess);
 
 static int iscsi_iter_destroy_flashnode_fn(struct device *dev, void *data)
 {
-	if (!iscsi_flashnode_bus_match(dev, NULL))
+	if (dev->type != &iscsi_flashnode_sess_dev_type)
 		return 0;
 
 	iscsi_destroy_flashnode_sess(iscsi_dev_to_flash_session(dev));
@@ -5200,7 +5194,7 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	err = bus_register(&iscsi_flashnode_bus);
+	err = class_register(&iscsi_flashnode_bus);
 	if (err)
 		goto unregister_session_class;
 
@@ -5223,7 +5217,7 @@ static __init int iscsi_transport_init(void)
 unregister_pernet_subsys:
 	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -5243,7 +5237,7 @@ static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
 	unregister_pernet_subsys(&iscsi_net_ops);
-	bus_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 9ac1bc133693..580f06d1479b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -512,6 +512,8 @@ iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 extern struct device *
 iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
 
+extern bool iscsi_is_flashnode_session_dev(struct device *dev);
+
 extern char *
 iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
 extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
-- 
2.39.1

