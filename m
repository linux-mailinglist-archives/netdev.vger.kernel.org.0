Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB5EA4E5C
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 06:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfIBEYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 00:24:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35680 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729505AbfIBEYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 00:24:51 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Sep 2019 07:24:49 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x824OeRN001225;
        Mon, 2 Sep 2019 07:24:47 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v3 3/5] mdev: Expose mdev alias in sysfs tree
Date:   Sun,  1 Sep 2019 23:24:34 -0500
Message-Id: <20190902042436.23294-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190902042436.23294-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190902042436.23294-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the optional alias for an mdev device as a sysfs attribute.
This way, userspace tools such as udev may make use of the alias, for
example to create a netdevice name for the mdev.

Updated documentation for optional read only sysfs attribute.

Signed-off-by: Parav Pandit <parav@mellanox.com>

---
Changelog:
v2->v3:
 - Merged sysfs documentation patch with sysfs addition
 - Added more description for alias return value
v0->v1:
 - Addressed comments from Cornelia Huck
 - Updated commit description
---
 Documentation/driver-api/vfio-mediated-device.rst |  9 +++++++++
 drivers/vfio/mdev/mdev_sysfs.c                    | 13 +++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..0b7d2bf843b6 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each mdev Device
          |--- remove
          |--- mdev_type {link to its type}
          |--- vendor-specific-attributes [optional]
+         |--- alias
 
 * remove (write only)
 
@@ -281,6 +282,14 @@ Example::
 
 	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
 
+* alias (read only, optional)
+Whenever a parent requested to generate an alias, each mdev device of such
+parent is assigned unique alias by the mdev core.
+This file shows the alias of the mdev device.
+
+Reading file either returns valid alias when assigned or returns error code
+-EOPNOTSUPP when unsupported.
+
 Mediated device Hot plug
 ------------------------
 
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

