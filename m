Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A166964E487
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiLOXL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLOXLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:11:16 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A04C62E93
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 15:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671145874; x=1702681874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SvTO9K6lYDJmyTLyqammuvKpJp48liDOOXwyOcsjIls=;
  b=RGQyjI6KhjKz9QZA+5plWdIIYDzr5Q28IHBHMQoLnfGT9PHeG8sIPhpZ
   1kpiKQK2EOOICo4EkT8PrZsq/Q/0T6cpSY9PtkyJk0Yrc+2r6GW834cxp
   aXNiDT+LZE0HGPNeX7EwuZ6LChUz30C+2PKRKzCjd/glkduaV00ipcrZA
   Q2R1u14Fn9DEjm8IX3tGcx24fmkxx0o0Uda9Ybt21M4zKRzam+OBK31Me
   8eHmtPQoYIthGrEyJZdw86kV8/xJ7VSNO5yXeFmQmqp6kGs0RxcFvBklE
   AmImNy94PxCASZ1Dff6whe9L4kbMhtMyL4O3dd5BfHmXG4M0HYe48gcvG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="320714867"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="320714867"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:10:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="823923527"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="823923527"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2022 15:10:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        anthony.l.nguyen@intel.com, johan@kernel.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: [RFC PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Date:   Thu, 15 Dec 2022 15:10:47 -0800
Message-Id: <20221215231047.3595649-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Previously support for GNSS was implemented as a TTY driver, it allowed
to access GNSS receiver on /dev/ttyGNSS_<bus><func>.

Use generic GNSS subsystem API instead of implementing own TTY driver.
The receiver is accessible on /dev/gnss<id>. In case of multiple
receivers in the OS, correct device can be found by enumerating either:
- /sys/class/net/<eth port>/device/gnss/
- /sys/class/gnss/gnss<id>/device/

User expecting onboard GNSS receiver support is required to enable
CONFIG_GNSS=y/m in kernel config.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
Based on feedback from:
https://lore.kernel.org/netdev/20220829220049.333434-4-anthony.l.nguyen@intel.com/

 .../device_drivers/ethernet/intel/ice.rst     |  16 +-
 drivers/net/ethernet/intel/Kconfig            |   3 +
 drivers/net/ethernet/intel/ice/Makefile       |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   6 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 375 +++++++-----------
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  18 +-
 6 files changed, 158 insertions(+), 262 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index dc2e60ced927..1aa029d08cb1 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -901,15 +901,17 @@ To enable/disable UDP Segmentation Offload, issue the following command::
 
   # ethtool -K <ethX> tx-udp-segmentation [off|on]
 
+
 GNSS module
 -----------
-Allows user to read messages from the GNSS module and write supported commands.
-If the module is physically present, driver creates 2 TTYs for each supported
-device in /dev, ttyGNSS_<device>:<function>_0 and _1. First one (_0) is RW and
-the second one is RO.
-The protocol of write commands is dependent on the GNSS module as the driver
-writes raw bytes from the TTY to the GNSS i2c. Please refer to the module
-documentation for details.
+Requires kernel compiled with CONFIG_GNSS=y or CONFIG_GNSS=m.
+Allows user to read messages from the GNSS hardware module and write supported
+commands. If the module is physically present, a GNSS device is spawned:
+``/dev/gnss<id>``.
+The protocol of write command is dependent on the GNSS hardware module as the
+driver writes raw bytes by the GNSS object to the receiver through i2c. Please
+refer to the hardware GNSS module documentation for configuration details.
+
 
 Performance Optimization
 ========================
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 3facb55b7161..a3c84bf05e44 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -337,6 +337,9 @@ config ICE_HWTS
 	  the PTP clock driver precise cross-timestamp ioctl
 	  (PTP_SYS_OFFSET_PRECISE).
 
+config ICE_GNSS
+	def_bool GNSS = y || GNSS = ICE
+
 config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 9183d480b70b..060d8f2b4953 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -42,8 +42,8 @@ ice-$(CONFIG_PCI_IOV) +=	\
 	ice_vf_vsi_vlan_ops.o	\
 	ice_vf_lib.o
 ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
-ice-$(CONFIG_TTY) += ice_gnss.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
+ice-$(CONFIG_ICE_GNSS) += ice_gnss.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2f0b604abc5e..ae93ae488bc2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -39,6 +39,7 @@
 #include <linux/avf/virtchnl.h>
 #include <linux/cpu_rmap.h>
 #include <linux/dim.h>
+#include <linux/gnss.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_gact.h>
@@ -565,9 +566,8 @@ struct ice_pf {
 	struct mutex adev_mutex;	/* lock to protect aux device access */
 	u32 msg_enable;
 	struct ice_ptp ptp;
-	struct tty_driver *ice_gnss_tty_driver;
-	struct tty_port *gnss_tty_port[ICE_GNSS_TTY_MINOR_DEVICES];
-	struct gnss_serial *gnss_serial[ICE_GNSS_TTY_MINOR_DEVICES];
+	struct gnss_serial *gnss_serial;
+	struct gnss_device *gnss_dev;
 	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
 	u16 rdma_base_vector;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index b5a7f246d230..855e4d76bebc 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -3,15 +3,18 @@
 
 #include "ice.h"
 #include "ice_lib.h"
-#include <linux/tty_driver.h>
 
 /**
- * ice_gnss_do_write - Write data to internal GNSS
+ * ice_gnss_do_write - Write data to internal GNSS receiver
  * @pf: board private structure
  * @buf: command buffer
  * @size: command buffer size
  *
  * Write UBX command data to the GNSS receiver
+ *
+ * Return:
+ * * number of bytes written - success
+ * * negative - error code
  */
 static unsigned int
 ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
@@ -82,6 +85,12 @@ static void ice_gnss_write_pending(struct kthread_work *work)
 						write_work);
 	struct ice_pf *pf = gnss->back;
 
+	if (!pf)
+		return;
+
+	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+		return;
+
 	if (!list_empty(&gnss->queue)) {
 		struct gnss_write_buf *write_buf = NULL;
 		unsigned int bytes;
@@ -102,16 +111,14 @@ static void ice_gnss_write_pending(struct kthread_work *work)
  * ice_gnss_read - Read data from internal GNSS module
  * @work: GNSS read work structure
  *
- * Read the data from internal GNSS receiver, number of bytes read will be
- * returned in *read_data parameter.
+ * Read the data from internal GNSS receiver, write it to gnss_dev.
  */
 static void ice_gnss_read(struct kthread_work *work)
 {
 	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
 						read_work.work);
+	unsigned int i, bytes_read, data_len, count;
 	struct ice_aqc_link_topo_addr link_topo;
-	unsigned int i, bytes_read, data_len;
-	struct tty_port *port;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	__be16 data_len_b;
@@ -120,14 +127,15 @@ static void ice_gnss_read(struct kthread_work *work)
 	int err = 0;
 
 	pf = gnss->back;
-	if (!pf || !gnss->tty || !gnss->tty->port) {
+	if (!pf) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	hw = &pf->hw;
-	port = gnss->tty->port;
+	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+		return;
 
+	hw = &pf->hw;
 	buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
@@ -159,7 +167,6 @@ static void ice_gnss_read(struct kthread_work *work)
 	}
 
 	data_len = min_t(typeof(data_len), data_len, PAGE_SIZE);
-	data_len = tty_buffer_request_room(port, data_len);
 	if (!data_len) {
 		err = -ENOMEM;
 		goto exit_buf;
@@ -179,12 +186,11 @@ static void ice_gnss_read(struct kthread_work *work)
 			goto exit_buf;
 	}
 
-	/* Send the data to the tty layer for users to read. This doesn't
-	 * actually push the data through unless tty->low_latency is set.
-	 */
-	tty_insert_flip_string(port, buf, i);
-	tty_flip_buffer_push(port);
-
+	count = gnss_insert_raw(pf->gnss_dev, buf, i);
+	if (count != i)
+		dev_warn(ice_pf_to_dev(pf),
+			 "gnss_insert_raw ret=%d size=%d\n",
+			 count, i);
 exit_buf:
 	free_page((unsigned long)buf);
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work,
@@ -195,11 +201,16 @@ static void ice_gnss_read(struct kthread_work *work)
 }
 
 /**
- * ice_gnss_struct_init - Initialize GNSS structure for the TTY
+ * ice_gnss_struct_init - Initialize GNSS receiver
  * @pf: Board private structure
- * @index: TTY device index
+ *
+ * Initialize GNSS structures and workers.
+ *
+ * Return:
+ * * pointer to initialized gnss_serial struct - success
+ * * NULL - error
  */
-static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf, int index)
+static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct kthread_worker *kworker;
@@ -209,17 +220,12 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf, int index)
 	if (!gnss)
 		return NULL;
 
