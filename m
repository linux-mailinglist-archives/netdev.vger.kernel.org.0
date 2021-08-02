Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31E13DD540
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhHBMIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhHBMIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:08:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CA7C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 05:08:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e5so19350682pld.6
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 05:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LoWF/YtiATK/JG4AUtLbQvuapyw/zBxv2DS/rYBTtbw=;
        b=LFkGS14hbazgJqhNtrMm1dWpG0XspzvDaIPmxpJ3loBEKFsby4IwhEXhxP5glW5fCN
         dxBlvAPXrcJmZmcWOwOatsaiGrqjqw1w2YNmghgGYcNTVOESZNgrYKe19KTuJgDQqudO
         pD8PtyQH3OpE5+Mn88ovrqQr1NthkxYhIyaPlX8UK4fwBo6U5ZZsykp1HSQBSNLoo1BX
         3JMaDKTrzyaPeflgYFZvXrNATSBFkff5ANpCOnbcX0JrPPnpK5UoGyOH6RH+na5MpVuC
         5a9iDXBvLUCNYbRXk0gQI69b1q/PiB2HvK1lDRvDsqJ1MGvj9ebRPF6VffE0v6Qw0sa4
         UPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LoWF/YtiATK/JG4AUtLbQvuapyw/zBxv2DS/rYBTtbw=;
        b=Or4ODIXRfv4fPqDOUPaJhpBkO7vKQ7qWpby4kbsPLwJGcR7YqjA38Y9FavmHq/HFhA
         fnRvoYqmkCTLMUGm4kLIDGVCsfYthRyElt6X158egWuT/A0oyf7K0QFLmmHlgKQhVnT/
         fxeoPaTt7dR4yZBuVSDzpS/I/j2wwtU4W4nRVnoiGf+VMAYEbr0gVqhgJhj3UZRjW0mF
         5SQLXF1RdXWJKKYZcq9G6HD8dfltp491jlWe5QxLViiOoWDGJzOpHt6EFnsS1NARttT+
         rt9mDmgt7IF6/DDaFjfyi3MStia0mazMKv9vHd1j6Vjb9HoNNLBpMushjJ1jZ4g/fstW
         SRBw==
X-Gm-Message-State: AOAM533ofq1qzMx8PV3Uoa7ktwqgXRROh/XJZpKflltY3pZacWDAVEGa
        yp7c8etkaacx1p/KwIOBhqIMEA==
X-Google-Smtp-Source: ABdhPJzbMFrH8i2QRZAk7grT0cT37daa6hWHXiwZ4OnHFYfUPa4v14ZTdDf4U72EMXtFuJXe8rwGZg==
X-Received: by 2002:a65:568c:: with SMTP id v12mr1759985pgs.88.1627906101044;
        Mon, 02 Aug 2021 05:08:21 -0700 (PDT)
Received: from n248-175-059.byted.org. ([121.30.179.62])
        by smtp.googlemail.com with ESMTPSA id f30sm12874867pgl.48.2021.08.02.05.08.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:08:20 -0700 (PDT)
From:   fuguancheng <fuguancheng@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, andraprs@amazon.com,
        colin.king@canonical.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fuguancheng <fuguancheng@bytedance.com>
Subject: [PATCH 3/4] VSOCK DRIVER: support specifying additional cids for host
Date:   Mon,  2 Aug 2021 20:07:19 +0800
Message-Id: <20210802120720.547894-4-fuguancheng@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210802120720.547894-1-fuguancheng@bytedance.com>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This packet allows the user to specify multiple additional CIDS for host
that can be used to communicate with a guest in the future. The host get
its additional cid through the ioctl call with
request code VHOST_VSOCK_SET_GUEST_CID.

Guest also knows the additional cids for host so that it can check the
received packet to see whether the packet should be received or rejected.

Guest gets host's additional cids from the device config space, so
hypervisors that emulate the device needs to be changed to use this
feature. The data layout of the device config space can be found at
include/uapi/linux/virtio_vsock.h

Signed-off-by: fuguancheng <fuguancheng@bytedance.com>
---
 drivers/vhost/vhost.h             |   5 --
 drivers/vhost/vsock.c             | 134 ++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vhost.h        |   2 +
 include/uapi/linux/virtio_vsock.h |   5 ++
 net/vmw_vsock/virtio_transport.c  |  27 ++++++++
 5 files changed, 161 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 52bd143ccf0c..638bb640d6b4 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -25,11 +25,6 @@ struct vhost_work {
 	unsigned long		flags;
 };
 
