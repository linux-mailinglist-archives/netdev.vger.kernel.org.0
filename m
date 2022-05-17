Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4126F52AD75
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiEQVWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiEQVWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:22:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7C43ED09
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652822558; x=1684358558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RaRSa+JJvmB042m+Jv/JoUiOr3PaJSwPyjSqSB9eBYk=;
  b=VXtqIckykZQSnnoLx8A9HctbZSJ4/kpKB92WJzxFB23jy9bV87A3j8wR
   Dsb0gUwGlMB4kwQxBNURWl7qeQLeuxgrFFKK9TsTf4taSSN1iWok9z17V
   jod2ElrA7T2gaRYeKJro7eWGP80lmGTEJjNykz4nMvjwm6k0fmOFQreh3
   gBRN37LpS8TBo+06TncRFb+QfkKfg3rU/5MSucLH8F9u9wR/SqHG7WMN9
   MKN+S+bSzTZfc//1wc1gdHudOTmmTG8e2WQ0lXqziZFpD1zKG9hk+Lmed
   ap1wWbCtUzKiqspjZ1EXAdz1FMIm45Gn8qs2Oz69dnu9/KieWjNop/Wyz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357749584"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357749584"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 14:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="605546010"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2022 14:22:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Date:   Tue, 17 May 2022 14:19:35 -0700
Message-Id: <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

Add the possibility to write raw bytes to the GNSS module through the
first TTY device. This allows user to configure the module using the
publicly available u-blox UBX protocol (version 29) commands.

Create a second read-only TTY device.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c | 241 +++++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_gnss.h |  26 ++-
 3 files changed, 240 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..5c472ed99c7a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -544,8 +544,8 @@ struct ice_pf {
 	u32 msg_enable;
 	struct ice_ptp ptp;
 	struct tty_driver *ice_gnss_tty_driver;
-	struct tty_port gnss_tty_port;
-	struct gnss_serial *gnss_serial;
+	struct tty_port *gnss_tty_port[ICE_GNSS_TTY_MINOR_DEVICES];
+	struct gnss_serial *gnss_serial[ICE_GNSS_TTY_MINOR_DEVICES];
 	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
 	u16 rdma_base_vector;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index c6d755f707aa..4b7b762cd787 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -1,10 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2018-2021, Intel Corporation. */
+/* Copyright (C) 2021-2022, Intel Corporation. */
 
 #include "ice.h"
 #include "ice_lib.h"
 #include <linux/tty_driver.h>
 
+/**
+ * ice_gnss_do_write - Write data to internal GNSS
+ * @pf: board private structure
+ * @buf: command buffer
+ * @size: command buffer size
+ *
+ * Write UBX command data to the GNSS receiver
+ */
+static unsigned int
+ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
+{
+	struct ice_aqc_link_topo_addr link_topo;
+	struct ice_hw *hw = &pf->hw;
+	unsigned int offset = 0;
+	int err = 0;
+
+	memset(&link_topo, 0, sizeof(struct ice_aqc_link_topo_addr));
+	link_topo.topo_params.index = ICE_E810T_GNSS_I2C_BUS;
+	link_topo.topo_params.node_type_ctx |=
+		FIELD_PREP(ICE_AQC_LINK_TOPO_NODE_CTX_M,
+			   ICE_AQC_LINK_TOPO_NODE_CTX_OVERRIDE);
+
+	/* It's not possible to write a single byte to u-blox.
+	 * Write all bytes in a loop until there are 6 or less bytes left. If
+	 * there are exactly 6 bytes left, the last write would be only a byte.
+	 * In this case, do 4+2 bytes writes instead of 5+1. Otherwise, do the
+	 * last 2 to 5 bytes write.
+	 */
+	while (size - offset > ICE_GNSS_UBX_WRITE_BYTES + 1) {
+		err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+				       cpu_to_le16(buf[offset]),
+				       ICE_MAX_I2C_WRITE_BYTES,
+				       &buf[offset + 1], NULL);
+		if (err)
+			goto exit;
+
+		offset += ICE_GNSS_UBX_WRITE_BYTES;
+	}
+
+	/* Single byte would be written. Write 4 bytes instead of 5. */
+	if (size - offset == ICE_GNSS_UBX_WRITE_BYTES + 1) {
+		err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+				       cpu_to_le16(buf[offset]),
+				       ICE_MAX_I2C_WRITE_BYTES - 1,
+				       &buf[offset + 1], NULL);
+		if (err)
+			goto exit;
+
+		offset += ICE_GNSS_UBX_WRITE_BYTES - 1;
+	}
+
+	/* Do the last write, 2 to 5 bytes. */
+	err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+			       cpu_to_le16(buf[offset]), size - offset - 1,
+			       &buf[offset + 1], NULL);
+	if (!err)
+		offset = size;
+
+exit:
+	if (err)
+		dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=%u, size=%u, err=%d\n",
+			offset, size, err);
+
+	return offset;
+}
+
+/**
+ * ice_gnss_write_pending - Write all pending data to internal GNSS
+ * @work: GNSS write work structure
+ */
+static void ice_gnss_write_pending(struct kthread_work *work)
+{
+	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
+						write_work);
+	struct ice_pf *pf = gnss->back;
+
+	if (!list_empty(&gnss->queue)) {
+		struct gnss_write_buf *write_buf = NULL;
+		unsigned int bytes;
+
+		write_buf = list_first_entry(&gnss->queue,
+					     struct gnss_write_buf, queue);
+
+		bytes = ice_gnss_do_write(pf, write_buf->buf, write_buf->size);
+		dev_dbg(ice_pf_to_dev(pf), "%u bytes written to GNSS\n", bytes);
+
+		list_del(&write_buf->queue);
+		kfree(write_buf->buf);
+		kfree(write_buf);
+	}
+}
+
 /**
  * ice_gnss_read - Read data from internal GNSS module
  * @work: GNSS read work structure
@@ -104,8 +196,9 @@ static void ice_gnss_read(struct kthread_work *work)
 /**
  * ice_gnss_struct_init - Initialize GNSS structure for the TTY
  * @pf: Board private structure
+ * @index: TTY device index
  */
