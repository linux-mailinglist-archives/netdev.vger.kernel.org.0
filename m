Return-Path: <netdev+bounces-8578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB017249FA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 315C71C20941
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44391ED50;
	Tue,  6 Jun 2023 17:17:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6C19915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:17:25 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F231705
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686071842; x=1717607842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/oJdHS+6YHalem7HUZpiuF9XvET7UxLOR5Gsgra7Vtw=;
  b=mZ9n4yGFRk0nzbvWkUqoIDliM6bnd7MZhdxNIUGcfZ9AOxesVqMnuX67
   2oSG9fc+qmqnkITQ3l4GXq8aQ+Gxl4K2VZ8NeaQdIg+6vM2wbrPzF8Fie
   94wnGRIq9mUWlWlfhczw2lWTjELVbJmsch7sGnyUruQlUv8i47I8J9h8G
   wKG8M72CmMlRqqzIIAg8S76JP+uhsnq6WTjLoaq4RSOm0F9GRRFngksxl
   9xJaKZBStaNrR0kMy/0XB6o+Jnmy7aRGWC1CdWD8b153amWtBq/gJhUz7
   PmjmZuE8C6Bj6hNNEpN+oFS49TMti60OkbN415qcpFcEocWi2LS8Uq5rY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337102109"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="337102109"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:17:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="774198472"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="774198472"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jun 2023 10:17:21 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Michal Schmidt <mschmidt@redhat.com>,
	anthony.l.nguyen@intel.com,
	karol.kolacinski@intel.com,
	michal.michalik@intel.com,
	johan@kernel.org,
	Simon Horman <simon.horman@corigine.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net] ice: make writes to /dev/gnssX synchronous
Date: Tue,  6 Jun 2023 10:12:53 -0700
Message-Id: <20230606171253.2612334-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Schmidt <mschmidt@redhat.com>

The current ice driver's GNSS write implementation buffers writes and
works through them asynchronously in a kthread. That's bad because:
 - The GNSS write_raw operation is supposed to be synchronous[1][2].
 - There is no upper bound on the number of pending writes.
   Userspace can submit writes much faster than the driver can process,
   consuming unlimited amounts of kernel memory.

A patch that's currently on review[3] ("[v3,net] ice: Write all GNSS
buffers instead of first one") would add one more problem:
 - The possibility of waiting for a very long time to flush the write
   work when doing rmmod, softlockups.

To fix these issues, simplify the implementation: Drop the buffering,
the write_work, and make the writes synchronous.

I tested this with gpsd and ubxtool.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/12/The-GNSS-Subsystem-Johan-Hovold-Hovold-Consulting-AB.pdf
    "User interface" slide.
[2] A comment in drivers/gnss/core.c:gnss_write():
        /* Ignoring O_NONBLOCK, write_raw() is synchronous. */
[3] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230217120541.16745-1-karol.kolacinski@intel.com/

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_common.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c   | 64 ++-------------------
 drivers/net/ethernet/intel/ice/ice_gnss.h   | 10 ----
 4 files changed, 6 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 0157f6e98d3e..eb2dc0983776 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5160,7 +5160,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
  */
 int
 ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
-		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 u16 bus_addr, __le16 addr, u8 params, const u8 *data,
 		 struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc = { 0 };
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 8ba5f935a092..81961a7d6598 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -229,7 +229,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 		struct ice_sq_cd *cd);
 int
 ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
-		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 u16 bus_addr, __le16 addr, u8 params, const u8 *data,
 		 struct ice_sq_cd *cd);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 2ea8a2b11bcd..bd0ed155e11b 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -16,8 +16,8 @@
  * * number of bytes written - success
  * * negative - error code
  */
-static unsigned int
-ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
+static int
+ice_gnss_do_write(struct ice_pf *pf, const unsigned char *buf, unsigned int size)
 {
 	struct ice_aqc_link_topo_addr link_topo;
 	struct ice_hw *hw = &pf->hw;
@@ -72,39 +72,7 @@ ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
 	dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=%u, size=%u, err=%d\n",
 		offset, size, err);
 