-	mutex_init(&gnss->gnss_mutex);
-	gnss->open_count = 0;
 	gnss->back = pf;
-	pf->gnss_serial[index] = gnss;
+	pf->gnss_serial = gnss;
 
 	kthread_init_delayed_work(&gnss->read_work, ice_gnss_read);
 	INIT_LIST_HEAD(&gnss->queue);
 	kthread_init_work(&gnss->write_work, ice_gnss_write_pending);
-	/* Allocate a kworker for handling work required for the GNSS TTY
-	 * writes.
-	 */
 	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
 	if (IS_ERR(kworker)) {
 		kfree(gnss);
@@ -232,276 +238,186 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf, int index)
 }
 
 /**
- * ice_gnss_tty_open - Initialize GNSS structures on TTY device open
- * @tty: pointer to the tty_struct
- * @filp: pointer to the file
+ * ice_gnss_open - Open GNSS device
+ * @gdev: pointer to the gnss device struct
  *
- * This routine is mandatory. If this routine is not filled in, the attempted
- * open will fail with ENODEV.
+ * Open GNSS device and start filling the read buffer for consumer.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error code
  */
-static int ice_gnss_tty_open(struct tty_struct *tty, struct file *filp)
+static int ice_gnss_open(struct gnss_device *gdev)
 {
+	struct ice_pf *pf = gnss_get_drvdata(gdev);
 	struct gnss_serial *gnss;
-	struct ice_pf *pf;
 
-	pf = (struct ice_pf *)tty->driver->driver_state;
 	if (!pf)
 		return -EFAULT;
 
-	/* Clear the pointer in case something fails */
-	tty->driver_data = NULL;
-
-	/* Get the serial object associated with this tty pointer */
-	gnss = pf->gnss_serial[tty->index];
-	if (!gnss) {
-		/* Initialize GNSS struct on the first device open */
-		gnss = ice_gnss_struct_init(pf, tty->index);
-		if (!gnss)
-			return -ENOMEM;
-	}
+	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+		return -EFAULT;
 
-	mutex_lock(&gnss->gnss_mutex);
+	gnss = pf->gnss_serial;
+	if (!gnss)
+		return -ENODEV;
 
-	/* Save our structure within the tty structure */
-	tty->driver_data = gnss;
-	gnss->tty = tty;
-	gnss->open_count++;
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, 0);
 
