Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3483E414F1D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhIVRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:32:24 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:33551 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbhIVRcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:32:22 -0400
X-Greylist: delayed 2687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 13:32:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=Dg1gjIRekS8zgEvTByPnswl6ttfsf5eNF+Ja+K6B/K4=; b=B70xc
        uz9FsxzNWTVlK0LqahSpPkrSpaIVnDtzCLAqdxK11Yay5C42weL1/WPTVnEeseH45GHOpjBPm5XUm
        UHLlX2GoMGIbSTchqd++dnpyaFByccQt8bYIs+tmqFWKPfIh0zeJoLSM9GZAR2YoP/Xf2tHOATPK+
        znZwDGcgwBo4BWxyCwEyrZUXdfJ3LRfCAt2ICWDIigoNtb+UyRLVKzDpcTEHnDP+kgDM8I9jezhxq
        Gx4JzCxMR2rgWMXkBqTGOsYE/65RIsjSCUWVqMnfF4e8Z0a3RDH1dNAFZL5yOO5Y8sE9ih2IB8ofY
        s10h6YlbIn2z3P1QbOj/2CrNrhiAA==;
Message-Id: <36abf4c1ed348b1ef8ed38655f875942e0103d7f.1632327421.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632327421.git.linux_oss@crudebyte.com>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Wed, 22 Sep 2021 18:00:24 +0200
Subject: [PATCH v3 2/7] 9p/trans_virtio: separate allocation of scatter gather
 list
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scatter gather list in struct virtio_chan currently
resides as compile-time constant size array directly within the
contiguous struct virtio_chan's memory space.

Separate memory space and allocation of the scatter gather list
from memory space and allocation of struct virtio_chan.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 490a4c900339..1dbe2e921bb8 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -77,7 +77,7 @@ struct virtio_chan {
 	 */
 	unsigned long p9_max_pages;
 	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[VIRTQUEUE_NUM];
+	struct scatterlist *sg;
 	/**
 	 * @tag: name to identify a mount null terminated
 	 */
@@ -574,6 +574,14 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 		goto fail;
 	}
 
+	chan->sg = kmalloc_array(VIRTQUEUE_NUM,
+				 sizeof(struct scatterlist), GFP_KERNEL);
+	if (!chan->sg) {
+		pr_err("Failed to allocate virtio 9P channel\n");
+		err = -ENOMEM;
+		goto out_free_chan_shallow;
+	}
+
 	chan->vdev = vdev;
 
 	/* We expect one virtqueue, for requests. */
@@ -635,6 +643,8 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 out_free_vq:
 	vdev->config->del_vqs(vdev);
 out_free_chan:
+	kfree(chan->sg);
+out_free_chan_shallow:
 	kfree(chan);
 fail:
 	return err;
@@ -728,6 +738,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
 	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
+	kfree(chan->sg);
 	kfree(chan);
 
 }
-- 
2.20.1

