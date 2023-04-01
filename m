Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465566D32D1
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 19:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDAR2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 13:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjDAR2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 13:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001201A955
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 10:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680370041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUBHCMPgBRoA748LOlojQdHdk8ijt7iGpcycRyNToP4=;
        b=Lfme6Nxtv2+W4h/WlhprILqlr1FGir03XtYrKhPhloG4/lmUFy5gmJsviyEqQnAjyGgspd
        34VFngLDiz3H7etsOKzDDowyI6LEC3IH6zVIEmp8hv8DCH00yEupUDXYcyu2vQ73C8Zw2n
        yBkH3xc+0Y2romBB8E+2MtFIAVhrpsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-eKYzsFE4NGito0fAtGggOQ-1; Sat, 01 Apr 2023 13:27:19 -0400
X-MC-Unique: eKYzsFE4NGito0fAtGggOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 638EF101A531;
        Sat,  1 Apr 2023 17:27:19 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-6.brq.redhat.com [10.40.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8275240C83A9;
        Sat,  1 Apr 2023 17:27:17 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: [PATCH net-next 1/4] ice: lower CPU usage of the GNSS read thread
Date:   Sat,  1 Apr 2023 19:26:56 +0200
Message-Id: <20230401172659.38508-2-mschmidt@redhat.com>
In-Reply-To: <20230401172659.38508-1-mschmidt@redhat.com>
References: <20230401172659.38508-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.39.2

