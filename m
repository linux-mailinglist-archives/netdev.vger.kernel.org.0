Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7541B8F7C
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 13:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgDZLqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 07:46:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:11883 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgDZLqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 07:46:48 -0400
IronPort-SDR: 1kmjzcgEZGhXMZ5240bJFIEsZMmNXrEtpKZ5um1F28UhXnZmTXKN58CFJtorsRriwiCbCVTVUK
 hBrFxwq2e/gw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 04:46:48 -0700
IronPort-SDR: SMOXoiLc6kHuQmCO2n6hhlMkAhxQScaMIpQ9oww2q9IyNt0nF9Tapx7GOZJKMp85xZkqoWzTWD
 0fnuec71TfAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,320,1583222400"; 
   d="scan'208";a="275155057"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by orsmga002.jf.intel.com with ESMTP; 26 Apr 2020 04:46:45 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/3] vhost: replace -1 with  VHOST_FILE_UNBIND in iotcls
Date:   Sun, 26 Apr 2020 19:43:25 +0800
Message-Id: <1587901406-27400-3-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587901406-27400-1-git-send-email-lingshan.zhu@intel.com>
References: <1587901406-27400-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaces -1 with VHOST_FILE_UNBIND in ioctls since
we have added such a macro in the uapi header for vdpa_host.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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