-static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
+static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf, int index)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct kthread_worker *kworker;
@@ -118,9 +211,11 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 	mutex_init(&gnss->gnss_mutex);
 	gnss->open_count = 0;
 	gnss->back = pf;
-	pf->gnss_serial = gnss;
+	pf->gnss_serial[index] = gnss;
 
 	kthread_init_delayed_work(&gnss->read_work, ice_gnss_read);
+	INIT_LIST_HEAD(&gnss->queue);
+	kthread_init_work(&gnss->write_work, ice_gnss_write_pending);
 	/* Allocate a kworker for handling work required for the GNSS TTY
 	 * writes.
 	 */
@@ -156,10 +251,10 @@ static int ice_gnss_tty_open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = NULL;
 
 	/* Get the serial object associated with this tty pointer */
-	gnss = pf->gnss_serial;
+	gnss = pf->gnss_serial[tty->index];
 	if (!gnss) {
 		/* Initialize GNSS struct on the first device open */
-		gnss = ice_gnss_struct_init(pf);
+		gnss = ice_gnss_struct_init(pf, tty->index);
 		if (!gnss)
 			return -ENOMEM;
 	}
@@ -212,25 +307,100 @@ static void ice_gnss_tty_close(struct tty_struct *tty, struct file *filp)
 }
 
 /**
- * ice_gnss_tty_write - Dummy TTY write function to avoid kernel panic
+ * ice_gnss_tty_write - Write GNSS data
  * @tty: pointer to the tty_struct
  * @buf: pointer to the user data
- * @cnt: the number of characters that was able to be sent to the hardware (or
- *       queued to be sent at a later time)
+ * @count: the number of characters queued to be sent to the HW
+ *
+ * The write function call is called by the user when there is data to be sent
+ * to the hardware. First the tty core receives the call, and then it passes the
+ * data on to the tty driver's write function. The tty core also tells the tty
+ * driver the size of the data being sent.
+ * If any errors happen during the write call, a negative error value should be
+ * returned instead of the number of characters queued to be written.
  */
 static int