-struct multi_cid_message {
-	u32 number_cid;
-	u64 *cid;
-};
-
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 013f8ebf8189..f5d9b9f06ba5 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -39,10 +39,16 @@ enum {
 	VHOST_VSOCK_BACKEND_FEATURES = (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2)
 };
 
+typedef struct vhost_vsock *(*get_vhost_vsock)(u32);
+
 /* Used to track all the vhost_vsock instances on the system. */
 static DEFINE_MUTEX(vhost_vsock_mutex);
 static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 
+/* Used to track all the valid host cids for vhost_vsock in system. */
+static DEFINE_MUTEX(valid_host_mutex);
+static DEFINE_READ_MOSTLY_HASHTABLE(valid_host_hash, 8);
+
 struct vhost_vsock_ref {
 	struct vhost_vsock *vsock;
 	struct hlist_node ref_hash;
@@ -65,12 +71,21 @@ struct vhost_vsock {
 
 	struct vhost_work send_pkt_work;
 	spinlock_t send_pkt_list_lock;
-	struct list_head send_pkt_list;	/* host->guest pending packets */
+	struct list_head send_pkt_list; /* host->guest pending packets */
 
 	atomic_t queued_replies;
 
 	u32 *cids;
 	u32 num_cid;
+
+	/* num_host_cid indicates how many host cids are considered valid for this guest. */
+	/* Additional cids are stored in hostcids. */
+	u32 num_host_cid;
+	u32 *hostcids;
+
+	/* Link to table valid_host_hash, writes use valid_hash_lock. */
+	struct vhost_vsock_ref *valid_cid_list;
+
 	bool seqpacket_allow;
 };
 
@@ -113,7 +128,24 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 	return NULL;
 }
 
-static int check_if_cid_valid(u64 guest_cid, struct vhost_vsock *vsock)
+/* Callers that dereference the return value must hold vhost_vsock_mutex or the
+ * RCU read lock.
+ */
+static struct vhost_vsock *valid_vhost_get(u32 host_cid)
+{
+	struct vhost_vsock_ref *ref;
+	/* Iterate through the hash table to prevent two vhost_vsock use the same host cid. */
+	hash_for_each_possible_rcu(valid_host_hash, ref, ref_hash, host_cid) {
+		u32 other_cid = ref->cid;
+
+		if (other_cid == host_cid)
+			return ref->vsock;
+	}
+
+	return NULL;
+}
+
+static int check_if_cid_valid(u64 guest_cid, struct vhost_vsock *vsock, get_vhost_vsock func)
 {
 	struct vhost_vsock *other;
 
@@ -130,7 +162,7 @@ static int check_if_cid_valid(u64 guest_cid, struct vhost_vsock *vsock)
 		return -EADDRINUSE;
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other = vhost_vsock_get(guest_cid);
+	other = func(guest_cid);
 	if (other) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;
@@ -712,6 +744,10 @@ static void vhost_vsock_free(struct vhost_vsock *vsock)
 		kvfree(vsock->ref_list);
 	if (vsock->cids)
 		kvfree(vsock->cids);
+	if (vsock->valid_cid_list)
+		kvfree(vsock->valid_cid_list);
+	if (vsock->hostcids)
+		kvfree(vsock->hostcids);
 	kvfree(vsock);
 }
 
@@ -738,6 +774,10 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->cids = NULL;
 	vsock->num_cid = 0;
 
+	vsock->valid_cid_list = NULL;
+	vsock->hostcids = NULL;
+	vsock->num_host_cid = 0;
+
 	atomic_set(&vsock->queued_replies, 0);
 
 	vqs[VSOCK_VQ_TX] = &vsock->vqs[VSOCK_VQ_TX];
@@ -808,6 +848,13 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	}
 	mutex_unlock(&vhost_vsock_mutex);
 
+	mutex_lock(&valid_host_mutex);
+	if (vsock->num_host_cid) {
+		for (index = 0; index < vsock->num_host_cid; index++)
+			hash_del_rcu(&vsock->valid_cid_list[index].ref_hash);
+	}
+	mutex_unlock(&valid_host_mutex);
+
 	/* Wait for other CPUs to finish using vsock */
 	synchronize_rcu();
 
