Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580906BAAE
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbfGQKxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731759AbfGQKxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16B80307CDEA;
        Wed, 17 Jul 2019 10:53:51 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266421001B00;
        Wed, 17 Jul 2019 10:53:47 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 09/15] vhost: do not export vhost_add_used_n() and vhost_add_used_and_signal_n()
Date:   Wed, 17 Jul 2019 06:52:49 -0400
Message-Id: <20190717105255.63488-10-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 17 Jul 2019 10:53:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We would request device to use shadow used ring API. Then there's no
need for exposing those to device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 13 +++++++------
 drivers/vhost/vhost.h |  4 ----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5bfca5b76b05..50ba382f0981 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2883,8 +2883,9 @@ EXPORT_SYMBOL_GPL(vhost_get_shadow_used_count);
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
-		     unsigned count)
+static int vhost_add_used_n(struct vhost_virtqueue *vq,
+			    struct vring_used_elem *heads,
+			    unsigned count)
 {
 	int start, n, r;
 
@@ -2988,14 +2989,14 @@ void vhost_add_used_and_signal(struct vhost_dev *dev,
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
 
 /* multi-buffer version of vhost_add_used_and_signal */
-void vhost_add_used_and_signal_n(struct vhost_dev *dev,
-				 struct vhost_virtqueue *vq,
-				 struct vring_used_elem *heads, unsigned count)
+static void vhost_add_used_and_signal_n(struct vhost_dev *dev,
+					struct vhost_virtqueue *vq,
+					struct vring_used_elem *heads,
+					unsigned count)
 {
 	vhost_add_used_n(vq, heads, count);
 	vhost_signal(dev, vq);
 }
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 
 void vhost_flush_shadow_used_and_signal(struct vhost_virtqueue *vq)
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 175eb5ebf954..481baba20c3d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -240,13 +240,9 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
 
 void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
 			       unsigned int id, int len);
-void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
 
 /* Zerocopy shadow used ring API */
 void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
-- 
2.18.1

