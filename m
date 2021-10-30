Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A747440C4C
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhJ3XRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhJ3XRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C757F60FC1;
        Sat, 30 Oct 2021 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635714;
        bh=lXmoZEI10ZYzf63SDfz0+KRYzfql9ToMZibaBkIA80w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEesD/twuX86V3KNx9WAJtjqcVZWsnTieCiWI1rNmqzV5wFQuNHgZCIk0XQn12n9n
         tT4yu/VPnmfy9qeGboVilB0rsNB4+oHNzJ2dkV1Ym6q4eCO0pm96azc2ZvU4VB9F2R
         q990oySF/0Livj47RbQgknzquC75Y+e8Jl/qU4/ghJXfestS9xSV598+7iBwm4jTxs
         DYKmAm+x6ivd8FVzOx2QoHRgR1rQW6z3TF0X6S7DGqwRGtOwyoqnFnzrhOw32gs9AM
         N3YEl2Ou5us3m4gh/M99yDJT76AV20sKu9lMjM74VclzRRen6/kku9ADyDszghh6uA
         oELXQVFOM1SvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/5] netdevsim: move max vf config to dev
Date:   Sat, 30 Oct 2021 16:15:04 -0700
Message-Id: <20211030231505.2478149-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231505.2478149-1-kuba@kernel.org>
References: <20211030231505.2478149-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

max_vfs is a strange little beast because the file
hangs off of nsim's debugfs, but it configures a field
in the bus device. Move it to dev.c, let's look at it
as if the device driver was imposing VF limit based
on FW info (like pci_sriov_set_totalvfs()).

Again, when moving refactor the function not to hold
the vfs lock pointlessly while parsing the input.
Wrap the access from the read side in READ_ONCE()
to appease concurrency checkers. Do not check if
return value from snprintf() is negative...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       | 75 -------------------------------
 drivers/net/netdevsim/dev.c       | 64 ++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  7 ---
 3 files changed, 64 insertions(+), 82 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index d037600c0f0c..0b41f1625db9 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -57,81 +57,6 @@ static struct device_attribute nsim_bus_dev_numvfs_attr =
 	__ATTR(sriov_numvfs, 0664, nsim_bus_dev_numvfs_show,
 	       nsim_bus_dev_numvfs_store);
 
-ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
-				  char __user *data,
-				  size_t count, loff_t *ppos)
-{
-	struct nsim_dev *nsim_dev = file->private_data;
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	char buf[11];
-	ssize_t len;
-
-	len = snprintf(buf, sizeof(buf), "%u\n", nsim_bus_dev->max_vfs);
-	if (len < 0)
-		return len;
-
-	return simple_read_from_buffer(data, count, ppos, buf, len);
-}
-
-ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
-				   const char __user *data,
-				   size_t count, loff_t *ppos)
-{
-	struct nsim_dev *nsim_dev = file->private_data;
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	struct nsim_vf_config *vfconfigs;
-	ssize_t ret;
-	char buf[10];
-	u32 val;
-
-	if (*ppos != 0)
-		return 0;
-
-	if (count >= sizeof(buf))
-		return -ENOSPC;
-
-	mutex_lock(&nsim_dev->vfs_lock);
-	/* Reject if VFs are configured */
-	if (nsim_bus_dev->num_vfs) {
-		ret = -EBUSY;
-		goto unlock;
-	}
-
-	ret = copy_from_user(buf, data, count);
-	if (ret) {
-		ret = -EFAULT;
-		goto unlock;
-	}
-
-	buf[count] = '\0';
-	ret = kstrtouint(buf, 10, &val);
-	if (ret) {
-		ret = -EIO;
-		goto unlock;
-	}
-
-	/* max_vfs limited by the maximum number of provided port indexes */
-	if (val > NSIM_DEV_VF_PORT_INDEX_MAX - NSIM_DEV_VF_PORT_INDEX_BASE) {
-		ret = -ERANGE;
-		goto unlock;
-	}
-
-	vfconfigs = kcalloc(val, sizeof(struct nsim_vf_config), GFP_KERNEL | __GFP_NOWARN);
-	if (!vfconfigs) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	kfree(nsim_dev->vfconfigs);
-	nsim_dev->vfconfigs = vfconfigs;
-	nsim_bus_dev->max_vfs = val;
-	*ppos += count;
-	ret = count;
-unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
-	return ret;
-}
-
 static ssize_t
 new_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c19f36c9e0a1..040531fe0879 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -227,6 +227,70 @@ static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
 	.owner = THIS_MODULE,
 };
 
+static ssize_t nsim_bus_dev_max_vfs_read(struct file *file, char __user *data,
+					 size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	char buf[11];
+	ssize_t len;
+
+	len = scnprintf(buf, sizeof(buf), "%u\n",
+			READ_ONCE(nsim_dev->nsim_bus_dev->max_vfs));
+
+	return simple_read_from_buffer(data, count, ppos, buf, len);
+}
+
+static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
+					  const char __user *data,
+					  size_t count, loff_t *ppos)
+{
+	struct nsim_vf_config *vfconfigs;
+	struct nsim_dev *nsim_dev;
+	char buf[10];
+	ssize_t ret;
+	u32 val;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count >= sizeof(buf))
+		return -ENOSPC;
+
+	ret = copy_from_user(buf, data, count);
+	if (ret)
+		return -EFAULT;
+	buf[count] = '\0';
+
+	ret = kstrtouint(buf, 10, &val);
+	if (ret)
+		return -EINVAL;
+
+	/* max_vfs limited by the maximum number of provided port indexes */
+	if (val > NSIM_DEV_VF_PORT_INDEX_MAX - NSIM_DEV_VF_PORT_INDEX_BASE)
+		return -ERANGE;
+
+	vfconfigs = kcalloc(val, sizeof(struct nsim_vf_config),
+			    GFP_KERNEL | __GFP_NOWARN);
+	if (!vfconfigs)
+		return -ENOMEM;
+
+	nsim_dev = file->private_data;
+	mutex_lock(&nsim_dev->vfs_lock);
+	/* Reject if VFs are configured */
+	if (nsim_dev_get_vfs(nsim_dev)) {
+		ret = -EBUSY;
+	} else {
+		swap(nsim_dev->vfconfigs, vfconfigs);
+		WRITE_ONCE(nsim_dev->nsim_bus_dev->max_vfs, val);
+		*ppos += count;
+		ret = count;
+	}
+	mutex_unlock(&nsim_dev->vfs_lock);
+
+	kfree(vfconfigs);
+	return ret;
+}
+
 static const struct file_operations nsim_dev_max_vfs_fops = {
 	.open = simple_open,
 	.read = nsim_bus_dev_max_vfs_read,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 8da5f82e5cfc..fd7133407f05 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -317,13 +317,6 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *fib_data);
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 		     enum nsim_resource_id res_id, bool max);
 
-ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
-				  char __user *data,
-				  size_t count, loff_t *ppos);
-ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
-				   const char __user *data,
-				   size_t count, loff_t *ppos);
-
 static inline bool nsim_dev_port_is_pf(struct nsim_dev_port *nsim_dev_port)
 {
 	return nsim_dev_port->port_type == NSIM_DEV_PORT_TYPE_PF;
-- 
2.31.1

