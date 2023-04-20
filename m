Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664C06EA049
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjDTXxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjDTXxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD5C659D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034802; x=1713570802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lp5cTubV/xUMGJaIfcWbk1xJdTFrPARNU1I+0cXukyA=;
  b=CYJh85fOqx7vRQxYFSgXZ6dmy+vJ4ZjlnlLfmK9UwaRdIMu6QOoG8g3p
   E7sxtvHprfqnAu0Hitje7pg4lATa7l6ExDaqdrcONEpcIwlVVaAYCwjW7
   wqB4id4w+/svzpt1SAi+SBvOJf2cGy2pUAjs+OaOcYK21ljz6NuP+0XTN
   qKlYAv+EO9ybO7NGQdu0EONDP5SDWnpb0P2Xn6eB5uHu5TTpAsb+q815v
   ls/8N9lkH/LQAS+5FC1nttMD9JUcO1tiyp5/yy4WhboxqPxD/esd25zgz
   2AcAJrAeGHYv2j6207/vSfWp4hXpm+im37LiXKk17M1WTh+VziXIdWt0E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368430"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368430"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714233"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714233"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 1/6] ice: do not busy-wait to read GNSS data
Date:   Thu, 20 Apr 2023 16:50:28 -0700
Message-Id: <20230420235033.2971567-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox
GNSS module, keep a CPU core almost 100% busy. The main reason is that
it busy-waits for data to become available.

A simple improvement would be to replace the "mdelay(10);" in
ice_gnss_read() with sleeping. A better fix is to not do any waiting
directly in the function and just requeue this delayed work as needed.
The advantage is that canceling the work from ice_gnss_exit() becomes
immediate, rather than taking up to ~2.5 seconds (ICE_MAX_UBX_READ_TRIES
* 10 ms).

This lowers the CPU usage of the ice-gnss-<dev_name> thread on my system
from ~90 % to ~8 %.

I am not sure if the larger 0.1 s pause after inserting data into the
gnss subsystem is really necessary, but I'm keeping that as it was.

Of course, ideally the driver would not have to poll at all, but I don't
know if the E810 can watch for GNSS data availability over the i2c bus
by itself and notify the driver.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 42 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_gnss.h |  3 +-
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 8dec748bb53a..2ea8a2b11bcd 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -117,6 +117,7 @@ static void ice_gnss_read(struct kthread_work *work)
 {
 	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
 						read_work.work);
+	unsigned long delay = ICE_GNSS_POLL_DATA_DELAY_TIME;
 	unsigned int i, bytes_read, data_len, count;
 	struct ice_aqc_link_topo_addr link_topo;
 	struct ice_pf *pf;
@@ -136,11 +137,6 @@ static void ice_gnss_read(struct kthread_work *work)
 		return;
 
 	hw = &pf->hw;
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
-	if (!buf) {
-		err = -ENOMEM;
-		goto exit;
-	}
 
 	memset(&link_topo, 0, sizeof(struct ice_aqc_link_topo_addr));
 	link_topo.topo_params.index = ICE_E810T_GNSS_I2C_BUS;
@@ -151,25 +147,24 @@ static void ice_gnss_read(struct kthread_work *work)
 	i2c_params = ICE_GNSS_UBX_DATA_LEN_WIDTH |
 		     ICE_AQC_I2C_USE_REPEATED_START;
 
-	/* Read data length in a loop, when it's not 0 the data is ready */
-	for (i = 0; i < ICE_MAX_UBX_READ_TRIES; i++) {
-		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
-				      cpu_to_le16(ICE_GNSS_UBX_DATA_LEN_H),
-				      i2c_params, (u8 *)&data_len_b, NULL);
-		if (err)
-			goto exit_buf;
+	err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+			      cpu_to_le16(ICE_GNSS_UBX_DATA_LEN_H),
+			      i2c_params, (u8 *)&data_len_b, NULL);
+	if (err)
+		goto requeue;
 
-		data_len = be16_to_cpu(data_len_b);
-		if (data_len != 0 && data_len != U16_MAX)
-			break;
+	data_len = be16_to_cpu(data_len_b);
+	if (data_len == 0 || data_len == U16_MAX)
+		goto requeue;
 
-		mdelay(10);
-	}
+	/* The u-blox has data_len bytes for us to read */
 
 	data_len = min_t(typeof(data_len), data_len, PAGE_SIZE);
-	if (!data_len) {
+
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf) {
 		err = -ENOMEM;
-		goto exit_buf;
+		goto requeue;
 	}
 
 	/* Read received data */
@@ -183,7 +178,7 @@ static void ice_gnss_read(struct kthread_work *work)
 				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
 				      bytes_read, &buf[i], NULL);
 		if (err)
-			goto exit_buf;
+			goto free_buf;
 	}
 
 	count = gnss_insert_raw(pf->gnss_dev, buf, i);
@@ -191,10 +186,11 @@ static void ice_gnss_read(struct kthread_work *work)
 		dev_warn(ice_pf_to_dev(pf),
 			 "gnss_insert_raw ret=%d size=%d\n",
 			 count, i);
-exit_buf:
+	delay = ICE_GNSS_TIMER_DELAY_TIME;
+free_buf:
 	free_page((unsigned long)buf);
-	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work,
-				   ICE_GNSS_TIMER_DELAY_TIME);
+requeue:
+	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
 exit:
 	if (err)
 		dev_dbg(ice_pf_to_dev(pf), "GNSS failed to read err=%d\n", err);
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index 4d49e5b0b4b8..640df7411373 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -5,6 +5,7 @@
 #define _ICE_GNSS_H_
 
 #define ICE_E810T_GNSS_I2C_BUS		0x2
+#define ICE_GNSS_POLL_DATA_DELAY_TIME	(HZ / 100) /* poll every 10 ms */
 #define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
 #define ICE_GNSS_TTY_WRITE_BUF		250
 #define ICE_MAX_I2C_DATA_SIZE		FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
@@ -20,8 +21,6 @@
  * passed as I2C addr parameter.
  */
 #define ICE_GNSS_UBX_WRITE_BYTES	(ICE_MAX_I2C_WRITE_BYTES + 1)
-#define ICE_MAX_UBX_READ_TRIES		255
-#define ICE_MAX_UBX_ACK_READ_TRIES	4095
 
 struct gnss_write_buf {
 	struct list_head queue;
-- 
2.38.1

