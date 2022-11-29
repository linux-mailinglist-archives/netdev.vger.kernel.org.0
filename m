Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342C763C4E2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiK2QOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiK2QOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:14:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DBE65E53;
        Tue, 29 Nov 2022 08:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669738447; x=1701274447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Su0Cw3MyHqpzsKA0PnsNlmYF5H+VQ8b4Iwhnm0qJsZk=;
  b=gIN9xUrDMmHCizqKmGnS2LVjmiRZd6wlzFkvWYA/UE8zMUz+AF+PvHtU
   6ttR8G9v+r6FIgrFzkuBM7M4XsBfj5IsL3ca9bpr+edFMI5FIIvS95tg/
   Kke30HvrvzUHNBi2bjHGXKHVoKJXXASryKeonl1/YcD91nE7JJfyNmDyx
   7gXQWxGSr6WPu3Fp6yA31jNpbkbNpuohe5zV/komry1ciu7PnvwOTFjfm
   A3vzuqC3rV4ap8Vs9WR+YD+dwJA476yxagmdaUPgBomy9A57SwzgVyLB/
   bFCxtzwNcjJuCdpoVFlZEPysjyCZ9r8mYJUGNrgjuqWcsXCiQP3epAUz1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="302740399"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="302740399"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 08:13:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="768476669"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="768476669"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2022 08:13:36 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3868D179; Tue, 29 Nov 2022 18:14:03 +0200 (EET)
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
Subject: [resend, PATCH net-next v1 2/2] net: thunderbolt: Use separate header data type for the Rx
Date:   Tue, 29 Nov 2022 18:13:59 +0200
Message-Id: <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same data type structure is used for bitwise operations and
regular ones. It makes sparse unhappy, for example:

  .../thunderbolt.c:718:23: warning: cast to restricted __le32

  .../thunderbolt.c:953:23: warning: incorrect type in initializer (different base types)
  .../thunderbolt.c:953:23:    expected restricted __wsum [usertype] wsum
  .../thunderbolt.c:953:23:    got restricted __be32 [usertype]

Split the header to bitwise one and specific for Rx to make sparse
happy. Assure the layout by involving static_assert() against size
and offsets of the member of the structures.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/thunderbolt.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 4dbc6c7f2e10..f7b3d0d4646c 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -58,12 +58,32 @@
  * supported then @frame_id is filled, otherwise it stays %0.
  */
 struct thunderbolt_ip_frame_header {
+	__le32 frame_size;
+	__le16 frame_index;
+	__le16 frame_id;
+	__le32 frame_count;
+};
+
+/* Same as &struct thunderbolt_ip_frame_header for Rx */
+struct thunderbolt_ip_frame_rx_hdr {
 	u32 frame_size;
 	u16 frame_index;
 	u16 frame_id;
 	u32 frame_count;
 };
 
+static_assert(sizeof(struct thunderbolt_ip_frame_header) ==
+	      sizeof(struct thunderbolt_ip_frame_rx_hdr));
+
+#define TBIP_FRAME_HDR_MATCH(x)							 \
+	static_assert(offsetof(struct thunderbolt_ip_frame_header, frame_##x) == \
+		      offsetof(struct thunderbolt_ip_frame_rx_hdr, frame_##x))
+TBIP_FRAME_HDR_MATCH(size);
+TBIP_FRAME_HDR_MATCH(index);
+TBIP_FRAME_HDR_MATCH(id);
+TBIP_FRAME_HDR_MATCH(count);
+#undef TBIP_FRAME_HDR_MATCH
+
 enum thunderbolt_ip_frame_pdf {
 	TBIP_PDF_FRAME_START = 1,
 	TBIP_PDF_FRAME_END,
@@ -193,7 +213,7 @@ struct tbnet {
 	struct delayed_work login_work;
 	struct work_struct connected_work;
 	struct work_struct disconnect_work;
-	struct thunderbolt_ip_frame_header rx_hdr;
+	struct thunderbolt_ip_frame_rx_hdr rx_hdr;
 	struct tbnet_ring rx_ring;
 	atomic_t frame_id;
 	struct tbnet_ring tx_ring;
-- 
2.35.1

