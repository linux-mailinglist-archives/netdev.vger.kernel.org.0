Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1E863D586
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiK3MYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiK3MYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:24:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15BF2B618;
        Wed, 30 Nov 2022 04:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811060; x=1701347060;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CHddWfflPs8kLESzYoIMrTNSP+L+KcSfpj3rQaLl8ps=;
  b=oITNyRvew8KVb3YH9fOF/4xqdDIXk6ASxtByefLx6WTkLg+JJjPat0ej
   A2mhTITR/vgVJ4o0dZ8xvc4y7iUy3IQPlIjNwJVDAHR98J/Rh9+iUCEBA
   VXi5+HjXsC87fV/sEC8phzduGl9UoCbx4l0d2ddV3Q8uQfApOp6YIaEj9
   MxC99YbQcfPAFer9YXEeht4lrqCv/wHWXSGsIHZTsRo0XKEAnvww9RFfb
   LKgdPAN+qjvacAlpolurOeshkBXGwYXj8jSFpm8pDrfd82Q8PfKGdVFx5
   iCd+xTspKty9c1i8deqn1B5T9kR4L4I2Fsb624xT7nyFTOIqUnHn87btM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="401662243"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="401662243"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:24:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="889272093"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="889272093"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2022 04:24:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C505710E; Wed, 30 Nov 2022 14:24:42 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v2 1/2] Revert "net: thunderbolt: Use separate header data type for the Rx"
Date:   Wed, 30 Nov 2022 14:24:38 +0200
Message-Id: <20221130122439.10822-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9ad63a3dad65b984ba16f5841163457dec266be4.
---
v2: added tag (Mika)
 drivers/net/thunderbolt.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 0fc2d9222a71..c73d419f1456 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -58,32 +58,12 @@
  * supported then @frame_id is filled, otherwise it stays %0.
  */
 struct thunderbolt_ip_frame_header {
-	__le32 frame_size;
-	__le16 frame_index;
-	__le16 frame_id;
-	__le32 frame_count;
-};
-
-/* Same as &struct thunderbolt_ip_frame_header for Rx */
-struct thunderbolt_ip_frame_rx_hdr {
 	u32 frame_size;
 	u16 frame_index;
 	u16 frame_id;
 	u32 frame_count;
 };
 
-static_assert(sizeof(struct thunderbolt_ip_frame_header) ==
-	      sizeof(struct thunderbolt_ip_frame_rx_hdr));
-
-#define TBIP_FRAME_HDR_MATCH(x)							 \
-	static_assert(offsetof(struct thunderbolt_ip_frame_header, frame_##x) == \
-		      offsetof(struct thunderbolt_ip_frame_rx_hdr, frame_##x))
-TBIP_FRAME_HDR_MATCH(size);
-TBIP_FRAME_HDR_MATCH(index);
-TBIP_FRAME_HDR_MATCH(id);
-TBIP_FRAME_HDR_MATCH(count);
-#undef TBIP_FRAME_HDR_MATCH
-
 enum thunderbolt_ip_frame_pdf {
 	TBIP_PDF_FRAME_START = 1,
 	TBIP_PDF_FRAME_END,
@@ -213,7 +193,7 @@ struct tbnet {
 	struct delayed_work login_work;
 	struct work_struct connected_work;
 	struct work_struct disconnect_work;
-	struct thunderbolt_ip_frame_rx_hdr rx_hdr;
+	struct thunderbolt_ip_frame_header rx_hdr;
 	struct tbnet_ring rx_ring;
 	atomic_t frame_id;
 	struct tbnet_ring tx_ring;
-- 
2.35.1

