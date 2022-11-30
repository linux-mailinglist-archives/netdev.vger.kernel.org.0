Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B612563D585
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiK3MYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiK3MYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:24:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8982BB2F;
        Wed, 30 Nov 2022 04:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811059; x=1701347059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f2Nj2e0faGv/S6d1FqA8MU+LXFErcONXYF0KNmZbZX4=;
  b=Xn3XWvB3ynKY8AgJw2oxMLARVkYyI6e/70eYgkN7horysSorQqh6aQq6
   6qsnXoR2aynjAGOwE7tat15lVHmbAbKo+KiNOiQlODOJkT7yT/pit29NO
   wdb+f48PyWnW17PRBrfC1fKP7Nuea9oitjHJwILX+0THbhCTuIrm3LwwN
   heVQ4qSEfsExrHBGu0JzEBWioKDPK+evPCumt3ygZYjIsstYqIFX/x/Wv
   d/uEsPuOw5gVl03hamwTpeyi41zH6kh7ToQv7Z9OOjjPiHoX2MCjlYblU
   n6LrW0Fb+YtuBJvmrWl7RDFpOj6GJBK2EnaLX1MdMoO6W7r8B42K0MF43
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="401662235"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="401662235"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:24:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="889272091"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="889272091"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2022 04:24:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D46B16A; Wed, 30 Nov 2022 14:24:42 +0200 (EET)
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
Subject: [PATCH net-next v2 2/2] net: thunderbolt: Use bitwise types in the struct thunderbolt_ip_frame_header
Date:   Wed, 30 Nov 2022 14:24:39 +0200
Message-Id: <20221130122439.10822-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130122439.10822-1-andriy.shevchenko@linux.intel.com>
References: <20221130122439.10822-1-andriy.shevchenko@linux.intel.com>
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

The main usage of the struct thunderbolt_ip_frame_header is to handle
the packets on the media layer. The header is bound to the protocol
in which the byte ordering is crucial. However the data type definition
doesn't use that and sparse is unhappy, for example (17 altogether):

  .../thunderbolt.c:718:23: warning: cast to restricted __le32

  .../thunderbolt.c:966:42: warning: incorrect type in assignment (different base types)
  .../thunderbolt.c:966:42:    expected unsigned int [usertype] frame_count
  .../thunderbolt.c:966:42:    got restricted __le32 [usertype]

Switch to the bitwise types in the struct thunderbolt_ip_frame_header to
reduce this, but not completely solving (9 left), because the same data
type is used for Rx header handled locally (in CPU byte order).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: changed only types without splitting the data type (Mika)
 drivers/net/thunderbolt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index c73d419f1456..4ed7f5b547e3 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -58,10 +58,10 @@
  * supported then @frame_id is filled, otherwise it stays %0.
  */
 struct thunderbolt_ip_frame_header {
-	u32 frame_size;
-	u16 frame_index;
-	u16 frame_id;
-	u32 frame_count;
+	__le32 frame_size;
+	__le16 frame_index;
+	__le16 frame_id;
+	__le32 frame_count;
 };
 
 enum thunderbolt_ip_frame_pdf {
-- 
2.35.1

