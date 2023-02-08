Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4168F5DD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBHRoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBHRn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:43:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53707521CA;
        Wed,  8 Feb 2023 09:42:16 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 69DEA341C8;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 2B72F2C146;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 65949CA196; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 9/9] iscsi: filter flashnode sysfs by net namespace
Date:   Wed,  8 Feb 2023 09:40:57 -0800
Message-Id: <283ecc31424b7f5e8e3dd68aa2283fcd109de145.1675876736.git.lduncan@suse.com>
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

This finishes the net namespace support for flashnode sysfs devices.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 34 +++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  4 ----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 13393c025ccb..9a176ea0d866 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1268,8 +1268,42 @@ static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 	return dev->type == &iscsi_flashnode_conn_dev_type;
 }
 
+static struct net *iscsi_flashnode_sess_net(struct iscsi_flash_session *f_sess)
+{
+	struct Scsi_Host *shost = iscsi_flash_session_to_shost(f_sess);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	return iscsi_host_net(ihost);
+}
+
+static struct net *iscsi_flashnode_conn_net(struct iscsi_flash_conn *f_conn)
+{
+	struct iscsi_flash_session *f_sess =
+		iscsi_flash_conn_to_flash_session(f_conn);
+
+	return iscsi_flashnode_sess_net(f_sess);
+}
+
+static const void *iscsi_flashnode_namespace(const struct device *dev)
+{
+	struct iscsi_flash_conn *f_conn;
+	struct iscsi_flash_session *f_sess;
+	struct device *dev_tmp = (struct device *)dev;
+
+	if (iscsi_is_flashnode_conn_dev(dev_tmp, NULL)) {
+		f_conn = iscsi_dev_to_flash_conn(dev);
+		return iscsi_flashnode_conn_net(f_conn);
+	} else if (iscsi_is_flashnode_session_dev(dev_tmp)) {
+		f_sess = iscsi_dev_to_flash_session(dev);
+		return iscsi_flashnode_sess_net(f_sess);
+	}
+	return NULL;
+}
+
 static struct class iscsi_flashnode = {
 	.name = "iscsi_flashnode",
+	.ns_type = &net_ns_type_operations,
+	.namespace = iscsi_flashnode_namespace,
 };
 
 /**
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d03d9eb5707b..0c3fd690ecf8 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -504,8 +504,6 @@ extern void
 iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess);
 
 extern void iscsi_destroy_all_flashnode(struct Scsi_Host *shost);
-extern int iscsi_flashnode_bus_match(struct device *dev,
-				     struct device_driver *drv);
 extern struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data));
@@ -514,8 +512,6 @@ iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess);
 
 extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
-extern bool iscsi_is_flashnode_session_dev(struct device *dev);
-
 extern char *
 iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
 extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
-- 
2.39.1