-	mutex_unlock(&gnss->gnss_mutex);
-
 	return 0;
 }
 
 /**
- * ice_gnss_tty_close - Cleanup GNSS structures on tty device close
- * @tty: pointer to the tty_struct
- * @filp: pointer to the file
+ * ice_gnss_close - Close GNSS device
+ * @gdev: pointer to the gnss device struct
+ *
+ * Close GNSS device, cancel worker, stop filling the read buffer.
  */
-static void ice_gnss_tty_close(struct tty_struct *tty, struct file *filp)
+static void ice_gnss_close(struct gnss_device *gdev)
 {
-	struct gnss_serial *gnss = tty->driver_data;
-	struct ice_pf *pf;
-
-	if (!gnss)
-		return;
+	struct ice_pf *pf = gnss_get_drvdata(gdev);
+	struct gnss_serial *gnss;
 
-	pf = (struct ice_pf *)tty->driver->driver_state;
 	if (!pf)
 		return;
 
-	mutex_lock(&gnss->gnss_mutex);
-
-	if (!gnss->open_count) {
-		/* Port was never opened */
-		dev_err(ice_pf_to_dev(pf), "GNSS port not opened\n");
-		goto exit;
-	}
+	gnss = pf->gnss_serial;
+	if (!gnss)
+		return;
 
-	gnss->open_count--;
-	if (gnss->open_count <= 0) {
-		/* Port is in shutdown state */
-		kthread_cancel_delayed_work_sync(&gnss->read_work);
-	}
-exit:
-	mutex_unlock(&gnss->gnss_mutex);
+	kthread_cancel_work_sync(&gnss->write_work);
+	kthread_cancel_delayed_work_sync(&gnss->read_work);
 }
 
 /**
- * ice_gnss_tty_write - Write GNSS data
- * @tty: pointer to the tty_struct
+ * ice_gnss_write - Write to GNSS device
+ * @gdev: pointer to the gnss device struct
  * @buf: pointer to the user data
- * @count: the number of characters queued to be sent to the HW
+ * @count: size of the buffer to be sent to the GNSS device
  *
- * The write function call is called by the user when there is data to be sent
- * to the hardware. First the tty core receives the call, and then it passes the
- * data on to the tty driver's write function. The tty core also tells the tty
- * driver the size of the data being sent.
- * If any errors happen during the write call, a negative error value should be
- * returned instead of the number of characters queued to be written.
+ * Return:
+ * * number of written bytes - success
+ * * negative - error code
  */
 static int
