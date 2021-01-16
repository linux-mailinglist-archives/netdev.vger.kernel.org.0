Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298932F8F70
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 22:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbhAPV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 16:29:47 -0500
Received: from fox.pavlix.cz ([185.8.165.163]:36888 "EHLO fox.pavlix.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAPV3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 16:29:45 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jan 2021 16:29:44 EST
Received: from zorg.lan (unknown [217.30.64.218])
        by fox.pavlix.cz (Postfix) with ESMTPSA id 2A13AE61EC;
        Sat, 16 Jan 2021 22:19:27 +0100 (CET)
From:   =?UTF-8?q?Pavel=20=C5=A0imerda?= <code@simerda.eu>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Pavel=20=C5=A0imerda?= <code@simerda.eu>
Subject: [PATCH net-next] net: mdio: access c22 registers via debugfs
Date:   Sat, 16 Jan 2021 22:19:16 +0100
Message-Id: <20210116211916.8329-1-code@simerda.eu>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a debugging interface to read and write MDIO registers directly
without the need for a device driver.

This is extremely useful when debugging switch hardware and phy hardware
issues. The interface provides proper locking for communication that
consists of a sequence of MDIO read/write commands.

The interface binds directly to the MDIO bus abstraction in order to
provide support for all devices whether there's a hardware driver for
them or not. Registers are written by writing address, offset, and
value in hex, separated by colon. Registeres are read by writing only
address and offset, then reading the value.

It can be easily tested using `socat`:

    # socat - /sys/kernel/debug/mdio/f802c000.ethernet-ffffffff/control

Example: Reading address 0x00 offset 0x00, value is 0x3000

    Input: 00:00
    Output: 3000

Example: Writing address 0x00 offset 0x00, value 0x2100

    Input: 00:00:2100

Signed-off-by: Pavel Šimerda <code@simerda.eu>
---
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-debugfs.c | 196 +++++++++++++++++++++++++++++++++
 drivers/net/phy/mdio-debugfs.h |   2 +
 drivers/net/phy/mdio_bus.c     |   5 +
 include/linux/phy.h            |   3 +
 5 files changed, 207 insertions(+)
 create mode 100644 drivers/net/phy/mdio-debugfs.c
 create mode 100644 drivers/net/phy/mdio-debugfs.h

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..4999cb97844b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -17,6 +17,7 @@ libphy-y			+= $(mdio-bus-y)
 else
 obj-$(CONFIG_MDIO_DEVICE)	+= mdio-bus.o
 endif
+obj-$(CONFIG_MDIO_DEVICE)	+= mdio-debugfs.o
 obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
diff --git a/drivers/net/phy/mdio-debugfs.c b/drivers/net/phy/mdio-debugfs.c
new file mode 100644
index 000000000000..abed40052c20
--- /dev/null
+++ b/drivers/net/phy/mdio-debugfs.c
@@ -0,0 +1,196 @@
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/phy.h>
+#include <linux/poll.h>
+
+/*
+ * TODO: May need locking implementation to avoid being susceptible to file
+ * descriptor sharing concurrency issues
+ */
+struct mdio_debug {
+	wait_queue_head_t queue;
+	int value;
+};
+
+static int mdio_debug_open(struct inode *inode, struct file *file)
+{
+	struct mii_bus *bus = file->f_inode->i_private;
+	struct mdio_debug *data;
+	int err;
+
+	data = kzalloc(sizeof *data, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	err = mutex_lock_interruptible(&bus->mdio_lock);
+	if (err) {
+		kfree(data);
+		return err;
+	}
+	dev_dbg(&bus->dev, "MDIO locked for user space program.\n");
+
+	init_waitqueue_head(&data->queue);
+	data->value = -1;
+	file->private_data = data;
+
+	return 0;
+}
+
+static int mdio_debug_release(struct inode *inode, struct file *file)
+{
+	struct mii_bus *bus = file->f_inode->i_private;
+	struct mdio_debug *data = file->private_data;
+
+	file->private_data = NULL;
+
+	mutex_unlock(&bus->mdio_lock);
+	dev_dbg(&bus->dev, "MDIO unlocked.\n");
+
+	kfree(data);
+
+	return 0;
+}
+
+static ssize_t mdio_debug_write(struct file *file, const char __user *buffer, size_t size, loff_t *off)
+{
+	struct mii_bus *bus = file->f_inode->i_private;
+	struct mdio_debug *data = file->private_data;
+	char str[64] = {};
+	char *s = str;
+	char *token;
+	int addr;
+	int offset;
+	int value;
+	int ret;
+
+	if (data->value != -1)
+		return -EWOULDBLOCK;
+
+	if (size > sizeof str - 1)
+		return -EINVAL;
+
+	ret = copy_from_user(str, buffer, size);
+	if (ret)
+		return -EFAULT;
+
+	if (str[size-1] == '\n')
+		str[size-1] = '\0';
+
+	token = strsep(&s, ":");
+	if (!token)
+		return -EINVAL;
+	ret = kstrtoint(token, 16, &addr);
+	if (ret)
+		return ret;
+
+	token = strsep(&s, ":");
+	if (!token)
+		return -EINVAL;
+	ret = kstrtoint(token, 16, &offset);
+	if (ret)
+		return ret;
+
+	token = strsep(&s, ":");
+
+	if (token) {
+		ret = kstrtoint(token, 16, &value);
+		if (ret)
+			return ret;
+
+		ret = __mdiobus_write(bus, addr, offset, value);
+		if (ret)
+			return ret;
+
+		dev_dbg(&bus->dev, "write: addr=0x%.2x offset=0x%.2x value=%.4x\n",
+			addr, offset, value);
+	} else {
+		value = __mdiobus_read(bus, addr, offset);
+		if (value < 0)
+			return value;
+
+		dev_dbg(&bus->dev, "read: addr=0x%.2x offset=0x%.2x value=%.4x\n",
+			addr, offset, value);
+
+		data->value = value;
+		wake_up_all(&data->queue);
+	}
+
+	return size;
+}
+
+static ssize_t mdio_debug_read(struct file *file, char __user *buffer, size_t size, loff_t *off)
+{
+	struct mdio_debug *data = file->private_data;
+	char str[6];
+	int ret;
+	ssize_t rsize;
+
+	if (data->value == -1)
+		return -EWOULDBLOCK;
+
+	rsize = snprintf(str, sizeof str, "%04x\n", data->value);
+	if (rsize > size)
+		return -EINVAL;
+
+	ret = copy_to_user(buffer, str, rsize);
+	if (ret)
+		return -EFAULT;
+
+	data->value = -1;
+	wake_up_all(&data->queue);
+
+	return rsize;
+}
+
+static unsigned int mdio_debug_poll(struct file *file, poll_table *wait)
+{
+	struct mdio_debug *data = file->private_data;
+
+	poll_wait(file, &data->queue, wait);
+
+	return data->value == -1 ? POLLOUT : POLLIN;
+}
+
+struct file_operations mdio_debug_fops = {
+	.owner = THIS_MODULE,
+	.open = mdio_debug_open,
+	.release = mdio_debug_release,
+	.write = mdio_debug_write,
+	.read = mdio_debug_read,
+	.poll = mdio_debug_poll,
+};
+
+/*
+ * TODO: This implementation doesn't support module load/unload and has no
+ * error checking.
+ */
+
+static struct dentry *mdio_debugfs_dentry;
+
+void mdio_debugfs_add(struct mii_bus *bus)
+{
+	bus->debugfs_dentry = debugfs_create_dir(dev_name(&bus->dev), mdio_debugfs_dentry);
+	debugfs_create_file("control", 0600, bus->debugfs_dentry, bus, &mdio_debug_fops);
+}
+EXPORT_SYMBOL_GPL(mdio_debugfs_add);
+
+void mdio_debugfs_remove(struct mii_bus *bus)
+{
+	debugfs_remove(bus->debugfs_dentry);
+	bus->debugfs_dentry = NULL;
+}
+EXPORT_SYMBOL_GPL(mdio_debugfs_remove);
+
+int __init mdio_debugfs_init(void)
+{
+	mdio_debugfs_dentry = debugfs_create_dir("mdio", NULL);
+
+	return PTR_ERR_OR_ZERO(mdio_debugfs_dentry);
+}
+module_init(mdio_debugfs_init);
+
+void __exit mdio_debugfs_exit(void)
+{
+	debugfs_remove(mdio_debugfs_dentry);
+}
+module_exit(mdio_debugfs_exit);
diff --git a/drivers/net/phy/mdio-debugfs.h b/drivers/net/phy/mdio-debugfs.h
new file mode 100644
index 000000000000..fe98dcdfcacf
--- /dev/null
+++ b/drivers/net/phy/mdio-debugfs.h
@@ -0,0 +1,2 @@
+void mdio_debugfs_add(struct mii_bus *bus);
+void mdio_debugfs_remove(struct mii_bus *bus);
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 040509b81f02..969cb8e1ebee 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -39,6 +39,7 @@
 #include <trace/events/mdio.h>
 
 #include "mdio-boardinfo.h"
+#include "mdio-debugfs.h"
 
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
@@ -581,6 +582,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
+	mdio_debugfs_add(bus);
+
 	bus->state = MDIOBUS_REGISTERED;
 	pr_info("%s: probed\n", bus->name);
 	return 0;
@@ -612,6 +615,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	BUG_ON(bus->state != MDIOBUS_REGISTERED);
 	bus->state = MDIOBUS_UNREGISTERED;
 
+	mdio_debugfs_remove(bus);
+
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
 		mdiodev = bus->mdio_map[i];
 		if (!mdiodev)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 24fcc6456a9e..f4cc93c11006 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -371,6 +371,9 @@ struct mii_bus {
 
 	/** @shared: shared state across different PHYs */
 	struct phy_package_shared *shared[PHY_MAX_ADDR];
+
+	/* debugfs file for MDIO access */
+	struct dentry *debugfs_dentry;
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
-- 
2.29.2