-	return offset;
-}
-
-/**
- * ice_gnss_write_pending - Write all pending data to internal GNSS
- * @work: GNSS write work structure
- */
-static void ice_gnss_write_pending(struct kthread_work *work)
-{
-	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
-						write_work);
-	struct ice_pf *pf = gnss->back;
-
-	if (!pf)
-		return;
-
-	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
-		return;
-
-	if (!list_empty(&gnss->queue)) {
-		struct gnss_write_buf *write_buf = NULL;
-		unsigned int bytes;
-
-		write_buf = list_first_entry(&gnss->queue,
-					     struct gnss_write_buf, queue);
-
-		bytes = ice_gnss_do_write(pf, write_buf->buf, write_buf->size);
-		dev_dbg(ice_pf_to_dev(pf), "%u bytes written to GNSS\n", bytes);
-
-		list_del(&write_buf->queue);
-		kfree(write_buf->buf);
-		kfree(write_buf);
-	}
+	return err;
 }
 
 /**
@@ -220,8 +188,6 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 	pf->gnss_serial = gnss;
 
 	kthread_init_delayed_work(&gnss->read_work, ice_gnss_read);
-	INIT_LIST_HEAD(&gnss->queue);
-	kthread_init_work(&gnss->write_work, ice_gnss_write_pending);
 	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
 	if (IS_ERR(kworker)) {
 		kfree(gnss);
@@ -281,7 +247,6 @@ static void ice_gnss_close(struct gnss_device *gdev)
 	if (!gnss)
 		return;
 
-	kthread_cancel_work_sync(&gnss->write_work);
 	kthread_cancel_delayed_work_sync(&gnss->read_work);
 }
 
@@ -300,10 +265,7 @@ ice_gnss_write(struct gnss_device *gdev, const unsigned char *buf,
 	       size_t count)
 {
 	struct ice_pf *pf = gnss_get_drvdata(gdev);
-	struct gnss_write_buf *write_buf;
 	struct gnss_serial *gnss;
-	unsigned char *cmd_buf;
-	int err = count;
 
 	/* We cannot write a single byte using our I2C implementation. */
 	if (count <= 1 || count > ICE_GNSS_TTY_WRITE_BUF)
@@ -319,24 +281,7 @@ ice_gnss_write(struct gnss_device *gdev, const unsigned char *buf,
 	if (!gnss)
 		return -ENODEV;
 
-	cmd_buf = kcalloc(count, sizeof(*buf), GFP_KERNEL);
-	if (!cmd_buf)
-		return -ENOMEM;
-
-	memcpy(cmd_buf, buf, count);
-	write_buf = kzalloc(sizeof(*write_buf), GFP_KERNEL);
-	if (!write_buf) {
-		kfree(cmd_buf);
-		return -ENOMEM;
-	}
-
-	write_buf->buf = cmd_buf;
-	write_buf->size = count;
-	INIT_LIST_HEAD(&write_buf->queue);
-	list_add_tail(&write_buf->queue, &gnss->queue);
-	kthread_queue_work(gnss->kworker, &gnss->write_work);
-
-	return err;
+	return ice_gnss_do_write(pf, buf, count);
 }
 
 static const struct gnss_operations ice_gnss_ops = {
@@ -432,7 +377,6 @@ void ice_gnss_exit(struct ice_pf *pf)
 	if (pf->gnss_serial) {
 		struct gnss_serial *gnss = pf->gnss_serial;
 
-		kthread_cancel_work_sync(&gnss->write_work);
 		kthread_cancel_delayed_work_sync(&gnss->read_work);
 		kthread_destroy_worker(gnss->kworker);
 		gnss->kworker = NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index b8bb8b63d081..75e567ad7059 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -22,26 +22,16 @@
  */
 #define ICE_GNSS_UBX_WRITE_BYTES	(ICE_MAX_I2C_WRITE_BYTES + 1)
 
-struct gnss_write_buf {
-	struct list_head queue;
-	unsigned int size;
-	unsigned char *buf;
-};
-
 /**
  * struct gnss_serial - data used to initialize GNSS TTY port
  * @back: back pointer to PF
  * @kworker: kwork thread for handling periodic work
  * @read_work: read_work function for handling GNSS reads
- * @write_work: write_work function for handling GNSS writes
- * @queue: write buffers queue
  */
 struct gnss_serial {
 	struct ice_pf *back;
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work read_work;
-	struct kthread_work write_work;
-	struct list_head queue;
 };
 
 #if IS_ENABLED(CONFIG_GNSS)
-- 
2.38.1


