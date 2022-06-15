Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF8D54C3C4
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346428AbiFOIle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346459AbiFOIlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:41:13 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013F4A933;
        Wed, 15 Jun 2022 01:41:10 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id KGF00005;
        Wed, 15 Jun 2022 16:41:05 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201602.home.langchao.com (10.100.2.2) with Microsoft SMTP Server id
 15.1.2308.27; Wed, 15 Jun 2022 16:41:06 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vhost-vdpa: Remove usage of the deprecated ida_simple_xxx API
Date:   Wed, 15 Jun 2022 04:40:55 -0400
Message-ID: <20220615084055.4797-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   2022615164105b10b1c60219b480d69d964b77389ea2f
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc_xxx()/ida_free() instead of
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/vhost/vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5ad2596c6e8a..8fc5c0bbb428 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1295,7 +1295,7 @@ static void vhost_vdpa_release_dev(struct device *device)
 	struct vhost_vdpa *v =
 	       container_of(device, struct vhost_vdpa, dev);
 
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
+	ida_free(&vhost_vdpa_ida, v->minor);
 	kfree(v->vqs);
 	kfree(v);
 }
@@ -1318,7 +1318,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	if (!v)
 		return -ENOMEM;
 
-	minor = ida_simple_get(&vhost_vdpa_ida, 0,
+	minor = ida_alloc_max(&vhost_vdpa_ida,
 			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
 	if (minor < 0) {
 		kfree(v);
-- 
2.27.0