-ice_gnss_tty_write(struct tty_struct *tty, const unsigned char *buf, int cnt)
+ice_gnss_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-	return 0;
+	struct gnss_write_buf *write_buf;
+	struct gnss_serial *gnss;
+	unsigned char *cmd_buf;
+	struct ice_pf *pf;
+	int err = count;
+
+	/* We cannot write a single byte using our I2C implementation. */
+	if (count <= 1 || count > ICE_GNSS_TTY_WRITE_BUF)
+		return -EINVAL;
+
+	gnss = tty->driver_data;
+	if (!gnss)
+		return -EFAULT;
+
+	pf = (struct ice_pf *)tty->driver->driver_state;
+	if (!pf)
+		return -EFAULT;
+
+	/* Only allow to write on TTY 0 */
+	if (gnss != pf->gnss_serial[0])
+		return -EIO;
+
+	mutex_lock(&gnss->gnss_mutex);
+
+	if (!gnss->open_count) {
+		err = -EINVAL;
+		goto exit;
+	}
+
+	cmd_buf = kcalloc(count, sizeof(*buf), GFP_KERNEL);
+	if (!cmd_buf) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	memcpy(cmd_buf, buf, count);
+
+	/* Send the data out to a hardware port */
+	write_buf = kzalloc(sizeof(*write_buf), GFP_KERNEL);
+	if (!write_buf) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	write_buf->buf = cmd_buf;
+	write_buf->size = count;
+	INIT_LIST_HEAD(&write_buf->queue);
+	list_add_tail(&write_buf->queue, &gnss->queue);
+	kthread_queue_work(gnss->kworker, &gnss->write_work);
+exit:
+	mutex_unlock(&gnss->gnss_mutex);
+	return err;
 }
 
 /**
- * ice_gnss_tty_write_room - Dummy TTY write_room function to avoid kernel panic
+ * ice_gnss_tty_write_room - Returns the numbers of characters to be written.
  * @tty: pointer to the tty_struct
+ *
+ * This routine returns the numbers of characters the tty driver will accept
+ * for queuing to be written or 0 if either the TTY is not open or user
+ * tries to write to the TTY other than the first.
  */
 static unsigned int ice_gnss_tty_write_room(struct tty_struct *tty)
 {
-	return 0;
+	struct gnss_serial *gnss = tty->driver_data;
+
+	/* Only allow to write on TTY 0*/
+	if (!gnss || gnss != gnss->back->gnss_serial[0])
+		return 0;
+
+	mutex_lock(&gnss->gnss_mutex);
+
+	if (!gnss->open_count) {
+		mutex_unlock(&gnss->gnss_mutex);
+		return 0;
+	}
+
+	mutex_unlock(&gnss->gnss_mutex);
+	return ICE_GNSS_TTY_WRITE_BUF;
 }
 
 static const struct tty_operations tty_gps_ops = {
@@ -250,11 +420,13 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	const int ICE_TTYDRV_NAME_MAX = 14;
 	struct tty_driver *tty_driver;
 	char *ttydrv_name;
+	unsigned int i;
 	int err;
 
-	tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW);
+	tty_driver = tty_alloc_driver(ICE_GNSS_TTY_MINOR_DEVICES,
+				      TTY_DRIVER_REAL_RAW);
 	if (IS_ERR(tty_driver)) {
-		dev_err(ice_pf_to_dev(pf), "Failed to allocate memory for GNSS TTY\n");
+		dev_err(dev, "Failed to allocate memory for GNSS TTY\n");
 		return NULL;
 	}
 
@@ -284,23 +456,32 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	tty_driver->driver_state = pf;
 	tty_set_operations(tty_driver, &tty_gps_ops);
 
-	pf->gnss_serial = NULL;
+	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
+		pf->gnss_tty_port[i] = kzalloc(sizeof(*pf->gnss_tty_port[i]),
+					       GFP_KERNEL);
+		pf->gnss_serial[i] = NULL;
 
-	tty_port_init(&pf->gnss_tty_port);
-	tty_port_link_device(&pf->gnss_tty_port, tty_driver, 0);
+		tty_port_init(pf->gnss_tty_port[i]);
+		tty_port_link_device(pf->gnss_tty_port[i], tty_driver, i);
+	}
 
 	err = tty_register_driver(tty_driver);
 	if (err) {
-		dev_err(ice_pf_to_dev(pf), "Failed to register TTY driver err=%d\n",
-			err);
+		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
 
-		tty_port_destroy(&pf->gnss_tty_port);
+		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
+			tty_port_destroy(pf->gnss_tty_port[i]);
+			kfree(pf->gnss_tty_port[i]);
+		}
 		kfree(ttydrv_name);
 		tty_driver_kref_put(pf->ice_gnss_tty_driver);
 
 		return NULL;
 	}
 