-ice_gnss_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
+ice_gnss_write(struct gnss_device *gdev, const unsigned char *buf,
+	       size_t count)
 {
+	struct ice_pf *pf = gnss_get_drvdata(gdev);
 	struct gnss_write_buf *write_buf;
 	struct gnss_serial *gnss;
 	unsigned char *cmd_buf;
-	struct ice_pf *pf;
 	int err = count;
 
 	/* We cannot write a single byte using our I2C implementation. */
 	if (count <= 1 || count > ICE_GNSS_TTY_WRITE_BUF)
 		return -EINVAL;
 
-	gnss = tty->driver_data;
-	if (!gnss)
-		return -EFAULT;
-
-	pf = (struct ice_pf *)tty->driver->driver_state;
 	if (!pf)
 		return -EFAULT;
 
-	/* Only allow to write on TTY 0 */
-	if (gnss != pf->gnss_serial[0])
-		return -EIO;
-
-	mutex_lock(&gnss->gnss_mutex);
+	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+		return -EFAULT;
 
-	if (!gnss->open_count) {
-		err = -EINVAL;
-		goto exit;
-	}
+	gnss = pf->gnss_serial;
+	if (!gnss)
+		return -ENODEV;
 
 	cmd_buf = kcalloc(count, sizeof(*buf), GFP_KERNEL);
-	if (!cmd_buf) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	if (!cmd_buf)
+		return -ENOMEM;
 
 	memcpy(cmd_buf, buf, count);
-
-	/* Send the data out to a hardware port */
 	write_buf = kzalloc(sizeof(*write_buf), GFP_KERNEL);
-	if (!write_buf) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	if (!write_buf)
+		return -ENOMEM;
 
 	write_buf->buf = cmd_buf;
 	write_buf->size = count;
 	INIT_LIST_HEAD(&write_buf->queue);
 	list_add_tail(&write_buf->queue, &gnss->queue);
 	kthread_queue_work(gnss->kworker, &gnss->write_work);
-exit:
-	mutex_unlock(&gnss->gnss_mutex);
+
 	return err;
 }
 
+static const struct gnss_operations ice_gnss_ops = {
+	.open = ice_gnss_open,
+	.close = ice_gnss_close,
+	.write_raw = ice_gnss_write,
+};
+
 /**
- * ice_gnss_tty_write_room - Returns the numbers of characters to be written.
- * @tty: pointer to the tty_struct
+ * ice_gnss_register - Register GNSS receiver
+ * @pf: Board private structure
+ *
+ * Allocate and register GNSS receiver in the Linux GNSS subsystem.
  *
- * This routine returns the numbers of characters the tty driver will accept
- * for queuing to be written or 0 if either the TTY is not open or user
- * tries to write to the TTY other than the first.
+ * Return:
+ * * 0 - success
+ * * negative - error code
  */