@@ -836,14 +883,19 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32 number_cid)
+static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids,
+			       u32 number_cid, u64 __user *hostcids,
+			       u32 number_host_cid)
 {
 	u64 cid;
 	int i, ret;
 
+	/* num_host_cid = 0 is allowed for that
+	 * we can use the default host cid.
+	 */
 	if (number_cid <= 0)
 		return -EINVAL;
-	/* delete the old CIDs. */
+	/* delete the old guest CIDs. */
 	if (vsock->num_cid) {
 		mutex_lock(&vhost_vsock_mutex);
 		for (i = 0; i < vsock->num_cid; i++)
@@ -854,6 +906,19 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32
 		kvfree(vsock->cids);
 		vsock->cids = NULL;
 	}
+
+	/* delete old host CIDS related to this vsock. */
+	if (vsock->num_host_cid) {
+		mutex_lock(&valid_host_mutex);
+		for (i = 0; i < vsock->num_host_cid; i++)
+			hash_del_rcu(&vsock->valid_cid_list[i].ref_hash);
+		mutex_unlock(&valid_host_mutex);
+		kvfree(vsock->valid_cid_list);
+		vsock->valid_cid_list = NULL;
+		kvfree(vsock->hostcids);
+		vsock->valid_cid_list = NULL;
+	}
+
 	vsock->num_cid = number_cid;
 	vsock->cids = kmalloc_array(vsock->num_cid, sizeof(u32),
 				    GFP_KERNEL | __GFP_RETRY_MAYFAIL);
@@ -870,6 +935,22 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32
 		goto out;
 	}
 
+	vsock->num_host_cid = number_host_cid;
+	vsock->hostcids = kmalloc_array(vsock->num_host_cid, sizeof(u32),
+				    GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!vsock->hostcids) {
+		vsock->num_host_cid = 0;
+		ret = -ENOMEM;
+		goto out;
+	}
+	vsock->valid_cid_list = kvmalloc_array(vsock->num_host_cid, sizeof(*vsock->ref_list),
+			       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!vsock->valid_cid_list) {
+		vsock->num_host_cid = 0;
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	for (i = 0; i < number_cid; i++) {
 		if (copy_from_user(&cid, cids + i, sizeof(cid))) {
 			/* record where we failed, to clean up the ref in hash table. */
@@ -877,7 +958,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32
 			ret = -EFAULT;
 			goto out;
 		}
-		ret = check_if_cid_valid(cid, vsock);
+		ret = check_if_cid_valid(cid, vsock, vhost_vsock_get);
 		if (ret) {
 			vsock->num_cid = i;
 			goto out;
@@ -891,6 +972,28 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32
 			     vsock->cids[i]);
 		mutex_unlock(&vhost_vsock_mutex);
 	}
+
+	for (i = 0; i < number_host_cid; i++) {
+		if (copy_from_user(&cid, hostcids + i, sizeof(cid))) {
+			vsock->num_host_cid = i;
+			ret = -EFAULT;
+			goto out;
+		}
+		ret = check_if_cid_valid(cid, vsock, valid_vhost_get);
+		if (ret) {
+			vsock->num_host_cid = i;
+			goto out;
+		}
+
+		vsock->hostcids[i] = (u32)cid;
+		vsock->valid_cid_list[i].cid = vsock->hostcids[i];
+		vsock->valid_cid_list[i].vsock = vsock;
+		mutex_lock(&valid_host_mutex);
+		hash_add_rcu(valid_host_hash,
+		     &vsock->valid_cid_list[i].ref_hash,
+		     vsock->hostcids[i]);
+		mutex_unlock(&valid_host_mutex);
+	}
 	return 0;
 
 out:
@@ -902,13 +1005,27 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32
 		mutex_unlock(&vhost_vsock_mutex);
 		vsock->num_cid = 0;
 	}
+
+	if (vsock->num_host_cid) {
+		mutex_lock(&valid_host_mutex);
+		for (i = 0; i < vsock->num_host_cid; i++)
+			hash_del_rcu(&vsock->valid_cid_list[i].ref_hash);
+		mutex_unlock(&valid_host_mutex);
+		vsock->num_host_cid = 0;
+	}
 	if (vsock->ref_list)
 		kvfree(vsock->ref_list);
 	if (vsock->cids)
 		kvfree(vsock->cids);