+	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
+		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
+
 	return tty_driver;
 }
 
@@ -328,17 +509,25 @@ void ice_gnss_init(struct ice_pf *pf)
  */
 void ice_gnss_exit(struct ice_pf *pf)
 {
+	unsigned int i;
+
 	if (!test_bit(ICE_FLAG_GNSS, pf->flags) || !pf->ice_gnss_tty_driver)
 		return;
 
-	tty_port_destroy(&pf->gnss_tty_port);
+	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
+		if (pf->gnss_tty_port[i]) {
+			tty_port_destroy(pf->gnss_tty_port[i]);
+			kfree(pf->gnss_tty_port[i]);
+		}
 
-	if (pf->gnss_serial) {
-		struct gnss_serial *gnss = pf->gnss_serial;
+		if (pf->gnss_serial[i]) {
+			struct gnss_serial *gnss = pf->gnss_serial[i];
 
-		kthread_cancel_delayed_work_sync(&gnss->read_work);
-		kfree(gnss);
-		pf->gnss_serial = NULL;
+			kthread_cancel_work_sync(&gnss->write_work);
+			kthread_cancel_delayed_work_sync(&gnss->read_work);
+			kfree(gnss);
+			pf->gnss_serial[i] = NULL;
+		}
 	}
 
 	tty_unregister_driver(pf->ice_gnss_tty_driver);
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index 9211adb2372c..1f569a6e09a1 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2018-2021, Intel Corporation. */
+/* Copyright (C) 2021-2022, Intel Corporation. */
 
 #ifndef _ICE_GNSS_H_
 #define _ICE_GNSS_H_
@@ -8,14 +8,30 @@
 #include <linux/tty_flip.h>
 
 #define ICE_E810T_GNSS_I2C_BUS		0x2
+#define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
+#define ICE_GNSS_TTY_MINOR_DEVICES	2
+#define ICE_GNSS_TTY_WRITE_BUF		250
+#define ICE_MAX_I2C_DATA_SIZE		FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
+#define ICE_MAX_I2C_WRITE_BYTES		4
+
+/* u-blox specific definitions */
 #define ICE_GNSS_UBX_I2C_BUS_ADDR	0x42
 /* Data length register is big endian */
 #define ICE_GNSS_UBX_DATA_LEN_H		0xFD
 #define ICE_GNSS_UBX_DATA_LEN_WIDTH	2
 #define ICE_GNSS_UBX_EMPTY_DATA		0xFF
-#define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
-#define ICE_MAX_I2C_DATA_SIZE		FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
+/* For u-blox writes are performed without address so the first byte to write is
+ * passed as I2C addr parameter.
+ */
+#define ICE_GNSS_UBX_WRITE_BYTES	(ICE_MAX_I2C_WRITE_BYTES + 1)
 #define ICE_MAX_UBX_READ_TRIES		255
+#define ICE_MAX_UBX_ACK_READ_TRIES	4095
+
+struct gnss_write_buf {
+	struct list_head queue;
+	unsigned int size;
+	unsigned char *buf;
+};
 
 /**
  * struct gnss_serial - data used to initialize GNSS TTY port
@@ -25,6 +41,8 @@
  * @gnss_mutex: gnss_mutex used to protect GNSS serial operations
  * @kworker: kwork thread for handling periodic work
  * @read_work: read_work function for handling GNSS reads
+ * @write_work: write_work function for handling GNSS writes
+ * @queue: write buffers queue
  */
 struct gnss_serial {
 	struct ice_pf *back;
@@ -33,6 +51,8 @@ struct gnss_serial {
 	struct mutex gnss_mutex; /* protects GNSS serial structure */
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work read_work;
+	struct kthread_work write_work;
+	struct list_head queue;
 };
 
 #if IS_ENABLED(CONFIG_TTY)
-- 
2.35.1

