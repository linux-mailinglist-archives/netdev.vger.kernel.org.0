Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5415427E5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiFHHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354811AbiFHGTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:19:46 -0400
X-Greylist: delayed 94 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 23:16:20 PDT
Received: from ssh249.corpemail.net (ssh249.corpemail.net [210.51.61.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2B01E3E3;
        Tue,  7 Jun 2022 23:16:17 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id CCQ00146;
        Wed, 08 Jun 2022 14:08:46 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2308.27; Wed, 8 Jun 2022 14:08:47 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] virtio: Directly use ida_alloc_range()/ida_free()
Date:   Wed, 8 Jun 2022 02:08:26 -0400
Message-ID: <20220608060826.1681-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   2022608140846640643a74332369a4aa4a55b1bfc3fae
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

Use ida_alloc_range()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove() .

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/vhost/vdpa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 935a1d0ddb97..384049cfca8d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1293,7 +1293,7 @@ static void vhost_vdpa_release_dev(struct device *device)
 	struct vhost_vdpa *v =
 	       container_of(device, struct vhost_vdpa, dev);
 
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
+	ida_free(&vhost_vdpa_ida, v->minor);
 	kfree(v->vqs);
 	kfree(v);
 }
@@ -1316,8 +1316,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	if (!v)
 		return -ENOMEM;
 
-	minor = ida_simple_get(&vhost_vdpa_ida, 0,
-			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
+	minor = ida_alloc_range(&vhost_vdpa_ida, 0, VHOST_VDPA_DEV_MAX - 1, GFP_KERNEL);
 	if (minor < 0) {
 		kfree(v);
 		return minor;
-- 
2.27.0

