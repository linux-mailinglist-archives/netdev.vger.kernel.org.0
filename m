Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C768B10CE0A
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfK1Roi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:44:38 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:51574 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfK1Roi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:44:38 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaNq0-0007Yx-TF; Thu, 28 Nov 2019 17:44:21 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaNpx-000189-2a; Thu, 28 Nov 2019 17:44:18 +0000
From:   anton.ivanov@cambridgegreys.com
To:     linux-um@lists.infradead.org
Cc:     richard@nod.at, dan.carpenter@oracle.com, weiyongjun1@huawei.com,
        kernel-janitors@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kafai@fb.com,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: [PATCH] um: vector: fix BPF loading in vector drivers
Date:   Thu, 28 Nov 2019 17:44:05 +0000
Message-Id: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

This fixes a possible hang in bpf firmware loading in the
UML vector io drivers due to use of GFP_KERNEL while holding
a spinlock.

Based on a prposed fix by weiyongjun1@huawei.com and suggestions for
improving it by dan.carpenter@oracle.com

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
---
 arch/um/drivers/vector_kern.c | 38 ++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 92617e16829e..dbbc6e850fdd 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1387,6 +1387,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 	struct vector_private *vp = netdev_priv(dev);
 	struct vector_device *vdevice;
 	const struct firmware *fw;
+	void *new_filter;
 	int result = 0;
 
 	if (!(vp->options & VECTOR_BPF_FLASH)) {
@@ -1394,6 +1395,15 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 		return -1;
 	}
 
+	vdevice = find_device(vp->unit);
+
+	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
+		return -1;
+
+	new_filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!new_filter)
+		goto free_buffer;
+
 	spin_lock(&vp->lock);
 
 	if (vp->bpf != NULL) {
@@ -1402,41 +1412,33 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 		kfree(vp->bpf->filter);
 		vp->bpf->filter = NULL;
 	} else {
-		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
+		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
 		if (vp->bpf == NULL) {
 			netdev_err(dev, "failed to allocate memory for firmware\n");
-			goto flash_fail;
+			goto apply_flash_fail;
 		}
 	}
 
-	vdevice = find_device(vp->unit);
-
-	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
-		goto flash_fail;
-
-	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
-	if (!vp->bpf->filter)
-		goto free_buffer;
-
+	vp->bpf->filter = new_filter;
 	vp->bpf->len = fw->size / sizeof(struct sock_filter);
-	release_firmware(fw);
 
 	if (vp->opened)
 		result = uml_vector_attach_bpf(vp->fds->rx_fd, vp->bpf);
 
 	spin_unlock(&vp->lock);
 
-	return result;
-
-free_buffer:
 	release_firmware(fw);
 
-flash_fail:
+	return result;
+
+apply_flash_fail:
 	spin_unlock(&vp->lock);
-	if (vp->bpf != NULL)
+	if (vp->bpf)
 		kfree(vp->bpf->filter);
 	kfree(vp->bpf);
-	vp->bpf = NULL;
+
+free_buffer:
+	release_firmware(fw);
 	return -1;
 }
 
-- 
2.20.1

