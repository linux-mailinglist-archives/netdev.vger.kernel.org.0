Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5780753036A
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346281AbiEVN7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 09:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244975AbiEVN7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 09:59:07 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7591B3B01A
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 06:59:05 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id sm6onkpsUxzw2sm6oniSvB; Sun, 22 May 2022 15:59:04 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 22 May 2022 15:59:04 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     dan.carpenter@oracle.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost-vdpa: Fix some error handling path in vhost_vdpa_process_iotlb_msg()
Date:   Sun, 22 May 2022 15:59:01 +0200
Message-Id: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error paths introduced by the commit in the Fixes tag, a mutex may
be left locked.
Add the correct goto instead of a direct return.

Fixes: a1468175bb17 ("vhost-vdpa: support ASID based IOTLB API")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
WARNING: This patch only fixes the goto vs return mix-up in this function.
However, the 2nd hunk looks really spurious to me. I think that the:
-		return -EINVAL;
+		r = -EINVAL;
+		goto unlock;
should be done only in the 'if (!iotlb)' block.

As I don't know this code, I just leave it as-is but draw your attention
in case this is another bug lurking.
---
 drivers/vhost/vdpa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1f1d1c425573..3e86080041fc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1000,7 +1000,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		if (!as) {
 			dev_err(&v->dev, "can't find and alloc asid %d\n",
 				asid);
-			return -EINVAL;
+			r = -EINVAL;
+			goto unlock;
 		}
 		iotlb = &as->iotlb;
 	} else
@@ -1013,7 +1014,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		}
 		if (!iotlb)
 			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
-		return -EINVAL;
+		r = -EINVAL;
+		goto unlock;
 	}
 
 	switch (msg->type) {
-- 
2.34.1

