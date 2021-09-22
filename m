Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D002414693
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhIVKkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhIVKke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 476D261242;
        Wed, 22 Sep 2021 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307145;
        bh=BcqOr4/BxckdG0JgeNfJQFTFky8MX/TUfOd14KVupMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NO7+DDQKkUHe7MiF7RQT1bVBXOL2lYpqKp+0Ducw833CAOcSDD17RVIKO1Xlcmhha
         qAK7XZgWeoTr0t3Sw0vnaMW+1qy9SG1EalylI50ryXMVFLn48PfrJIzysTvtIXI3Yd
         edP8Z3l6ZdORIuDJ/c4Ae8J9Bxf7D9w8mZw8Hk3YUteyd76r6z7Q7MIedjHjGI1hZ/
         KLNrcE8hCecIMtLEQYa5EAnj+NFB0Hl6Z7isQQT+2t6HppHdJmrb34STPrgi7Q2JpH
         VxId5zhQyJLVystRl10Avj5WSMlmNPPwywY1/Od0m2dasU3bldr3ownauJ4LQyUoor
         Vn/oZBE7cmBtQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state transition validity
Date:   Wed, 22 Sep 2021 13:38:51 +0300
Message-Id: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Add an API in the core layer to check migration state transition validity
as part of a migration flow.

The valid transitions follow the expected usage as described in
uapi/vfio.h and triggered by QEMU.

This ensures that all migration implementations follow a consistent
migration state machine.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/vfio.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |  1 +
 2 files changed, 42 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3c034fe14ccb..c3ca33e513c8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+/**
+ * vfio_change_migration_state_allowed - Checks whether a migration state
+ *   transition is valid.
+ * @new_state: The new state to move to.
+ * @old_state: The old state.
+ * Return: true if the transition is valid.
+ */
+bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state)
+{
+	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
+	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
+		[VFIO_DEVICE_STATE_STOP] = {
+			[VFIO_DEVICE_STATE_RUNNING] = 1,
+			[VFIO_DEVICE_STATE_RESUMING] = 1,
+		},
+		[VFIO_DEVICE_STATE_RUNNING] = {
+			[VFIO_DEVICE_STATE_STOP] = 1,
+			[VFIO_DEVICE_STATE_SAVING] = 1,
+			[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = 1,
+		},
+		[VFIO_DEVICE_STATE_SAVING] = {
+			[VFIO_DEVICE_STATE_STOP] = 1,
+			[VFIO_DEVICE_STATE_RUNNING] = 1,
+		},
+		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = {
+			[VFIO_DEVICE_STATE_RUNNING] = 1,
+			[VFIO_DEVICE_STATE_SAVING] = 1,
+		},
+		[VFIO_DEVICE_STATE_RESUMING] = {
+			[VFIO_DEVICE_STATE_RUNNING] = 1,
+			[VFIO_DEVICE_STATE_STOP] = 1,
+		},
+	};
+
+	if (new_state > MAX_STATE || old_state > MAX_STATE)
+		return false;
+
+	return vfio_from_state_table[old_state][new_state];
+}
+EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
+
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b53a9557884a..e65137a708f1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -83,6 +83,7 @@ extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
+bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
-- 
2.31.1

