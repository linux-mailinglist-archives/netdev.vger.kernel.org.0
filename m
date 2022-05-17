Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32852AD78
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiEQVWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiEQVWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:22:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E073EBB8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652822557; x=1684358557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oHeil+CFWyrCh/Db8fa2AZ7zOtVl8vzXToYvkEmjXz0=;
  b=OPl711HanaU/ZnjyA8qTTE9lHc35NBIlUnTCr7GzMoLD47XrGxYKFzci
   xGHVzLyY2A5e9vg9blkgp3lWB75jm+rAgJqIOJjxHnpytFi4fD5wo3PNR
   xyeI+VTF/Ngjm5MhfhE6AJH9oSnzfEnWUVnVDaQ//o+IsFk65mBbQcjD+
   V1cU73Qbpt1HHsSd5Ni1jw8rttEZL1SKdlfhWxTPZkiSiT6ElFKcK2kXu
   SfOChf4O/+oM90OcDwmR5MnlgIwia+VRASNp5TbjO5nf0Yrnz7QL2OyY7
   WX+tf77KSFz6aelW/uv9tg8JUKhAjS/9XLmn0CbqXXVL1JYPcnMcNDclf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357749579"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357749579"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 14:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="605546004"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2022 14:22:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/3] ice: remove u16 arithmetic in ice_gnss
Date:   Tue, 17 May 2022 14:19:33 -0700
Message-Id: <20220517211935.1949447-2-anthony.l.nguyen@intel.com>
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

Change u16 to unsigned int where arithmetic occurs.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 57586a2e6dec..c6d755f707aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -17,13 +17,13 @@ static void ice_gnss_read(struct kthread_work *work)
 	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
 						read_work.work);
 	struct ice_aqc_link_topo_addr link_topo;
-	u8 i2c_params, bytes_read;
+	unsigned int i, bytes_read, data_len;
 	struct tty_port *port;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	__be16 data_len_b;
 	char *buf = NULL;
-	u16 i, data_len;
+	u8 i2c_params;
 	int err = 0;
 
 	pf = gnss->back;
@@ -65,7 +65,7 @@ static void ice_gnss_read(struct kthread_work *work)
 		mdelay(10);
 	}
 
-	data_len = min(data_len, (u16)PAGE_SIZE);
+	data_len = min_t(typeof(data_len), data_len, PAGE_SIZE);
 	data_len = tty_buffer_request_room(port, data_len);
 	if (!data_len) {
 		err = -ENOMEM;
@@ -74,9 +74,10 @@ static void ice_gnss_read(struct kthread_work *work)
 
 	/* Read received data */
 	for (i = 0; i < data_len; i += bytes_read) {
-		u16 bytes_left = data_len - i;
+		unsigned int bytes_left = data_len - i;
 
-		bytes_read = min_t(typeof(bytes_left), bytes_left, ICE_MAX_I2C_DATA_SIZE);
+		bytes_read = min_t(typeof(bytes_left), bytes_left,
+				   ICE_MAX_I2C_DATA_SIZE);
 
 		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
 				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
-- 
2.35.1

