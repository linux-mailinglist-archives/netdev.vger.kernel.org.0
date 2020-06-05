Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776601EF567
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgFEKbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:31:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:57119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgFEKbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:31:12 -0400
IronPort-SDR: GOo6mgn05Ut+Haxu37fik7KTadMMY2T1Z2JD5hVuwEUf/SZZHAF/HqST5rlibgOIM6pXU64NOB
 Bu3eM3avf4MA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:31:11 -0700
IronPort-SDR: lm3QYIaVxLSkhqT0pKn9HJj5bMORhCda7mMWueJwGR/cyePta+VX6cPyygJaWvENQdjCfjz3K5
 oRUn1U51sg+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="305024954"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 03:31:09 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 4/5] vhost: replace -1 with VHOST_FILE_UNBIND in iotcls
Date:   Fri,  5 Jun 2020 18:27:14 +0800
Message-Id: <1591352835-22441-5-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
References: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaces -1 with VHOST_FILE_UNBIND in ioctls since
we have added such a macro in the uapi header for vdpa_host.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d450e16..8ba3ed2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1574,7 +1574,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
-		eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
+		eventfp = f.fd == VHOST_FILE_UNBIND ? NULL : eventfd_fget(f.fd);
 		if (IS_ERR(eventfp)) {
 			r = PTR_ERR(eventfp);
 			break;
@@ -1590,7 +1590,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
-		ctx = f.fd == -1 ? NULL : eventfd_ctx_fdget(f.fd);
+		ctx = f.fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(f.fd);
 		if (IS_ERR(ctx)) {
 			r = PTR_ERR(ctx);
 			break;
@@ -1602,7 +1602,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
-		ctx = f.fd == -1 ? NULL : eventfd_ctx_fdget(f.fd);
+		ctx = f.fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(f.fd);
 		if (IS_ERR(ctx)) {
 			r = PTR_ERR(ctx);
 			break;
@@ -1727,7 +1727,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		r = get_user(fd, (int __user *)argp);
 		if (r < 0)
 			break;
-		ctx = fd == -1 ? NULL : eventfd_ctx_fdget(fd);
+		ctx = fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
 		if (IS_ERR(ctx)) {
 			r = PTR_ERR(ctx);
 			break;
-- 
1.8.3.1