-static unsigned int ice_gnss_tty_write_room(struct tty_struct *tty)
+static int ice_gnss_register(struct ice_pf *pf)
 {
-	struct gnss_serial *gnss = tty->driver_data;
-
-	/* Only allow to write on TTY 0 */
-	if (!gnss || gnss != gnss->back->gnss_serial[0])
-		return 0;
-
-	mutex_lock(&gnss->gnss_mutex);
-
-	if (!gnss->open_count) {
-		mutex_unlock(&gnss->gnss_mutex);
-		return 0;
+	struct gnss_device *gdev = NULL;
+	int ret;
+
+	gdev = gnss_allocate_device(ice_pf_to_dev(pf));
+	if (!gdev) {
+		dev_err(ice_pf_to_dev(pf),
+			"gnss_allocate_device returns NULL\n");
+		return -ENOMEM;
 	}
 
-	mutex_unlock(&gnss->gnss_mutex);
-	return ICE_GNSS_TTY_WRITE_BUF;
+	gdev->ops = &ice_gnss_ops;
+	gdev->type = GNSS_TYPE_UBX;
+	gnss_set_drvdata(gdev, pf);
+	ret = gnss_register_device(gdev);
+	if (ret)
+		dev_err(ice_pf_to_dev(pf), "gnss_register_device err=%d\n",
+			ret);
+	else
+		pf->gnss_dev = gdev;
+
+	return ret;
 }
 
-static const struct tty_operations tty_gps_ops = {
-	.open =		ice_gnss_tty_open,
-	.close =	ice_gnss_tty_close,
-	.write =	ice_gnss_tty_write,
-	.write_room =	ice_gnss_tty_write_room,
-};
-
 /**
- * ice_gnss_create_tty_driver - Create a TTY driver for GNSS
+ * ice_gnss_deregister - Deregister GNSS receiver
  * @pf: Board private structure
+ *
+ * Deregister GNSS receiver from the Linux GNSS subsystem,
+ * release its resources.
  */
-static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
+static void ice_gnss_deregister(struct ice_pf *pf)
 {
-	struct device *dev = ice_pf_to_dev(pf);
-	const int ICE_TTYDRV_NAME_MAX = 14;
-	struct tty_driver *tty_driver;
-	char *ttydrv_name;
-	unsigned int i;
-	int err;
-
-	tty_driver = tty_alloc_driver(ICE_GNSS_TTY_MINOR_DEVICES,
-				      TTY_DRIVER_REAL_RAW);
-	if (IS_ERR(tty_driver)) {
-		dev_err(dev, "Failed to allocate memory for GNSS TTY\n");
-		return NULL;
-	}
-
-	ttydrv_name = kzalloc(ICE_TTYDRV_NAME_MAX, GFP_KERNEL);
-	if (!ttydrv_name) {
-		tty_driver_kref_put(tty_driver);
-		return NULL;
-	}
-
-	snprintf(ttydrv_name, ICE_TTYDRV_NAME_MAX, "ttyGNSS_%02x%02x_",
-		 (u8)pf->pdev->bus->number, (u8)PCI_SLOT(pf->pdev->devfn));
-
-	/* Initialize the tty driver*/
-	tty_driver->owner = THIS_MODULE;
-	tty_driver->driver_name = dev_driver_string(dev);
-	tty_driver->name = (const char *)ttydrv_name;
-	tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
-	tty_driver->subtype = SERIAL_TYPE_NORMAL;
-	tty_driver->init_termios = tty_std_termios;
-	tty_driver->init_termios.c_iflag &= ~INLCR;
-	tty_driver->init_termios.c_iflag |= IGNCR;
-	tty_driver->init_termios.c_oflag &= ~OPOST;
-	tty_driver->init_termios.c_lflag &= ~ICANON;
-	tty_driver->init_termios.c_cflag &= ~(CSIZE | CBAUD | CBAUDEX);
-	/* baud rate 9600 */
-	tty_termios_encode_baud_rate(&tty_driver->init_termios, 9600, 9600);
-	tty_driver->driver_state = pf;
-	tty_set_operations(tty_driver, &tty_gps_ops);
-
-	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-		pf->gnss_tty_port[i] = kzalloc(sizeof(*pf->gnss_tty_port[i]),
-					       GFP_KERNEL);
-		pf->gnss_serial[i] = NULL;
-
-		tty_port_init(pf->gnss_tty_port[i]);
-		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
-	}
-
-	err = tty_register_driver(tty_driver);
-	if (err) {
-		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
-
-		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-			tty_port_destroy(pf->gnss_tty_port[i]);
-			kfree(pf->gnss_tty_port[i]);
-		}
-		kfree(ttydrv_name);
-		tty_driver_kref_put(pf->ice_gnss_tty_driver);
-
-		return NULL;
+	if (pf->gnss_dev) {
+		gnss_deregister_device(pf->gnss_dev);
+		gnss_put_device(pf->gnss_dev);
+		pf->gnss_dev = NULL;
 	}
-
-	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
-		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
-
-	return tty_driver;
 }
 
 /**
- * ice_gnss_init - Initialize GNSS TTY support
+ * ice_gnss_init - Initialize GNSS support
  * @pf: Board private structure
  */
 void ice_gnss_init(struct ice_pf *pf)
 {
-	struct tty_driver *tty_driver;
+	int ret;
 
-	tty_driver = ice_gnss_create_tty_driver(pf);
-	if (!tty_driver)
+	pf->gnss_serial = ice_gnss_struct_init(pf);
+	if (!pf->gnss_serial)
 		return;
 
-	pf->ice_gnss_tty_driver = tty_driver;
-
-	set_bit(ICE_FLAG_GNSS, pf->flags);
-	dev_info(ice_pf_to_dev(pf), "GNSS TTY init successful\n");
+	ret = ice_gnss_register(pf);
+	if (!ret) {
+		set_bit(ICE_FLAG_GNSS, pf->flags);
+		dev_info(ice_pf_to_dev(pf), "GNSS init successful\n");
+	} else {
+		ice_gnss_exit(pf);
+		dev_err(ice_pf_to_dev(pf), "GNSS init failure\n");
+	}
 }
 
 /**
@@ -510,31 +426,20 @@ void ice_gnss_init(struct ice_pf *pf)
  */
 void ice_gnss_exit(struct ice_pf *pf)
 {
-	unsigned int i;
+	ice_gnss_deregister(pf);
+	clear_bit(ICE_FLAG_GNSS, pf->flags);
 
-	if (!test_bit(ICE_FLAG_GNSS, pf->flags) || !pf->ice_gnss_tty_driver)
-		return;
-
-	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-		if (pf->gnss_tty_port[i]) {
-			tty_port_destroy(pf->gnss_tty_port[i]);
-			kfree(pf->gnss_tty_port[i]);
-		}
+	if (pf->gnss_serial) {
+		struct gnss_serial *gnss = pf->gnss_serial;
 
-		if (pf->gnss_serial[i]) {
-			struct gnss_serial *gnss = pf->gnss_serial[i];
+		kthread_cancel_work_sync(&gnss->write_work);
+		kthread_cancel_delayed_work_sync(&gnss->read_work);
+		kthread_destroy_worker(gnss->kworker);
+		gnss->kworker = NULL;
 
-			kthread_cancel_work_sync(&gnss->write_work);
-			kthread_cancel_delayed_work_sync(&gnss->read_work);
-			kfree(gnss);
-			pf->gnss_serial[i] = NULL;
-		}
+		kfree(gnss);
+		pf->gnss_serial = NULL;
 	}
-
-	tty_unregister_driver(pf->ice_gnss_tty_driver);
-	kfree(pf->ice_gnss_tty_driver->name);
-	tty_driver_kref_put(pf->ice_gnss_tty_driver);
-	pf->ice_gnss_tty_driver = NULL;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index f454dd1d9285..31db0701d13f 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -4,15 +4,8 @@
 #ifndef _ICE_GNSS_H_
 #define _ICE_GNSS_H_
 
-#include <linux/tty.h>
-#include <linux/tty_flip.h>
-
 #define ICE_E810T_GNSS_I2C_BUS		0x2
 #define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
-/* Create 2 minor devices, both using the same GNSS module. First one is RW,
- * second one RO.
- */
-#define ICE_GNSS_TTY_MINOR_DEVICES	2
 #define ICE_GNSS_TTY_WRITE_BUF		250
 #define ICE_MAX_I2C_DATA_SIZE		FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
 #define ICE_MAX_I2C_WRITE_BYTES		4
@@ -36,13 +29,9 @@ struct gnss_write_buf {
 	unsigned char *buf;
 };
 
-
 /**
  * struct gnss_serial - data used to initialize GNSS TTY port
  * @back: back pointer to PF
- * @tty: pointer to the tty for this device
- * @open_count: number of times this port has been opened
- * @gnss_mutex: gnss_mutex used to protect GNSS serial operations
  * @kworker: kwork thread for handling periodic work
  * @read_work: read_work function for handling GNSS reads
  * @write_work: write_work function for handling GNSS writes
@@ -50,16 +39,13 @@ struct gnss_write_buf {
  */
 struct gnss_serial {
 	struct ice_pf *back;
-	struct tty_struct *tty;
-	int open_count;
-	struct mutex gnss_mutex; /* protects GNSS serial structure */
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work read_work;
 	struct kthread_work write_work;
 	struct list_head queue;
 };
 
-#if IS_ENABLED(CONFIG_TTY)
+#if IS_ENABLED(CONFIG_ICE_GNSS)
 void ice_gnss_init(struct ice_pf *pf);
 void ice_gnss_exit(struct ice_pf *pf);
 bool ice_gnss_is_gps_present(struct ice_hw *hw);
@@ -70,5 +56,5 @@ static inline bool ice_gnss_is_gps_present(struct ice_hw *hw)
 {
 	return false;
 }
-#endif /* IS_ENABLED(CONFIG_TTY) */
+#endif /* IS_ENABLED(CONFIG_ICE_GNSS) */
 #endif /* _ICE_GNSS_H_ */
-- 
2.35.1

