Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA36526252B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIIC0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:26:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:40167 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgIIC0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 22:26:35 -0400
IronPort-SDR: JqoNHJQkrgldhEPYOn1nUJ4GcrlrlXHA87Gh+99MgZQJeQ5wD3derW64pkW5SyxOQ68yyEJyOE
 YC9EHye41B4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="159223259"
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="159223259"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 19:26:34 -0700
IronPort-SDR: GBf2UqYhYYp0JBGU6H3PM87EBjBkQQT77Sf9gref8cx5V8J9in/KyGydAqmqURh8KrQqWMZ3E3
 edzZkUVu5/+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="343745815"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga007.jf.intel.com with ESMTP; 08 Sep 2020 19:26:32 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vhost: new vhost_vdpa SET/GET_BACKEND_FEATURES handlers
Date:   Wed,  9 Sep 2020 10:22:33 +0800
Message-Id: <20200909022233.26559-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduced vhost_vdpa_set/get_backend_features() to
resolve these issues:
(1)In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
would try to acquire vhost dev mutex twice
(first shown in vhost_vdpa_unlocked_ioctl), which can lead
to a dead lock issue.
(2)SET_BACKEND_FEATURES was blindly added to vring ioctl instead
of vdpa device ioctl

To resolve these issues, this commit (1)removed mutex operations
in vhost_set_backend_features. (2)Handle ioctl
SET/GET_BACKEND_FEATURES in vdpa ioctl. (3)introduce a new
function vhost_net_set_backend_features() for vhost_net,
which is a wrap of vhost_set_backend_features() with
necessary mutex lockings.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/net.c   |  9 ++++++++-
 drivers/vhost/vdpa.c  | 47 ++++++++++++++++++++++++++++++-------------
 drivers/vhost/vhost.c |  2 --
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..e01da77538c8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1679,6 +1679,13 @@ static long vhost_net_set_owner(struct vhost_net *n)
 	return r;
 }
 
+static void vhost_net_set_backend_features(struct vhost_dev *dev, u64 features)
+{
+	mutex_lock(&dev->mutex);
+	vhost_set_backend_features(dev, features);
+	mutex_unlock(&dev->mutex);
+}
+
 static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			    unsigned long arg)
 {
@@ -1715,7 +1722,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		if (features & ~VHOST_NET_BACKEND_FEATURES)
 			return -EOPNOTSUPP;
-		vhost_set_backend_features(&n->dev, features);
+		vhost_net_set_backend_features(&n->dev, features);
 		return 0;
 	case VHOST_RESET_OWNER:
 		return vhost_net_reset_owner(n);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f88894..ade33c566a81 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -344,6 +344,33 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	return 0;
 }
 
+
+static long vhost_vdpa_get_backend_features(void __user *argp)
+{
+	u64 features = VHOST_VDPA_BACKEND_FEATURES;
+	u64 __user *featurep = argp;
+	long r;
+
+	r = copy_to_user(featurep, &features, sizeof(features));
+
+	return r;
+}
+static long vhost_vdpa_set_backend_features(struct vhost_vdpa *v, void __user *argp)
+{
+	u64 __user *featurep = argp;
+	u64 features;
+
+	if (copy_from_user(&features, featurep, sizeof(features)))
+		return -EFAULT;
+
+	if (features & ~VHOST_VDPA_BACKEND_FEATURES)
+		return -EOPNOTSUPP;
+
+	vhost_set_backend_features(&v->vdev, features);
+
+	return 0;
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -353,8 +380,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	struct vdpa_callback cb;
 	struct vhost_virtqueue *vq;
 	struct vhost_vring_state s;
-	u64 __user *featurep = argp;
-	u64 features;
 	u32 idx;
 	long r;
 
@@ -381,18 +406,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 		vq->last_avail_idx = vq_state.avail_index;
 		break;
-	case VHOST_GET_BACKEND_FEATURES:
-		features = VHOST_VDPA_BACKEND_FEATURES;
-		if (copy_to_user(featurep, &features, sizeof(features)))
-			return -EFAULT;
-		return 0;
-	case VHOST_SET_BACKEND_FEATURES:
-		if (copy_from_user(&features, featurep, sizeof(features)))
-			return -EFAULT;
-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
-			return -EOPNOTSUPP;
-		vhost_set_backend_features(&v->vdev, features);
-		return 0;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
@@ -476,6 +489,12 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_SET_CONFIG_CALL:
 		r = vhost_vdpa_set_config_call(v, argp);
 		break;
+	case VHOST_SET_BACKEND_FEATURES:
+		r = vhost_vdpa_set_backend_features(v, argp);
+		break;
+	case VHOST_GET_BACKEND_FEATURES:
+		r = vhost_vdpa_get_backend_features(argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..e03c9e6f058f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
 	struct vhost_virtqueue *vq;
 	int i;
 
-	mutex_lock(&dev->mutex);
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		mutex_lock(&vq->mutex);
 		vq->acked_backend_features = features;
 		mutex_unlock(&vq->mutex);
 	}
-	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(vhost_set_backend_features);
 
-- 
2.18.4

