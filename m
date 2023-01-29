Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D74967FDC9
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjA2JNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjA2JNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:13:06 -0500
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 01:13:05 PST
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9E21448C
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:13:04 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id ZCP00152;
        Sun, 29 Jan 2023 17:11:52 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.16; Sun, 29 Jan 2023 17:11:53 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
        <stefanha@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vhost-scsi: convert sysfs snprintf and sprintf to sysfs_emit
Date:   Sun, 29 Jan 2023 04:11:45 -0500
Message-ID: <20230129091145.2837-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20231291711523e15c5864ca3c237e23cf420b0e13c91
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst
and show() should only use sysfs_emit() or sysfs_emit_at()
when formatting the value to be returned to user space.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/vhost/scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dca6346d75b3..5cdfa0bfc075 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2092,7 +2092,7 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 
-	return sprintf(page, "%d\n", tpg->tv_fabric_prot_type);
+	return sysfs_emit(page, "%d\n", tpg->tv_fabric_prot_type);
 }
 
 CONFIGFS_ATTR(vhost_scsi_tpg_attrib_, fabric_prot_type);
@@ -2202,7 +2202,7 @@ static ssize_t vhost_scsi_tpg_nexus_show(struct config_item *item, char *page)
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		return -ENODEV;
 	}
-	ret = snprintf(page, PAGE_SIZE, "%s\n",
+	ret = sysfs_emit(page, "%s\n",
 			tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
@@ -2427,7 +2427,7 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 static ssize_t
 vhost_scsi_wwn_version_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "TCM_VHOST fabric module %s on %s/%s"
+	return sysfs_emit(page, "TCM_VHOST fabric module %s on %s/%s"
 		"on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 }
-- 
2.27.0

