Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE59F317
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfH0TRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:17:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38885 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730968AbfH0TRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:17:08 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Aug 2019 22:17:05 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7RJGuGt026842;
        Tue, 27 Aug 2019 22:17:03 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v1 3/5] mdev: Expose mdev alias in sysfs tree
Date:   Tue, 27 Aug 2019 14:16:52 -0500
Message-Id: <20190827191654.41161-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190827191654.41161-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190827191654.41161-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the optional alias for an mdev device as a sysfs attribute.
This way, userspace tools such as udev may make use of the alias, for
example to create a netdevice name for the mdev.

Signed-off-by: Parav Pandit <parav@mellanox.com>

---
Changelog:
v0->v1:
 - Addressed comments from Cornelia Huck
 - Updated commit description
---
 drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 43afe0e80b76..59f4e3cc5233 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -246,7 +246,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_WO(remove);
 
+static ssize_t alias_show(struct device *device,
+			  struct device_attribute *attr, char *buf)
+{
+	struct mdev_device *dev = mdev_from_dev(device);
+
+	if (!dev->alias)
+		return -EOPNOTSUPP;
+
+	return sprintf(buf, "%s\n", dev->alias);
+}
+static DEVICE_ATTR_RO(alias);
+
 static const struct attribute *mdev_device_attrs[] = {
+	&dev_attr_alias.attr,
 	&dev_attr_remove.attr,
 	NULL,
 };
-- 
2.19.2

