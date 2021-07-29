Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9363D9ED6
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhG2Hid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbhG2HiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:38:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1C1C06121C
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:37:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so14220351pja.5
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZwhAH0F4f+dla5ydIiXHt9Z2ZRDF+Tm2EIsqRAKSvCk=;
        b=ipQQAaLUnIsq/8OzP0aQX0aEbOom8ZuQLMISnXtuDNfa/f/WkdsN6mQcH1+BHcq6Lr
         m+cz3Yheh6sca0j+5gzELbypWQzqwmRB4BmXROIBG/rLiRiOD+HQjf81DqL0PnI0pzpz
         nBn9pywAlNt3+eY0uFVWSsQ9MT6cmowlFaUUZdrkvhk9XTzU9QZU+whCH/G9/B6USPss
         sbK8FYWWU0m1g21U1CR5HC3YL8536es2veDLZ3StqxMvZWp+HjKP5IM4EneyTBqrGoUR
         Fq10u7taiXCjzEBo26fGgS4N6nil6xmWz6ssrQQ3wFPeso7TlROVeo8zeuUv5nSdkb4c
         fI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZwhAH0F4f+dla5ydIiXHt9Z2ZRDF+Tm2EIsqRAKSvCk=;
        b=dgP2cTxnyNSChYSdg/mDTIVjhwD32uy59QjCQR+mNcE2kaQopQjX4m6vRUK6c5yH3d
         CDfFmkwJcw4CvXX0w5UyJ3/CDWHU63nDOmR9dSglftMWmRLAwUEeTXODYEOYXGnzwdIc
         O0MUjLJs8Qa3Ki07XnskOnpOvQJ0kOaCHTOmPZf+q8zSLcmJUOi5X025Aq5fef2VFh2B
         s3MidsUuRqqZxFKfnqIswZQaRe8gNWfiQ5t1Nq8vdNlR+MdBKcKEJt4zDdjYoEePeFFZ
         GnbPc2moGcQfnfI5XQvvuBA1IeLAZUTwUyqbhWCvqg0n4IXDaOqMUZ+EAsmcEJ9LAqso
         rFqw==
X-Gm-Message-State: AOAM531LEe92elZEzzuBVxQ57DX16pMzgw5z3NugovHmCaQiZGi5Z5Gy
        OoUtCqomUDgxorad1xs6q8lf
X-Google-Smtp-Source: ABdhPJzxkbYRwk3u37hmk3GqtET8HODyrHgYpJs+wT1O73nsmpefgxYtxywbKQTN9OUxz9BcTgJc0Q==
X-Received: by 2002:a17:90a:bc4b:: with SMTP id t11mr4035516pjv.139.1627544250679;
        Thu, 29 Jul 2021 00:37:30 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 10sm2410832pjc.41.2021.07.29.00.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:37:30 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 17/17] Documentation: Add documentation for VDUSE
Date:   Thu, 29 Jul 2021 15:35:03 +0800
Message-Id: <20210729073503.187-18-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VDUSE (vDPA Device in Userspace) is a framework to support
implementing software-emulated vDPA devices in userspace. This
document is intended to clarify the VDUSE design and usage.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 Documentation/userspace-api/index.rst |   1 +
 Documentation/userspace-api/vduse.rst | 232 ++++++++++++++++++++++++++++++++++
 2 files changed, 233 insertions(+)
 create mode 100644 Documentation/userspace-api/vduse.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index 0b5eefed027e..c432be070f67 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -27,6 +27,7 @@ place where this information is gathered.
    iommu
    media/index
    sysfs-platform_profile
+   vduse
 
 .. only::  subproject and html
 
diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
new file mode 100644
index 000000000000..30c9d1482126
--- /dev/null
+++ b/Documentation/userspace-api/vduse.rst
@@ -0,0 +1,232 @@
+==================================
+VDUSE - "vDPA Device in Userspace"
+==================================
+
+vDPA (virtio data path acceleration) device is a device that uses a
+datapath which complies with the virtio specifications with vendor
+specific control path. vDPA devices can be both physically located on
+the hardware or emulated by software. VDUSE is a framework that makes it
+possible to implement software-emulated vDPA devices in userspace. And
+to make the device emulation more secure, the emulated vDPA device's
+control path is handled in the kernel and only the data path is
+implemented in the userspace.
+
+Note that only virtio block device is supported by VDUSE framework now,
+which can reduce security risks when the userspace process that implements
+the data path is run by an unprivileged user. The support for other device
+types can be added after the security issue of corresponding device driver
+is clarified or fixed in the future.
+
+Create/Destroy VDUSE devices
+------------------------
+
+VDUSE devices are created as follows:
+
+1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
+   /dev/vduse/control.
+
+2. Setup each virtqueue with ioctl(VDUSE_VQ_SETUP) on /dev/vduse/$NAME.
+
+3. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
+   messages will arrive while attaching the VDUSE instance to vDPA bus.
+
+4. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
+   instance to vDPA bus.
+
+VDUSE devices are destroyed as follows:
+
+1. Send the VDPA_CMD_DEV_DEL netlink message to detach the VDUSE
+   instance from vDPA bus.
+
+2. Close the file descriptor referring to /dev/vduse/$NAME.
+
+3. Destroy the VDUSE instance with ioctl(VDUSE_DESTROY_DEV) on
+   /dev/vduse/control.
+
+The netlink messages can be sent via vdpa tool in iproute2 or use the
+below sample codes:
+
+.. code-block:: c
+
+	static int netlink_add_vduse(const char *name, enum vdpa_command cmd)
+	{
+		struct nl_sock *nlsock;
+		struct nl_msg *msg;
+		int famid;
+
+		nlsock = nl_socket_alloc();
+		if (!nlsock)
+			return -ENOMEM;
+
+		if (genl_connect(nlsock))
+			goto free_sock;
+
+		famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
+		if (famid < 0)
+			goto close_sock;
+
+		msg = nlmsg_alloc();
+		if (!msg)
+			goto close_sock;
+
+		if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0, cmd, 0))
+			goto nla_put_failure;
+
+		NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
+		if (cmd == VDPA_CMD_DEV_NEW)
+			NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
+
+		if (nl_send_sync(nlsock, msg))
+			goto close_sock;
+
+		nl_close(nlsock);
+		nl_socket_free(nlsock);
+
+		return 0;
+	nla_put_failure:
+		nlmsg_free(msg);
+	close_sock:
+		nl_close(nlsock);
+	free_sock:
+		nl_socket_free(nlsock);
+		return -1;
+	}
+
+How VDUSE works
+---------------
+
+As mentioned above, a VDUSE device is created by ioctl(VDUSE_CREATE_DEV) on
+/dev/vduse/control. With this ioctl, userspace can specify some basic configuration
+such as device name (uniquely identify a VDUSE device), virtio features, virtio
+configuration space, the number of virtqueues and so on for this emulated device.
+Then a char device interface (/dev/vduse/$NAME) is exported to userspace for device
+emulation. Userspace can use the VDUSE_VQ_SETUP ioctl on /dev/vduse/$NAME to
+add per-virtqueue configuration such as the max size of virtqueue to the device.
+
+After the initialization, the VDUSE device can be attached to vDPA bus via
+the VDPA_CMD_DEV_NEW netlink message. Userspace needs to read()/write() on
+/dev/vduse/$NAME to receive/reply some control messages from/to VDUSE kernel
+module as follows:
+
+.. code-block:: c
+
+	static int vduse_message_handler(int dev_fd)
+	{
+		int len;
+		struct vduse_dev_request req;
+		struct vduse_dev_response resp;
+
+		len = read(dev_fd, &req, sizeof(req));
+		if (len != sizeof(req))
+			return -1;
+
+		resp.request_id = req.request_id;
+
+		switch (req.type) {
+
+		/* handle different types of messages */
+
+		}
+
+		len = write(dev_fd, &resp, sizeof(resp));
+		if (len != sizeof(resp))
+			return -1;
+
+		return 0;
+	}
+
+There are now three types of messages introduced by VDUSE framework:
+
+- VDUSE_GET_VQ_STATE: Get the state for virtqueue, userspace should return
+  avail index for split virtqueue or the device/driver ring wrap counters and
+  the avail and used index for packed virtqueue.
+
+- VDUSE_SET_STATUS: Set the device status, userspace should follow
+  the virtio spec: https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html
+  to process this message. For example, fail to set the FEATURES_OK device
+  status bit if the device can not accept the negotiated virtio features
+  get from the VDUSE_DEV_GET_FEATURES ioctl.
+
+- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping for specified
+  IOVA range, userspace should firstly remove the old mapping, then setup the new
+  mapping via the VDUSE_IOTLB_GET_FD ioctl.
+
+After DRIVER_OK status bit is set via the VDUSE_SET_STATUS message, userspace is
+able to start the dataplane processing as follows:
+
+1. Get the specified virtqueue's information with the VDUSE_VQ_GET_INFO ioctl,
+   including the size, the IOVAs of descriptor table, available ring and used ring,
+   the state and the ready status.
+
+2. Pass the above IOVAs to the VDUSE_IOTLB_GET_FD ioctl so that those IOVA regions
+   can be mapped into userspace. Some sample codes is shown below:
+
+.. code-block:: c
+
+	static int perm_to_prot(uint8_t perm)
+	{
+		int prot = 0;
+
+		switch (perm) {
+		case VDUSE_ACCESS_WO:
+			prot |= PROT_WRITE;
+			break;
+		case VDUSE_ACCESS_RO:
+			prot |= PROT_READ;
+			break;
+		case VDUSE_ACCESS_RW:
+			prot |= PROT_READ | PROT_WRITE;
+			break;
+		}
+
+		return prot;
+	}
+
+	static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
+	{
+		int fd;
+		void *addr;
+		size_t size;
+		struct vduse_iotlb_entry entry;
+
+		entry.start = iova;
+		entry.last = iova;
+
+		/*
+		 * Find the first IOVA region that overlaps with the specified
+		 * range [start, last] and return the corresponding file descriptor.
+		 */
+		fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
+		if (fd < 0)
+			return NULL;
+
+		size = entry.last - entry.start + 1;
+		*len = entry.last - iova + 1;
+		addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
+			    fd, entry.offset);
+		close(fd);
+		if (addr == MAP_FAILED)
+			return NULL;
+
+		/*
+		 * Using some data structures such as linked list to store
+		 * the iotlb mapping. The munmap(2) should be called for the
+		 * cached mapping when the corresponding VDUSE_UPDATE_IOTLB
+		 * message is received or the device is reset.
+		 */
+
+		return addr + iova - entry.start;
+	}
+
+3. Setup the kick eventfd for the specified virtqueues with the VDUSE_VQ_SETUP_KICKFD
+   ioctl. The kick eventfd is used by VDUSE kernel module to notify userspace to
+   consume the available ring.
+
+4. Listen to the kick eventfd and consume the available ring. The buffer described
+   by the descriptors in the descriptor table should be also mapped into userspace
+   via the VDUSE_IOTLB_GET_FD ioctl before accessing.
+
+5. Inject an interrupt for specific virtqueue with the VDUSE_INJECT_VQ_IRQ ioctl
+   after the used ring is filled.
+
+For more details on the uAPI, please see include/uapi/linux/vduse.h.
-- 
2.11.0

