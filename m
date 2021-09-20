Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E019E4122B8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376673AbhITSRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:17:02 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:44745 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376387AbhITSMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:12:12 -0400
X-Greylist: delayed 3422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 14:12:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=Dg1gjIRekS8zgEvTByPnswl6ttfsf5eNF+Ja+K6B/K4=; b=Xspoi
        ysR+Lvejz+Lx/h+WLrGlELxfS7Qu8Z9/bUF5Rlj1Cy386d8b7oQ18UJ6tU/X7b/G7ln/w81icSExX
        qJqMPX39TiS1VxKEpBleMvFyAGrG7nV0Y2FLy5lDUfaLsswdq+NYHI4/TApkG0o29ndxc+PatXMFP
        hJkj2EzybBNW1/7k/e/B0tIKXkOXnkf71l79fL738r/q3Iz1CvyHJG0S3kTmcE3+DvRod7M/9eCxy
        AZdebhHej3fACUTBltcKql6vjh4alz1egXZN12rgpon7YZwvgTY/je1G+xQzc1/bEqd/kpdWU4IUC
        WsuIv4McdXQEVXCCvytTjUdO9+bSg==;
Message-Id: <bda8a68e03830c672141f531de2e35542edc0f8f.1632156835.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Mon, 20 Sep 2021 18:43:46 +0200
Subject: [PATCH v2 2/7] 9p/trans_virtio: separate allocation of scatter gather
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

