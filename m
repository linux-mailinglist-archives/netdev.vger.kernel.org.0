Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C431BC948
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441180AbfIXNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441151AbfIXNyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 09:54:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D05A796ED;
        Tue, 24 Sep 2019 13:54:31 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 220B75B6A5;
        Tue, 24 Sep 2019 13:54:09 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 1/8] vringh: fix copy direction of vringh_iov_push_kern()
Date:   Tue, 24 Sep 2019 21:53:25 +0800
Message-Id: <20190924135332.14160-2-jasowang@redhat.com>
In-Reply-To: <20190924135332.14160-1-jasowang@redhat.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 24 Sep 2019 13:54:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to copy from iov to buf, so the direction was wrong.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vringh.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 08ad0d1f0476..a0a2d74967ef 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, size_t len)
 	return 0;
 }
 
+static inline int kern_xfer(void *dst, void *src, size_t len)
+{
+	memcpy(dst, src, len);
+	return 0;
+}
+
 /**
  * vringh_init_kern - initialize a vringh for a kernelspace vring.
  * @vrh: the vringh to initialize.
@@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
 ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
 			     const void *src, size_t len)
 {
-	return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
+	return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
 }
 EXPORT_SYMBOL(vringh_iov_push_kern);
 
-- 
2.19.1