+	if (vsock->valid_cid_list)
+		kvfree(vsock->valid_cid_list);
+	if (vsock->hostcids)
+		kvfree(vsock->hostcids);
 	/* Set it to null to prevent double release. */
 	vsock->ref_list = NULL;
 	vsock->cids = NULL;
+	vsock->valid_cid_list = NULL;
+	vsock->hostcids = NULL;
 	return ret;
 }
 
@@ -962,7 +1079,10 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 	case VHOST_VSOCK_SET_GUEST_CID:
 		if (copy_from_user(&cid_message, argp, sizeof(cid_message)))
 			return -EFAULT;
-		return vhost_vsock_set_cid(vsock, cid_message.cid, cid_message.number_cid);
+		return vhost_vsock_set_cid(vsock, cid_message.cid,
+					   cid_message.number_cid,
+					   cid_message.hostcid,
+					   cid_message.number_host_cid);
 	case VHOST_VSOCK_SET_RUNNING:
 		if (copy_from_user(&start, argp, sizeof(start)))
 			return -EFAULT;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index a3ea99f6fc7f..e2639d7ce375 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -22,6 +22,8 @@
 struct multi_cid_message {
 	u32 number_cid;
 	u64 *cid;
+	u32 number_host_cid;
+	u64 *hostcid;
 };
 
 /* ioctls */
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 0afc14446b01..18c54bfdcbf2 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -41,8 +41,13 @@
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
 
+/* For values stored in cids, the first "number_cid" values
+ * are used for guest additional cid.
+ * The last "number_host_cid" values are used for host additional cid.
+ */
 struct virtio_vsock_config {
 	__le32 number_cid;
+	__le32 number_host_cid;
 	__le64 cids[];
 } __attribute__((packed));
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5f256a57d9ae..c552bc60e539 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -67,6 +67,9 @@ struct virtio_vsock {
 	u32 number_cid;
 	u32 *cids;
 
+	u32 number_host_cid;
+	u32 *host_cids;
+
 	bool seqpacket_allow;
 };
 
@@ -400,11 +403,16 @@ static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
 	struct virtio_device *vdev = vsock->vdev;
 	__le64 guest_cid;
 	__le32 number_cid;
+	__le64 host_cid;
+	__le32 number_host_cid;
 	u32 index;
 
 	vdev->config->get(vdev, offsetof(struct virtio_vsock_config, number_cid),
 			  &number_cid, sizeof(number_cid));
+	vdev->config->get(vdev, offsetof(struct virtio_vsock_config, number_host_cid),
+			  &number_host_cid, sizeof(number_host_cid));
 	vsock->number_cid = le32_to_cpu(number_cid);
+	vsock->number_host_cid = le32_to_cpu(number_host_cid);
 
 	/* number_cid must be greater than 0 in the config space
 	 * to use this feature.
@@ -419,6 +427,16 @@ static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
 		}
 	}
 
+	if (vsock->number_host_cid > 0) {
+		vsock->host_cids = kmalloc_array(vsock->number_host_cid, sizeof(u32), GFP_KERNEL);
+		if (!vsock->host_cids) {
+			/* Space allocated failed, reset number_cid to 0.
+			 * only use the original guest_cid.
+			 */
+			vsock->number_host_cid = 0;
+		}
+	}
+
 	for (index = 0; index < vsock->number_cid; index++) {
 		vdev->config->get(vdev,
 				  offsetof(struct virtio_vsock_config, cids)
@@ -426,6 +444,14 @@ static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
 				  &guest_cid, sizeof(guest_cid));
 		vsock->cids[index] = le64_to_cpu(guest_cid);
 	}
+
+	for (index = index; index < vsock->number_cid + vsock->number_host_cid; index++) {
+		vdev->config->get(vdev,
+				  offsetof(struct virtio_vsock_config, cids)
+				  + index * sizeof(uint64_t),
+				  &host_cid, sizeof(host_cid));
+		vsock->host_cids[index - vsock->number_cid] = le64_to_cpu(host_cid);
+	}
 }
 
 /* event_lock must be held */
@@ -771,6 +797,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	mutex_unlock(&the_virtio_vsock_mutex);
 
 	kfree(vsock->cids);
+	kfree(vsock->host_cids);
 	kfree(vsock);
 }
 
-- 
2.11.0

